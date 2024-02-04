lobbyMenuOpen = false
local inZone = false
local is_control_just_released = IsControlJustReleased
local wait = Wait
local lobbyData = GetWorldsData()

Citizen.CreateThread(function()
    while true do
        Wait(2500)
        RemoveEmptyCustomLobbies()
    end
end)

local function toggleNuiFrame(shouldShow)
    if shouldShow then
        RemoveEmptyCustomLobbies()
        TriggerEvent("erotic-lobby:updateLobbies")
        TriggerScreenblurFadeIn(50)
    else
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

function RemoveEmptyCustomLobbies()
    local i = 1
    while i <= #worlds do
        local lobby = worlds[i]
        if lobby.custom and getLobbyPlayerCount(lobby.ID) == 0 then
            table.remove(worlds, i)
            print("Removed empty custom lobby:", json.encode(lobby))
        else
            i = i + 1
        end
    end
end

RegisterNUICallback('createCustomLobby', function(data, cb)
    local customLobbySettings = data

    print('Received custom lobby settings:')
    print(json.encode(customLobbySettings))

    TriggerEvent('customLobbyCreate', customLobbySettings)
    
    cb({ success = true })
end)

AddEventHandler('customLobbyCreate', function(customLobbySettings)
    toggleNuiFrame(false)
    print('Custom lobby created:')
    print(json.encode(customLobbySettings))
    AddCustomLobby(customLobbySettings)
    TriggerEvent("erotic-lobby:updateLobbies")
end)

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

local lobbyPed = {
	coords = vector3(236.9479, -1390.3431, 29.548),
	heading = 140.0,
	labelText = "Press E for lobby",
	scenario = "WORLD_HUMAN_TOURIST_MAP",
	pedModel = "IG_LilDee"
}

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

AddEventHandler("polyzone:exit", function(name)
    if name == "lobbyped" then
        exports['prompts']:hidePrompt()
        inZone = false
    end
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

RegisterNUICallback("hideFrame", function(data, cb)
	toggleNuiFrame(false)
	cb({})
end)

function getLobbyData(lobby)
    local lobbyID = lobby
	if lobbyID then
		return lobbyData[lobbyID]
	else -- returns all data if lobbyid isnt specified
		return lobbyData
	end
end
exports('getLobbyData', getLobbyData)

exports('openLobby', toggleNuiFrame)
