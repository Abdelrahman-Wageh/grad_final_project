import { createBrowserRouter } from "react-router";
import Root from "./Root";
import Home from "./pages/Home";
import Categories from "./pages/Categories";
import Lesson from "./pages/Lesson";
import Quiz from "./pages/Quiz";
import Rewards from "./pages/Rewards";
import Progress from "./pages/Progress";
import LearningMap from "./pages/LearningMap";
import ParentDashboard from "./pages/ParentDashboard";
import DailyChallenge from "./pages/DailyChallenge";
import AvatarShop from "./pages/AvatarShop";
import DrawingChallenge from "./pages/DrawingChallenge";
import GamesHub from "./pages/GamesHub";
import AnimalSoundsGame from "./pages/games/AnimalSoundsGame";
import ColorsGame from "./pages/games/ColorsGame";
import NumbersGame from "./pages/games/NumbersGame";
import MemoryGame from "./pages/games/MemoryGame";
import ShapesGame from "./pages/games/ShapesGame";
import ArabicLettersGame from "./pages/games/ArabicLettersGame";
import WordBuildGame from "./pages/games/WordBuildGame";
import ArabicStoriesGame from "./pages/games/ArabicStoriesGame";
import SpellingGame from "./pages/games/SpellingGame";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: Home },
      { path: "categories", Component: Categories },
      { path: "categories/:subjectId", Component: Categories },
      { path: "lesson/:subjectId/:lessonIdx", Component: Lesson },
      { path: "quiz/:subjectId", Component: Quiz },
      { path: "rewards", Component: Rewards },
      { path: "progress", Component: Progress },
      { path: "map", Component: LearningMap },
      { path: "parent", Component: ParentDashboard },
      { path: "challenge", Component: DailyChallenge },
      { path: "avatar", Component: AvatarShop },
      { path: "drawing", Component: DrawingChallenge },
      { path: "games", Component: GamesHub },
      { path: "games/animals", Component: AnimalSoundsGame },
      { path: "games/colors",  Component: ColorsGame },
      { path: "games/numbers", Component: NumbersGame },
      { path: "games/memory",  Component: MemoryGame },
      { path: "games/shapes",  Component: ShapesGame },
      { path: "games/letters",  Component: ArabicLettersGame },
      { path: "games/words",    Component: WordBuildGame },
      { path: "games/stories",  Component: ArabicStoriesGame },
      { path: "games/spelling", Component: SpellingGame },
    ],
  },
]);
