local firstPersonVehicleEnabled = false

function SetFirstPersonVehicleEnabled(state)
    firstPersonVehicleEnabled = state
end

local ped = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ped = PlayerPedId()
    end
end)

CreateThread(function()
    while true do
        Wait(10)

        if firstPersonVehicleEnabled then
            local isInVehicle = IsPedInAnyVehicle(ped, false)
            local viewMode = GetFollowVehicleCamViewMode()
            local isAiming = (IsControlPressed(0, 25) and IsUsingKeyboard(0)) or IsAimCamActive()

            if isInVehicle and isAiming and not WasAimingThirdPerson then
                if viewMode ~= 4 then
                    SetFollowVehicleCamViewMode(4)
                    DisableAimCamThisUpdate()
                    WasAimingThirdPerson = viewMode
                end
            elseif WasAimingThirdPerson and not isAiming then
                SetFollowVehicleCamViewMode(WasAimingThirdPerson)
                WasAimingThirdPerson = false
            end
        end
    end
end)

exports("setFirstPersonVehicleEnabled", SetFirstPersonVehicleEnabled)