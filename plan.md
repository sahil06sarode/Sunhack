Here's the complete architectural plan for your **ConflictSense AI** Flutter app — a real-time conflict intelligence platform powered by Firebase, Gemini Live, and a multi-agent pipeline.Now here's the full detailed plan broken into phases:

---

## App name: ConflictSense AI

### Tech stack
- **Frontend:** Flutter (iOS, Android, Web)
- **Backend/Infra:** Firebase (Firestore, Realtime DB, Cloud Functions, Scheduler, Auth, FCM, Storage)
- **AI Engine:** Gemini 2.5 Flash via Google AI SDK (agent LLM) + Gemini Live API (voice assistant)
- **Data APIs:** NewsAPI, Tavily, RSS, optional social signal webhooks

---

## Phase 1 — Project setup & data ingestion

**Flutter project** initialized with `flutter create conflictsense` using feature-first folder structure: `features/dashboard`, `features/feed`, `features/report`, `features/scenarios`, `features/alerts`. Core packages: `firebase_core`, `cloud_firestore`, `firebase_database`, `firebase_messaging`, `google_generative_ai`, `riverpod` (state), `go_router` (navigation), `fl_chart` (charts), `google_maps_flutter` (map).

**Firebase setup:** Firestore holds structured article documents with fields: `id`, `headline`, `source`, `url`, `location`, `timestamp`, `sentiment`, `keywords[]`, `riskScore`, `eventType`. Realtime Database handles live alert state. Cloud Scheduler triggers ingestion every 15 minutes.

**Data pipeline Cloud Function (`ingestNews`):** Calls NewsAPI + Tavily simultaneously, pulls active RSS feeds, deduplicates by URL hash and headline similarity (cosine similarity via Gemini embeddings), normalizes all articles into the standard Firestore schema.

---

## Phase 2 — Multi-agent pipeline (the hackathon core)

Each agent is a discrete Firebase Cloud Function that passes a structured JSON payload to the next. The pipeline runs as a sequential chain triggered by the ingestion function.

**Agent 1 — Collector:** Receives raw API responses. Extracts headline, body snippet, source URL, publication time. Outputs normalized `RawArticle[]` JSON array.

**Agent 2 — Cleaner:** Receives `RawArticle[]`. Runs deduplication (Firestore hash lookup), keyword filtering (blocklist: protest, clash, tension, violence, militant, airstrike, etc.), strips HTML. Outputs `CleanArticle[]`.

**Agent 3 — Analyzer:** Passes each `CleanArticle` to Gemini 2.5 Flash with a structured prompt requesting: sentiment label (positive/negative/neutral), confidence %, extracted location(s) as lat/lng, detected event type (protest/clash/tension/displacement/ceasefire), and top 5 keywords. Returns `AnalyzedArticle[]`.

**Agent 4 — Predictor:** Aggregates `AnalyzedArticle[]` for a given region/timeframe. Calculates risk score (0–100) based on: article volume (weight 30%), negative sentiment ratio (25%), event severity mapping (30%), trend velocity (15%). Outputs: `riskLevel` (Low/Medium/High/Critical), `riskScore`, `confidence`, `24hrForecast`, `48hrForecast`, `civilianImpact`, `uncertaintyFlag` (triggered if < 3 articles).

**Agent 5 — Reporter:** Sends aggregated analysis to Gemini 2.5 Flash with a prompt to generate: a 3–5 paragraph conflict intelligence report, a bullet-point explainability section ("why is risk rated High?"), scenario simulation text ("if escalation continues..."), and source citations. Stores final `ConflictReport` document in Firestore.

---

## Phase 3 — Flutter dashboard UI

**Dashboard screen:** Animated risk gauge using `fl_chart` `RadialBarChart` — color coded green/amber/red/dark-red by risk level. Region selector at top. "Last updated" timestamp with manual refresh button. Summary cards: total articles ingested, dominant event type, civilian impact badge.

**Live Feed screen:** `StreamBuilder` on Firestore `articles` collection ordered by timestamp. Each card shows headline, source, sentiment chip (color-coded), event type tag, extracted location, and keyword highlights (matched words bolded). Infinite scroll with pagination.

**AI Report screen:** Full `ConflictReport` rendered with collapsible sections — summary, detailed analysis, explainability bullets ("Risk is High because: 47 articles in 6 hours, 78% negative sentiment, 3 clash events detected"), scenario simulation section, source links list.

**Scenarios screen:** "What-if" simulation input — user types or speaks a scenario ("What if a ceasefire breaks down?"). Sent to Gemini Live / Gemini 2.5 Flash. Response rendered as a structured prediction card with probability band and impact estimate.

**Alerts screen:** Google Map with color-coded pins per region risk level. Location-based alert toggle (Firebase Realtime DB listener). Alert history timeline — vertical list with timestamps and risk level color indicators.

---

## Phase 4 — Gemini Live integration (voice assistant)

A persistent bottom sheet "Ask ConflictSense" button launches the Gemini Live session. The system prompt primes Gemini with the latest `ConflictReport` JSON as context. User can ask: "What's the risk level in Sudan right now?", "Why is the score high?", "Simulate an escalation scenario." Gemini Live streams back audio response; transcript also shown as text. Session ends gracefully with a summary card saved to history.

---

## Phase 5 — Intelligence & resilience features

**Trend detector:** Cloud Function compares article count in current 2-hour window vs 7-day rolling average for the same window. If count > 2.5× average, fires a "spike alert" to FCM and updates Realtime DB alert flag.

**Fallback logic:** If Gemini API fails or returns malformed JSON, the Predictor agent falls back to a rule-based scorer: count articles by keyword severity tier, apply fixed weights, output rule-based risk level with a `"AI unavailable — rule-based estimate"` flag shown in the UI.

**Error handling:** All Cloud Functions wrap API calls in try/catch with structured error logging to Firebase Crashlytics. Flutter UI uses `AsyncValue` from Riverpod — loading skeletons, error banners with retry buttons, and "Not enough data" empty states when article count < threshold.

**Offline mode:** Firestore persistence enabled. Last known `ConflictReport` cached locally and shown with a "Last synced X minutes ago" banner when offline.

---

## Phase 6 — Hackathon polish

**Confidence score display:** Every risk card shows a confidence % bar below the risk level. Low confidence (< 50%) triggers a yellow "Limited data" warning chip.

**Explainable AI panel:** Expandable section on every report showing exactly which articles, keywords, and sentiment scores drove the risk calculation — sourced directly from Agent 5's structured output.

**Timeline view:** Horizontal scrollable timeline on the Dashboard showing risk level history for the selected region over the past 48 hours — color-coded blocks per time slot.

**Alert level indicators:** App-wide color theming shifts subtly based on current highest alert — green tint for Low, amber for Medium, red wash for High/Critical.
