local currentValues = { MaxAmmo = 0, ClipAmmo = 0 }
local no_xhair = (GetResourceKvpInt("erotic_xhair") == 1) or false

local weapons = {
    snipers = {
        177293209,
        205991906,
        1785463520,
        3342088282
    }
}

local COMBAT = {
    PedCamera = function()
        while true do
            Citizen.Wait(250)
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

    SniperThread = function()
        while true do 
            Citizen.Wait(250)

            local pedWeapon = GetSelectedPedWeapon(PlayerPedId()) or false;

            if pedWeapon == 177293209 and IsPlayerFreeAiming(PlayerId()) or pedWeapon == 1785463520 and IsPlayerFreeAiming(PlayerId()) then 
                SendNUIMessage({ type = "scope", value = true })
                SendNUIMessage({ type = "ammo", data = currentValues })
                SendNUIMessage({ type = "show", value = false, cross = no_xhair })
            else
                SendNUIMessage({ type = "scope", value = false })
            end            
        end
    end,
    
    HideAmmo = function(self)
        while true do
          Wait(0)
            HideHudComponentThisFrame(14)
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)
            DisplayAmmoThisFrame(false)
        end
    end,
}

Citizen.CreateThread(function()
    COMBAT:HideAmmo()
    Citizen.Wait(250)
end)

Citizen.CreateThread(function()
    COMBAT:InfoThread()
    Citizen.Wait(250)
end)

Citizen.CreateThread(function()
    COMBAT:SniperThread()
    Citizen.Wait(250)
end)

RegisterCommand('cross', function(src, args)
    no_xhair = not no_xhair
    SetResourceKvpInt("erotic_xhair", no_xhair)
end)

RegisterCommand("top", function()
    local playerPed = PlayerPedId()
    local worldID = tonumber(exports['erotic-lobby']:getCurrentWorld())

    if worldID >= 9 and worldID <= 10 then
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            TaskLeaveVehicle(playerPed, vehicle, 0)

            SetVehicleForwardSpeed(vehicle, 0.0)

            while IsPedInAnyVehicle(playerPed, false) do
               Citizen.Wait(0)
            end

            local x, y, z = table.unpack(GetEntityCoords(vehicle))
            local min, max = GetModelDimensions(GetEntityModel(vehicle))
            local height = max.z - min.z

            SetPedCoordsKeepVehicle(playerPed, x, y, z + height)
        end
    end
end, false)

RegisterKeyMapping("top", "Teleport on top of car", "keyboard", "h")