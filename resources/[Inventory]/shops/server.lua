local stashcodes = {
    ['secretguns'] = 808413767
}

RegisterNetEvent('shops:coderesult')
AddEventHandler('shops:coderesult', function(code, type)
    if stashcodes[type] then
        if stashcodes[type] == tonumber(code) then
            TriggerClientEvent('shops:anticheatcheck', source, type)
        end
    end
end)

RegisterNetEvent('shops:weapons:licensecheck')
AddEventHandler('shops:weapons:licensecheck', function(a, b)
    if a and b then
        TriggerEvent('echorp:getplayerfromid', source, function(player)
            local licenses = exports['drp-license']:GetLicenses(player.cid)
            local hasWeapons = false
            for k,v in pairs(licenses) do
                if v['type'] == "weapon" then
                    hasWeapons = true
                    break
                end
            end
            if hasWeapons then
                TriggerClientEvent("server-inventory-open", player.source, a, b)
                TriggerClientEvent('3dme:triggerDisplay', -1, 'Has a weapons license', NetworkGetNetworkIdFromEntity(GetPlayerPed(player.source)), true)
            else
                TriggerClientEvent('3dme:triggerDisplay', -1, 'Missing weapons license', NetworkGetNetworkIdFromEntity(GetPlayerPed(player.source)), true)
            end
        end)
    end
end)

local classesStrings = {
    ['drive'] = "Drive",
    ['drive_bike'] = "Bike",
    ['drive_truck'] = "Truck",
    ['theory'] = "Theory",
    ['pilot'] = "Pilot"
}

local permitsStrings = {
    ['hunting'] = "Hunting",
    ['pilot'] = "Pilot",
    ['weapon'] = "Weapon"
}

RegisterNetEvent('echorp:createId')
AddEventHandler('echorp:createId', function(hairname, eyename, mugshotstring)
    TriggerEvent('echorp:getplayerfromid', source, function(player)
        if player then

            local citizenid = player['cid']
            local firstname = player['firstname']
            local lastname = player['lastname']
            local dateofbirth = "01/01/1970"
            local dob = exports.oxmysql:fetchSync('SELECT dateofbirth FROM users WHERE id=:id LIMIT 1', { id = player['id'] })
            local mugshot = mugshotstring

            if dob and dob[1] then
                dateofbirth = dob[1]['dateofbirth']
            end

            local issuedate = os.date('%m/%d/%Y')
            local expirydate = os.date('%m/%d/%Y', os.time() + 720 * 60 * 60)
            local gender = player['gender']
            local hair = hairname
            local eye = eyename

            local licenses = exports['drp-license']:GetLicenses(player.cid)
            local classes = ""
            local permits = ""
            
            for k,v in pairs(licenses) do
                local toAsTrIng = classesStrings[v['type']]
                local toAsTrIngXX = permitsStrings[v['type']]
                if toAsTrIng then
                    if #classes == 0 then
                        classes = toAsTrIng or "None"
                    else
                        classes = classes.."<br>"..toAsTrIng
                    end
                elseif toAsTrIngXX then
                    if #permits == 0 then
                        permits = toAsTrIngXX or "None"
                    else
                        permits = permits.."<br>"..toAsTrIngXX
                    end
                end
            end            

            local itemInfo = { 
                ['citizenid'] = citizenid,
                ['firstname'] = firstname,
                ['lastname'] = lastname,
                ['dateofbirth'] = dateofbirth,
                ['issuedate'] = issuedate,
                ['expirydate'] = expirydate,
                ['gender'] = gender,
                ['hair'] = hair,
                ['eye'] = eye,
                ['classes'] = classes,
                ['permits'] = permits,
                ['mugshot'] = mugshot,
            }
            TriggerClientEvent("player:receiveItem", player['source'], 'idcard', 1, true, itemInfo)
        end
    end)
end)

-- New server-side saving things

local Cfg = {
    tool_shops = {
        { coords = vec3(44.838, -1748.536, 29.549), type = "4" },
        { coords = vector3(814.46, -93.32, 80.59), type = "8" },
        { coords = vector3(-741.28, -1127.43, 10.59), type = "9" },
        { coords = vector3(-11.34, 6499.65, 31.49), type = "16" },
        { coords = vector3(343.03, -1298.81, 32.5), type = "17" },
        { coords = vector3(-3153.57, 1054.35, 20.84), type = "4" },
    },
    electronic_shops = {
        { coords = vector3(393.15, -832.19, 29.28), type = "20" },
        { coords = vector3(1138.05, -470.98, 66.65), type = "20" },
        { coords = vector3(-509.33, 278.47, 83.3), type = "20" },
        { coords = vector3(1124.35, -345.76, 67.09), type = "20" },
        { coords = vector3(-1342.89, -344.37, 36.64), type = "20" },
    },
    mechanic_parts_shops = {
        { coords = vector3(810.4, -750.24, 26.74), type = "23" },
        { coords = vector3(2506.79, 4097.14, 38.7), type = "24" },
        { coords = vector3(-1377.43, -361.27, 36.61), type = "25" },
        { coords = vector3(1130.24, -776.87, 57.6), type = "26" },
        { coords = vector3(-1268.56, -1155.43, 6.79), type = "27" },
    },
    police_armory = {
        vector3(482.52, -995.45, 30.68),
        vector3(1840.94, 3691.38, 35.20),
        vector3(1841.3, 2574.04, 46.01),
        vector3(1846.62, 3680.29, 34.27),
        vector3(386.1357, 799.5472, 187.6776)
    },
    twentyfourseven_shops = {
        {coords = vec3(1961.55, 3740.93, 32.33), blip = true},
        {coords = vec3(1393.5, 3604.97, 34.98), blip = true},
        {coords = vec3(547.48, 2671.25, 42.15), blip = true},
        {coords = vec3(2557.23, 382.4, 108.61), blip = true},
        {coords = vec3(-1820.65, 792.32, 138.11), blip = true},
        {coords = vec3(-1222.93, -906.95, 12.31), blip = true},
        {coords = vec3(-707.72, -914.62, 19.2), blip = true},
        {coords = vec3(26.07, -1347.42, 29.48), blip = true},
        {coords = vec3(-48.61, -1757.74, 29.41), blip = true},
        {coords = vec3(1163.21, -323.96, 69.2), blip = true},
        {coords = vec3(374.06, 326.04, 103.55), blip = true},
        {coords = vec3(374.72, 328.22, 103.55), blip = false},
        {coords = vec3(2676.66, 3281.76, 55.23), blip = true},
        {coords = vec3(2678.69, 3280.6, 55.23), blip = false},
        {coords = vec3(1698.09, 4924.92, 42.05), blip = true},
        {coords = vector3(1842.91, 2570.06, 45.88), blip = false},
        {coords = vec3(1135.808, -982.281, 46.45), blip = true},
        {coords = vec3(-1487.553, -379.107, 40.163), blip = true},
        {coords = vec3(-2968.243, 390.910, 14.043), blip = true},
        {coords = vec3(1166.024, 2708.930, 37.157), blip = true},
        {coords = vec3(-3038.939, 585.954, 7.95), blip = true},
        {coords = vec3(-3241.927, 1001.462, 12.95), blip = true},
        {coords = vector3(1729.37, 6414.25, 35.03), blip = true},
        {coords = vec3(309.03, -585.55, 43.01), blip = false},
        {coords = vector3(448.71, -974.16, 34.96), blip = false},
        {coords = vector3(462.69, -982.25, 30.68), blip = false},
        {coords = vector3(-601.91, -914.18, 28.84), blip = false}
    },
    weashop_locations = {
        vec3(810.2, -2157.38, 29.62),
        vec3(1693.53, 3759.71, 34.69),
        vec3(252.07, -49.86, 69.94),
        vec3(842.41, -1033.28, 28.18),
        vec3(-330.29, 6083.58, 31.45),
        vec3(-662.37, -935.5, 21.82),
        vec3(-1305.92, -394.09, 36.69),
        vec3(-1117.7, 2698.26, 18.55),
        vec3(2567.76, 294.42, 108.73),
        vec3(-3171.73, 1087.71, 20.84),
        vec3(21.76, -1107.32, 29.79) -- Adam's Apple Location
    },
    SecretStashes = {
        { coords = vector3(963.45, -979.02, 39.49), type = 726, job = 'jt3nv7', code = '0726'},
    },
    JobShops = {
        -- Mechanic Shops
        { coords = vector3(-227.51, -1327.42, 30.89), job = 'bennys', type = '55', shopType = "Craft", message = "[E] Craft" },
        { coords = vector3(998.68, -124.25, 74.06), job = 'lostmc', type = '55', shopType = "Craft", message = "[E] Craft" },
        { coords = vector3(964.71, -104.35, 73.00), job = 'lostmc', type = '55', shopType = "Craft", message = "[E] Craft" },
        { coords = vector3(-1421.54, -455.17, 35.9), job = 'flywheels', type = '55', shopType = "Craft", message = "[E] Craft" },
        { coords = vector3(939.03, -984.46, 39.49), job = 'jt3nv7', type = '55', shopType = "Craft", message = "[E] Craft" },
        { coords = vector3(-1418.85, -454.21, 35.9), job = 'flywheels', type = 'harness', shopType = "Shop" },
        { coords = vector3(1816.067, 3678.653, 34.27641), job = 'all', type = 'coldmedicine', shopType = "Shop" },
        -- Crafting
        { coords = vector3(1393.464, 3606.927, 38.94194), job = 'all', type = 'UnstableMeth', shopType = "Craft", emote = "mechanic3", message = "[E] Craft" },
        { coords = vector3(1389.298, 3604.906, 38.94188), job = 'all', type = 'rawmethpile', shopType = "Craft", emote = "mechanic", message = "[E] Craft" },
        -- { coords = vector3(1790.087, 4602.886, 37.68284), job = 'all', type = 'LaptopCrafting', shopType = "Craft", emote = "mechanic3", message = "[E] Craft" },
        { coords = vector3(448.8169, -2761.347, 7.100912), job = 'all', type = 'FakePlateCrafting', shopType = "Craft", emote = "mechanic3", message = "[E] Craft" },
        { coords = vector3(-226.3411, -1340.536, 30.88943), job = 'bennys', type = 'drift-bennys', shopType = "Craft", message = "[E] Craft" },
    },
    Stashes = {
        { name = 'jtenvy', coords = vector3(952.19, -955.41, 39.49), job = 'jt3nv7', grade = 0},
        { name = 'jtenvy2', coords = vector3(953.08, -976.53, 39.49), job = 'jt3nv7', grade = 0},
        { name = 'lostmc', coords = vec3(986.10, -133.66, 78.89), job = 'lostmc', grade = 0},
        { name = 'lostmcs', coords = vec3(977.02, -103.97, 74.85), job = 'lostmc', grade = 5},
        { name = 'lostmcm', coords = vector3(996.37, -122.49, 74.05), job = 'lostmc', grade = 0},
        { name = 'tacoshop', coords = vec3(16.83, -1599.88, 29.30), job = 'taco', grade = 0},
        { name = 'realestate', coords = vec3(-127.91, -633.64, 168.81), job = 'realestate', grade = 0},
        { name = 'fmb', coords = vec3(-433.47, 271.45, 83.42), job = 'fmb', grade = 0},
        { name = 'flywheels', coords = vector3(-1428.84, -458.37, 35.9), job = 'flywheels', grade = 0},
        { name = 'weazelnews', coords = vector3(-572.57, -939.13, 28.81), job = 'weazelnews', grade = 0},
        { name = 'storage-doj', coords = vector3(241.25, -1100.43, 36.12), job = 'doj', grade = 0},
        { name = 'storage-flywheels', coords = vector3(-1408.65, -447.28, 35.9), job = 'flywheels', grade = 0},
        { name = 'storage-bennys', coords = vector3(-224.21, -1320.24, 30.89), job = 'bennys', grade = 0},
        { name = 'storage-jimsburger', coords = vector3(135.28, -1062.79, 22.94), job = 'jimsburger', grade = 0},
        { name = 'morgue', coords = vector3(262.54, -1378.58, 39.52), job = 'cdmortuary', grade = 1},
        { name = 'pdm', coords = vector3(-811.1046, -206.0868, 37.253), job = 'pdm', grade = 1},
        { name = 'storage-flywheels2', coords = vector3(-1414.48, -451.09, 35.9), job = 'flywheels', grade = 0},
        { name = 'storage-legacy1', coords = vector3(-1397.55, -628.76, 30.31), job = 'legacyrecords', grade = 0},
        { name = 'storage-legacy2', coords = vector3(204.29, -5.62, 69.89), job = 'legacyrecords', grade = 0},
        { name = 'storage-casino1', coords = vector3(1114.88, 244.0, -45.85), job = 'casino', grade = 3 },
        { name = 'storage-casino2', coords = vector3(1120.33, 218.0, -49.44), job = 'casino', grade = 0 },
        { name = 'storage-thc', coords = vector3(376.85, -823.79, 29.3), job = 'thc', grade = 0 },
        { name = 'storage-soochi', coords = vector3(-1844.15, -1190.07, 14.3), job = 'soochi', grade = 0 },
        { name = 'storage-chichis', coords = vector3(5.393123, -1109.383, 29.791), job = 'gatsnstraps', grade = 0},
        { name = 'storage-sidewaysu', coords = vector3(-64.06, -2517.89, 7.41), job = 'sidewaysu', grade = 0},
        { name = 'storage-driftschool', coords = vector3(906.87, -2363.43, 21.19), job = 'driftschool', grade = 0},

    },
    ShopCounters = {
        { coords = vector3(335.85, -915.94, 29.25), name = 'levelup' }, -- Level Up Counter
        { coords = vector3(195.57, -15.4, 69.89), name = 'legacylounge'}, -- Legacy Lounge
        { coords = vector3(125.2, -1034.56, 29.26), name = 'jimsburgers-up'}, -- Jims (Upstairs)
        { coords = vector3(135.32, -1055.74, 22.94), name = 'jimsburgers-down'}, -- Jims (Downstairs)
        { coords = vector3(-1835.72, -1186.06, 14.3), name = 'Soochi'}, -- Soochi downstairs
        { coords = vector3(-1387.69, -613.75, 30.31), name = 'bahama-back'}, -- Bahama near dance floor
        { coords = vector3(-1392.2, -607.03, 30.31), name = 'bahama-front'}, -- Bahama front area
        { coords = vector3(20.37, -1105.31, 29.79), name = 'chichi'}, -- ChiChi's front desk
        { coords = vector3(10.67, -1605.18, 29.38), name = 'tacos'}, -- Taco Counter
        { coords = vector3(379.04, -827.42, 29.3), name = 'thorhalls'}, -- Thorhall's
    },
    CustomBlips = {
        { title = 'Department of Justice', sprite = 351, colour = 17, coords = vector3(241.25, -1100.43, 36.12), group = "Business"},
        { title = 'Carbon N\' Chrome', sprite = 72, colour = 33, coords = vector3(-1417.71, -446.15, 35.9), group = "Mechanic Shop"},
        { title = 'Hobo Jim\'s Burger Shack', sprite = 536, colour = 6, coords = vector3(135.28, -1062.79, 22.94), group = "Food Shop"},
        { title = 'Dynasty 8', sprite = 375, colour = 35, coords = vector3(-139.80, -626.95, 168.82), group = "Business"},
        { title = 'Auto Exotic', sprite = 442, colour = 3, coords = vector3(533.42, -183.49, 54.18), group = "Mechanic Shop"},
        { title = 'Cloudy Days Mortuary', sprite = 305, colour = 0, coords = vector3(240.75, -1379.5, 33.73), group = "Business"},
        { title = 'Hospital', sprite = 61, colour = 0, coords = vector3(1838.74, 3673.64, 34.27), group = "Emergency"},
        { title = 'Hospital', sprite = 61, colour = 0, coords = vector3(-448.17, -340.88, 34.49), group = "Emergency"},
        { title = 'Bennys Motorworks', sprite = 72, colour = 35, coords = vector3(-210.61, -1327.73, 30.88), group = "Mechanic Shop"},
        { title = 'Impound Lot', sprite = 68, colour = 1, coords = vector3(402.36, -1631.82, 29.28), group = ""},
        { title = 'Vangelico', sprite = 618, colour = 46, coords = vec3(-622.070, -230.740, 38.060), group = "Business"}, 
        { title = 'DMV School', sprite = 225, colour = 0, coords = vector3(236.70, -408.74, 47.92), group = ""},
        { title = 'Thorhall\'s Holistic Center', sprite = 140, colour = 2, coords = vector3(377.748, -828.7451, 29.3025), group = "Business"},
        { title = "Pegasus Airlines", sprite = 90, colour = 0, coords = vector3(-1662.74, -3160.09, 14.0), group = "Business" },
        { title = "SooChi Restaurant", sprite = 120, colour = 51, coords = vector3(-1830.4, -1190.84, 28.81), group = "Food Shop" },
    },
    secretguns = vector3(-1834.875, 3215.257, 36.84926),
    baggedpuremeth = vector3(1389.972, 3608.589, 38.94188),
    refinedmeth = vector3(1394.495, 3601.855, 38.94194),
    thermalcharge = vector3(1775.116, 2487.518, 55.14363)
}

CreateThread(function()
    Wait(1000)
    TriggerClientEvent('drp-shops:sendConfig', -1, Cfg)
end)

RegisterNetEvent('playerJoining')
AddEventHandler('playerJoining', function()
    TriggerClientEvent('drp-shops:sendConfig', source, Cfg)
end)