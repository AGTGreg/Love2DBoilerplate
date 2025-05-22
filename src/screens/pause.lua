-- src/screens/pause.lua
-- Pause menu screen

local assets = require("src.assets")
local stateManager = require("src.stateManager")
local input = require("src.input")
local ads = require("src.ads")

local pause = {
    buttons = {},
    selected = 1,
    title = "PAUSED",
    animTimer = 0,
    gameState = {}  -- Store the game state here
}

local function createButton(id, text, x, y, width, height, callback)
    return {
        id = id,
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        callback = callback,
        hover = false,
        scale = 1
    }
end

function pause.init()
    -- Create pause menu buttons
    pause.buttons = {}

    -- Button dimensions
    local buttonWidth = 200
    local buttonHeight = 50
    local centerX = gameWidth / 2 - buttonWidth / 2

    -- Create buttons
    table.insert(pause.buttons, createButton(
        "resume",
        "Resume",
        centerX,
        gameHeight / 2 - buttonHeight * 1.5,
        buttonWidth,
        buttonHeight,
        function()
            stateManager.switchState("game", {
                fromPause = true,
                score = pause.gameState.score,
                timeElapsed = pause.gameState.timeElapsed
            })
        end
    ))

    table.insert(pause.buttons, createButton(
        "mainMenu",
        "Main Menu",
        centerX,
        gameHeight / 2,
        buttonWidth,
        buttonHeight,
        function()
            stateManager.switchState("menu")
        end
    ))

    table.insert(pause.buttons, createButton(
        "quit",
        "Quit Game",
        centerX,
        gameHeight / 2 + buttonHeight * 1.5,
        buttonWidth,
        buttonHeight,
        function()
            love.event.quit()
        end
    ))
end

function pause.enter(params)
    pause.selected = 1
    pause.animTimer = 0

    -- Store game state from parameters
    pause.gameState = params or {}

    -- Define touch areas for buttons
    for i, button in ipairs(pause.buttons) do
        input.defineTouchArea(
            button.id,
            button.x,
            button.y,
            button.width,
            button.height,
            function()
                button.callback()
            end
        )
    end

    -- Show ad if on mobile
    if ads.isAvailable and ads.isInterstitialReady() then
        ads.showInterstitial()
    end
end

function pause.update(dt)
    pause.animTimer = pause.animTimer + dt

    -- Update button animations
    for i, button in ipairs(pause.buttons) do
        if i == pause.selected then
            button.scale = 1 + math.sin(pause.animTimer * 4) * 0.05
        else
            button.scale = 1
        end
    end
end

function pause.draw()
    -- Draw semi-transparent overlay on top of the game
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)

    -- Draw pause title
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(assets.fonts.large or love.graphics.newFont(36))
    love.graphics.printf(pause.title, 0, gameHeight * 0.2, gameWidth, "center")

    -- Draw game stats
    love.graphics.setFont(assets.fonts.medium or love.graphics.newFont(24))
    love.graphics.printf(
        "Score: " .. (pause.gameState.score or 0),
        0,
        gameHeight * 0.2 + 60,
        gameWidth,
        "center"
    )

    -- Draw buttons
    for i, button in ipairs(pause.buttons) do
        -- Button background
        love.graphics.push()
        love.graphics.translate(button.x + button.width / 2, button.y + button.height / 2)
        love.graphics.scale(button.scale, button.scale)

        if i == pause.selected then
            love.graphics.setColor(0.3, 0.7, 1, 1)
        else
            love.graphics.setColor(0.2, 0.5, 0.8, 1)
        end

        love.graphics.rectangle(
            "fill",
            -button.width / 2,
            -button.height / 2,
            button.width,
            button.height,
            8, -- rounded corners
            8
        )

        -- Button border
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.rectangle(
            "line",
            -button.width / 2,
            -button.height / 2,
            button.width,
            button.height,
            8,
            8
        )

        -- Button text
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(assets.fonts.medium or love.graphics.newFont(24))
        love.graphics.printf(
            button.text,
            -button.width / 2,
            -button.height / 4,
            button.width,
            "center"
        )

        love.graphics.pop()
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)

    -- Draw placeholder ad if on desktop
    ads.draw()
end

function pause.keypressed(key)
    if key == "escape" then
        -- Resume game with Escape key
        stateManager.switchState("game", {
            fromPause = true,
            score = pause.gameState.score,
            timeElapsed = pause.gameState.timeElapsed
        })
        return
    end

    if key == "up" or key == "w" then
        pause.selected = pause.selected - 1
        if pause.selected < 1 then pause.selected = #pause.buttons end
        assets.playSound("hover", 0.5)
    elseif key == "down" or key == "s" then
        pause.selected = pause.selected + 1
        if pause.selected > #pause.buttons then pause.selected = 1 end
        assets.playSound("hover", 0.5)
    elseif key == "return" or key == "space" then
        if pause.buttons[pause.selected] then
            assets.playSound("click", 0.7)
            pause.buttons[pause.selected].callback()
        end
    end
end

function pause.mousepressed(x, y, button)
    if button ~= 1 then return end

    for i, btn in ipairs(pause.buttons) do
        if x >= btn.x and x <= btn.x + btn.width and
           y >= btn.y and y <= btn.y + btn.height then
            pause.selected = i
            assets.playSound("click", 0.7)
            btn.callback()
            break
        end
    end
end

function pause.mousemoved(x, y)
    for i, btn in ipairs(pause.buttons) do
        local wasHover = btn.hover
        btn.hover = x >= btn.x and x <= btn.x + btn.width and
                    y >= btn.y and y <= btn.y + btn.height

        if btn.hover and not wasHover then
            pause.selected = i
            assets.playSound("hover", 0.3)
        end
    end
end

function pause.exit()
    -- Clean up touch areas
    for _, button in ipairs(pause.buttons) do
        input.removeTouchArea(button.id)
    end
end

return pause
