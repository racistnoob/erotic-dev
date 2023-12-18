AddEventHandler('playerSpawned', function()
    local src = source;
    TriggerServerEvent('Multiverse:SpawnWorldTrigger');
end)

RegisterNetEvent('Multiverse:KillPlayer')
AddEventHandler('Multiverse:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0) -- Sets the player's health to 0, effectively killing them
end)

RegisterNetEvent("Multiverse:ChangeCoords")
AddEventHandler("Multiverse:ChangeCoords", function(x, y, z)
    SetEntityCoords(GetPlayerPed(-1), x, y, z, false, false, false, false);
end)

--[[RegisterCommand("world", function(source, args, rawCommand)
    local src = source;
    if #args == 0 then
        -- Invalid maybe idk
        return;
    end
    TriggerServerEvent('Multiverse:ChangeWorld', args[1]);
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
end)]]

exports('ChangeWorld', function(worldId)
    TriggerServerEvent('Multiverse:ChangeWorld', worldId)
    exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
end)