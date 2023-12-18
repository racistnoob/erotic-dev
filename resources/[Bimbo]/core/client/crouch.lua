local crouched = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)

        local ped = GetPlayerPed(-1)

        if DoesEntityExist(ped) and not IsEntityDead(ped) then 
            DisableControlAction(0, 36, true) -- INPUT_DUCK  

            if not IsPauseMenuActive() then 
                if IsDisabledControlJustPressed(0, 36) then 
                    RequestAnimSet("move_ped_crouched")

                    while not HasAnimSetLoaded("move_ped_crouched") do 
                        Citizen.Wait(100)
                    end 

                    if crouched then 
                        ResetPedMovementClipset(ped, 0)
                        crouched = false 
                    else
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                        crouched = true 
                    end 
                end
            end 

            -- Check if the player is aiming
            if IsPlayerFreeAiming(PlayerId()) then
                ResetPedMovementClipset(ped, 0) -- Reset to normal standing position
                crouched = false -- Update the crouched variable
            end
        end 
    end
end)