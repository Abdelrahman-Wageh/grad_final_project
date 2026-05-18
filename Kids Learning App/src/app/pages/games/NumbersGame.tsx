import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const NUMBERS = [
  { num: 1, ar: "واحد", emoji: "1️⃣" },
  { num: 2, ar: "اثنان", emoji: "2️⃣" },
  { num: 3, ar: "ثلاثة", emoji: "3️⃣" },
  { num: 4, ar: "أربعة", emoji: "4️⃣" },
  { num: 5, ar: "خمسة", emoji: "5️⃣" },
  { num: 6, ar: "ستة", emoji: "6️⃣" },
  { num: 7, ar: "سبعة", emoji: "7️⃣" },
  { num: 8, ar: "ثمانية", emoji: "8️⃣" },
  { num: 9, ar: "تسعة", emoji: "9️⃣" },
  { num: 10, ar: "عشرة", emoji: "🔟" },
];

const EMOJIS = ["⭐", "🍎", "🌸", "🎈", "🦋", "🍕", "🚗", "🌻"];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

type Mode = "learn" | "count" | "match";

export default function NumbersGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [mode, setMode] = useState<Mode>("learn");
  const [learnIdx, setLearnIdx] = useState(0);
  const [score, setScore] = useState(0);
  const [round, setRound] = useState(0);
  const [done, setDone] = useState(false);
  const [emoji] = useState(EMOJIS[Math.floor(Math.random() * EMOJIS.length)]);

  // count mode
  const [countTarget, setCountTarget] = useState(3);
  const [countChoices, setCountChoices] = useState<number[]>([]);
  const [countSelected, setCountSelected] = useState<number | null>(null);

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  function nextCountRound(r: number) {
    const n = (r % 10) + 1;
    setCountTarget(n);
    setCountSelected(null);
    const wrong = shuffle([...Array(10)].map((_, i) => i + 1).filter((x) => x !== n)).slice(0, 3);
    setCountChoices(shuffle([n, ...wrong]));
    speak(`كم عدد ${emoji}؟`);
  }

  useEffect(() => {
    if (mode === "count") nextCountRound(0);
  }, [mode]);

  function handleCount(n: number) {
    if (countSelected !== null) return;
    setCountSelected(n);
    if (n === countTarget) {
      setScore((s) => s + 1);
      speak("صحيح! أحسنت!");
    } else {
      speak(`العدد الصحيح هو ${NUMBERS[countTarget - 1].ar}`);
    }
    setTimeout(() => {
      if (round + 1 >= 10) {
        setDone(true);
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "math", score, total: 10 });
      } else {
        setRound((r) => { nextCountRound(r + 1); return r + 1; });
      }
    }, 1400);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E0F7FA] to-[#B2EBF2] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">🔢</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">بارك الله فيك يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">حصلت على {score} من 10 نقاط</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setMode("learn"); setRound(0); setScore(0); setDone(false); }} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#06D6A0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E8F4FD] to-[#D1ECF1] pb-8">
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">تعلّم الأرقام 🔢</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}</div>
      </div>

      {/* Mode selector */}
      {mode === "learn" && (
        <div className="px-5 mt-6">
          <p className="text-center text-[#1A1A2E]/60 font-bold mb-4">تعلّم الأرقام أولاً، ثم العب!</p>
          <div className="flex gap-3 justify-center mb-6">
            {NUMBERS.map((n, i) => (
              <motion.button
                key={n.num}
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => { setLearnIdx(i); speak(`${n.num} — ${n.ar}`); }}
                className={`w-10 h-10 rounded-xl font-black text-lg ${learnIdx === i ? "bg-[#4CC9F0] text-white" : "bg-white text-[#1A1A2E]"} shadow`}
              >
                {n.num}
              </motion.button>
            ))}
          </div>

          <AnimatePresence mode="wait">
            <motion.div
              key={learnIdx}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              className="flex flex-col items-center"
            >
              <div className="text-9xl mb-2">{NUMBERS[learnIdx].emoji}</div>
              <div className="text-7xl font-black text-[#4CC9F0] mb-2">{NUMBERS[learnIdx].num}</div>
              <div className="text-3xl font-black text-[#1A1A2E] mb-6">{NUMBERS[learnIdx].ar}</div>

              <div className="flex flex-wrap gap-2 justify-center mb-8">
                {Array.from({ length: NUMBERS[learnIdx].num }).map((_, i) => (
                  <motion.span key={i} initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: i * 0.08 }} className="text-3xl">⭐</motion.span>
                ))}
              </div>

              <button onClick={() => speak(`${NUMBERS[learnIdx].num} — ${NUMBERS[learnIdx].ar}`)} className="bg-white/80 rounded-2xl px-5 py-2 font-bold text-sm text-[#1A1A2E]/70 shadow mb-8">
                🔊 استمع
              </button>
            </motion.div>
          </AnimatePresence>

          <button onClick={() => setMode("count")} className="w-full bg-[#4CC9F0] text-white font-black text-xl rounded-2xl py-4 shadow-lg">
            ابدأ اللعبة! ▶
          </button>
        </div>
      )}

      {mode === "count" && (
        <div className="px-5 mt-6">
          <div className="bg-white/60 rounded-full h-3 mb-1">
            <motion.div className="bg-[#4CC9F0] h-3 rounded-full" animate={{ width: `${(round / 10) * 100}%` }} />
          </div>
          <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mb-6">جولة {round + 1} من 10</p>

          <AnimatePresence mode="wait">
            <motion.div key={round} initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0 }} className="flex flex-col items-center">
              <p className="text-2xl font-black text-[#1A1A2E] mb-5">كم عدد {emoji}؟</p>

              <div className="flex flex-wrap gap-3 justify-center mb-8 max-w-xs">
                {Array.from({ length: countTarget }).map((_, i) => (
                  <motion.span key={i} initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: i * 0.07 }} className="text-4xl">
                    {emoji}
                  </motion.span>
                ))}
              </div>

              <div className="grid grid-cols-2 gap-4 w-full max-w-xs">
                {countChoices.map((n) => {
                  const isSelected = countSelected === n;
                  const isCorrect = n === countTarget;
                  return (
                    <motion.button
                      key={n}
                      whileHover={{ scale: countSelected !== null ? 1 : 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleCount(n)}
                      className={`py-5 rounded-2xl font-black text-3xl border-3 transition-all ${
                        isSelected && isCorrect ? "bg-[#06D6A0] text-white border-[#06D6A0]" :
                        isSelected && !isCorrect ? "bg-[#FF4D6D] text-white border-[#FF4D6D]" :
                        countSelected !== null && isCorrect ? "bg-[#06D6A0]/20 border-[#06D6A0] text-[#06D6A0]" :
                        "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                      }`}
                      style={{ borderWidth: 3 }}
                    >
                      {n}
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>
          </AnimatePresence>
        </div>
      )}
    </div>
  );
}
