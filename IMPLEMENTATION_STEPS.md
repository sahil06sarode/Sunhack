# ConflictSense AI - Step-by-step Build Guide

This repository is now scaffolded. Follow these steps in order.

## Phase 0 - Install prerequisites

1. Install Flutter stable SDK.
2. Install Node.js 20+.
3. Install Firebase CLI.
4. Run `flutter doctor` and fix any missing platform dependencies.

## Phase 1 - Bootstrap and Firebase wiring

1. Run `flutter pub get`.
2. Run `dart pub global activate flutterfire_cli`.
3. Run `flutterfire configure` to generate real Firebase options.
4. Configure Firebase Auth Google sign-in:
   - Firebase Console > Authentication > Sign-in method > enable Google
   - Add Android SHA-1/SHA-256 in Firebase project settings
   - Place `google-services.json` in `android/app/`
5. If `android/` and `ios/` folders are not present, run `flutter create .` once.
6. Re-run `flutterfire configure` after platform folders exist.
7. Confirm these app files are present and wired:
   - `lib/main.dart`
   - `lib/app.dart`
   - `lib/router/app_router.dart`
   - `lib/features/shell/app_shell.dart`
8. If FlutterFire cannot list projects, run `firebase login --reauth` and retry configure.

## Phase 2 - Backend multi-agent pipeline

1. Open `functions/.env.example`, copy to `.env.local`, fill API keys.
2. Run `cd functions`.
3. Run `npm install`.
4. Run `npm run build`.
5. Return to project root before Firebase commands: `cd ..`.
6. Pipeline flow (already implemented):
   - Collector: `functions/src/agents/collector.ts`
   - Cleaner: `functions/src/agents/cleaner.ts`
   - Analyzer: `functions/src/agents/analyzer.ts`
   - Predictor: `functions/src/agents/predictor.ts`
   - Reporter: `functions/src/agents/reporter.ts`
7. Orchestration entrypoint:
   - `functions/src/index.ts`

## Phase 3 - Run emulators and trigger ingestion

1. From project root run `firebase emulators:start`.
2. If Firebase reports `User code failed to load... Timeout after 10000`, verify you are not inside `functions/` when running `firebase` commands.
3. Trigger pipeline manually with Firebase ID token:
   - `POST http://127.0.0.1:5001/YOUR_PROJECT_ID/us-central1/runConflictPipeline`
   - Header: `Authorization: Bearer <firebase_id_token>`
   - Body: `{"region":"Sudan"}`
4. Verify Firestore collections update:
   - `articles`
   - `riskSnapshots`
   - `reports`

## Phase 4 - Run Flutter app

1. From project root:
   - `flutter run --dart-define=BACKEND_BASE_URL=http://127.0.0.1:5001/YOUR_PROJECT_ID/us-central1 --dart-define=GEMINI_LIVE_MODEL=models/gemini-live-3.1`
2. Navigate through screens:
   - Login (Google)
   - Dashboard
   - Feed
   - Report
   - Scenarios
   - Alerts
3. For Android runs, attach a phone with USB debugging or create an emulator in Android Studio Device Manager.

## Phase 5 - Gemini Live 3.1 voice assistant setup

1. Backend live session endpoint is ready:
   - `functions/src/index.ts` exports `createGeminiLiveSession`
2. Live model is configured by default as:
   - `models/gemini-live-3.1`
3. Flutter live client is wired in:
   - `lib/features/voice/data/gemini_live_service.dart`
4. UI sheet is wired in:
   - `lib/features/voice/presentation/voice_assistant_sheet.dart`
5. Tap `Ask ConflictSense` FAB and start session.

## API key reference

1. Keep all external-provider secrets in `functions/.env.local`.
2. Required keys:
   - `NEWS_API_KEY`
   - `TAVILY_API_KEY`
   - `GEMINI_API_KEY`
3. Never put these secrets in Flutter `--dart-define`.
4. Firebase Auth ID token is automatically sent by app when calling backend endpoints.

## Phase 6 - Hackathon polish checklist

1. Replace fallback analyzer logic with Gemini structured JSON extraction.
2. Add microphone PCM audio streaming in live service for full duplex voice.
3. Add FCM spike alerts and Realtime DB alert flags.
4. Add offline cache badges and stale-data warnings.
5. Add end-to-end tests for pipeline scoring.
