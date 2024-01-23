local currentWorldID = 1

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

local worlds = {
    { ID = 1, settings = {
        name = 'Southside #1',
        tags = {'FPS Mode', 'Light Recoil'},
        recoilMode = "roleplay",
        firstPersonVehicle = true, 
        hsMulti = false,
    }},
    { ID = 2, settings = {
        name = 'FFA Bunker',
		tags = {'FPS Mode', 'Light Recoil', 'FFA'},
        recoilMode = "roleplay",
        firstPersonVehicle = true, 
        hsMulti = false,
        spawningcars = false,   
        RandomSpawns = {
            [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
            -- Add other spawn points as needed
        },                                                         
    }},
    { ID = 6, settings = {
        name = 'Casino Deluxo',
		tags = {'FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'},
        recoilMode = "roleplay2",
        firstPersonVehicle = true, 
        hsMulti = false,
        spawningcars = false,
        CarRagdoll = true,
        spawn = {
            x = 770.5748, 
            y = -233.9927, 
            z = 66.1145, 
            h = 354.6606
        }
    }},
    { ID = 3, settings = {
        name = 'Southside #2',
        tags = {'FPS Mode', 'Light Recoil', 'Headshots'},
        recoilMode = "roleplay",
        firstPersonVehicle = true, 
        nonstopCombat = false,
        hsMulti = true 
    }},
    { ID = 4, settings = {
        name = 'Southside #3',
		tags = {'FPS Mode', 'Envy Recoil'},
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        hsMulti = false 
    }},
    { ID = 5, settings = {
        name = 'Southside #4',
		tags = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        recoilMode = "envy", 
        firstPersonVehicle = true, 
        hsMulti = true 
    }},
    { ID = 7, settings = {
        name = 'Southside #5',
		tags = {'Third Person', 'Light Recoil'},
        recoilMode = "roleplay3", 
        firstPersonVehicle = false, 
        hsMulti = false
    }},
}

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = worlds,
    })
end)

function switchWorld(worldID)
    worldID = tonumber(worldID)
    if worldID then
        local worldSettings, worldSpawn = nil, nil
        for _, world in pairs(worlds) do
            if world.ID == worldID then
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

            exports['erotic-lobby']:ChangeWorld(tostring(worldID))
        end
    end
end

function getCurrentWorldDeathSpot()
    if currentWorldID then
        for _, world in pairs(worlds) do
            if world.ID == currentWorldID then
                if world.settings.RandomSpawns then
                    return world.settings.RandomSpawns[math.random(1, #world.settings.RandomSpawns)]
                end
                return world.settings.spawn or defaultSpawn
            end
        end
    end
    return defaultSpawn
end

exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)

exports("switchWorld", switchWorld)

exports("getCurrentWorld", function()
    return currentWorldID
end)
