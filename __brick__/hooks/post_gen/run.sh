#!/bin/bash

# Post-generation hook for smoketrees_app brick
# This script handles Android package renaming and initial setup

set -e

echo "Running post-generation hook..."

# Get the output directory from Mason
OUTPUT_DIR="${OUTPUT_DIR:-.}"

# Navigate to the output directory
cd "$OUTPUT_DIR"

# Get the organization and project_name from brick variables
ORGANIZATION="{{organization}}"
PROJECT_NAME="{{project_name}}"

# Convert organization to directory path (e.g., com.example -> com/example)
ORG_PATH=$(echo "$ORGANIZATION" | tr '.' '/')

# Create the correct Android package directory structure
ANDROID_KOTLIN_DIR="android/app/src/main/kotlin/${ORG_PATH}/${PROJECT_NAME}"

# Remove the placeholder directory if it exists
if [ -d "android/app/src/main/kotlin/com/example/placeholder" ]; then
    rm -rf "android/app/src/main/kotlin/com/example/placeholder"
fi

# Create the correct directory structure
mkdir -p "$ANDROID_KOTLIN_DIR"

# Create MainActivity.kt with correct package
cat > "$ANDROID_KOTLIN_DIR/MainActivity.kt" << EOF
package ${ORGANIZATION}.${PROJECT_NAME}

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
EOF

echo "Android package structure created: $ANDROID_KOTLIN_DIR"

# Run flutter pub get
echo "Running flutter pub get..."
flutter pub get

# Run build_runner to generate .g.dart files
echo "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "Post-generation hook completed successfully!"
echo ""
echo "Your project is ready! Run 'flutter run' to start the app."
