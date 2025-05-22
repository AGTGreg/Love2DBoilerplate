#!/bin/bash
# generate_assets.sh - Creates placeholder assets using ImageMagick

echo "Generating placeholder assets..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Skipping asset generation."
    echo "You can install it with: sudo apt-get install imagemagick"
    exit 0
fi

# Create placeholder image (100x100 checkerboard pattern)
convert -size 100x100 pattern:checkerboard -fill "#AAAAAA" -opaque black \
        -fill "#555555" -opaque white \
        -bordercolor "#333333" -border 2 \
        ./assets/images/placeholder.png

# Create logo image (200x200 with LOVE text)
convert -size 200x200 xc:transparent \
        -fill "#6495ED" -draw "circle 100,100 100,150" \
        -pointsize 36 -fill white -gravity center -annotate 0 "LÖVE" \
        ./assets/images/logo.png

# Create button images (200x50 rounded rectangle)
convert -size 200x50 xc:transparent \
        -fill "#3080C0" -draw "roundrectangle 0,0 200,50 10,10" \
        ./assets/images/button.png

convert -size 200x50 xc:transparent \
        -fill "#50B0FF" -draw "roundrectangle 0,0 200,50 10,10" \
        ./assets/images/button_hover.png

# Generate simple WAV files for sound effects
if command -v ffmpeg &> /dev/null; then
    echo "Generating sound placeholders with ffmpeg..."

    # Generate click sound (short beep)
    ffmpeg -f lavfi -i "sine=frequency=880:duration=0.1" -ar 44100 \
           ./assets/sounds/click.wav -y 2>/dev/null

    # Generate hover sound (shorter, higher beep)
    ffmpeg -f lavfi -i "sine=frequency=1320:duration=0.05" -ar 44100 \
           ./assets/sounds/hover.wav -y 2>/dev/null

    # Generate placeholder music files (silent)
    ffmpeg -f lavfi -i "anullsrc=r=44100:cl=stereo" -t 10 \
           ./assets/sounds/menu.mp3 -y 2>/dev/null
    ffmpeg -f lavfi -i "anullsrc=r=44100:cl=stereo" -t 10 \
           ./assets/sounds/game.mp3 -y 2>/dev/null
else
    echo "ffmpeg not found. Skipping sound generation."
fi

echo "Asset generation complete!"
