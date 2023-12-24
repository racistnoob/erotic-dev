local firstPersonVehicleEnabled = false

function SetFirstPersonVehicleEnabled(state)
    firstPersonVehicleEnabled = state
end

CreateThread(function()
    while true do
        Wait(0)

        if firstPersonVehicleEnabled then
            local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
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