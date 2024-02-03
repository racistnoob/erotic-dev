nonstopcombat = false
local LastJump = 0

local weaponDamages = {
    [`WEAPON_PISTOL`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_1911`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_SMG`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_762`] = { head = 1.8, pelvis = 1.6, damage = 1.0},
    [`WEAPON_TACTICALRIFLE`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_HEAVYRIFLE`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_ASSAULTRIFLE`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
    [`WEAPON_SP45`] = { head = 1.8, pelvis = 1.6, damage = 1.0},
    [`WEAPON_HEAVYPISTOL`] = { head = 1.8, pelvis = 1.6, damage = 1.0},
    [`WEAPON_GLOCK17`] = { head = 1.0, pelvis = 1.5, damage = 2.0 },
    [`WEAPON_GLOCK18C`] = { head = 2.1, pelvis = 7.2, damage = 1.5},
    [`WEAPON_MICROSMG`] = { head = 2.1, pelvis = 1.2, damage = 1.5},
}

local modifiedDamage = {}

function ResurrectPed()
	HealPed()
end

function Slay()
	SetEntityHealth(PlayerPedId(), 0)
end

local wait = Wait
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local get_follow_vehicle_cam_view_mode = GetFollowVehicleCamViewMode
local set_follow_vehicle_cam_view_mode = SetFollowVehicleCamViewMode
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode
local set_follow_ped_cam_view_mode = SetFollowPedCamViewMode
local clamp_gameplay_cam_pitch = ClampGameplayCamPitch
local set_player_forced_zoom = SetPlayerForcedZoom
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_ped_last_damage_bone = GetPedLastDamageBone
local set_weapon_damage_modifier = SetWeaponDamageModifier
local is_ped_jumping = IsPedJumping
local get_game_timer = GetGameTimer
local set_ped_move_rate_override = SetPedMoveRateOverride
local disable_control_action = DisableControlAction
local math_min = math.min
local function nonstop_weaponDamage()
    CreateThread(function()
        while nonstopcombat do
            wait(0)
            UpdateInfo()

            local ped = PlayerPed
            local isInVehicle = is_ped_in_any_vehicle(ped, false)
    
            if isInVehicle then
                local viewMode = get_follow_vehicle_cam_view_mode()
                if viewMode == 1 or viewMode == 2 then
                    set_follow_vehicle_cam_view_mode(4)
                end
            else
                local viewMode = get_follow_ped_cam_view_mode()
                if viewMode == 2 then
                    set_follow_ped_cam_view_mode(4)
                end
            end
    
            if not isInVehicle then
                clamp_gameplay_cam_pitch(-80.0, 80.0)
            end
    
            set_player_forced_zoom(playerID, not isInVehicle)
            
            local weapon = get_selected_ped_weapon(ped)
    
            --[[
            if weaponDamages[weapon] then
                local _, bone = get_ped_last_damage_bone(ped)
                local damageMultiplier = 1.0
    
                if bone == 31086 or 39317 then
                    damageMultiplier = weaponDamages[weapon].head
                else
                    damageMultiplier = weaponDamages[weapon].pelvis
                end
    
                local totalDamageMultiplier = damageMultiplier * weaponDamages[weapon].damage
    
                modifiedDamage[weapon] = totalDamageMultiplier
                set_weapon_damage_modifier(weapon, totalDamageMultiplier)
            end]]
    
            if is_ped_jumping(ped) then
                LastJump = get_game_timer()
            elseif get_game_timer() - LastJump < 3000 then
                set_ped_move_rate_override(ped, 0.5 + math_min((get_game_timer() - LastJump) / 3000 * 0.5, 0.5))
                disable_control_action(0, 22)
            end
        end
    end)
end

function setNonstopCombat(state)
    nonstopcombat = state
    exports["drp-hud"]:toggleNui(not state, true)
    if not state then
        if damageEventHandler ~= nil then
            RemoveEventHandler(damageEventHandler)
        end
        set_player_forced_zoom(playerID, false)
    else
        nonstop_weaponDamage()
        nonstop_Injuries()
        nonstop_Effects()
        nonstop_Affliction()
        nonstop_damageHandler()
        
        HealPed()
    end
    SendNUIMessage({
        visible = state
    })
    collectgarbage("collect")
end

exports("hideNonstop", function(state)
    SendNUIMessage({
        visible = state
    })      
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    Wait(1000)
    if resourceName == GetCurrentResourceName() then
        SendNUIMessage({
            visible = false
        })
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    Wait(1000)
    if resourceName == GetCurrentResourceName() then
        print"xd"
        setNonstopCombat(false)
    end
end)

exports("setNonstopCombat", setNonstopCombat)

exports("getNonstopCombat", function()
    return nonstopcombat
end)
