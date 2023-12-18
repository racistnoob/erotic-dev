Recoil:RegisterMode('roleplay2', function(self)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local currentWeapon = GetSelectedPedWeapon(ped)
    
    local weaponRecoils = {
        -- Pistols
        [453432689] = { onFoot = 1.0, onBike = 1.0 },  -- pistol
        [-1075685676] = { onFoot = 0.5, onBike = 1.5 }, -- pistol_mk2
        [1593441988] = { onFoot = 0.2, onBike = 0.6 }, -- combatpistol
        [-998000829] = { onFoot = 1.0, onBike = 1.3 }, -- sp45
        [-2060501776] = { onFoot = 0.8, onBike = 1.8 }, -- m1911
        [-771403250] = { onFoot = 0.4, onBike = 1.8 }, -- heavypistol
        [1303514201] = { onFoot = 0.8, onBike = 1.8 }, -- glock18c
        [-1882382516] = { onFoot = 0.5, onBike = 1.8 }, -- glock17
        
        -- Assault Rifles
        [-1074790547] = { onFoot = 1.5, onBike = 1.5 },  -- assaultrifle
        [961495388] = { onFoot = 0.2, onBike = 0.6 },  -- assaultrifle_mk2
        [-2084633992] = { onFoot = 0.3, onBike = 1.0 },  -- carbinerifle
        [-86904375] = { onFoot = 1.3, onBike = 1.0 },  -- carbinerifle_mk2
        [-947031628] = { onFoot = 1.3, onBike = 1.0 },  -- heavyrifle
        [-774507221] = { onFoot = 1.3, onBike = 1.0 },  -- tacticalrifle
        -- SMGs
        [324215364] = { onFoot = 1.3, onBike = 1.2 },  -- microsmg

    }
    
        
        if IsPedShooting(ped) and not IsPedDoingDriveby(ped) then
            local _, wep = GetCurrentPedWeapon(ped)
            local recoilInfo = weaponRecoils[wep]
            
            if recoilInfo then
                local tv = 0
                
                if GetFollowPedCamViewMode() ~= 4 then
                    repeat
                        Wait(0)
                        local p = GetGameplayCamRelativePitch()
                        SetGameplayCamRelativePitch(p + 0.1, 0.2)
                        tv = tv + 0.1
                    until tv >= recoilInfo.onFoot
                else
                    repeat
                        Wait(0)
                        local p = GetGameplayCamRelativePitch()
                        
                        if recoilInfo.onFoot > 0.1 then
                            SetGameplayCamRelativePitch(p + 0.6, 1.2)
                            tv = tv + 0.6
                        else
                            SetGameplayCamRelativePitch(p + 0.016, 0.333)
                            tv = tv + 0.1
                        end
                    until tv >= recoilInfo.onFoot
                end
            end
        end
        
        if IsPedShooting(ped) and IsPedDoingDriveby(ped) then
            local tv = 0
            local _, wep = GetCurrentPedWeapon(ped)
            local recoilInfo = weaponRecoils[wep]
            
            if recoilInfo and recoilInfo.onBike > 0.1 then
                --ocal direction = math.random(0, 1) == 0 and -1 or 1 -- Randomly choose left or right
                repeat
                    Wait(0)
                    local p = GetGameplayCamRelativePitch()
                    --local yaw = GetGameplayCamRelativeHeading()
                    SetGameplayCamRelativePitch(p + 3.0, 0.2)
                    --SetGameplayCamRelativeHeading(yaw + direction * 0.01) -- Adjust this value for left-right movement intensity
                    tv = tv + 0.1
                until tv >= recoilInfo.onBike
            end
        end        
end)