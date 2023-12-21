currentWorldID = 0
currentWorldName = "1"

AddEventHandler('echorp:playerSpawned', function()
    local src = source;
    TriggerServerEvent('erotic-lobby:SpawnWorldTrigger');
    exports['lane-inventory']:DoKitStuff("hopout")
end)

RegisterNetEvent('erotic-lobby:KillPlayer')
AddEventHandler('erotic-lobby:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0) -- Sets the player's health to 0, effectively killing them
end)

RegisterNetEvent("erotic-lobby:ChangeCoords")
AddEventHandler("erotic-lobby:ChangeCoords", function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false);
end)

--[[RegisterCommand("world", function(source, args, rawCommand)
    local src = source;
    if #args == 0 then
        -- Invalid maybe idk
        return;
    end
    TriggerServerEvent('erotic-lobby:ChangeWorld', args[1]);
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
end)]]

RegisterNetEvent('erotic-lobby:updateLobby')
AddEventHandler('erotic-lobby:updateLobby', function(worldID, worldName)
    currentWorldID = worldID
    currentWorldName = worldName
end)

exports('getCurrentWorld', function()
    return currentWorldID, currentWorldName
end)

exports('ChangeWorld', function(worldId)
    TriggerServerEvent('erotic-lobby:ChangeWorld', worldId)
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
end)