local ped = 0
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(2500)
      ped = PlayerPedId()
  end
end)

Citizen.CreateThread(function()
    while true do
        Wait(250)

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