---@diagnostic disable: param-type-mismatch

CURRENT_LOCATION = nil
LOADING_VARIATION = false
benchCoords = vec4(241, -1391.5, 29.5600624+1.2, -196)
isOpen = false

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        revertToOriginal()
        DeleteEntity(EDIT_GUN)
    end
end)

exports("applyComponents", function(weaponName)
    local weaponHash = GetHashKey(weaponName)
    local weaponMeta = GetResourceKvpString(tostring(weaponHash).."_components")

    applyAttachmentsFromMeta(json.decode(weaponMeta))
end)

RegisterNetEvent("erp-weaponbench:openMenu", function(data)
    CURRENT_LOCATION = data
    local gun = GetSelectedPedWeapon(PlayerPedId())

    if not WEAPON_LIST[gun] then
        exports['drp-notifications']:SendAlert('error', 'No valid weapon equipped', 1500)
        return
    end
    SetEntityCoords(PlayerPedId(), vec3(240.560211, -1392.974243, 30.453533))
    local coords = CURRENT_LOCATION.editCoords

    local gunData = getAttachmentsForCurrentWeapon(gun, true)

    loadGun(gun, coords)
    SendNUIMessage({ type = "openUI", toggle = true, gunData = gunData })
    isOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    handleBackground()
end)

RegisterNUICallback("changeAttachment", function(data, cb)
    if LOADING_VARIATION then
        cb(true)
        return
    end
    local isTint = type(data.attachment) == "number"
    local componentHash = (isTint and data.attachment and data.attachment) or (isTint and data.lastAttachment and data.lastAttachment) or (data.attachment and joaat(data.attachment)) or (data.lastAttachment and joaat(data.lastAttachment)) or nil
    local gun = GetSelectedPedWeapon(PlayerPedId())

    if isTint then
        SetPedWeaponTintIndex(PlayerPedId(), gun, data.attachment - 1)
        SetWeaponObjectTintIndex(EDIT_GUN, data.attachment - 1)
        local newMeta = extractNewMetaFromData(getAttachmentsForCurrentWeapon(gun))
        SetResourceKvp(tostring(gun).."_components", json.encode(newMeta))
        cb(true)
        return
    end

    local model = GetWeaponComponentTypeModel(componentHash)
    if not data.attachment then
        if HasPedGotWeaponComponent(PlayerPedId(), gun, componentHash) then
            RemoveWeaponComponentFromPed(PlayerPedId(), gun, componentHash)
            RemoveWeaponComponentFromWeaponObject(EDIT_GUN, componentHash)
            if data.label == "Variation" then
                SetPedWeaponTintIndex(PlayerPedId(), gun, 0)
                SetWeaponObjectTintIndex(EDIT_GUN, 0)
            end
        end
    else
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end
        GiveWeaponComponentToWeaponObject(EDIT_GUN, componentHash)
        GiveWeaponComponentToPed(PlayerPedId(), gun, componentHash)
    end
    if data.label == "Variation" then
        LOADING_VARIATION = true
        SendNUIMessage({ type = "toggleButtonLock", toggle = LOADING_VARIATION})
        SetEntityVisible(EDIT_GUN, false, false)
        Wait(300)
        refreshEditGun(gun)
    end
    local newMeta = extractNewMetaFromData(getAttachmentsForCurrentWeapon(gun))
    SetResourceKvp(tostring(gun).."_components", json.encode(newMeta))
    cb(true)
end)

RegisterNUICallback("onExit", function(data, cb)
    isOpen = false
    destroyWeaponCamera()
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteEntity(EDIT_GUN)
    EDIT_GUN = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    cb(true)
end)

RegisterNUICallback("onCancel", function(data, cb)
    isOpen = false
    cancelEditGun()
    cb(true)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end