RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)

    local event = data.event
    local args = data.args

    TriggerEvent(event, args)
    cb('ok')
end)

RegisterNUICallback("cancel", function(cb)
    SetNuiFocus(false)
    TriggerEvent('erp-context:cancel')
end)

RegisterNetEvent('erp-context:forceClose', function()
    SetNuiFocus(false)
    TriggerEvent('erp-context:cancel')
end)

function OpenContextMenu(data)
    if not data then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
end

RegisterNetEvent('erp-context:sendMenu', OpenContextMenu)
exports("OpenContextMenu", OpenContextMenu)

local mainMenu = {
    {
        id = 1,
        header = "Game Settings",
        txt = ""
    },
    {
        id = 2,
        header = "Weather",
        txt = "Adjust in-game weather settings",
        params = {
            event = "erp-context:submenu",
            args = {
                number = 1, -- You can modify these values as needed
                id = 2
            }
        }
    },
    {
        id = 3,
        header = "TimeCycle",
        txt = "Adjust time of day settings",
        params = {
            event = "erp-context:submenu",
            args = {
                number = 2, -- You can modify these values as needed
                id = 3
            }
        }
    },
    {
        id = 4,
        header = "BloodFx",
        txt = "Configure blood effects",
        params = {
            event = "erp-context:submenu",
            args = {
                number = 3, -- You can modify these values as needed
                id = 4
            }
        }
    },
    -- {
    --     id = 7,
    --     header = "FPS BOOSTER",
    --     txt = "boost fps now",
    --     params = {
    --         event = "erp-context:submenu",
    --         args = {
    --             number = 6, -- You can modify these values as needed
    --             id = 7
    --         }
    --     }
    -- },
}

RegisterNetEvent('erp-context:submenu', function(data)
    local id = data.id
    local submenu = {}

    if id == 2 then
        submenu = exports["effects"]:getWeatherSubMenu()
    elseif id == 3 then
        submenu = exports["effects"]:getTimecycleSubMenu()
    elseif id == 4 then
        submenu = exports["effects"]:getBloodFXSubMenu()
    elseif id == 5 then

    elseif id == 6 then
        
    elseif id == 7 then
        
    end

    TriggerEvent('erp-context:sendMenu', submenu)
end)

RegisterCommand("settings", function(source, args, raw)
    TriggerEvent("erp-context:sendMenu", mainMenu)
end)

RegisterNetEvent('erp-context:GoBackToMainMenu')
AddEventHandler('erp-context:GoBackToMainMenu', function()
    TriggerEvent("erp-context:sendMenu", mainMenu)
end)