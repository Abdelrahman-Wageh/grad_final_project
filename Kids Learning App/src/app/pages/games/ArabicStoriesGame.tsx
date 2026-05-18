import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const STORIES = [
  {
    title: "الأسد والفأر",
    emoji: "🦁",
    pages: [
      { text: "في يوم من الأيام، كان أسد كبير نائماً في الغابة. فجأة جاء فأر صغير يلعب حوله.", emoji: "😴🐭" },
      { text: "استيقظ الأسد على صوت الفأر فغضب وأمسك به. قال الفأر: 'أرجوك أطلق سراحي، سأساعدك يوماً ما!'", emoji: "😠🐭" },
      { text: "ضحك الأسد وأطلق سراح الفأر. بعد أيام، وقع الأسد في شبكة الصيادين وصاح طالباً النجدة.", emoji: "🦁🕸️" },
      { text: "سمع الفأر صرخة الأسد فجاء وقضم الشبكة بأسنانه الحادة حتى تحرر الأسد. قال الأسد: 'شكراً صديقي الصغير!'", emoji: "🐭✂️🦁" },
    ],
    question: "ما الدرس المستفاد من هذه القصة؟",
    options: ["الأسد أقوى من الفأر", "المعروف لا يضيع ومهما صغر فضل أحد فقد يعود بالنفع", "الفأر لا يستطيع مساعدة الأسد", "يجب النوم في الغابة"],
    correct: 1,
  },
  {
    title: "الغراب والثعلب",
    emoji: "🦅",
    pages: [
      { text: "وجد غراب ذكي قطعة جبن لذيذة ووقف على غصن شجرة عالية يتأملها فرحاً.", emoji: "🐦🧀" },
      { text: "مرّ ثعلب ماكر ورأى الغراب والجبن فأراد أن يحتال عليه لأخذ الجبن.", emoji: "🦊👀" },
      { text: "قال الثعلب: 'يا غراب، لقد سمعت أن صوتك أجمل من كل الطيور! هل تغني لي أغنية؟'", emoji: "🦊🎵" },
      { text: "فتح الغراب فمه ليغني فسقطت الجبنة. أخذها الثعلب وقال: 'لا تُصدِّق كل مَن يمدحك!' وابتعد ضاحكاً.", emoji: "🐦😱🦊" },
    ],
    question: "ماذا كان خطأ الغراب؟",
    options: ["وقف على الشجرة", "صدّق مديح الثعلب الماكر وفتح فمه ليغني", "أكل الجبن وحده", "لم يطِر بعيداً"],
    correct: 1,
  },
  {
    title: "النملة والجندب",
    emoji: "🐜",
    pages: [
      { text: "في فصل الصيف، كانت النملة تعمل طوال اليوم تجمع الطعام وتخزنه للشتاء.", emoji: "🐜☀️" },
      { text: "كان الجندب يغني ويلهو طوال الصيف ويقول: 'الصيف طويل، سأعمل لاحقاً!'", emoji: "🦗🎵" },
      { text: "جاء الشتاء بثلجه وبرده. لم يجد الجندب طعاماً وشعر بالجوع الشديد.", emoji: "🦗❄️😢" },
      { text: "ذهب الجندب إلى النملة طالباً الطعام. قالت النملة: 'كنتِ تغنين في الصيف؟ الآن ارقصي!' ثم رقّت قلبها وأعطته طعاماً وقالت: 'تعلّم أن تعمل قبل أن تلهو!'", emoji: "🐜🤝🦗" },
    ],
    question: "ما الدرس من قصة النملة والجندب؟",
    options: ["الغناء أهم من العمل", "يجب العمل والاستعداد للمستقبل قبل اللهو", "الشتاء لا يأتي أبداً", "النمل لا يأكل"],
    correct: 1,
  },
];

function speak(text: string) {
  speechSynthesis.cancel();
  const u = new SpeechSynthesisUtterance(text);
  u.lang = "ar-SA";
  u.rate = 0.82;
  speechSynthesis.speak(u);
}

export default function ArabicStoriesGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [storyIdx, setStoryIdx] = useState(0);
  const [pageIdx, setPageIdx] = useState(0);
  const [phase, setPhase] = useState<"read" | "quiz" | "done">("read");
  const [selected, setSelected] = useState<number | null>(null);
  const [score, setScore] = useState(0);

  const story = STORIES[storyIdx];
  const page = story.pages[pageIdx];
  const isLastPage = pageIdx >= story.pages.length - 1;

  function nextPage() {
    if (!isLastPage) {
      setPageIdx((p) => p + 1);
      speak(story.pages[pageIdx + 1].text);
    } else {
      setPhase("quiz");
      speak(story.question);
    }
  }

  function handleAnswer(idx: number) {
    if (selected !== null) return;
    setSelected(idx);
    const correct = idx === story.correct;
    if (correct) {
      setScore((s) => s + 1);
      speak("أحسنت! إجابة صحيحة!");
    } else {
      speak("الإجابة الصحيحة هي: " + story.options[story.correct]);
    }
    setTimeout(() => {
      if (storyIdx + 1 >= STORIES.length) {
        setPhase("done");
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "reading", score: score + (correct ? 1 : 0), total: STORIES.length });
      } else {
        setStoryIdx((s) => s + 1);
        setPageIdx(0);
        setPhase("read");
        setSelected(null);
        speak(STORIES[storyIdx + 1].pages[0].text);
      }
    }, 2000);
  }

  if (phase === "done") {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#FFF3E0] to-[#FFE0B2] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl max-w-sm w-full">
          <div className="text-7xl mb-4">📖</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">ممتاز يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">أجبت على {score} من {STORIES.length} أسئلة صحيحة</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setStoryIdx(0); setPageIdx(0); setPhase("read"); setScore(0); setSelected(null); }} className="bg-[#FF4D6D] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
            <button onClick={() => navigate("/games")} className="bg-[#4CC9F0] text-white font-black py-3 px-6 rounded-2xl">الألعاب</button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#FFF8F0] to-[#FFEDD5] pb-8">
      <div className="bg-white/80 backdrop-blur px-5 py-4 flex items-center justify-between">
        <button onClick={() => navigate("/games")} className="text-2xl">←</button>
        <h1 className="text-lg font-black text-[#1A1A2E]">القصص العربية 📖</h1>
        <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{storyIdx + 1}/{STORIES.length}</div>
      </div>

      <div className="px-5 mt-5">
        {/* Story title */}
        <motion.div key={storyIdx} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-white rounded-3xl p-5 shadow-md mb-4 text-center">
          <div className="text-5xl mb-2">{story.emoji}</div>
          <h2 className="text-2xl font-black text-[#1A1A2E]">{story.title}</h2>
          <div className="flex justify-center gap-1 mt-3">
            {story.pages.map((_, i) => (
              <div key={i} className="h-2 rounded-full transition-all" style={{ width: i === pageIdx ? "20px" : "8px", backgroundColor: i <= pageIdx ? "#FF4D6D" : "#E2E8F0" }} />
            ))}
          </div>
        </motion.div>

        {phase === "read" && (
          <AnimatePresence mode="wait">
            <motion.div key={pageIdx} initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }} className="bg-white rounded-3xl p-6 shadow-lg mb-5">
              <div className="text-5xl text-center mb-4">{page.emoji}</div>
              <p className="text-lg font-bold text-[#1A1A2E] leading-relaxed text-center">{page.text}</p>
              <button onClick={() => speak(page.text)} className="mt-4 w-full bg-[#FFF3E0] rounded-2xl py-2 font-bold text-[#FF4D6D] text-sm">
                🔊 استمع
              </button>
            </motion.div>
          </AnimatePresence>
        )}

        {phase === "read" && (
          <motion.button
            whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
            onClick={nextPage}
            className="w-full bg-[#FF4D6D] text-white font-black text-xl rounded-2xl py-4 shadow-lg"
          >
            {isLastPage ? "الآن أجب على السؤال! 🤔" : "الصفحة التالية ←"}
          </motion.button>
        )}

        {phase === "quiz" && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
            <div className="bg-white rounded-3xl p-5 shadow-md mb-4">
              <p className="text-lg font-black text-[#1A1A2E] text-center">{story.question}</p>
            </div>
            <div className="space-y-3">
              {story.options.map((opt, i) => {
                const isSelected = selected === i;
                const isCorrect = i === story.correct;
                return (
                  <motion.button
                    key={i}
                    whileHover={selected === null ? { scale: 1.02 } : {}}
                    whileTap={selected === null ? { scale: 0.97 } : {}}
                    onClick={() => handleAnswer(i)}
                    className={`w-full text-right p-4 rounded-2xl font-bold border-2 transition-all ${
                      isSelected && isCorrect ? "bg-[#06D6A0]/20 border-[#06D6A0] text-[#06D6A0]" :
                      isSelected && !isCorrect ? "bg-[#FF4D6D]/10 border-[#FF4D6D] text-[#FF4D6D]" :
                      selected !== null && isCorrect ? "bg-[#06D6A0]/10 border-[#06D6A0] text-[#06D6A0]" :
                      "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                    }`}
                  >
                    {opt}
                  </motion.button>
                );
              })}
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
}
