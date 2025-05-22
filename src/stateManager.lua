-- src/stateManager.lua
-- Manages game states (screens) and transitions between them

local stateManager = {}

-- Table to store registered states
local states = {}
local currentState = nil
local nextState = nil
local stateTransition = false
local transitionProgress = 0
local transitionSpeed = 2 -- transition completes in 0.5 seconds

function stateManager.registerState(stateName, stateTable)
    states[stateName] = stateTable
    -- Initialize the state if it has an init function
    if stateTable.init then
        stateTable.init()
    end
end

function stateManager.getCurrentState()
    return currentState
end

function stateManager.switchState(stateName, params)
    if states[stateName] then
        -- If there's a current state and it has an exit function, call it
        if currentState and states[currentState].exit then
            states[currentState].exit()
        end

        -- Set the next state
        nextState = stateName
        stateTransition = true
        transitionProgress = 0

        -- Save parameters to pass to the enter function
        if params then
            stateManager.stateParams = params
        else
            stateManager.stateParams = {}
        end
    else
        error("State '" .. stateName .. "' not registered")
    end
end

function stateManager.update(dt)
    if stateTransition then
        -- Update transition progress
        transitionProgress = transitionProgress + dt * transitionSpeed

        if transitionProgress >= 1 then
            -- Transition complete, switch states
            currentState = nextState
            stateTransition = false

            -- Enter the new state
            if states[currentState].enter then
                states[currentState].enter(stateManager.stateParams)
            end
        end
    elseif currentState and states[currentState].update then
        -- Update the current state
        states[currentState].update(dt)
    end
end

function stateManager.draw()
    -- Draw the current state
    if currentState and states[currentState].draw then
        -- Apply transition effects if transitioning
        if stateTransition then
            love.graphics.setColor(1, 1, 1, 1 - transitionProgress)
            states[currentState].draw()

            if transitionProgress > 0 then
                love.graphics.setColor(1, 1, 1, transitionProgress)
                if states[nextState] and states[nextState].draw then
                    states[nextState].draw()
                end
            end

            love.graphics.setColor(1, 1, 1, 1)
        else
            states[currentState].draw()
        end
    end
end

-- Forward input events to the current state
function stateManager.keypressed(key, scancode, isrepeat)
    if not stateTransition and currentState and states[currentState].keypressed then
        states[currentState].keypressed(key, scancode, isrepeat)
    end
end

function stateManager.keyreleased(key, scancode)
    if not stateTransition and currentState and states[currentState].keyreleased then
        states[currentState].keyreleased(key, scancode)
    end
end

function stateManager.mousepressed(x, y, button, istouch, presses)
    if not stateTransition and currentState and states[currentState].mousepressed then
        states[currentState].mousepressed(x, y, button, istouch, presses)
    end
end

function stateManager.mousereleased(x, y, button, istouch, presses)
    if not stateTransition and currentState and states[currentState].mousereleased then
        states[currentState].mousereleased(x, y, button, istouch, presses)
    end
end

function stateManager.touchpressed(id, x, y, dx, dy, pressure)
    if not stateTransition and currentState and states[currentState].touchpressed then
        states[currentState].touchpressed(id, x, y, dx, dy, pressure)
    end
end

function stateManager.touchreleased(id, x, y, dx, dy, pressure)
    if not stateTransition and currentState and states[currentState].touchreleased then
        states[currentState].touchreleased(id, x, y, dx, dy, pressure)
    end
end

function stateManager.touchmoved(id, x, y, dx, dy, pressure)
    if not stateTransition and currentState and states[currentState].touchmoved then
        states[currentState].touchmoved(id, x, y, dx, dy, pressure)
    end
end

return stateManager
