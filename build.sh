#!/bin/bash
# build.sh - Simple build script for Love2D boilerplate

# Configuration
GAME_NAME="love2d-boilerplate"
VERSION="1.0.0"
OUTPUT_DIR="./dist"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Building $GAME_NAME v$VERSION..."

# Build .love file (zip the contents)
echo "Creating .love package..."
zip -9 -r "$OUTPUT_DIR/$GAME_NAME.love" . -x "*.git*" "dist/*" "*.sh" "*.love"

echo "Package created at $OUTPUT_DIR/$GAME_NAME.love"

# Check if we're on Linux and have the necessary tools for AppImage creation
if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v appimagetool &> /dev/null; then
    echo "Linux detected. Would you like to create an AppImage? (y/n)"
    read -r CREATE_APPIMAGE

    if [[ $CREATE_APPIMAGE == "y" ]]; then
        echo "Creating AppImage..."
        # Implementation would go here
        echo "AppImage creation not yet implemented."
    fi
fi

# For Android builds (requires love-android)
if command -v gradle &> /dev/null && [ -d "love-android" ]; then
    echo "Gradle detected. Would you like to build for Android? (y/n)"
    read -r BUILD_ANDROID

    if [[ $BUILD_ANDROID == "y" ]]; then
        echo "Building Android APK..."
        # Implementation would go here
        echo "Android build not yet implemented."
    fi
fi

echo "Build completed successfully."
