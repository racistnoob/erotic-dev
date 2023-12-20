local whitelistedVehicles = {
    "revolter",
    "sheava",
    "issi7",
    "cyclone",
    "shotaro",
    "toros",
    "omnisegt",
    "paragon",
    "sultanrs",
    "neon",
    "streiter",
    "raiden",
    "tulip",
    "buffalo",
    "buffalo1",
    "buffalo2",
    "buffalo3",
    "seven70",
    "massacro",
    "guardian",
    "vigero2",
    "coquette4",
    "jester",
    "jester3",
    "jester4",
    "penumbra2",
    "schlagen",
    "italigto",
    "comet2",
    "comet6",
    "pariah",
    "nero2",
    "specter2",
    "tempesta",
    "elegy",
    "sultan2",
    "banshee2",
    "cliffhanger",
    "bati",
    "sanchez",
    "manchez",
    "bf400",
    "powersurge"
}

local previousCar
local spawnedCar
local spawningcars = false

local function IsVehicleWhitelisted(model)
    for _, name in ipairs(whitelistedVehicles) do
        if model == GetHashKey(name) then
            return true
        end
    end
    return false
end

local function deletePreviousVehicle(playerPed)
    -- deletes old car to prevent spammed cars
    if not DoesEntityExist(spawnedCar) then
        spawnedCar = false
        return
    end
  
    -- checks if anyone is in the car
    local shouldDelete = true
    for seatIndex = -1, 5 do
        local ped = GetPedInVehicleSeat(spawnedCar, seatIndex)
        if DoesEntityExist(ped) and ped ~= playerPed then
            shouldDelete = false
        end
    end
  
    -- deletes car
    if shouldDelete then
        DeleteVehicle(spawnedCar)
    end
end

RegisterNetEvent("drp:spawnvehicle")
AddEventHandler("drp:spawnvehicle", function(veh)
    if spawningcars then
        local playerPed = PlayerPedId()
        local vehiclehash = GetHashKey(veh)
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.5, 0.0, 0.0))

        if not IsVehicleWhitelisted(vehiclehash) then
            exports['drp-notifications']:SendAlert('inform', 'This vehicle cannot be spawned.', 5000)
            return
        end

        RequestModel(vehiclehash)

        Citizen.CreateThread(function()
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
                    return
                end
            end

            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(currentVehicle) then
                if GetPedInVehicleSeat(currentVehicle, -1) == playerPed then
                    DeleteVehicle(currentVehicle)
                else
                    exports['drp-notifications']:SendAlert('inform', 'Exit your current vehicle.', 5000)
                    return
                end
            end

            deletePreviousVehicle()

            local car = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(playerPed), 1, 0)
            if DoesEntityExist(car) then
                SetPedIntoVehicle(playerPed, car, -1)
                exports['drp-notifications']:SendAlert('inform', 'Vehicle spawned', 5000)
                TriggerEvent('keys:addNew', car, GetVehicleNumberPlateText(car))
                SetVehicleEngineOn(car, true, true, false)
                spawnedCar = car
                previousCar = veh

                Citizen.CreateThread(function()
                    local savedMods = GetResourceKvpString("vehicle_" .. tostring(vehiclehash) .. "_mods")
                    if savedMods then
                        local parsedMods = json.decode(savedMods)
                        if parsedMods then
                            exports["core"]:SetVehicleProperties(car, parsedMods)
                        end
                    end
                end)
            else
                exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
            end
        end)
    end
end)

RegisterCommand("previous_vehicle", function()
    if previousCar then
        TriggerEvent("drp:spawnvehicle", previousCar)
    end
end)
RegisterKeyMapping("previous_vehicle", "Spawn your last spawned vehicle", "KEYBOARD", "F3")

exports("spawningcars", function(state)
    spawningcars = state
end)