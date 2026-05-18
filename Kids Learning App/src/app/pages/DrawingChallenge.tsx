import { useRef, useState } from "react";
import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowLeft, Trash2, Loader2, CheckCircle, XCircle } from "lucide-react";
import { recognizeDrawing } from "../api";
import { useStore } from "../store";

const CHALLENGES = [
  { id: "DRAW_CAT", label: "Cat 🐱", emoji: "🐱" },
  { id: "DRAW_HOUSE", label: "House 🏠", emoji: "🏠" },
  { id: "DRAW_TREE", label: "Tree 🌳", emoji: "🌳" },
  { id: "DRAW_SUN", label: "Sun ☀️", emoji: "☀️" },
  { id: "DRAW_FISH", label: "Fish 🐟", emoji: "🐟" },
];

export default function DrawingChallenge() {
  const navigate = useNavigate();
  const { user } = useStore();
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const isDrawingRef = useRef(false);

  const [challenge, setChallenge] = useState(CHALLENGES[0]);
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "fail">("idle");
  const [feedback, setFeedback] = useState<string | null>(null);
  const [confidence, setConfidence] = useState<number | null>(null);
  const [strokeColor, setStrokeColor] = useState("#1A1A2E");
  const [strokeWidth, setStrokeWidth] = useState(4);

  function getPos(e: React.MouseEvent | React.TouchEvent) {
    const canvas = canvasRef.current!;
    const rect = canvas.getBoundingClientRect();
    const scaleX = canvas.width / rect.width;
    const scaleY = canvas.height / rect.height;
    if ("touches" in e) {
      return {
        x: (e.touches[0].clientX - rect.left) * scaleX,
        y: (e.touches[0].clientY - rect.top) * scaleY,
      };
    }
    return {
      x: (e.clientX - rect.left) * scaleX,
      y: (e.clientY - rect.top) * scaleY,
    };
  }

  function startDraw(e: React.MouseEvent | React.TouchEvent) {
    e.preventDefault();
    isDrawingRef.current = true;
    const ctx = canvasRef.current!.getContext("2d")!;
    const { x, y } = getPos(e);
    ctx.beginPath();
    ctx.moveTo(x, y);
  }

  function draw(e: React.MouseEvent | React.TouchEvent) {
    e.preventDefault();
    if (!isDrawingRef.current) return;
    const ctx = canvasRef.current!.getContext("2d")!;
    ctx.strokeStyle = strokeColor;
    ctx.lineWidth = strokeWidth;
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    const { x, y } = getPos(e);
    ctx.lineTo(x, y);
    ctx.stroke();
  }

  function stopDraw(e: React.MouseEvent | React.TouchEvent) {
    e.preventDefault();
    isDrawingRef.current = false;
  }

  function clearCanvas() {
    const canvas = canvasRef.current!;
    const ctx = canvas.getContext("2d")!;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = "#FFFFFF";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    setStatus("idle");
    setFeedback(null);
    setConfidence(null);
  }

  async function handleSubmit() {
    const canvas = canvasRef.current!;
    setStatus("loading");
    setFeedback(null);
    try {
      const result = await recognizeDrawing(canvas, challenge.id, user.name);
      setConfidence(result.confidence);
      setFeedback(result.text_response);
      setStatus(result.is_correct ? "success" : "fail");
    } catch {
      setFeedback("Could not reach the server. Make sure the backend is running!");
      setStatus("fail");
    }
  }

  return (
    <div className="min-h-screen flex flex-col px-4 py-6 bg-gradient-to-br from-[#EDE0FF] to-[#FFF0FB]">
      {/* Header */}
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => navigate("/")}
          className="w-10 h-10 rounded-xl bg-white border-2 border-[#C77DFF] flex items-center justify-center hover:bg-[#F5E6FF]"
        >
          <ArrowLeft className="w-4 h-4 text-[#C77DFF]" />
        </button>
        <div>
          <h1 className="font-black text-xl text-[#1A1A2E]">Drawing Challenge 🎨</h1>
          <p className="text-xs font-bold text-[#1A1A2E]/50">Draw and let the AI judge!</p>
        </div>
      </div>

      {/* Challenge selector */}
      <div className="flex gap-2 overflow-x-auto pb-1 mb-4">
        {CHALLENGES.map((c) => (
          <button
            key={c.id}
            onClick={() => { setChallenge(c); clearCanvas(); }}
            className={`shrink-0 rounded-xl px-3 py-2 font-black text-sm border-2 transition-all ${
              challenge.id === c.id
                ? "bg-[#C77DFF] border-[#C77DFF] text-white"
                : "bg-white border-[#C77DFF]/40 text-[#1A1A2E] hover:border-[#C77DFF]"
            }`}
          >
            {c.label}
          </button>
        ))}
      </div>

      {/* Challenge prompt */}
      <div className="rounded-2xl bg-white border-[3px] border-[#C77DFF] p-4 mb-4 text-center">
        <p className="text-xs font-black text-[#C77DFF] uppercase tracking-widest mb-1">Draw this:</p>
        <div className="text-5xl mb-1">{challenge.emoji}</div>
        <p className="font-black text-lg text-[#1A1A2E]">{challenge.label.replace(/\s\S+$/, "")}</p>
      </div>

      {/* Canvas */}
      <div className="relative rounded-[1.5rem] overflow-hidden border-[3px] border-[#C77DFF] bg-white mb-4 touch-none">
        <canvas
          ref={(el) => {
            canvasRef.current = el;
            if (el) {
              el.width = 400;
              el.height = 300;
              const ctx = el.getContext("2d")!;
              ctx.fillStyle = "#FFFFFF";
              ctx.fillRect(0, 0, el.width, el.height);
            }
          }}
          className="w-full cursor-crosshair"
          onMouseDown={startDraw}
          onMouseMove={draw}
          onMouseUp={stopDraw}
          onMouseLeave={stopDraw}
          onTouchStart={startDraw}
          onTouchMove={draw}
          onTouchEnd={stopDraw}
        />
        <button
          onClick={clearCanvas}
          className="absolute top-2 right-2 w-9 h-9 rounded-xl bg-white border-2 border-[#FF4D6D] flex items-center justify-center hover:bg-[#FFE0E6]"
        >
          <Trash2 className="w-4 h-4 text-[#FF4D6D]" />
        </button>
      </div>

      {/* Color & width controls */}
      <div className="flex items-center gap-3 mb-4 bg-white rounded-2xl border-2 border-[#C77DFF]/40 px-4 py-3">
        <span className="text-xs font-black text-[#1A1A2E]/50 uppercase">Color</span>
        {["#1A1A2E", "#FF4D6D", "#06D6A0", "#C77DFF", "#FF6B35", "#4CC9F0"].map((c) => (
          <button
            key={c}
            onClick={() => setStrokeColor(c)}
            className={`w-7 h-7 rounded-full border-2 transition-all ${strokeColor === c ? "scale-125 border-white shadow-md" : "border-transparent"}`}
            style={{ backgroundColor: c }}
          />
        ))}
        <span className="ml-auto text-xs font-black text-[#1A1A2E]/50 uppercase">Size</span>
        {[2, 4, 8, 14].map((w) => (
          <button
            key={w}
            onClick={() => setStrokeWidth(w)}
            className={`rounded-full bg-[#1A1A2E] transition-all ${strokeWidth === w ? "ring-2 ring-[#C77DFF]" : ""}`}
            style={{ width: w * 2 + 8, height: w * 2 + 8 }}
          />
        ))}
      </div>

      {/* Feedback */}
      {feedback && (
        <motion.div
          initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
          className={`rounded-2xl px-4 py-3 mb-4 border-2 flex items-start gap-3 ${
            status === "success"
              ? "bg-[#D6F8EF] border-[#06D6A0]"
              : "bg-[#FFE0E6] border-[#FF4D6D]"
          }`}
        >
          {status === "success"
            ? <CheckCircle className="w-5 h-5 text-[#06D6A0] shrink-0 mt-0.5" />
            : <XCircle className="w-5 h-5 text-[#FF4D6D] shrink-0 mt-0.5" />
          }
          <div>
            <p className="font-black text-sm text-[#1A1A2E]">{feedback}</p>
            {confidence !== null && (
              <p className="text-xs font-bold text-[#1A1A2E]/50 mt-0.5">
                Confidence: {Math.round(confidence * 100)}%
              </p>
            )}
          </div>
        </motion.div>
      )}

      {/* Submit */}
      <motion.button
        whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
        onClick={handleSubmit}
        disabled={status === "loading"}
        className="w-full rounded-2xl py-4 font-black text-lg text-white shadow-lg flex items-center justify-center gap-2 bg-[#C77DFF] disabled:opacity-60"
      >
        {status === "loading" ? (
          <><Loader2 className="w-5 h-5 animate-spin" /> Analyzing...</>
        ) : (
          "Submit Drawing 🎨"
        )}
      </motion.button>
    </div>
  );
}
