# ConflictSense AI

ConflictSense AI is a Flutter + Firebase conflict intelligence app.
The intelligence pipeline runs directly in the Flutter app, while Firebase is used for:

- Authentication (Google sign-in)
- Firestore data storage and sync

## Prerequisites

1. Flutter SDK (stable)
2. Firebase CLI
3. Android Studio / Xcode toolchain for your target platform
4. Google sign-in enabled in Firebase Authentication

## Quick Start

### 1) Install Flutter dependencies

```bash
flutter pub get
```

### 2) Configure Firebase for Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3) Configure app runtime keys

```bash
cp .env.example .env
```

Set values in root `.env`:

- `GEMINI_API_KEY` (required)
- `TAVILY_API_KEY` (optional)
- `NEWS_API_KEY` (optional)
- `GEMINI_LIVE_MODEL` (optional)
- `DEFAULT_REGION` (optional)

### 4) Run app

```bash
npm run frontend
```

Optional frontend variants:

```bash
npm run frontend:dark
npm run frontend:home
```

## Firebase Usage in This App

- Auth: Firebase Authentication
- Database: Firestore
- Pipeline reports saved in Firestore collection `intelligence_reports`

## Notes

- Hot reload/hot restart may not refresh `.env` asset changes. Fully stop and rerun the app after key updates.
- If Firestore writes fail, verify your Firebase login state and Firestore rules in `firestore.rules`.

