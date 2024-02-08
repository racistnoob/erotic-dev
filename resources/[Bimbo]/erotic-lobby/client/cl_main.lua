local currentWorldID = 1
local worlds = {}
local playerCounts = {}
local inZone = false
local is_control_just_released = IsControlJustReleased
local wait = Wait
local defaultSpawn = {
    x = 233.5797,
    y = -1393.9111,
    z = 30.5152,
    h = 143.0110
}
local lobbyPed = {
	coords = vector3(236.9479, -1390.3431, 29.548),
	heading = 140.0,
	labelText = "Press E for lobby",
	scenario = "WORLD_HUMAN_TOURIST_MAP",
	pedModel = "IG_LilDee"
}

lobbyMenuOpen = false

--## LOCAL FUNCTIONS ##--

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

local backgroundActive = false
local function background()
    Citizen.CreateThread(function()
        while backgroundActive do
            Citizen.Wait()
            DrawSprite("", "", 0.5, 0.5, 1.0, 1.0, 0, 144, 138, 255, 100)
        end
    end)
end

local function toggleNuiFrame(shouldShow)
    if shouldShow then
        RemoveEmptyCustomLobbies()
        TriggerServerEvent("RequestWorldsData")
        backgroundActive = true
        background()
        TriggerScreenblurFadeIn(50)
    else
        backgroundActive = false
        TriggerScreenblurFadeOut(50)
        if inZone then
            exports['prompts']:showPrompt({
                pressText = "Press E",
                text = "to open lobby menu"
            })
            interaction()
        end
    end
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage("setVisible", shouldShow)
    lobbyMenuOpen = shouldShow
    
	SendNUIMessage({
		type = 'closePasswordPrompt' and 'closeCustomLobbyPrompt'
	})
end

--## FUNCTIONS ##--

function RemoveEmptyCustomLobbies()
    for _, lobby in ipairs(worlds) do
        if lobby.custom and getLobbyPlayerCount(lobby.ID) == 0 then
            TriggerServerEvent('RemoveEmptyCustomLobby', lobby.ID)
        end
    end
end

function getLobbyPlayerCount(worldID)
    if playerCounts[worldID] ~= nil then
        return playerCounts[worldID]
    end
    return 0
end

function AddCustomLobby(customLobbySettings)
    TriggerServerEvent('AddCustomLobby', customLobbySettings)
end

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
        end
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

function isLobbyMenuOpen()
	return lobbyMenuOpen
end

function interaction()
    Citizen.CreateThread(function()
        while inZone do
            if not lobbyMenuOpen then
                if is_control_just_released(0, 38) then
                    exports['prompts']:hidePrompt()
                    toggleNuiFrame(true)
                end
            end
            wait()
        end
    end)
end

--## Threads ##--

CreateThread(function()
    exports["noob"]:AddBoxZone(
        "lobbyped",
        lobbyPed.coords,
        2.0, 
        2.0, 
        {
            heading = lobbyPed.heading,
            scale={1.0, 1.0, 1.0},
            minZ = 29,
            maxZ = 32,
        }
    )
end)

Citizen.CreateThread(function()	
	RequestModel(lobbyPed.pedModel)
	while not HasModelLoaded(lobbyPed.pedModel) do
		wait(1)
	end

	local pedCoords = lobbyPed.coords
	local ped = CreatePed(4, lobbyPed.pedModel, pedCoords, lobbyPed.heading, 0, 0)
	SetEntityInvincible(ped, true)
	SetPedFleeAttributes(ped, 0, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, lobbyPed.scenario, -1)
	FreezeEntityPosition(ped, true)
end)

--## RegisterNUICallback ##--

RegisterNUICallback('createCustomLobby', function(data, cb)
    local customLobbySettings = data

    -- print('Received custom lobby settings:')
    -- print(json.encode(customLobbySettings))

    TriggerEvent('customLobbyCreate', customLobbySettings)
    
    cb({ success = true })
end)

RegisterNUICallback("hideFrame", function(data, cb)
	toggleNuiFrame(false)
	cb({})
end)

RegisterNUICallback('switchWorld', function(data, cb)
    if data.worldId then
        exports['erotic-lobby']:openLobby(false)
        exports['erotic-lobby']:switchWorld(data.worldId)
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)

--## AddEventHandler ##--

AddEventHandler('customLobbyCreate', function(customLobbySettings)
    toggleNuiFrame(false)
    -- print('Custom lobby created:')
    -- print(json.encode(customLobbySettings))
    AddCustomLobby(customLobbySettings)
    TriggerEvent("erotic-lobby:updateLobbies")
end)

AddEventHandler("polyzone:enter", function(name)
    if name == "lobbyped" then
        exports['prompts']:hidePrompt()
        Wait(100)

        exports['prompts']:showPrompt({
            pressText = "Press E",
            text = "to open lobby menu"
        })            
        inZone = true
        interaction()
    end
end)

AddEventHandler('erotic:playerSpawned', function()
    exports['erotic-lobby']:openLobby(true)
    Wait(250)
    TriggerEvent("erotic-lobby:forceworld", 1)
end)

AddEventHandler("polyzone:exit", function(name)
    if name == "lobbyped" then
        exports['prompts']:hidePrompt()
        inZone = false
    end
end)

--## RegisterNetEvent ##--

RegisterNetEvent("erotic-lobby:forceworld")
AddEventHandler("erotic-lobby:forceworld", switchWorld)

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = worlds,
    })
end)

RegisterNetEvent('SwitchWorldData')
AddEventHandler('SwitchWorldData', function(worldID)
    switchWorld(worldID)
end)

RegisterNetEvent('erotic-lobby:KillPlayer')
AddEventHandler('erotic-lobby:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("erotic-lobby:ChangeCoords")
AddEventHandler("erotic-lobby:ChangeCoords", function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false);
end)
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

RegisterNetEvent('erotic-lobby:sendPlayerCount')
AddEventHandler('erotic-lobby:sendPlayerCount', function(playerCount, worldID)
    playerCounts[tonumber(worldID)] = tonumber(playerCount)
    SendNUIMessage({
        type = "updatePlayerCount",
        count = playerCount,
        worldId = worldID,
    })
end)

exports("getLobbyPlayerCount", getLobbyPlayerCount)
exports('openLobby', toggleNuiFrame)
exports('AddCustomLobby', AddCustomLobby)
exports('getLobbySettings', getLobbySettings)
exports("getCurrentWorldDeathSpot", getCurrentWorldDeathSpot)
exports("switchWorld", switchWorld)
exports("getCurrentWorld", function()
    return currentWorldID
end)