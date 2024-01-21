local function toggleNuiFrame(shouldShow)
	if shouldShow then
		SetNuiFocus(true, true)
		SetTimecycleModifier('hud_def_blur')
	else
		SetNuiFocus(false,false)
		TriggerEvent('reset-timecycle')
		TriggerScreenblurFadeOut(50)
	end
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage("setVisible", shouldShow)
end

RegisterNUICallback("hideFrame", function(data, cb)
		toggleNuiFrame(false)
		debugPrint("Hide NUI frame")
		cb({})
end)

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

function OpenLobby()
		toggleNuiFrame(true)
end
exports('openLobby', toggleNuiFrame)
local peds = {
		{
				coords = vector3(236.9479, -1390.3431, 29.548),
				heading = 140,
				labelText = "Press E for lobby",
				scenario = "WORLD_HUMAN_AA_SMOKE",
				interactionFunction = OpenLobby,
				pedModel = "csb_brucie2"
		}
}

function CreatePeds(pedsData)
		for _, pedData in pairs(pedsData) do
				local pedCoords = pedData.coords
				RequestModel(pedData.pedModel)
				while not HasModelLoaded(pedData.pedModel) do
						Wait(1)
				end
				local ped = CreatePed(4, pedData.pedModel, pedCoords, pedData.heading, false, false)
				SetEntityInvincible(ped, true)
				SetPedFleeAttributes(ped, 0, false)
				SetBlockingOfNonTemporaryEvents(ped, true)
				TaskStartScenarioInPlace(ped, pedData.scenario, 0, true)
				FreezeEntityPosition(ped, true)
				while true do
						local sleepTimer = 1500
						if exports.noob:inSafeZone() then
								if DoesEntityExist(ped) then
										local playerCoords = GetEntityCoords(PlayerPedId())
										local distance = #(playerCoords - pedCoords)
										if distance < 5 then
												sleepTimer = 1
												if distance < 2 then
														DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, pedData.labelText)
														if IsControlJustReleased(0, 38) then
																if pedData.interactionFunction ~= nil and type(pedData.interactionFunction) == "function" then
																		pedData.interactionFunction()
																end
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
		end
end
CreatePeds(peds)
