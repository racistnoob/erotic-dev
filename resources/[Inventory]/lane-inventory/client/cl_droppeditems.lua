droppedItems = {}

RegisterNetEvent('zbrp:spawnDroppedItems')
RegisterNetEvent('zbrp:removeDroppedItem')
RegisterNetEvent('zbrp:addDroppedItem')

RegisterNUICallback('nui:zbrp:throwItem', function(data)
    local playerpos = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('nui:zbrp:throwItem', data, playerpos)
end)

AddEventHandler('zbrp:spawnDroppedItems', function(alldrops)
    droppedItems = alldrops

    for k,v in pairs(droppedItems) do
        local item = v.item

        if item.itemdata and item.itemdata.model then
            local model = GetHashKey(item.itemdata.model)
            if IsModelValid(model) and IsModelInCdimage(model) then
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(1)
                end

                droppedItems[k].objecthandle = CreateObject(model, v.pos, false, false, true)
                while not HasCollisionForModelLoaded(model) do
                    Citizen.Wait(1)
                end
                -- ActivatePhysics(droppedItems[k].objecthandle)
                SetEntityNoCollisionEntity(PlayerPedId(), droppedItems[k].objecthandle, false)
                Wait(5000)
                if droppedItems[id].objecthandle ~= nil then
                if DoesEntityExist(droppedItems[k].objecthandle) then
                FreezeEntityPosition(droppedItems[k].objecthandle, true) end end
                SetModelAsNoLongerNeeded(model)
            end
        end
    end
end)

AddEventHandler('zbrp:removeDroppedItem', function(id)
    if droppedItems[id] then
        if DoesEntityExist(droppedItems[id].objecthandle) then
            DeleteObject(droppedItems[id].objecthandle)
        end

        droppedItems[id] = nil
    end
end)

AddEventHandler('zbrp:addDroppedItem', function(id, data)
    Wait(20)
    droppedItems[id] = data

    local item = data.item

    if item.itemdata and item.itemdata.model then
        local model = GetHashKey(item.itemdata.model)
        if IsModelValid(model) and IsModelInCdimage(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(1)
            end

            droppedItems[id].objecthandle = CreateObject(model, data.pos-vector3(0.0, 0.0, 0.5), false, false, true)
            while not HasCollisionForModelLoaded(model) do
                Citizen.Wait(1)
            end
            ActivatePhysics(droppedItems[id].objecthandle)
            Wait(5000)
            if droppedItems[id] ~= nil then
            if DoesEntityExist(droppedItems[id].objecthandle) then
            FreezeEntityPosition(droppedItems[id].objecthandle, true)
            SetEntityNoCollisionEntity(PlayerPedId(), droppedItems[id].objecthandle, false)
            SetModelAsNoLongerNeeded(model) end end
            if playerHasWeapon() then 
                API.SyncAmmo()
            end

        end
    end
end)

local defaultColour = 'm'

Citizen.CreateThread(function()
    while true do
        if not IsEntityDead(Player.Ped()) then 
        local letSleep = true
        local playerpos = GetEntityCoords(PlayerPedId())
        for k,v in pairs(droppedItems) do
            if DoesEntityExist(v.objecthandle) then
                local objcoords = GetEntityCoords(v.objecthandle)
                local dist = #(playerpos - objcoords)
                if dist < 5.0 then
                    letSleep = false
                    if v.item.itemdata.stackable and v.item.quantity > 0 then
                        if dist < 1.5 then
                            Functions.DrawText3D(objcoords, string.format('%s [%s]', v.item.itemdata.formatname, v.item.quantity), true)
                            if IsDisabledControlJustPressed(0, 38) then
                                TriggerServerEvent('zbrp:pickupItem', k)
                                break
                            end
                        else
                            Functions.DrawText3D(objcoords, string.format('%s [%s]', v.item.itemdata.formatname, v.item.quantity))
                        end
                    else
                        if dist < 1.5 then
                            Functions.DrawText3D(objcoords, string.format('%s', v.item.itemdata.formatname), true)
                            if IsDisabledControlJustPressed(0, 38) then
                                TriggerServerEvent('zbrp:pickupItem', k)
                                break
                            end
                        else
                            Functions.DrawText3D(objcoords, string.format('%s', v.item.itemdata.formatname))
                        end
                    end
                end
            end
        end

        if letSleep then
            Citizen.Wait(1000)
        end end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("zbrp:addDroppedItem", API.SyncAmmo)


function DropAll()
    for k,v in pairs(inventoryData) do 
        if v and v.item then 
            TriggerServerEvent("nui:zbrp:throwItem", {index = k, count = v.quantity}, Player.Coords())
        end
    end
end
RegisterNetEvent("inventory.api:DropAll", DropAll)

function clearDropped()
    for k,v in pairs(droppedItems) do 
        if droppedItems[k] then
            if DoesEntityExist(droppedItems[k].objecthandle) then
                DeleteObject(droppedItems[k].objecthandle)
            end
            droppedItems[k] = nil
        end
    end
end
RegisterNetEvent("inventory.Api:ClearDroppedItems", clearDropped)