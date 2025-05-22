# Boilerplate design document

#### Name
Love2D Mini Game Boilerplate

#### Goal
Provide a robust, mobile-first, and developer-friendly project template for quickly building mini games with the Love2D framework, supporting best practices, code organization, and core features expected in modern mobile games.

#### Key Requirements and Challenges

- **Functional Requirements:**
    - Organized multi-folder codebase with clear separation of concerns (src/, assets/, libs/)
    - Out-of-the-box modules for:
        - Input handling (touch, mouse, keyboard)
        - Basic physics setup
        - State/screen management (e.g., Splash, Main Menu, Game, Pause)
        - Asset loading (images, sound, fonts)
        - Splash screen and main menu (with "New Game" and "Quit")
        - HTTP requests (for networking features)
        - Ad integration (common ad providers)
    - Support for Android (mobile) and desktop (debug/test only)

- **Technical Considerations:**
    - Modular architecture for easy extension and maintenance
    - Use of reputable up-to-date third-party libraries
    - Responsive layout/scaling for different screen sizes
    - Unified input abstraction across platforms
    - Dependency management for external libraries
    - Ensure all modules are enabled by default; not optional

- **User Experience Notes:**
    - Consistent, mobile-first UI/UX; scalable/adaptable to desktop for testing
    - Intuitive navigation (clear splash/menu, consistent feedback)
    - Quick testing/dev support (e.g., debugging on desktop)

---

### Proposed Solution

- **Implementation Approach:**
    - **Architecture:**
       - Modular, multi-folder structure (e.g., `/src`, `/assets`, `/libs`)
       - Code modules: input, physics, scene/state manager, asset loader, HTTP, ads manager
       - Use Love2D’s event architecture; rely on third-party libraries for HTTP/ads
    - **Technologies:**
       - Love2D engine (Lua)
       - Recommended libraries from [Love2D libraries index](https://love2d.org/wiki/Category:Libraries)
       - Mobile ad library (e.g., AdMob plugin for Love2D, if available)
       - HTTP library (e.g., LuaSocket, LÖVE-native HTTP)
    - **Main Components:**
       - Core: `main.lua`, `conf.lua`
       - Modules: `/src/input.lua`, `/src/physics.lua`, `/src/stateManager.lua`, `/src/http.lua`, `/src/ads.lua`
       - UI Screens: `/src/splash.lua`, `/src/menu.lua`
       - Assets: `/assets/images`, `/assets/sounds`, `/assets/fonts`
       - External Libraries: `/libs/`
       - Config/Docs: README, sample inline documentation

- **UI/UX Design:**
    - Mobile-oriented interface scaling and layouts using Love2D transforms
    - Unified menu navigation (Splash -> Main Menu -> Game/Pause/Exit)
    - Touch-friendly controls; mouse/keyboard mapping for desktop debug
    - Simple reference wireframe:
      ```
      [Splash Screen] --> [Main Menu (New Game | Quit)] --> [Game Scene] --> [Pause/Ads] --> [Exit]
      ```

---

### Acceptance Criteria

- Runs out-of-the-box on desktop with no missing features or errors
- Displays splash, main menu, and functional game state transitions
- Accepts input via touch, mouse, and keyboard as expected per platform
- Loads assets and displays placeholder UI/art/sfx without manual intervention
- Can perform HTTP requests (e.g., successful GET to a known endpoint)
- Shows test ad banner/interstitial on mobile (or placeholder if in desktop debug)
- Clearly organized code structure and asset pipeline
- Basic documentation included (README + inline module comments)
