local worlds = {
    { startID = 1, endID = 4, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        nonstopCombat = false, 
        hsMulti = false 
    }},
    { startID = 5, endID = 8, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        nonstopCombat = false, 
        hsMulti = true 
    }},
    { startID = 9, endID = 12, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        nonstopCombat = false, 
        hsMulti = true 
    }},
    { startID = 13, endID = 16, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        nonstopCombat = false, 
        hsMulti = true 
    }},
    { startID = 17, endID = 20, settings = { 
        recoilMode = "roleplay3", 
        firstPersonVehicle = false, 
        nonstopCombat = false, 
        hsMulti = true 
    }},
}

function switchWorld(worldId)
    exports['drpvp-scripts']:ChangeWorld(worldId)
end

RegisterNUICallback('switchWorld', function(data, cb)
    local worldId = tonumber(data.worldId)
    if worldId then
        local worldSettings = nil

        -- Find the world settings for the given worldId
        for _, world in ipairs(worlds) do
            if worldId >= world.startID and worldId <= world.endID then
                worldSettings = world.settings
                break
            end
        end

        if worldSettings then
            NetworkSetFriendlyFireOption(true)
            SetCanAttackFriendly(playerPed, true, true)
            TriggerServerEvent('Multiverse:ChangeWorld', tostring(worldId))
            collectgarbage("collect")

            -- these are always the same for all lobbies
            exports['lane-inventory']:DoKitStuff("hopout")
            exports['core']:setUndeaded(true)
            exports['core']:spawningcars(true)
            exports['core']:setHelmetsEnabled(false)

            -- Apply world-specific settings
            exports['core']:SetRecoilMode(worldSettings.recoilMode)
            exports['core']:setFirstPersonVehicleEnabled(worldSettings.firstPersonVehicle)
            exports['core']:setnonstopcombat(worldSettings.nonstopCombat)
            exports['core']:setHsMulti(worldSettings.hsMulti)

            cb({ success = true })
        else
            cb({ error = 'Invalid world ID' })
        end
    else
        cb({ error = 'Invalid world ID' })
    end
end)
