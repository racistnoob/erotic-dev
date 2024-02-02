local currentWorldID = 1

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
    { startID = 1, endID = 1, settings = { 
        recoilMode = "roleplay3", 
        firstPersonVehicle = false, 
        hsMulti = true,
        kits = {'pistols'},
        kit = {'pistols', 'sp'},
    }},
    
    { startID = 2, endID = 2, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        hsMulti = true,
        spawningcars = false,   
        RandomSpawns = {
            [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
            [2] = {x = 843.3173, y = -3235.2666, z = -98.6991, h = 143.0110},
            [3] ={x = 856.9405, y = -3212.1631, z = -98.4711, h = 143.0110},
            [4] ={x = 872.1874, y = -3211.3135, z = -97.2462, h = 143.0110},
            [5] ={x = 867.2796, y = -3186.1096, z = -96.2488, h = 143.0110},
            [6] ={x = 900.2949, y = -3182.2495, z = -97.0675, h = 143.0110},
            [7] ={x = 904.9290, y = -3199.6267, z = -97.1880, h = 143.0110},
            [8] ={x = 909.7304, y = -3236.9119, z = -98.2942, h = 143.0110},
            [9] ={x = 945.9636, y = -3210.4885, z = -98.2774, h = 143.0110},
            [10] ={x = 918.3181, y = -3201.2510, z = -98.2621, h = 143.0110},
            [11] ={x = 906.0173, y = -3230.5940, z = -98.2944, h = 143.0110},
            [12] = {x = 884.8878, y = -3211.9189, z = -98.1962, h = 143.0110},
        },         
        kit = {'pistols', 'sp'},
        kits = {'pistols'}                                                
    },},

    { startID = 3, endID = 3, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        hsMulti = true,
        spawningcars = false,   
        RandomSpawns = {
            [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
            [2] = {x = 843.3173, y = -3235.2666, z = -98.6991, h = 143.0110},
            [3] ={x = 856.9405, y = -3212.1631, z = -98.4711, h = 143.0110},
            [4] ={x = 872.1874, y = -3211.3135, z = -97.2462, h = 143.0110},
            [5] ={x = 867.2796, y = -3186.1096, z = -96.2488, h = 143.0110},
            [6] ={x = 900.2949, y = -3182.2495, z = -97.0675, h = 143.0110},
            [7] ={x = 904.9290, y = -3199.6267, z = -97.1880, h = 143.0110},
            [8] ={x = 909.7304, y = -3236.9119, z = -98.2942, h = 143.0110},
            [9] ={x = 945.9636, y = -3210.4885, z = -98.2774, h = 143.0110},
            [10] ={x = 918.3181, y = -3201.2510, z = -98.2621, h = 143.0110},
            [11] ={x = 906.0173, y = -3230.5940, z = -98.2944, h = 143.0110},
            [12] = {x = 884.8878, y = -3211.9189, z = -98.1962, h = 143.0110},
        },         
        kit = {'ars', '762'},
        kits = {'ars'}                                                
    },},

    { startID = 4, endID = 4, settings = { 
        recoilMode = "roleplay2",
        firstPersonVehicle = true, 
        hsMulti = false,
        spawningcars = false,
        CarRagdoll = true,
        kits = {'snipers'},
        kit = {'snipers', 'trick2'},
        spawn = {
            x = 770.5748, 
            y = -233.9927, 
            z = 66.1145, 
            h = 354.6606
        }
    }},

    { startID = 5, endID = 6, settings = { 
        recoilMode = "roleplay", 
        firstPersonVehicle = true, 
        hsMulti = true,
        kits = {'ars','pistols','smgs'} 
    }},

    { startID = 7, endID = 12, settings = { 
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        hsMulti = true ,
        kit = {'pistols', 'sp'},
        kits = {'ars','pistols','smgs'} 
    }},

    { startID = 13, endID = 14, settings = { 
        recoilMode = "roleplay2", 
        firstPersonVehicle = false, 
        hsMulti = true,
        kits = {'ars','pistols','smgs'} 
    }},

    { startID = 15, endID = 16, settings = { 
        recoilMode = "roleplay3", 
        firstPersonVehicle = false, 
        hsMulti = false,
        kits = {'ars','pistols','smgs'} 
    }},

    { startID = 17, endID = 18, settings = { 
        recoilMode = "nonstop",
        nonstopcombat = true,
        firstPersonVehicle = true, 
        hsMulti = true,
        kits = {'ars','pistols','smgs'} 
    }},
}

function switchWorld(worldID)
    local worldID = tonumber(worldID)
    if worldID then
        if getLobbyPlayerCount(worldID) >= getLobbyData(worldID).maxPlayers then
            return exports['drp-notifications']:SendAlert('error', 'Lobby is full!', 3000)
        end
        local worldSettings, worldSpawn = nil, nil
        for _, world in pairs(worlds) do
            if worldID >= world.startID and worldID <= world.endID then
                worldSettings = world.settings
                worldSpawn = worldSettings.spawn or defaultSpawn

                if worldSettings.RandomSpawns then
                    worldSpawn = worldSettings.RandomSpawns[math.random(1, #worldSettings.RandomSpawns)]
                end
                break
            end
        end

        currentWorldID = worldID

        if worldSettings then
            if worldSettings and worldSpawn then
                exports['core']:deathSpot(worldSpawn.x, worldSpawn.y, worldSpawn.z, worldSpawn.h)
            else
                exports['core']:deathSpot(defaultSpawn.x, defaultSpawn.y, defaultSpawn.z, defaultSpawn.h)
            end
            
            if type(worldSettings.kit) == "table" then
                exports['lane-inventory']:DoKitStuff(worldSettings.kit[1] or 'ars', worldSettings.kit[2] or 'hopout')
            else
                exports['lane-inventory']:DoKitStuff('ars', 'hopout')
            end
            
            exports['core']:spawningcars(false or worldSettings.spawningcars == nil)
            exports['core']:setHelmetsEnabled(worldSettings.Helmets or false)
            exports['core']:setCarRagdoll(worldSettings.CarRagdoll or false)
            exports['core']:SetRecoilMode(worldSettings.recoilMode or "roleplay")
            exports['core']:setFirstPersonVehicleEnabled(worldSettings.firstPersonVehicle or false)
            exports['core']:setHsMulti(worldSettings.hsMulti or false)
            exports['core']:setNonstopCombat(worldSettings.nonstopcombat or false)

            if LocalPlayer.state.radioChannel ~= 111 then -- global radio
                exports['radio']:changeradio(0)
            end

            worldID = tostring(worldID)

            exports['core']:deletePreviousVehicle(PlayerPedId())
            TriggerServerEvent('erotic-lobby:ChangeWorld', worldID)
            exports['drp-notifications']:SendAlert('inform', 'Changed Worlds', 5000)
            if worldID ~= "2" or worldID ~= "3" then
                exports['noob']:putInSafeZone(true)
            end
        end
    end
end


local function getLobbySettings(worldID)
    local worldID = tonumber(worldID) or tonumber(currentWorldID)
    if worldID then
        local worldSettings = nil
        for _, world in pairs(worlds) do
            if worldID >= world.startID and worldID <= world.endID then
                worldSettings = world.settings
                break
            end
        end
        return worldSettings
    end
end

function getCurrentWorldDeathSpot()
    if currentWorldID then
        for _, world in pairs(worlds) do
            if currentWorldID >= world.startID and currentWorldID <= world.endID then
                if world.settings.RandomSpawns then
                    return world.settings.RandomSpawns[math.random(1, #world.settings.RandomSpawns)]
                end
                return world.settings.spawn or defaultSpawn
            end
        end
    end
    return defaultSpawn
end

exports('getLobbySettings', getLobbySettings)

exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)

exports("switchWorld", switchWorld)

exports("getCurrentWorld", function()
    return currentWorldID
end)

-- RegisterNUICallback("getWorldsData", function(data, callback)
--     local worldsData = getWorldsData() -- Assuming you have the getWorldsData function defined
--     callback(worldsData)
-- end)