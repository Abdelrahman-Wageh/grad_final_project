import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const WORDS = [
  { word: "كتاب", emoji: "📚", hint: "نقرأ منه" },
  { word: "شمس", emoji: "☀️", hint: "تضيء النهار" },
  { word: "بيت", emoji: "🏠", hint: "نسكن فيه" },
  { word: "ماء", emoji: "💧", hint: "نشربه" },
  { word: "تفاح", emoji: "🍎", hint: "فاكهة حمراء" },
  { word: "قلب", emoji: "❤️", hint: "يضخ الدم" },
  { word: "نجمة", emoji: "⭐", hint: "في السماء ليلاً" },
  { word: "سمكة", emoji: "🐟", hint: "تعيش في الماء" },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

export default function WordBuildGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [idx, setIdx] = useState(0);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);
  const [placed, setPlaced] = useState<string[]>([]);
  const [pool, setPool] = useState<string[]>([]);
  const [result, setResult] = useState<"correct" | "wrong" | null>(null);

  const current = WORDS[idx];

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  function initRound(i: number) {
    const w = WORDS[i];
    const letters = w.word.split("");
    const extra = shuffle(["ز", "ق", "م", "ل", "س", "ر"]).slice(0, 2);
    setPool(shuffle([...letters, ...extra]));
    setPlaced(Array(letters.length).fill(""));
    setResult(null);
    speak(`رتّب الحروف لتكوين كلمة: ${w.hint}`);
  }

  useEffect(() => { initRound(0); }, []);

  function pickLetter(letter: string, poolIdx: number) {
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
      if (built === current.word) {
        setResult("correct");
        setScore((s) => s + 1);
        speak(`أحسنت! الكلمة هي ${current.word}`);
        setTimeout(() => {
          if (idx + 1 >= WORDS.length) {
            setDone(true);
            dispatch({ type: "COMPLETE_QUIZ", subjectId: "reading", score: score + 1, total: WORDS.length });
          } else {
            setIdx((i) => { initRound(i + 1); return i + 1; });
          }
        }, 1500);
      } else {
        setResult("wrong");
        speak("حاول مجدداً!");
        setTimeout(() => initRound(idx), 1200);
      }
    }
  }

  function removeLetter(slotIdx: number) {
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
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">🎉</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">رائع يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">كوّنت {score} من {WORDS.length} كلمات صحيحة</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setIdx(0); setScore(0); setDone(false); initRound(0); }} className="bg-[#06D6A0] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F0FFF4] to-[#DCFCE7] pb-8">
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">كوّن الكلمة 🔤</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/{WORDS.length}</div>
      </div>

      <div className="px-5 mt-4">
        <div className="bg-white/60 rounded-full h-3 mb-1">
          <motion.div className="bg-[#06D6A0] h-3 rounded-full" animate={{ width: `${(idx / WORDS.length) * 100}%` }} />
        </div>
        <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mb-6">كلمة {idx + 1} من {WORDS.length}</p>

        <AnimatePresence mode="wait">
          <motion.div key={idx} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} className="flex flex-col items-center">
            {/* Emoji clue */}
            <motion.div
              className="text-8xl mb-2 cursor-pointer"
              animate={{ scale: [1, 1.06, 1] }}
              transition={{ duration: 2.5, repeat: Infinity }}
              onClick={() => speak(current.hint)}
            >
              {current.emoji}
            </motion.div>
            <p className="text-lg font-bold text-[#1A1A2E]/70 mb-6 bg-white/80 rounded-2xl px-5 py-2">
              💡 {current.hint}
            </p>

            {/* Answer slots */}
            <div className="flex gap-3 mb-8 justify-center flex-wrap">
              {placed.map((p, i) => (
                <motion.button
                  key={i}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => removeLetter(i)}
                  className={`w-14 h-14 rounded-2xl font-black text-2xl flex items-center justify-center border-3 transition-all ${
                    result === "correct" ? "bg-[#06D6A0] border-[#06D6A0] text-white" :
                    result === "wrong" ? "bg-[#FF4D6D] border-[#FF4D6D] text-white" :
                    p ? "bg-white border-[#06D6A0] text-[#1A1A2E] shadow" :
                    "bg-white/50 border-dashed border-[#94A3B8]"
                  }`}
                  style={{ borderWidth: 3 }}
                >
                  {p || ""}
                </motion.button>
              ))}
            </div>

            {result === "correct" && (
              <motion.p initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} className="text-[#06D6A0] font-black text-xl mb-4">✅ أحسنت!</motion.p>
            )}
            {result === "wrong" && (
              <motion.p initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} className="text-[#FF4D6D] font-black text-xl mb-4">❌ حاول مجدداً</motion.p>
            )}

            {/* Letter pool */}
            <p className="font-bold text-[#1A1A2E]/60 text-sm mb-3">اضغط على الحروف لترتيبها</p>
            <div className="flex gap-3 flex-wrap justify-center max-w-xs">
              {pool.map((letter, i) => (
                letter ? (
                  <motion.button
                    key={i}
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => pickLetter(letter, i)}
                    className="w-14 h-14 bg-white rounded-2xl font-black text-2xl shadow-md border-2 border-[#E2E8F0] text-[#1A1A2E]"
                  >
                    {letter}
                  </motion.button>
                ) : (
                  <div key={i} className="w-14 h-14" />
                )
              ))}
            </div>
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
}
