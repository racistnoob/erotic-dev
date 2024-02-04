local WeaponRecoil = {
    
    [`weapon_tacticalrifle`] = {
        vertical = .31,
        horizontal = .15
    },
    [`weapon_MK18`] = {
        vertical = .15,
    },
    [`weapon_specialcarbine`] = {
        vertical = .11,
    },
    [`weapon_heavyrifle`] = {
        vertical = .19,
    },
    [`weapon_glock17`] = {
        vertical = .21,
    },
    [`weapon_fnx45`] = {
        vertical = .21,
    },
    [`WEAPON_GLOCK18`] = {
        vertical = .80,
        horizontal = .20
    }, 
    [`weapon_minismg`] = {
        vertical = .80,
    },
    [`WEAPON_TEC9`] = {
        vertical = .20,
    },
    [`weapon_combatmg`] = {
        vertical = .15,
    },
    [`weapon_m249`] = {
        vertical = .15,
    },
    [`weapon_m60`] = {
        vertical = .15,
    },
    [`weapon_assaultrifle`] = {
        vertical = .23,
    },
    [`weapon_combatpdw`] = {
        vertical = .11,
    },
    [`weapon_assaultsmg`] = {
        vertical = .18,
    },
    [`weapon_smg_mk2`] = {
        vertical = .26,
    },
    [`weapon_microsmg`] = {
        vertical = .48,
    },
    [`weapon_762`] = {
        vertical = .30,
        horizontal = .14
    },
    [`weapon_mp5`] = {
        vertical = .26,
        
    },
    
    
    
}

-- Group recoil: This is the recoil for the group overall if it is lacking an invidivual weapon recoil; 0.0 means no recoil at all

local GroupRecoil = {
    [416676503] = {
        vertical = .20,
    }, -- Handgun
    [-957766203] = {
        vertical = .17,
    }, -- Submachine
    [860033945] = {
        vertical = .22,
    }, -- Shotgun
    [970310034] = {
        vertical = .17,
    }, -- Assault Rifle
    [1159398588] = {
        vertical = .18,
    }, -- LMG
    [3082541095] = {
        vertical = .15,
    }, -- Sniper
    [2725924767] = {
        vertical = .3,
    } -- Heavy
}

local function GetStressRecoil()
    
    return 0.95
    
end

local isMoving = false

local storedRecoils = {}

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
local is_ped_armed = IsPedArmed
local set_weapon_recoil_shake_amplitude = SetWeaponRecoilShakeAmplitude
local get_weapon_recoil_shake_amplitude = GetWeaponRecoilShakeAmplitude
local is_ped_shooting = IsPedShooting
Recoil:RegisterMode('envy', function()
    
    local plyPed = PlayerPed -- Defining the player's ped
    
    local isArmed = is_ped_armed(plyPed, 4) -- Checking if they are armed
    local _, weapon = get_current_ped_weapon(plyPed, true) -- Get's the ped's weapon
    
    local vehicle = get_vehicle_ped_is_in(plyPed, false)
    local inVehicle = vehicle ~= 0
    
    
    if isArmed and not inVehicle then
        
        if storedRecoils[weapon] then
            set_weapon_recoil_shake_amplitude(weapon, storedRecoils[weapon])
            storedRecoils[weapon] = nil
        end
        
    elseif isArmed and inVehicle then
        
        if not storedRecoils[weapon] then
            storedRecoils[weapon] = get_weapon_recoil_shake_amplitude(weapon)
            set_weapon_recoil_shake_amplitude(weapon, 4.5)
        end
        
    end
    
    if isArmed and is_ped_shooting(plyPed) then -- Check if they are armed and dangerous (shooting)
        
        local movementSpeed = math_ceil( get_entity_speed(plyPed) ) -- Getting the speed of the ped
        
        local stressRecoil = GetStressRecoil() -- Grab recoil multiplier based on stress
        
        local camHeading = get_gameplay_cam_relative_heading()
        local headingFactor = math_random(10,40+movementSpeed)/100
        
        local weaponRecoil = WeaponRecoil[ weapon ] or GroupRecoil[ get_weapon_type_group(weapon) ] or { vertical = 0.1, horizontal = 0.1 }
        
        local rightLeft = math_random(1, 4) -- Chance to move left or right
        
        local horizontalRecoil = (headingFactor * stressRecoil) * ((weaponRecoil.horizontal or 0.1) * 10)
        
        if rightLeft == 1 then -- If chance is 1, move right
            set_gameplay_cam_relative_heading(camHeading + horizontalRecoil)
        elseif rightLeft == 3 then -- If chance is 1, move left
            set_gameplay_cam_relative_heading(camHeading - horizontalRecoil)
        end
        
        if not isMoving then -- Checks if the recoil is already being vertically adjusted
            
            local farRange = math_ceil( 75 + (movementSpeed * 1.5) ) -- Faster the player is moving, the higher the random range for recoil
            
            local recoil = math_random(50, farRange) / 100 -- Random math from 50-farRange and then divides by 100
            
            local isFirstPerson = get_follow_ped_cam_view_mode() == 4
            
            local currentRecoil = 0.0 -- Sets a default value for current recoil at 0
            local finalRecoilTarget = (recoil * (weaponRecoil.vertical * 10)) * stressRecoil -- Working out the target for recoil
            
            if isFirstPerson then
                finalRecoilTarget = finalRecoilTarget / 9.5
            end
            
            isMoving = true -- Sets the moving var to true
            
            local vehicleClass = inVehicle and get_vehicle_class(vehicle) or 0
            local weirdRecoil = vehicleClass == 13 or vehicleClass == 8
            
            repeat
                
                Wait(0)
                
                set_gameplay_cam_relative_pitch(get_gameplay_cam_relative_pitch()+(weirdRecoil and (math_random(28, 32) / 10) or 0.1), 0.2) -- Move the camera pitch up by 0.1
                currentRecoil = currentRecoil + 0.1 -- Increment current recoil by 0.1 as we moved up by 0.1
                
            until currentRecoil >= finalRecoilTarget -- Repeat until the currentRecoil variable reaches the desirred recoil target
            
            isMoving = false -- Sets the moving var to false				
            
        end
        
    end
    
end)

Recoil:OnModeChange(function()
    for weaponHash, recoil in pairs(storedRecoils) do
        set_weapon_recoil_shake_amplitude(GetHashKey(weaponHash), recoil)
    end
end)

AddEventHandler("onResourceStop", function()
    for weaponHash, recoil in pairs(storedRecoils) do
        set_weapon_recoil_shake_amplitude(GetHashKey(weaponHash), recoil)
    end
end)