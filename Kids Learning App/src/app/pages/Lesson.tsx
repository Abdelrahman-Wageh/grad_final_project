import { useState, useRef, useEffect } from "react";
import { useNavigate, useParams } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, Star, Mic, MicOff, Loader2 } from "lucide-react";
import { SUBJECTS } from "../data";
import type { SubjectId } from "../data";
import { useStore } from "../store";
import { adventureSpeech, playAudioBase64 } from "../api";

const avatarEmojis: Record<string, string> = { fox: "🦊", bunny: "🐰", dragon: "🐲", owl: "🦉", tiger: "🐯" };

function speakArabic(text: string) {
  speechSynthesis.cancel();
  const u = new SpeechSynthesisUtterance(text);
  u.lang = "ar-SA";
  u.rate = 0.85;
  speechSynthesis.speak(u);
}

export default function Lesson() {
  const navigate = useNavigate();
  const { subjectId, lessonIdx } = useParams<{ subjectId: string; lessonIdx: string }>();
  const { user, dispatch } = useStore();
  const [factIdx, setFactIdx] = useState(0);
  const [completed, setCompleted] = useState(false);

  // Voice interaction state
  const [voiceState, setVoiceState] = useState<"idle" | "recording" | "loading" | "error">("idle");
  const [voiceReply, setVoiceReply] = useState<string | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);

  async function handleVoiceToggle() {
    if (voiceState === "recording") {
      mediaRecorderRef.current?.stop();
      return;
    }
    if (voiceState === "loading") return;

    setVoiceReply(null);
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const recorder = new MediaRecorder(stream);
      audioChunksRef.current = [];
      recorder.ondataavailable = (e) => audioChunksRef.current.push(e.data);
      recorder.onstop = async () => {
        stream.getTracks().forEach((t) => t.stop());
        setVoiceState("loading");
        try {
          const blob = new Blob(audioChunksRef.current, { type: "audio/wav" });
          const result = await adventureSpeech(blob, subjectId ?? "math", user.name);
          setVoiceReply(result.text_response);
          playAudioBase64(result.audio_base64, result.audio_format);
          setVoiceState("idle");
        } catch {
          setVoiceState("error");
          setTimeout(() => setVoiceState("idle"), 2000);
        }
      };
      recorder.start();
      mediaRecorderRef.current = recorder;
      setVoiceState("recording");
    } catch {
      setVoiceState("error");
      setTimeout(() => setVoiceState("idle"), 2000);
    }
  }

  const subject = SUBJECTS[subjectId as SubjectId];
  const idx = parseInt(lessonIdx ?? "0");
  const lesson = subject?.lessons[idx];

  const avatar = avatarEmojis[user.avatarBase] ?? "🦊";

  useEffect(() => {
    if (!lesson) return;
    speakArabic(`مرحباً يا ${user.name}! ${lesson.characterLine}`);
  }, []);

  useEffect(() => {
    if (!lesson) return;
    speakArabic(lesson.facts[factIdx]);
  }, [factIdx]);

  if (!subject || !lesson) {
    return <div className="p-8 text-center font-black">الدرس غير موجود</div>;
  }

  const isLastFact = factIdx >= lesson.facts.length - 1;
  const alreadyDone = user.completedLessons.includes(`${subjectId}-${idx}`);

  function handleNext() {
    if (!isLastFact) {
      setFactIdx((f) => f + 1);
    } else {
      if (!alreadyDone) dispatch({ type: "COMPLETE_LESSON", subjectId: subjectId as SubjectId, lessonIdx: idx });
      setCompleted(true);
    }
  }

  if (completed) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-4 py-8 text-center">
        <motion.div initial={{ scale: 0.7, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} transition={{ type: "spring", stiffness: 200, damping: 18 }}>
          <div className="text-7xl mb-4 select-none">🎉</div>
          <h1 className="text-3xl font-black text-foreground mb-2">أحسنت يا {user.name}! 🎉</h1>
          <p className="text-muted-foreground font-bold mb-8">أنهيت درس "{lesson.title}" بنجاح</p>

          <div className="flex justify-center gap-4 mb-10">
            <div className="bg-[#FFF9D6] border-2 border-[#FFD60A] rounded-2xl px-6 py-4 text-center">
              <Star className="w-6 h-6 text-[#FFD60A] fill-[#FFD60A] mx-auto mb-1" />
              <div className="font-black text-xl text-[#1A1A2E]">+{lesson.xp}</div>
              <div className="text-xs font-bold text-[#1A1A2E]/60">خبرة</div>
            </div>
            <div className="bg-[#FFF9D6] border-2 border-[#FFD60A] rounded-2xl px-6 py-4 text-center">
              <span className="text-2xl select-none">🪙</span>
              <div className="font-black text-xl text-[#1A1A2E]">+{lesson.coins}</div>
              <div className="text-xs font-bold text-[#1A1A2E]/60">عملات</div>
            </div>
          </div>

          <div className="space-y-3 w-full max-w-xs">
            <button onClick={() => navigate(`/categories/${subjectId}`)} className="w-full rounded-2xl py-4 font-black text-lg shadow-lg" style={{ backgroundColor: subject.color, color: subjectId === "math" ? "#1A1A2E" : "#FFFFFF" }}>
              العودة إلى {subject.name}
            </button>
            <button onClick={() => navigate(`/quiz/${subjectId}`)} className="w-full rounded-2xl py-4 font-black text-lg border-2 border-border bg-card hover:bg-muted transition-colors">
              جرّب الاختبار ←
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div dir="rtl" className="min-h-screen flex flex-col px-4 py-6">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate(`/categories/${subjectId}`)} className="w-10 h-10 rounded-xl bg-card border-2 border-border flex items-center justify-center hover:bg-muted">
          <ArrowRight className="w-4 h-4" />
        </button>
        <div className="flex-1">
          <p className="text-xs font-black text-muted-foreground uppercase tracking-wide">{subject.emoji} {subject.name}</p>
          <h2 className="font-black text-lg leading-tight">{lesson.title}</h2>
        </div>
        <div className="flex gap-1">
          {lesson.facts.map((_, i) => (
            <div key={i} className="h-2 rounded-full transition-all" style={{ width: i === factIdx ? "20px" : "8px", backgroundColor: i <= factIdx ? subject.color : "#E5E5E5" }} />
          ))}
        </div>
      </div>

      {/* Character + speech bubble */}
      <motion.div key="bubble" initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="flex items-end gap-3 mb-6">
        <motion.div animate={{ y: [0, -8, 0] }} transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }} className="text-[4.5rem] select-none shrink-0 leading-none">
          {avatar}
        </motion.div>
        <div className="relative bg-card border-[3px] rounded-2xl rounded-bl-none p-4 flex-1 shadow-md" style={{ borderColor: subject.color }}>
          <div className="absolute -left-3.5 bottom-4 w-0 h-0" style={{ borderTop: "8px solid transparent", borderBottom: "8px solid transparent", borderRight: `14px solid ${subject.color}` }} />
          <p className="text-sm font-bold text-foreground leading-relaxed">{lesson.characterLine}</p>
        </div>
      </motion.div>

      {/* Fact card */}
      <motion.div
        key={factIdx}
        initial={{ opacity: 0, x: 24 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -24 }}
        className="flex-1 rounded-[1.75rem] p-6 border-[3px] flex flex-col justify-center mb-6"
        style={{ backgroundColor: subject.lightColor, borderColor: subject.color }}
      >
        <div className="text-4xl mb-4 select-none">
          {["💡", "🌟", "🎯"][factIdx % 3]}
        </div>
        <p className="font-black text-xl text-[#1A1A2E] leading-snug">{lesson.facts[factIdx]}</p>
        <p className="text-sm font-bold text-[#1A1A2E]/50 mt-3">معلومة {factIdx + 1} من {lesson.facts.length}</p>
      </motion.div>

      {/* Voice interaction button */}
      <div className="mb-4">
        <motion.button
          whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.96 }}
          onClick={handleVoiceToggle}
          disabled={voiceState === "loading"}
          className={`w-full flex items-center justify-center gap-2 rounded-2xl py-3 font-black text-sm transition-all border-2 ${
            voiceState === "recording"
              ? "bg-[#FF4D6D] border-[#FF4D6D] text-white"
              : voiceState === "error"
              ? "bg-red-100 border-red-400 text-red-600"
              : "bg-card border-border text-foreground hover:bg-muted"
          }`}
        >
          {voiceState === "loading" ? (
            <><Loader2 className="w-4 h-4 animate-spin" /> جاري التفكير...</>
          ) : voiceState === "recording" ? (
            <><MicOff className="w-4 h-4" /> أوقف التسجيل</>
          ) : voiceState === "error" ? (
            <>⚠️ خطأ في الميكروفون — حاول مجدداً</>
          ) : (
            <><Mic className="w-4 h-4" /> اسأل سؤالاً 🎙️</>
          )}
        </motion.button>

        {voiceReply && (
          <motion.div initial={{ opacity: 0, y: 6 }} animate={{ opacity: 1, y: 0 }} className="mt-2 bg-card border-2 rounded-2xl px-4 py-3" style={{ borderColor: subject.color }}>
            <p className="text-xs font-black text-muted-foreground uppercase tracking-wide mb-1">رد المساعد الذكي</p>
            <p className="text-sm font-bold text-foreground leading-relaxed">{voiceReply}</p>
          </motion.div>
        )}
      </div>

      {/* Reward preview */}
      <div className="flex gap-2 mb-4">
        <div className="flex items-center gap-1.5 bg-muted rounded-xl px-3 py-2 text-sm font-bold">
          <Star className="w-4 h-4 text-[#FFD60A] fill-[#FFD60A]" />
          <span>+{lesson.xp} نقطة خبرة</span>
        </div>
        <div className="flex items-center gap-1.5 bg-muted rounded-xl px-3 py-2 text-sm font-bold">
          <span>🪙</span>
          <span>+{lesson.coins}</span>
        </div>
      </div>

      {/* Next button */}
      <motion.button
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={handleNext}
        className="w-full rounded-2xl py-4 font-black text-lg shadow-lg transition-all"
        style={{ backgroundColor: subject.color, color: subjectId === "math" ? "#1A1A2E" : "#FFFFFF" }}
      >
        {isLastFact ? "أكمل الدرس 🎉" : "التالي ←"}
      </motion.button>
    </div>
  );
}
