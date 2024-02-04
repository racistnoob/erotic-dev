-- locals --
local timecycles = {
    ["default"] = "default",
    ["nofog"] = "full_bright",
    ["nofoglow"] = "full_bright_low_clip",
}

function SetTimecycleModifierEffect(timecycleEffect)
    if timecycleEffect then
        SetTimecycleModifier(timecycleEffect)
        print("Timecycle effect changed to:", timecycleEffect)
    else
        print("Invalid timecycle effect:", timecycleEffect)
    end
end

RegisterNetEvent('reset-timecycle')
AddEventHandler('reset-timecycle', function()
    local kvpValue = GetResourceKvpString("graphics_timecycle")
    if kvpValue then
        print('KVP loaded:', kvpValue)
        SetTimecycleModifierEffect(kvpValue)
    elseif kvpValue == nil then
        SetTimecycleModifierEffect("default")
    end
end)

RegisterNetEvent('set-timecycle')
AddEventHandler('set-timecycle', function(params)
    local timecycleType = params.type
    local timecycleName = timecycles[timecycleType]
    
    if timecycleName then
        SetResourceKvp("graphics_timecycle", timecycleName) -- Store the timecycle name as a string
        print('KVP loaded', timecycleName)
        SetTimecycleModifierEffect(timecycleName)
    else
        print("Invalid timecycle type.")
    end
end)



AddEventHandler('erotic:playerSpawned', function()
    local kvpValue = GetResourceKvpString("graphics_timecycle")
        
    if kvpValue then
        print('KVP loaded:', kvpValue)
        SetTimecycleModifierEffect(kvpValue)
    else
        print("Player does not have KVP.")
    end
end)

--[[AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_timecycle")
            
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            SetTimecycleModifierEffect(kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)]]

local submenu = {
    {
        id = 1,
        header = "< Go Back",
        txt = "",
        params = {
            event = "erp-context:GoBackToMainMenu"
        }
    },
    {
        id = 2,
        header = "Default",
        txt = "Set the time cycle to default",
        params = {
            event = "set-timecycle",
            args = {
                type = "default",
                number = 1,
                id = 2
            }
        }
    },
    {
        id = 3,
        header = "No Fog",
        txt = "Set the No Fog",
        params = {
            event = "set-timecycle",
            args = {
                type = "nofog",
                number = 2,
                id = 3
            }
        }
    },
    {
        id = 4,
        header = "No Fog Low Render",
        txt = "Set the No Fog with low render",
        params = {
            event = "set-timecycle",
            args = {
                type = "nofoglow",
                number = 3,
                id = 4
            }
        }
    },
}

exports("getTimecycleSubMenu", function()
    return submenu
end)