import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const ROUNDS = [
  { word: "قِطَّة",  emoji: "🐱", hint: "حيوان أليف يموء" },
  { word: "شَجَرَة", emoji: "🌳", hint: "تنمو في الحديقة وتعطي ظلاً" },
  { word: "سَمَاء",  emoji: "🌤️", hint: "ما فوقنا في النهار" },
  { word: "كِتَاب",  emoji: "📚", hint: "نقرأ منه ونتعلم" },
  { word: "قَمَر",   emoji: "🌙", hint: "يضيء الليل" },
  { word: "بَيْت",   emoji: "🏠", hint: "نسكن فيه" },
  { word: "نَهْر",   emoji: "🏞️", hint: "مياه تجري على الأرض" },
  { word: "وَرْدَة",  emoji: "🌹", hint: "زهرة جميلة حمراء" },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

function speak(text: string) {
  speechSynthesis.cancel();
  const u = new SpeechSynthesisUtterance(text);
  u.lang = "ar-SA";
  u.rate = 0.8;
  speechSynthesis.speak(u);
}

export default function SpellingGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [rounds] = useState(() => shuffle(ROUNDS).slice(0, 6));
  const [idx, setIdx] = useState(0);
  const [pool, setPool] = useState<string[]>([]);
  const [placed, setPlaced] = useState<string[]>([]);
  const [result, setResult] = useState<"correct" | "wrong" | null>(null);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);

  const current = rounds[idx];

  function initRound(i: number) {
    const w = rounds[i];
    const letters = w.word.replace(/\s/g, "").split("");
    // Strip diacritics for pool label but keep original for display
    const extraPool = shuffle(["ز", "ف", "م", "ه", "ب", "ط", "ع"]).slice(0, 3);
    setPool(shuffle([...letters, ...extraPool]));
    setPlaced(Array(letters.length).fill(""));
    setResult(null);
    setTimeout(() => speak(w.hint), 300);
  }

  useEffect(() => { initRound(0); }, []);

  function pickFromPool(letter: string, poolIdx: number) {
    if (result) return;
    const emptySlot = placed.findIndex((p) => p === "");
    if (emptySlot === -1) return;
    const newPlaced = [...placed];
    newPlaced[emptySlot] = letter;
    const newPool = [...pool];
    newPool[poolIdx] = "";
    setPlaced(newPlaced);
    setPool(newPool);

    if (newPlaced.every((p) => p !== "")) {
      const built = newPlaced.join("");
      const target = current.word.replace(/\s/g, "");
      if (built === target) {
        setResult("correct");
        setScore((s) => s + 1);
        speak(`ممتاز! الكلمة هي ${current.word}`);
        setTimeout(() => {
          if (idx + 1 >= rounds.length) {
            setDone(true);
            dispatch({ type: "COMPLETE_QUIZ", subjectId: "reading", score: score + 1, total: rounds.length });
          } else {
            setIdx((i) => { initRound(i + 1); return i + 1; });
          }
        }, 1600);
      } else {
        setResult("wrong");
        speak("حاول مجدداً!");
        setTimeout(() => initRound(idx), 1400);
      }
    }
  }

  function removeFromSlot(slotIdx: number) {
    if (result) return;
    const letter = placed[slotIdx];
    if (!letter) return;
    const newPlaced = [...placed];
    newPlaced[slotIdx] = "";
    const newPool = [...pool];
    const emptyPoolSlot = newPool.findIndex((p) => p === "");
    if (emptyPoolSlot !== -1) newPool[emptyPoolSlot] = letter;
    else newPool.push(letter);
    setPlaced(newPlaced);
    setPool(newPool);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E8F5E9] to-[#C8E6C9] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl max-w-sm w-full">
          <div className="text-7xl mb-4">🏆</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">أحسنت يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">هجّيت {score} من {rounds.length} كلمات صحيحة</p>
          <div className="flex gap-3 justify-center">
            <button
              onClick={() => { setIdx(0); setScore(0); setDone(false); initRound(0); }}
              className="bg-[#22C55E] text-white font-black py-3 px-6 rounded-2xl"
            >
              العب مجدداً
            </button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F0FFF4] to-[#DCFCE7] pb-8">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">لعبة التهجئة ✍️</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/{rounds.length}</div>
      </div>

      <div className="px-5 mt-5">
        {/* Progress */}
        <div className="bg-white/60 rounded-full h-3 mb-1 overflow-hidden">
          <motion.div className="bg-[#22C55E] h-3 rounded-full" animate={{ width: `${(idx / rounds.length) * 100}%` }} />
        </div>
        <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mb-5">كلمة {idx + 1} من {rounds.length}</p>

        <AnimatePresence mode="wait">
          <motion.div key={idx} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }}>
            {/* Clue card */}
            <div className="bg-white rounded-3xl p-6 shadow-md mb-5 text-center">
              <motion.div
                className="text-7xl mb-3 cursor-pointer"
                animate={{ scale: [1, 1.07, 1] }}
                transition={{ duration: 2.5, repeat: Infinity }}
                onClick={() => speak(current.hint)}
              >
                {current.emoji}
              </motion.div>
              <p className="text-base font-bold text-[#1A1A2E]/70 bg-[#F0FFF4] rounded-2xl px-4 py-2 inline-block">
                💡 {current.hint}
              </p>
              <button onClick={() => speak(current.hint)} className="block mx-auto mt-3 text-sm font-bold text-[#22C55E]">
                🔊 استمع للتلميح
              </button>
            </div>

            {/* Answer slots */}
            <p className="text-center font-bold text-[#1A1A2E]/60 text-sm mb-3">رتّب الحروف لتكوين الكلمة</p>
            <div className="flex gap-2 mb-6 justify-center flex-wrap">
              {placed.map((p, i) => (
                <motion.button
                  key={i}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => removeFromSlot(i)}
                  className={`w-12 h-12 rounded-xl font-black text-xl flex items-center justify-center border-2 transition-all ${
                    result === "correct" ? "bg-[#06D6A0] border-[#06D6A0] text-white" :
                    result === "wrong"   ? "bg-[#FF4D6D] border-[#FF4D6D] text-white" :
                    p ? "bg-white border-[#22C55E] text-[#1A1A2E] shadow" :
                    "bg-white/50 border-dashed border-[#94A3B8]"
                  }`}
                >
                  {p}
                </motion.button>
              ))}
            </div>

            {result === "correct" && (
              <motion.p initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} className="text-center text-[#06D6A0] font-black text-xl mb-4">
                ✅ ممتاز! {current.word}
              </motion.p>
            )}
            {result === "wrong" && (
              <motion.p initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} className="text-center text-[#FF4D6D] font-black text-xl mb-4">
                ❌ حاول مجدداً!
              </motion.p>
            )}

            {/* Letter pool */}
            <p className="text-center font-bold text-[#1A1A2E]/50 text-sm mb-3">اضغط على الحرف لاختياره</p>
            <div className="flex gap-2 flex-wrap justify-center">
              {pool.map((letter, i) =>
                letter ? (
                  <motion.button
                    key={i}
                    whileHover={{ scale: 1.12 }}
                    whileTap={{ scale: 0.88 }}
                    onClick={() => pickFromPool(letter, i)}
                    className="w-12 h-12 bg-white rounded-xl font-black text-xl shadow border-2 border-[#E2E8F0] text-[#1A1A2E]"
                  >
                    {letter}
                  </motion.button>
                ) : (
                  <div key={i} className="w-12 h-12" />
                )
              )}
            </div>
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
}
