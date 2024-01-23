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

RegisterNetEvent('erotic-lobby:updateLobbies')
AddEventHandler('erotic-lobby:updateLobbies', function()
    SendNUIMessage({
        type = "updateLobbies",
        lobbies = lobbyData,
    })
    -- print('Updated lobbies:', json.encode(lobbyData))
end)

RegisterCommand("wds", function()
    TriggerEvent("erotic-lobby:updateLobbies")
end, false)

<<<<<<< HEAD
  
local Settings = {
	{label = 'Headshots', checked = false, description = 'Enable Headshots'},
	{label = 'FPS Mode', checked = true, description = 'FPS Mode'},
	{label = 'Deluxo', checked = false, description = 'Deluxo Gamemode'},
	{label = 'Third Person', checked = false, description = 'Enable Third Person in Cars'},
	{label = 'Weapon Recoil', values = {'Light Recoil', 'Medium Recoil', 'High Recoil', 'Envy Recoil'}, description = 'Pick a recoil'},
	{label = 'Create The Lobby', description = 'Create a lobby'},
}
  
local SelectedRecoil = 1
function OpenCreateLobby()
	lib.registerMenu({
		id = 'CreateLobby_Menu',
		title = 'Menu title',
		position = 'top-right',
		options = Settings,
		onSideScroll = function(selected, scrollIndex, args)
			SelectedRecoil = scrollIndex
		end,
		onCheck = function(selected, checked, args)
			Settings[selected].checked = checked
		end,
	}, function(selected, scrollIndex, args)
		if selected == 6 then 
			local input = lib.inputDialog('Create Lobby', {'Lobby Name', 'Password'})

			if not input then return end
			local success, WorldID = lib.callback.await('erotic-lobby:createLobby', false, {LobbyName = input[1], LobbyPassword = input[2], DeluxoMode = Settings[3].checked, Headshots = Settings[1].checked, FPSMode = Settings[2].checked, Recoil = SelectedRecoil, FirstPerson = Settings[4].checked})
			if not success then return end
			exports['erotic-lobby']:switchWorld(WorldID)
		end
	end)

	if lib.getOpenMenu() then
		lib.hideMenu()
	end

	Wait(50)
	lib.showMenu('CreateLobby_Menu')
end
  
RegisterNUICallback('CreateLobby', function(data, cb)
	Wait(500)
	OpenCreateLobby()
	cb({}) 
end)

=======
>>>>>>> parent of bc911399 (Lobbys + ox lib)
exports('openLobby', toggleNuiFrame)
