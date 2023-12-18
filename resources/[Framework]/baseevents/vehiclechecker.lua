local function GetPedVehicleSeat(plyPed)
	local vehicle = GetVehiclePedIsIn(plyPed, false)
	for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
			if(GetPedInVehicleSeat(vehicle, i) == plyPed) then return i end
	end
	return -2
end

CreateThread(function()
	local isInVehicle, isEnteringVehicle, currentVehicle, currentSeat = false, false, 0, 0
	while true do
		if not isInVehicle and not isDead then
			local vehicle = GetVehiclePedIsTryingToEnter(plyPed)
			if DoesEntityExist(vehicle) and not isEnteringVehicle then	
				local seat = GetSeatPedIsTryingToEnter(plyPed)
				local netId = VehToNet(vehicle)
				isEnteringVehicle = true
				TriggerServerEvent('baseevents:enteringVehicle', vehicle, seat, GetVehicleClass(vehicle), netId)
			elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(plyPed)) and not IsPedInAnyVehicle(plyPed, true) and isEnteringVehicle then
				TriggerServerEvent('baseevents:enteringAborted')
				isEnteringVehicle = false
			elseif IsPedInAnyVehicle(plyPed, false) then
				-- suddenly appeared in a vehicle, possible teleport
				isEnteringVehicle = false
				isInVehicle = true
				currentVehicle = GetVehiclePedIsUsing(plyPed)
				currentSeat = GetPedVehicleSeat(plyPed)
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetVehicleClass(currentVehicle), netId)
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(plyPed, false) or isDead then
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetVehicleClass(currentVehicle), netId)
				isInVehicle = false
				currentVehicle = 0
				currentSeat = 0
			end
		end
		Wait(100)
	end
end)

RegisterNetEvent('baseevents:enteredVehicle', function(veh, seat, class, netId)
	if seat == -1 then
		SetNetworkIdCanMigrate(netId, true)
		SetEntityAsMissionEntity(veh, true, false)
		SetVehicleHasBeenOwnedByPlayer(veh, true)
	end
end)