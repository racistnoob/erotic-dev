local vehicle = nil

local get_vehicle_max_number_of_passengers = GetVehicleMaxNumberOfPassengers
local get_ped_in_vehicle_seat = GetPedInVehicleSeat
local function GetSeatPedIsIn(ped, veh)
    for i=-2,get_vehicle_max_number_of_passengers(veh) do
        if(get_ped_in_vehicle_seat(veh, i) == ped) then
            return i 
        end
    end
    return -2
end

local wait = Wait
local get_vehicle_ped_is_in = GetVehiclePedIsIn
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local is_ped_using_action_mode = IsPedUsingActionMode
local set_ped_using_action_mode = SetPedUsingActionMode
local is_control_pressed = IsControlPressed
local is_entity_dead = IsEntityDead
local set_vehicle_engine_on = SetVehicleEngineOn
local task_leave_vehicle = TaskLeaveVehicle
local get_seat_ped_is_in = GetSeatPedIsIn
local get_is_task_active = GetIsTaskActive
local set_ped_into_vehicle = SetPedIntoVehicle
local set_ped_config_flag = SetPedConfigFlag

Citizen.CreateThread(function()
    while true do
        wait(1000)
        local plyPed = COMBAT.plyPed
        if not is_ped_in_any_vehicle(plyPed, false) then
            if is_ped_using_action_mode(plyPed) then
                set_ped_using_action_mode(plyPed, -1, -1, 1)
            end
        else
            vehicle = get_vehicle_ped_is_in(plyPed, false)
            wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        wait()
        if vehicle then
            local plyPed = COMBAT.plyPed
            -- keep engine on
            if is_control_pressed(2, 75) and not is_entity_dead(plyPed) then
                wait(150)
                set_vehicle_engine_on(vehicle, true, true, false)
                task_leave_vehicle(plyPed, vehicle, 0)
            end
      
            -- anti shuffle
            local seat = get_seat_ped_is_in(plyPed, vehicle)
            set_ped_config_flag(plyPed, 184, true)
            if get_is_task_active(plyPed, 165) == 1 then
                set_ped_into_vehicle(plyPed, vehicle, seat) -- getting into car from passenger with no driver
            end
            wait(1000)
        else
            wait(2000)
        end
    end
end)

RegisterCommand("seat", function(source, args, rawCommand)
    local seatID = tonumber(args[1])
    if seatID ~= nil then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle then
            if IsVehicleSeatFree(vehicle, seatID) then
                SetPedIntoVehicle(playerPed, vehicle, seatID)
            end
        end
    end
end)
  