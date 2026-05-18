import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useStore } from "../store";

const AVATARS = ["🦊", "🐻", "🦁", "🐸", "🦄", "🐧", "🐼", "🐯"];

export default function Login() {
  const { dispatch } = useStore();
  const [name, setName] = useState("");
  const [selectedAvatar, setSelectedAvatar] = useState(0);
  const [step, setStep] = useState<"name" | "avatar">("name");
  const [error, setError] = useState("");

  function handleNameNext() {
    const trimmed = name.trim();
    if (!trimmed) { setError("من فضلك اكتب اسمك!"); return; }
    if (trimmed.length < 2) { setError("الاسم قصير جداً!"); return; }
    setError("");
    setStep("avatar");
  }

  function handleStart() {
    dispatch({ type: "SET_NAME", name: name.trim() });
  }

  return (
    <div
      dir="rtl"
      className="min-h-screen bg-gradient-to-br from-[#1A1A2E] via-[#16213E] to-[#0F3460] flex items-center justify-center p-6"
    >
      {/* Stars background */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {Array.from({ length: 20 }).map((_, i) => (
          <motion.div
            key={i}
            className="absolute w-1 h-1 bg-white rounded-full"
            style={{ left: `${Math.random() * 100}%`, top: `${Math.random() * 100}%` }}
            animate={{ opacity: [0.2, 1, 0.2], scale: [1, 1.5, 1] }}
            transition={{ duration: 2 + Math.random() * 3, repeat: Infinity, delay: Math.random() * 2 }}
          />
        ))}
      </div>

      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        className="relative w-full max-w-sm"
      >
        {/* Logo / mascot */}
        <motion.div
          className="text-center mb-8"
          animate={{ y: [0, -10, 0] }}
          transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
        >
          <div className="text-8xl mb-3">{AVATARS[selectedAvatar]}</div>
          <h1 className="text-3xl font-black text-white">مرحباً!</h1>
          <p className="text-white/60 font-bold mt-1">تعلّم وألعب بالعربية</p>
        </motion.div>

        <div className="bg-white/10 backdrop-blur-md rounded-3xl p-6 border border-white/20 shadow-2xl">
          <AnimatePresence mode="wait">
            {step === "name" ? (
              <motion.div
                key="name"
                initial={{ opacity: 0, x: 40 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -40 }}
              >
                <h2 className="text-xl font-black text-white mb-1 text-center">ما اسمك؟</h2>
                <p className="text-white/50 text-sm text-center mb-5">سيناديك الذكاء الاصطناعي باسمك</p>

                <input
                  type="text"
                  value={name}
                  onChange={(e) => { setName(e.target.value); setError(""); }}
                  onKeyDown={(e) => e.key === "Enter" && handleNameNext()}
                  placeholder="اكتب اسمك هنا..."
                  maxLength={20}
                  className="w-full bg-white/20 text-white placeholder-white/40 font-bold text-lg text-right rounded-2xl px-5 py-4 border-2 border-white/30 focus:border-[#FFD60A] focus:outline-none transition-all"
                  autoFocus
                />

                {error && (
                  <motion.p
                    initial={{ opacity: 0, y: -4 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="text-[#FF4D6D] font-bold text-sm mt-2 text-center"
                  >
                    {error}
                  </motion.p>
                )}

                <motion.button
                  whileHover={{ scale: 1.03 }}
                  whileTap={{ scale: 0.97 }}
                  onClick={handleNameNext}
                  className="mt-5 w-full bg-[#FFD60A] text-[#1A1A2E] font-black text-lg rounded-2xl py-4 shadow-lg"
                >
                  التالي ←
                </motion.button>
              </motion.div>
            ) : (
              <motion.div
                key="avatar"
                initial={{ opacity: 0, x: 40 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -40 }}
              >
                <h2 className="text-xl font-black text-white mb-1 text-center">
                  اختر شخصيتك يا {name}!
                </h2>
                <p className="text-white/50 text-sm text-center mb-5">هذا سيكون مساعدك</p>

                <div className="grid grid-cols-4 gap-3 mb-5">
                  {AVATARS.map((a, i) => (
                    <motion.button
                      key={i}
                      whileHover={{ scale: 1.1 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setSelectedAvatar(i)}
                      className={`text-4xl p-3 rounded-2xl border-3 transition-all ${
                        selectedAvatar === i
                          ? "bg-[#FFD60A]/30 border-[#FFD60A] scale-110"
                          : "bg-white/10 border-white/20"
                      }`}
                      style={{ borderWidth: 3 }}
                    >
                      {a}
                    </motion.button>
                  ))}
                </div>

                <div className="flex gap-3">
                  <motion.button
                    whileTap={{ scale: 0.97 }}
                    onClick={() => setStep("name")}
                    className="flex-1 bg-white/10 text-white font-bold rounded-2xl py-4 border border-white/20"
                  >
                    → رجوع
                  </motion.button>
                  <motion.button
                    whileHover={{ scale: 1.03 }}
                    whileTap={{ scale: 0.97 }}
                    onClick={handleStart}
                    className="flex-2 bg-[#06D6A0] text-white font-black text-lg rounded-2xl py-4 px-8 shadow-lg"
                  >
                    ابدأ! 🚀
                  </motion.button>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </motion.div>
    </div>
  );
}
