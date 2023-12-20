---@diagnostic disable: trailing-space
local loopType = nil

-- Functions

---@param shadow boolean
---@param air boolean
local function setShadowAndAir(shadow, air)
    RopeDrawShadowEnabled(shadow)
    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(air)
end

---@param entity boolean
---@param dynamic boolean
---@param tracker number
---@param depth number
---@param bounds number
local function setEntityTracker(entity, dynamic, tracker, depth, bounds)
    CascadeShadowsEnableEntityTracker(entity)
    CascadeShadowsSetDynamicDepthMode(dynamic)
    CascadeShadowsSetEntityTrackerScale(tracker)
    CascadeShadowsSetDynamicDepthValue(depth)
    CascadeShadowsSetCascadeBoundsScale(bounds)
end

---@param distance number
---@param tweak number
local function setLights(distance, tweak)
    SetFlashLightFadeDistance(distance)
    SetLightsCutoffDistanceTweak(tweak)
end

---@param notify string
local function notify(message)
    print(message)
end

---@param type string
local function umfpsBooster(type)
    if type == "reset" then
        setShadowAndAir(true, true)
        setEntityTracker(true, true, 5.0, 5.0, 5.0)
        setLights(10.0, 10.0)
        notify("Mode: Reset")
    elseif type == "ulow" then
        setShadowAndAir(false, false)
        setEntityTracker(true, false, 0.0, 0.0, 0.0)
        setLights(0.0, 0.0)
        notify("Mode: Ultra Low")
    elseif type == "low" then
        setShadowAndAir(false, false)
        setEntityTracker(true, false, 0.0, 0.0, 0.0)
        setLights(5.0, 5.0)
        notify("Mode: Low")
    elseif type == "medium" then
        setShadowAndAir(true, false)
        setEntityTracker(true, false, 5.0, 3.0, 3.0)
        setLights(3.0, 3.0)
        notify("Mode: Medium")
    else
        notify("Usage: /fps [reset/ulow/low/medium]")
        notify("Invalid type: " .. type)
        return
    end
    loopType = type
end

RegisterNetEvent("core:toggle-fps")
AddEventHandler("core:toggle-fps", function(params)
    local fpsType = params.type
    
    if fpsType then
        umfpsBooster(fpsType)
    else
        notify("Invalid usage.")
    end
end)

-- Main Loop

-- // Distance rendering and entity handler (need a revision)
CreateThread(function()
    while true do
        if loopType == "ulow" then
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Wait(1)
            end
            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "low" then
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Wait(1)
            end
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "medium" then
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Wait(1)
            end
        else
            Wait(500)
        end
        Wait(8)
    end
end)

--// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
CreateThread(function()
    while true do
        if loopType == "ulow" or loopType == "low" then
            local ped = PlayerPedId()

            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearPedBloodDamage(ped)
            ClearPedWetness(ped)
            ClearPedEnvDirt(ped)
            ResetPedVisibleDamage(ped)
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)
            Wait(300)
        elseif loopType == "medium" then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Wait(1000)
        else
            Wait(1500)
        end
    end
end)

local fpssubmenu = {
    {
        id = 1,
        header = "< Go Back",
        txt = "HAS ISSUES WITH TIMECYCLE WHEN USED :WIP: TESTING ACCESS: TRUE",
        params = {
            event = "erp-context:GoBackToMainMenu"
        }
    },
    {
        id = 2,
        header = "Reset",
        txt = "Reset the fps booster",
        params = {
            event = "core:toggle-fps",
            args = {
                type = "reset",
                number = 1,
                id = 2
            }
        }
    },
    {
        id = 3,
        header = "Ultra Low",
        txt = "Set fps booster to Ultra low",
        params = {
            event = "core:toggle-fps",
            args = {
                type = "ulow",
                number = 2,
                id = 3
            }
        }
    },
    {
        id = 4,
        header = "Low",
        txt = "Set fps booster to Low",
        params = {
            event = "core:toggle-fps",
            args = {
                type = "low",
                number = 3,
                id = 4
            }
        }
    },
    {
        id = 5,
        header = "Medium",
        txt = "Set fps booster to Medium",
        params = {
            event = "core:toggle-fps",
            args = {
                type = "medium",
                number = 4,
                id = 5
            }
        }
    },
}

exports("getFpsSubMenu", function()
    return fpssubmenu
end)