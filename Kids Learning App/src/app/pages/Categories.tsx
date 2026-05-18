import { useNavigate, useParams } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, CheckCircle, Download } from "lucide-react";
import { SUBJECTS } from "../data";
import type { SubjectId } from "../data";
import { useStore } from "../store";

export default function Categories() {
  const navigate = useNavigate();
  const { subjectId } = useParams<{ subjectId?: string }>();
  const { user } = useStore();

  if (subjectId && SUBJECTS[subjectId as SubjectId]) {
    return <SubjectDetail subjectId={subjectId as SubjectId} />;
  }

  return (
    <div dir="rtl" className="px-4 py-6">
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-card border-2 border-border flex items-center justify-center hover:bg-muted transition-colors">
          <ArrowRight className="w-4 h-4" />
        </button>
        <div>
          <h1 className="text-2xl font-black text-foreground">المواد الدراسية</h1>
          <p className="text-sm font-bold text-muted-foreground">اختر مادة لتبدأ التعلّم</p>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4">
        {(Object.values(SUBJECTS) as typeof SUBJECTS[SubjectId][]).map((subject, i) => {
          const totalLessons = subject.lessons.length;
          const doneLessons = subject.lessons.filter((_, idx) => user.completedLessons.includes(`${subject.id}-${idx}`)).length;
          const pct = Math.round((doneLessons / totalLessons) * 100);

          return (
            <motion.button
              key={subject.id}
              initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: i * 0.08 }}
              whileHover={{ scale: 1.02, x: 4 }} whileTap={{ scale: 0.98 }}
              onClick={() => navigate(`/categories/${subject.id}`)}
              className="w-full text-left rounded-[1.75rem] p-5 border-[3px] overflow-hidden relative"
              style={{ backgroundColor: subject.lightColor, borderColor: subject.color }}
            >
              <div className="absolute -top-8 -right-8 w-36 h-36 rounded-full opacity-20" style={{ backgroundColor: subject.color }} />
              <div className="relative flex items-center gap-4">
                <div className="w-16 h-16 rounded-2xl flex items-center justify-center text-3xl shadow-md shrink-0" style={{ backgroundColor: subject.color }}>
                  {subject.emoji}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <h2 className="text-xl font-black text-[#1A1A2E]">{subject.name}</h2>
                    {user.offlineMode && <Download className="w-3.5 h-3.5 text-[#1A1A2E]/40" />}
                  </div>
                  <p className="text-sm font-bold text-[#1A1A2E]/60 mb-2">{subject.description}</p>
                  <div className="bg-white/50 rounded-full h-2 overflow-hidden">
                    <div className="h-full rounded-full" style={{ width: `${pct}%`, backgroundColor: subject.color }} />
                  </div>
                  <div className="flex justify-between mt-1">
                    <span className="text-xs font-bold text-[#1A1A2E]/60">{doneLessons}/{totalLessons} درس</span>
                    <span className="text-xs font-black" style={{ color: subject.color }}>{pct}%</span>
                  </div>
                </div>
              </div>
            </motion.button>
          );
        })}
      </div>
    </div>
  );
}

function SubjectDetail({ subjectId }: { subjectId: SubjectId }) {
  const navigate = useNavigate();
  const { user } = useStore();
  const subject = SUBJECTS[subjectId];

  return (
    <div dir="rtl" className="px-4 py-6">
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate("/categories")} className="w-10 h-10 rounded-xl bg-card border-2 border-border flex items-center justify-center hover:bg-muted">
          <ArrowRight className="w-4 h-4" />
        </button>
        <div className="flex items-center gap-2">
          <span className="text-2xl">{subject.emoji}</span>
          <h1 className="text-2xl font-black">{subject.name}</h1>
        </div>
      </div>

      {/* Subject hero */}
      <div className="rounded-[1.75rem] p-6 mb-6 border-[3px] overflow-hidden relative" style={{ backgroundColor: subject.lightColor, borderColor: subject.color }}>
        <div className="absolute -top-10 -right-10 w-40 h-40 rounded-full opacity-20" style={{ backgroundColor: subject.color }} />
        <div className="relative">
          <p className="text-sm font-bold text-[#1A1A2E]/60">{subject.description}</p>
          <div className="mt-3 bg-white/50 rounded-full h-3 overflow-hidden">
            <div className="h-full rounded-full" style={{ width: `${Math.round((subject.lessons.filter((_, i) => user.completedLessons.includes(`${subjectId}-${i}`)).length / subject.lessons.length) * 100)}%`, backgroundColor: subject.color }} />
          </div>
        </div>
      </div>

      {/* Lessons */}
      <h2 className="text-lg font-black mb-4">الدروس</h2>
      <div className="space-y-3 mb-6">
        {subject.lessons.map((lesson, idx) => {
          const done = user.completedLessons.includes(`${subjectId}-${idx}`);
          return (
            <motion.button
              key={idx}
              whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
              onClick={() => navigate(`/lesson/${subjectId}/${idx}`)}
              className="w-full text-left rounded-2xl p-4 border-2 border-border bg-card flex items-center gap-4 hover:border-opacity-60 transition-all"
            >
              <div className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0 text-lg" style={{ backgroundColor: done ? subject.color : subject.lightColor }}>
                {done ? <CheckCircle className="w-5 h-5 text-white" /> : <span>{idx + 1}</span>}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-black text-foreground">{lesson.title}</p>
                <p className="text-xs font-bold text-muted-foreground mt-0.5">+{lesson.xp} نقطة · +{lesson.coins} عملة</p>
              </div>
              {done && <span className="text-xs font-black px-2 py-1 rounded-lg text-white shrink-0" style={{ backgroundColor: subject.color }}>أتممته!</span>}
            </motion.button>
          );
        })}
      </div>

      {/* Quiz button */}
      <motion.button
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={() => navigate(`/quiz/${subjectId}`)}
        className="w-full rounded-2xl py-4 font-black text-lg shadow-lg transition-all hover:brightness-110 flex items-center justify-center gap-2"
        style={{ backgroundColor: subject.color, color: subjectId === "math" ? "#1A1A2E" : "#FFFFFF" }}
      >
        <span>ابدأ اختبار {subject.name}</span>
        <span>←</span>
      </motion.button>
    </div>
  );
}
