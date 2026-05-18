import { useNavigate, useLocation } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, Star } from "lucide-react";
import { ALL_BADGES, SUBJECTS } from "../data";
import type { SubjectId } from "../data";
import { useStore, getEarnedBadgeIds } from "../store";

interface QuizState {
  fromQuiz?: boolean;
  score?: number;
  total?: number;
  xpEarned?: number;
  coinsEarned?: number;
  subjectId?: string;
  oldBadges?: string[];
}

export default function Rewards() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useStore();
  const state = (location.state ?? {}) as QuizState;
  const earnedIds = getEarnedBadgeIds(user);
  const newBadgeIds = state.oldBadges ? earnedIds.filter((id) => !state.oldBadges!.includes(id)) : [];

  const xpPct = Math.round((user.xp / user.xpToNext) * 100);
  const subject = state.subjectId ? SUBJECTS[state.subjectId as SubjectId] : null;

  return (
    <div className="min-h-screen" style={{ background: "radial-gradient(ellipse at 30% 20%, #2D0D52 0%, #1A1A2E 50%, #0D0D1A 100%)" }}>
      {/* Stars background */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        {[...Array(30)].map((_, i) => (
          <motion.div
            key={i}
            animate={{ opacity: [0.2, 0.8, 0.2] }}
            transition={{ duration: 2 + (i % 4), repeat: Infinity, delay: (i * 0.3) % 3 }}
            className="absolute rounded-full bg-white"
            style={{ width: `${1 + (i % 3)}px`, height: `${1 + (i % 3)}px`, left: `${(i * 37 + 7) % 95}%`, top: `${(i * 53 + 13) % 90}%` }}
          />
        ))}
      </div>

      <div dir="rtl" className="relative px-4 py-6">
        <div className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center hover:bg-white/20 transition-colors">
            <ArrowRight className="w-4 h-4 text-white" />
          </button>
          <h1 className="text-2xl font-black text-white">شاراتك</h1>
          <div className="mr-auto flex items-center gap-1.5 bg-[#FFD60A]/20 rounded-xl px-3 py-1.5 border border-[#FFD60A]/30">
            <Star className="w-4 h-4 text-[#FFD60A] fill-[#FFD60A]" />
            <span className="text-sm font-black text-[#FFD60A]">{user.totalStars}</span>
          </div>
        </div>

        {/* Just earned banner */}
        {state.fromQuiz && (
          <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="mb-6 rounded-[1.5rem] overflow-hidden border-2 border-[#FFD60A]/40 bg-white/10 backdrop-blur-sm">
            <div className="px-5 py-4 border-b border-white/10">
              <p className="text-xs font-black uppercase tracking-widest text-[#FFD60A]">حصلت للتوّ</p>
              <h2 className="text-lg font-black text-white mt-1">
                {state.score === state.total ? "🏆 نتيجة مثالية!" : state.score! >= Math.ceil(state.total! / 2) ? "⭐ عمل رائع!" : "💪 واصل التدريب!"}
              </h2>
            </div>
            <div className="flex divide-x divide-white/10">
              <div className="flex-1 p-4 text-center">
                <div className="text-2xl font-black text-white">{state.score}/{state.total}</div>
                <div className="text-[10px] font-black text-white/50 uppercase">نتيجة</div>
              </div>
              <div className="flex-1 p-4 text-center">
                <div className="text-2xl font-black text-[#FFD60A]">+{state.xpEarned}</div>
                <div className="text-[10px] font-black text-white/50 uppercase">نقاط</div>
              </div>
              <div className="flex-1 p-4 text-center">
                <div className="text-2xl font-black text-[#FFD60A]">+{state.coinsEarned}</div>
                <div className="text-[10px] font-black text-white/50 uppercase">عملة 🪙</div>
              </div>
            </div>
            <div className="flex justify-center gap-2 pb-4 pt-2">
              {Array.from({ length: state.total ?? 3 }).map((_, i) => (
                <motion.div key={i} initial={{ scale: 0, rotate: -20 }} animate={{ scale: 1, rotate: 0 }} transition={{ delay: 0.3 + i * 0.15, type: "spring", stiffness: 200 }}>
                  <Star className={`w-9 h-9 ${i < (state.score ?? 0) ? "text-[#FFD60A] fill-[#FFD60A]" : "text-white/20 fill-white/20"}`} />
                </motion.div>
              ))}
            </div>
            {newBadgeIds.length > 0 && (
              <div className="px-4 pb-4">
                <p className="text-xs font-black text-[#C77DFF] mb-2 uppercase tracking-wide">شارات جديدة تم فتحها!</p>
                <div className="flex gap-2 flex-wrap">
                  {newBadgeIds.map((id) => {
                    const badge = ALL_BADGES.find((b) => b.id === id);
                    return badge ? (
                      <motion.div key={id} initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: "spring" }} className="bg-[#C77DFF]/20 border border-[#C77DFF]/40 rounded-xl px-3 py-2 flex items-center gap-2">
                        <span className="text-xl">{badge.emoji}</span>
                        <span className="text-xs font-black text-white">{badge.name}</span>
                      </motion.div>
                    ) : null;
                  })}
                </div>
              </div>
            )}
          </motion.div>
        )}

        {/* XP Level bar */}
        <div className="bg-white/10 border border-white/20 rounded-2xl p-4 mb-6 backdrop-blur-sm">
          <div className="flex justify-between mb-2">
            <span className="text-sm font-black text-white">المستوى {user.level}</span>
            <span className="text-sm font-black text-[#FFD60A]">{user.xp}/{user.xpToNext} نقطة</span>
          </div>
          <div className="h-3 bg-white/10 rounded-full overflow-hidden">
            <motion.div initial={{ width: 0 }} animate={{ width: `${xpPct}%` }} transition={{ delay: 0.3, duration: 0.8 }} className="h-full rounded-full bg-gradient-to-r from-[#C77DFF] to-[#FFD60A]" />
          </div>
          <div className="flex justify-between mt-2">
            <span className="text-xs font-bold text-white/50">{user.coins} 🪙 عملة</span>
            <span className="text-xs font-bold text-white/50">{user.streak} 🔥 يوم متتالي</span>
          </div>
        </div>

        {/* Badge grid */}
        <h2 className="text-lg font-black text-white mb-4">جميع الشارات ({earnedIds.length}/{ALL_BADGES.length})</h2>
        <div className="grid grid-cols-2 gap-3">
          {ALL_BADGES.map((badge, i) => {
            const earned = earnedIds.includes(badge.id);
            const isNew = newBadgeIds.includes(badge.id);
            return (
              <motion.div
                key={badge.id}
                initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: i * 0.04 }}
                className={`relative rounded-2xl p-4 border-2 text-left transition-all ${earned ? "border-[#FFD60A]/40 bg-white/10" : "border-white/10 bg-white/5"} ${!earned ? "opacity-50" : ""}`}
                style={earned ? { boxShadow: `0 0 20px ${isNew ? "#C77DFF" : "#FFD60A"}30` } : {}}
              >
                {isNew && <div className="absolute -top-1.5 -right-1.5 bg-[#C77DFF] text-white text-[9px] font-black rounded-full px-1.5 py-0.5">جديد</div>}
                <div className={`text-4xl mb-2 select-none ${!earned ? "grayscale" : ""}`}>{badge.emoji}</div>
                <p className="font-black text-sm text-white leading-tight">{badge.name}</p>
                <p className="text-xs font-bold text-white/50 mt-0.5">{badge.desc}</p>
                {earned && <div className="mt-2 w-2 h-2 rounded-full bg-[#FFD60A]" />}
              </motion.div>
            );
          })}
        </div>

        {state.fromQuiz && (
          <div className="mt-6 space-y-3">
            {subject && (
              <button onClick={() => navigate(`/quiz/${state.subjectId}`)} className="w-full rounded-2xl py-4 font-black text-lg shadow-lg transition-all hover:brightness-110" style={{ backgroundColor: subject.color, color: state.subjectId === "math" ? "#1A1A2E" : "#FFFFFF" }}>
                العب مجدداً 🔄
              </button>
            )}
            <button onClick={() => navigate("/")} className="w-full rounded-2xl py-4 font-black text-white text-lg border-2 border-white/20 bg-white/10 hover:bg-white/20 transition-colors">
              العودة للرئيسية
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
