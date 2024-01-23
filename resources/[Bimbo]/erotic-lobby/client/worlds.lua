local currentWorldID = 1

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

-- local worlds = {
--     -- { startID = 0, endID = 0, settings = { 
--     --     recoilMode = "roleplay", 
--     --     firstPersonVehicle = true, 
--     --     hsMulti = false,
--     --     spawn = {     
--     --     x = 0,
--     --     y = 0,
--     --     z = 0,
--     --     h = 0
--     -- }
--     -- }},
--     { startID = 1, endID = 1, settings = { 
--         recoilMode = "roleplay", 
--         firstPersonVehicle = true, 
--         hsMulti = false,
--     }},
--     { startID = 2, endID = 2, settings = { 
--         recoilMode = "roleplay", 
--         firstPersonVehicle = true, 
--         hsMulti = true,
--         spawningcars = false,   
--         RandomSpawns = {
--             [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
--             [2] = {x = 843.3173, y = -3235.2666, z = -98.6991, h = 143.0110},
--             [3] ={x = 856.9405, y = -3212.1631, z = -98.4711, h = 143.0110},
--             [4] ={x = 872.1874, y = -3211.3135, z = -97.2462, h = 143.0110},
--             [5] ={x = 867.2796, y = -3186.1096, z = -96.2488, h = 143.0110},
--             [6] ={x = 900.2949, y = -3182.2495, z = -97.0675, h = 143.0110},
--             [7] ={x = 904.9290, y = -3199.6267, z = -97.1880, h = 143.0110},
--             [8] ={x = 909.7304, y = -3236.9119, z = -98.2942, h = 143.0110},
--             [9] ={x = 945.9636, y = -3210.4885, z = -98.2774, h = 143.0110},
--             [10] ={x = 918.3181, y = -3201.2510, z = -98.2621, h = 143.0110},
--             [11] ={x = 906.0173, y = -3230.5940, z = -98.2944, h = 143.0110},
--             [12] = {x = 884.8878, y = -3211.9189, z = -98.1962, h = 143.0110},
--         },                                                         
--     },},
--     { startID = 3, endID = 4, settings = { 
--         recoilMode = "roleplay", 
--         firstPersonVehicle = true, 
--         nonstopCombat = false,
--         hsMulti = true 
--     }},
--     { startID = 5, endID = 6, settings = { 
--         recoilMode = "envy", 
--         firstPersonVehicle = true, 
--         hsMulti = true 
--     }},
--     { startID = 7, endID = 8, settings = { 
--         recoilMode = "envy", 
--         firstPersonVehicle = true, 
--         hsMulti = true 
--     }},
--     { startID = 9, endID = 10, settings = { 
--         recoilMode = "roleplay2",
--         firstPersonVehicle = true, 
--         hsMulti = false,
--         spawningcars = false,
--         CarRagdoll = true,
--         kit = {'snipers', 'trick2'},
--         spawn = {
--             x = 770.5748, 
--             y = -233.9927, 
--             z = 66.1145, 
--             h = 354.6606
--         }
--     }},
--     { startID = 11, endID = 12, settings = { 
--         recoilMode = "qb", 
--         firstPersonVehicle = true, 
--         hsMulti = true 
--     }},
--     { startID = 13, endID = 16, settings = { 
--         recoilMode = "roleplay2", 
--         firstPersonVehicle = false, 
--         hsMulti = true
--     }},
--     { startID = 17, endID = 20, settings = { 
--         recoilMode = "roleplay3", 
--         firstPersonVehicle = false, 
--         hsMulti = false
--     }},
-- }

local Recoil = {
    ['Light Recoil'] = "roleplay3",
    ['Medium Recoil'] = "roleplay",
    ['Envy Recoil'] = "envy",
    ['High Recoil'] = "roleplay2",
}
-- 'Light Recoil', 'Envy Recoil', 'Medium Recoil', 'High Recoil'
local DeluxoMaps = {
    ["MirrorPark"] = {
        x = 770.5748, 
        y = -233.9927, 
        z = 66.1145, 
        h = 354.6606
    },
}

local FFAMaps = {
    ["Bunker"] = {
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
}

SettingEnabled = function(settingToCheck, settings)
    for _, setting in ipairs(settings) do
        if setting == settingToCheck then
            return true
        end
    end
    return false
end

GetSelectedRecoil = function(settings)
    if SettingEnabled('Light Recoil', settings) then
        return Recoil['Light Recoil']
    elseif SettingEnabled('Medium Recoil', settings) then
        return Recoil['Medium Recoil']
    elseif SettingEnabled('Envy Recoil', settings) then
        return Recoil['Envy Recoil']
    elseif SettingEnabled('High Recoil', settings) then
        return Recoil['High Recoil']
    end

    return "roleplay"
end

function switchWorld(worldID)
    worldID = tonumber(worldID)
    if not worldID then return end

    local Worlds = lib.callback.await('erotic-lobby:getLobbies', false)
    local World = Worlds[worldID]
    local WorldSettings = World.settings
    local WorldSpawn = SettingEnabled('Deluxo', WorldSettings) and DeluxoMaps[World.SelectedMap] or defaultSpawn

    if SettingEnabled('FFA', WorldSettings) then
        WorldSpawn = FFAMaps[World.SelectedMap][math.random(1,#FFAMaps[World.SelectedMap])]
    end

    currentWorldID = worldID

    if WorldSettings then

        if not WorldSpawn then 
            exports['core']:deathSpot(defaultSpawn.x, defaultSpawn.y, defaultSpawn.z, defaultSpawn.h)
        end

        exports['core']:deathSpot(WorldSpawn.x, WorldSpawn.y, WorldSpawn.z, WorldSpawn.h)

        if SettingEnabled('Deluxo', WorldSettings) then
            local DeluxoKits = {'snipers', 'trick2'}
            exports['lane-inventory']:DoKitStuff( DeluxoKits[1] or 'ars', DeluxoKits[2] or 'hopout' )
        else
            exports['lane-inventory']:DoKitStuff( 'ars', 'hopout' )
        end

        exports['core']:spawningcars(World.SpawningCars or World.SpawningCars == nil)
        exports['core']:setHelmetsEnabled( false )
        exports['core']:setCarRagdoll( SettingEnabled('Deluxo', WorldSettings) )
        exports['core']:SetRecoilMode( GetSelectedRecoil(WorldSettings) )
        exports['core']:setFirstPersonVehicleEnabled( SettingEnabled('Third Person', WorldSettings) )
        exports['core']:setHsMulti( SettingEnabled('Headshots', WorldSettings) )

        exports['erotic-lobby']:ChangeWorld(worldID, World.name)
    end
end

function getCurrentWorldDeathSpot()
    if currentWorldID then
        local Worlds = lib.callback.await('erotic-lobby:getLobbies', false)
        local WorldSettings = Worlds[currentWorldID].settings
        if SettingEnabled('FFA', WorldSettings) then
            return Maps[Worlds.SelectedMap][math.random(1,#Maps[Worlds.SelectedMap])]
        end
        return SettingEnabled('Deluxo', WorldSettings) and DeluxoMaps[Worlds.SelectedMap] or defaultSpawn 
    end
    return defaultSpawn
end

exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)

exports("switchWorld", switchWorld)

exports("getCurrentWorld", function()
    return currentWorldID
end)

-- RegisterNUICallback("getWorldsData", function(data, callback)
--     local worldsData = getWorldsData() -- Assuming you have the getWorldsData function defined
--     callback(worldsData)
-- end)