-- src/screens/splash.lua
-- Splash screen shown at game startup

local assets = require("src.assets")
local stateManager = require("src.stateManager")

local splash = {
    timer = 0,
    duration = 3,  -- Splash screen duration in seconds
    fadeInDuration = 0.5,
    fadeOutDuration = 0.5,
    logoScale = 1,
    logoRotation = 0
}

function splash.init()
    -- Initialize any splash-specific resources
end

function splash.enter()
    splash.timer = 0
end

function splash.update(dt)
    splash.timer = splash.timer + dt

    -- Animate the logo
    splash.logoScale = 1 + math.sin(splash.timer * 2) * 0.05
    splash.logoRotation = math.sin(splash.timer) * 0.05

    -- Auto transition to menu after duration
    if splash.timer >= splash.duration then
        stateManager.switchState("menu")
    end
end

function splash.draw()
    local width, height = love.graphics.getDimensions()
    width = width / gameScale
    height = height / gameScale

    -- Clear the screen
    love.graphics.clear(0.1, 0.1, 0.2, 1)

    -- Calculate alpha for fade in/out
    local alpha = 1
    if splash.timer < splash.fadeInDuration then
        -- Fade in
        alpha = splash.timer / splash.fadeInDuration
    elseif splash.timer > splash.duration - splash.fadeOutDuration then
        -- Fade out
        alpha = (splash.duration - splash.timer) / splash.fadeOutDuration
    end

    love.graphics.setColor(1, 1, 1, alpha)

    -- Draw the logo
    if assets.images.logo then
        local logoWidth = assets.images.logo:getWidth()
        local logoHeight = assets.images.logo:getHeight()

        love.graphics.push()
        love.graphics.translate(width / 2, height / 2)
        love.graphics.rotate(splash.logoRotation)
        love.graphics.scale(splash.logoScale, splash.logoScale)
        love.graphics.draw(assets.images.logo, -logoWidth / 2, -logoHeight / 2)
        love.graphics.pop()
    else
        -- Fallback if logo isn't loaded
        love.graphics.setFont(assets.fonts.large or love.graphics.newFont(36))
        love.graphics.printf("LOVE2D BOILERPLATE", 0, height / 2 - 18, width, "center")
    end

    -- Draw company name or additional info
    love.graphics.setFont(assets.fonts.small or love.graphics.newFont(16))
    love.graphics.printf("Made with LÖVE", 0, height - 40, width, "center")

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

function splash.keypressed(key)
    -- Skip splash screen with any key
    stateManager.switchState("menu")
end

function splash.mousepressed()
    -- Skip splash screen with mouse click
    stateManager.switchState("menu")
end

function splash.touchpressed()
    -- Skip splash screen with touch
    stateManager.switchState("menu")
end

function splash.exit()
    -- Clean up any splash-specific resources
end

return splash
