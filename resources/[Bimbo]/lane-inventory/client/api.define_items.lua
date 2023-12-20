

function Item.Register(item, data) -- register item to the ReigsteredItems table 
    RegisteredItems[item] = data
end

function Item.RequiresAnimClearance(item) -- check if InAnim check is required for this item to be used
    return RegisteredItems[item].animClearance 
end

function Item.Use(itemid, slot)
    if Item.RequiresAnimClearance(itemid) and Player.InAnim then return end 
    RegisteredItems[itemid].func(itemid)
end

function API.UseItem(item, slot) -- this is just a translator, its really useless
    Item.Use(item, slot)
end
RegisterNetEvent("inventory.api:useItem", API.UseItem)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end




--[[
    MAIN ITEM REGISTER THREAD
]]
local healing = false
CreateThread(function()
    Item.Register("oxy", {
        func = function(item)
            if Player.Health() == 200 or healing == true then
                -- ShowNotification("~g~Already Healing or Full HP.")
                return false
            end
            RequestAnimDict("mp_suicide")
            TaskPlayAnim(GetPlayerPed(-1), "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "Vicodin"
            })
            ClearPedTasks(GetPlayerPed(-1))
            if (finished == 100) then
                local count = math.random(30, 60)
                healing = true
                while count > 0 do
                    Wait(1000)
                    count = count - 1
                    healAmount = math.random(1, 4)
                    SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + healAmount)
                    if IsEntityDead(GetPlayerPed(-1)) then
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
            -- loadAnimDict("clothingshirt")  
            RequestAnimDict("clothingtie")
            -- TaskPlayAnim(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(GetPlayerPed(-1), "clothingtie", "try_tie_negative_a", 1.0, -1, -1, 50, 0, 0, 0, 0)
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "Medium Armour"
              })

            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 60)
                -- StopAnimTask(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 1.0)
                ClearPedTasks(GetPlayerPed(-1))
                API.RemoveItem(item, 1)
            end
            ClearPedTasks(GetPlayerPed(-1))
            return true
        end,
        animClearance = true
    })

    Item.Register("bandage", {
        func = function(item)
            if Player.InVehicle() then return false end 
            if Player.Health() >= 175 then return false end 
            local currentHealth = Player.Health()
            local healthToSet = currentHealth + 15
            if healthToSet >= 175 then 
                healthToSet = 175 
            end
            -- animation + set health
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "BANDAGING"
              })
            ClearPedTasks(GetPlayerPed(-1))

            if (finished == 100) then
                SetEntityHealth(Player.Ped(), healthToSet)
                ClearPedTasksImmediately(Player.Ped())
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
            loadAnimDict("mini@repair")
            Player.InAnim = true
            TaskPlayAnim(Player.Ped(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
            SetVehicleDoorOpen(veh, 4, 1, 1)
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "repairing"
              })
            ClearPedTasks(GetPlayerPed(-1))

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
            if Player.InVehicle() then TriggerEvent("noticeme:Warn", "Cannot use joints in a car!") return false end 
            TaskStartScenarioInPlace(Player.Ped(), "WORLD_HUMAN_SMOKING_POT", 0, false)
            Player.InAnim = true
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "using joint"
              })
            ClearPedTasks(GetPlayerPed(-1))

            if (finished == 100) then
                SetPedArmour(Player.Ped(), Player.Armour() + 25)
                ClearPedTasks(Player.Ped())
                API.RemoveItem(item, 1)
                Player.InAnim = false
            end
            
            ClearPedTasksImmediately(Player.Ped())
            Player.InAnim = false

        end,
        animClearance = true
    })

    Item.Register("kevlar", {
        func = function(item)
            if Player.Armour() == 100 then return false end 
            if Player.InVehicle() and GetEntitySpeed(PlayerPedId()) < 1.0 then 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar"
                  })
                ClearPedTasks(GetPlayerPed(-1))
    
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
                TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
                Player.InAnim = true 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar"
                  })
                ClearPedTasks(GetPlayerPed(-1))
    
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
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "healing"
              })
            ClearPedTasks(GetPlayerPed(-1))

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


    -- Config.Loadouts = {
    --     {name = "LOADOUT_HEAVYPISTOL", format = "Heavy Pistol Loadout", kit = "heavypistol"},
    --     {name = "LOADOUT_M9", format = "M9 Beretta Loadout", kit = "m9"},
    --     {name = "LOADOUT_MP9", format = "MP9 Loadout", kit = "mp9"},
    --     {name = "LOADOUT_MCX", format = "MCX Loadout", kit = "mcx"},
    --     {name = "LOADOUT_AK47", format = "AK-47 Loadout", kit = "akm"},
    -- }


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
                ClearPedTasks(GetPlayerPed(-1))
                if (finished == 100) then
                    DoKitStuff(kit)
                    API.RemoveItem(item, 1)
                end
            end,
        })
    end
end)
