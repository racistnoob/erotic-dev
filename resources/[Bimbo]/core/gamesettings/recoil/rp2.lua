local weaponRecoils = {
    -- Pistols
    [453432689] = { onFoot = 1.0, onBike = 1.0 },  -- pistol
    [-1075685676] = { onFoot = 0.5, onBike = 1.5 }, -- pistol_mk2
    [1593441988] = { onFoot = 0.2, onBike = 0.6 }, -- combatpistol
    [-998000829] = { onFoot = 1.0, onBike = 1.3 }, -- sp45
    [`WEAPON_USP45`] = { onFoot = 1.0, onBike = 1.3 }, -- usp
    [-2060501776] = { onFoot = 0.8, onBike = 1.8 }, -- m1911
    [-771403250] = { onFoot = 0.4, onBike = 1.8 }, -- heavypistol
    [`WEAPON_M45A1`] = { onFoot = 0.4, onBike = 1.8 }, -- heavypistol
    [1303514201] = { onFoot = 0.8, onBike = 1.8 }, -- glock18c
    [-1882382516] = { onFoot = 0.5, onBike = 1.8 }, -- glock17
    
    -- Assault Rifles
    [-1074790547] = { onFoot = 1.5, onBike = 1.5 },  -- assaultrifle
    [961495388] = { onFoot = 0.2, onBike = 0.6 },  -- assaultrifle_mk2
    [-2084633992] = { onFoot = 0.3, onBike = 1.0 },  -- carbinerifle
    [-86904375] = { onFoot = 1.3, onBike = 1.0 },  -- carbinerifle_mk2
    [`weapon_762`] = { onFoot = 1.3, onBike = 1.0 },  -- carbinerifle_mk2

    [-947031628] = { onFoot = 1.3, onBike = 1.0 },  -- heavyrifle
    [-774507221] = { onFoot = 1.3, onBike = 1.0 },  -- tacticalrifle
    -- SMGs
    [324215364] = { onFoot = 1.3, onBike = 1.2 },  -- microsmg
}

local is_ped_shooting = IsPedShooting
local is_ped_doing_driveby = IsPedDoingDriveby
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_gameplay_cam_relative_pitch = GetGameplayCamRelativePitch
local set_gameplay_cam_relative_pitch = SetGameplayCamRelativePitch
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode

Recoil:RegisterMode('roleplay2', function()
    local ped = PlayerPed
    local currentWeapon = get_selected_ped_weapon(ped)
    local recoilInfo = weaponRecoils[currentWeapon]
    
    if is_ped_shooting(ped) then
        if not is_ped_doing_driveby(ped) and recoilInfo and recoilInfo.onFoot > 0.1 then
            local tv = 0
            local followCamMode = get_follow_ped_cam_view_mode()
            repeat
                Wait(0)
                local pitch = get_gameplay_cam_relative_pitch()

                if followCamMode ~= 4 then
                    set_gameplay_cam_relative_pitch(pitch + 0.1, 0.2)
                    tv = tv + 0.1
                else
                    local pitchIncrement = (recoilInfo.onFoot > 0.1) and 0.6 or 0.016
                    set_gameplay_cam_relative_pitch(pitch + pitchIncrement, (pitchIncrement > 0.1) and 1.2 or 0.333)
                    tv = tv + pitchIncrement
                end
            until tv >= recoilInfo.onFoot
        elseif is_ped_doing_driveby(ped) and recoilInfo and recoilInfo.onBike > 0.1 then
            local tv = 0
            repeat
                Wait(0)
                local pitch = get_gameplay_cam_relative_pitch()
                set_gameplay_cam_relative_pitch(pitch + 3.0, 0.2)
                tv = tv + 0.1
            until tv >= recoilInfo.onBike
        end
    end
end)