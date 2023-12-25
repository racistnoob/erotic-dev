local components = false

NoWeaponComponents = {}

CurrentSkin = 1

WeaponSkins = {
    [1] = "1",
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7"
}

WeaponComponents = {
    ["WEAPON_ASSAULTRIFLE"] = {
        {comp = "COMPONENT_AT_AR_SUPP_02"}
    },
    ["WEAPON_HEAVYRIFLE"] = {
        {comp = "COMPONENT_AT_AR_SUPP"},
    },
    ["WEAPON_TACTICALRIFLE"] = {
        {comp = "COMPONENT_AT_AR_SUPP_02"}
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        {comp = "COMPONENT_AT_AR_SUPP"}
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        {comp = "COMPONENT_SPECIALCARBINE_MK2_CLIP_02"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM_MK2"},
        {comp = "COMPONENT_AT_AR_SUPP_02"},
        {comp = "COMPONENT_AT_AR_AFGRIP_02"}
    },
    ["WEAPON_COMBATMG_MK2"] = {
        {comp = "COMPONENT_AT_AR_AFGRIP"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM_MK2"},
        {comp = "COMPONENT_AT_MG_BARREL_02"},
    },
    ["WEAPON_SPECIALCARBINE"] = {
        {comp = "COMPONENT_SPECIALCARBINE_CLIP_03"},
        {comp = "COMPONENT_AT_SCOPE_MEDIUM"},
        {comp = "COMPONENT_AT_AR_SUPP_02"},
        {comp = "COMPONENT_AT_AR_AFGRIP"},
        {comp = "COMPONENT_AT_AR_FLSH"}
    }
}

function ApplyWeaponComponents(primary)
    print("COMP: " .. primary)
    if components == false then
        if NoWeaponComponents[primary] == nil then return end 
            for k,v in pairs(NoWeaponComponents[primary]) do 
                print(v.comp)
                GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(primary), GetHashKey(v.comp))
        end
    else 
        if WeaponComponents[primary] == nil then return end 
            for k,v in pairs(WeaponComponents[primary]) do 
                print(v.comp)
                GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(primary), GetHashKey(v.comp))
            end
        end
    end

function ApplyWeaponSkin(ped, weaponHash, skinIndex)
    print("Skin " .. skinIndex)
    if skinIndex >= 1 and skinIndex <= 7 then
        SetPedWeaponTintIndex(ped, weaponHash, skinIndex)
    else
        SetPedWeaponTintIndex(ped, weaponHash, 1)
    end
end

RegisterCommand("silencer", function(source, args, rawCommand)
    if components == false then
        components = true
    else
        components = false
    end
end)

RegisterCommand("skin", function(source, args, rawCommand)
    local skinIndex = tonumber(args[1])
    if skinIndex and skinIndex >= 1 and skinIndex <= 7 then
        CurrentSkin = skinIndex
    else
        print("Invalid skin index. Please use a number between 1 and 7.")
    end
end)