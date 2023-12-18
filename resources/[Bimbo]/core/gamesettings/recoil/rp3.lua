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


Recoil:RegisterMode('roleplay3', function()
    if IsPedShooting(PlayerPedId()) then
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        if not noRecoil[weapon] then
            local ply = PlayerPedId()
            local GamePlayCamFoot = GetFollowPedCamViewMode()
            local GamePlayCamVehicle = GetFollowVehicleCamViewMode()
            local Vehicled = IsPedInAnyVehicle(ply, false)

            local GamePlayCam = GamePlayCamFoot

            if Vehicled then
                GamePlayCam = GamePlayCamVehicle
            end

            local MovementSpeed = math.ceil(GetEntitySpeed(ply))
            if MovementSpeed > 69 then
                MovementSpeed = 69
            end
            local _, wep = GetCurrentPedWeapon(ply)
            local group = GetWeapontypeGroup(wep)
            local p = GetGameplayCamRelativePitch()
            local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(ply))
            local recoil = math.random(130, 140 + (math.ceil(MovementSpeed * 0.5))) / 100
            local rifle = false


            if group == 970310034 or group == 1159398588 then
                rifle = true
            end


            if cameraDistance < 5.3 then
                cameraDistance = 1.5
            else
                if cameraDistance < 8.0 then
                    cameraDistance = 2.0
                else
                    cameraDistance = 3.0
                end
            end


            if Vehicled then
                recoil = recoil + (recoil * cameraDistance)
            else
                recoil = recoil * 0.8
            end

            if GamePlayCam == 4 then
                recoil = recoil * 0.5
                if rifle then
                    recoil = recoil * 0.1
                end
            end

            if rifle then
                recoil = recoil * 0.1
            end

            local rightleft = math.random(4)
            local h = GetGameplayCamRelativeHeading()
            local hf = math.random(10, 40 + MovementSpeed) / 100

            if Vehicled then
                hf = hf * 2.0
            end

            if rightleft == 1 then
                SetGameplayCamRelativeHeading(h + hf)
            elseif rightleft == 2 then
                SetGameplayCamRelativeHeading(h - hf)
            end

            local set = p + recoil
            SetGameplayCamRelativePitch(set, 0.8)
        end
    end
end)
