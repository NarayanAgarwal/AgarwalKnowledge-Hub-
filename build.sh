#!/bin/bash

# 1. Clone Flutter stable branch
echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 2. Add Flutter to path
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable web support and create web template files
echo "Configuring Web support..."
flutter config --enable-web
flutter create . --platforms web

# 4. Fetch dependencies
echo "Getting pub packages..."
flutter pub get

# 5. Build production web bundle with HTML renderer defined via dart-define (safest option to bypass option parsing errors)
echo "Building Flutter Web release assets with HTML renderer define..."
flutter build web --release --dart-define=FLUTTER_WEB_RENDERER=html

echo "Build complete!"
