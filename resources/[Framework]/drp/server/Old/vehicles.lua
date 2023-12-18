RegisterNetEvent('echorp:spawnvehicle')
AddEventHandler('echorp:spawnvehicle', function(coords, vehicle, keys, warp)
    local src = source
    local vehicleName = vehicle
    if type(coords) ~= 'vector4' then coords = vec4(coords, 90.0) end
    local vehicle = CreateVehicle(vehicleName, coords.x, coords.y, coords.z, coords.w or 90.0, true, false)
    local timeout = 20
    while not DoesEntityExist(vehicle) do
        Wait(100)
        timeout = timeout - 1
        if timeout <= 0 then
            return
        end
    end
    TriggerClientEvent('echorp:vehicleSpawned', src, NetworkGetNetworkIdFromEntity(vehicle), true, true)
end)