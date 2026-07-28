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

# 5. Build production web bundle with HTML renderer (maximizes browser compatibility and prevents CanvasKit/WebGL blank screens)
echo "Building Flutter Web release assets using HTML renderer..."
flutter build web --release --web-renderer html

echo "Build complete!"
