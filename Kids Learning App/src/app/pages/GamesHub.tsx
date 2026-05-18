import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { useStore } from "../store";

const GAMES = [
  { path: "/games/animals", emoji: "🐾", title: "أصوات الحيوانات", desc: "تعلّم أصوات الحيوانات بالعربية", color: "#06D6A0", bg: "from-[#E8FDF6] to-[#D0F5EA]", border: "#06D6A0" },
  { path: "/games/colors",  emoji: "🌈", title: "الألوان",          desc: "تعرّف على الألوان بالعربية",    color: "#F97316", bg: "from-[#FFF7ED] to-[#FFEDD5]", border: "#F97316" },
  { path: "/games/numbers", emoji: "🔢", title: "الأرقام",          desc: "تعلّم الأرقام من ١ إلى ١٠",    color: "#4CC9F0", bg: "from-[#E0F7FA] to-[#B2EBF2]", border: "#4CC9F0" },
  { path: "/games/memory",  emoji: "🧠", title: "لعبة الذاكرة",     desc: "ابحث عن الأزواج المتشابهة",   color: "#A855F7", bg: "from-[#F3E5F5] to-[#EDE7F6]", border: "#A855F7" },
  { path: "/games/shapes",  emoji: "🔷", title: "الأشكال",          desc: "تعرّف على الأشكال الهندسية",   color: "#22C55E", bg: "from-[#F0FFF4] to-[#DCFCE7]", border: "#22C55E" },
  { path: "/games/letters", emoji: "✏️", title: "الحروف العربية",   desc: "تعلّم حروف الهجاء بالعربية",  color: "#EF4444", bg: "from-[#FFF5F5] to-[#FFE4E4]", border: "#EF4444" },
  { path: "/games/words",   emoji: "🔤", title: "كوّن الكلمة",      desc: "رتّب الحروف لتكوين كلمات",    color: "#EAB308", bg: "from-[#FEFCE8] to-[#FEF9C3]", border: "#EAB308" },
  { path: "/games/stories",  emoji: "📖", title: "القصص العربية",    desc: "اقرأ قصصاً ممتعة وأجب على الأسئلة", color: "#FF4D6D", bg: "from-[#FFF0F3] to-[#FFE0E6]", border: "#FF4D6D" },
  { path: "/games/spelling", emoji: "✍️", title: "لعبة التهجئة",    desc: "رتّب الحروف لتهجئة الكلمات",  color: "#22C55E", bg: "from-[#F0FFF4] to-[#DCFCE7]", border: "#22C55E" },
  { path: "/drawing",        emoji: "🎨", title: "تحدي الرسم",       desc: "ارسم وذكاؤنا يتعرف عليه!",   color: "#C77DFF", bg: "from-[#EDE0FF] to-[#FFF0FB]", border: "#C77DFF" },
];

export default function GamesHub() {
  const navigate = useNavigate();
  const { user } = useStore();

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#F8F9FF] to-[#EEF2FF] pb-24">
      {/* Header */}
      <div className="bg-white shadow-sm px-5 pt-10 pb-5">
        <div className="flex items-center gap-3 mb-1">
          <motion.div animate={{ rotate: [0, 10, -10, 0] }} transition={{ duration: 2, repeat: Infinity }} className="text-3xl">🎮</motion.div>
          <h1 className="text-2xl font-black text-[#1A1A2E]">الألعاب التعليمية</h1>
        </div>
        <p className="text-[#1A1A2E]/60 font-bold text-sm">تعلّم وانت تلعب يا {user.name}! 🌟</p>
      </div>

      <div className="px-5 mt-6 grid grid-cols-1 gap-4">
        {GAMES.map((game, i) => (
          <motion.button
            key={game.path}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.07 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.97 }}
            onClick={() => navigate(game.path)}
            className={`relative overflow-hidden rounded-[1.5rem] p-5 text-right bg-gradient-to-br ${game.bg} border-[3px]`}
            style={{ borderColor: game.border }}
          >
            <div className="flex items-center gap-4">
              <motion.div
                className="text-5xl"
                animate={{ scale: [1, 1.1, 1] }}
                transition={{ duration: 2, repeat: Infinity, delay: i * 0.2 }}
              >
                {game.emoji}
              </motion.div>
              <div className="flex-1">
                <h2 className="text-xl font-black text-[#1A1A2E]">{game.title}</h2>
                <p className="text-sm font-bold text-[#1A1A2E]/60 mt-0.5">{game.desc}</p>
              </div>
              <div className="text-2xl text-[#1A1A2E]/30">←</div>
            </div>
          </motion.button>
        ))}
      </div>
    </div>
  );
}
