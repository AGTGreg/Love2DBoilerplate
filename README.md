# Love2D Mini Game Boilerplate

A robust, mobile-first project template for quickly building mini games with the Love2D framework.

## Features

- **Organized Structure**: Multi-folder codebase with clear separation of concerns
- **Complete Module System**: Includes input handling, physics, state management, asset loading, HTTP requests, and ad integration
- **Cross-Platform**: Supports Android (mobile) and desktop
- **Ready-to-Use Screens**: Includes splash screen, main menu, game screen, and pause screen
- **Responsive Design**: Automatically scales for different screen sizes

## Getting Started

### Requirements

- [LÖVE](https://love2d.org/) version 11.4 or higher

### Running the Boilerplate

1. Clone or download this repository
2. Navigate to the project folder
3. Run the project with LÖVE:

```bash
# On Linux/macOS
love .

# On Windows
"C:\Program Files\LOVE\love.exe" .
```

### Project Structure

```
/
├── main.lua             # Entry point
├── conf.lua             # LÖVE configuration
├── assets/              # Game assets
│   ├── images/          # Image files
│   ├── sounds/          # Sound effects and music
│   └── fonts/           # Font files
├── src/                 # Source code
│   ├── screens/         # Game screens/states
│   │   ├── splash.lua   # Splash/loading screen
│   │   ├── menu.lua     # Main menu
│   │   ├── game.lua     # Main game screen
│   │   └── pause.lua    # Pause screen
│   ├── input.lua        # Input handling (keyboard, mouse, touch)
│   ├── physics.lua      # Physics setup and utilities
│   ├── stateManager.lua # Screen/state management
│   ├── assets.lua       # Asset loading and management
│   ├── http.lua         # HTTP request handling
│   └── ads.lua          # Mobile ad integration
└── libs/                # Third-party libraries
```

## Main Features

### State Management

The boilerplate includes a powerful state manager for handling different game screens:

```lua
stateManager.switchState("menu")  -- Switch to menu screen
stateManager.switchState("game")  -- Switch to game screen
```

### Input Handling

Unified input system that works across mouse, keyboard, and touch devices:

```lua
-- Check if a virtual button was pressed
if input.buttonPressed("action") then
    -- Do something
end

-- Define a touch area (for UI buttons)
input.defineTouchArea("buttonId", x, y, width, height, callback)
```

### Asset Management

Simple API for loading and playing assets:

```lua
-- Play a sound effect
assets.playSound("click")

-- Play background music
assets.playMusic("game")
```

### Physics Integration

Easy physics object creation using Love2D's Box2D integration:

```lua
-- Create a physics object
physics.newRectangle("wall", "static", x, y, width, height)
physics.newCircle("player", "dynamic", x, y, radius)
```

## Mobile Features

### Ad Integration

The boilerplate includes a simple API for showing mobile ads:

```lua
-- Show banner ad
ads.showBanner()

-- Show fullscreen interstitial ad
if ads.isInterstitialReady() then
    ads.showInterstitial()
end
```

### HTTP Requests

Make network requests using the HTTP module:

```lua
-- Make a GET request
http.get("/api/endpoint", nil, function(success, code, data)
    if success then
        -- Handle response
    end
end)
```

## Customization

To customize this boilerplate for your game:

1. Replace placeholder assets with your own graphics and sounds
2. Modify the game screen in `src/screens/game.lua` to implement your game mechanics
3. Update the menu in `src/screens/menu.lua` with your game title and options
4. Adjust the physics settings in `src/physics.lua` if needed
5. Configure `conf.lua` with your game's information

## Utility Scripts

This boilerplate includes several utility scripts to help with development:

### Asset Generation

```bash
# Generate placeholder assets using ImageMagick
./generate_assets.sh
```

This script creates placeholder images and sounds for development purposes. Requires ImageMagick and ffmpeg to be installed.

### Building for Distribution

```bash
# Build a .love file for distribution
./build.sh
```

This script packages your game into a .love file that can be distributed and played on any platform with LÖVE installed.

## License

This boilerplate is released under the MIT License. Feel free to use it in your personal and commercial projects.

## Credits

Developed as a robust starting point for Love2D game development.

---

Happy Game Development!
