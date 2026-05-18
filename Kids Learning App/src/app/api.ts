/**
 * API service layer — connects the Kids Learning App frontend to the
 * Whispering Woods FastAPI backend (http://localhost:8000).
 *
 * All requests go through Vite's dev proxy (/api → http://localhost:8000/api)
 * so there are no CORS issues during development.
 */

const BASE = "/api";

// ── Types mirroring backend Pydantic schemas ──────────────────────────────

export interface GameState {
  state: string;
  context: string;
  level?: number;
  state_data?: Record<string, unknown>;
}

export interface AdventureSpeechRequest {
  audio_base64: string;
  audio_format?: string;
  game_state: GameState;
  player_id?: string;
  character_type?: string;
}

export interface ResponseMetadata {
  response_key: string;
  confidence: number;
  source: string;
  transcribed_text?: string;
  detected_emotion?: string;
  processing_time_ms?: number;
}

export interface AdventureSpeechResponse {
  audio_base64: string;
  audio_format: string;
  text_response: string;
  metadata: ResponseMetadata;
  timestamp: string;
}

export interface DrawRequest {
  image_base64: string;
  challenge: string;
  game_state?: GameState;
  player_id?: string;
}

export interface DrawResponse {
  prediction: string;
  confidence: number;
  is_correct: boolean;
  response_key: string;
  text_response: string;
  metadata: ResponseMetadata;
  timestamp: string;
}

export interface HealthResponse {
  status: string;
  timestamp: string;
  dry_run_mode: boolean;
  services: Record<string, string>;
}

// ── Helpers ───────────────────────────────────────────────────────────────

async function post<T>(path: string, body: unknown): Promise<T> {
  const res = await fetch(`${BASE}${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(err.detail ?? `HTTP ${res.status}`);
  }
  return res.json() as Promise<T>;
}

async function get<T>(path: string): Promise<T> {
  const res = await fetch(`${BASE}${path}`);
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(err.detail ?? `HTTP ${res.status}`);
  }
  return res.json() as Promise<T>;
}

// ── Utility: convert a Blob/File to base64 string ────────────────────────

export function blobToBase64(blob: Blob): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onloadend = () => {
      const result = reader.result as string;
      // Strip the "data:...;base64," prefix
      resolve(result.split(",")[1]);
    };
    reader.onerror = reject;
    reader.readAsDataURL(blob);
  });
}

// ── Public API ────────────────────────────────────────────────────────────

/**
 * Send recorded audio to the backend STT → NLU → TTS pipeline.
 *
 * @param audioBlob  Raw audio recorded from the browser microphone.
 * @param subjectId  Subject currently being studied (used as game state).
 * @param playerId   Optional player identifier for audit logging.
 */
export async function adventureSpeech(
  audioBlob: Blob,
  subjectId: string,
  playerId?: string
): Promise<AdventureSpeechResponse> {
  const audio_base64 = await blobToBase64(audioBlob);
  const body: AdventureSpeechRequest = {
    audio_base64,
    audio_format: "wav",
    game_state: {
      state: `LESSON_${subjectId.toUpperCase()}`,
      context: "lesson_interaction",
      state_data: { subject: subjectId },
    },
    player_id: playerId,
    character_type: "fox",
  };
  return post<AdventureSpeechResponse>("/adventure_speech", body);
}

/**
 * Play back a base64-encoded audio response from the backend.
 */
export function playAudioBase64(base64: string, format = "wav"): void {
  const src = `data:audio/${format};base64,${base64}`;
  const audio = new Audio(src);
  audio.play().catch(console.error);
}

/**
 * Submit a drawing (canvas PNG) to the backend CV recognition endpoint.
 *
 * @param canvas     HTMLCanvasElement containing the kid's drawing.
 * @param challenge  What the child was asked to draw, e.g. "DRAW_CAT".
 * @param playerId   Optional player identifier.
 */
export async function recognizeDrawing(
  canvas: HTMLCanvasElement,
  challenge: string,
  playerId?: string
): Promise<DrawResponse> {
  const dataUrl = canvas.toDataURL("image/png");
  const image_base64 = dataUrl.split(",")[1];
  const body: DrawRequest = {
    image_base64,
    challenge,
    game_state: {
      state: "DRAWING_CHALLENGE",
      context: "drawing",
    },
    player_id: playerId,
  };
  return post<DrawResponse>("/draw", body);
}

/**
 * Check if the backend is reachable and healthy.
 */
export async function checkHealth(): Promise<HealthResponse> {
  return get<HealthResponse>("/health");
}
