#!/bin/bash
set -e # Exit immediately if any command exits with a non-zero status

# 1. Fast download prebuilt Flutter SDK archive from Google CDN
if [ ! -d "flutter" ]; then
  echo "Downloading prebuilt Flutter SDK archive..."
  curl -sL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz | tar -xJ
fi

# 2. Add Flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable web support
echo "Configuring Web support..."
flutter config --enable-web

# 4. Fetch dependencies
echo "Getting pub packages..."
flutter pub get

# 5. Build production web bundle (disable service worker cache to enforce fresh page loading)
echo "Building Flutter Web release assets..."
flutter build web --release --pwa-strategy=none --dart-define=FLUTTER_WEB_RENDERER=html --no-tree-shake-icons \
  --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
  --dart-define=FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID" \
  --dart-define=FIREBASE_APP_ID="$FIREBASE_APP_ID" \
  --dart-define=FIREBASE_AUTH_DOMAIN="$FIREBASE_AUTH_DOMAIN" \
  --dart-define=FIREBASE_STORAGE_BUCKET="$FIREBASE_STORAGE_BUCKET" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="$FIREBASE_MESSAGING_SENDER_ID"

echo "Build complete!"
