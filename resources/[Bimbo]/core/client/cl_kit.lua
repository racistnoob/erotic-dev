RegisterCommand('kit', function(source, args, rawCommand)
    local kitName = args[1]

    if kitName then
        TriggerServerEvent('core:applyKit', kitName)
        print("Applying kit:", kitName)
    else
        print("Usage: /kit <kitname>")
    end
end, false)

RegisterCommand('rkit', function(source, args, rawCommand)
    local kitName = args[1]

    if kitName then
        TriggerServerEvent('core:removeKit', kitName)
        print("Removing kit:", kitName)
    else
        print("Usage: /rkit <kitname>")
    end
end, false)

RegisterNetEvent('empty:hands')
AddEventHandler('empty:hands', function()
    TriggerEvent("actionbar:setEmptyHanded")
end)

--[[AddEventHandler('baseevents:onPlayerDied', function()
    TriggerServerEvent('removeKit', "default")
    Citizen.Wait(100)
    TriggerServerEvent('applyKit', "default")
end)

AddEventHandler('baseevents:onPlayerDied', function()
    TriggerServerEvent('removeKit', kit[selected])
    Citizen.Wait(100)
    TriggerServerEvent('applyKit', kit[selected])
end)]]