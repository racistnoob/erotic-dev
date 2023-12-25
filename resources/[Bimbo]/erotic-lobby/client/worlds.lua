local currentWorldID = nil

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

local worlds = {
    -- { startID = 0, endID = 0, settings = { 
    --     recoilMode = "roleplay", 
    --     firstPersonVehicle = true, 
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
        hsMulti = false,
        spawningcars = false,
        kit = 'trick2',
        spawn = {
            x = 770.5748, 
            y = -233.9927, 
            z = 66.1145, 
            h = 354.6606
        }
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
            if worldSettings and worldSettings.spawn then
                exports['core']:deathSpot(worldSettings.spawn.x, worldSettings.spawn.y, worldSettings.spawn.z, worldSettings.spawn.h)
            else
                exports['core']:deathSpot(defaultSpawn.x, defaultSpawn.y, defaultSpawn.z, defaultSpawn.h)
            end
            exports['lane-inventory']:DoKitStuff(worldSettings.kit or 'hopout')
            exports['core']:spawningcars(worldSettings.spawningcars or worldSettings.spawningcars == nil)
            exports['core']:setHelmetsEnabled(worldSettings.Helmets or false)
            exports['core']:setCarRagdoll(worldSettings.CarRagdoll or true)
            exports['core']:SetRecoilMode(worldSettings.recoilMode or "roleplay")
            exports['core']:setFirstPersonVehicleEnabled(worldSettings.firstPersonVehicle or false)
            exports['core']:setHsMulti(worldSettings.hsMulti or false)


            exports['erotic-lobby']:ChangeWorld(tostring(worldID))
        end
    end
end

function getCurrentWorldDeathSpot()
    if currentWorldID then
        for _, world in ipairs(worlds) do
            if currentWorldID >= world.startID and currentWorldID <= world.endID then
                return world.settings.deathSpot or defaultDeathSpot
            end
        end
    end
    return defaultDeathSpot
end

exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)

exports("switchWorld", switchWorld)

exports("getCurrentWorldID", function()
    return currentWorldID
end)