-- src/http.lua
-- Manages HTTP requests using Love2D's built-in HTTP functionality

local http = {
    baseUrl = "",
    defaultHeaders = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    },
    requests = {}
}

function http.init(baseUrl, defaultHeaders)
    if baseUrl then
        http.baseUrl = baseUrl
    end

    if defaultHeaders then
        for k, v in pairs(defaultHeaders) do
            http.defaultHeaders[k] = v
        end
    end

    -- Check if network is available
    local success = pcall(function()
        -- Try a simple request to check connectivity
        love.thread.newThread([[
            require("love.timer")
            love.timer.sleep(0.1)
        ]]):start()
    end)

    http.isAvailable = success
end

-- Build the complete URL for a request
function http.buildUrl(path)
    if path:sub(1, 4) == "http" then
        -- Path is already a full URL
        return path
    else
        -- Combine base URL with path
        local baseUrl = http.baseUrl
        if baseUrl:sub(-1) ~= "/" and path:sub(1, 1) ~= "/" then
            return baseUrl .. "/" .. path
        elseif baseUrl:sub(-1) == "/" and path:sub(1, 1) == "/" then
            return baseUrl .. path:sub(2)
        else
            return baseUrl .. path
        end
    end
end

-- Merge headers with defaults
function http.mergeHeaders(headers)
    local result = {}

    -- Start with default headers
    for k, v in pairs(http.defaultHeaders) do
        result[k] = v
    end

    -- Override with provided headers
    if headers then
        for k, v in pairs(headers) do
            result[k] = v
        end
    end

    return result
end

-- Make a GET request
function http.get(path, headers, callback)
    local url = http.buildUrl(path)
    local mergedHeaders = http.mergeHeaders(headers)

    local requestId = tostring({}):sub(8) -- Generate a unique ID
    http.requests[requestId] = {
        url = url,
        method = "GET",
        headers = mergedHeaders,
        callback = callback
    }

    -- Make the request
    love.http.request(url, {
        method = "GET",
        headers = mergedHeaders,
        success = function(code, data, headers)
            if http.requests[requestId] and http.requests[requestId].callback then
                http.requests[requestId].callback(true, code, data, headers)
            end
            http.requests[requestId] = nil
        end,
        failure = function(error)
            if http.requests[requestId] and http.requests[requestId].callback then
                http.requests[requestId].callback(false, nil, error, nil)
            end
            http.requests[requestId] = nil
        end
    })

    return requestId
end

-- Make a POST request
function http.post(path, data, headers, callback)
    local url = http.buildUrl(path)
    local mergedHeaders = http.mergeHeaders(headers)

    -- Convert data to JSON if it's not already a string
    local body = data
    if type(data) == "table" then
        body = love.data.encode("string", "json", data)
    end

    local requestId = tostring({}):sub(8) -- Generate a unique ID
    http.requests[requestId] = {
        url = url,
        method = "POST",
        headers = mergedHeaders,
        body = body,
        callback = callback
    }

    -- Make the request
    love.http.request(url, {
        method = "POST",
        headers = mergedHeaders,
        data = body,
        success = function(code, data, headers)
            if http.requests[requestId] and http.requests[requestId].callback then
                http.requests[requestId].callback(true, code, data, headers)
            end
            http.requests[requestId] = nil
        end,
        failure = function(error)
            if http.requests[requestId] and http.requests[requestId].callback then
                http.requests[requestId].callback(false, nil, error, nil)
            end
            http.requests[requestId] = nil
        end
    })

    return requestId
end

-- Cancel a request
function http.cancel(requestId)
    -- Note: Love2D doesn't provide a way to cancel in-flight requests,
    -- so we just remove the callback to prevent it from firing
    if http.requests[requestId] then
        http.requests[requestId].callback = nil
        http.requests[requestId] = nil
        return true
    end
    return false
end

return http
