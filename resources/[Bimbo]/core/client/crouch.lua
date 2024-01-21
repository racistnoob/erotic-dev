local crouched = false
local ped = 0
local exists = DoesEntityExist(ped)
local isDead = IsEntityDead(ped)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        ped = PlayerPedId()
        exists = DoesEntityExist(ped)
        isDead = IsEntityDead(ped)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if exists and not isDead then 
            DisableControlAction(0, 36, true)
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

            if IsPlayerFreeAiming(PlayerId()) then
                ResetPedMovementClipset(ped, 0)
                crouched = false
            end
        end 
    end
end)