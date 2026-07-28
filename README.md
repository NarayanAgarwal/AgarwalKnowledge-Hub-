# Agarwal Knowledge Hub - Enterprise Education Platform

Agarwal Knowledge Hub is a premium, scalable, and secure multi-tenant educational management ecosystem built using Flutter (Material Design 3), Firebase services, and Clean Architecture (MVVM).

The same codebase supports Android, iOS, Web (PWA), and Windows platforms, adapting to all mobile, tablet, and desktop viewports.

---

## 📂 Project Directory Structure

```
lib/
├── main.dart                       # App initializations and global ChangeNotifier providers
├── core/
│   ├── theme/                      # Light & Dark theme parameters
│   ├── constants/                  # Color palettes, text constants, and asset keys
│   ├── widgets/                    # Frosted containers, skeletons, and error screens
│   ├── utils/                      # Secure file upload extension and size limit checks
│   ├── models/                     # User, homework, quiz, story, folders, and exams models
│   └── services/                   # Analytics logs, notification handlers, downloads, and audio
└── features/
    ├── splash/                     # Animated splash & role-based routing controls
    ├── auth/                       # Phone authentication OTP grids
    ├── dashboard/                  # Classroom timelines, schedules, notice boards, and calendars
    ├── classes/                    # CBSE & BSEB curriculum selectors
    ├── homework/                   # Homework submit, download files, and teacher evaluation panels
    ├── quiz/                       # Timed quiz play, exams browser, leaderboard rank lists, and report cards
    ├── video/                      # lecture players (0.5x to 2x control overlays)
    ├── stories/                    # story viewer overlay with 24 hours expiry checks
    ├── downloads/                  # download queues tracking offline registers
    ├── library/                    # Nested folders, built-in PDF document reader, audio player
    └── web_panel/                  # Web logins, Super Admin controls, branding configs, student rosters
```

---

## 🛠️ Build & Deployment Guidelines

### 1. Prerequisites
- Install Flutter SDK (Stable Channel, latest version).
- Verify platforms compatibility via command:
  ```bash
  flutter doctor
  ```

### 2. Native Compilation Commands
Run these commands from the root directory to generate optimized production release binaries:

* **Android (APK & AAB Bundles)**:
  ```bash
  flutter build apk --release
  flutter build appbundle --release
  ```
  *(Output: `build/app/outputs/flutter-apk/app-release.apk`)*

* **Flutter Web Build**:
  ```bash
  flutter build web --release
  ```
  *(Output: `build/web/` directory assets ready for Firebase hosting)*

* **Windows Desktop App**:
  ```bash
  flutter build windows --release
  ```
  *(Output: `build/windows/runner/Release/` executable binaries)*

---

## 🔐 Firebase Setup & Security Auditing
1. Configure credentials on the Firebase console:
   - For Android: Place `google-services.json` inside `android/app/`.
   - For iOS: Place `GoogleService-Info.plist` inside `ios/Runner/`.
2. Secure Database paths using the compiled security rules defined inside `firestore.rules` and `storage.rules`. All paths restrict read/write access based on active role metadata tags (`Super Admin`, `Admin`, `Teacher`, `Student`, `Parent`).

---

## 🚀 CI/CD Automation
The project includes a pre-configured GitHub Actions script under `.github/workflows/flutter_ci.yml` that:
- Runs static code analysis checks (`flutter analyze`).
- Runs unit tests suits (`flutter test`).
- Compiles Android APK/AAB and Web production builds on every main push/pull request.
