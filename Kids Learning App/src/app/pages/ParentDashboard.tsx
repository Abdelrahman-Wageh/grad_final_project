import { useState } from "react";
import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, Flame, Clock, BookOpen, Target, TrendingUp } from "lucide-react";
import { AreaChart, Area, XAxis, YAxis, ResponsiveContainer, Tooltip } from "recharts";
import { SUBJECTS, STUDY_TIME_DATA } from "../data";
import type { SubjectId } from "../data";
import { useStore } from "../store";

export default function ParentDashboard() {
  const navigate = useNavigate();
  const { user } = useStore();
  const [pin, setPin] = useState("");
  const [unlocked, setUnlocked] = useState(false);
  const [wrong, setWrong] = useState(false);

  function handlePin(digit: string) {
    const next = pin + digit;
    setPin(next);
    if (next.length === 4) {
      if (next === "1234") {
        setUnlocked(true);
      } else {
        setWrong(true);
        setTimeout(() => { setPin(""); setWrong(false); }, 800);
      }
    }
  }

  if (!unlocked) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-4" style={{ background: "linear-gradient(135deg, #0D1B2A 0%, #1A2940 100%)" }}>
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="text-center w-full max-w-xs">
          <div className="w-20 h-20 rounded-3xl bg-[#4CC9F0]/20 border-2 border-[#4CC9F0]/40 flex items-center justify-center text-4xl mx-auto mb-6">👨‍👩‍👧</div>
          <h1 className="text-2xl font-black text-white mb-1">لوحة الوالدين</h1>
          <p className="text-white/50 font-bold text-sm mb-8">أدخل رمزك السري للمتابعة</p>

          <div className={`flex justify-center gap-3 mb-8 ${wrong ? "animate-bounce" : ""}`}>
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className={`w-4 h-4 rounded-full border-2 transition-all ${i < pin.length ? "bg-[#4CC9F0] border-[#4CC9F0]" : "border-white/30"}`} />
            ))}
          </div>

          <div className="grid grid-cols-3 gap-3 mb-4">
            {[1, 2, 3, 4, 5, 6, 7, 8, 9].map((d) => (
              <button key={d} onClick={() => handlePin(String(d))} className="h-14 rounded-2xl bg-white/10 border border-white/20 text-white font-black text-xl hover:bg-white/20 transition-colors">
                {d}
              </button>
            ))}
            <div />
            <button onClick={() => handlePin("0")} className="h-14 rounded-2xl bg-white/10 border border-white/20 text-white font-black text-xl hover:bg-white/20">0</button>
            <button onClick={() => setPin((p) => p.slice(0, -1))} className="h-14 rounded-2xl bg-white/10 border border-white/20 text-white font-black text-sm hover:bg-white/20">⌫</button>
          </div>
          <p className="text-white/30 text-xs font-bold">تلميح: 1234</p>

          <button onClick={() => navigate("/")} className="mt-6 text-white/50 font-bold text-sm hover:text-white">العودة للرئيسية →</button>
        </motion.div>
      </div>
    );
  }

  const avgScore = Math.round((user.quizzesCompleted > 0 ? (user.totalStars / (user.quizzesCompleted * 3)) * 100 : 0));
  const todayMin = STUDY_TIME_DATA[6].minutes;

  return (
    <div className="min-h-screen" style={{ background: "linear-gradient(180deg, #0D1B2A 0%, #0D1B2A 100%)" }}>
      <div className="px-4 pt-6 pb-4">
        <div dir="rtl" className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center hover:bg-white/20">
            <ArrowRight className="w-4 h-4 text-white" />
          </button>
          <div>
            <h1 className="text-xl font-black text-white">لوحة الوالدين</h1>
            <p className="text-sm font-bold text-white/50">نظرة على تعلّم {user.name}</p>
          </div>
        </div>

        {/* Key stats */}
        <div className="grid grid-cols-2 gap-3 mb-5">
          {[
            { icon: Clock, label: "دراسة اليوم", value: `${todayMin} دق`, color: "#4CC9F0", bg: "rgba(76,201,240,0.1)", border: "rgba(76,201,240,0.3)" },
            { icon: BookOpen, label: "الدروس المنجزة", value: user.lessonsCompleted, color: "#06D6A0", bg: "rgba(6,214,160,0.1)", border: "rgba(6,214,160,0.3)" },
            { icon: Target, label: "متوسط الدرجات", value: `${avgScore}%`, color: "#FFD60A", bg: "rgba(255,214,10,0.1)", border: "rgba(255,214,10,0.3)" },
            { icon: Flame, label: "الأيام المتتالية", value: `${user.streak} يوم`, color: "#FF4D6D", bg: "rgba(255,77,109,0.1)", border: "rgba(255,77,109,0.3)" },
          ].map(({ icon: Icon, label, value, color, bg, border }) => (
            <motion.div key={label} initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="rounded-2xl p-4 border" style={{ backgroundColor: bg, borderColor: border }}>
              <Icon className="w-5 h-5 mb-2" style={{ color }} />
              <div className="font-black text-xl text-white">{value}</div>
              <div className="text-xs font-bold text-white/50">{label}</div>
            </motion.div>
          ))}
        </div>

        {/* Study time chart */}
        <div className="bg-white/5 border border-white/10 rounded-3xl p-5 mb-5">
          <div className="flex justify-between items-center mb-4">
            <h3 className="font-black text-white">وقت الدراسة (٧ أيام)</h3>
            <div className="flex items-center gap-1.5 text-[#4CC9F0]">
              <TrendingUp className="w-4 h-4" />
              <span className="text-xs font-black">{Math.round(STUDY_TIME_DATA.reduce((a, b) => a + b.minutes, 0) / 7)} min avg</span>
            </div>
          </div>
          <ResponsiveContainer width="100%" height={140}>
            <AreaChart data={STUDY_TIME_DATA}>
              <defs>
                <linearGradient id="grad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#4CC9F0" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#4CC9F0" stopOpacity={0} />
                </linearGradient>
              </defs>
              <XAxis dataKey="day" tick={{ fill: "rgba(255,255,255,0.4)", fontSize: 11, fontWeight: 700 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fill: "rgba(255,255,255,0.3)", fontSize: 10 }} axisLine={false} tickLine={false} width={28} />
              <Tooltip contentStyle={{ backgroundColor: "#1E3A5F", border: "1px solid rgba(76,201,240,0.3)", borderRadius: "12px", color: "white", fontWeight: 700, fontSize: 12 }} />
              <Area type="monotone" dataKey="minutes" stroke="#4CC9F0" fill="url(#grad)" strokeWidth={2.5} dot={{ fill: "#4CC9F0", strokeWidth: 0, r: 4 }} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Subject breakdown */}
        <div className="bg-white/5 border border-white/10 rounded-3xl p-5 mb-5">
          <h3 className="font-black text-white mb-4">تقدّم المواد</h3>
          <div className="space-y-4">
            {(Object.values(SUBJECTS) as typeof SUBJECTS[SubjectId][]).map((subject) => {
              const done = subject.lessons.filter((_, i) => user.completedLessons.includes(`${subject.id}-${i}`)).length;
              const pct = Math.round((done / subject.lessons.length) * 100);
              return (
                <div key={subject.id}>
                  <div className="flex justify-between items-center mb-1.5">
                    <div className="flex items-center gap-2">
                      <span>{subject.emoji}</span>
                      <span className="font-black text-sm text-white">{subject.name}</span>
                    </div>
                    <span className="text-xs font-black text-white/60">{done}/{subject.lessons.length} دروس · {pct}%</span>
                  </div>
                  <div className="h-2.5 bg-white/10 rounded-full overflow-hidden">
                    <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }} transition={{ delay: 0.3, duration: 0.6 }} className="h-full rounded-full" style={{ backgroundColor: subject.color }} />
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Summary */}
        <div className="bg-white/5 border border-white/10 rounded-3xl p-5">
          <h3 className="font-black text-white mb-3">ملخص الأسبوع</h3>
          <div className="space-y-2" dir="rtl">
            {[
              `📚 أتمّ ${user.lessonsCompleted} دروس هذا الأسبوع`,
              `🎯 أنهى ${user.quizzesCompleted} اختبارات بمتوسط ${avgScore}%`,
              `🔥 حافظ على ${user.streak} أيام تعلّم متتالية`,
              `⭐ حصل على ${user.totalStars} نجمة إجمالاً`,
              `🏅 فتح ${user.quizzesCompleted > 0 ? "3" : "0"} شارات جديدة`,
            ].map((item, i) => (
              <div key={i} className="flex items-center gap-2 text-sm font-bold text-white/70">
                <div className="w-1.5 h-1.5 rounded-full bg-[#4CC9F0] shrink-0" />
                {item}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
