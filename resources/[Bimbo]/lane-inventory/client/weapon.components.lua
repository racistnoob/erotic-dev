local suppressor = false
NoSuppressorComponents = {

}

SuppressorComponents = {
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
    if suppressor == false then
        if NoSuppressorComponents[primary] == nil then return end 
            for k,v in pairs(NoSuppressorComponents[primary]) do 
                print(v.comp)
                GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(primary), GetHashKey(v.comp))
        end
    else 
        if SuppressorComponents[primary] == nil then return end 
            for k,v in pairs(SuppressorComponents[primary]) do 
                print(v.comp)
                GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(primary), GetHashKey(v.comp))
            end
        end
    end

RegisterCommand("silencer", function(source, args, rawCommand)
    if suppressor == false then
        suppressor = true
    else
        suppressor = false
    end
end)
