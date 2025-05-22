-- imageGenerator.lua
-- Small utility to generate placeholder images for the boilerplate

local imageGenerator = {}

function love.conf(t)
    t.window.width = 512
    t.window.height = 512
    t.window.title = "Image Generator"
end

function love.load()
    print("Generating placeholder images...")

    -- Create placeholder image
    createPlaceholderImage("placeholder.png", 100, 100)

    -- Create logo image
    createLogoImage("logo.png", 200, 200)

    -- Create button images
    createButtonImage("button.png", 200, 50, {0.2, 0.5, 0.8, 1})
    createButtonImage("button_hover.png", 200, 50, {0.3, 0.7, 1, 1})

    print("Image generation complete!")
    love.event.quit()
end

function createPlaceholderImage(filename, width, height)
    local imageData = love.image.newImageData(width, height)

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            -- Create a checkered pattern
            local isEvenX = math.floor(x / 10) % 2 == 0
            local isEvenY = math.floor(y / 10) % 2 == 0

            if isEvenX == isEvenY then
                imageData:setPixel(x, y, 0.8, 0.8, 0.8, 1)
            else
                imageData:setPixel(x, y, 0.5, 0.5, 0.5, 1)
            end

            -- Draw borders
            if x < 2 or x >= width - 2 or y < 2 or y >= height - 2 then
                imageData:setPixel(x, y, 0.3, 0.3, 0.3, 1)
            end
        end
    end

    -- Save the image
    imageData:encode("png", filename)
    print("Created " .. filename)
end

function createLogoImage(filename, width, height)
    local imageData = love.image.newImageData(width, height)
    local centerX, centerY = width / 2, height / 2
    local radius = math.min(width, height) * 0.4

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            -- Calculate distance from center
            local dx, dy = x - centerX, y - centerY
            local distance = math.sqrt(dx * dx + dy * dy)

            -- Create heart shape
            local angle = math.atan2(dy, dx)
            local heartR = radius * (1 - 0.3 * math.sin(angle * 2))

            -- Fill with color
            if distance < heartR then
                -- Inside the shape
                local r = 0.8 + 0.2 * (1 - distance / radius)
                local g = 0.2 + 0.3 * (1 - distance / radius)
                local b = 0.5 + 0.5 * (1 - distance / radius)
                imageData:setPixel(x, y, r, g, b, 1)
            else
                -- Outside the shape (transparent)
                imageData:setPixel(x, y, 0, 0, 0, 0)
            end
        end
    end

    -- Draw text
    drawText(imageData, "LÖVE", width / 2, height / 2, width * 0.1)

    -- Save the image
    imageData:encode("png", filename)
    print("Created " .. filename)
end

function createButtonImage(filename, width, height, color)
    local imageData = love.image.newImageData(width, height)

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            -- Calculate distance from edges for rounded corners
            local cornerRadius = height / 3
            local edgeX = math.min(x, width - 1 - x)
            local edgeY = math.min(y, height - 1 - y)

            -- Check if we're in a corner region
            if edgeX < cornerRadius and edgeY < cornerRadius then
                -- Calculate distance from corner
                local dx = cornerRadius - edgeX
                local dy = cornerRadius - edgeY
                local distance = math.sqrt(dx * dx + dy * dy)

                if distance <= cornerRadius then
                    -- Inside the rounded corner
                    imageData:setPixel(x, y, color[1], color[2], color[3], color[4])
                else
                    -- Outside the rounded corner (transparent)
                    imageData:setPixel(x, y, 0, 0, 0, 0)
                end
            else
                -- Not in a corner, fill with color
                imageData:setPixel(x, y, color[1], color[2], color[3], color[4])
            end
        end
    end

    -- Save the image
    imageData:encode("png", filename)
    print("Created " .. filename)
end

function drawText(imageData, text, x, y, size)
    -- Very simple "pixel font" implementation
    -- This is very basic and only handles uppercase letters

    local letterWidth = math.floor(size * 0.6)
    local letterHeight = math.floor(size)
    local spacing = math.floor(size * 0.2)
    local startX = x - (text:len() * (letterWidth + spacing)) / 2

    for i = 1, #text do
        local char = text:sub(i, i)
        local charX = startX + (i - 1) * (letterWidth + spacing)

        -- Draw each letter
        if char == "L" then
            drawLine(imageData, charX, y - letterHeight/2, charX, y + letterHeight/2, 2, {1,1,1,1})
            drawLine(imageData, charX, y + letterHeight/2, charX + letterWidth, y + letterHeight/2, 2, {1,1,1,1})
        elseif char == "Ö" or char == "O" then
            drawCircle(imageData, charX + letterWidth/2, y, letterWidth/2, letterHeight/2, {1,1,1,1})
            -- Add umlaut for Ö
            if char == "Ö" then
                drawCircle(imageData, charX + letterWidth/3, y - letterHeight/2 + size/6, size/10, size/10, {1,1,1,1})
                drawCircle(imageData, charX + letterWidth*2/3, y - letterHeight/2 + size/6, size/10, size/10, {1,1,1,1})
            end
        elseif char == "V" then
            drawLine(imageData, charX, y - letterHeight/2, charX + letterWidth/2, y + letterHeight/2, 2, {1,1,1,1})
            drawLine(imageData, charX + letterWidth/2, y + letterHeight/2, charX + letterWidth, y - letterHeight/2, 2, {1,1,1,1})
        elseif char == "E" then
            drawLine(imageData, charX, y - letterHeight/2, charX, y + letterHeight/2, 2, {1,1,1,1})
            drawLine(imageData, charX, y - letterHeight/2, charX + letterWidth, y - letterHeight/2, 2, {1,1,1,1})
            drawLine(imageData, charX, y, charX + letterWidth*0.8, y, 2, {1,1,1,1})
            drawLine(imageData, charX, y + letterHeight/2, charX + letterWidth, y + letterHeight/2, 2, {1,1,1,1})
        end
    end
end

function drawLine(imageData, x1, y1, x2, y2, thickness, color)
    x1, y1, x2, y2 = math.floor(x1), math.floor(y1), math.floor(x2), math.floor(y2)

    local dx, dy = x2 - x1, y2 - y1
    local steps = math.max(math.abs(dx), math.abs(dy))

    for i = 0, steps do
        local t = steps == 0 and 0 or i / steps
        local x = math.floor(x1 + dx * t)
        local y = math.floor(y1 + dy * t)

        -- Draw a thick point
        for ox = -thickness, thickness do
            for oy = -thickness, thickness do
                if ox*ox + oy*oy <= thickness*thickness then
                    local px, py = x + ox, y + oy
                    if px >= 0 and px < imageData:getWidth() and py >= 0 and py < imageData:getHeight() then
                        imageData:setPixel(px, py, color[1], color[2], color[3], color[4])
                    end
                end
            end
        end
    end
end

function drawCircle(imageData, cx, cy, rx, ry, color)
    cx, cy = math.floor(cx), math.floor(cy)

    for y = cy - ry - 1, cy + ry + 1 do
        for x = cx - rx - 1, cx + rx + 1 do
            if x >= 0 and x < imageData:getWidth() and y >= 0 and y < imageData:getHeight() then
                local dx, dy = x - cx, y - cy
                local distance = (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry)

                if distance <= 1 and distance >= 0.8 then
                    imageData:setPixel(x, y, color[1], color[2], color[3], color[4])
                end
            end
        end
    end
end

-- Run the program
if arg and arg[0] then
    -- Run as a standalone script
    love.run()
end

return imageGenerator
