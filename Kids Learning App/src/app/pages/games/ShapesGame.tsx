import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const SHAPES = [
  { name: "دائرة", color: "#EF4444", svg: <circle cx="50" cy="50" r="40" /> },
  { name: "مربع", color: "#3B82F6", svg: <rect x="10" y="10" width="80" height="80" rx="6" /> },
  { name: "مثلث", color: "#22C55E", svg: <polygon points="50,10 90,90 10,90" /> },
  { name: "نجمة", color: "#EAB308", svg: <polygon points="50,5 61,35 95,35 68,57 79,91 50,70 21,91 32,57 5,35 39,35" /> },
  { name: "قلب", color: "#EC4899", svg: <path d="M50 85 C15 60 5 40 25 25 C35 18 45 22 50 30 C55 22 65 18 75 25 C95 40 85 60 50 85Z" /> },
  { name: "مستطيل", color: "#8B5CF6", svg: <rect x="5" y="20" width="90" height="60" rx="6" /> },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

function ShapeSVG({ shape, color, size = 80 }: { shape: typeof SHAPES[0]; color: string; size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 100 100">
      {/* Clone with fill */}
      {shape.name === "دائرة" && <circle cx="50" cy="50" r="40" fill={color} />}
      {shape.name === "مربع" && <rect x="10" y="10" width="80" height="80" rx="6" fill={color} />}
      {shape.name === "مثلث" && <polygon points="50,10 90,90 10,90" fill={color} />}
      {shape.name === "نجمة" && <polygon points="50,5 61,35 95,35 68,57 79,91 50,70 21,91 32,57 5,35 39,35" fill={color} />}
      {shape.name === "قلب" && <path d="M50 85 C15 60 5 40 25 25 C35 18 45 22 50 30 C55 22 65 18 75 25 C95 40 85 60 50 85Z" fill={color} />}
      {shape.name === "مستطيل" && <rect x="5" y="20" width="90" height="60" rx="6" fill={color} />}
    </svg>
  );
}

export default function ShapesGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [idx, setIdx] = useState(0);
  const [score, setScore] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [done, setDone] = useState(false);
  const [choices, setChoices] = useState<typeof SHAPES>([]);

  const target = SHAPES[idx];

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  function nextRound(i: number) {
    const t = SHAPES[i];
    const wrong = shuffle(SHAPES.filter((s) => s.name !== t.name)).slice(0, 3);
    setChoices(shuffle([t, ...wrong]));
    setSelected(null);
    speak(`اختر ال${t.name}`);
  }

  useEffect(() => { nextRound(0); }, []);

  function handlePick(name: string) {
    if (selected) return;
    setSelected(name);
    if (name === target.name) {
      setScore((s) => s + 1);
      speak("ممتاز! إجابة صحيحة!");
    } else {
      speak(`الشكل الصحيح هو ال${target.name}`);
    }
    setTimeout(() => {
      if (idx + 1 >= SHAPES.length) {
        setDone(true);
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "math", score, total: SHAPES.length });
      } else {
        setIdx((i) => { nextRound(i + 1); return i + 1; });
      }
    }, 1400);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#E8F5E9] to-[#C8E6C9] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">⭐</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">أحسنت يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">حصلت على {score} من {SHAPES.length} نقاط</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setIdx(0); setScore(0); setDone(false); nextRound(0); }} className="bg-[#22C55E] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
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
        <h1 className="text-lg font-black text-[#1A1A2E]">تعلّم الأشكال 🔷</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/{SHAPES.length}</div>
      </div>

      <div className="px-5 mt-4">
        <div className="bg-white/60 rounded-full h-3">
          <motion.div className="bg-[#22C55E] h-3 rounded-full" animate={{ width: `${(idx / SHAPES.length) * 100}%` }} />
        </div>
        <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mt-1">سؤال {idx + 1} من {SHAPES.length}</p>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={idx}
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 1.1 }}
          className="flex flex-col items-center mt-8 px-5"
        >
          <motion.div
            className="mb-6 cursor-pointer"
            animate={{ scale: [1, 1.08, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
            onClick={() => speak(`اختر ال${target.name}`)}
          >
            <ShapeSVG shape={target} color={target.color} size={140} />
          </motion.div>

          <button onClick={() => speak(`اختر ال${target.name}`)} className="mb-6 bg-white/80 rounded-2xl px-5 py-2 font-bold text-sm text-[#1A1A2E]/70 shadow">
            🔊 اسمع السؤال
          </button>

          <p className="text-2xl font-black text-[#1A1A2E] mb-6">ما اسم هذا الشكل؟</p>

          <div className="grid grid-cols-2 gap-4 w-full max-w-sm">
            {choices.map((s) => {
              const isSelected = selected === s.name;
              const isCorrect = s.name === target.name;
              return (
                <motion.button
                  key={s.name}
                  whileHover={{ scale: selected ? 1 : 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => handlePick(s.name)}
                  className={`py-5 rounded-2xl font-black text-xl border-3 flex flex-col items-center gap-2 transition-all ${
                    isSelected && isCorrect ? "bg-[#06D6A0] border-[#06D6A0] text-white" :
                    isSelected && !isCorrect ? "bg-[#FF4D6D] border-[#FF4D6D] text-white" :
                    selected && isCorrect ? "bg-[#06D6A0]/10 border-[#06D6A0] text-[#06D6A0]" :
                    "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                  }`}
                  style={{ borderWidth: 3 }}
                >
                  <ShapeSVG shape={s} color={isSelected ? "#fff" : s.color} size={40} />
                  {s.name}
                </motion.button>
              );
            })}
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
