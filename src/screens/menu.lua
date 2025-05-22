-- src/screens/menu.lua
-- Main menu screen with game options

local assets = require("src.assets")
local stateManager = require("src.stateManager")
local input = require("src.input")
local ads = require("src.ads")

local menu = {
    buttons = {},
    selected = 1,
    animTimer = 0,
    title = "LÖVE2D MINI GAME",
    subtitle = "Boilerplate Template"
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
        scale = 1,
    }
end

function menu.init()
    -- Create menu buttons
    menu.buttons = {}

    -- Button dimensions
    local buttonWidth = 200
    local buttonHeight = 50
    local centerX = gameWidth / 2 - buttonWidth / 2

    -- Create buttons
    table.insert(menu.buttons, createButton(
        "newGame",
        "New Game",
        centerX,
        gameHeight / 2,
        buttonWidth,
        buttonHeight,
        function()
            stateManager.switchState("game")
        end
    ))

    table.insert(menu.buttons, createButton(
        "quit",
        "Quit",
        centerX,
        gameHeight / 2 + buttonHeight * 1.5,
        buttonWidth,
        buttonHeight,
        function()
            love.event.quit()
        end
    ))
end

function menu.enter()
    menu.selected = 1
    menu.animTimer = 0

    -- Define touch areas for buttons
    for i, button in ipairs(menu.buttons) do
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

    -- Start playing menu music
    assets.playMusic("menu", 0.7)
end

function menu.update(dt)
    menu.animTimer = menu.animTimer + dt

    -- Update button animations
    for i, button in ipairs(menu.buttons) do
        if i == menu.selected then
            button.scale = 1 + math.sin(menu.animTimer * 4) * 0.05
        else
            button.scale = 1
        end
    end
end

function menu.draw()
    -- Draw background
    love.graphics.clear(0.2, 0.3, 0.5, 1)

    -- Draw title
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(assets.fonts.large or love.graphics.newFont(36))
    love.graphics.printf(menu.title, 0, gameHeight * 0.2, gameWidth, "center")

    -- Draw subtitle
    love.graphics.setFont(assets.fonts.medium or love.graphics.newFont(24))
    love.graphics.printf(menu.subtitle, 0, gameHeight * 0.2 + 50, gameWidth, "center")

    -- Draw buttons
    for i, button in ipairs(menu.buttons) do
        -- Button background
        love.graphics.push()
        love.graphics.translate(button.x + button.width / 2, button.y + button.height / 2)
        love.graphics.scale(button.scale, button.scale)

        if i == menu.selected then
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

    -- Draw version info at the bottom
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setFont(assets.fonts.small or love.graphics.newFont(14))
    love.graphics.printf("Version 1.0.0", 0, gameHeight - 40, gameWidth, "center")

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)

    -- Draw placeholder ad if on desktop
    ads.draw()
end

function menu.keypressed(key)
    if key == "up" or key == "w" then
        menu.selected = menu.selected - 1
        if menu.selected < 1 then menu.selected = #menu.buttons end
        assets.playSound("hover", 0.5)
    elseif key == "down" or key == "s" then
        menu.selected = menu.selected + 1
        if menu.selected > #menu.buttons then menu.selected = 1 end
        assets.playSound("hover", 0.5)
    elseif key == "return" or key == "space" then
        if menu.buttons[menu.selected] then
            assets.playSound("click", 0.7)
            menu.buttons[menu.selected].callback()
        end
    end
end

function menu.mousepressed(x, y, button)
    if button ~= 1 then return end

    for i, btn in ipairs(menu.buttons) do
        if x >= btn.x and x <= btn.x + btn.width and
           y >= btn.y and y <= btn.y + btn.height then
            menu.selected = i
            assets.playSound("click", 0.7)
            btn.callback()
            break
        end
    end
end

function menu.mousemoved(x, y)
    for i, btn in ipairs(menu.buttons) do
        local wasHover = btn.hover
        btn.hover = x >= btn.x and x <= btn.x + btn.width and
                    y >= btn.y and y <= btn.y + btn.height

        if btn.hover and not wasHover then
            menu.selected = i
            assets.playSound("hover", 0.3)
        end
    end
end

function menu.exit()
    -- Clean up touch areas when leaving the menu
    for _, button in ipairs(menu.buttons) do
        input.removeTouchArea(button.id)
    end
end

return menu
