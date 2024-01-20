local WeaponRecoil = {
    --m16
    [`weapon_tacticalrifle`] = {
        vertical = .31,
        horizontal = .15
    },
    --mk18
    [`weapon_mk18`] = {
        vertical = .15,
    },
    --doesnt matter shitter gun
    [`weapon_specialcarbine`] = {
        vertical = .11,
    },
    -- op as fuck
    [`weapon_heavyrifle`] = {
        vertical = .19,
    },
    [`weapon_scarh`] = {
        vertical = .19,
    },
    --berretta
    [`weapon_pistol`] = {
    vertical = .21,
    },
    [`weapon_M1911`] = {
        vertical = .21,
        },
    [`weapon_fnx45`] = {
        vertical = .21,
        },
    [`weapon_sp45`] = {
        vertical = .21,
    },
    [`weapon_glock17`] = {
        vertical = .21,
    },
    [`weapon_heavypistol`] = {
        vertical = .21,
    },
    [`WEAPON_GLOCK18C`] = {
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
    --ak
    [`weapon_assaultrifle`] = {
        vertical = .23,
    },
    --mpx
    [`weapon_combatpdw`] = {
        vertical = .11,
    },
    [`WEAPON_MPX`] = {
        vertical = .11,
    },
    --magpull
    [`weapon_assaultsmg`] = {
        vertical = .18,
    },
    --mp5
    [`weapon_smg_mk2`] = {
        vertical = .26,
    },
    [`weapon_microsmg`] = {
        vertical = .48,
    },
    --762
    [`weapon_carbinerifle_mk2`] = {
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
        vertical = .2,
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
    
        return 1
    
    end
    
    local isMoving = false
    
    local storedRecoils = {}
    
    Recoil:RegisterMode('envy', function()
            
            local plyPed = PlayerPedId() -- Defining the player's ped
    
            local isArmed = IsPedArmed(plyPed, 4) -- Checking if they are armed
            local _, weapon = GetCurrentPedWeapon(plyPed, true) -- Get's the ped's weapon
    
            local vehicle = GetVehiclePedIsIn(plyPed, false)
            local inVehicle = vehicle ~= 0

    
            if isArmed and not inVehicle then
    
                if storedRecoils[weapon] then
                    SetWeaponRecoilShakeAmplitude(weapon, storedRecoils[weapon])
                    storedRecoils[weapon] = nil
                end
    
            elseif isArmed and inVehicle then
    
                if not storedRecoils[weapon] then
                    storedRecoils[weapon] = GetWeaponRecoilShakeAmplitude(weapon)
                    SetWeaponRecoilShakeAmplitude(weapon, 4.5)
                end
    
            end
    
            if isArmed and IsPedShooting(plyPed) then -- Check if they are armed and dangerous (shooting)
    
                local movementSpeed = math.ceil( GetEntitySpeed(plyPed) ) -- Getting the speed of the ped
    
                local stressRecoil = GetStressRecoil() -- Grab recoil multiplier based on stress
                
                local camHeading = GetGameplayCamRelativeHeading()
                local headingFactor = math.random(10,40+movementSpeed)/100
    
                local weaponRecoil = WeaponRecoil[ weapon ] or GroupRecoil[ GetWeapontypeGroup(weapon) ] or { vertical = 0.1, horizontal = 0.1 }
    
                local rightLeft = math.random(1, 4) -- Chance to move left or right
    
                local horizontalRecoil = (headingFactor * stressRecoil) * ((weaponRecoil.horizontal or 0.1) * 10)
    
                if rightLeft == 1 then -- If chance is 1, move right
                    SetGameplayCamRelativeHeading(camHeading + horizontalRecoil)
                elseif rightLeft == 3 then -- If chance is 1, move left
                    SetGameplayCamRelativeHeading(camHeading - horizontalRecoil)
                end
    
                if not isMoving then -- Checks if the recoil is already being vertically adjusted
    
                    local farRange = math.ceil( 75 + (movementSpeed * 1.5) ) -- Faster the player is moving, the higher the random range for recoil
    
                    local recoil = math.random(50, farRange) / 100 -- Random math from 50-farRange and then divides by 100
    
                    local isFirstPerson = GetFollowPedCamViewMode() == 4
    
                    local currentRecoil = 0.0 -- Sets a default value for current recoil at 0
                    local finalRecoilTarget = (recoil * (weaponRecoil.vertical * 10)) * stressRecoil -- Working out the target for recoil
    
                    if isFirstPerson then
                        finalRecoilTarget = finalRecoilTarget / 9.5
                    end
    
                    isMoving = true -- Sets the moving var to true
    
                    local vehicleClass = inVehicle and GetVehicleClass(vehicle) or 0
                    local weirdRecoil = vehicleClass == 13 or vehicleClass == 8
    
                    repeat
    
                        Wait(0)
    
                        SetGameplayCamRelativePitch(GetGameplayCamRelativePitch()+(weirdRecoil and (math.random(28, 32) / 10) or 0.1), 0.2) -- Move the camera pitch up by 0.1
                        currentRecoil = currentRecoil + 0.1 -- Increment current recoil by 0.1 as we moved up by 0.1
    
                    until currentRecoil >= finalRecoilTarget -- Repeat until the currentRecoil variable reaches the desirred recoil target
    
                    isMoving = false -- Sets the moving var to false				
    
                end
    
            end
    
    end)