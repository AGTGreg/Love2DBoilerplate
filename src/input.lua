-- src/input.lua
-- Manages input from keyboard, mouse, and touch devices

local input = {
    -- Input state
    keys = {},
    mouseButtons = {},
    touches = {},

    -- Virtual buttons for abstraction
    virtualButtons = {},

    -- Touch areas for UI
    touchAreas = {},

    -- Is touch available?
    touchAvailable = false,

    -- Input mapping
    keyMap = {
        up = {"w", "up"},
        down = {"s", "down"},
        left = {"a", "left"},
        right = {"d", "right"},
        action = {"space", "return"},
        back = {"escape", "backspace"}
    }
}

function input.init()
    -- Check if touch input is available
    input.touchAvailable = love.touch ~= nil

    -- Clear input states
    input.keys = {}
    input.mouseButtons = {}
    input.touches = {}
    input.virtualButtons = {}

    -- Initialize virtual buttons
    for button, _ in pairs(input.keyMap) do
        input.virtualButtons[button] = {
            pressed = false,
            down = false,
            released = false
        }
    end
end

function input.update(dt)
    -- Reset one-frame button states
    for button, state in pairs(input.virtualButtons) do
        state.pressed = false
        state.released = false
    end

    -- Update virtual button states based on keyboard
    for vButton, keys in pairs(input.keyMap) do
        local wasDown = input.virtualButtons[vButton].down
        local isDown = false

        for _, key in ipairs(keys) do
            if input.keys[key] then
                isDown = true
                break
            end
        end

        input.virtualButtons[vButton].down = isDown
        input.virtualButtons[vButton].pressed = isDown and not wasDown
        input.virtualButtons[vButton].released = not isDown and wasDown
    end
end

-- Check if a virtual button was just pressed this frame
function input.buttonPressed(button)
    return input.virtualButtons[button] and input.virtualButtons[button].pressed
end

-- Check if a virtual button is being held down
function input.buttonDown(button)
    return input.virtualButtons[button] and input.virtualButtons[button].down
end

-- Check if a virtual button was just released this frame
function input.buttonReleased(button)
    return input.virtualButtons[button] and input.virtualButtons[button].released
end

-- Define a touch area for UI interaction
function input.defineTouchArea(id, x, y, width, height, callback)
    input.touchAreas[id] = {
        x = x,
        y = y,
        width = width,
        height = height,
        callback = callback,
        active = true,
        pressed = false
    }
end

-- Remove a touch area
function input.removeTouchArea(id)
    input.touchAreas[id] = nil
end

-- Check if a point is inside a touch area
function input.pointInTouchArea(area, x, y)
    return x >= area.x and x <= area.x + area.width and
           y >= area.y and y <= area.y + area.height
end

-- Check touch/mouse input against defined areas
function input.checkTouchAreas(x, y, pressed)
    for id, area in pairs(input.touchAreas) do
        if area.active and input.pointInTouchArea(area, x, y) then
            if pressed then
                area.pressed = true
            elseif area.pressed then
                area.pressed = false
                if area.callback then
                    area.callback(id)
                end
                return true
            end
        else
            area.pressed = false
        end
    end
    return false
end

-- Event callbacks
function input.keypressed(key, scancode, isrepeat)
    input.keys[key] = true
end

function input.keyreleased(key, scancode)
    input.keys[key] = false
end

function input.mousepressed(x, y, button, istouch, presses)
    input.mouseButtons[button] = true

    -- Process touch areas
    if button == 1 then
        input.checkTouchAreas(x, y, true)
    end
end

function input.mousereleased(x, y, button, istouch, presses)
    input.mouseButtons[button] = false

    -- Process touch areas
    if button == 1 then
        input.checkTouchAreas(x, y, false)
    end
end

function input.touchpressed(id, x, y, dx, dy, pressure)
    input.touches[id] = {x = x, y = y, pressure = pressure}

    -- Process touch areas
    input.checkTouchAreas(x, y, true)
end

function input.touchreleased(id, x, y, dx, dy, pressure)
    -- Process touch areas before removing the touch
    local touch = input.touches[id]
    if touch then
        input.checkTouchAreas(x, y, false)
    end

    input.touches[id] = nil
end

function input.touchmoved(id, x, y, dx, dy, pressure)
    if input.touches[id] then
        input.touches[id].x = x
        input.touches[id].y = y
        input.touches[id].pressure = pressure
    end
end

return input
