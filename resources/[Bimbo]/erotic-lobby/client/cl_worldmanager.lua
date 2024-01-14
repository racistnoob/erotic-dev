currentWorldID = 1

RegisterNUICallback('switchWorld', function(data, cb)
    if data.worldId then
        exports['erotic-lobby']:switchWorld(data.worldId)
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)

AddEventHandler('echorp:playerSpawned', function()
    local src = source;
    TriggerServerEvent('erotic-lobby:SpawnWorldTrigger');
    exports['lane-inventory']:DoKitStuff("ars", "hopout")
end)

RegisterNetEvent('erotic-lobby:KillPlayer')
AddEventHandler('erotic-lobby:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0) -- Sets the player's health to 0, effectively killing them
end)

RegisterNetEvent("erotic-lobby:ChangeCoords")
AddEventHandler("erotic-lobby:ChangeCoords", function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false);
end)

RegisterNetEvent('erotic-lobby:updateLobby')
AddEventHandler('erotic-lobby:updateLobby', function(worldID)
    currentWorldID = worldID
end)

RegisterNetEvent('erotic-lobby:sendPlayerCount')
AddEventHandler('erotic-lobby:sendPlayerCount', function(playerCount)
    -- Send this data to the NUI (frontend)
    SendNUIMessage({
        type = "updatePlayerCount",
        worldId = currentWorldID,
        count = playerCount
    })
end)

exports('getCurrentWorld', function()
    return currentWorldID
end)

exports('ChangeWorld', function(worldId)
    TriggerServerEvent('erotic-lobby:ChangeWorld', worldId)
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
end)