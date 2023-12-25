local currentWorldID = nil

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

local TrickSpawn = {
    x = 770.5748,
    y = -233.9927,
    z = 66.1145,
    h = 354.6606
}

local worlds = {
    -- { startID = 1, endID = 4, settings = { 
    --     recoilMode = "roleplay", 
    --     firstPersonVehicle = true, 
    --     nonstopCombat = false, 
    --     hsMulti = false,
    --     spawn = {     
    --     x = 0,
    --     y = 0,
    --     z = 0,
    --     h = 0
    -- }
    -- }},
    { startID = 1, endID = 2, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        hsMulti = false,
    }},
    { startID = 3, endID = 4, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        nonstopCombat = false,
        hsMulti = true 
    }},
    { startID = 5, endID = 6, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        hsMulti = true 
    }},
    { startID = 7, endID = 8, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        hsMulti = true 
    }},
    { startID = 9, endID = 10, settings = { 
        recoilMode = "roleplay2",
        firstPersonVehicle = true, 
        hsMulti = true,
        spawn = TrickSpawn,
        spawningcars = false,
        kit = 'trick',
        setUndeaded = false,
        setUndeaded2 = true
    }},
    { startID = 11, endID = 12, settings = { 
        recoilMode = "qb", 
        firstPersonVehicle = true, 
        hsMulti = true 
    }},
    { startID = 13, endID = 16, settings = { 
        recoilMode = "roleplay2", 
        firstPersonVehicle = false, 
        hsMulti = true
    }},
    { startID = 17, endID = 20, settings = { 
        recoilMode = "roleplay3", 
        firstPersonVehicle = false, 
        hsMulti = false
    }},
}

function switchWorld(worldID)
    worldID = tonumber(worldID)
    if worldID then
        local worldSettings, worldSpawn = nil, nil
        for _, world in ipairs(worlds) do
            if worldID >= world.startID and worldID <= world.endID then
                worldSettings = world.settings
                worldSpawn = worldSettings.spawn or defaultSpawn
                break
            end
        end

        currentWorldID = worldID

        if worldSettings then
            exports['erotic-lobby']:ChangeWorld(tostring(worldID))
            collectgarbage("collect")
            exports['lane-inventory']:DoKitStuff(worldSettings.kit or 'hopout')
            
            exports['core']:setUndeaded(worldSettings.setUndeaded or true)
            exports['core']:spawningcars(worldSettings.spawningcars or true)
            exports['core']:setHelmetsEnabled(worldSettings.Helmets or false)
            exports['core']:setCarRagdoll(worldSettings.CarRagdoll or true)

            -- Apply world-specific settings
            exports['core']:SetRecoilMode(worldSettings.recoilMode or "roleplay")
            exports['core']:setFirstPersonVehicleEnabled(worldSettings.firstPersonVehicle or false)
            exports['core']:setnonstopcombat(worldSettings.nonstopCombat or false)
            exports['core']:setHsMulti(worldSettings.hsMulti or false)

            TriggerEvent("erotic-lobby:ChangeCoords", worldSpawn.x, worldSpawn.y, worldSpawn.z)
            TriggerEvent("polyzone:enter")
        end
    end
end

exports("switchWorld", switchWorld)

exports("getCurrentWorldID", function()
    return currentWorldID
end)