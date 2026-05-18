import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const COLORS = [
  { name: "أحمر", hex: "#EF4444", emoji: "🍎" },
  { name: "أزرق", hex: "#3B82F6", emoji: "🫐" },
  { name: "أخضر", hex: "#22C55E", emoji: "🌿" },
  { name: "أصفر", hex: "#EAB308", emoji: "⭐" },
  { name: "برتقالي", hex: "#F97316", emoji: "🍊" },
  { name: "بنفسجي", hex: "#A855F7", emoji: "🍇" },
  { name: "وردي", hex: "#EC4899", emoji: "🌸" },
  { name: "بني", hex: "#92400E", emoji: "🍫" },
  { name: "أبيض", hex: "#E5E7EB", emoji: "☁️" },
  { name: "أسود", hex: "#1F2937", emoji: "🎱" },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

export default function ColorsGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [round, setRound] = useState(0);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);
  const [selected, setSelected] = useState<string | null>(null);
  const [choices, setChoices] = useState<typeof COLORS>([]);
  const [target, setTarget] = useState(COLORS[0]);

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.85;
    speechSynthesis.speak(u);
  }

  function nextRound(r: number) {
    const t = COLORS[r % COLORS.length];
    setTarget(t);
    setSelected(null);
    const wrong = shuffle(COLORS.filter((c) => c.name !== t.name)).slice(0, 3);
    setChoices(shuffle([t, ...wrong]));
    speak(`أشر إلى اللون ${t.name}`);
  }

  useEffect(() => { nextRound(0); }, []);

  function handlePick(color: typeof COLORS[0]) {
    if (selected) return;
    setSelected(color.name);
    if (color.name === target.name) {
      setScore((s) => s + 1);
      speak("ممتاز! إجابة صحيحة!");
    } else {
      speak(`اللون الصحيح هو ${target.name}`);
    }
    setTimeout(() => {
      if (round + 1 >= 10) {
        setDone(true);
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "math", score, total: 10 });
      } else {
        setRound((r) => { nextRound(r + 1); return r + 1; });
      }
    }, 1400);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#FFF9C4] to-[#FFECB3] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">🌈</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">عظيم يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">حصلت على {score} من 10 نقاط</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setRound(0); setScore(0); setSelected(null); setDone(false); nextRound(0); }} className="bg-[#EAB308] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F0F4FF] to-[#E8F5FF] pb-8">
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">تعلّم الألوان 🌈</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/10</div>
      </div>

      <div className="px-5 mt-4">
        <div className="bg-white/60 rounded-full h-3">
          <motion.div className="bg-[#F97316] h-3 rounded-full" animate={{ width: `${(round / 10) * 100}%` }} />
        </div>
        <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mt-1">جولة {round + 1} من 10</p>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={round}
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 1.1 }}
          className="flex flex-col items-center mt-8 px-5"
        >
          {/* Target color swatch */}
          <motion.div
            className="w-32 h-32 rounded-3xl shadow-xl mb-4 flex items-center justify-center text-5xl"
            style={{ backgroundColor: target.hex }}
            animate={{ scale: [1, 1.05, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
          >
            {target.emoji}
          </motion.div>

          <button onClick={() => speak(`أشر إلى اللون ${target.name}`)} className="mb-6 bg-white/80 rounded-2xl px-5 py-2 font-bold text-[#1A1A2E]/70 text-sm shadow">
            🔊 اسمع السؤال مجدداً
          </button>

          <p className="text-2xl font-black text-[#1A1A2E] mb-6">أي لون هذا؟</p>

          <div className="grid grid-cols-2 gap-4 w-full max-w-sm">
            {choices.map((c) => {
              const isSelected = selected === c.name;
              const isCorrect = c.name === target.name;
              return (
                <motion.button
                  key={c.name}
                  whileHover={{ scale: selected ? 1 : 1.05 }}
                  whileTap={{ scale: selected ? 1 : 0.95 }}
                  onClick={() => handlePick(c)}
                  className={`py-4 rounded-2xl font-black text-lg border-3 flex items-center justify-center gap-2 transition-all ${
                    isSelected && isCorrect ? "text-white border-[#06D6A0]" :
                    isSelected && !isCorrect ? "text-white border-[#FF4D6D]" :
                    selected && isCorrect ? "border-[#06D6A0]" :
                    "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                  }`}
                  style={{
                    borderWidth: 3,
                    backgroundColor: isSelected ? (isCorrect ? "#06D6A0" : "#FF4D6D") : selected && isCorrect ? "#06D6A0/20" : undefined,
                  }}
                >
                  <span className="w-6 h-6 rounded-full inline-block border border-white/40" style={{ backgroundColor: c.hex }} />
                  {c.name}
                </motion.button>
              );
            })}
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
