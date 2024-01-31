local whitelistedVehicles = {"revolter", "sheava", "issi7", "cyclone", "shotaro", "toros", "omnisegt", "paragon",
                             "sultanrs", "neon", "streiter", "raiden", "tulip", "buffalo", "buffalo1", "buffalo2",
                             "buffalo3", "seven70", "massacro", "guardian", "vigero2", "coquette4", "jester", "jester3",
                             "jester4", "penumbra2", "schlagen", "italigto", "comet2", "comet6", "pariah", "nero2",
                             "specter2", "tempesta", "elegy", "sultan2", "banshee2", "cliffhanger", "bati", "sanchez",
                             "manchez", "bf400", "powersurge"}

local spawnedCar
spawningcars = true

local function IsVehicleWhitelisted(model)
    for _, name in pairs(whitelistedVehicles) do
        if model == GetHashKey(name) then
            return true
        end
    end
    return false
end

local function deleteVeh(vehicle)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
    SetEntityAsMissionEntity(vehicle, false, false)
    DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
    end
end

local function deleteCurrentVehicle(playerPed)
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    if DoesEntityExist(currentVehicle) then
        if GetPedInVehicleSeat(currentVehicle, -1) == playerPed then
            deleteVeh(currentVehicle)
        else
            exports['drp-notifications']:SendAlert('error', 'You are not the driver.', 5000)
            return
        end
    end
end

local function deletePreviousVehicle(playerPed)
    if not DoesEntityExist(spawnedCar) then
        spawnedCar = false
        return
    end

    local shouldDelete = true
    for seatIndex = -1, 5 do
        local ped = GetPedInVehicleSeat(spawnedCar, seatIndex)
        if DoesEntityExist(ped) and ped ~= playerPed then
            shouldDelete = false
        end
    end

    if shouldDelete then
        deleteVeh(spawnedCar)
    end
end

RegisterNetEvent("drp:spawnvehicle")
AddEventHandler("drp:spawnvehicle", function(veh)
    local worldID = tonumber(exports['erotic-lobby']:getCurrentWorld())
    local trickLobby = worldID == 3
    if spawningcars or trickLobby and veh == "deluxo" then
        local playerPed = PlayerPedId()
        local vehiclehash = GetHashKey(veh)
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.5, 0.0, 0.0))

        if not IsVehicleWhitelisted(vehiclehash) and not trickLobby then
            exports['drp-notifications']:SendAlert('error', 'This vehicle cannot be spawned.', 5000)
            return
        end

        RequestModel(vehiclehash)

        Citizen.CreateThread(function()
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    exports['drp-notifications']:SendAlert('error', 'Failed to spawn the vehicle.', 5000)
                    return
                end
            end

            deleteCurrentVehicle(playerPed)

            deletePreviousVehicle(playerPed)

            local car = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(playerPed), 1, 0)
            if DoesEntityExist(car) then
                SetPedIntoVehicle(playerPed, car, -1)
                exports['drp-notifications']:SendAlert('inform', 'Vehicle spawned', 5000)
                TriggerEvent('keys:addNew', car, GetVehicleNumberPlateText(car))
                SetVehicleEngineOn(car, true, true, false)
                SetVehicleDirtLevel(car, 0.0)
                spawnedCar = car
                SetResourceKvp("last_vehicle", veh)

                Citizen.CreateThread(function()
                    local savedMods = GetResourceKvpString("vehicle_" .. tostring(vehiclehash) .. "_mods")
                    if savedMods then
                        local parsedMods = json.decode(savedMods)
                        if parsedMods then
                            exports["noob"]:SetVehicleProperties(car, parsedMods)
                        end
                    end
                end)
            else
                exports['drp-notifications']:SendAlert('error', 'Failed to spawn the vehicle.', 5000)
            end
        end)
    else
        exports['drp-notifications']:SendAlert('error', 'Spawning cars is disabled in this lobby.', 5000)
    end
end)

AddEventHandler("drp:saveVehicleModsBennys", function(veh)
    if not DoesEntityExist(veh) then return end
    local mods = exports['noob']:GetVehicleProperties(veh)
    SetResourceKvp("vehicle_" .. tostring(GetEntityModel(veh)) .. "_mods", json.encode(mods))
end)

RegisterCommand("previous_vehicle", function()
    TriggerEvent("drp:spawnvehicle", GetResourceKvpString('last_vehicle') or "revolter")
end)

RegisterKeyMapping("previous_vehicle", "Spawn your last spawned vehicle", "KEYBOARD", "F3")

RegisterCommand("dv", function()
    if exports["noob"]:inSafeZone() then
        deleteCurrentVehicle(PlayerPedId())
    end
end)
RegisterKeyMapping("dv", "Delete current vehicle", "KEYBOARD", "K")

exports("deletePreviousVehicle", deletePreviousVehicle)

exports("spawningcars", function(state)
    spawningcars = state
end)
