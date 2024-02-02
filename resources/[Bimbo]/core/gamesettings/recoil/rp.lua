local is_ped_shooting = IsPedShooting
local get_current_ped_weapon = GetCurrentPedWeapon
local get_entity_speed = GetEntitySpeed
local get_vehicle_ped_is_in = GetVehiclePedIsIn
local get_vehicle_class = GetVehicleClass
local get_weapon_type_group = GetWeapontypeGroup
local get_gameplay_cam_relative_heading = GetGameplayCamRelativeHeading
local set_gameplay_cam_relative_heading = SetGameplayCamRelativeHeading
local get_gameplay_cam_relative_pitch = GetGameplayCamRelativePitch
local set_gameplay_cam_relative_pitch = SetGameplayCamRelativePitch
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode
local math_ceil = math.ceil
local math_random = math.random
local get_entity_coords = GetEntityCoords
local get_gameplay_cam_coord = GetGameplayCamCoord

Recoil:RegisterMode("roleplay", function()
    local ped = PlayerPed
    if is_ped_shooting(ped) then
        local _, wep = get_current_ped_weapon(ped)
        local GamePlayCam = get_follow_ped_cam_view_mode()
        local MovementSpeed = math_ceil(get_entity_speed(ped))

        if MovementSpeed > 69 then
            MovementSpeed = 69
        end

        local group = get_weapon_type_group(wep)
        local p = get_gameplay_cam_relative_pitch()
        local cameraDistance = #(get_gameplay_cam_coord() - get_entity_coords(ped))
        local recoil = math_random(50, 75 + (math_ceil(MovementSpeed * 1.5))) / 100
        local rifle = false

        if group == 970310034 or group == 1159398588 then
            rifle = true
        end

        if cameraDistance < 5.3 then
            cameraDistance = 1.5
        else
            if cameraDistance < 8.0 then
                cameraDistance = 4.0
            else
                cameraDistance = 7.0
            end
        end

        if GamePlayCam == 4 then
            recoil = recoil * 0.35

            if rifle then
                recoil = recoil * 0.15
            else
                recoil = recoil * 0.05
            end
        end

        if rifle then
            recoil = recoil * 0.15
        end

        local rightleft = math_random(4)
        local h = get_gameplay_cam_relative_heading()
        local hf = math_random(10, 40 + MovementSpeed) / 100

        local direction = (rightleft == 1) and 1 or -1
        set_gameplay_cam_relative_heading(h + direction * hf)        

        local standardPitch = p + recoil
        local vehicleClass = get_vehicle_class(get_vehicle_ped_is_in(ped))

        if vehicleClass == 8 or vehicleClass == 13 then
            local bikePitch = p + math_random(2, 5)
            if math_random(1, 10) >= math_random(1, 5) then
                set_gameplay_cam_relative_pitch(bikePitch, 1.0)
            else
                set_gameplay_cam_relative_pitch(bikePitch, 1.0)
            end
        else
            if math_random(1, 10) >= math_random(1, 5) then
                set_gameplay_cam_relative_pitch(standardPitch, 1.0)
            else
                set_gameplay_cam_relative_pitch(standardPitch, 1.0)
            end
        end
    end
end)
