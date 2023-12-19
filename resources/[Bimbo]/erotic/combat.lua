local currentValues = { MaxAmmo = 0, ClipAmmo = 0 }

local COMBAT = {
    PedCamera = function()
        while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()
            local InVehicle = IsPedInAnyVehicle(ped, false)
            local isAiming = (IsControlPressed(0, 25) and IsUsingKeyboard(0)) or IsAimCamActive()
            local isFiring = IsPedShooting(ped)
            local isArmed = IsPedArmed(ped, 7)

            if isArmed or isAiming and not InVehicle then
                local camMode = GetFollowPedCamViewMode()
                if camMode == 1 or camMode == 2 or camMode == 4 then
                    SetFollowPedCamViewMode(0)
                elseif isAiming and camMode == 0 then
                    DisableControlAction(1, 0, true)
                end
            end
        end
    end,    

    InfoThread = function()
        while true do
            Citizen.Wait(250)
            local plyPed = PlayerPedId()
            local pedWeapon = GetSelectedPedWeapon(PlayerPedId()) or false;
            local weaponMaxAmmo = pedWeapon and GetAmmoInPedWeapon(plyPed, pedWeapon) or 0;
            local a, weaponClipAmmo = GetAmmoInClip(plyPed, pedWeapon);
    
            currentValues["MaxAmmo"] = weaponMaxAmmo - weaponClipAmmo
            currentValues["ClipAmmo"] = weaponClipAmmo
    
            if IsPedArmed(plyPed, 7) and pedWeapon ~= 911657153 then
                SendNUIMessage({ type = "ammo", data = currentValues })
                SendNUIMessage({ type = "show", value = true })
            else
                SendNUIMessage({ type = "show", value = false })
            end
        end
    end,    
    
    HideAmmo = function(self)
        while true do
          Wait(0)
            HideHudComponentThisFrame(14) 
            DisplayAmmoThisFrame(false)
        end
    end,
}

-- 
WasOnVehicle = false
RagdollSpeed = 30.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local isOnVehicle = IsPedOnVehicle(ped)

        if isOnVehicle then
            SetRagdollBlockingFlags(ped, 2)
        elseif WasOnVehicle and not isOnVehicle then
            ClearRagdollBlockingFlags(ped, 2)
            if GetEntitySpeed(ped) > RagdollSpeed then
                SetPedToRagdoll(ped)
            end
        end
        WasOnVehicle = isOnVehicle
    end
end)

Citizen.CreateThread(function() while true do N_0x4757f00bc6323cfe(-1553120962, 0.0) Wait(0) end end)

Citizen.CreateThread( function()
 while true do
    Citizen.Wait(0)
    RestorePlayerStamina(PlayerId(), 1.0)
	end
end)

Citizen.CreateThread(function()
    COMBAT:HideAmmo()
    Citizen.Wait(250)
end)

Citizen.CreateThread(function()
    COMBAT:InfoThread()
    Citizen.Wait(250)
end)

-- Lua script
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 288) then -- F1 key
            SendNUIMessage({ action = 'toggleInfo' })
        elseif IsControlJustReleased(0, 322) then -- ESC key
            SendNUIMessage({ action = 'toggleInfo' })
        end
    end
end)

local infoVisible = false

function toggleInformation()
    infoVisible = not infoVisible
    SendNUIMessage({ action = 'toggleInfo' })
end

exports("toggleInformation", toggleInformation)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        if IsControlJustReleased(0, 288) then  -- F1 key
            toggleInformation()
        end

        if infoVisible then
            if IsControlJustReleased(0, 322) then  -- ESC key
                toggleInformation()
            end
            DisableControlAction(0, 200, true)  -- Disable ESC key default action (Opening pause menu)
        end
    end
end)

WasOnVehicle = false
RagdollSpeed = 30.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local isOnVehicle = IsPedOnVehicle(ped)

        if isOnVehicle then
            SetRagdollBlockingFlags(ped, 2)
        elseif WasOnVehicle and not isOnVehicle then
            ClearRagdollBlockingFlags(ped, 2)
            if GetEntitySpeed(ped) > RagdollSpeed then
                SetPedToRagdoll(ped)
            end
        end
        WasOnVehicle = isOnVehicle
    end
end)

Citizen.CreateThread( function()
 while true do
    Citizen.Wait(0)
    RestorePlayerStamina(PlayerId(), 1.0)
	end
end)