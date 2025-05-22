-- src/assets.lua
-- Manages loading and accessing game assets (images, sounds, fonts)

local assets = {
    images = {},
    sounds = {},
    fonts = {},
    music = {}
}

-- Load all game assets
function assets.init()
    -- Load images
    assets.loadImages()

    -- Load sounds
    assets.loadSounds()

    -- Load fonts
    assets.loadFonts()

    -- Load music
    assets.loadMusic()
end

-- Load image assets from the assets/images directory
function assets.loadImages()
    -- Load default placeholder image
    assets.images.placeholder = love.graphics.newImage("assets/images/placeholder.png")

    -- Load logo for splash screen
    assets.images.logo = love.graphics.newImage("assets/images/logo.png")

    -- Load UI elements
    assets.images.button = love.graphics.newImage("assets/images/button.png")
    assets.images.buttonHover = love.graphics.newImage("assets/images/button_hover.png")
end

-- Load sound assets from the assets/sounds directory
function assets.loadSounds()
    -- Load UI sounds
    assets.sounds.click = love.audio.newSource("assets/sounds/click.wav", "static")
    assets.sounds.hover = love.audio.newSource("assets/sounds/hover.wav", "static")
end

-- Load font assets from the assets/fonts directory
function assets.loadFonts()
    -- Default fonts
    assets.fonts.small = love.graphics.newFont("assets/fonts/font.ttf", 14)
    assets.fonts.medium = love.graphics.newFont("assets/fonts/font.ttf", 24)
    assets.fonts.large = love.graphics.newFont("assets/fonts/font.ttf", 36)

    -- Fallback to default font if the file isn't found
    if not love.filesystem.getInfo("assets/fonts/font.ttf") then
        assets.fonts.small = love.graphics.newFont(14)
        assets.fonts.medium = love.graphics.newFont(24)
        assets.fonts.large = love.graphics.newFont(36)
    end
end

-- Load music assets from the assets/sounds directory
function assets.loadMusic()
    -- Background music
    assets.music.menu = love.audio.newSource("assets/sounds/sample_loop.wav", "stream")
    assets.music.game = love.audio.newSource("assets/sounds/sample_loop.wav", "stream")

    -- Set music to loop
    assets.music.menu:setLooping(true)
    assets.music.game:setLooping(true)
end

-- Play a sound with optional parameters
function assets.playSound(name, volume, pitch)
    if assets.sounds[name] then
        local sound = assets.sounds[name]:clone()
        if volume then sound:setVolume(volume) end
        if pitch then sound:setPitch(pitch) end
        sound:play()
        return sound
    end
end

-- Play music track
function assets.playMusic(name, volume)
    -- Stop all currently playing music
    assets.stopAllMusic()

    if assets.music[name] then
        if volume then assets.music[name]:setVolume(volume) end
        assets.music[name]:play()
    end
end

-- Stop all music tracks
function assets.stopAllMusic()
    for _, music in pairs(assets.music) do
        music:stop()
    end
end

return assets
