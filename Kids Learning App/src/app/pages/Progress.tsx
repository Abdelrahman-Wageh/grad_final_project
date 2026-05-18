import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowRight } from "lucide-react";
import { SUBJECTS } from "../data";
import type { SubjectId } from "../data";
import { useStore, getEarnedBadgeIds } from "../store";

const DAYS = ["إ", "ث", "أ", "خ", "ج", "س", "أح"];
const STUDY_MINS = [20, 35, 15, 42, 28, 55, 24];

function StatCard({ label, value, sub, color, emoji }: { label: string; value: string | number; sub?: string; color: string; emoji: string }) {
  return (
    <div className="rounded-2xl p-4 border-2 border-border bg-card">
      <div className="text-2xl mb-1 select-none">{emoji}</div>
      <div className="font-black text-2xl" style={{ color }}>{value}</div>
      <div className="font-black text-xs text-foreground">{label}</div>
      {sub && <div className="text-[10px] font-bold text-muted-foreground mt-0.5">{sub}</div>}
    </div>
  );
}

export default function Progress() {
  const navigate = useNavigate();
  const { user } = useStore();
  const earnedBadges = getEarnedBadgeIds(user);
  const xpPct = Math.round((user.xp / user.xpToNext) * 100);
  const avgStudy = Math.round(STUDY_MINS.reduce((a, b) => a + b, 0) / STUDY_MINS.length);
  const todayStudy = STUDY_MINS[6];

  return (
    <div dir="rtl" className="px-4 py-6">
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-card border-2 border-border flex items-center justify-center hover:bg-muted">
          <ArrowRight className="w-4 h-4" />
        </button>
        <div>
          <h1 className="text-2xl font-black">تقدّمي</h1>
          <p className="text-sm font-bold text-muted-foreground">تابع رحلتك التعليمية</p>
        </div>
      </div>

      {/* Level + XP */}
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} className="rounded-[1.75rem] p-6 border-[3px] border-[#C77DFF] bg-gradient-to-br from-[#F5E6FF] to-[#EDE0FF] mb-5">
        <div className="flex justify-between items-start mb-3">
          <div>
            <p className="text-[10px] font-black uppercase tracking-widest text-[#C77DFF]">المستوى الحالي</p>
            <h2 className="text-4xl font-black text-[#1A1A2E]">{user.level}</h2>
          </div>
          <div className="text-right">
            <p className="text-[10px] font-black uppercase tracking-widest text-[#1A1A2E]/50">المستوى التالي</p>
            <p className="text-lg font-black text-[#C77DFF]">{user.xpToNext - user.xp} نقطة متبقية</p>
          </div>
        </div>
        <div className="h-4 bg-white/60 rounded-full overflow-hidden border border-[#C77DFF]/30">
          <motion.div initial={{ width: 0 }} animate={{ width: `${xpPct}%` }} transition={{ delay: 0.3, duration: 0.8 }} className="h-full rounded-full bg-gradient-to-r from-[#C77DFF] to-[#FF4D6D]" />
        </div>
        <div className="flex justify-between mt-1.5">
          <span className="text-xs font-black text-[#1A1A2E]/50">{user.xp} نقطة</span>
          <span className="text-xs font-black text-[#1A1A2E]/50">{user.xpToNext} نقطة</span>
        </div>
      </motion.div>

      {/* Stats grid */}
      <div className="grid grid-cols-2 gap-3 mb-5">
        <StatCard label="الأيام المتتالية" value={user.streak} sub="واصل هكذا!" color="#FF4D6D" emoji="🔥" />
        <StatCard label="إجمالي النجوم" value={user.totalStars} sub="رائع!" color="#FFD60A" emoji="⭐" />
        <StatCard label="الدروس المنجزة" value={user.lessonsCompleted} sub={`متوسط ${user.lessonsCompleted * 5} دقيقة`} color="#06D6A0" emoji="📚" />
        <StatCard label="الشارات المكتسبة" value={`${earnedBadges.length}/10`} sub="استمر في الفتح!" color="#C77DFF" emoji="🏅" />
      </div>

      {/* Weekly activity */}
      <div className="bg-card border-2 border-border rounded-3xl p-5 mb-5">
        <h3 className="font-black text-base mb-4">هذا الأسبوع</h3>
        <div className="flex gap-1.5 items-end h-24 mb-2">
          {STUDY_MINS.map((mins, i) => {
            const h = Math.round((mins / 55) * 100);
            const isToday = i === 6;
            return (
              <div key={i} className="flex-1 flex flex-col items-center gap-1">
                <motion.div
                  initial={{ height: 0 }} animate={{ height: `${h}%` }}
                  transition={{ delay: i * 0.06, duration: 0.5, ease: "easeOut" }}
                  className="w-full rounded-t-lg"
                  style={{ backgroundColor: isToday ? "#FF4D6D" : "#F3EEE4" }}
                />
                <span className="text-[10px] font-black text-muted-foreground">{DAYS[i]}</span>
              </div>
            );
          })}
        </div>
        <div className="flex justify-between text-xs font-bold text-muted-foreground">
          <span>اليوم: {todayStudy} دقيقة</span>
          <span>المتوسط: {avgStudy} د/يوم</span>
        </div>
      </div>

      {/* Subject breakdown */}
      <div className="bg-card border-2 border-border rounded-3xl p-5 mb-5">
        <h3 className="font-black text-base mb-4">تقدّم المواد</h3>
        <div className="space-y-3">
          {(Object.values(SUBJECTS) as typeof SUBJECTS[SubjectId][]).map((subject) => {
            const done = subject.lessons.filter((_, i) => user.completedLessons.includes(`${subject.id}-${i}`)).length;
            const pct = Math.round((done / subject.lessons.length) * 100);
            return (
              <div key={subject.id}>
                <div className="flex justify-between items-center mb-1">
                  <div className="flex items-center gap-2">
                    <span className="text-lg">{subject.emoji}</span>
                    <span className="font-black text-sm">{subject.name}</span>
                  </div>
                  <span className="text-xs font-black" style={{ color: subject.color }}>{done}/{subject.lessons.length} دروس</span>
                </div>
                <div className="h-2.5 bg-muted rounded-full overflow-hidden">
                  <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }} transition={{ delay: 0.3, duration: 0.6 }} className="h-full rounded-full" style={{ backgroundColor: subject.color }} />
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Streak calendar */}
      <div className="bg-card border-2 border-border rounded-3xl p-5">
        <h3 className="font-black text-base mb-4">تقويم الانتظام 🔥</h3>
        <div className="grid grid-cols-7 gap-2 mb-2">
          {DAYS.map((d) => <div key={d} className="text-center text-[10px] font-black text-muted-foreground">{d}</div>)}
        </div>
        <div className="grid grid-cols-7 gap-2">
          {Array.from({ length: 28 }).map((_, i) => {
            const active = i >= 28 - user.streak;
            const isToday = i === 27;
            return (
              <motion.div
                key={i}
                initial={{ scale: 0 }} animate={{ scale: 1 }}
                transition={{ delay: i * 0.015 }}
                className="aspect-square rounded-lg"
                style={{ backgroundColor: active ? (isToday ? "#FF4D6D" : "#FFD60A") : "#F3EEE4" }}
              />
            );
          })}
        </div>
        <p className="text-xs font-bold text-muted-foreground mt-3 text-center">{user.streak} أيام متتالية — رائع!</p>
      </div>
    </div>
  );
}
