-- src/screens/game.lua
-- Main game screen where gameplay happens

local assets = require("src.assets")
local stateManager = require("src.stateManager")
local input = require("src.input")
local physics = require("src.physics")
local ads = require("src.ads")

local game = {
    player = {
        x = 0,
        y = 0,
        speed = 200,
        radius = 20,
        color = {0.2, 0.8, 1, 1}
    },
    paused = false,
    score = 0,
    timeElapsed = 0,
    obstacles = {},
    nextObstacleTime = 2
}

function game.init()
    -- Initialize physics world
    physics.init()

    -- Create game boundaries
    physics.newRectangle("topWall", "static", gameWidth / 2, -10, gameWidth, 20)
    physics.newRectangle("bottomWall", "static", gameWidth / 2, gameHeight + 10, gameWidth, 20)
    physics.newRectangle("leftWall", "static", -10, gameHeight / 2, 20, gameHeight)
    physics.newRectangle("rightWall", "static", gameWidth + 10, gameHeight / 2, 20, gameHeight)
end

function game.enter()
    -- Reset game state
    game.paused = false
    game.score = 0
    game.timeElapsed = 0
    game.obstacles = {}
    game.nextObstacleTime = 2

    -- Position player
    game.player.x = gameWidth / 2
    game.player.y = gameHeight / 2

    -- Create physics object for player
    if physics.objects["player"] then
        physics.removeObject("player")
    end

    game.playerObject = physics.newCircle(
        "player",
        "dynamic",
        game.player.x,
        game.player.y,
        game.player.radius,
        {
            density = 1,
            friction = 0.2,
            restitution = 0.8,
            linearDamping = 1,
            fixedRotation = true,
            type = "player"
        }
    )

    -- Set up virtual buttons for game controls
    if input.touchAvailable then
        -- Define touch areas for mobile controls
        input.defineTouchArea("pauseButton", gameWidth - 60, 20, 40, 40, function()
            stateManager.switchState("pause")
        end)
    end

    -- Play game music
    assets.playMusic("game", 0.5)

    -- If coming from pause, don't reset everything
    if stateManager.stateParams and stateManager.stateParams.fromPause then
        -- Restore state from pause
        if stateManager.stateParams.score then
            game.score = stateManager.stateParams.score
        end
        if stateManager.stateParams.timeElapsed then
            game.timeElapsed = stateManager.stateParams.timeElapsed
        end
    end
end

function game.update(dt)
    -- Update physics world
    physics.update(dt)

    -- Update game timer
    game.timeElapsed = game.timeElapsed + dt

    -- Update player position from physics
    if game.playerObject and game.playerObject.body then
        game.player.x = game.playerObject.body:getX()
        game.player.y = game.playerObject.body:getY()
    end

    -- Handle player input
    local dx, dy = 0, 0

    if input.buttonDown("left") then dx = dx - 1 end
    if input.buttonDown("right") then dx = dx + 1 end
    if input.buttonDown("up") then dy = dy - 1 end
    if input.buttonDown("down") then dy = dy + 1 end

    -- Apply force to player
    if game.playerObject and game.playerObject.body and (dx ~= 0 or dy ~= 0) then
        -- Normalize diagonal movement
        if dx ~= 0 and dy ~= 0 then
            local len = math.sqrt(dx * dx + dy * dy)
            dx = dx / len
            dy = dy / len
        end

        game.playerObject.body:applyForce(dx * game.player.speed * 10, dy * game.player.speed * 10)
    end

    -- Spawn obstacles
    game.nextObstacleTime = game.nextObstacleTime - dt
    if game.nextObstacleTime <= 0 then
        game.spawnObstacle()
        game.nextObstacleTime = 1 + math.random() * 2
    end

    -- Update obstacles
    for i = #game.obstacles, 1, -1 do
        local obstacle = game.obstacles[i]
        obstacle.x = obstacle.x + obstacle.vx * dt
        obstacle.y = obstacle.y + obstacle.vy * dt

        -- Remove obstacles that are off screen
        if obstacle.x < -50 or obstacle.x > gameWidth + 50 or
           obstacle.y < -50 or obstacle.y > gameHeight + 50 then
            table.remove(game.obstacles, i)
            game.score = game.score + 10
        end
    end

    -- Check for pause
    if input.buttonPressed("back") then
        stateManager.switchState("pause", {
            score = game.score,
            timeElapsed = game.timeElapsed
        })
    end
end

function game.spawnObstacle()
    local side = math.random(1, 4)
    local x, y, vx, vy

    -- Spawn from a random side of the screen
    if side == 1 then -- top
        x = math.random(0, gameWidth)
        y = -30
        vx = math.random(-100, 100)
        vy = math.random(50, 150)
    elseif side == 2 then -- right
        x = gameWidth + 30
        y = math.random(0, gameHeight)
        vx = math.random(-150, -50)
        vy = math.random(-100, 100)
    elseif side == 3 then -- bottom
        x = math.random(0, gameWidth)
        y = gameHeight + 30
        vx = math.random(-100, 100)
        vy = math.random(-150, -50)
    else -- left
        x = -30
        y = math.random(0, gameHeight)
        vx = math.random(50, 150)
        vy = math.random(-100, 100)
    end

    -- Add obstacle
    table.insert(game.obstacles, {
        x = x,
        y = y,
        vx = vx,
        vy = vy,
        radius = math.random(10, 30),
        color = {
            math.random(0.5, 1),
            math.random(0.5, 1),
            math.random(0.5, 1),
            1
        }
    })
end

function game.draw()
    -- Draw background
    love.graphics.clear(0.1, 0.1, 0.2, 1)

    -- Draw obstacles
    for _, obstacle in ipairs(game.obstacles) do
        love.graphics.setColor(obstacle.color)
        love.graphics.circle("fill", obstacle.x, obstacle.y, obstacle.radius)
    end

    -- Draw player
    love.graphics.setColor(game.player.color)
    love.graphics.circle("fill", game.player.x, game.player.y, game.player.radius)

    -- Draw physics objects for debug
    if physics.debugDraw then
        physics.draw()
    end

    -- Draw UI elements
    game.drawUI()

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)

    -- Draw any ads
    ads.draw()
end

function game.drawUI()
    -- Draw score
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(assets.fonts.medium or love.graphics.newFont(24))
    love.graphics.print("Score: " .. game.score, 20, 20)

    -- Draw time
    love.graphics.setFont(assets.fonts.small or love.graphics.newFont(16))
    love.graphics.print("Time: " .. string.format("%.1f", game.timeElapsed), 20, 60)

    -- Draw pause button
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", gameWidth - 60, 20, 40, 40, 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", gameWidth - 60, 20, 40, 40, 5, 5)

    -- Pause icon
    love.graphics.rectangle("fill", gameWidth - 50, 30, 5, 20)
    love.graphics.rectangle("fill", gameWidth - 35, 30, 5, 20)
end

function game.keypressed(key, scancode, isrepeat)
    if key == "p" then
        stateManager.switchState("pause", {
            score = game.score,
            timeElapsed = game.timeElapsed
        })
    end
end

function game.mousepressed(x, y, button)
    -- Check if pause button was clicked
    if x >= gameWidth - 60 and x <= gameWidth - 20 and
       y >= 20 and y <= 60 then
        stateManager.switchState("pause", {
            score = game.score,
            timeElapsed = game.timeElapsed
        })
    end
end

function game.exit()
    -- Clean up touch areas
    input.removeTouchArea("pauseButton")

    -- Store game state if going to pause menu
    if stateManager.getCurrentState() == "pause" then
        -- Don't need to do anything, already passed state in switchState
    end
end

return game
