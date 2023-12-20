local ped = nil
local vehicle = nil

local function GetSeatPedIsIn(ped)
    for i=-2,GetVehicleMaxNumberOfPassengers(veh) do
        if(GetPedInVehicleSeat(veh, i) == ped) then
            return i 
        end
    end
    return -2
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		ped = PlayerPedId()
		vehicle = GetVehiclePedIsIn(ped, false)
	end
end)

Citizen.CreateThread(function()
    while true do
        if vehicle then
            -- keep engine on
            if IsControlPressed(2, 75) and not IsEntityDead(ped) then
                Wait(150)
                SetVehicleEngineOn(vehicle, true, true, false)
                TaskLeaveVehicle(ped, vehicle, 0)
            end
      
            -- anti shuffle
            local seat = GetSeatPedIsIn(ped)
            SetPedConfigFlag(ped, 184, true)
            if GetIsTaskActive(ped, 165) == 1 then
                SetPedIntoVehicle(ped, vehicle, seat) -- getting into car from passenger with no driver
            end
        end
        Wait(1000)
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
  