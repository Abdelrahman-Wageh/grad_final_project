import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, Clock, Zap } from "lucide-react";
import { DAILY_QUESTIONS } from "../data";
import { useStore } from "../store";

export default function DailyChallenge() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();

  const [qIdx, setQIdx] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);
  const [timeLeft, setTimeLeft] = useState({ hours: 0, minutes: 0 });

  const question = DAILY_QUESTIONS[qIdx];

  useEffect(() => {
    const compute = () => {
      const now = new Date();
      const midnight = new Date();
      midnight.setHours(24, 0, 0, 0);
      const diff = midnight.getTime() - now.getTime();
      setTimeLeft({ hours: Math.floor(diff / 3600000), minutes: Math.floor((diff % 3600000) / 60000) });
    };
    compute();
    const id = setInterval(compute, 60000);
    return () => clearInterval(id);
  }, []);

  function handleAnswer(idx: number) {
    if (answered) return;
    setSelected(idx);
    setAnswered(true);
    if (idx === question.correct) setScore((s) => s + 1);
  }

  function handleNext() {
    if (qIdx < DAILY_QUESTIONS.length - 1) {
      setQIdx((q) => q + 1);
      setSelected(null);
      setAnswered(false);
    } else {
      const finalScore = answered && selected === question.correct ? score + 1 : score;
      dispatch({ type: "COMPLETE_CHALLENGE" });
      setScore(finalScore);
      setDone(true);
    }
  }

  function optionStyle(idx: number) {
    if (!answered) return "border-2 border-white/20 bg-white/5 text-white cursor-pointer hover:bg-white/15";
    if (idx === question.correct) return "border-[3px] border-[#06D6A0] bg-[#06D6A0]/20 text-white cursor-default";
    if (idx === selected) return "border-[3px] border-[#FF4D6D] bg-[#FF4D6D]/20 text-white cursor-default";
    return "border-2 border-white/10 bg-white/5 text-white/30 cursor-default";
  }

  if (done) {
    const perfect = score === DAILY_QUESTIONS.length;
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-4 text-center" style={{ background: "linear-gradient(135deg, #1A0800 0%, #2D1500 100%)" }}>
        <div className="fixed inset-0 pointer-events-none overflow-hidden">
          {[...Array(20)].map((_, i) => (
            <motion.div key={i} animate={{ y: [0, -200], opacity: [1, 0], x: [(i % 2 ? 20 : -20)] }}
              transition={{ duration: 1.5, delay: i * 0.1, repeat: Infinity, repeatDelay: 1 }}
              className="absolute bottom-0 w-3 h-3 rounded-sm"
              style={{ left: `${(i * 5 + 5) % 95}%`, backgroundColor: ["#FFD60A", "#FF4D6D", "#06D6A0", "#C77DFF", "#4CC9F0"][i % 5] }}
            />
          ))}
        </div>
        <motion.div initial={{ scale: 0.7, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} transition={{ type: "spring", stiffness: 180 }}>
          <div className="text-7xl mb-4 select-none">{perfect ? "🏆" : score >= 2 ? "⭐" : "💪"}</div>
          <h1 className="text-3xl font-black text-white mb-2">أكملت التحدي!</h1>
          <p className="text-white/60 font-bold mb-8">حصلت على {score}/{DAILY_QUESTIONS.length}!</p>
          <div className="flex gap-4 justify-center mb-8">
            <div className="bg-white/10 border border-[#FFD60A]/30 rounded-2xl px-5 py-4 text-center">
              <div className="font-black text-2xl text-[#FFD60A]">+100</div>
              <div className="text-xs font-bold text-white/50">مكافأة نقاط</div>
            </div>
            <div className="bg-white/10 border border-[#FFD60A]/30 rounded-2xl px-5 py-4 text-center">
              <div className="font-black text-2xl text-[#FFD60A]">+50 🪙</div>
              <div className="text-xs font-bold text-white/50">عملة</div>
            </div>
          </div>
          <div className="flex gap-3 flex-col">
            <button onClick={() => navigate("/rewards")} className="w-64 rounded-2xl py-4 font-black text-[#1A1A2E] text-lg" style={{ backgroundColor: "#FFD60A" }}>
              استلم الجوائز ←
            </button>
            <button onClick={() => navigate("/")} className="w-64 rounded-2xl py-3 font-black text-white border-2 border-white/20 bg-white/10">
              العودة للرئيسية
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  if (user.challengeCompletedToday) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-4 text-center" style={{ background: "linear-gradient(135deg, #1A0800 0%, #2D1500 100%)" }}>
        <div className="text-6xl mb-4 select-none">✅</div>
        <h1 className="text-2xl font-black text-white mb-2">أتممت تحدي اليوم!</h1>
        <p className="text-white/60 font-bold mb-2">لقد أكملت تحدي اليوم!</p>
        <div className="flex items-center gap-2 bg-white/10 rounded-xl px-4 py-2 mb-8">
          <Clock className="w-4 h-4 text-[#FF6B35]" />
          <span className="text-sm font-black text-white">تحدي جديد خلال {timeLeft.hours}ساعة {timeLeft.minutes}دقيقة</span>
        </div>
        <button onClick={() => navigate("/")} className="rounded-2xl px-8 py-4 font-black text-[#1A1A2E] text-lg" style={{ backgroundColor: "#FFD60A" }}>العودة للرئيسية</button>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen flex flex-col px-4 py-6" style={{ background: "linear-gradient(135deg, #1A0800 0%, #2D1500 50%, #1A0A00 100%)" }}>
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center hover:bg-white/20">
          <ArrowRight className="w-4 h-4 text-white" />
        </button>
        <div className="flex-1">
          <h1 className="font-black text-white text-lg">تحدي اليوم 🔥</h1>
          <div className="flex items-center gap-1.5 text-[#FF6B35]">
            <Clock className="w-3.5 h-3.5" />
            <span className="text-xs font-black">متبقّي: {timeLeft.hours}س {timeLeft.minutes}دق</span>
          </div>
        </div>
        <div className="flex items-center gap-1.5 bg-[#FFD60A]/20 rounded-xl px-3 py-1.5 border border-[#FFD60A]/30">
          <Zap className="w-4 h-4 text-[#FFD60A]" />
          <span className="text-sm font-black text-[#FFD60A]">+100 XP</span>
        </div>
      </div>

      {/* Progress */}
      <div className="flex gap-2 mb-6">
        {DAILY_QUESTIONS.map((_, i) => (
          <div key={i} className="flex-1 h-2 rounded-full transition-colors" style={{ backgroundColor: i < qIdx ? "#FF6B35" : i === qIdx ? "#FFD60A" : "rgba(255,255,255,0.1)" }} />
        ))}
      </div>

      {/* Flame character */}
      <div className="flex items-end gap-3 mb-6">
        <motion.div animate={{ y: [0, -6, 0], rotate: [-3, 3, -3] }} transition={{ repeat: Infinity, duration: 1.8 }} className="text-5xl select-none shrink-0">🦊</motion.div>
        <div className="relative bg-white/10 border border-[#FF6B35]/40 rounded-2xl rounded-bl-none p-3 flex-1">
          <div className="absolute -left-3 bottom-3 w-0 h-0" style={{ borderTop: "6px solid transparent", borderBottom: "6px solid transparent", borderRight: "10px solid rgba(255,107,53,0.4)" }} />
          <p className="text-sm font-bold text-white/80">تحدي كبير! أسئلة متنوعة — أثبت ما تعرف! 🔥</p>
        </div>
      </div>

      {/* Question */}
      <motion.div key={qIdx} initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} className="flex-1 flex flex-col">
        <div className="rounded-[1.75rem] p-7 mb-5 text-center border-[3px] border-[#FF6B35]/50" style={{ background: "linear-gradient(135deg, rgba(255,107,53,0.2) 0%, rgba(255,77,109,0.2) 100%)" }}>
          <div className="text-5xl mb-3 select-none">🤔</div>
          <h2 className="text-xl font-black text-white leading-snug">{question.question}</h2>
          <div className="mt-2 flex items-center justify-center gap-1.5">
            <span className="text-xs font-bold text-[#FF6B35] uppercase tracking-wide">المادة:</span>
            <span className="text-xs font-bold text-white/60">{question.subject}</span>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 mb-4">
          {question.options.map((opt, idx) => (
            <motion.button
              key={idx}
              whileHover={!answered ? { scale: 1.02 } : {}}
              whileTap={!answered ? { scale: 0.97 } : {}}
              onClick={() => handleAnswer(idx)}
              className={`rounded-2xl p-4 text-left transition-all ${optionStyle(idx)}`}
            >
              <span className="block text-[10px] font-black text-white/40 mb-1 uppercase tracking-widest">{["A", "B", "C", "D"][idx]}</span>
              <span className="block font-black text-base">{opt}</span>
              {answered && idx === question.correct && <span className="block text-xs font-black text-[#06D6A0] mt-1">✓ صحيح!</span>}
              {answered && idx === selected && idx !== question.correct && <span className="block text-xs font-black text-[#FF4D6D] mt-1">✗ حاول مجدداً!</span>}
            </motion.button>
          ))}
        </div>

        {answered && (
          <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}>
            <div className="bg-white/10 border border-white/20 rounded-2xl px-4 py-3 mb-4">
              <p className="text-sm font-bold text-white/80">💡 {question.hint}</p>
            </div>
            <button
              onClick={handleNext}
              className="w-full rounded-2xl py-4 font-black text-[#1A1A2E] text-lg shadow-lg"
              style={{ backgroundColor: "#FF6B35" }}
            >
              {qIdx < DAILY_QUESTIONS.length - 1 ? "التالي ←" : "إنهاء! 🎉"}
            </button>
          </motion.div>
        )}
      </motion.div>
    </div>
  );
}
