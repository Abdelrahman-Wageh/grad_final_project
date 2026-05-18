import { Outlet, useNavigate, useLocation } from "react-router";
import { Home, Map, BookOpen, Trophy, Gamepad2, WifiOff } from "lucide-react";
import { useStore } from "./store";

const NAV_ITEMS = [
  { path: "/",          icon: Home,      label: "الرئيسية" },
  { path: "/map",       icon: Map,       label: "الخريطة" },
  { path: "/games",     icon: Gamepad2,  label: "الألعاب" },
  { path: "/categories",icon: BookOpen,  label: "الدروس" },
  { path: "/rewards",   icon: Trophy,    label: "الجوائز" },
];

export default function Root() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useStore();

  const active = (path: string) => {
    if (path === "/") return location.pathname === "/";
    return location.pathname.startsWith(path);
  };

  return (
    <div dir="rtl" className="min-h-screen bg-background flex flex-col max-w-lg mx-auto relative">
      {user.offlineMode && (
        <div className="flex items-center justify-center gap-2 py-1.5 bg-[#FF6B35] text-white text-xs font-black shrink-0">
          <WifiOff className="w-3 h-3" />
          وضع عدم الاتصال — المحتوى محفوظ
        </div>
      )}

      <main className="flex-1 overflow-y-auto pb-20">
        <Outlet />
      </main>

      <nav className="fixed bottom-0 left-0 right-0 z-40 bg-card border-t-2 border-border">
        <div className="max-w-lg mx-auto flex">
          {NAV_ITEMS.map(({ path, icon: Icon, label }) => {
            const isActive = active(path);
            return (
              <button
                key={path}
                onClick={() => navigate(path)}
                className={`flex-1 flex flex-col items-center gap-0.5 py-3 transition-colors ${isActive ? "text-[#FF4D6D]" : "text-muted-foreground hover:text-foreground"}`}
              >
                <div className={`relative p-1.5 rounded-xl transition-all ${isActive ? "bg-[#FFE0E6]" : ""}`}>
                  <Icon className="w-5 h-5" />
                  {path === "/rewards" && user.totalStars > 0 && (
                    <span className="absolute -top-1 -left-1 w-4 h-4 bg-[#FFD60A] rounded-full text-[9px] font-black text-[#1A1A2E] flex items-center justify-center">
                      {Math.min(user.totalStars, 99)}
                    </span>
                  )}
                </div>
                <span className={`text-[10px] font-black ${isActive ? "text-[#FF4D6D]" : ""}`}>{label}</span>
              </button>
            );
          })}
        </div>
      </nav>
    </div>
  );
}
