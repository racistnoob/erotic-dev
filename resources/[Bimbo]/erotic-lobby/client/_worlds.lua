local currentWorldID = 1

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

local FFABUNKER = {
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
}

local MirrorPark = {
    x = 770.5748, 
    y = -233.9927, 
    z = 66.1145, 
    h = 354.6606
}

worlds = {}

worlds = {
    { ID = 1, custom = false, playerCount = 0, settings = {
        name = 'Southside #1',
        tags = {'ThirdPerson Mode', 'Pistols'},
        recoilMode = 'roleplay',
        firstPersonVehicle = false, 
        hsMulti = false,
        maxPlayers = 30,
        kits = {'pistols'},
        kit = {'pistols', 'heavypistol'},
    }},
    { ID = 2, custom = false, playerCount = 0, settings = {
        name = 'Southside #2',
        tags = {'FPS Mode', 'ARs'},
        recoilMode = 'roleplay',
        firstPersonVehicle = false, 
        hsMulti = false,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'}
    }},
    { ID = 3, custom = false, playerCount = 0, settings = {
        name = 'Car Fights',
        tags = {'Pistols'},
        recoilMode = 'roleplay3',
        firstPersonVehicle = false, 
        hsMulti = true,
        maxPlayers = 30,
        kit = {'pistols', 'heavypistol'},
        kits = {'pistols'},
    }},
    { ID = 4, custom = false, playerCount = 0, settings = {
        name = 'Pistol FFA',
        tags = {'FFA', 'Pistols'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = false,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'pistols'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 5, custom = false, playerCount = 0, settings = {
        name = 'AR FFA',
        tags = {'FFA', 'ARs'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = true,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 6, custom = false, playerCount = 0, settings = {
        name = 'Envy',
        tags = {'FPS Mode', 'Headshots'},
        recoilMode = 'envy',
        firstPersonVehicle = true, 
        hsMulti = true,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'ars','pistols','smgs'},
    }},
    { ID = 7, custom = false, playerCount = 0, settings = {
        name = 'Deluxo',
        tags = {'Deluxo', 'Snipers'},
        recoilMode = 'roleplay2',
        firstPersonVehicle = true, 
        hsMulti = false,
        maxPlayers = 30,
        spawningcars = false,
        kits = {'snipers'},
        kit = {'snipers', 'trick2'},
        spawn = MirrorPark
    }},
    { ID = 8, custom = false, playerCount = 0, settings = {
        name = 'Overtime (BETA)',
        tags = {'Overtime Combat', 'Headshots', 'FPS Mode'},
        recoilMode = 'nonstop',
        nonstopcombat = true,
        firstPersonVehicle = true,
        hsMulti = true,
        kits = {'ars','pistols','smgs'},
        maxPlayers = 30,
    }}
}

function AddCustomLobby(customLobbySettings, playerName)
    local playerName = GetPlayerName(PlayerId())

    if playerName == nil then
        return
    end

    customLobbySettings.name = playerName .. "'s Lobby"

    local customLobby = {
        ID = #worlds + 1,
        custom = true,
        settings = customLobbySettings
    }
    table.insert(worlds, customLobby)
    print(json.encode(customLobby))
    switchWorld(customLobby.ID)
end

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = worlds,
    })
end)

function GetWorldsData()
    return worlds
end

function switchWorld(worldID, force)
    local worldID = tonumber(worldID)
    if worldID then
        local worldSettings, worldSpawn = nil, nil
        for _, world in pairs(worlds) do
            if world.ID == worldID then
                worldSettings = world.settings

                if not force and getLobbyPlayerCount(worldID) >= world.settings.maxPlayers then
                    return exports['drp-notifications']:SendAlert('error', 'Lobby is full!', 3000)
                end

                worldSpawn = worldSettings.spawn or defaultSpawn

                if worldSettings.RandomSpawns then
                    worldSpawn = worldSettings.RandomSpawns[math.random(1, #worldSettings.RandomSpawns)]
                end
                break
            end
        end

        currentWorldID = worldID

        if worldSettings then
            if worldSpawn then
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

RegisterNetEvent("erotic-lobby:forceworld")
AddEventHandler("erotic-lobby:forceworld", switchWorld)

local function getLobbySettings(worldID)
    local worldID = tonumber(worldID) or tonumber(currentWorldID)
    if worldID then
        local worldSettings = nil
        for _, world in pairs(worlds) do
            if world.ID == worldID then
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
            if world.ID == worldID then
                if world.settings.RandomSpawns then
                    return world.settings.RandomSpawns[math.random(1, #world.settings.RandomSpawns)]
                end
                return world.settings.spawn or defaultSpawn
            end
        end
    end
    return defaultSpawn
end

exports('AddCustomLobby', AddCustomLobby)

exports('getLobbySettings', getLobbySettings)

exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)

exports("switchWorld", switchWorld)

exports("getCurrentWorld", function()
    return currentWorldID
end)