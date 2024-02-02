---@diagnostic disable: param-type-mismatch, missing-parameter, cast-local-type, assign-type-mismatch
EDIT_GUN = nil
BONE_POSITIONS = {}
ORIGINAL_DATA = {}

local pairs = pairs
function GetWeaponBoneCoords(gunHash)
    local list = {}
    local isChange = false

    if not DoesEntityExist(EDIT_GUN) then
        return
    end
    if gunHash ~= nil then
        for i, v in pairs(WEAPON_LIST[gunHash]) do
            if v.bone then
                local boneIndex = GetEntityBoneIndexByName(EDIT_GUN, v.bone)
                local bonePosition = GetWorldPositionOfEntityBone(EDIT_GUN, boneIndex)
                if v.label == "Tint" then
                    bonePosition = GetOffsetFromEntityInWorldCoords(EDIT_GUN, 0.03, 0, -0.05)
                end
                if v.label == "Variation" then
                    bonePosition = GetOffsetFromEntityInWorldCoords(EDIT_GUN, 0, 0, -0.05)
                end
                local onScreen, _x, _y = GetScreenCoordFromWorldCoord(bonePosition.x, bonePosition.y, bonePosition.z)
                _x = ("%.3f%%"):format((_x * 100))
                _y = ("%.3f%%"):format((_y * 100))
                local index = i - 1
                if (BONE_POSITIONS[index]?.left ~= _x or BONE_POSITIONS[index]?.top ~= _y) then
                    isChange = true
                    list[index] = { left = _x, top = _y, visibility = onScreen and "visible" or "hidden" }
                else
                    list[index] = BONE_POSITIONS[index]
                end
            end
        end
    end
    if isChange then
        BONE_POSITIONS = list
    end
    return isChange
end

function revertToOriginal()
    if #ORIGINAL_DATA == 0 then return end
    removeAllAttachments()
    local originMeta = extractNewMetaFromData(ORIGINAL_DATA)
    SetResourceKvp(tostring(GetSelectedPedWeapon(PlayerPedId())).."_components", json.encode(originMeta))
    applyAttachmentsFromMeta(originMeta)
    ORIGINAL_DATA = {}
end

function extractNewMetaFromData(data)
    local newMeta = {}
    local found = false
    for i = 1, #data do
        local category = data[i]
        found = false
        for y = 1, #category.options do
            local attachmentInfo = category.options[y]
            if attachmentInfo.selected then
                found = true
                newMeta[#newMeta+1] = attachmentInfo.attachment
            end
        end
        if not found and category?.options?[1]?.attachment then
            newMeta[#newMeta+1] = category.options[1].attachment
        end
    end
    return newMeta
end

function removeAllAttachments()
    local _, gun = GetCurrentPedWeapon(PlayerPedId(), 1)
    for i = 1, #WEAPON_LIST[gun] do
        local attachmentInfo = WEAPON_LIST[gun][i]
        for y = 1, #attachmentInfo.options do
            local data = attachmentInfo.options[y]
            if data.attachment then
                RemoveWeaponComponentFromPed(PlayerPedId(), gun, joaat(data.attachment))
            end
        end
    end
end

function applyAttachmentsFromMeta(givenMeta)
    local meta = givenMeta

    if not meta then return end

    for i = 1, #meta do
        local isTint = type(meta[i]) == "number"
        local attachment = isTint and meta[i] or meta[i]
        local _, gun = GetCurrentPedWeapon(PlayerPedId(), 1)
        if not isTint then
            if not meta[i]:find("CLIP") then
                attachment = joaat(meta[i])
                GiveWeaponComponentToPed(PlayerPedId(), gun, attachment)
            end
        else
            SetPedWeaponTintIndex(PlayerPedId(), gun, attachment - 1)
        end
    end
    return newMeta
end


function getAttachmentsForCurrentWeapon(gun, saveog)
    local weaponListCopy = deepcopy(WEAPON_LIST)

    for i = 1, #weaponListCopy[gun] do
        if weaponListCopy[gun][i] then
            local hasNone = 0
            local found = false
            if weaponListCopy[gun][i].label == "Tint" then
                local tintCount = GetWeaponTintCount(gun)
                local tintIndex = (tintCount < 9 and 1) or 2
                weaponListCopy[gun][i].options = {}

                for tint, data in ipairs(WEAPON_TINTS[tintIndex]) do
                    local selected = GetPedWeaponTintIndex(PlayerPedId(), gun) == tint - 1
                    weaponListCopy[gun][i].options[#weaponListCopy[gun][i].options + 1] = {price = selected and "Equipped" or "", label = data.label, attachment = tint, selected = selected}
                end
            else
                for y = 1, #weaponListCopy[gun][i].options do
                    local componentHash = weaponListCopy[gun][i].options[y].attachment and joaat(weaponListCopy[gun][i].options[y].attachment) or 0
                    if componentHash == 0 then
                        hasNone = y
                    end
                    if HasPedGotWeaponComponent(PlayerPedId(), gun, componentHash) then
                        weaponListCopy[gun][i].options[y].selected = true
                        weaponListCopy[gun][i].options[y].price = "Equipped"
                        found = true
                    else
                        weaponListCopy[gun][i].options[y].selected = false
                        weaponListCopy[gun][i].options[y].price = ""
                    end
                end
                if hasNone > 0 and not found then
                    weaponListCopy[gun][i].options[hasNone].selected = true
                    weaponListCopy[gun][i].options[hasNone].price = "Equipped"
                end
            end
        end
    end
    if saveog then
        ORIGINAL_DATA = weaponListCopy[gun]
    end
    return weaponListCopy[gun]
end

function refreshEditGun(gunHash)
    local gunLastCoords = CURRENT_LOCATION.editCoords
    if EDIT_GUN then
        DeleteEntity(EDIT_GUN)
        EDIT_GUN = nil
    end

    while not DoesEntityExist(EDIT_GUN) do
        if EDIT_GUN == 0 or EDIT_GUN == nil then
            EDIT_GUN = GetWeaponObjectFromPed(PlayerPedId(), true)
            SetEntityCoords(EDIT_GUN, gunLastCoords.xyz)
            SetEntityRotation(EDIT_GUN, 0.0, 0.0, gunLastCoords.w, 1)
            FreezeEntityPosition(EDIT_GUN, true)
        end
         Wait(100)
    end

    handleCamUpdates(EDIT_GUN, gunHash, gunLastCoords)
    LOADING_VARIATION = false
    SendNUIMessage({ type = "toggleButtonLock", toggle = LOADING_VARIATION})
end

function loadGun(gunHash, coords)
    if EDIT_GUN then
        DeleteEntity(EDIT_GUN)
        EDIT_GUN = false
    end
    exports["drp-hud"]:toggleNui(false)
    exports["erotic"]:toggleHud(false)
    exports["killfeed"]:toggleHud(false)
    EDIT_GUN = GetWeaponObjectFromPed(PlayerPedId(), true)
    SetEntityCoords(EDIT_GUN, vector3(coords.x, coords.y, coords.z))
    SetEntityHeading(EDIT_GUN, coords.w)
    FreezeEntityPosition(EDIT_GUN, true)
    RequestWeaponHighDetailModel(EDIT_GUN)
    createWeaponCam(coords, gunHash)
    SetEntityVisible(PlayerPedId(), true, false)
end

function cancelEditGun()
    SetEntityVisible(PlayerPedId(), true, false)
    exports["drp-hud"]:toggleNui(true)
    exports["erotic"]:toggleHud(true)
    exports["killfeed"]:toggleHud(true)
    revertToOriginal()
    destroyWeaponCamera()
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteEntity(EDIT_GUN)
    EDIT_GUN = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    CreateThread(function()
        local timeout = 1000
        while not IsDisabledControlJustReleased(0, 200) and timeout > 0 do
            timeout -= 1
            Wait(0)
            DisableAllControlActions(0)
        end
    end)
    
end

