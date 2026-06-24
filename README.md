# Football Dynasty: Road to Glory

A production-quality football management simulation game built with Flutter. Manage your club, develop players, compete in leagues, and build a football dynasty.

## Features

- **Authentication** — Email, Google Sign-In, Guest mode, password reset
- **Club Creation** — Name, colors, country, league, stadium
- **Dashboard** — League position, finances, matches, board objectives, trophy cabinet
- **Squad Management** — 25-player squads with full attribute system
- **Tactics** — 5 formations, attacking/defensive styles, pressing, sliders
- **Match Engine** — Realistic simulation with goals, cards, injuries, live commentary
- **League System** — Full table, promotion/relegation, fixture generation
- **Transfer Market** — Buy, sell, loan, AI offers, value calculation
- **Training** — Attacking, defensive, physical, tactical training
- **Youth Academy** — Ages 15–18, seasonal intake, star potential (50–99)
- **Finances** — Revenue charts, salaries, transfers, facility costs
- **Facilities** — Stadium, training ground, medical, youth upgrades
- **Achievements** — Unlock trophies for milestones
- **Save System** — Auto, manual, and cloud saves (SQLite + Firestore)

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | Flutter, Material 3, Dark Theme |
| State | Riverpod |
| Local DB | SQLite (sqflite) |
| Backend | Firebase Auth, Firestore, Storage |
| Charts | fl_chart |
| Navigation | go_router |
| Architecture | Clean Architecture, MVVM, Repository Pattern |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
├── core/
│   ├── constants/
│   ├── database/
│   ├── providers/
│   ├── router/
│   ├── theme/
│   └── utils/
├── models/
├── services/
├── repositories/
├── features/
│   ├── authentication/
│   ├── dashboard/
│   ├── club/
│   ├── players/
│   ├── transfers/
│   ├── league/
│   ├── matches/
│   ├── tactics/
│   ├── finances/
│   ├── academy/
│   ├── facilities/
│   ├── achievements/
│   └── settings/
└── widgets/
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.12+ ([install guide](https://docs.flutter.dev/get-started/install))
- Dart 3.12+
- Android Studio / VS Code with Flutter extensions
- Firebase account (for auth and cloud saves)

### 1. Clone and Install Dependencies

```bash
cd football_dynasty
flutter pub get
```

### 2. Firebase Setup

1. Create a project at [Firebase Console](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password, Google, Anonymous)
3. Create a **Cloud Firestore** database
4. Enable **Firebase Storage**
5. Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This replaces `lib/firebase_options.dart` with your project credentials.

6. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) as prompted.

### 3. Google Sign-In (Optional)

- **Android**: Add SHA-1 fingerprint in Firebase Console → Project Settings
- **iOS**: Add URL scheme from `GoogleService-Info.plist` to `Info.plist`

### 4. Run the App

```bash
# Windows
flutter run -d windows

# Android
flutter run -d android

# Web
flutter run -d chrome
```

### 5. Guest Mode

If Firebase is not configured, the app falls back to **local guest mode** with SQLite saves. All game features work offline.

## Database Schema

### SQLite Tables

| Table | Purpose |
|-------|---------|
| `game_saves` | Local game save data (JSON blob) |
| `user_settings` | Key-value app settings |
| `facilities` | Club facility levels |
| `training_sessions` | Weekly training history |

### Firestore Collections

| Collection | Purpose |
|------------|---------|
| `users` | User profiles |
| `game_saves` | Cloud save data |

## Gameplay Guide

1. **Sign in** or continue as Guest
2. **Create your club** — choose name, country, league, colors
3. **Dashboard** — overview of your club's status
4. **Set tactics** — pick formation and style before matches
5. **Advance week** — simulates matches for all clubs
6. **Train squad** — improve attributes weekly
7. **Transfer market** — buy/sell players
8. **Upgrade facilities** — boost stadium, training, medical, youth
9. **Save progress** — manual or cloud save from settings

## Match Simulation

The engine calculates results using:

- Team strength (player ratings, morale, fitness, form)
- Tactical modifiers (formation, pressing, tempo)
- Home advantage (+8%)
- Random events (goals, cards, injuries)

## License

Private project — not for redistribution.
