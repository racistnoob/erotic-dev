local noRecoil = {
    [`WEAPON_COMBATMG`] = true,
    [`WEAPON_ASSAULTRIFLE_MK2`] = true,
    [`WEAPON_COMBATMG_MK2`] = true,
    [`WEAPON_SPECIALCARBINE`] = true,
    [`WEAPON_BULLPUPRIFLE_MK2`] = true,
    [`WEAPON_MICROSMG2`] = true,
    [`WEAPON_COMPACTRIFLE`] = true,
    [`WEAPON_GEPARD`] = true,
    [`WEAPON_MARKSMANRIFLE_MK2`] = true,
    [`WEAPON_ADVANCEDRIFLE`] = true,
    [`WEAPON_DRAGUNOV`] = true,
    [`WEAPON_GLOCK18C`] = true,
    [`WEAPON_MK47FM`] = true,
    [`WEAPON_AK74`] = true,
    [`WEAPON_MPX`] = true
}


local is_ped_shooting = IsPedShooting
local get_selected_ped_weapon = GetSelectedPedWeapon
local get_gameplay_cam_relative_pitch = GetGameplayCamRelativePitch
local set_gameplay_cam_relative_pitch = SetGameplayCamRelativePitch
local get_gameplay_cam_relative_heading = GetGameplayCamRelativeHeading
local set_gameplay_cam_relative_heading = SetGameplayCamRelativeHeading
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode
local get_follow_vehicle_cam_view_mode = GetFollowVehicleCamViewMode
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local get_entity_speed = GetEntitySpeed
local get_weapon_type_group = GetWeapontypeGroup
local get_gameplay_cam_coord = GetGameplayCamCoord
local get_entity_coords = GetEntityCoords
local math_ceil = math.ceil
local math_random = math.random
local math_min = math.min

Recoil:RegisterMode('roleplay3', function()
    local ply = PlayerPed
    if is_ped_shooting(ply) then
        local weapon = get_selected_ped_weapon(ply)
        if not noRecoil[weapon] then
            local GamePlayCam = is_ped_in_any_vehicle(ply, false) and get_follow_vehicle_cam_view_mode() or get_follow_ped_cam_view_mode()
            local MovementSpeed = math_min(math_ceil(get_entity_speed(ply)), 69)
            local group = get_weapon_type_group(weapon)
            local p = get_gameplay_cam_relative_pitch()
            local cameraDistance = #(get_gameplay_cam_coord() - get_entity_coords(ply))
            local recoil = math_random(130, 140 + (math_ceil(MovementSpeed * 0.5))) / 100
            local rifle = group == 970310034 or group == 1159398588

            cameraDistance = (cameraDistance < 5.3 and 1.5) or (cameraDistance < 8.0 and 2.0) or 3.0

            if is_ped_in_any_vehicle(ply, false) then
                recoil = recoil + (recoil * cameraDistance)
            else
                recoil = recoil * 0.8
            end

            if GamePlayCam == 4 then
                recoil = (rifle and recoil * 0.1) or recoil * 0.5
            elseif rifle then
                recoil = recoil * 0.1
            end

            local rightleft = math_random(4)
            local h = get_gameplay_cam_relative_heading()
            local hf = math_random(10, 40 + MovementSpeed) / 100
            hf = is_ped_in_any_vehicle(ply, false) and hf * 2.0 or hf

            set_gameplay_cam_relative_heading(h + (rightleft == 1 and hf or -hf))
            set_gameplay_cam_relative_pitch(p + recoil, 0.8)
        end
    end
end)
