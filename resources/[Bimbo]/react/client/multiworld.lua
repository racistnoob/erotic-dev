function switchWorld(worldId)
    exports['drpvp-scripts']:ChangeWorld(worldId)
end

RegisterNUICallback('switchWorld', function(data, cb)
    local worldId = tonumber(data.worldId)
    if worldId then
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(playerPed, true, true)
        TriggerServerEvent('Multiverse:ChangeWorld', tostring(worldId))
        collectgarbage("collect")

        -- these are always the same for all lobbies
        exports['lane-inventory']:DoKitStuff("hopout")
        exports['core']:setUndeaded(true)
        exports['core']:spawningcars(true)
        exports['core']:setHelmetsEnabled(false)

        if worldId >= 1 and worldId <= 4 then
            exports['core']:SetRecoilMode("roleplay")
            exports['core']:setFirstPersonVehicleEnabled(true)
            exports['core']:setnonstopcombat(false)
            exports['core']:setHsMulti(false)
        elseif worldId >= 5 and worldId <= 8 then
            exports['core']:SetRecoilMode("envy")
            exports['core']:setFirstPersonVehicleEnabled(true)
            exports['core']:setnonstopcombat(false)
            exports['core']:setHsMulti(true)
        elseif worldId >= 9 and worldId <= 12 then
            exports['core']:SetRecoilMode("roleplay")
            exports['core']:setFirstPersonVehicleEnabled(true)
            exports['core']:setnonstopcombat(false)
            exports['core']:setHsMulti(true)
        elseif worldId >= 13 and worldId <= 16 then
            exports['core']:SetRecoilMode("roleplay2")
            exports['core']:setFirstPersonVehicleEnabled(true)
            exports['core']:setnonstopcombat(false)
            exports['core']:setHsMulti(false)
        elseif worldId >= 17 and worldId <= 20 then
            exports['core']:SetRecoilMode("roleplay3")
            exports['core']:setFirstPersonVehicleEnabled(false)
            exports['core']:setnonstopcombat(false)
            exports['core']:setHsMulti(false)
        end
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)