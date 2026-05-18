import { RouterProvider } from "react-router";
import { router } from "./routes";
import { StoreProvider, useStore } from "./store";
import Login from "./pages/Login";

function AppInner() {
  const { user } = useStore();
  if (!user.isLoggedIn) return <Login />;
  return <RouterProvider router={router} />;
}

export default function App() {
  return (
    <StoreProvider>
      <AppInner />
    </StoreProvider>
  );
}
