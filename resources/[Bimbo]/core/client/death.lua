

AddEventHandler('baseevents:onPlayerDied', function()
    if not exports['drp_clothing']:inMenu() then
        DeathTimer()
        TriggerEvent("actionbar:setEmptyHanded")
    end
end)

function DeathTimer()
    CreateThread(function()
        Citizen.Wait(1000)
        local spawn = exports['erotic-lobby']:getCurrentWorldDeathSpot()
        UndeadedPlayer(spawn.x, spawn.y, spawn.z, spawn.h)
    end)
end


function UndeadedPlayer(x, y, z, h)
    TriggerEvent("actionbar:setEmptyHanded")
    NetworkResurrectLocalPlayer(vector3(x, y, z), h, true, false)
    TriggerEvent('baseevents:revived')
    TriggerServerEvent('baseevents:revived')
    if nonstopcombat then
        ResurrectPed()
        Wait(250)
        ResetPedMovementClipset(PlayerPedId(), 1.0)
        ClearEffects()
    end
end


RegisterCommand('kill', function(source, args, rawCommand)
    exports['drp-notifications']:SendAlert('error', 'About to die', 5000)
    local playerPed = PlayerPedId()
    SetPedToRagdoll(playerPed, 5000, 5000, 0, true, true, false)
    Citizen.Wait(1000)
    TriggerEvent('baseevents:onPlayerDied')
    SetEntityHealth(playerPed, 0)
    DetachEntity(playerPed)
end)

RegisterCommand('leave', function(source, args, rawCommand)
    exports['drp-notifications']:SendAlert('inform', 'Leaving lobby', 5000)
    Citizen.Wait(1500)
    exports['erotic-lobby']:switchWorld(1)
end)

exports("deathSpot", function(x, y, z, h)
    UndeadedPlayer(x, y, z, h)
end)