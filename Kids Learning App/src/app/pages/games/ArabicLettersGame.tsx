import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useNavigate } from "react-router";
import { useStore } from "../../store";

const LETTERS = [
  { letter: "أ", word: "أسد", emoji: "🦁" },
  { letter: "ب", word: "بطة", emoji: "🦆" },
  { letter: "ت", word: "تفاحة", emoji: "🍎" },
  { letter: "ث", word: "ثعلب", emoji: "🦊" },
  { letter: "ج", word: "جمل", emoji: "🐪" },
  { letter: "ح", word: "حصان", emoji: "🐴" },
  { letter: "خ", word: "خروف", emoji: "🐑" },
  { letter: "د", word: "دجاجة", emoji: "🐔" },
  { letter: "ذ", word: "ذئب", emoji: "🐺" },
  { letter: "ر", word: "ربع", emoji: "🌸" },
  { letter: "ز", word: "زهرة", emoji: "🌺" },
  { letter: "س", word: "سمكة", emoji: "🐠" },
  { letter: "ش", word: "شمس", emoji: "☀️" },
  { letter: "ص", word: "صقر", emoji: "🦅" },
  { letter: "ط", word: "طائر", emoji: "🐦" },
  { letter: "ع", word: "عصفور", emoji: "🐤" },
  { letter: "ف", word: "فيل", emoji: "🐘" },
  { letter: "ق", word: "قطة", emoji: "🐱" },
  { letter: "ك", word: "كلب", emoji: "🐶" },
  { letter: "ل", word: "لمبة", emoji: "💡" },
  { letter: "م", word: "مدرسة", emoji: "🏫" },
  { letter: "ن", word: "نجمة", emoji: "⭐" },
  { letter: "ه", word: "هرة", emoji: "😺" },
  { letter: "و", word: "وردة", emoji: "🌹" },
  { letter: "ي", word: "يد", emoji: "✋" },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

type Mode = "learn" | "match";

export default function ArabicLettersGame() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [mode, setMode] = useState<Mode>("learn");
  const [learnIdx, setLearnIdx] = useState(0);
  const [quizIdx, setQuizIdx] = useState(0);
  const [score, setScore] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [choices, setChoices] = useState<typeof LETTERS>([]);
  const [done, setDone] = useState(false);
  const [quizLetters] = useState(() => shuffle(LETTERS).slice(0, 10));

  function speak(text: string) {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = "ar-SA";
    u.rate = 0.8;
    speechSynthesis.speak(u);
  }

  const current = quizLetters[quizIdx];

  function nextQuiz(i: number) {
    const t = quizLetters[i];
    const wrong = shuffle(LETTERS.filter((l) => l.letter !== t.letter)).slice(0, 3);
    setChoices(shuffle([t, ...wrong]));
    setSelected(null);
    speak(`اختر كلمة تبدأ بحرف ${t.letter}`);
  }

  function startQuiz() {
    setMode("match");
    setQuizIdx(0);
    setScore(0);
    nextQuiz(0);
  }

  function handlePick(letter: string) {
    if (selected) return;
    setSelected(letter);
    if (letter === current.letter) {
      setScore((s) => s + 1);
      speak(`أحسنت! ${current.word} تبدأ بحرف ${current.letter}`);
    } else {
      speak(`الكلمة ${current.word} تبدأ بحرف ${current.letter}`);
    }
    setTimeout(() => {
      if (quizIdx + 1 >= quizLetters.length) {
        setDone(true);
        dispatch({ type: "COMPLETE_QUIZ", subjectId: "reading", score, total: quizLetters.length });
      } else {
        setQuizIdx((i) => { nextQuiz(i + 1); return i + 1; });
      }
    }, 1500);
  }

  if (done) {
    return (
      <div dir="rtl" className="min-h-screen bg-gradient-to-br from-[#FFF3E0] to-[#FFE0B2] flex items-center justify-center p-6">
        <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="bg-white rounded-3xl p-8 text-center shadow-2xl">
          <div className="text-7xl mb-4">📚</div>
          <h2 className="text-3xl font-black text-[#1A1A2E] mb-2">ممتاز يا {user.name}!</h2>
          <p className="text-xl font-bold text-gray-600 mb-6">أتقنت {score} من {quizLetters.length} حرفاً</p>
          <div className="flex gap-3 justify-center">
            <button onClick={() => { setMode("learn"); setDone(false); }} className="bg-[#F97316] text-white font-black py-3 px-6 rounded-2xl">العب مجدداً</button>
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
        <h1 className="text-lg font-black text-[#1A1A2E]">الحروف العربية ✏️</h1>
        {mode === "match" && <div className="bg-[#FFD60A] rounded-full px-3 py-1 font-black text-sm">{score}/{quizLetters.length}</div>}
        {mode === "learn" && <div className="w-10" />}
      </div>

      {/* LEARN MODE */}
      {mode === "learn" && (
        <div className="px-5 mt-4">
          <p className="text-center text-[#1A1A2E]/60 font-bold mb-4">تعلّم الحروف أولاً، ثم العب!</p>

          {/* Letter grid */}
          <div className="grid grid-cols-5 gap-2 mb-6">
            {LETTERS.map((l, i) => (
              <motion.button
                key={l.letter}
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => { setLearnIdx(i); speak(`${l.letter} — ${l.word}`); }}
                className={`aspect-square rounded-2xl font-black text-2xl flex items-center justify-center border-2 transition-all ${
                  learnIdx === i ? "bg-[#F97316] text-white border-[#F97316]" : "bg-white text-[#1A1A2E] border-[#E2E8F0]"
                }`}
              >
                {l.letter}
              </motion.button>
            ))}
          </div>

          <AnimatePresence mode="wait">
            <motion.div
              key={learnIdx}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              className="bg-white rounded-3xl p-6 shadow-lg flex flex-col items-center mb-6"
            >
              <div className="text-8xl font-black text-[#F97316] mb-2">{LETTERS[learnIdx].letter}</div>
              <div className="text-5xl mb-2">{LETTERS[learnIdx].emoji}</div>
              <div className="text-2xl font-black text-[#1A1A2E] mb-3">{LETTERS[learnIdx].word}</div>
              <button
                onClick={() => speak(`${LETTERS[learnIdx].letter} — ${LETTERS[learnIdx].word}`)}
                className="bg-[#FFF3E0] rounded-2xl px-5 py-2 font-bold text-sm text-[#F97316]"
              >
                🔊 استمع
              </button>
            </motion.div>
          </AnimatePresence>

          <button onClick={startQuiz} className="w-full bg-[#F97316] text-white font-black text-xl rounded-2xl py-4 shadow-lg">
            ابدأ اللعبة! ▶
          </button>
        </div>
      )}

      {/* QUIZ MODE */}
      {mode === "match" && (
        <div className="px-5 mt-4">
          <div className="bg-white/60 rounded-full h-3 mb-1">
            <motion.div className="bg-[#F97316] h-3 rounded-full" animate={{ width: `${(quizIdx / quizLetters.length) * 100}%` }} />
          </div>
          <p className="text-center text-sm font-bold text-[#1A1A2E]/60 mb-6">سؤال {quizIdx + 1} من {quizLetters.length}</p>

          <AnimatePresence mode="wait">
            <motion.div key={quizIdx} initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0 }} className="flex flex-col items-center">
              <motion.div
                className="text-9xl font-black text-[#F97316] mb-2 cursor-pointer"
                animate={{ scale: [1, 1.05, 1] }}
                transition={{ duration: 2, repeat: Infinity }}
                onClick={() => speak(`اختر كلمة تبدأ بحرف ${current.letter}`)}
              >
                {current.emoji}
              </motion.div>
              <p className="text-xl font-black text-[#1A1A2E] mb-1">هذه الكلمة تبدأ بأي حرف؟</p>
              <p className="text-3xl font-black text-[#F97316] mb-6">{current.word}</p>

              <div className="grid grid-cols-2 gap-4 w-full max-w-sm">
                {choices.map((c) => {
                  const isSelected = selected === c.letter;
                  const isCorrect = c.letter === current.letter;
                  return (
                    <motion.button
                      key={c.letter}
                      whileHover={{ scale: selected ? 1 : 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handlePick(c.letter)}
                      className={`py-6 rounded-2xl font-black text-4xl border-3 transition-all ${
                        isSelected && isCorrect ? "bg-[#06D6A0] border-[#06D6A0] text-white" :
                        isSelected && !isCorrect ? "bg-[#FF4D6D] border-[#FF4D6D] text-white" :
                        selected && isCorrect ? "bg-[#06D6A0]/10 border-[#06D6A0] text-[#06D6A0]" :
                        "bg-white border-[#E2E8F0] text-[#1A1A2E]"
                      }`}
                      style={{ borderWidth: 3 }}
                    >
                      {c.letter}
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>
          </AnimatePresence>
        </div>
      )}
    </div>
  );
}
