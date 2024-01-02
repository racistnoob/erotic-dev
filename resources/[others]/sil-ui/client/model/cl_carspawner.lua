local CAR_LIST = {
    [1] = {
        ['model'] = 'Revolter',
        ['image'] = 'https://www.gtaboom.com/wp-content/uploads/2018/01/revolter3.jpg',
    },
    [2] = {
        ['model'] = 'Sheava',
        ['image'] = 'https://img.gta5-mods.com/q75/images/emperor-sheava-add-on-lods/d9c4d0-Sheava.9.png',
    },
    [3] = {
        ['model'] = 'Issi7',
        ['image'] = 'https://th.bing.com/th/id/OIP.meiRzJA_S-t9PQTCMyX1IgHaEK?rs=1&pid=ImgDetMain',
    },
    [4] = {
        ['model'] = 'Cyclone',
        ['image'] = 'https://th.bing.com/th/id/OIP.eTYHQOMIqy_8bfrBIXaFhQHaEK?rs=1&pid=ImgDetMain',
    },
    [5] = {
        ['model'] = 'Shotaro',
        ['image'] = 'https://vignette.wikia.nocookie.net/gtawiki/images/d/df/Shotaro-GTAO-front.png/revision/latest?cb=20161004182220',
    },
    [6] = {
        ['model'] = 'Toros',
        ['image'] = 'https://th.bing.com/th/id/R.86f1754dbf9f5d4b21d0302538724fbf?rik=bdWUn0Mfs8viNg&pid=ImgRaw&r=0',
    },
    [7] = {
        ['model'] = 'OmnisEGT',
        ['image'] = 'https://www.gtabase.com/images/user/vehicles/62e6735f473c8_omnisegt.jpg',
    },
    [8] = {
        ['model'] = 'Paragon',
        ['image'] = 'https://www.gtabase.com/images/jch-optimize/ng/images_gta-5_vehicles_sports_main_paragon-r.webp',
    },
    [9] = {
        ['model'] = 'SultanRS',
        ['image'] = 'https://www.gtabase.com/images/jch-optimize/ng/images_gta-5_vehicles_super_main_sultan-rs.webp',
    },
    [10] = {
        ['model'] = 'Neon',
        ['image'] = 'https://www.gtabase.com/images/user/vehicles/62e6735f473c8_omnisegt.jpg',
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