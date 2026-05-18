import { useState } from "react";
import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowRight, WifiOff, Wifi, ShoppingBag } from "lucide-react";
import { SHOP_AVATARS, SHOP_HATS, SHOP_OUTFITS } from "../data";
import type { ShopItem } from "../data";
import { useStore } from "../store";

type Tab = "avatar" | "hat" | "outfit";

const hatEmojis: Record<string, string> = { "hat-none": "", "hat-crown": "👑", "hat-wizard": "🎩", "hat-cap": "🧢", "hat-party": "🎊" };
const outfitLabels: Record<string, string> = { "outfit-default": "", "outfit-astronaut": "🚀", "outfit-knight": "⚔️", "outfit-scientist": "🔬", "outfit-wizard": "✨" };

export default function AvatarShop() {
  const navigate = useNavigate();
  const { user, dispatch } = useStore();
  const [tab, setTab] = useState<Tab>("avatar");
  const [buying, setBuying] = useState<string | null>(null);

  const avatarEmojis: Record<string, string> = { fox: "🦊", bunny: "🐰", dragon: "🐲", owl: "🦉", tiger: "🐯" };
  const currentAvatar = avatarEmojis[user.avatarBase] ?? "🦊";
  const currentHat = hatEmojis[user.avatarHat] ?? "";
  const currentOutfit = outfitLabels[user.avatarOutfit] ?? "";

  function getItems(): ShopItem[] {
    if (tab === "avatar") return SHOP_AVATARS;
    if (tab === "hat") return SHOP_HATS;
    return SHOP_OUTFITS;
  }

  function isOwned(item: ShopItem) {
    return user.ownedItems.includes(item.id);
  }

  function isEquipped(item: ShopItem) {
    if (tab === "avatar") return user.avatarBase === item.id;
    if (tab === "hat") return user.avatarHat === item.id;
    return user.avatarOutfit === item.id;
  }

  function handleBuy(item: ShopItem) {
    if (!isOwned(item) && user.coins >= item.cost) {
      dispatch({ type: "BUY_ITEM", itemId: item.id, cost: item.cost });
    }
  }

  function handleEquip(item: ShopItem) {
    if (!isOwned(item)) return;
    dispatch({ type: "EQUIP_ITEM", category: tab, itemId: item.id });
  }

  return (
    <div dir="rtl" className="min-h-screen" style={{ background: "linear-gradient(180deg, #1A0A3E 0%, #0D0020 60%, #1A1A2E 100%)" }}>
      {/* Bokeh background */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        {[...Array(8)].map((_, i) => (
          <motion.div key={i} animate={{ scale: [1, 1.2, 1], opacity: [0.05, 0.12, 0.05] }} transition={{ duration: 4 + i, repeat: Infinity, delay: i * 0.5 }}
            className="absolute rounded-full"
            style={{ width: `${80 + i * 40}px`, height: `${80 + i * 40}px`, left: `${(i * 37 + 10) % 80}%`, top: `${(i * 53 + 15) % 80}%`, backgroundColor: ["#C77DFF", "#4CC9F0", "#FFD60A", "#FF4D6D"][i % 4], filter: "blur(24px)" }}
          />
        ))}
      </div>

      <div className="relative px-4 py-6">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate("/")} className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center hover:bg-white/20">
            <ArrowRight className="w-4 h-4 text-white" />
          </button>
          <div className="flex-1">
            <h1 className="text-xl font-black text-white flex items-center gap-2">
              <ShoppingBag className="w-5 h-5" />
              متجر الشخصية
            </h1>
          </div>
          <div className="flex items-center gap-1.5 bg-[#FFD60A]/20 border border-[#FFD60A]/30 rounded-xl px-3 py-1.5">
            <span className="text-sm">🪙</span>
            <span className="font-black text-[#FFD60A] text-sm">{user.coins}</span>
          </div>
        </div>

        {/* Avatar preview */}
        <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="bg-white/10 border-2 border-white/20 rounded-[2rem] p-8 mb-6 text-center backdrop-blur-sm">
          <div className="relative inline-block">
            <motion.div animate={{ y: [0, -8, 0] }} transition={{ duration: 2.5, repeat: Infinity, ease: "easeInOut" }} className="text-[5rem] select-none leading-none">
              {currentAvatar}
            </motion.div>
            {currentHat && <span className="absolute -top-5 left-1/2 -translate-x-1/2 text-3xl select-none">{currentHat}</span>}
            {currentOutfit && <span className="absolute -bottom-3 right-0 text-2xl select-none">{currentOutfit}</span>}
          </div>
          <p className="mt-4 font-black text-white text-lg">شخصية {user.name}</p>
          <p className="text-white/50 font-bold text-sm">متعلّم المستوى {user.level}</p>
        </motion.div>

        {/* Offline toggle */}
        <div className="flex items-center justify-between bg-white/10 border border-white/20 rounded-2xl px-4 py-3 mb-5">
          <div className="flex items-center gap-2">
            {user.offlineMode ? <WifiOff className="w-4 h-4 text-[#FF6B35]" /> : <Wifi className="w-4 h-4 text-[#06D6A0]" />}
            <div>
              <p className="font-black text-white text-sm">وضع بدون إنترنت</p>
              <p className="text-white/50 text-[10px] font-bold">المحتوى محفوظ للتعلّم بدون إنترنت</p>
            </div>
          </div>
          <button
            onClick={() => dispatch({ type: "TOGGLE_OFFLINE" })}
            className={`w-12 h-6 rounded-full transition-colors relative ${user.offlineMode ? "bg-[#FF6B35]" : "bg-white/20"}`}
          >
            <div className={`absolute top-0.5 w-5 h-5 bg-white rounded-full transition-transform shadow ${user.offlineMode ? "translate-x-6" : "translate-x-0.5"}`} />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex bg-white/10 rounded-2xl p-1 mb-5">
          {([["avatar", "🐾 الشخصية"], ["hat", "🎩 القبعات"], ["outfit", "👕 الملابس"]] as [Tab, string][]).map(([t, label]) => (
            <button key={t} onClick={() => setTab(t)} className={`flex-1 py-2.5 rounded-xl font-black text-sm transition-all ${tab === t ? "bg-white text-[#1A1A2E] shadow-md" : "text-white/60 hover:text-white"}`}>
              {label}
            </button>
          ))}
        </div>

        {/* Items grid */}
        <div className="grid grid-cols-2 gap-3">
          {getItems().map((item, i) => {
            const owned = isOwned(item);
            const equipped = isEquipped(item);
            const affordable = user.coins >= item.cost;
            return (
              <motion.div
                key={item.id}
                initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: i * 0.06 }}
                className={`relative rounded-2xl p-4 border-2 transition-all ${equipped ? "border-[#FFD60A] bg-[#FFD60A]/10" : owned ? "border-white/20 bg-white/10" : "border-white/10 bg-white/5"}`}
                style={equipped ? { boxShadow: "0 0 20px rgba(255,214,10,0.3)" } : {}}
              >
                {equipped && <div className="absolute -top-2 -right-2 bg-[#FFD60A] text-[#1A1A2E] text-[9px] font-black rounded-full px-2 py-0.5">ملبوس</div>}
                <div className={`text-4xl mb-2 text-center select-none ${!owned && !affordable ? "opacity-40 grayscale" : ""}`}>{item.emoji}</div>
                <p className="font-black text-sm text-white text-center">{item.name}</p>
                {item.cost === 0 ? (
                  <p className="text-[10px] font-black text-[#06D6A0] text-center">مجاني</p>
                ) : (
                  <p className="text-[10px] font-bold text-white/50 text-center">🪙 {item.cost}</p>
                )}
                <div className="mt-3">
                  {equipped ? (
                    <div className="w-full py-2 rounded-xl bg-[#FFD60A]/20 text-[#FFD60A] font-black text-[11px] text-center">ملبوس ✓</div>
                  ) : owned ? (
                    <button onClick={() => handleEquip(item)} className="w-full py-2 rounded-xl bg-white/20 text-white font-black text-[11px] hover:bg-white/30 transition-colors">ارتداءه</button>
                  ) : (
                    <button
                      onClick={() => handleBuy(item)}
                      disabled={!affordable}
                      className={`w-full py-2 rounded-xl font-black text-[11px] transition-colors ${affordable ? "bg-[#FFD60A] text-[#1A1A2E] hover:brightness-110" : "bg-white/10 text-white/30 cursor-not-allowed"}`}
                    >
                      {affordable ? `شراء · 🪙 ${item.cost}` : `تحتاج 🪙 ${item.cost - user.coins} إضافية`}
                    </button>
                  )}
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
