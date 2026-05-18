import { useState } from "react";
import { useNavigate, useParams } from "react-router";
import { motion } from "motion/react";
import { ArrowRight } from "lucide-react";
import { SUBJECTS, QUIZ_DATA } from "../data";
import type { SubjectId } from "../data";
import { useStore, getEarnedBadgeIds } from "../store";
const avatarEmojis: Record<string, string> = { fox: "🦊", bunny: "🐰", dragon: "🐲", owl: "🦉", tiger: "🐯" };
const EMOJIS = ["🤔", "💭", "🧠"];

export default function Quiz() {
  const navigate = useNavigate();
  const { subjectId } = useParams<{ subjectId: string }>();
  const { user, dispatch } = useStore();

  const [qIdx, setQIdx] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [score, setScore] = useState(0);

  const subject = SUBJECTS[subjectId as SubjectId];
  const questions = QUIZ_DATA[subjectId as SubjectId];
  const question = questions?.[qIdx];
  const avatar = avatarEmojis[user.avatarBase] ?? "🦊";

  if (!subject || !question) return <div className="p-8 text-center font-black">الاختبار غير موجود</div>;

  function handleAnswer(idx: number) {
    if (answered) return;
    setSelected(idx);
    setAnswered(true);
    if (idx === question.correct) setScore((s) => s + 1);
  }

  function handleNext() {
    if (qIdx < questions.length - 1) {
      setQIdx((q) => q + 1);
      setSelected(null);
      setAnswered(false);
    } else {
      const finalScore = score; // score already updated by handleAnswer via setScore
      const oldBadges = getEarnedBadgeIds(user);
      dispatch({ type: "COMPLETE_QUIZ", subjectId: subjectId as SubjectId, score: finalScore, total: questions.length });
      const xpEarned = finalScore * 40;
      const coinsEarned = finalScore * 15;
      navigate("/rewards", { state: { fromQuiz: true, score: finalScore, total: questions.length, xpEarned, coinsEarned, subjectId, oldBadges } });
    }
  }

  function optionClass(idx: number) {
    if (!answered) return "border-2 border-border bg-card text-foreground cursor-pointer hover:border-opacity-60";
    if (idx === question.correct) return "border-[3px] bg-[#D6F8EF] border-[#06D6A0] text-[#1A1A2E] cursor-default";
    if (idx === selected) return "border-[3px] bg-[#FFE0E6] border-[#FF4D6D] text-[#1A1A2E] cursor-default";
    return "border-2 border-border bg-card text-muted-foreground opacity-40 cursor-default";
  }

  return (
    <div dir="rtl" className="min-h-screen flex flex-col px-4 py-6">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate(`/categories/${subjectId}`)} className="w-10 h-10 rounded-xl bg-card border-2 border-border flex items-center justify-center hover:bg-muted">
          <ArrowRight className="w-4 h-4" />
        </button>
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-1.5">
            <span className="text-xl">{subject.emoji}</span>
            <span className="font-black">اختبار {subject.name}</span>
          </div>
          <div className="flex gap-1.5">
            {questions.map((_, i) => (
              <div key={i} className="h-2 rounded-full transition-all duration-300" style={{ width: i === qIdx ? "24px" : "10px", backgroundColor: i <= qIdx ? subject.color : "#E5E5E5" }} />
            ))}
          </div>
        </div>
        <span className="text-sm font-black text-muted-foreground">{qIdx + 1}/{questions.length}</span>
      </div>

      <motion.div key={qIdx} initial={{ opacity: 0, x: 24 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.25 }} className="flex-1 flex flex-col">
        {/* Character hint */}
        <div className="flex items-end gap-2 mb-4">
          <motion.div animate={{ y: [0, -5, 0] }} transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }} className="text-4xl select-none shrink-0">{avatar}</motion.div>
          <div className="relative bg-card border-2 rounded-xl rounded-bl-none px-3 py-2 flex-1" style={{ borderColor: subject.color }}>
            <div className="absolute -left-2.5 bottom-3 w-0 h-0" style={{ borderTop: "6px solid transparent", borderBottom: "6px solid transparent", borderRight: `10px solid ${subject.color}` }} />
            <p className="text-xs font-bold text-muted-foreground">اقرأ السؤال بتمعّن! 🧠</p>
          </div>
        </div>

        {/* Question */}
        <div className="rounded-[1.75rem] p-7 mb-5 text-center border-[3px]" style={{ backgroundColor: subject.lightColor, borderColor: subject.color }}>
          <div className="text-5xl mb-3 select-none">{EMOJIS[qIdx % 3]}</div>
          <h2 className="text-xl font-black text-[#1A1A2E] leading-snug">{question.question}</h2>
        </div>

        {/* Options */}
        <div className="grid grid-cols-2 gap-3 mb-4">
          {question.options.map((opt, idx) => (
            <motion.button
              key={idx}
              whileHover={!answered ? { scale: 1.02 } : {}}
              whileTap={!answered ? { scale: 0.97 } : {}}
              onClick={() => handleAnswer(idx)}
              className={`rounded-2xl p-4 text-left transition-all ${optionClass(idx)}`}
            >
              <span className="block text-[10px] font-black text-muted-foreground mb-1 tracking-widest uppercase">{["A", "B", "C", "D"][idx]}</span>
              <span className="block font-black text-base">{opt}</span>
              {answered && idx === question.correct && <span className="block text-xs font-black text-[#06D6A0] mt-1">✓ صحيح!</span>}
              {answered && idx === selected && idx !== question.correct && <span className="block text-xs font-black text-[#FF4D6D] mt-1">✗ حاول مجدداً</span>}
            </motion.button>
          ))}
        </div>

        {answered && (
          <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}>
            <div className="bg-muted rounded-2xl px-4 py-3 mb-4">
              <p className="text-sm font-bold"><span className="text-foreground">💡 {question.hint}</span></p>
            </div>
            <motion.button
              whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
              onClick={handleNext}
              className="w-full rounded-2xl py-4 font-black text-lg shadow-lg transition-all"
              style={{ backgroundColor: subject.color, color: subjectId === "math" ? "#1A1A2E" : "#FFFFFF" }}
            >
              {qIdx < questions.length - 1 ? "السؤال التالي ←" : "عرض النتائج 🎉"}
            </motion.button>
          </motion.div>
        )}
      </motion.div>
    </div>
  );
}
