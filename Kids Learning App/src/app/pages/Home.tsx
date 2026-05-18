import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { Flame, Star, Trophy, Zap, Map, BookOpen, Users, Palette, Gamepad2 } from "lucide-react";
import { useStore } from "../store";

function GeomDecor() {
  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none" aria-hidden="true">
      <div className="absolute -top-12 -right-12 w-48 h-48 rounded-full bg-[#FFD60A] opacity-15" />
      <div className="absolute -bottom-8 -left-8 w-36 h-36 rounded-full bg-[#FF4D6D] opacity-15" />
      <div className="absolute top-8 right-32 opacity-25" style={{ width: 0, height: 0, borderLeft: "20px solid transparent", borderRight: "20px solid transparent", borderBottom: "34px solid #06D6A0" }} />
      <div className="absolute top-1/2 right-4 w-3 h-20 rounded-full bg-[#C77DFF] opacity-30 rotate-12" />
      <div className="absolute bottom-12 right-16 w-6 h-6 rounded bg-[#4CC9F0] opacity-35 rotate-45" />
    </div>
  );
}

export default function Home() {
  const navigate = useNavigate();
  const { user } = useStore();
  const xpPct = Math.round((user.xp / user.xpToNext) * 100);

  const avatarEmojis: Record<string, string> = { fox: "🦊", bunny: "🐰", dragon: "🐲", owl: "🦉", tiger: "🐯" };
  const hatEmojis: Record<string, string> = { "hat-none": "", "hat-crown": "👑", "hat-wizard": "🎩", "hat-cap": "🧢", "hat-party": "🎊" };
  const avatar = avatarEmojis[user.avatarBase] ?? "🦊";
  const hat = hatEmojis[user.avatarHat] ?? "";

  return (
    <div dir="rtl" className="px-4 py-6 space-y-5">
      {/* Hero */}
      <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }} className="relative overflow-hidden bg-[#1A1A2E] rounded-[2rem] p-6 text-white">
        <GeomDecor />
        <div className="relative flex items-center gap-4">
          <div className="relative shrink-0">
            <div className="w-[72px] h-[72px] rounded-[1.25rem] bg-[#FFD60A] flex items-center justify-center text-[2.4rem] shadow-lg select-none">
              {avatar}
            </div>
            {hat && <span className="absolute -top-3 left-1/2 -translate-x-1/2 text-lg select-none">{hat}</span>}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-[10px] text-white/50 font-black tracking-widest">أهلاً بعودتك</p>
            <h1 className="text-2xl font-black mt-0.5 leading-tight">مرحباً يا {user.name}! 👋</h1>
            <p className="text-sm text-white/60 font-bold mt-1">المستوى {user.level}</p>
          </div>
          <div className="text-left shrink-0">
            <div className="text-2xl font-black text-[#FFD60A]">{user.totalStars}</div>
            <div className="text-[10px] text-white/50 font-black">نجمة</div>
          </div>
        </div>

        {/* XP Bar */}
        <div className="relative mt-5 pt-4 border-t border-white/10">
          <div className="flex justify-between items-center mb-2">
            <span className="text-xs font-black text-white/70">المستوى {user.level} ← {user.level + 1}</span>
            <span className="text-xs font-black text-[#FFD60A]">{user.xp} / {user.xpToNext} نقطة</span>
          </div>
          <div className="h-2.5 bg-white/10 rounded-full overflow-hidden">
            <motion.div initial={{ width: 0 }} animate={{ width: `${xpPct}%` }} transition={{ delay: 0.4, duration: 0.8, ease: "easeOut" }} className="h-full rounded-full bg-gradient-to-r from-[#FFD60A] to-[#FF9500]" />
          </div>
          <div className="flex gap-3 mt-4 flex-wrap">
            {[
              { icon: Flame, label: `${user.streak} يوم متتالي`, color: "#FF4D6D" },
              { icon: Star, label: `${user.coins} عملة`, color: "#FFD60A" },
              { icon: Zap, label: `${user.lessonsCompleted} درس`, color: "#06D6A0" },
            ].map(({ icon: Icon, label, color }) => (
              <div key={label} className="flex items-center gap-1.5 bg-white/10 rounded-xl px-3 py-1.5">
                <Icon className="w-3.5 h-3.5" style={{ color }} />
                <span className="text-xs font-black">{label}</span>
              </div>
            ))}
          </div>
        </div>
      </motion.div>

      {/* Games — big CTA */}
      <motion.button
        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.08 }}
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={() => navigate("/games")}
        className="w-full relative overflow-hidden rounded-[1.75rem] p-6 text-right border-[3px] border-[#06D6A0] bg-gradient-to-br from-[#E8FDF6] to-[#C8F7EC]"
      >
        <div className="absolute -top-6 -left-6 w-32 h-32 rounded-full bg-[#06D6A0] opacity-20" />
        <div className="relative flex items-center gap-4">
          <div className="w-16 h-16 rounded-2xl bg-[#06D6A0] flex items-center justify-center text-3xl shadow-lg">🎮</div>
          <div>
            <p className="text-[10px] font-black uppercase tracking-widest text-[#1A1A2E]/50">العب وتعلّم</p>
            <h2 className="text-xl font-black text-[#1A1A2E] mt-0.5">الألعاب التعليمية</h2>
            <p className="text-sm font-bold text-[#1A1A2E]/60 mt-0.5">٧ ألعاب تفاعلية بالعربية</p>
          </div>
          <Gamepad2 className="mr-auto w-6 h-6 text-[#1A1A2E]/30" />
        </div>
      </motion.button>

      {/* Course Categories */}
      <motion.button
        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={() => navigate("/categories")}
        className="w-full relative overflow-hidden rounded-[1.75rem] p-6 text-right border-[3px] border-[#FFD60A] bg-gradient-to-br from-[#FFF9D6] to-[#FFF3A0]"
      >
        <div className="absolute -top-6 -left-6 w-32 h-32 rounded-full bg-[#FFD60A] opacity-20" />
        <div className="relative flex items-center gap-4">
          <div className="w-16 h-16 rounded-2xl bg-[#FFD60A] flex items-center justify-center text-3xl shadow-lg">📚</div>
          <div>
            <p className="text-[10px] font-black uppercase tracking-widest text-[#1A1A2E]/50">ابدأ التعلّم</p>
            <h2 className="text-xl font-black text-[#1A1A2E] mt-0.5">الدروس التعليمية</h2>
            <p className="text-sm font-bold text-[#1A1A2E]/60 mt-0.5">رياضيات، قراءة، علوم، فنون</p>
          </div>
          <BookOpen className="mr-auto w-6 h-6 text-[#1A1A2E]/30" />
        </div>
      </motion.button>

      {/* Two-column row */}
      <div className="grid grid-cols-2 gap-4">
        <motion.button
          initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}
          whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
          onClick={() => navigate("/rewards")}
          className="relative overflow-hidden rounded-[1.5rem] p-5 text-right border-[3px] border-[#C77DFF] bg-gradient-to-br from-[#F5E6FF] to-[#EDE0FF]"
        >
          <div className="absolute -top-4 -left-4 w-20 h-20 rounded-full bg-[#C77DFF] opacity-20" />
          <div className="text-3xl mb-3 select-none">🏆</div>
          <h3 className="font-black text-[#1A1A2E] text-sm leading-tight">الجوائز</h3>
          <p className="text-[10px] font-bold text-[#1A1A2E]/55 mt-1">{user.totalStars} نجمة</p>
          <Trophy className="absolute bottom-4 left-4 w-5 h-5 text-[#C77DFF]/40" />
        </motion.button>

        <motion.button
          initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.18 }}
          whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
          onClick={() => navigate("/challenge")}
          className="relative overflow-hidden rounded-[1.5rem] p-5 text-right border-[3px] border-[#FF6B35] bg-gradient-to-br from-[#FFF0E8] to-[#FFE4D0]"
        >
          <div className="absolute -top-4 -left-4 w-20 h-20 rounded-full bg-[#FF6B35] opacity-20" />
          <div className="text-3xl mb-3 select-none">🔥</div>
          <h3 className="font-black text-[#1A1A2E] text-sm leading-tight">تحدي اليوم</h3>
          <p className="text-[10px] font-bold text-[#1A1A2E]/55 mt-1">{user.challengeCompletedToday ? "أنجزته اليوم! ✓" : "جديد اليوم!"}</p>
          <Flame className="absolute bottom-4 left-4 w-5 h-5 text-[#FF6B35]/40" />
        </motion.button>
      </div>

      {/* Learning Map */}
      <motion.button
        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.22 }}
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={() => navigate("/map")}
        className="w-full relative overflow-hidden rounded-[1.75rem] p-6 text-right border-[3px] border-[#4CC9F0]"
        style={{ background: "linear-gradient(135deg, #0A1A3A 0%, #0D2545 100%)" }}
      >
        <div className="absolute inset-0 opacity-30">
          {[...Array(12)].map((_, i) => (
            <div key={i} className="absolute w-1 h-1 rounded-full bg-white" style={{ left: `${(i * 37 + 11) % 90 + 5}%`, top: `${(i * 53 + 17) % 80 + 10}%`, opacity: 0.3 + (i % 3) * 0.2 }} />
          ))}
        </div>
        <div className="relative flex items-center gap-4">
          <div className="w-16 h-16 rounded-2xl bg-[#4CC9F0]/20 border-2 border-[#4CC9F0]/40 flex items-center justify-center text-3xl">🗺️</div>
          <div>
            <p className="text-[10px] font-black uppercase tracking-widest text-[#4CC9F0]/60">مغامرة تعليمية</p>
            <h2 className="text-xl font-black text-white mt-0.5">خريطة التعلّم</h2>
            <p className="text-sm font-bold text-white/50 mt-0.5">استكشف ٥ جزر سحرية</p>
          </div>
          <Map className="mr-auto w-6 h-6 text-[#4CC9F0]/50" />
        </div>
      </motion.button>

      {/* Progress + Parent row */}
      <div className="grid grid-cols-2 gap-4">
        <motion.button
          initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }}
          whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
          onClick={() => navigate("/progress")}
          className="relative overflow-hidden rounded-[1.5rem] p-5 text-right border-[3px] border-[#06D6A0] bg-gradient-to-br from-[#E8FDF6] to-[#D6F8EF]"
        >
          <div className="text-3xl mb-3 select-none">📊</div>
          <h3 className="font-black text-[#1A1A2E] text-sm">تقدّمي</h3>
          <p className="text-[10px] font-bold text-[#1A1A2E]/55 mt-1">تابع رحلتك</p>
        </motion.button>

        <motion.button
          initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.27 }}
          whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.97 }}
          onClick={() => navigate("/parent")}
          className="relative overflow-hidden rounded-[1.5rem] p-5 text-right border-[3px] border-[#6B7280] bg-gradient-to-br from-[#F3F4F6] to-[#E9EBF0]"
        >
          <div className="text-3xl mb-3 select-none">👨‍👩‍👧</div>
          <h3 className="font-black text-[#1A1A2E] text-sm">لوحة الوالدين</h3>
          <p className="text-[10px] font-bold text-[#1A1A2E]/55 mt-1">تقرير التقدّم</p>
          <Users className="absolute bottom-4 left-4 w-5 h-5 text-[#6B7280]/30" />
        </motion.button>
      </div>

      {/* Drawing Challenge — AI powered */}
      <motion.button
        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={() => navigate("/drawing")}
        className="w-full relative overflow-hidden rounded-[1.75rem] p-6 text-right border-[3px] border-[#C77DFF] bg-gradient-to-br from-[#EDE0FF] to-[#FFF0FB]"
      >
        <div className="absolute -top-6 -left-6 w-32 h-32 rounded-full bg-[#C77DFF] opacity-15" />
        <div className="relative flex items-center gap-4">
          <div className="w-16 h-16 rounded-2xl bg-[#C77DFF]/20 border-2 border-[#C77DFF]/40 flex items-center justify-center text-3xl">🎨</div>
          <div>
            <p className="text-[10px] font-black uppercase tracking-widest text-[#C77DFF]/70">بالذكاء الاصطناعي</p>
            <h2 className="text-xl font-black text-[#1A1A2E] mt-0.5">تحدي الرسم</h2>
            <p className="text-sm font-bold text-[#1A1A2E]/60 mt-0.5">ارسم والذكاء الاصطناعي يتعرف!</p>
          </div>
          <Palette className="mr-auto w-6 h-6 text-[#C77DFF]/50" />
        </div>
      </motion.button>

      {/* Character greeting */}
      <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.35 }} className="flex items-end gap-3 pb-2">
        <div className="relative bg-card rounded-2xl rounded-br-none p-3.5 border-2 border-[#FFD60A] flex-1 shadow-sm">
          <div className="absolute -right-3 bottom-3 w-0 h-0" style={{ borderTop: "7px solid transparent", borderBottom: "7px solid transparent", borderLeft: "11px solid #FFD60A" }} />
          <p className="text-sm font-bold text-foreground leading-relaxed">
            "استمر يا {user.name}! لديك {user.streak} أيام متتالية — هذا رائع! 🔥 لنواصل اليوم!"
          </p>
        </div>
        <motion.div animate={{ y: [0, -6, 0] }} transition={{ repeat: Infinity, duration: 2.2, ease: "easeInOut" }} className="text-5xl select-none shrink-0">{avatar}</motion.div>
      </motion.div>
    </div>
  );
}
