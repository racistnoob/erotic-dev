

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

local function deleteVeh(vehicle)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
    SetEntityAsMissionEntity(vehicle, false, false)
    DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
    end
end

local function deleteCurrentVehicle(playerPed)
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    if DoesEntityExist(currentVehicle) then
        if GetPedInVehicleSeat(currentVehicle, -1) == playerPed then
            deleteVeh(currentVehicle)
        else
            exports['drp-notifications']:SendAlert('inform', 'You are not the driver.', 5000)
            return
        end
    end
end

local function deletePreviousVehicle(playerPed)
    -- deletes old car to prevent spammed cars
    if not DoesEntityExist(spawnedCar) then
        spawnedCar = false
        return
    end

    -- checks if anyone is in the car
    local shouldDelete = true
    for seatIndex = -1, 5 do
        local ped = GetPedInVehicleSeat(spawnedCar, seatIndex)
        if DoesEntityExist(ped) and ped ~= playerPed then
            shouldDelete = false
        end
    end

    -- deletes car
    if shouldDelete then
        deleteVeh(spawnedCar)
    end
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
            local playerPed = PlayerPedId()
            RequestAnimDict("mp_suicide")
            TaskPlayAnim(playerPed, "mp_suicide", "pill", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "Vicodin"
            })
            ClearPedTasks(playerPed)
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
            -- loadAnimDict("clothingshirt")  
            RequestAnimDict("clothingtie")
            -- TaskPlayAnim(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(playerPed, "clothingtie", "try_tie_negative_a", 1.0, -1, -1, 50, 0, 0, 0, 0)
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "Heavy Armour"
              })

            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 100)
                -- StopAnimTask(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 1.0)
                ClearPedTasks(playerPed)
                API.RemoveItem(item, 1)
            end
            ClearPedTasks(playerPed)
            return true
        end,
        animClearance = true
    })

    Item.Register("armour2", {
        func = function(item)
            if Player.Armour() == 100 then return false end
            local playerPed = PlayerPedId()
            -- loadAnimDict("clothingshirt")  
            RequestAnimDict("clothingtie")
            -- TaskPlayAnim(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(playerPed, "clothingtie", "try_tie_negative_a", 1.0, -1, -1, 50, 0, 0, 0, 0)
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "Heavy Armour"
              })

            if (finished == 100) then
                SetPlayerMaxArmour(PlayerId(), 100)
                AddArmourToPed(Player.Ped(), 60)
                -- StopAnimTask(Player.Ped(), "clothingshirt", "try_shirt_positive_d", 1.0)
                ClearPedTasks(playerPed)
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
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 7500,
                text = "BANDAGING"
              })
            ClearPedTasks(playerPed)

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
            local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(Player.Ped(), "WORLD_HUMAN_SMOKING_POT", 0, false)
            Player.InAnim = true
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "using joint"
              })
            ClearPedTasks(playerPed)

            if (finished == 100) then
                SetPedArmour(Player.Ped(), Player.Armour() + 15)
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
                TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
                Player.InAnim = true 
                local finished = exports["lane-taskbar"]:taskBar({
                    length = 3500,
                    text = "using kevlar"
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
            TaskStartScenarioInPlace(Player.Ped(), "CODE_HUMAN_MEDIC_KNEEL", 0, false)
            Player.InAnim = true 
            local finished = exports["lane-taskbar"]:taskBar({
                length = 3500,
                text = "healing"
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
            local zone = exports['noob']:CurrentSafezone()
            print("Current safezone:", zone)

            if exports['noob']:inSafeZone() and zone == 'casino' then
                local previousCar
                local spawnedCar
                local spawningcars = true
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
                            exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
                            return
                        end
                    end
    
                    deleteCurrentVehicle(playerPed)
                    deletePreviousVehicle(playerPed)
    
                    local car = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(playerPed), true, false)
                    if DoesEntityExist(car) then
                        SetPedIntoVehicle(playerPed, car, -1)
                        exports['drp-notifications']:SendAlert('inform', 'Vehicle spawned', 5000)
                        TriggerEvent('keys:addNew', car, GetVehicleNumberPlateText(car))
                        SetVehicleEngineOn(car, true, true, false)
                        SetVehicleDirtLevel(car, 0.0)
    
                        -- Load saved modifications, if any
                        Citizen.CreateThread(function()
                            local savedMods = GetResourceKvpString("vehicle_" .. tostring(vehiclehash) .. "_mods")
                            if savedMods then
                                local parsedMods = json.decode(savedMods)
                                if parsedMods then
                                    exports["noob"]:SetVehicleProperties(car, parsedMods)
                                end
                            end
                        end)
                    else
                        exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
                    end
                end)
            else
                exports['drp-notifications']:SendAlert('inform', 'Cannot Deluxo out of safezone.', 5000)
            end
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
