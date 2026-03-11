# Task Flow

A Flutter task management app built with clean architecture, feature-based
modules, BLoC state management, Firebase Authentication, and Firebase Realtime
Database REST integration.

## Architecture

The codebase is organized by feature:

- `lib/features/auth`
- `lib/features/tasks`

Each feature follows:

- `data/datasource`
- `data/models`
- `data/repositories`
- `domain/entities`
- `domain/repositories`
- `domain/usecases`
- `presentation/screens`
- `presentation/blocs`
- `presentation/widgets`

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Configure Firebase in this project:

```bash
flutterfire configure
```

3. Ensure Firebase Authentication Email/Password is enabled.

4. Create a Firebase Realtime Database and keep its database URL available in
the generated Firebase configuration.

5. Run the app:

```bash
flutter run
```

## Realtime Database shape

Tasks are stored per user:

```json
{
  "users": {
    "USER_ID": {
      "tasks": {
        "AUTO_ID": {
          "title": "Prepare demo",
          "description": "Record APK walkthrough",
          "isCompleted": false,
          "createdAt": "2026-03-11T12:00:00.000Z",
          "updatedAt": "2026-03-11T12:00:00.000Z"
        }
      }
    }
  }
}
```

## Verification

- `flutter analyze`
- `flutter test`
