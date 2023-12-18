-- OPTIMIZE LATER #DL
local attachmentsEnabled = {
    silencerL = false,
    silencerS = false,
    scopeL = false,
    scopeS = false,
}

local attachmentCommands = {
    ["silencerL"] = "silencerL",
    ["silencerS"] = "silencerS",
    ["scopeL"] = "scopeL",
    ["scopeS"] = "scopeS",
}

local skinTypeEnabled = {
    varMods = false,
    platinumSkin = false,
    orangeSkin = false,
    bossSkin = false,
    goldSkin = false,
    pinkSkin = false,
    greenSkin = false,
}

local skinCommands = {
    ["luxe"] = {
        command = "varMods",
    },
    ["plat"] = {
        command = "platinumSkin",
    },
    ["orange"] = {
        command = "orangeSkin",
    },
    ["boss"] = {
        command = "bossSkin",
    },
    ["pink"] = {
        command = "pinkSkin",
    },
    ["green"] = {
        command = "greenSkin",
    },
    ["gold"] = {
        command = "goldSkin",
    },
}

function ToggleAttachment(attachmentType)
    attachmentsEnabled[attachmentType] = not attachmentsEnabled[attachmentType]
    if attachmentsEnabled[attachmentType] then
		TriggerEvent("actionbar:setEmptyHanded")
        --exports['drp-notifications']:SendAlert('inform', 'Attachment Enabled', 5000)
    else
		TriggerEvent("actionbar:setEmptyHanded")
        --exports['drp-notifications']:SendAlert('inform', 'Attachment Disabled', 5000)
    end
end

function ToggleskinType(skinType)
    if not skinTypeEnabled[skinType] then
        for key, _ in pairs(skinTypeEnabled) do
            if key ~= skinType then
                skinTypeEnabled[key] = false
            end
        end
    end

    skinTypeEnabled[skinType] = not skinTypeEnabled[skinType]

    if skinTypeEnabled[skinType] then
		TriggerEvent("actionbar:setEmptyHanded")
        --exports['drp-notifications']:SendAlert('inform', 'Skin Enabled', 5000)
    else
		TriggerEvent("actionbar:setEmptyHanded")
        --exports['drp-notifications']:SendAlert('inform', 'Skin Disabled', 5000)
    end
end

function AttachmentCheck(weaponhash)
    local ped = PlayerPedId()
    
    local weaponTable = {
        "-1074790547",
        "-947031628",
        "-774507221"
    }

    for _, weaponTableHash in ipairs(weaponTable) do
        if exports["drp-inventory"]:hasEnoughOfItem(weaponTableHash, 1, false) then
            if attachmentsEnabled.silencerL then
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_AR_SUPP`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_AR_SUPP_02`)
            end
            if attachmentsEnabled.silencerS then
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_PI_SUPP`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_PI_SUPP_02`)
            end
            if attachmentsEnabled.scopeL then
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_SCOPE_MEDIUM`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_SCOPE_MEDIUM_MK2`)
            end
            if attachmentsEnabled.scopeS then
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_SCOPE_SMALL`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_AT_SCOPE_MACRO`)
            end
            if skinTypeEnabled.varMods then
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_ASSAULTRIFLE_VARMOD_LUXE`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_HEAVYPISTOL_VARMOD_LUXE`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER`)
                GiveWeaponComponentToPed(ped, weaponhash, `COMPONENT_BULLPUPRIFLE_VARMOD_LOW`)
            end
            if skinTypeEnabled.platinumSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 7)
            end
            if skinTypeEnabled.orangeSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 6)
            end
            if skinTypeEnabled.randomSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 5)
            end
            if skinTypeEnabled.bossSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 4)
            end
            if skinTypeEnabled.pinkSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 3)
            end
            if skinTypeEnabled.goldSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 2)
            end
            if skinTypeEnabled.greenSkin then
                SetPedWeaponTintIndex(ped, weaponhash, 1)
            end
            break
        end
    end
end

AddEventHandler('echorp:doLogout', function()
    varMods = false
    platinumSkin = false
    orangeSkin = false
    bossSkin = false
    goldSkin = false
    pinkSkin = false
    greenSkin = false
    silencerL = false
    silencerS = false
    scopeL = false
    scopeS = false
end)

RegisterNetEvent('toggle-skin')
AddEventHandler('toggle-skin', function(params)
    local skinType = params.type
    local skinData = skinCommands[skinType]
    
    if skinData then
        SetResourceKvp("graphics_skin", skinData.command) -- Store the skin command as a string
        print('KVP loaded:', skinData)
        ToggleskinType(skinData.command)
    else
        print("Invalid skin type.")
    end
end)

RegisterNetEvent('toggle-attachment')
AddEventHandler('toggle-attachment', function(params)
    local attachmentType = params.type
    local attachmentName = attachmentCommands[attachmentType]
    
    if attachmentName then
        SetResourceKvp("graphics_attachment", attachmentType)
        print('Attachment KVP set:', attachmentType)
        ToggleAttachment(attachmentType)
    else
        print("Invalid attachment type.")
    end
end)

AddEventHandler('echorp:playerSpawned', function()
    local kvpValue = GetResourceKvpString("graphics_skin")
    local kvpValue2 = GetResourceKvpString("graphics_attachment")
            
    if kvpValue then
        print('KVP loaded:', kvpValue)
        ToggleskinType(kvpValue)
    else
        print("Resource started. Player does not have KVP.")
    end

    if kvpValue2 then
        print('KVP loaded:', kvpValue2)
        ToggleAttachment(kvpValue2)
    else
        print("Resource started. Player does not have KVP.")
    end
end)

--[[AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_skin")
            
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            ToggleskinType(kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)]]

local submenuAttachment = {
    {
        id = 1,
        header = "< Go Back",
        txt = "",
        params = {
            event = "erp-context:GoBackToMainMenu"
        }
    },
    {
        id = 2,
        header = "Small Scope",
        txt = "Enables/Disables Scopes",
        params = {
            event = "toggle-attachment",
            args = {
                type = "scopeS",
                number = 1,
                id = 2
            }
        }
    },
    {
        id = 3,
        header = "Large Scope",
        txt = "Enables/Disables Scopes",
        params = {
            event = "toggle-attachment",
            args = {
                type = "scopeL",
                number = 2,
                id = 3
            }
        }
    },
    {
        id = 4,
        header = "Large Silencer",
        txt = "Enables/Disables Silencers",
        params = {
            event = "toggle-attachment",   
            args = {
                type = "silencerL",
                number = 3,
                id = 4
            }
        }
    },
    {
        id = 5,
        header = "Small Silencer",
        txt = "Enables/Disables Silencers",
        params = {
            event = "toggle-attachment",   
            args = {
                type = "silencerS",
                number = 4,
                id = 5
            }
        }
    },
}

local submenuSkin = {
    {
        id = 1,
        header = "< Go Back",
        txt = "",
        params = {
            event = "erp-context:GoBackToMainMenu"
        }
    },
    {
        id = 2,
        header = "Green",
        txt = "Enables/Disables green skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "green",
                number = 1,
                id = 2
            }
        }
    },
    {
        id = 3,
        header = "Gold",
        txt = "Enables/Disables gold skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "gold",
                number = 2,
                id = 3
            }
        }
    },
    {
        id = 4,
        header = "Pink",
        txt = "Enables/Disables pink skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "pink",
                number = 3,
                id = 4
            }
        }
    },
    {
        id = 5,
        header = "Boss",
        txt = "Enables/Disables Boss skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "boss",
                number = 4,
                id = 5
            }
        }
    },
    {
        id = 6,
        header = "Orange",
        txt = "Enables/Disables Orange skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "orange",
                number = 5,
                id = 6
            }
        }
    },
    {
        id = 7,
        header = "Platinum",
        txt = "Enables/Disables plat skin",
        params = {
            event = "toggle-skin",
            args = {
                type = "plat",
                number = 6,
                id = 7
            }
        }
    },
}

exports("getAttachmentSubMenu", function()
    return submenuAttachment
end)

exports("getSkinSubMenu", function()
    return submenuSkin
end)

exports("AttachmentCheck", AttachmentCheck)