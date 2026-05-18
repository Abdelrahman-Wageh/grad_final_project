import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, Lock, Star } from "lucide-react";
import { ISLANDS, SUBJECTS } from "../data";
import type { SubjectId } from "../data";
import { useStore } from "../store";

const PATH_SEGMENTS = [
  "M 50 80 C 33 71, 25 71, 20 62",
  "M 20 62 C 44 53, 52 52, 68 44",
  "M 68 44 C 50 36, 40 35, 28 26",
  "M 28 26 C 42 18, 48 15, 58 10",
];

export default function LearningMap() {
  const navigate = useNavigate();
  const { user } = useStore();

  function isUnlocked(minLevel: number) {
    return user.level >= minLevel;
  }

  function completionPct(subject: SubjectId | null) {
    if (!subject) return 0;
    const s = SUBJECTS[subject];
    const done = s.lessons.filter((_, i) => user.completedLessons.includes(`${subject}-${i}`)).length;
    return Math.round((done / s.lessons.length) * 100);
  }

  return (
    <div className="min-h-screen flex flex-col" style={{ background: "linear-gradient(180deg, #040E24 0%, #071831 40%, #0A2040 100%)" }}>
      {/* Stars */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        {[...Array(40)].map((_, i) => (
          <motion.div
            key={i}
            animate={{ opacity: [0.1, 0.7, 0.1] }}
            transition={{ duration: 2 + (i % 5), repeat: Infinity, delay: (i * 0.2) % 4 }}
            className="absolute rounded-full bg-white"
            style={{ width: `${1 + (i % 2)}px`, height: `${1 + (i % 2)}px`, left: `${(i * 41 + 5) % 95}%`, top: `${(i * 57 + 9) % 88}%` }}
          />
        ))}
      </div>

      {/* Wave bottom decoration */}
      <div className="fixed bottom-16 left-0 right-0 h-32 pointer-events-none opacity-20" style={{ background: "linear-gradient(0deg, #4CC9F0 0%, transparent 100%)" }} />

      <div className="relative px-4 pt-6 pb-4">
        <div dir="rtl" className="flex items-center gap-3 mb-4">
          <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center hover:bg-white/20">
            <ArrowRight className="w-4 h-4 text-white" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-white">خريطة التعلّم</h1>
            <p className="text-sm font-bold text-white/50">مستكشف المستوى {user.level}</p>
          </div>
          <div className="mr-auto flex items-center gap-1.5 bg-[#FFD60A]/20 border border-[#FFD60A]/30 rounded-xl px-3 py-1.5">
            <Star className="w-4 h-4 text-[#FFD60A] fill-[#FFD60A]" />
            <span className="text-sm font-black text-[#FFD60A]">{user.totalStars}</span>
          </div>
        </div>
      </div>

      {/* Map */}
      <div className="relative flex-1 mx-4 mb-4" style={{ minHeight: "480px" }}>
        {/* SVG Paths */}
        <svg className="absolute inset-0 w-full h-full" viewBox="0 0 100 100" preserveAspectRatio="none">
          <defs>
            <filter id="glow">
              <feGaussianBlur stdDeviation="0.5" result="coloredBlur" />
              <feMerge><feMergeNode in="coloredBlur" /><feMergeNode in="SourceGraphic" /></feMerge>
            </filter>
          </defs>
          {PATH_SEGMENTS.map((d, i) => {
            const toIsland = ISLANDS[i + 1];
            const unlocked = isUnlocked(toIsland.minLevel);
            return (
              <path
                key={i}
                d={d}
                fill="none"
                stroke={unlocked ? ISLANDS[i].color : "#334155"}
                strokeWidth="1.2"
                strokeDasharray="3,2"
                opacity={unlocked ? 0.7 : 0.3}
                filter={unlocked ? "url(#glow)" : undefined}
              />
            );
          })}
        </svg>

        {/* Island nodes */}
        {ISLANDS.map((island, i) => {
          const unlocked = isUnlocked(island.minLevel);
          const pct = island.subject ? completionPct(island.subject) : 0;
          const isCurrent = unlocked && (i === 0 || !isUnlocked(ISLANDS[Math.min(i + 1, ISLANDS.length - 1)].minLevel));

          return (
            <motion.div
              key={island.id}
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ delay: i * 0.12, type: "spring", stiffness: 200 }}
              className="absolute"
              style={{ left: `${island.x}%`, top: `${island.y}%`, transform: "translate(-50%, -50%)" }}
            >
              <motion.button
                animate={isCurrent ? { scale: [1, 1.05, 1] } : {}}
                transition={{ duration: 2, repeat: Infinity }}
                whileHover={unlocked ? { scale: 1.1 } : {}}
                whileTap={unlocked ? { scale: 0.95 } : {}}
                onClick={() => unlocked && island.subject && navigate(`/categories/${island.subject}`)}
                disabled={!unlocked}
                className="relative flex flex-col items-center"
              >
                {/* Glow ring for current */}
                {isCurrent && (
                  <motion.div
                    animate={{ scale: [1, 1.3, 1], opacity: [0.5, 0, 0.5] }}
                    transition={{ duration: 2, repeat: Infinity }}
                    className="absolute inset-0 rounded-full"
                    style={{ backgroundColor: island.color, filter: "blur(8px)" }}
                  />
                )}

                {/* Island circle */}
                <div
                  className={`relative w-16 h-16 rounded-full border-[3px] flex items-center justify-center text-2xl shadow-xl select-none ${!unlocked ? "grayscale opacity-50" : ""}`}
                  style={{ backgroundColor: unlocked ? island.color + "30" : "#1E293B", borderColor: unlocked ? island.color : "#334155" }}
                >
                  {unlocked ? island.emoji : <Lock className="w-5 h-5 text-slate-400" />}

                  {/* Stars */}
                  {unlocked && pct === 100 && (
                    <div className="absolute -top-1.5 -right-1.5 bg-[#FFD60A] rounded-full w-5 h-5 flex items-center justify-center">
                      <Star className="w-3 h-3 fill-[#1A1A2E] text-[#1A1A2E]" />
                    </div>
                  )}
                </div>

                {/* Label */}
                <div className={`mt-2 text-center ${!unlocked ? "opacity-40" : ""}`}>
                  <p className="text-[10px] font-black text-white leading-tight whitespace-nowrap">{island.name}</p>
                  <p className="text-[9px] font-bold text-white/50 whitespace-nowrap">{island.theme}</p>
                  {unlocked && island.subject && (
                    <div className="mt-1 bg-white/10 rounded-full h-1.5 w-14 overflow-hidden">
                      <div className="h-full rounded-full" style={{ width: `${pct}%`, backgroundColor: island.color }} />
                    </div>
                  )}
                  {!unlocked && <p className="text-[9px] font-black text-slate-500">مستوى {island.minLevel}</p>}
                </div>
              </motion.button>
            </motion.div>
          );
        })}
      </div>

      {/* Legend */}
      <div className="mx-4 mb-4 bg-white/5 border border-white/10 rounded-2xl p-4">
        <p className="text-xs font-black text-white/50 uppercase tracking-wide mb-3">جزرك</p>
        <div className="flex gap-2 flex-wrap">
          {ISLANDS.filter((i) => isUnlocked(i.minLevel)).map((island) => (
            <div key={island.id} className="flex items-center gap-1.5 bg-white/10 rounded-xl px-2.5 py-1.5">
              <span className="text-sm">{island.emoji}</span>
              <span className="text-[10px] font-black text-white">{island.name}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
