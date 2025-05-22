function love.conf(t)
    t.title = "Love2D Boilerplate"        -- The title of the window
    t.version = "11.4"                    -- The LÖVE version this game was made for
    t.window.width = 800                  -- Window width (desktop default)
    t.window.height = 600                 -- Window height (desktop default)
    t.window.resizable = true             -- Let the window be user-resizable
    t.window.minwidth = 320               -- Minimum window width for resizable windows
    t.window.minheight = 480              -- Minimum window height for resizable windows
    t.window.fullscreen = false           -- Enable fullscreen (true = fullscreen, false = windowed)
    t.window.vsync = 1                    -- Vertical sync mode (0 = off, 1 = on, 2 = adaptive)
    t.window.msaa = 0                     -- The number of samples to use with multi-sampled antialiasing
    t.window.icon = nil                   -- Filepath to an image to use as the window's icon

    t.modules.audio = true                -- Enable the audio module
    t.modules.data = true                 -- Enable the data module
    t.modules.event = true                -- Enable the event module
    t.modules.font = true                 -- Enable the font module
    t.modules.graphics = true             -- Enable the graphics module
    t.modules.image = true                -- Enable the image module
    t.modules.joystick = true             -- Enable the joystick module
    t.modules.keyboard = true             -- Enable the keyboard module
    t.modules.math = true                 -- Enable the math module
    t.modules.mouse = true                -- Enable the mouse module
    t.modules.physics = true              -- Enable the physics module
    t.modules.sound = true                -- Enable the sound module
    t.modules.system = true               -- Enable the system module
    t.modules.thread = true               -- Enable the thread module
    t.modules.timer = true                -- Enable the timer module
    t.modules.touch = true                -- Enable the touch module
    t.modules.video = true                -- Enable the video module
    t.modules.window = true               -- Enable the window module

    -- Console for debugging on Windows
    t.console = false                     -- Enable console output for Windows
end
