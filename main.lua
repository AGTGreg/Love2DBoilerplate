-- main.lua - Entry point for Love2D boilerplate
local stateManager = require("src.stateManager")
local assets = require("src.assets")
local input = require("src.input")

-- Game states
local splash = require("src.screens.splash")
local menu = require("src.screens.menu")
local game = require("src.screens.game")
local pause = require("src.screens.pause")

-- Global variables
gameWidth = 800
gameHeight = 600
gameScale = 1

function love.load()
    -- Set default filter mode for scaling images
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Initialize modules
    assets.init()
    input.init()

    -- Initialize game states
    stateManager.registerState("splash", splash)
    stateManager.registerState("menu", menu)
    stateManager.registerState("game", game)
    stateManager.registerState("pause", pause)

    -- Start with splash screen
    stateManager.switchState("splash")

    -- Setup window scaling
    updateScale()
end

function love.update(dt)
    -- Update input manager
    input.update(dt)

    -- Update current state
    stateManager.update(dt)
end

function love.draw()
    -- Apply scaling
    love.graphics.push()
    love.graphics.scale(gameScale, gameScale)

    -- Draw current state
    stateManager.draw()

    love.graphics.pop()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        -- If in game, pause; if in menu, quit
        if stateManager.getCurrentState() == "game" then
            stateManager.switchState("pause")
        elseif stateManager.getCurrentState() == "menu" then
            love.event.quit()
        end
    end

    input.keypressed(key, scancode, isrepeat)
    stateManager.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    input.keyreleased(key, scancode)
    stateManager.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    local scaledX, scaledY = x / gameScale, y / gameScale
    input.mousepressed(scaledX, scaledY, button, istouch, presses)
    stateManager.mousepressed(scaledX, scaledY, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    local scaledX, scaledY = x / gameScale, y / gameScale
    input.mousereleased(scaledX, scaledY, button, istouch, presses)
    stateManager.mousereleased(scaledX, scaledY, button, istouch, presses)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    local scaledX, scaledY = x / gameScale, y / gameScale
    input.touchpressed(id, scaledX, scaledY, dx, dy, pressure)
    stateManager.touchpressed(id, scaledX, scaledY, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    local scaledX, scaledY = x / gameScale, y / gameScale
    input.touchreleased(id, scaledX, scaledY, dx, dy, pressure)
    stateManager.touchreleased(id, scaledX, scaledY, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    local scaledX, scaledY = x / gameScale, y / gameScale
    local scaledDx, scaledDy = dx / gameScale, dy / gameScale
    input.touchmoved(id, scaledX, scaledY, scaledDx, scaledDy, pressure)
    stateManager.touchmoved(id, scaledX, scaledY, scaledDx, scaledDy, pressure)
end

function love.resize(w, h)
    updateScale()
end

-- Calculate the game scale based on window dimensions
function updateScale()
    local w, h = love.graphics.getDimensions()
    gameScale = math.min(w / gameWidth, h / gameHeight)
end
