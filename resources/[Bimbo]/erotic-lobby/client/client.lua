lobbyMenuOpen = false
local inZone = false

local lobbyData = {
    -- car fights
	{
		id = 1,
		name = 'Southside',
		settings = {'FPS Mode', 'Light Recoil'},
        maxPlayers = 20
	},
	
    -- ffa lobbies
	{
		id = 2,
		name = 'Pistol FFA',
		settings = {'FFA', 'Headshots', 'Light Recoil'},
        maxPlayers = 20
	},

    {
		id = 3,
		name = 'AR FFA',
		settings = {'FFA', 'Headshots', 'Light Recoil'},
        maxPlayers = 20
	},

	{
		id = 4,
		name = 'Deluxo',
		settings = {'Deluxo', 'Medium Recoil', 'Headshots'},
        maxPlayers = 20
	},

    -- rp preset 1
	{
		id = 5,
		name = 'RP 1 HS (#1)',
		settings = {'FPS Mode', 'Light Recoil', 'Headshots'},
        maxPlayers = 12
	},
	{
		id = 6,
		name = 'RP 1 HS (#2)',
		settings = {'FPS Mode', 'Light Recoil', 'Headshots'},
        maxPlayers = 12
	},

    -- envy hs
	{
		id = 7,
		name = 'Envy HS (#1)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 8
	},
	{
		id = 8,
		name = 'Envy HS (#2)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 8
	},

	{
		id = 9,
		name = 'Envy HS (#3)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 10
	},
	{
		id = 10,
		name = 'Envy HS (#4)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 10
	},
	{
		id = 11,
		name = 'Envy HS (#5)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 12
	},
	{
		id = 12,
		name = 'Envy HS (#6)',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
        maxPlayers = 12
	},

    -- rp preset 2
	{
		id = 13,
		name = 'RP 2 (#1)',
		settings = {'Third Person', 'Heavy Recoil', 'Headshots'},
        maxPlayers = 20
	},
	{
		id = 14,
		name = 'RP 2 (#2)',
		settings = {'Third Person', 'Heavy Recoil', 'Headshots'},
        maxPlayers = 20
	},

    -- arena recoil
	{
		id = 15,
		name = 'Rena (#1)',
		settings = {'Third Person', 'Light Recoil'},
        maxPlayers = 20
	},
	{
		id = 16,
		name = 'Rena (#2)',
		settings = {'Third Person', 'Light Recoil'},
        maxPlayers = 20
	},

    -- overtime
	{
		id = 17,
		name = 'Overtime (BETA #1)',
		settings = {'Third Person', 'Light Recoil'},
        maxPlayers = 20
	},
	{
		id = 18,
		name = 'Overtime (BETA #2)',
		settings = {'Third Person', 'Light Recoil'},
        maxPlayers = 20
	},
}

local is_control_just_released = IsControlJustReleased
local wait = Wait

local function toggleNuiFrame(shouldShow)
	if shouldShow then
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

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = lobbyData,
    })
    -- print('Updated lobbies:', json.encode(lobbyData))
end)


RegisterCommand("wds", function(source, args, rawCommand)
    TriggerEvent("erotic-lobby:updateLobbies")
end, false)

exports('openLobby', toggleNuiFrame)
