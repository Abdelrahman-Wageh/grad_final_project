import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const ANIMALS = [
  { name: "قطة", emoji: "🐱", sound: "مواء", options: ["مواء", "هواء", "نباح", "خرير"] },
  { name: "كلب", emoji: "🐶", sound: "نباح", options: ["مواء", "نباح", "خوار", "ثغاء"] },
  { name: "بقرة", emoji: "🐮", sound: "خوار", options: ["خوار", "نباح", "مواء", "زئير"] },
  { name: "خروف", emoji: "🐑", sound: "ثغاء", options: ["زئير", "ثغاء", "نباح", "مواء"] },
  { name: "أسد", emoji: "🦁", sound: "زئير", options: ["مواء", "خوار", "زئير", "ثغاء"] },
  { name: "دجاجة", emoji: "🐔", sound: "صياح", options: ["صياح", "نباح", "زئير", "مواء"] },
  { name: "بطة", emoji: "🦆", sound: "نقنقة", options: ["نقنقة", "صياح", "خوار", "زئير"] },
  { name: "فرس", emoji: "🐴", sound: "صهيل", options: ["صهيل", "نباح", "ثغاء", "نقنقة"] },
];

export default function AnimalSoundsGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [idx, setIdx] = useState(0);
  const [score, setScore] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [done, setDone] = useState(false);
  const [shake, setShake] = useState(false);

  const current = ANIMALS[idx];

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  useEffect(() => {
    speak(`ما هو صوت ال${current.name}؟`);
  }, [idx]);

  function handleAnswer(option: string) {
    if (selected) return;
    setSelected(option);
    const correct = option === current.sound;
    if (correct) {
      setScore((s) => s + 1);
      speak("أحسنت! إجابة صحيحة!");
    } else {
      setShake(true);
      setTimeout(() => setShake(false), 500);
      speak(`صوت ال${current.name} هو ${current.sound}`);
    }
    setTimeout(() => {
      if (idx + 1 >= ANIMALS.length) {
        setDone(true);
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "science", score, total: ANIMALS.length });
      } else {
        setIdx((i) => i + 1);
        setSelected(null);
      }
    }, 1500);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E8F5E9] to-[#C8E6C9] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">🏆</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">رائع يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">حصلت على {score} من {ANIMALS.length} نقاط</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setIdx(0); setScore(0); setSelected(null); setDone(false); }} className="bg-[#06D6A0] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E3F2FD] to-[#BBDEFB] pb-8">
      {/* Header */}
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">أصوات الحيوانات 🐾</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/{ANIMALS.length}</div>
      </div>

      {/* Progress */}
      <div className="px-5 mt-4">
        <div className="bg-white/60 rounded-full h-3">
          <motion.div className="bg-[#06D6A0] h-3 rounded-full" animate={{ width: `${((idx) / ANIMALS.length) * 100}%` }} />
        </div>
        <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mt-1">سؤال {idx + 1} من {ANIMALS.length}</p>
      </div>

      {/* Animal */}
      <div className="flex flex-col items-center mt-8 px-5">
        <motion.div
          key={idx}
          initial={{ scale: 0, rotate: -10 }}
          animate={{ scale: 1, rotate: 0 }}
          className={`text-9xl mb-4 cursor-pointer ${shake ? "animate-bounce" : ""}`}
          onClick={() => speak(`ما هو صوت ال${current.name}؟`)}
        >
          {current.emoji}
        </motion.div>
        <motion.h2 key={`name-${idx}`} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="text-3xl font-black text-[#1A1A2E] mb-2">{current.name}</motion.h2>
        <p className="text-[#1A1A2E]/60 font-bold text-sm mb-8">اضغط على الحيوان لسماع السؤال 🔊</p>

        <p className="text-xl font-black text-[#1A1A2E] mb-5">ما هو صوت ال{current.name}؟</p>

        <div className="grid grid-cols-2 gap-4 w-full max-w-sm">
          {current.options.map((opt) => {
            const isCorrect = opt === current.sound;
            const isSelected = opt === selected;
            return (
              <motion.button
                key={opt}
                whileHover={{ scale: selected ? 1 : 1.05 }}
                whileTap={{ scale: selected ? 1 : 0.95 }}
                onClick={() => handleAnswer(opt)}
                className={`py-5 rounded-2xl font-black text-xl border-3 transition-all ${
                  isSelected && isCorrect ? "bg-[#06D6A0] border-[#06D6A0] text-white" :
                  isSelected && !isCorrect ? "bg-[#FF4D6D] border-[#FF4D6D] text-white" :
                  selected && isCorrect ? "bg-[#06D6A0]/20 border-[#06D6A0] text-[#06D6A0]" :
                  "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                }`}
                style={{ borderWidth: 3 }}
              >
                {opt}
              </motion.button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
