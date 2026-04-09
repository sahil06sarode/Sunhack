# ConflictSense AI

ConflictSense AI is a Flutter + Firebase conflict intelligence platform that ingests live news, runs a multi-agent analysis pipeline, and produces explainable risk reports with a Gemini Live voice assistant.

## What is already scaffolded

- Feature-first Flutter app structure with 5 main screens.
- Riverpod-based data and service wiring.
- Firebase Auth with Google sign-in flow and protected app routes.
- Firestore user profile storage in `users/{uid}` after login.
- Firebase-backed repository and fallback logic for low-data cases.
- Multi-agent Cloud Functions pipeline:
  - Collector
  - Cleaner
  - Analyzer
  - Predictor
  - Reporter
- Gemini Live session endpoint configured with model `models/gemini-live-3.1`.

## Prerequisites

1. Install Flutter SDK (stable)
2. Install Node.js 20+
3. Install Firebase CLI
4. Install Java + Android Studio / Xcode toolchain for target platforms
5. Enable Google provider in Firebase Authentication

## Step-by-step setup

### 1) Install Flutter dependencies

```bash
flutter pub get
```

### 2) Configure Firebase for Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This will regenerate `lib/firebase_options.dart` for your project.

### 2.1) Configure Google login for Android

1. In Firebase Console, open Authentication > Sign-in method, then enable Google.
2. Add your Android app package name and SHA-1/SHA-256 certificate fingerprints in Firebase project settings.
3. Download `google-services.json` and place it in `android/app/`.
4. If Android/iOS folders are missing in this repo, generate them once from root:

```bash
flutter create .
```

5. Re-run `flutterfire configure` after generating platform folders.

### 3) Configure backend functions

```bash
cd functions
npm install
cp .env.example .env.local
```

Set keys in `functions/.env.local`.

### 4) Run Firebase emulators

```bash
firebase emulators:start
```

### 5) Run Flutter app

```bash
flutter run \
  --dart-define=BACKEND_BASE_URL=http://127.0.0.1:5001/YOUR_PROJECT_ID/us-central1 \
  --dart-define=GEMINI_LIVE_MODEL=models/gemini-live-3.1 \
  --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY
```

## Architecture

- Flutter app: `lib/`
- Cloud Functions multi-agent pipeline: `functions/src/`
- Implementation checklist: `IMPLEMENTATION_STEPS.md`

## Security note

The demo uses direct API-key based Gemini Live session wiring for hackathon speed. Before production, switch to ephemeral tokens and strict server-side access controls.
