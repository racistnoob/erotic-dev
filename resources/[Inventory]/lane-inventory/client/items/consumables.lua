--[[
    MAIN ITEM REGISTER THREAD
]]
local healing = false
CreateThread(function()
    Item.Register("oxy", {
        func = function(item)
            if Player.Health() == 200 or healing == true then
                -- Already Full HP
                --return false
            end
            local playerPed = PlayerPedId()
            local finished = exports["lane-taskbar"]:taskBar({
                length = 2500,
                text = "Vicodin",
                animation = { dict = "mp_suicide", anim = "pill" },
                canShoot = true
            })
            if (finished == 100) then
                local count = math.random(30, 60)
                healing = true
                while count > 0 do
                    Wait(1000)
                    count = count - 1
                    healAmount = math.random(1, 4)
                    SetEntityHealth(playerPed, GetEntityHealth(playerPed) + healAmount)
                    if IsEntityDead(playerPed) then
                        healing = false
                        break
                    end
                end
                healing = false
            end
        end
    })
    
    Item.Register("armour", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local playerPed = PlayerPedId()
            local finished = exports["lane-taskbar"]:taskBar({
                length = 4500,
                text = "Heavy Armour",
                animation = { dict = "clothingtie", anim = "try_tie_negative_a" }
              })
            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 100)
                API.RemoveItem(item, 1)
            end
            return true
        end,
        animClearance = true
    })

    Item.Register("armour2", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local playerPed = PlayerPedId()
            local finished = exports["lane-taskbar"]:taskBar({
                length = 4500,
                text = "Heavy Armour",
                animation = { dict = "clothingtie", anim = "try_tie_negative_a" }
              })

            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 60)
                API.RemoveItem(item, 1)
            end
            ClearPedTasks(playerPed)
            return true
        end,
        animClearance = true
    })

    Item.Register("bandage", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() >= 175 then return false end 
            local playerPed = PlayerPedId()

            local currentHealth = Player.Health()
            local healthToSet = currentHealth + 15
            if healthToSet >= 175 then 
                healthToSet = 175 
            end
            -- animation + set health
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 4500,
                text = "BANDAGING",
                animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL" }
              })
            if (finished == 100) then
                SetEntityHealth(Player.Ped(), healthToSet)
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
            return true
        end,
        animClearance = true
    })

    Item.Register("repairkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            local a = GetEntityCoords(Player.Ped(), 1)
            local b = GetOffsetFromEntityInWorldCoords(Player.Ped(), 0.0, 100.0, 0.0)
            local veh = Player.GetTargetVehicle(a, b)
            if veh == 0 then return false end 

            Player.InAnim = true
            SetVehicleDoorOpen(veh, 4, 1, 1)
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "repairing",
                animation = { dict = "mini@repair", anim = "fixing_a_player" }
              })

            if (finished == 100) then
                SetVehicleEngineHealth(veh, 9999)
                SetVehiclePetrolTankHealth(veh, 9999)
                SetVehicleFixed(veh)
                TriggerEvent("InteractSound_CL:PlayOnOne","airwrench", 0.1)
                StopAnimTask(Player.Ped(), "mini@repair", "fixing_a_player", 1.0)
                Player.InAnim = false
                API.RemoveItem(item, 1)
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
            return true
        end,
        animClearance = true
    })

    Item.Register("radio", {
        func = function(item)
            TriggerEvent("radioGui")
            return true
        end,
        animClearance = false,
        onDrop = function(item)
            TriggerEvent("disableRadio")
        end,
    })

    Item.Register("joint", {
        func = function(item)
            --if Player.Armour() == 100 then return false end
            local playerPed = PlayerPedId()
            Player.InAnim = true
            local finished = exports["lane-taskbar"]:taskBar({
                length = 2500,
                text = "using joint",
                animation = { dict = "amb@world_human_smoking_pot@male@base", anim = "base", prop = "joint"},
                canShoot = true
            })

            if (finished == 100) then
                SetPedArmour(Player.Ped(), Player.Armour() + 15)
                ClearPedTasks(Player.Ped())
                DeleteEntity(jointProp)
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            Player.InAnim = false

        end,
        animClearance = true
    })

    Item.Register("kevlar", {
        func = function(item)
            if Player.Armour() == 100 then return false end 
            local playerPed = PlayerPedId()
            if Player.InVehicle() and GetEntitySpeed(PlayerPedId()) < 1.0 then 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar"
                  })
                ClearPedTasks(playerPed)
    
                if (finished == 100) then
                    SetPedArmour(Player.Ped(), 100)
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end
                
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false
                return 
            elseif Player.InVehicle() and GetEntitySpeed(PlayerPedId()) > 1.0 then 
                return false
            elseif not Player.InVehicle() then 

                Player.InAnim = true 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar",
                    animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL"}
                  })
                ClearPedTasks(playerPed)
    
                if (finished == 100) then
                    SetPedArmour(Player.Ped(), 100)
                    ClearPedTasksImmediately(Player.Ped())
                    API.RemoveItem(item, 1)
                    Player.InAnim = false
                end
                
                ClearPedTasksImmediately(Player.Ped())
                Player.InAnim = false

            end
        end,
        animClearance = true
    })

    Item.Register("medkit", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() == 200 then return false end 
            local playerPed = PlayerPedId()
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "healing",
                animation = { scenario = "CODE_HUMAN_MEDIC_KNEEL" }
              })
            ClearPedTasks(playerPed)

            if (finished == 100) then
                SetEntityHealth(Player.Ped(), 200)
                ClearPedTasksImmediately(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false
        end,
        animClearance = true
    })

    Item.Register("deluxo", {
        func = function(item)
                local playerPed = PlayerPedId()
                local vehiclehash = GetHashKey("deluxo")
                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.5, 0.0, 0.0))
    
                RequestModel(vehiclehash)
    
                Citizen.CreateThread(function()
                    local waiting = 0
                    while not HasModelLoaded(vehiclehash) do
                        waiting = waiting + 100
                        Citizen.Wait(100)
                        if waiting > 5000 then
                            return
                        end
                    end
    
                    deleteCurrentVehicle(playerPed)
                    deletePreviousVehicle(playerPed)
    
                    local car = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(playerPed), true, false)
                    if DoesEntityExist(car) then
                        SetPedIntoVehicle(playerPed, car, -1)
                        SetVehicleEngineOn(car, true, true, false)
                        SetVehicleDirtLevel(car, 0.0)
                    end
                end)
        end,
    }) 

    Item.Register("stamina", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.InStim then return false end 
            Player.InStim = true 
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
            API.RemoveItem(item, 1)
            TriggerEvent("notifyClient", "Using Stamina Shot", "centerRight", 5000)
            Wait(15000)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            Player.InStim = false 
        end,
        animClearance = true
    })

    for k,v in pairs(Config.Loadouts) do 
        local kit = v.kit 
        local name = v.name 
        local format = v.format 
        Item.Register(name, {
            func = function(item)
                if Player.InVehicle() then return false end 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "Using Loadout"
                  })
                ClearPedTasks(PlayerPedId())
                if (finished == 100) then
                    DoKitStuff(kit)
                    API.RemoveItem(item, 1)
                end
            end,
        })
    end
end)
