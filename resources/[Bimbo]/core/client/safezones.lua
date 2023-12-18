local safeZone = PolyZone:Create({
    vector2(185.66030883789, -1389.8002929688),
    vector2(219.25804138184, -1337.9571533203),
    vector2(281.5690612793, -1384.8869628906),
    vector2(243.30836486816, -1424.9483642578)
}, {
    name = "safezone",
})

local inSafezone = false

local function SetPlayerAlpha(playerPed, alphaValue)
    SetEntityAlpha(playerPed, alphaValue)
end

local function DisableInSafezone(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    if safeZone:isPointInside(GetEntityCoords(playerPed)) then
        print('^2[^1Entering Safezone^2]')
        for _, otherPlayer in ipairs(GetActivePlayers()) do
            local otherPlayerPed = GetPlayerPed(otherPlayer)
            SetCanAttackFriendly(otherPlayerPed, false, false)
            SetEntityInvincible(otherPlayerPed, true)
            SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
            NetworkSetFriendlyFireOption(false)
        end
        if playerVehicle and GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
            SetEntityNoCollisionEntity(playerPed, playerVehicle, true)
        end
    end
end

local function EnableOutsideSafezone(playerPed)
    if not safeZone:isPointInside(GetEntityCoords(playerPed)) then
        print('^2[^1Exiting Safezone^2]')
        for _, otherPlayer in ipairs(GetActivePlayers()) do
            local otherPlayerPed = GetPlayerPed(otherPlayer)
            SetCanAttackFriendly(otherPlayerPed, true, true)
            SetEntityInvincible(otherPlayerPed, false)
            SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
            NetworkSetFriendlyFireOption(true)
        end
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
        local playerPed = PlayerPedId()
        
        local newInSafezone = safeZone:isPointInside(GetEntityCoords(playerPed))
        
        if newInSafezone and not inSafezone then
            DisableInSafezone(playerPed)
            inSafezone = true
        elseif not newInSafezone and inSafezone then
            EnableOutsideSafezone(playerPed)
            inSafezone = false
        end
    end
end)
