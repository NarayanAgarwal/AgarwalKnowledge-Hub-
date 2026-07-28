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

# Modify base href to relative path for safer asset path resolution
echo "Modifying base href path..."
sed -i 's/<base href="\/">/<base href=".\/">/g' web/index.html

# 4. Fetch dependencies
echo "Getting pub packages..."
flutter pub get

# 5. Build production web bundle
echo "Building Flutter Web release assets..."
flutter build web --release --dart-define=FLUTTER_WEB_RENDERER=html

echo "Build complete!"
