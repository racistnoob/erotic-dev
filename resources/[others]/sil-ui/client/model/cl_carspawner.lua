local CAR_LIST = {
    [1] = {
        ['model'] = 'Revolter',
        ['image'] = 'https://i.imgur.com/0RI3Snh.png',
    },
    [2] = {
        ['model'] = 'Neon'
    },
    [3] = {
        ['model'] = 'Neon'
    },
    [4] = {
        ['model'] = 'Neon'
    },
}

RegisterNetEvent('carspawner:openMenu')
AddEventHandler('carspawner:openMenu', function()
    SetNuiFocus(true, true)
      SendReactMessage('vehiclespawner', {
        cars = CAR_LIST
    })

end)

RegisterNUICallback('carspawner:closeNUI', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('carspawner:spawnVehicle', function(DATA)
    SetNuiFocus(false, false)
    
    if IsPedInAnyVehicle(PlayerPedId()) then return end

    Citizen.CreateThread(function()
        local HASH = GetHashKey(DATA.MODEL)

        if not IsModelAVehicle(HASH) then return end
        if not IsModelInCdimage(HASH) or not IsModelValid(HASH) then return end
        
        RequestModel(HASH)

        while not HasModelLoaded(HASH) do
            Citizen.Wait(0)
        end

        local COORDS = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local HEADING = GetEntityHeading(PlayerPedId())
        local CREATED_VEHICLE = CreateVehicle(HASH, COORDS, HEADING, true, false)

        SetVehicleModKit(CREATED_VEHICLE, 0)
        SetVehicleMod(CREATED_VEHICLE, 11, 3, false)
        SetVehicleMod(CREATED_VEHICLE, 12, 2, false)
        SetVehicleMod(CREATED_VEHICLE, 13, 2, false)
        SetVehicleMod(CREATED_VEHICLE, 15, 3, false)
        SetVehicleMod(CREATED_VEHICLE, 16, 4, false)
        SetModelAsNoLongerNeeded(HASH)
        TaskWarpPedIntoVehicle(PlayerPedId(), CREATED_VEHICLE, -1)
        
        SetVehicleDirtLevel(CREATED_VEHICLE, 0)
        SetVehicleWindowTint(CREATED_VEHICLE, 0)

        SetResourceKvp('last_vehicle',DATA.MODEL)
    end)
end)

RegisterCommand('+car_menu', function()
    TriggerEvent('carspawner:openMenu')
end)

RegisterKeyMapping('+car_menu', '[Car Spawner] Open Menu', 'keyboard', 'm')

RegisterCommand("previous_vehicle", function()
    local previousVehicle = GetResourceKvpString('last_vehicle')
    if previousVehicle then
        TriggerEvent("drp:spawnvehicle", previousVehicle)
    end
end)