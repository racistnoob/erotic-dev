RegisterNUICallback('switchWorld', function(data, cb)
    if data.worldId then
        print(data.password)
        if not data.password then
            exports['erotic-lobby']:openLobby(false)
            exports['erotic-lobby']:switchWorld(data.worldId)
            cb({ success = true })
            return
        end

        local input = lib.inputDialog('Lobby Password', {'Password'})
        if not input then return cb({ error = 'Invalid Password' }) end
        if input[1] ~= data.password then return cb({ error = 'Invalid Password' }) end

        exports['erotic-lobby']:openLobby(false)
        exports['erotic-lobby']:switchWorld(data.worldId)
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)


AddEventHandler('echorp:playerSpawned', function()
    TriggerEvent("erotic-lobby:updateLobbies")
    TriggerServerEvent('erotic-lobby:SpawnWorldTrigger');
    exports['lane-inventory']:DoKitStuff("ars", "hopout")
end)

RegisterNetEvent('erotic-lobby:KillPlayer')
AddEventHandler('erotic-lobby:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("erotic-lobby:ChangeCoords")
AddEventHandler("erotic-lobby:ChangeCoords", function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false);
end)

RegisterNetEvent("erotic-lobby:ClosedLobby")
AddEventHandler("erotic-lobby:ClosedLobby", function(lobby)
    exports['erotic-lobby']:switchWorld(lobby)
end)

local cachedPlayerCount = {}
RegisterNetEvent('erotic-lobby:sendPlayerCount')
AddEventHandler('erotic-lobby:sendPlayerCount', function(playerCount, worldID)
    if not cachedPlayerCount[worldID] or (cachedPlayerCount[worldID] ~= playerCount) then
        SendNUIMessage({
            type = "updatePlayerCount",
            count = playerCount,
            worldId = worldID,
        })
        cachedPlayerCount[worldID] = playerCount
    end
end)

exports('ChangeWorld', function(worldId, name)
    TriggerServerEvent('erotic-lobby:ChangeWorld', worldId)
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds: '..name, 5000)
end)