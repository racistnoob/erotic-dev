local currentValues = { MaxAmmo = 0, ClipAmmo = 0 }
local no_xhair = (GetResourceKvpInt("erotic_xhair") == 1) or false

local COMBAT = {
    PedCamera = function()
        while true do
            Citizen.Wait(10)
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
                SendNUIMessage({ type = "show", value = true, cross = no_xhair })
            else
                SendNUIMessage({ type = "show", value = false, cross = no_xhair })
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

Citizen.CreateThread(function() while true do N_0x4757f00bc6323cfe(-1553120962, 0.0) Wait(0) end end)

Citizen.CreateThread(function()
    COMBAT:HideAmmo()
    Citizen.Wait(250)
end)

Citizen.CreateThread(function()
    COMBAT:InfoThread()
    Citizen.Wait(250)
end)

-- information menu
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

-- infinite stamina
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ResetPlayerStamina(PlayerId())
	end
end)

-- crosshair toggle
RegisterCommand('cross', function(src, args)
    no_xhair = not no_xhair
    SetResourceKvpInt("erotic_xhair", no_xhair)
end)