Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    local playerId = PlayerId()

    SetPedCanLosePropsOnDamage(playerPed, false, 0)

    while true do
        Citizen.Wait(100)

        for i = 1, 12 do
            EnableDispatchService(i, false)
        end

        SetPlayerWantedLevel(playerId, 0, false)
        SetPlayerWantedLevelNow(playerId, false)
        SetPlayerWantedLevelNoDrop(playerId, 0, false)

        if IsPedInCover(playerId, 1) and not IsPedAimingFromCover(playerPed, 1) then 
            DisableControlAction(2, 24, true)
            DisableControlAction(2, 142, true)
            DisableControlAction(2, 257, true)
        end

        BlockWeaponWheelThisFrame()
    end
end)

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
        Citizen.Wait(0)
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