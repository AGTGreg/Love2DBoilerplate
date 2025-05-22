# Using the Love2D Boilerplate

This is a quick guide to help you get started with the Love2D Mini Game Boilerplate.

## Overview

This boilerplate provides a complete foundation for building games with Love2D. It includes:

- A state management system for game screens
- Input handling for keyboard, mouse, and touch
- Asset loading and management
- Physics integration with Love2D's Box2D
- HTTP requests for networking
- Ad integration for mobile games

## First Steps

1. **Generate placeholder assets**: Run `./generate_assets.sh` to create basic placeholder images and sounds
2. **Run the game**: Use `love .` in the project directory to launch the boilerplate
3. **Explore the code**: Check out the files in the `src` directory to understand the structure

## Making Your Own Game

1. **Modify the game screen**: Edit `src/screens/game.lua` to implement your game mechanics
2. **Add your assets**: Replace the placeholder assets in the `assets` directory
3. **Customize the UI**: Edit the menu and pause screens to match your game's theme
4. **Update game settings**: Modify `conf.lua` with your game's title and configuration

## Testing

To test on desktop:
```bash
love .
```

For Android, you'll need to set up Love2D's Android export tools.

## Building for Distribution

Run the build script to package your game:
```bash
./build.sh
```

This will create a `.love` file in the `dist` directory that can be distributed to players.

## Architecture

The boilerplate follows a modular architecture:

- `main.lua`: Entry point that initializes the game
- `src/stateManager.lua`: Handles switching between game states/screens
- `src/input.lua`: Provides a unified input system across devices
- `src/physics.lua`: Wraps Love2D's physics system
- `src/assets.lua`: Handles loading and playing sounds/images
- `src/screens/`: Contains individual game screens
  - `splash.lua`: Splash screen shown at startup
  - `menu.lua`: Main menu with play/quit options
  - `game.lua`: Main gameplay screen
  - `pause.lua`: Pause menu

Happy game development!
