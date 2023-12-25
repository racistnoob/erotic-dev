Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            if IsPedUsingActionMode(ped) then
                SetPedUsingActionMode(ped, -1, -1, 1)
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        SetPedCanLosePropsOnDamage(playerPed, false, 0)
        DisableControlAction(0, 199, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Wait 1 second (1000 milliseconds)
        -- The '263' is the ID for SET_PLAYER_IDLE_CAM_TIME
        N_0x9e4cfff989258472() -- Disable the vehicle idle camera
        SetPlayerIdleCamTime(PlayerId(), 99999) -- Reset the idle timer (99999 seconds)
        SetPlayerIdleDropKeepLoadedTime(PlayerId(), 99999) -- Reset the idle drop time
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
            if IsPedFalling(PlayerPedId()) then
                SetEntityInvincible(PlayerPedId(), true)
                SetPlayerInvincible(PlayerId(), true)
                SetPedCanRagdoll(PlayerPedId(), false)
                ClearPedBloodDamage(PlayerPedId())
                ResetPedVisibleDamage(PlayerPedId())
                ClearPedLastWeaponDamage(PlayerPedId())
                SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
                SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
                SetEntityCanBeDamaged(PlayerPedId(), false)
            else
                SetEntityInvincible(PlayerPedId(), false)
                SetPlayerInvincible(PlayerId(), false)
                SetPedCanRagdoll(PlayerPedId(), true)
                ClearPedLastWeaponDamage(PlayerPedId())
                SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
                SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
                SetEntityCanBeDamaged(PlayerPedId(), true)
            end 
	end
end)