local currentWorldID = 1

local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}

local worlds = {}

RegisterNetEvent('ReceiveWorldsData')
AddEventHandler('ReceiveWorldsData', function(receivedWorlds)
    worlds = receivedWorlds
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = worlds,
    })
end)

RegisterNetEvent('updateLobbies')
AddEventHandler('updateLobbies', function(updatedWorlds)
    worlds = updatedWorlds
end)

function AddCustomLobby(customLobbySettings)
    TriggerServerEvent('AddCustomLobby', customLobbySettings)
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

RegisterNetEvent('SwitchWorldData')
AddEventHandler('SwitchWorldData', function(worldID, force)
    switchWorld(worldID, force)
    print(worldID)
end)

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