Functions = {}
Config = {}
Config.Locale = 'en'
Config.Debug = false

Config.DebugMsg = function(msg)
    if Config.Debug then print(msg) end
end

Config.NoTrunk = {
    [GetHashKey("terbyte")] = true 
}

Config.FactionSafes = {}

Config.OtherInventories = {
    {
        pos = vector3(-1247.065, -1398.573, 4.171693),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-'..Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(211.16, -1372.96, 29.59),
        weight = 200,
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(1155.36, -463.69, 65.78),
        weight = 200,
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(1281.75, -2560.59, 42.85),
        weight = 200,
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(1583.69, 2895.07, 56.07),
        weight = 200,
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(-232.62, -2433.64, 5.0 ),
        weight = 200,
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(-325.41, 6094.43, 30.46),
        weight = 200, 
        slots = 20,
        assign = function(source) -- THIS IS NOT SHARED! Only opening for the player, because we used with identifier
            return 'southside-' .. Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(1532.95, 6339.8, 23.2),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-' ..Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(-654.39, 1963.07, 500.49),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-'..Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(-270.86, 6334.93, 31.43),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-'..Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(3391.43, 4096.71, 223.71),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-'..Config.getIdentifier(source)
        end
    },
    {
        pos = vector3(-1481.769, -656.9156, 28.94311),
        weight = 200,
        slots = 20,
        assign = function(source)
            return 'southside-'..Config.getIdentifier(source)
        end
    },
    -- {
    --     pos = vector3(-1575.234, -571.3127, 116.3284),
    --     weight = 200,
    --     slots = 20,
    --     assign = function(source)
    --         return 'southside-'..Config.getIdentifier(source)
    --     end
    -- }

    -- { -- THIS IS SHARED! EXAMPLE WITH HOUSING! You need to have a server function to get which house the player is in.
    --     pos = vector3(0.0, 0.0, 0.0),
    --     weight = 1000,
    --     assign = function(source)
    --         return 'house-' .. getplayerhouseId()
    --     end
    -- }
}

Functions.Trim = function(value)
    if value then
        return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
    else
        return nil
    end
end


-- local function allLoadouts()
--     local str = "["

--     for k,v in pairs(Config.Loadouts) do 
--         str = str..'{"item": '..v.name..'", "quantity": 1, "slot": '..k..'},'
--     end
--     str = str.."]"
--     return str 
-- end


-- Config.LoadoutData = {
--     ["pistols"] = 
--     '[{"item" : "LOADOUT_HEAVYPISTOL", "quantity" : 1, "slot" : 1},{"item" : "LOADOUT_M9", "quantity" : 1, "slot" : 2}, {"item" : "LOADOUT_SP45", "quantity" : 1, "slot" : 3}, {"item" : "LOADOUT_VINTAGEPISTOL", "quantity" : 1, "slot" : 4}]',
--     -- ["all"] = '[{"item" : "LOADOUT_HEAVYPISTOL", "quantity" : 1, "slot" : 1},{"item" : "LOADOUT_M9", "quantity" : 1, "slot" : 2},{"item" : "LOADOUT_MP9", "quantity" : 1, "slot" : 3},{"item" : "LOADOUT_MCX", "quantity" : 1, "slot" : 4},{"item" : "LOADOUT_AK47", "quantity" : 1, "slot" : 5},{"item" : "LOADOUT_COMBATPISTOL", "quantity" : 1, "slot" : 6}, {"item":"LOADOUT_M60", "quantity" : 1, "slot" : 7} , {"item":"LOADOUT_APPISTOL", "quantity" : 1, "slot" : 8} , {"item":"LOADOUT_M1911", "quantity" : 1, "slot" : 9}]',
--     ["smgs"] = 
--     '[{"item" : "LOADOUT_SMG_MK2", "quantity" : 1, "slot" : 1},{"item" : "LOADOUT_M9", "quantity" : 1, "slot" : 2},{"item" : "LOADOUT_MP9", "quantity" : 1, "slot" : 3}, {{"item" : "LOADOUT_MPX", "quantity" : 1, "slot" : 4}}, {{"item" : "LOADOUT_TOMMY", "quantity" : 1, "slot" : 5}}]',
--     ["ars"] = 
--     '[{"item" : "LOADOUT_762", "quantity" : 1, "slot" : 1},{"item" : "LOADOUT_AK47", "quantity" : 1, "slot" : 2}, {"item":"LOUDOUT_M16", "quantity" : 1, "slot" : 3}, {"item":"LOADOUT_HEAVYRIFLE", "quantity" : 1, "slot" : 4}, {"item":"LOADOUT_COMPACTRIFLE", "quantity" : 1, "slot" : 5}]'
-- }

-- CreateThread(function()
--     Config.LoadoutData["all"] = '['
--     -- {"item" : "LOADOUT_MCX", "quantity" : 1, "slot" : 1},
--     for k,v in pairs(Config.Loadouts) do 
--         local str
--         if k == #Config.Loadouts then 
--             str = '{"item": "%s", "quantity": %s, "slot": %s}'
--         else
--             str = '{"item": "%s", "quantity": %s, "slot": %s},'
--         end
--         str = str:format(v.name, 1, k)
--         Config.LoadoutData["all"] = Config.LoadoutData["all"]..str
--     end
--     Config.LoadoutData["all"] = Config.LoadoutData["all"]..']'
--     -- print(Config.LoadoutData["all"])
-- end)

Config.Weapons = {
    ["WEAPON_APPISTOL"] = "9mm_rounds",
    ["WEAPON_1911"] = "9mm_rounds",
    ["WEAPON_FNX45"] = "9mm_rounds",
    ["WEAPON_MACHINEPISTOL"] = "9mm_rounds",
    ["WEAPON_PISTOL"] = "9mm_rounds",
    ["WEAPON_USP45"] = "9mm_rounds",
    ["WEAPON_GLOCK17"] = "9mm_rounds",
    ["WEAPON_GLOCK18C"] = "9mm_rounds",
    ["WEAPON_ASSAULTRIFLE"] = "556_rounds",
    ["WEAPON_TACTICALRIFLE"] = "556_rounds",
    ["WEAPON_COMBATPISTOL"] = "9mm_rounds",
    ["WEAPON_COMBATMG"] = "9mm_rounds",
    ["WEAPON_HEAVYPISTOL"] = "9mm_rounds",
    ["WEAPON_M45A1"] = "9mm_rounds",
    ["WEAPON_SP45"] = "9mm_rounds",
    ["WEAPON_SMG_MK2"] = "9mm_rounds",
    ["WEAPON_762"] = "556_rounds",
    ["WEAPON_SPECIALCARBINE"] = "556_rounds",
    ["WEAPON_SPECIALCARBINE_MK2"] = "556_rounds",
    ["WEAPON_BULLPUPRIFLE"] = "556_rounds",
    ["WEAPON_PISTOL50"] = "50cal_rounds",
    ["WEAPON_HEAVYRIFLE"] = "556_rounds",
    ["WEAPON_VINTAGEPISTOL"] = "9mm_rounds",
    ["WEAPON_MK18"] = "556_rounds",
    ["WEAPON_SCARH"] = "556_rounds",
    ["WEAPON_COMPACTRIFLE"] = "556_rounds",
    ["WEAPON_COMBATPDW"] = "9mm_rounds",
    ["WEAPON_MICROSMG"] = "9mm_rounds",
    ["WEAPON_MINISMG"] = "9mm_rounds",
    ["WEAPON_GUSENBERG"] = "9mm_rounds",
    ["WEAPON_ASSAULTSMG"] = "9mm_rounds",
    ["WEAPON_MARKSMANRIFLE_MK2"] = "50cal_rounds",
    ["WEAPON_HEAVYSNIPER_MK2"] = "50cal_rounds",
    ["WEAPON_ADVANCEDRIFLE"] = "556_rounds",
    ["WEAPON_MPX"] = "9mm_rounds",
    ["WEAPON_PISTOLXM3"] = "9mm_rounds",
    ["WEAPON_CERAMICPISTOL"] = "9mm_rounds"
}

exports('getWeaponAmmos', function()
    return Config.Weapons
end)


Config.Loadouts = {
    {name = "LOADOUT_HEAVYPISTOL", format = "Heavy Pistol Loadout", kit = "heavypistol"},
    {name = "LOADOUT_TEC9", format = "Machine Pistol Loadout", kit = "tec9"},
    {name = "LOADOUT_GLOCK17", format = "PD GLOCK", kit = "glock17"},
    {name = "LOADOUT_GLOCK18C", format = "Automatic Pistol", kit = "glock18c"},
    {name = "LOADOUT_HOPOUT", format = "Hopout Loadout", kit = "hopout"},
    {name = "LOADOUT_TRICK", format = "Trick Loadout", kit = "Trick"},
    {name = "LOADOUT_TRICK2", format = "Trick2 Loadout", kit = "Trick2"},
    {name = "LOADOUT_G36", format = "G36 Loadout", kit = "g36"},
    {name = "LOADOUT_BULLPUP", format = "BULLPUP Loadout", kit = "bullpup"},
    {name = "LOADOUT_USP", format = "USP Loadout", kit = "USP"},
    {name = "LOADOUT_AWP", format = "Awp Loadout", kit = "awp"},
    {name = "LOADOUT_M1911", format = "M1911 Beretta Loadout", kit = "1911"},
    {name = "LOADOUT_MP9", format = "MP9 Loadout", kit = "mp9"},
    {name = "LOADOUT_762", format = "762 Loadout", kit = "762"},
    {name = "LOADOUT_AK47", format = "AK-47 Loadout", kit = "akm"},
    {name = "LOADOUT_COMBATPISTOL", format = "Combat Pistol Loadout", kit = "combatpistol"},
    {name = "LOADOUT_SP45", format = "SP45 Loadout", kit = "sp"},
    {name= "LOADOUT_M16", format = "M16 JAWN", kit = "m16"},
    {name= "LOADOUT_HEAVYRIFLE", format = "Heavyrifle", kit = "heavyrifle"},
    {name= "LOADOUT_VINTAGEPISTOL", format = "Vintage Pistol", kit = "vintage"},
    {name= "LOADOUT_SMG_MK2", format = "MP5", kit = "mp5"},
    {name= "LOADOUT_MK18", format = "MK18", kit="mk18"},
    {name= "LOADOUT_COMBATMG", format = "M60", kit="m60"},
    {name= "LOADOUT_SCARH", format = "SCARH", kit="scarh"},
    {name= "LOADOUT_COMPACTRIFLE", format= "draco", kit="draco"},
    {name= "LOADOUT_COMBATPDW", format= "mpx", kit="mpx"},
    {name= "LOADOUT_MICROSMG", format= "uzi", kit="uzi"},
    {name= "LOADOUT_MINISMG", format= "Skorpion", kit="Skorpion"},
    {name= "LOADOUT_GUSENBERG", format= "tommy", kit="tommy"},
    {name= "LOADOUT_ASSAULTSMGG", format= "magpull", kit="magpull"}

}

Config.DefaultWeights = {
    ['player'] = 500,
    ['cartrunk'] = 1000, -- if not exist in the config_weights.lua this is the default
    ['carglovebox'] = 100, -- if not exist in the config_weights.lua this is the default
    ['factionsafe'] = 10000
}

if IsDuplicityVersion() then -- serverside
    Config.WipeDroppedTime = 60000 * 5 -- in normal lobby gamemodes (5 minutes)
    Config.Empty = 'empty' -- DO NOT MODIFY IN ANY CASE
    Config.SaveFreq = 60000 * 90 -- how often save every inventory ( 90  MINUTES )
    Config.DeleteItemsDeath = true -- delete tradable items on death or not
    Config.StartingItems = {}
    Config.DefaultSlots = { -- amount of itemslots inside the inventory type
        ['player'] = 25,
        ['cartrunk'] = 15,
        ['carglovebox'] = 5,
        ['factionsafe'] = 120
    }

    Config.IgnoreSlotsOnPickup = false -- do not add items to slots when we pickup an item (1-5), so it will be added to our 6. slot

    Config.vehicleExistDatabase = function(plate)
        -- here implement your mysql check that the vehicle is exist or not.
        -- example

        -- local exist = MySQL.Sync.fetchScalar('SELECT COUNT(1) FROM av_vehicles WHERE plate = @plate', {
        --     ['@plate'] = plate
        -- })
        -- if exist and exist > 0 then
        --     return true
        -- end
        -- return false

        return true
    end


    Config.getPlayerFaction = function(source) -- ADD YOUR FACTION SYSTEM HERE
        return 'police'
    end

    Config.GetPlayerName = function(source) -- ADD YOUR ROLEPLAY NAME GETTER HERE
        return GetPlayerName(source)
    end

    Config.getIdentifier = function(source)
        local id = nil
        for k, v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len('license:')) == 'license:' then
                id = v
            end
        end

        return id
    end

    Functions.SendNotification = function(source, msg, type) -- EDIT IT TO YOUR NOTIFICATION
        -- TriggerClientEvent('av:Notify', source, type, msg)
    end
else -- clientside
    
    
    Functions.SendNotification = function(msg, type) -- EDIT IT TO YOUR NOTIFICATION
        -- TriggerEvent('av:Notify', type, msg)
    end
    Functions.DrawText3D = function(coords, text, isClose)
        coords = vector3(coords.x, coords.y, coords.z)
        local close = isClose or false
        local camCoords = GetGameplayCamCoords()
        local distance = #(coords - camCoords)

        size = 1
        font = 4

        local scale = (size / distance) * 1.5
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov

        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(font)
        if close then 
            SetTextColour(111,183,22, 255)
        else
            SetTextColour(255, 255, 255, 255)
        end
        -- SetTextDropshadow(255, 255, 255, 255, 255)
        -- SetTextDropShadow()
        SetTextCentre(true)
        SetTextProportional(1)
        

        SetDrawOrigin(coords, 0)
        local factor = (string.len(text)) / 370
        DrawRect(coords+vector3(0.0, 0.0125, 0.0), 0.015+ factor, 0.03, 41, 11, 41, 68)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()

        -- local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        -- local px,py,pz=table.unpack(GetGameplayCamCoords())
        
        -- SetTextScale(0.35, 0.35)
        -- SetTextFont(4)
        -- SetTextProportional(1)
        -- SetTextColour(255, 255, 255, 215)
        -- SetTextEntry("STRING")
        -- SetTextCentre(1)
        -- AddTextComponentString(text)
        -- DrawText(_x,_y)
        -- local factor = (string.len(text)) / 370
        -- DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
        
    end

end
