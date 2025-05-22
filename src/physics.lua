-- src/physics.lua
-- Manages game physics using Love2D's built-in Box2D integration

local physics = {
    world = nil,
    scale = 64,  -- pixels per meter
    gravity = {x = 0, y = 9.81},
    objects = {},
    debugDraw = false
}

function physics.init()
    -- Create a new physics world with gravity
    physics.world = love.physics.newWorld(physics.gravity.x, physics.gravity.y, true)

    -- Set up collision callbacks
    physics.world:setCallbacks(
        physics.beginContact,
        physics.endContact,
        physics.preSolve,
        physics.postSolve
    )

    -- Clear objects list
    physics.objects = {}
end

function physics.update(dt)
    if physics.world then
        physics.world:update(dt)
    end
end

function physics.draw()
    if not physics.debugDraw then return end

    -- Debug drawing of physics objects
    love.graphics.setColor(0, 1, 0, 0.5)
    for _, object in pairs(physics.objects) do
        if object.body and object.shape then
            local bodyType = object.body:getType()

            -- Set color based on body type
            if bodyType == "static" then
                love.graphics.setColor(0.7, 0.7, 0.7, 0.5)
            elseif bodyType == "dynamic" then
                love.graphics.setColor(0, 1, 0, 0.5)
            elseif bodyType == "kinematic" then
                love.graphics.setColor(0, 0.7, 1, 0.5)
            end

            -- Draw shape based on type
            local shapeType = object.shape:getType()

            if shapeType == "circle" then
                local x, y = object.body:getPosition()
                local radius = object.shape:getRadius()
                love.graphics.circle("fill", x, y, radius)

                -- Draw a line to show rotation
                local angle = object.body:getAngle()
                love.graphics.line(x, y, x + math.cos(angle) * radius, y + math.sin(angle) * radius)

            elseif shapeType == "polygon" then
                local points = {object.body:getWorldPoints(object.shape:getPoints())}
                love.graphics.polygon("fill", points)

            elseif shapeType == "edge" or shapeType == "chain" then
                local points = {object.body:getWorldPoints(object.shape:getPoints())}
                love.graphics.line(points)
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

-- Create a new physics object
function physics.newObject(id, bodyType, x, y, shape, properties)
    if not physics.world then return nil end

    properties = properties or {}

    local object = {
        id = id,
        body = love.physics.newBody(physics.world, x, y, bodyType),
        fixtures = {},
        properties = properties
    }

    -- Set properties
    if properties.linearDamping then object.body:setLinearDamping(properties.linearDamping) end
    if properties.angularDamping then object.body:setAngularDamping(properties.angularDamping) end
    if properties.bullet then object.body:setBullet(properties.bullet) end
    if properties.fixedRotation then object.body:setFixedRotation(properties.fixedRotation) end
    if properties.gravityScale then object.body:setGravityScale(properties.gravityScale) end

    -- Handle shape
    if shape then
        object.shape = shape

        -- Create fixture
        local fixture = love.physics.newFixture(object.body, shape, properties.density or 1)
        table.insert(object.fixtures, fixture)

        -- Set fixture properties
        if properties.friction then fixture:setFriction(properties.friction) end
        if properties.restitution then fixture:setRestitution(properties.restitution) end
        if properties.sensor then fixture:setSensor(properties.sensor) end
        if properties.category then fixture:setCategory(unpack(properties.category)) end
        if properties.mask then fixture:setMask(unpack(properties.mask)) end
        if properties.group then fixture:setGroupIndex(properties.group) end

        -- Set user data for callbacks
        fixture:setUserData({id = id, type = properties.type or "unknown"})
    end

    -- Store the object
    physics.objects[id] = object

    return object
end

-- Create common shapes
function physics.newRectangle(id, bodyType, x, y, width, height, properties)
    local shape = love.physics.newRectangleShape(width, height)
    return physics.newObject(id, bodyType, x, y, shape, properties)
end

function physics.newCircle(id, bodyType, x, y, radius, properties)
    local shape = love.physics.newCircleShape(radius)
    return physics.newObject(id, bodyType, x, y, shape, properties)
end

function physics.newPolygon(id, bodyType, x, y, vertices, properties)
    local shape = love.physics.newPolygonShape(vertices)
    return physics.newObject(id, bodyType, x, y, shape, properties)
end

function physics.newEdge(id, bodyType, x, y, x1, y1, x2, y2, properties)
    local shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    return physics.newObject(id, bodyType, x, y, shape, properties)
end

function physics.newChain(id, bodyType, x, y, vertices, loop, properties)
    local shape = love.physics.newChainShape(loop, vertices)
    return physics.newObject(id, bodyType, x, y, shape, properties)
end

-- Remove an object from the physics world
function physics.removeObject(id)
    local object = physics.objects[id]
    if object and object.body then
        object.body:destroy()
        physics.objects[id] = nil
    end
end

-- Collision callbacks
function physics.beginContact(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()

    if data1 and data2 then
        -- Find the associated objects
        local obj1 = physics.objects[data1.id]
        local obj2 = physics.objects[data2.id]

        -- Call object-specific callbacks if they exist
        if obj1 and obj1.beginContact then
            obj1.beginContact(obj2, contact)
        end

        if obj2 and obj2.beginContact then
            obj2.beginContact(obj1, contact)
        end
    end
end

function physics.endContact(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()

    if data1 and data2 then
        -- Find the associated objects
        local obj1 = physics.objects[data1.id]
        local obj2 = physics.objects[data2.id]

        -- Call object-specific callbacks if they exist
        if obj1 and obj1.endContact then
            obj1.endContact(obj2, contact)
        end

        if obj2 and obj2.endContact then
            obj2.endContact(obj1, contact)
        end
    end
end

function physics.preSolve(fixture1, fixture2, contact)
    -- Pre-solve callback for advanced collision handling
end

function physics.postSolve(fixture1, fixture2, contact, normal, tangent)
    -- Post-solve callback for collision response
end

return physics
