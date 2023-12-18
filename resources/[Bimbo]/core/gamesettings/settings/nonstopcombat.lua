local nonstopcombat = false
local LastJump = 0
local isRolling = false

local weaponDamages = {
    [GetHashKey("WEAPON_PISTOL")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_1911")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_SMG")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_TACTICALRIFLE")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_HEAVYRIFLE")] = { head = 10.5, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_SP45")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_HEAVYPISTOL")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_GLOCK18C")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
    [GetHashKey("WEAPON_MICROSMG")] = { head = 10.2, pelvis = 1.2, damage = 0.6 },
}

function Setnonstopcombat(state)
    nonstopcombat = state
end

exports("setnonstopcombat", Setnonstopcombat)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if nonstopcombat then
            local ped = PlayerPedId()
            local isInVehicle = IsPedInAnyVehicle(ped, false)

            if isInVehicle then
                local viewMode = GetFollowVehicleCamViewMode()
                if viewMode == 1 or viewMode == 2 then
                    SetFollowVehicleCamViewMode(4)
                end
            else
                local viewMode = GetFollowPedCamViewMode()
                if viewMode == 2 then
                    SetFollowPedCamViewMode(4)
                end
            end

            if not isInVehicle then
                ClampGameplayCamPitch(-80.0, 80.0)
            end

            SetPlayerForcedZoom(PlayerId(), not isInVehicle)
            
            local weapon = GetSelectedPedWeapon(ped)

            if weaponDamages[weapon] then
                local _, bone = GetPedLastDamageBone(ped)
                local damageMultiplier = 1.0

                if bone == 31086 then
                    damageMultiplier = weaponDamages[weapon].head
                elseif bone == 11816 then
                    damageMultiplier = weaponDamages[weapon].pelvis
                end

                local totalDamageMultiplier = damageMultiplier * weaponDamages[weapon].damage

                SetWeaponDamageModifier(weapon, totalDamageMultiplier)
            end

            if IsPedJumping(ped) or isRolling then
                LastJump = GetGameTimer()
            elseif GetGameTimer() - LastJump < 3000 then
                SetPedMoveRateOverride(ped, 0.5 + math.min((GetGameTimer() - LastJump) / 3000 * 0.5, 0.5))
                DisableControlAction(0, 22)
            end
        end
    end
end)