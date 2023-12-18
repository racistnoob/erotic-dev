local safeZone = PolyZone:Create({
    vector2(185.66030883789, -1389.8002929688),
    vector2(219.25804138184, -1337.9571533203),
    vector2(281.5690612793, -1384.8869628906),
    vector2(243.30836486816, -1424.9483642578)
}, {
    name = "safezone",
})

--- #DL
--[[RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                break
            end
            Citizen.Wait(5)
        end
        exports['drp-notifications']:SendAlert('inform', 'Teleported To Waypoint.', 5000)
    else
        exports['drp-notifications']:SendAlert('inform', 'Select A Waypoint to Teleport.', 5000)
    end
end]]

local inSafezone = false

local function SetPlayerAlpha(playerPed, alphaValue)
    SetEntityAlpha(playerPed, alphaValue)
end

local function DisableInSafezone(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    if safeZone:isPointInside(GetEntityCoords(playerPed)) then
        print('^2[^1Entering Safezone^2]')
        for k, otherPlayer in ipairs(GetActivePlayers()) do
			SetCanAttackFriendly(GetPlayerPed(otherPlayer), false, false)
			NetworkSetFriendlyFireOption(false)
		end
        SetEntityInvincible(playerPed, true)
        
        if playerVehicle then
            SetEntityNoCollisionEntity(PlayerPedId(), playerVehicle, true)
        end
    end
end

local function EnableOutsideSafezone(playerPed)
    local playerCoords = GetEntityCoords(playerPed)

    if not safeZone:isPointInside(playerCoords) then
        print('^2[^1Exiting Safezone^2]')
        for k, otherPlayer in ipairs(GetActivePlayers()) do
			SetCanAttackFriendly(GetPlayerPed(otherPlayer), true, true)
			NetworkSetFriendlyFireOption(true)
		end
        SetEntityInvincible(playerPed, false)
        SetPlayerAlpha(playerPed, 255)
        
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)
        if playerVehicle then
            SetEntityNoCollisionEntity(playerPed, playerVehicle, false)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local player = PlayerId()
        local playerPed = GetPlayerPed(player)
        
        local newInSafezone = safeZone:isPointInside(GetEntityCoords(playerPed))
        
        if newInSafezone and not inSafezone then
            DisableInSafezone(playerPed)
            for _, otherPlayer in ipairs(GetActivePlayers()) do
                local otherPlayerPed = GetPlayerPed(otherPlayer)
                if player ~= otherPlayer then
                    SetEntityAlpha(otherPlayerPed, 100)
                end
            end
            inSafezone = true
        elseif not newInSafezone and inSafezone then
            EnableOutsideSafezone(playerPed)
            for _, otherPlayer in ipairs(GetActivePlayers()) do
                local otherPlayerPed = GetPlayerPed(otherPlayer)
                if player ~= otherPlayer then
                    SetEntityAlpha(otherPlayerPed, 255)
                end
            end
            inSafezone = false
        end
    end
end)
