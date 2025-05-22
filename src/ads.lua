-- src/ads.lua
-- Manages in-game advertisements integration

local ads = {
    isInitialized = false,
    isEnabled = false,
    isAvailable = false,
    platform = "unknown",

    -- Ad states
    bannerVisible = false,
    interstitialReady = false,
    rewardedReady = false,

    -- Callbacks
    callbacks = {
        onBannerLoaded = nil,
        onBannerFailed = nil,
        onInterstitialLoaded = nil,
        onInterstitialFailed = nil,
        onInterstitialClosed = nil,
        onRewardedLoaded = nil,
        onRewardedFailed = nil,
        onRewardedClosed = nil,
        onRewarded = nil
    },

    -- Default ad units (for placeholder/testing)
    adUnits = {
        banner = "banner_ad_unit",
        interstitial = "interstitial_ad_unit",
        rewarded = "rewarded_ad_unit"
    }
}

function ads.init(config)
    -- Determine platform
    local os = love.system.getOS()
    if os == "Android" then
        ads.platform = "android"
    elseif os == "iOS" then
        ads.platform = "ios"
    else
        ads.platform = "desktop"
    end

    -- Apply configuration
    if config then
        if config.enabled ~= nil then ads.isEnabled = config.enabled end
        if config.adUnits then
            for k, v in pairs(config.adUnits) do
                ads.adUnits[k] = v
            end
        end
    end

    -- On mobile platforms, try to initialize the ad SDK
    if ads.platform == "android" or ads.platform == "ios" then
        if ads.isEnabled then
            -- In a real implementation, this would initialize the ad SDK
            -- For this boilerplate, we'll simulate ad availability
            ads.isAvailable = true
        end
    else
        -- For desktop, only enable ads in debug mode if explicitly set
        ads.isAvailable = ads.isEnabled
    end

    ads.isInitialized = true

    -- Preload ads if available
    if ads.isAvailable then
        ads.loadInterstitial()
        ads.loadRewarded()
    end
end

-- Set callback functions
function ads.setCallbacks(callbacks)
    for k, v in pairs(callbacks) do
        if type(v) == "function" then
            ads.callbacks[k] = v
        end
    end
end

-- Load and show banner ad
function ads.showBanner(position)
    if not ads.isAvailable or not ads.isEnabled then return false end

    position = position or "bottom"

    -- In a real implementation, this would call the ad SDK
    -- For now, just simulate banner loading and display
    ads.bannerVisible = true

    if ads.callbacks.onBannerLoaded then
        ads.callbacks.onBannerLoaded()
    end

    return true
end

-- Hide banner ad
function ads.hideBanner()
    if not ads.isAvailable or not ads.bannerVisible then return false end

    -- In a real implementation, this would call the ad SDK
    ads.bannerVisible = false

    return true
end

-- Load interstitial ad
function ads.loadInterstitial()
    if not ads.isAvailable or not ads.isEnabled then return false end

    -- In a real implementation, this would call the ad SDK
    -- For now, just simulate interstitial loading
    love.timer.setTimeout(1, function()
        ads.interstitialReady = true

        if ads.callbacks.onInterstitialLoaded then
            ads.callbacks.onInterstitialLoaded()
        end
    end)

    return true
end

-- Show interstitial ad
function ads.showInterstitial()
    if not ads.isAvailable or not ads.interstitialReady then return false end

    -- In a real implementation, this would call the ad SDK
    -- For now, just simulate interstitial display
    ads.interstitialReady = false

    -- Simulate ad display and closure
    love.timer.setTimeout(2, function()
        if ads.callbacks.onInterstitialClosed then
            ads.callbacks.onInterstitialClosed()
        end

        -- Automatically load the next interstitial
        ads.loadInterstitial()
    end)

    return true
end

-- Load rewarded ad
function ads.loadRewarded()
    if not ads.isAvailable or not ads.isEnabled then return false end

    -- In a real implementation, this would call the ad SDK
    -- For now, just simulate rewarded ad loading
    love.timer.setTimeout(1, function()
        ads.rewardedReady = true

        if ads.callbacks.onRewardedLoaded then
            ads.callbacks.onRewardedLoaded()
        end
    end)

    return true
end

-- Show rewarded ad
function ads.showRewarded()
    if not ads.isAvailable or not ads.rewardedReady then return false end

    -- In a real implementation, this would call the ad SDK
    -- For now, just simulate rewarded ad display
    ads.rewardedReady = false

    -- Simulate ad display, reward, and closure
    love.timer.setTimeout(2, function()
        -- Simulate user watching the full ad
        if ads.callbacks.onRewarded then
            -- Reward parameters: type, amount
            ads.callbacks.onRewarded("coins", 100)
        end

        love.timer.setTimeout(0.5, function()
            if ads.callbacks.onRewardedClosed then
                ads.callbacks.onRewardedClosed()
            end

            -- Automatically load the next rewarded ad
            ads.loadRewarded()
        end)
    end)

    return true
end

-- Check if banner is visible
function ads.isBannerVisible()
    return ads.bannerVisible
end

-- Check if interstitial is ready
function ads.isInterstitialReady()
    return ads.interstitialReady
end

-- Check if rewarded ad is ready
function ads.isRewardedReady()
    return ads.rewardedReady
end

-- Draw placeholder ads in desktop debug mode
function ads.draw()
    if ads.platform ~= "desktop" or not ads.isEnabled then return end

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)

    -- Draw banner placeholder if visible
    if ads.bannerVisible then
        love.graphics.rectangle("fill", 0, gameHeight - 50, gameWidth, 50)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("BANNER AD PLACEHOLDER", 0, gameHeight - 30, gameWidth, "center")
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

-- Used by game to check ad status when making decisions
function ads.getState()
    return {
        isInitialized = ads.isInitialized,
        isAvailable = ads.isAvailable,
        isEnabled = ads.isEnabled,
        bannerVisible = ads.bannerVisible,
        interstitialReady = ads.interstitialReady,
        rewardedReady = ads.rewardedReady
    }
end

return ads
