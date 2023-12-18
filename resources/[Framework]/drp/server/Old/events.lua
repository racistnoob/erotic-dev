RegisterNetEvent('deletevehicle:server')
AddEventHandler('deletevehicle:server', function(vehicleNet)
	if vehicleNet then
		local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
		if DoesEntityExist(vehicle) then
			DeleteEntity(vehicle)
		end 
	end
end)