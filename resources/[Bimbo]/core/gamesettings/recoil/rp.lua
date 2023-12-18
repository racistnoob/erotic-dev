Recoil:RegisterMode("roleplay", function(self)
    local playerPed = PlayerPedId()
    local _, wep = GetCurrentPedWeapon(playerPed)

    if IsPedShooting(playerPed) then
        local GamePlayCam = GetFollowPedCamViewMode()
        local MovementSpeed = math.ceil(GetEntitySpeed(playerPed))

        if MovementSpeed > 69 then
            MovementSpeed = 69
        end

        local group = GetWeapontypeGroup(wep)
        local p = GetGameplayCamRelativePitch()
        local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(playerPed))
        local recoil = math.random(50, 75 + (math.ceil(MovementSpeed * 1.5))) / 100
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

        local rightleft = math.random(4)
        local h = GetGameplayCamRelativeHeading()
        local hf = math.random(10, 40 + MovementSpeed) / 100

        if rightleft == 1 then
            SetGameplayCamRelativeHeading(h + hf)
        elseif rightleft == 2 then
            SetGameplayCamRelativeHeading(h - hf)
        end

        local standardPitch = p + recoil
        local vehicleClass = GetVehicleClass(GetVehiclePedIsIn(playerPed))

        if vehicleClass == 8 or vehicleClass == 13 then
            local bikePitch = p + math.random(2, 5)
            if math.random(1, 10) >= math.random(1, 5) then
                SetGameplayCamRelativePitch(bikePitch, 1.0)
            else
                SetGameplayCamRelativePitch(bikePitch, 1.0)
            end
        else
            if math.random(1, 10) >= math.random(1, 5) then
                SetGameplayCamRelativePitch(standardPitch, 1.0)
            else
                SetGameplayCamRelativePitch(standardPitch, 1.0)
            end
        end
    end
end)
