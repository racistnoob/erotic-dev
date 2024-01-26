local crouched = false

RegisterCommand("crouch", function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        return
    end

    RequestAnimSet("move_ped_crouched")

    while not HasAnimSetLoaded("move_ped_crouched") do
        Wait(100)
    end

    if crouched == true then
        ResetPedMovementClipset(ped, 0.25)
        crouched = false
    elseif crouched == false then
        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
        crouched = true
    end
end)


RegisterKeyMapping("crouch", "Crouch", "KEYBOARD", "LCONTROL")