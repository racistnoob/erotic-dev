local HarnessVehicles = {}

RegisterNetEvent("harness", function(vehicle)
    HarnessVehicles[vehicle] = true
    TriggerClientEvent('newHarness', -1, HarnessVehicles)
end)

RegisterNetEvent('echorp:playerSpawned', function(data)
    TriggerClientEvent('newHarness', data.source, HarnessVehicles)
end)