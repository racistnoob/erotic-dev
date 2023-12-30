local crouched = false
local ped = 0
local exists = DoesEntityExist(ped)
local isDead = IsEntityDead(ped)


CreateThread( function()
    Wait(1)
    
    DisableControlAction(0, 36, true)
end)

RegisterCommand('toggleCrouch', function()
    local ped = PlayerPedId()
    local isDead = IsEntityDead(ped)
    if not isDead then 
        
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
end)

RegisterKeyMapping('toggleCrouch', 'Toggle Crouch', 'keyboard', 'LCONTROL')   