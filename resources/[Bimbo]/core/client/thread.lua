Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    local lastped = nil

    SetPedCanLosePropsOnDamage(playerPed, false, 0)

    while true do
        Citizen.Wait(100)

        SetPoliceIgnorePlayer(playerPed, true)
        SetDispatchCopsForPlayer(playerPed, false)
        
        --[[for k, otherPlayer in ipairs(GetActivePlayers()) do
			-- Enable PVP.
			SetCanAttackFriendly(GetPlayerPed(otherPlayer), true, true)
			NetworkSetFriendlyFireOption(true)
		end]]

        local pos = GetEntityCoords(playerPed)
        RemoveVehiclesFromGeneratorsInArea(
            pos.x - 500.0,
            pos.y - 500.0,
            pos.z - 500.0,
            pos.x + 500.0,
            pos.y + 500.0,
            pos.z + 500.0
        )

        for i = 1, 12 do
            EnableDispatchService(i, false)
        end

        SetPlayerWantedLevel(playerId, 0, false)
        SetPlayerWantedLevelNow(playerId, false)
        SetPlayerWantedLevelNoDrop(playerId, 0, false)

        SetPedPopulationBudget(0)
        SetPedDensityMultiplierThisFrame(0)
        SetScenarioPedDensityMultiplierThisFrame(0, 0)
        SetVehicleDensityMultiplierThisFrame(0)
        SetRandomVehicleDensityMultiplierThisFrame(0)
        SetParkedVehicleDensityMultiplierThisFrame(0)

        SetPoliceIgnorePlayer(playerPed, true)
        SetDispatchCopsForPlayer(playerPed, false)

        if IsPedInCover(playerId, 1) and not IsPedAimingFromCover(playerPed, 1) then 
            DisableControlAction(2, 24, true)
            DisableControlAction(2, 142, true)
            DisableControlAction(2, 257, true)
        end

        if IsPedArmed(playerId, 4) then
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
        end

        local currentTime = GetGameTimer()
        if IsPedUsingActionMode(playerId) and currentTime - ActionMode > 1000 then
            ActionMode = currentTime
            SetPedUsingActionMode(playerId, false, -1, 0)
        end

        if playerPed ~= lastped then
            lastped = playerPed
            SetPedCanLosePropsOnDamage(playerPed, false, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ped = PlayerPedId()
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

        DisableControlAction(0, 37, true)
        DisableControlAction(0, 140, true)
        Wait(1)

    end
end)

-- Testing
-- print(GetHashKey("weapon_762"))
--print(`weapon_deagle`)