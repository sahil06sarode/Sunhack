# ConflictSense AI - Implementation Steps

## Phase 0 - Prerequisites

1. Install Flutter stable SDK.
2. Install Firebase CLI.
3. Run `flutter doctor` and fix platform requirements.

## Phase 1 - Firebase wiring

1. Run `flutter pub get`.
2. Run `dart pub global activate flutterfire_cli`.
3. Run `flutterfire configure`.
4. Enable Google sign-in in Firebase Authentication.
5. Place `google-services.json` in `android/app/` if needed.

## Phase 2 - Runtime config

1. Copy `.env.example` to `.env`.
2. Set `GEMINI_API_KEY` (required).
3. Optionally set `TAVILY_API_KEY` and `NEWS_API_KEY`.
4. Restart app fully after env changes.

## Phase 3 - Run app

1. From project root run `npm run frontend`.
2. Sign in with Google.
3. Open feed/query screens and verify reports are persisted to Firestore `intelligence_reports`.

## Phase 4 - Validation checklist

1. Auth works: sign in and sign out succeed.
2. Firestore writes succeed for `intelligence_reports`.
3. Feed screen streams reports from Firestore.
4. Query screen responds using latest Firestore report context.

## API key reference

1. Keep provider keys in root `.env`.
2. Required: `GEMINI_API_KEY`.
3. Optional: `TAVILY_API_KEY`, `NEWS_API_KEY`, `GEMINI_LIVE_MODEL`, `DEFAULT_REGION`.
4. Do not put provider secrets in `--dart-define`.
