import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const EMOJI_POOL = ["🐱", "🐶", "🐻", "🦊", "🐼", "🦁", "🐸", "🐵", "🦄", "🐷", "🐮", "🐔", "🦋", "🐝", "🌸"];

interface Card {
  id: number;
  emoji: string;
  flipped: boolean;
  matched: boolean;
}

function buildCards(pairCount: number): Card[] {
  const emojis = [...EMOJI_POOL].sort(() => Math.random() - 0.5).slice(0, pairCount);
  const cards = [...emojis, ...emojis]
    .sort(() => Math.random() - 0.5)
    .map((emoji, i) => ({ id: i, emoji, flipped: false, matched: false }));
  return cards;
}

export default function MemoryGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [level, setLevel] = useState(1);
  const [cards, setCards] = useState<Card[]>(buildCards(4));
  const [first, setFirst] = useState<number | null>(null);
  const [moves, setMoves] = useState(0);
  const [isChecking, setIsChecking] = useState(false);
  const [done, setDone] = useState(false);
  const [wins, setWins] = useState(0);

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  useEffect(() => { speak("ابحث عن الأزواج المتشابهة!"); }, [level]);

  function startLevel(l: number) {
    const pairs = l === 1 ? 4 : l === 2 ? 6 : 8;
    setCards(buildCards(pairs));
    setFirst(null);
    setMoves(0);
    setIsChecking(false);
  }

  function flip(cardId: number) {
    if (isChecking) return;
    const card = cards.find((c) => c.id === cardId);
    if (!card || card.flipped || card.matched) return;

    const updated = cards.map((c) => c.id === cardId ? { ...c, flipped: true } : c);
    setCards(updated);

    if (first === null) {
      setFirst(cardId);
    } else {
      setMoves((m) => m + 1);
      setIsChecking(true);
      const firstCard = updated.find((c) => c.id === first)!;
      const secondCard = updated.find((c) => c.id === cardId)!;

      if (firstCard.emoji === secondCard.emoji) {
        const matched = updated.map((c) =>
          c.id === first || c.id === cardId ? { ...c, matched: true } : c
        );
        setCards(matched);
        setFirst(null);
        setIsChecking(false);
        speak("أحسنت! وجدت زوجاً!");

        if (matched.every((c) => c.matched)) {
          if (level < 3) {
            setTimeout(() => { setLevel((l) => { startLevel(l + 1); return l + 1; }); }, 1200);
            speak("رائع! انتقلت للمستوى التالي!");
          } else {
            setDone(true);
            setWins((w) => w + 1);
            dispatch({ type: "COMPLETE_QUIZ", subjectId: "reading", score: 3, total: 3 });
            speak("مبروك! أكملت اللعبة!");
          }
        }
      } else {
        setTimeout(() => {
          setCards(updated.map((c) =>
            c.id === first || c.id === cardId ? { ...c, flipped: false } : c
          ));
          setFirst(null);
          setIsChecking(false);
        }, 900);
      }
    }
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F3E5F5] to-[#E1BEE7] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">🧠</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">ذاكرة ممتازة يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">أكملت جميع المستويات الثلاثة!</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setLevel(1); setDone(false); startLevel(1); }} className="bg-[#A855F7] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  const cols = level === 1 ? 4 : level === 2 ? 4 : 4;

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F3E5F5] to-[#EDE7F6] pb-8">
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">لعبة الذاكرة 🧠</h1>
        <div className="bg-[#A855F7] rounded-full px-3 py-1 font-black text-sm text-white">المستوى {level}</div>
      </div>

      <div className="flex justify-center gap-6 mt-4 mb-2">
        <div className="text-center"><p className="text-xs font-bold text-[#1A1A2E]/50">المحاولات</p><p className="text-2xl font-black text-[#A855F7]">{moves}</p></div>
        <div className="text-center"><p className="text-xs font-bold text-[#1A1A2E]/50">الأزواج</p><p className="text-2xl font-black text-[#06D6A0]">{cards.filter((c) => c.matched).length / 2}/{cards.length / 2}</p></div>
      </div>

      <div className={`grid gap-3 px-5 mt-4`} style={{ gridTemplateColumns: `repeat(${cols}, 1fr)` }}>
        {cards.map((card) => (
          <motion.button
            key={card.id}
            whileTap={{ scale: 0.9 }}
            onClick={() => flip(card.id)}
            className="aspect-square rounded-2xl flex items-center justify-center text-3xl shadow-md overflow-hidden"
            style={{ minHeight: 70 }}
          >
            <AnimatePresence mode="wait">
              {card.flipped || card.matched ? (
                <motion.span
                  key="front"
                  initial={{ rotateY: 90 }}
                  animate={{ rotateY: 0 }}
                  exit={{ rotateY: 90 }}
                  className={`text-4xl ${card.matched ? "opacity-60" : ""}`}
                  style={{ display: "block", width: "100%", textAlign: "center", background: card.matched ? "#E8F5E9" : "white", padding: "12px", borderRadius: 16 }}
                >
                  {card.emoji}
                </motion.span>
              ) : (
                <motion.span
                  key="back"
                  initial={{ rotateY: 90 }}
                  animate={{ rotateY: 0 }}
                  exit={{ rotateY: 90 }}
                  style={{ display: "block", width: "100%", textAlign: "center", background: "linear-gradient(135deg,#A855F7,#C77DFF)", padding: "12px", borderRadius: 16, fontSize: 32 }}
                >
                  ❓
                </motion.span>
              )}
            </AnimatePresence>
          </motion.button>
        ))}
      </div>
    </div>
  );
}
