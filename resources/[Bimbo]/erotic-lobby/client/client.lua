lobbyMenuOpen = false

local lobbyData = {
	{
		id = 1,
		name = 'Southside #1',
		settings = {'FPS Mode', 'Light Recoil'},
	},
	  
	{
		id = 2,
		name = 'FFA Bunker',
		settings = {'FPS Mode', 'Light Recoil', 'FFA'},
	},
	{
		id = 3,
		name = 'Southside #3',
		settings = {'FPS Mode', 'Light Recoil', 'Headshots'},
	},
	{
		id = 4,
		name = 'Southside #4',
		settings = {'FPS Mode', 'Light Recoil', 'Headshots'},
	},
	{
		id = 5,
		name = 'Southside #5',
		settings = {'FPS Mode', 'Envy Recoil'},
	},
	{
		id = 6,
		name = 'Southside #6',
		settings = {'FPS Mode', 'Envy Recoil'},
	},
	{
		id = 7,
		name = 'Southside #7',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
	},
	{
		id = 8,
		name = 'Southside #8',
		settings = {'FPS Mode', 'Envy Recoil', 'Headshots'},
	},
	{
		id = 9,
		name = 'Southside #9',
		settings = {'FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'},
	},
	{
		id = 10,
		name = 'Southside #10',
		settings = {'FPS Mode', 'Medium Recoil', 'Deluxo', 'Headshots'},
	},
	{
		id = 11,
		name = 'Southside #11',
		settings = {'FPS Mode', 'Medium Recoil'},
	},
	{
		id = 12,
		name = 'Southside #12',
		settings = {'FPS Mode', 'Medium Recoil'},
	},
	{
		id = 13,
		name = 'Southside #13',
		settings = {'FPS Mode', 'Heavy Recoil'},
	},
	{
		id = 14,
		name = 'Southside #14',
		settings = {'FPS Mode', 'Heavy Recoil'},
	},
	{
		id = 15,
		name = 'Southside #15',
		settings = {'FPS Mode', 'Heavy Recoil'},
	},
	{
		id = 16,
		name = 'Southside #16',
		settings = {'FPS Mode', 'Heavy Recoil'},
	},
	{
		id = 17,
		name = 'Southside #17',
		settings = {'Third Person', 'Light Recoil'},
	},
	{
		id = 18,
		name = 'Southside #18',
		settings = {'Third Person', 'Light Recoil'},
	},
	{
		id = 19,
		name = 'Southside #19',
		settings = {'Third Person', 'Light Recoil'},
	},
	{
		id = 20,
		name = 'Southside #20',
		settings = {'Third Person', 'Light Recoil'},
	},
}

local function toggleNuiFrame(shouldShow)
	if shouldShow then
		TriggerEvent("erotic-lobby:updateLobbies")
		TriggerScreenblurFadeIn(50)
	else
		TriggerScreenblurFadeOut(50)
	end
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage("setVisible", shouldShow)
	lobbyMenuOpen = shouldShow
end

function isLobbyMenuOpen()
	return lobbyMenuOpen
end

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoord())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

local lobbyPed = {
	coords = vector3(236.9479, -1390.3431, 29.548),
	heading = 140,
	labelText = "Press E for lobby",
	scenario = "WORLD_HUMAN_AA_SMOKE",
	pedModel = "csb_brucie2"
}

Citizen.CreateThread(function()	
	RequestModel(lobbyPed.pedModel)
	while not HasModelLoaded(lobbyPed.pedModel) do
		Wait(1)
	end

	local pedCoords = lobbyPed.coords
	local ped = CreatePed(4, lobbyPed.pedModel, pedCoords, lobbyPed.heading, false, false)
	SetEntityInvincible(ped, true)
	SetPedFleeAttributes(ped, 0, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, lobbyPed.scenario, 0, true)
	FreezeEntityPosition(ped, true)

	local sleepTimer = 3000
	while true do
		if exports.noob:inSafeZone() then
			sleepTimer = 1500
			if DoesEntityExist(ped) then
				local playerCoords = GetEntityCoords(PlayerPedId())
				local distance = #(playerCoords - pedCoords)
				if distance < 5 and not lobbyMenuOpen then
					sleepTimer = 1
					if distance < 2 then
						DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, lobbyPed.labelText)
						if IsControlJustReleased(0, 38) then
							toggleNuiFrame(true)
						end
					end
				end
			else
				break
			end
		else
			sleepTimer = 3000
		end
		Wait(sleepTimer)
	end
end)

RegisterNUICallback("hideFrame", function(data, cb)
	toggleNuiFrame(false)
	cb({})
end)

exports('getLobbyData', function(lobby)
	local lobbyID = lobby
	if lobbyID then
		return lobbyData[lobbyID]
	else -- returns all data if lobbyid isnt specified
		return lobbyData
	end
end)

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = lobbyData,
    })
    -- print('Updated lobbies:', json.encode(lobbyData))
end)

--[[
RegisterCommand("wds", function(source, args, rawCommand)
    TriggerEvent("erotic-lobby:updateLobbies")
end, false)]]

exports('openLobby', toggleNuiFrame)
