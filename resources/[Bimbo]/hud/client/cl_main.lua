Citizen.CreateThread(function()
    while true do
        Wait(100)

        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped) - 100
        local armor = GetPedArmour(ped)

        --print("Health: " .. health .. ", Armor: " .. armor)

        if health < 0 then health = 0 end

        SendNUIMessage({
            type = 'updateHUD',
            health = health,
            armor = armor
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        DisplayAmmoThisFrame(false) -- Disable ammo display
        HideHudComponentThisFrame(1) -- Wanted stars
        HideHudComponentThisFrame(2) -- Weapon icon
        HideHudComponentThisFrame(3) -- Cash
        HideHudComponentThisFrame(4) -- MP Cash
        HideHudComponentThisFrame(6) -- Vehicle name
        HideHudComponentThisFrame(7)  -- Area name, hides armor
        HideHudComponentThisFrame(9)  -- Street name, hides health
        HideHudComponentThisFrame(8) -- Vehicle class
        HideHudComponentThisFrame(9)  -- Street name, hides health
        HideHudComponentThisFrame(13) -- Cash change
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        -- Disable the cinematic camera
        if IsCinematicCamRendering() then
            StopCinematicCamShaking(true)
            SetCinematicButtonActive(false)
        end
    end
end)
