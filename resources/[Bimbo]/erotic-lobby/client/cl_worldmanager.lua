RegisterNUICallback('switchWorld', function(data, cb)
    if data.worldId then
        exports['erotic-lobby']:openLobby(false)
        exports['erotic-lobby']:switchWorld(data.worldId)
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)

AddEventHandler('echorp:playerSpawned', function()
    exports['erotic-lobby']:openLobby(true)
    exports['erotic-lobby']:switchWorld(1)
end)

RegisterNetEvent('erotic-lobby:KillPlayer')
AddEventHandler('erotic-lobby:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("erotic-lobby:ChangeCoords")
AddEventHandler("erotic-lobby:ChangeCoords", function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false);
end)

local playerCounts = {}
function getLobbyPlayerCount(worldID)
    if playerCounts[worldID] ~= nil then
        return playerCounts[worldID]
    end
    return 0
end
exports("getLobbyPlayerCount", getLobbyPlayerCount)

RegisterNetEvent('erotic-lobby:sendPlayerCount')
AddEventHandler('erotic-lobby:sendPlayerCount', function(playerCount, worldID)
    playerCounts[tonumber(worldID)] = tonumber(playerCount)
    SendNUIMessage({
        type = "updatePlayerCount",
        count = playerCount,
        worldId = worldID,
    })
end)