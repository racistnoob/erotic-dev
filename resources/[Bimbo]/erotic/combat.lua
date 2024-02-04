local currentValues = { MaxAmmo = 0, ClipAmmo = 0 }
local no_xhair = (GetResourceKvpInt("erotic_xhair") == 1) or false

local toggleHud = true

local disable_control_action = DisableControlAction
local display_ammo_this_frame = DisplayAmmoThisFrame
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_ammo_in_ped_weapon = GetAmmoInPedWeapon
local get_ammo_in_clip = GetAmmoInClip
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode
local hide_hud_component_this_frame = HideHudComponentThisFrame
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local is_control_pressed = IsControlPressed
local is_using_keyboard = IsUsingKeyboard
local is_aim_cam_active = IsAimCamActive
local is_ped_armed = IsPedArmed
local is_player_free_aiming = IsPlayerFreeAiming
local player_ped_id = PlayerPedId
local player_id = PlayerId
local set_follow_ped_cam_view_mode = SetFollowPedCamViewMode
local send_nui_message = SendNUIMessage
local wait = Wait

COMBAT = {
    plyPed = player_ped_id(),
    pedWeapon = false,
    InVehicle = false,
    isAiming = false,
    isArmed = false,
    isAimingg = false,
    Sniper = false,
    nonstopCombat = false,

    PedCamera = function(self)
        while true do
            wait(250)
            if self.isArmed or self.isAiming and not self.InVehicle then
                local camMode = get_follow_ped_cam_view_mode()
                if not self.nonstopCombat and camMode == 1 or camMode == 2 or camMode == 4 then
                    set_follow_ped_cam_view_mode(0)
                elseif self.isAiming and camMode == 0 then
                    disable_control_action(1, 0, true)
                end
            else
                wait(500)
            end
        end
    end,
    
    InfoThread = function(self)
        while true do
            wait(1000)
            self.plyPed = player_ped_id()
            self.pedWeapon = get_selected_ped_weapon(self.plyPed) or false;

            self.InVehicle = is_ped_in_any_vehicle(self.plyPed, false)
            self.isAiming = (is_control_pressed(0, 25) and is_using_keyboard(0)) or is_aim_cam_active()
            self.isArmed = is_ped_armed(self.plyPed, 7)
            self.isAimingg = is_player_free_aiming(player_id())
            self.nonstopCombat = exports['core']:getNonstopCombat()
            self.Sniper = (self.pedWeapon == 177293209 or self.pedWeapon == 1785463520)
        end
    end,    

    --[[
    AmmoThread = function(self)
        while true do
            wait(250)
            if self.isArmed then
                local weaponMaxAmmo = self.pedWeapon and get_ammo_in_ped_weapon(self.plyPed, self.pedWeapon) or 0;
                local a, weaponClipAmmo = get_ammo_in_clip(self.plyPed, self.pedWeapon);
        
                currentValues["MaxAmmo"] = weaponMaxAmmo - weaponClipAmmo
                currentValues["ClipAmmo"] = weaponClipAmmo
        
                if toggleHud then
                    if self.isArmed and self.pedWeapon ~= 911657153 then
                        send_nui_message({ type = "ammo", data = currentValues })
                        send_nui_message({ type = "show", value = true })
                    else
                        send_nui_message({ type = "show", value = false })
                    end
                else
                    send_nui_message({ type = "show", value = false })
                    send_nui_message({ type = "scope", value = false })
                    wait(1000)
                end
            else
                wait(500)
            end
        end
    end,]]

    HideAmmo = function(self)
        while true do
            wait(1)
            hide_hud_component_this_frame(7)
            hide_hud_component_this_frame(9)
            --display_ammo_this_frame(false)
            hide_hud_component_this_frame(6)
            hide_hud_component_this_frame(8)
            if not self.Sniper then
                hide_hud_component_this_frame(14)
            end
        end
    end,
}

Citizen.CreateThread(function()
    COMBAT:HideAmmo()
    Citizen.Wait(250)
end)

--[[
Citizen.CreateThread(function()
    COMBAT:AmmoThread()
    Citizen.Wait(250)
end)]]

Citizen.CreateThread(function()
    COMBAT:InfoThread()
    Citizen.Wait(250)
end)

RegisterNetEvent('erotic:changeWatermark')
AddEventHandler('erotic:changeWatermark', function(lobbyName)
    send_nui_message({ type = "updateWatermark", value = lobbyName})
end)

AddEventHandler('erotic:playerSpawned', function()
    Wait(100)
    send_nui_message({ type = "xhair_colour", color = GetResourceKvpString('crosshairColor') })
    send_nui_message({ type = "showWatermark", value = true})
end)

exports("toggleHud", function(state)
    send_nui_message({ type = "xhair", cross = not state })
    send_nui_message({ type = "showWatermark", value = state})
    --toggleHud = state
end)

RegisterCommand('cross', function(src, args, rawCommand)
    local hexArg = string.sub(rawCommand, 7)
    if #hexArg > 0 then
        send_nui_message({ type = "xhair_colour", color = hexArg })
        exports['drp-notifications']:SendAlert('inform', 'Crosshair color updated')
        SetResourceKvp('crosshairColor', hexArg)
    else
        no_xhair = not no_xhair
        send_nui_message({ type = "xhair", cross = no_xhair })
        exports['drp-notifications']:SendAlert('inform', 'Crosshair '.. (no_xhair and "Disabled" or "Enabled"))
        SetResourceKvpInt("erotic_xhair", no_xhair)
    end
end)

RegisterCommand("top", function()
    local playerPed = PlayerPedId()
    local worldID = tonumber(exports['erotic-lobby']:getCurrentWorld())

    if worldID == 4 then
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