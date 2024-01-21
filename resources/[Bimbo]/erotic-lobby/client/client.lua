lobbyMenuOpen = false
local function toggleNuiFrame(shouldShow)
	if shouldShow then
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

exports('openLobby', toggleNuiFrame)
