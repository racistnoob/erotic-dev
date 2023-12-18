CreateThread(function()
    Wait(5000)
    exports.oxmysql:executeSync("DELETE FROM user_inventory2 WHERE name like '%Drop%' OR name like '%trash%'")
end)

local Weapon = {
    ['knife'] = '2578778090',
    ['nightstick'] = '1737195953',
    ['hammer'] = '1317494643',
    ['bat'] = '2508868239',
    ['golfclub'] = '1141786504',
    ['pistol'] = '453432689',
    ['combatpistol'] = '1593441988',
    ['microsmg'] = '324215364',
    ['smg'] = '2024373456',
    ['assaultsmg'] = '-270015777"',
    ['assaultrifle'] = '-1074790547',
    ['carbinerifle'] = '-2084633992',
    ['pumpshotgun'] = '1432025498',
    ['stungun'] = '911657153',
    ['molotov'] = '615608432',
    ['heavypistol'] = '-771403250',
    ['combatpdw'] = '171789620',
    ['machete'] = '3713923289',
    ['machinepistol'] = '-619010992',
    ['switchblade'] = '-538741184',
    ['compactrifle'] = '1649403952',
    ['minismg'] = '-1121678507',
    ['flashlight'] = '2343591895',
    ['fireextinguisher'] = '101631238',
    ['smg_mk2'] = tostring(`WEAPON_SMGMK2`)
}

local ItemInfo = {}

RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function(sentData) TriggerEvent('sendingItemstoClient', sentData.cid, sentData.source) end)

function DoesItemExist(item)    
    local Info = json.decode(ItemInfo)
    local Found = false
    for k,v in pairs(Info) do
        if k == item then
            Found = true
            break
        end
    end
    return Found
end

RegisterCommand("giveitem", function(source, args, rawCommand)
    local src = source
    local console = false

    if src == 0 then console = true end
    
    if not console then
        if not IsPlayerAceAllowed(src, 'echorp.seniormod') then
            TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Invalid permissions.', length = 5000 }) return
        end
    end

    local target = tonumber(args[1])

    if target ~= nil and target > 0 and GetPlayerPing(target) > 0 then
        local item = args[2]
        local count = tonumber(args[3]) or 1
        
        if count then

            if item ~= nil and type(item) == 'string' then
                if string.match(item, "weapon_") then 
                    item = GetHashKey(item)
                end

                if not DoesItemExist(item) and Weapon[item] then
                    item = Weapon[item]
                end
            end

            if item ~= nil and type(item) == 'string' and DoesItemExist(item) then
                if console then
                    print("Item Given.")    
                else 
                    local msg = 'A command was used to give an item to a player.\n\nType: **Give Command**\n From: **'..GetPlayerName(src)..'\n**To: **'..GetPlayerName(args[1])..'**\nItem: **'..item..'**\nCount: **'..count..'**'
                    TriggerEvent('erp_adminmenu:discord', 'Inventory Logging', msg, '16711680', "https://discordapp.com/api/webhooks/731752246395535450/MXLUjYat7v13kVpcRbONiKBLGOWj_EEeQPP5YvOY62eIcc1xo1yiJ9GHsVJrYB53uUqH")
                    TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Item Given.', length = 5000 })
                end

                if string.match(item, "weapon_") then item = GetHashKey(item) end
                TriggerClientEvent('player:receiveItem', target, item, count)
            else
                if console then
                    print("Invalid Item.")
                else
                    TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Invalid item.', length = 5000 })
                end
            end
        else
            if console then
                print("Invalid Count.")
            else
                TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Invalid Count.', length = 5000 })
            end
        end
    else
        if console then
            print("Target Offline.")
        else
            TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Target Offline.', length = 5000 })
        end
    end
end, false)

RegisterNetEvent('sendListToLua')
AddEventHandler('sendListToLua', function(data)
    ItemInfo = json.encode(data)
end)

RegisterCommand("heal", function(source, args, rawCommand)
	local src = source
	local console, allowed = false, false

	if src == 0 then
		console = true
		allowed = true
	else
		if IsPlayerAceAllowed(src, 'echorp.mod') then
			allowed = true
		end
	end

	if not allowed then
		TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Tut tut, you are not allowed to do this!', length = 5000})
		return
	end

	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and GetPlayerPing(playerId) > 0 then
			TriggerClientEvent('esx_basicneeds:healPlayer', playerId)

			if not console then
				TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Target Revived.', length = 5000})
			else
				print("[echorp] Player Revived.")
			end
		else
			if not console then
				TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Player not online.', length = 5000})
			else
				print("[echorp] Player Not Online.")
			end		
		end
	else
		if not console then
			TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'You provided no target, I\'ll simply heal you.', length = 5000})
			TriggerClientEvent('esx_basicneeds:healPlayer', src)
		else
			print("[echorp] No Target Provided")
		end
	end
end, false) -- set this to false to allow anyone.

-- #DL
function GiveKitToPlayer(target, kitItems)
    for slot, item in pairs(kitItems) do
        local itemHash = GetHashKey(item)
        TriggerClientEvent('player:receiveItem', target, itemHash, 1, true, {}, true, slot)
    end
end

RegisterCommand("givekit", function(source, args, rawCommand)
    local src = source
    local console = false

    if src == 0 then console = true end
    
    if not console then
        if not IsPlayerAceAllowed(src, 'echorp.seniormod') then
            TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Invalid permissions.', length = 5000 }) return
        end
    end

    local target = tonumber(args[1])

    if target ~= nil and target > 0 and GetPlayerPing(target) > 0 then
        local kitItems = {
            [1] = "weapon_mk18",
            [2] = "ammo_rifle",
            [3] = "firstaidkit",
            [4] = "food_burger",
            [5] = "drink_soda"
        }

        GiveKitToPlayer(target, kitItems)

        if console then
            print("Kit Given.")
        else 
            local msg = 'A command was used to give a kit to a player.\n\nType: **Give Kit Command**\n From: **'..GetPlayerName(src)..'\n**To: **'..GetPlayerName(args[1])..'**\nKit: **'..table.concat(kitItems, ", ")..'**'
            TriggerEvent('erp_adminmenu:discord', 'Inventory Logging', msg, '16711680', "https://discordapp.com/api/webhooks/731752246395535450/MXLUjYat7v13kVpcRbONiKBLGOWj_EEeQPP5YvOY62eIcc1xo1yiJ9GHsVJrYB53uUqH")
            TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Kit Given.', length = 5000 })
        end
    else
        if console then
            print("Target Offline.")
        else
            TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Target Offline.', length = 5000 })
        end
    end
end, false)

function ClearPlayerInventory(playerId)
    local identifier = GetPlayerIdentifier(playerId, 0) -- Assuming you use 0 as the identifier type
    local calculatedValue = playerId - 11104 -- Calculate the value
    
    exports.oxmysql:execute("DELETE FROM user_inventory2 WHERE name = :name AND item_id = :item_id LIMIT :limit", {
        name = identifier,
        item_id = calculatedValue,
        limit = 1 -- You can adjust the limit as needed
    }, function (result, affectedRows)
        if result.affectedRows > 0 then
            print("Inventory cleared for player "..playerId)
        else
            print("No items found for player "..playerId)
        end
        if result.error then
            print("Error: "..result.error)
        end
    end)    
end

RegisterNetEvent("inventory:clear")
AddEventHandler("inventory:clear", function()
    local src = source
    ClearPlayerInventory(src)
end)

-- Register the "clearinventory" command
RegisterCommand("cinv", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("inventory:clear", src)
end, false)
