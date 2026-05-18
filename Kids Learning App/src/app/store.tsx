import React, { createContext, useContext, useReducer, useEffect, ReactNode } from "react";
import type { SubjectId } from "./data";
import { ALL_BADGES, SUBJECTS } from "./data";

export interface UserState {
  name: string;
  isLoggedIn: boolean;
  level: number;
  xp: number;
  xpToNext: number;
  streak: number;
  coins: number;
  totalStars: number;
  quizzesCompleted: number;
  perfectQuizzes: number;
  lessonsCompleted: number;
  challengesCompleted: number;
  subjectsTried: SubjectId[];
  avatarBase: string;
  avatarHat: string;
  avatarOutfit: string;
  ownedItems: string[];
  completedLessons: string[];
  offlineMode: boolean;
  challengeCompletedToday: boolean;
}

const DEFAULTS: UserState = {
  name: "",
  isLoggedIn: false,
  level: 3,
  xp: 850,
  xpToNext: 1000,
  streak: 5,
  coins: 230,
  totalStars: 47,
  quizzesCompleted: 4,
  perfectQuizzes: 1,
  lessonsCompleted: 7,
  challengesCompleted: 2,
  subjectsTried: ["math", "reading", "science"],
  avatarBase: "fox",
  avatarHat: "hat-none",
  avatarOutfit: "outfit-default",
  ownedItems: ["fox", "hat-none", "outfit-default"],
  completedLessons: ["math-0", "math-1", "reading-0", "science-0"],
  offlineMode: false,
  challengeCompletedToday: false,
};

const STORAGE_KEY = "kids_learning_app_state";

function loadState(): UserState {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) return { ...DEFAULTS, ...JSON.parse(raw) };
  } catch {
    // ignore corrupt storage
  }
  return DEFAULTS;
}

function saveState(state: UserState): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch {
    // ignore storage errors (e.g. private browsing quota)
  }
}

const INITIAL = loadState();

type Action =
  | { type: "SET_NAME"; name: string }
  | { type: "COMPLETE_LESSON"; subjectId: SubjectId; lessonIdx: number }
  | { type: "COMPLETE_QUIZ"; subjectId: SubjectId; score: number; total: number }
  | { type: "COMPLETE_CHALLENGE" }
  | { type: "BUY_ITEM"; itemId: string; cost: number }
  | { type: "EQUIP_ITEM"; category: "avatar" | "hat" | "outfit"; itemId: string }
  | { type: "TOGGLE_OFFLINE" };

function applyXP(state: UserState, amount: number): UserState {
  let xp = state.xp + amount;
  let level = state.level;
  let xpToNext = state.xpToNext;
  while (xp >= xpToNext) {
    xp -= xpToNext;
    level += 1;
    xpToNext = level * 1000;
  }
  return { ...state, xp, level, xpToNext };
}

function reducer(state: UserState, action: Action): UserState {
  switch (action.type) {
    case "SET_NAME":
      return { ...state, name: action.name, isLoggedIn: true };
    case "COMPLETE_LESSON": {
      const key = `${action.subjectId}-${action.lessonIdx}`;
      if (state.completedLessons.includes(key)) return state;
      const lesson = SUBJECTS[action.subjectId].lessons[action.lessonIdx];
      const tried = state.subjectsTried.includes(action.subjectId)
        ? state.subjectsTried
        : [...state.subjectsTried, action.subjectId];
      let next = applyXP(state, lesson.xp);
      return {
        ...next,
        coins: next.coins + lesson.coins,
        lessonsCompleted: next.lessonsCompleted + 1,
        subjectsTried: tried as SubjectId[],
        completedLessons: [...next.completedLessons, key],
      };
    }
    case "COMPLETE_QUIZ": {
      const xpEarned = action.score * 40;
      const coinsEarned = action.score * 15;
      const starsEarned = action.score;
      let next = applyXP(state, xpEarned);
      return {
        ...next,
        coins: next.coins + coinsEarned,
        totalStars: next.totalStars + starsEarned,
        quizzesCompleted: next.quizzesCompleted + 1,
        perfectQuizzes: action.score === action.total ? next.perfectQuizzes + 1 : next.perfectQuizzes,
      };
    }
    case "COMPLETE_CHALLENGE": {
      let next = applyXP(state, 100);
      return {
        ...next,
        coins: next.coins + 50,
        challengesCompleted: next.challengesCompleted + 1,
        challengeCompletedToday: true,
      };
    }
    case "BUY_ITEM": {
      if (state.coins < action.cost || state.ownedItems.includes(action.itemId)) return state;
      return {
        ...state,
        coins: state.coins - action.cost,
        ownedItems: [...state.ownedItems, action.itemId],
      };
    }
    case "EQUIP_ITEM": {
      if (action.category === "avatar") return { ...state, avatarBase: action.itemId };
      if (action.category === "hat") return { ...state, avatarHat: action.itemId };
      return { ...state, avatarOutfit: action.itemId };
    }
    case "TOGGLE_OFFLINE":
      return { ...state, offlineMode: !state.offlineMode };
    default:
      return state;
  }
}

export function getEarnedBadgeIds(u: UserState): string[] {
  return ALL_BADGES.filter((b) =>
    b.check({
      level: u.level,
      quizzesCompleted: u.quizzesCompleted,
      perfectQuizzes: u.perfectQuizzes,
      streak: u.streak,
      lessonsCompleted: u.lessonsCompleted,
      challengesCompleted: u.challengesCompleted,
      coins: u.coins,
      subjectsTried: u.subjectsTried,
    })
  ).map((b) => b.id);
}

interface Ctx {
  user: UserState;
  dispatch: React.Dispatch<Action>;
}

const StoreCtx = createContext<Ctx | null>(null);

export function StoreProvider({ children }: { children: ReactNode }) {
  const [user, dispatch] = useReducer(reducer, INITIAL);

  useEffect(() => {
    saveState(user);
  }, [user]);

  return <StoreCtx.Provider value={{ user, dispatch }}>{children}</StoreCtx.Provider>;
}

export function useStore() {
  const ctx = useContext(StoreCtx);
  if (!ctx) throw new Error("useStore must be inside StoreProvider");
  return ctx;
}
