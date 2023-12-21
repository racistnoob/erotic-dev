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

function switchWorld(worldID)
    worldID = tonumber(worldID)
    if worldID then
        local worldSettings = nil
        for _, world in ipairs(worlds) do
            if worldID >= world.startID and worldID <= world.endID then
                worldSettings = world.settings
                break
            end
        end
    
        if worldSettings then
            exports['erotic-lobby']:ChangeWorld(tostring(worldID))
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
        end
    end
end
exports("switchWorld", switchWorld)