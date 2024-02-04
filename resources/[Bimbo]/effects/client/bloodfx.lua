local effects = {
    Default = "blood_entry",
    Confetti = "ent_dst_inflate_ball_clr",
    Hatchet = "td_blood_hatchet_back",
    Gumball = "ent_dst_gen_gobstop",
    Cash = "ent_brk_banknotes",
    Mud = "bang_mud",
    Metal = "bang_metal",
    Rocks = "ent_dst_rocks",
    Coins = "ent_brk_coins",
    Glass = "ent_dst_glass_bottles",
    Eletric = "ent_amb_elec_crackle_sp",
    Feathers = "ent_sht_feathers",
    BiggerBlood = "blood_wheel",
    Smoke = "blood_armour",
    --newfx = "",
}

RegisterNetEvent("core:bloodfx:change")
AddEventHandler("core:bloodfx:change", function(effectName)
    local particleDictionary = "core"

    local bloodfx = "blood_entry"

    local ped = PlayerPedId()

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    local particleName = effects[effectName] or effects["Default"]

    UseParticleFxAssetNextCall(particleDictionary)
    ResetParticleFxOverride(bloodfx)
    SetParticleFxOverride(bloodfx, particleName)
    StartParticleFxNonLoopedOnPedBone(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 1.0, false, false, false)

    Citizen.Wait(1000)

    RemoveNamedPtfxAsset("core")
end)

RegisterNetEvent("blood:changeEffect")
AddEventHandler("blood:changeEffect", function(params)
    local effectType = params.effectName
    local particleName = effects[effectName] or effects["Default"]
    
    if particleName then
        SetResourceKvp("graphics_bloodfx", effectType)
        print('KVP loaded', effectType)
        TriggerEvent("core:bloodfx:change", effectType)
    else
        print("Invalid bloodfx type.")
    end
end)

AddEventHandler('erotic:playerSpawned', function()
    local kvpValue = GetResourceKvpString("graphics_bloodfx")
        
    if kvpValue then
        print('KVP loaded:', kvpValue)
        TriggerEvent("core:bloodfx:change", kvpValue)
    else
        print("Player does not have KVP.")
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_bloodfx")
            
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            TriggerEvent("core:bloodfx:change", kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)

RegisterCommand("blood", function(source, args)
    local effectName = args[1] or "Default"

    TriggerEvent("core:bloodfx:change", effectName)
end, false)

local getBloodFXSubMenu = {
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
        header = "Default",
        txt = "Default",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Default", -- Corrected effect name
                number = 1,
                id = 2
            }
        }
    },  
    {
        id = 3,
        header = "Confetti",
        txt = "Confetti",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Confetti", -- Corrected effect name
                number = 2,
                id = 3
            }
        }
    },    
    {
        id = 4,
        header = "Hatchet",
        txt = "Hatchet",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Hatchet", -- Corrected effect name
                number = 3,
                id = 4
            }
        }
    },
    {
        id = 5,
        header = "Gumball",
        txt = "Gumball",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Gumball", -- Corrected effect name
                number = 4,
                id = 5
            }
        }
    },
    {
        id = 6,
        header = "Cash",
        txt = "Cash ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Cash", -- Corrected effect name
                number = 5,
                id = 6
            }
        }
    },
    {
        id = 7,
        header = "Mud",
        txt = "Mud ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Mud", -- Corrected effect name
                number = 6,
                id = 7
            }
        }
    },
    {
        id = 8,
        header = "Metal",
        txt = "Metal ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Metal", -- Corrected effect name
                number = 7,
                id = 8
            }
        }
    },
    {
        id = 9,
        header = "Rocks",
        txt = "Rocks ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Rocks", -- Corrected effect name
                number = 8,
                id = 9
            }
        }
    },
    {
        id = 10,
        header = "Coins",
        txt = "Coins ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Coins", -- Corrected effect name
                number = 9,
                id = 10
            }
        }
    },
    {
        id = 11,
        header = "Glass",
        txt = "Glass ",
        params = {
            event = "blood:changeEffect",
            args = {
                effectName = "Glass", -- Corrected effect name
                number = 10,
                id = 11
            }
        }
    },
}

exports("getBloodFXSubMenu", function()
    return getBloodFXSubMenu
end)