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