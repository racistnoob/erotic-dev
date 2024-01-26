inventoryOpened = false
NUI_LOADED = false
inventoryData = nil

exports("GetPlayerInventory", function()
    return inventoryData 
end)

RegisterNUICallback('nui:zbrp:mounted', function()
    NUI_LOADED = true
    TriggerServerEvent('SETUPINVENTORY')
end)

AddEventHandler('echorp:playerSpawned', function()
    TriggerEvent("Inv:load:components")
end)

-- MAIN OPENING THREAD
Citizen.CreateThread(
    function()
        local function keybind(name, key, cb)
            RegisterCommand("+" .. name, function()
                cb()
            end)
            RegisterCommand("-" .. name, function()
                cb()
            end)
            RegisterKeyMapping("+" .. name, name, 'keyboard', key)
        end
        keybind("openInventoryF2", "TAB", function()
                openInventory()
        end)
        return collectgarbage()
    end
)

function openInventory()
    SendNUIMessage({ action = 'openInventory', isMale = IsPedMale(PlayerPedId()) })
end

RegisterNUICallback('nui:zbrp:blurState', function(blur)
    if blur == 'on' then
        TriggerScreenblurFadeIn()
    elseif blur == 'off' then
        TriggerScreenblurFadeOut()
    end
end)

RegisterNUICallback('nui:zbrp:openedState', function(data)
    local state = data.state
    local blur = data.blur
    
    inventoryOpened = state

    -- global
    SetNuiFocus(state, state)
    -- Scaleform.Cursor()
    

    if state then
        if blur == 'on' then TriggerScreenblurFadeIn() end
    else
        if selectedTrunkOpened and DoesEntityExist(selectedTrunkOpened) then
            
            if NetworkGetEntityIsNetworked(selectedTrunkOpened) then
                NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(selectedTrunkOpened))
                while DoesEntityExist(selectedTrunkOpened) and
                    NetworkGetEntityOwner(selectedTrunkOpened) ~= PlayerId() and
                    DoesEntityExist(selectedTrunkOpened) do
                    Citizen.Wait(1)
                end
            end

            SetVehicleDoorShut(selectedTrunkOpened, 5, false)
            selectedTrunkOpened = nil
            ClearPedTasksImmediately(PlayerPedId())
        end

        TriggerServerEvent('zbrp:removeSecondary')
        TriggerScreenblurFadeOut()
        -- Scaleform.Hide()
    end
end)

RegisterNetEvent('zbrp:updateSecondInventory')
AddEventHandler('zbrp:updateSecondInventory', function(inventory, maxweight)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end
    SendNUIMessage({
        action = 'updateSecondInventory',
        inventory = inventory,
        maxweight = maxweight
    })
end)

RegisterNetEvent('zbrp:JoinedLobby')
AddEventHandler('zbrp:JoinedLobby', function()
    -- SetEntityCoords(PlayerPedId(), 234.2412, -1393.6769, 30.5178)
    -- SetEntityHeading(PlayerPedId(), 141.6501)
end)

RegisterNetEvent('zbrp:updatePlayerInventory')
AddEventHandler('zbrp:updatePlayerInventory', function(inventory)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end

    SendNUIMessage({
        action = 'updatePlayerInventory',
        inventory = inventory
    })
    inventoryData = inventory
end)

RegisterNetEvent('zbrp:setPlayerStaticData')
AddEventHandler('zbrp:setPlayerStaticData', function(maxweight, name)
    while not NUI_LOADED do
        Citizen.Wait(100)
    end
    -- print("Player Static Data: "..maxweight.. " - "..name)
    SendNUIMessage({ action = 'setPlayerStaticData', maxweight = maxweight, name = name})
end)

RegisterNUICallback('nui:zbrp:moveInside', function(data)
    print("move inside")
    TriggerServerEvent('nui:zbrp:moveInside', data)
end)
RegisterNUICallback('nui:zbrp:moveToFirst', function(data)
    print("farting")
    TriggerServerEvent('nui:zbrp:moveToFirst', data)
end)
RegisterNUICallback('nui:zbrp:moveToSecond', function(data)
    TriggerServerEvent('nui:zbrp:moveToSecond', data)
end)
RegisterNUICallback('nui:zbrp:instantToSecond', function(index)
    TriggerServerEvent('nui:zbrp:instantToSecond', index)
end)
RegisterNUICallback('nui:zbrp:instantToMain', function(index)
    TriggerServerEvent('nui:zbrp:instantToMain', index)
end)
RegisterNUICallback('nui:zbrp:useItem', function(index)
    TriggerServerEvent('nui:zbrp:useItem', index)
end)
RegisterNUICallback('nui:zbrp:giveItemToTarget', function(data)
    local targetSrc = tonumber(data.targetSrc)
    local targetHandle = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    local playerpos = GetEntityCoords(PlayerPedId())
    if targetHandle and #(playerpos - GetEntityCoords(targetHandle)) < 5.0 then
        TriggerServerEvent('nui:zbrp:giveItemToTarget', data)
    else
        Functions.SendNotification(_U('target_notnear'), 'warning')
    end
end)

-- SECONDARY INVENTORIES RENDER
--[[
Citizen.CreateThread(
    function()
        local modelhash = GetHashKey('p_v_43_safe_s')
        RequestModel(modelhash)
        while not HasModelLoaded(modelhash) do
            Citizen.Wait(10)
        end
        for i=1, #Config.FactionSafes, 1 do
            local obj = CreateObject(modelhash, Config.FactionSafes[i].pos, false, false, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityHeading(obj, Config.FactionSafes[i].heading)
        end
        SetModelAsNoLongerNeeded(modelhash)

        while true do
            local letSleep = true
            Citizen.Wait(0)

            local playerpos = GetEntityCoords(PlayerPedId())

            for i=1, #Config.OtherInventories, 1 do
                local d = Config.OtherInventories[i]
                local dist = #(playerpos - d.pos)
                if dist < 5 then
                    letSleep = false
                    DrawMarker(0,d.pos+vector3(0.0, 0.0, 1.5),0.0,0.0,0.0,0.0,0.0,0.0,0.3,0.3,0.3,255,255,255,80,true,false,0,nil,nil,false)
                end
            end

            if letSleep then
                Citizen.Wait(1000)
            end
        end
    end
)]]

RegisterNUICallback('getNearbyPlayers', function(_, cb)
    local players = GetActivePlayers()
    local tbl = {}
    local playerpos = GetEntityCoords(PlayerPedId())
    for i=1, #players, 1 do
        if players[i] ~= PlayerId() then
            local dist = #(playerpos - GetEntityCoords(GetPlayerPed(players[i])))
            if dist < 5.0 then
                table.insert(tbl, GetPlayerServerId(players[i]))
            end
        end
    end
    if #tbl > 0 then
        cb(tbl)
    else
        Functions.SendNotification(_U('no_player_nearby'), 'info')
    end
end)

RegisterNetEvent('zbrp:itemNotification')
AddEventHandler('zbrp:itemNotification', function(name, formatname, count)
    SendNUIMessage({action = 'itemNotification', name = name, formatname = formatname, count = count})
end)

local function GetWeight()
    local weight = 0.0 
    if inventoryData then 
        for k,v in pairs(inventoryData) do 
            if v.itemdata then 
                weight = weight + (v.itemdata.weight * v.quantity)
            end
        end
    end
    return weight
end

-- exports["Inventory"]:GetInvSpace()
exports("GetInvSpace", function()
    
    return GetWeight(), Config.DefaultWeights['player']
end)

Citizen.CreateThread(function()
    while true do
        -- print(GetWeight() / Config.DefaultWeights['player'])
        Citizen.Wait(0)
        if inventoryData then
            if IsDisabledControlJustPressed(0, 157) then -- 1
                if inventoryData[1] ~= 'empty' then
                    if CanUse(1) then TriggerServerEvent('nui:zbrp:useItem', 1) end
                end
            elseif IsDisabledControlJustPressed(0, 158) then -- 2
                if inventoryData[2] ~= 'empty' then
                    if CanUse(2) then TriggerServerEvent('nui:zbrp:useItem', 2) end
                end
            elseif IsDisabledControlJustPressed(0, 160) then -- 3
                if inventoryData[3] ~= 'empty' then
                    if CanUse(3) then TriggerServerEvent('nui:zbrp:useItem', 3) end
                end
            elseif IsDisabledControlJustPressed(0, 164) then -- 4
                if inventoryData[4] ~= 'empty' then
                    if CanUse(4) then TriggerServerEvent('nui:zbrp:useItem', 4) end
                end
            elseif IsDisabledControlJustPressed(0, 165) then --5
                if inventoryData[5] ~= 'empty' then
                    if CanUse(5) then TriggerServerEvent('nui:zbrp:useItem', 5) end
                end
            end
        end
    end
end)

function IsWeapon(slot)
    if string.find(inventoryData[slot].item, "WEAPON") then return true end
    return false 
end

function CanUse(slot)
    -- if they are in animation stop them from pulling out weapon 
    if IsWeapon(slot) and Player.InAnim then return false end
    return true
end

-- [[ WEAPON WHEEL ]] --
CreateThread(function()
    while true do
        Wait(0)
        BlockWeaponWheelThisFrame()
        DisableControlAction(0, 36, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 199, true)

        DisableControlAction(0, 199, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
    end
end)