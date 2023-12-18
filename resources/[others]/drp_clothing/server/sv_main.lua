local function checkExistenceClothes(cid, cb) exports.oxmysql:fetch('SELECT 1 FROM character_current WHERE cid = :cid LIMIT 1', { cid = cid }, function(result) if result and result[1] then cb(true) else cb(false) end end) end
local function checkExistenceFace(cid, cb) exports.oxmysql:fetch('SELECT 1 FROM character_face WHERE cid = :cid LIMIT 1', { cid = cid }, function(result) if result and result[1] then cb(true) else cb(false) end end) end

RegisterNetEvent("drp_clothing:insert_character_current")
AddEventHandler("drp_clothing:insert_character_current",function(data)
	if not data then return end
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end
	checkExistenceClothes(cid, function(exists)
			if not exists then
					exports.oxmysql:executeSync("INSERT INTO character_current (cid, model, drawables, props, drawtextures, proptextures) VALUES (:cid, :model, :drawables, :props, :drawtextures, :proptextures)", {
						cid = cid,
						model = json.encode(data.model),
						drawables = json.encode(data.drawables),
						props = json.encode(data.props),
						drawtextures = json.encode(data.drawtextures),
						proptextures = json.encode(data.proptextures),
					})
					return
			end
			exports.oxmysql:executeSync("UPDATE character_current SET model = :model, drawables = :drawables, props = :props, drawtextures = :drawtextures, proptextures = :proptextures WHERE cid = :cid", {
				cid = cid,
				model = json.encode(data.model),
				drawables = json.encode(data.drawables),
				props = json.encode(data.props),
				drawtextures = json.encode(data.drawtextures),
				proptextures = json.encode(data.proptextures),
			})
	end)
end)

RegisterNetEvent("drp_clothing:insert_character_face")
AddEventHandler("drp_clothing:insert_character_face",function(data)
	if not data then return end
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')

	if not cid then return end

	checkExistenceFace(cid, function(exists)
			if data.headBlend == "null" or data.headBlend == nil then
					data.headBlend = '[]'
			else
					data.headBlend = json.encode(data.headBlend)
			end
			if not exists then
					exports.oxmysql:executeSync("INSERT INTO character_face (cid, hairColor, headBlend, headOverlay, headStructure) VALUES (:cid, :hairColor, :headBlend, :headOverlay, :headStructure)", {
						cid = cid,
						hairColor = json.encode(data.hairColor),
						headBlend = data.headBlend,
						headOverlay = json.encode(data.headOverlay),
						headStructure = json.encode(data.headStructure),
				})
					return
			end

			exports.oxmysql:executeSync("UPDATE character_face SET hairColor = :hairColor,headBlend = :headBlend, headOverlay = :headOverlay,headStructure = :headStructure WHERE cid = :cid", {
				cid = cid,
				hairColor = json.encode(data.hairColor),
				headBlend = data.headBlend,
				headOverlay = json.encode(data.headOverlay),
				headStructure = json.encode(data.headStructure),
		})
	end)
end)

RegisterNetEvent("drp_clothing:fromclient:get_character_face")
AddEventHandler("drp_clothing:fromclient:get_character_face",function(model)
	local source = source
	local cid = exports['drp']:GetOnePlayerInfo(source, 'cid')
	exports.oxmysql:fetch("SELECT hairColor, headBlend, headOverlay, headStructure FROM character_face WHERE cid = :cid LIMIT 1", { cid = cid}, function(data)
			if data[1] ~= nil then
					local temp_data = { hairColor = json.decode(data[1].hairColor), headBlend = json.decode(data[1].headBlend), headOverlay = json.decode(data[1].headOverlay), headStructure = json.decode(data[1].headStructure), }
					if model == 1885233650 or model == -1667301416 then TriggerClientEvent("drp_clothing:setpedfeatures", source, temp_data) end
			else
					TriggerClientEvent("drp_clothing:setpedfeatures", source, false)
			end
	end)
end)

RegisterNetEvent("drp_clothing:get_character_face")
AddEventHandler("drp_clothing:get_character_face",function(pSrc, cid)
	local src = (not pSrc and source or pSrc)
	if cid == nil then cid = exports['drp']:GetOnePlayerInfo(src, 'cid') end
	exports.oxmysql:fetch("SELECT hairColor, headBlend, headOverlay, headStructure FROM character_face WHERE cid = :cid LIMIT 1", { cid = cid}, function(data)
			if data[1] ~= nil then
					local temp_data = {
							hairColor = json.decode(data[1].hairColor),
							headBlend = json.decode(data[1].headBlend),
							headOverlay = json.decode(data[1].headOverlay),
							headStructure = json.decode(data[1].headStructure),
					}

					exports.oxmysql:fetch("SELECT model FROM character_current WHERE cid = :cid LIMIT 1", { cid = cid}, function(data)
							local model = tonumber(data[1].model)
							if model == 1885233650 or model == -1667301416 then
									TriggerClientEvent("drp_clothing:setpedfeatures", src, temp_data)
							end
					end)
			else
					TriggerClientEvent("drp_clothing:setpedfeatures", src, false)
			end
	end)
end)

RegisterNetEvent("drp_clothing:get_character_current")
AddEventHandler("drp_clothing:get_character_current",function(pSrc, cid, firstSpawn, kvpArmour, kvpStress, kvpThirst, kvpHunger)
	local src = (not pSrc and source or pSrc)
	if cid == nil then cid = exports['drp']:GetOnePlayerInfo(src, 'cid') end
	exports.oxmysql:fetch("SELECT model, drawables, props, drawtextures, proptextures FROM character_current WHERE cid = :cid LIMIT 1", { cid = cid}, function(skin)
			if (skin ~= nil and skin[1] ~= nil) then
					local temp_data = {
							model = skin[1].model,
							drawables = json.decode(skin[1].drawables),
							props = json.decode(skin[1].props),
							drawtextures = json.decode(skin[1].drawtextures),
							proptextures = json.decode(skin[1].proptextures),
					}
					TriggerClientEvent("drp_clothing:setclothes", src, temp_data, 0, firstSpawn, kvpArmour, kvpStress, kvpThirst, kvpHunger)
			else
					TriggerClientEvent('drp_clothing:setclothes',src,{},nil, firstSpawn, kvpArmour, kvpStress, kvpThirst, kvpHunger)
			end
	end)
end)

RegisterNetEvent("drp_clothing:retrieve_tats")
AddEventHandler("drp_clothing:retrieve_tats",function(pSrc, cid)
	local src = (not pSrc and source or pSrc)
	if cid == nil then cid = exports['drp']:GetOnePlayerInfo(src, 'cid') end
	exports.oxmysql:fetch("SELECT tattoos FROM playersTattoos WHERE cid = :cid LIMIT 1", { cid = cid}, function(result)
		if #result == 0 then
			local tattooValue = "{}"
			exports.oxmysql:executeSync("INSERT INTO playersTattoos (cid, tattoos) VALUES (:cid, :tattoo)", { cid = cid, tattoo = tattooValue})
			TriggerClientEvent("drp_clothing:settattoos", src, {})
		elseif result[1]['tattoos'] ~= "null" then
			TriggerClientEvent("drp_clothing:settattoos", src, json.decode(result[1].tattoos))
		else
			TriggerClientEvent("drp_clothing:settattoos", src, {})
		end
	end)
end)

RegisterNetEvent("drp_clothing:set_tats")
AddEventHandler("drp_clothing:set_tats", function(tattoosList)
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end
	exports.oxmysql:executeSync("UPDATE playersTattoos SET tattoos = :tattoos WHERE cid = :cid", { tattoos = json.encode(tattoosList), cid = cid})
end)


RegisterNetEvent("drp_clothing:get_outfit")
AddEventHandler("drp_clothing:get_outfit",function(id)
	if not id then return end
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end

	exports.oxmysql:fetch("SELECT model, drawables, props, drawtextures, proptextures, hairColor FROM character_outfits WHERE cid = :cid and Id = :id LIMIT 1", {
			cid = cid,
			id = id
	}, function(result)
		if result and result[1] then
			if result[1].model == nil then
				TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'You can\'t use this.', length = 3000 })
				return
			end
			
			local data = {
				model = result[1].model,
				drawables = json.decode(result[1].drawables),
				props = json.decode(result[1].props),
				drawtextures = json.decode(result[1].drawtextures),
				proptextures = json.decode(result[1].proptextures),
				hairColor = json.decode(result[1].hairColor)
			}

			TriggerClientEvent("drp_clothing:setclothes", src, data,0)

			exports.oxmysql:executeSync("UPDATE character_current SET model = :model, drawables = :drawables, props = :props,drawtextures = :drawtextures,proptextures = :proptextures WHERE cid = :cid", {
				cid = cid,
				model = data.model,
				drawables = json.encode(data.drawables),
				props = json.encode(data.props),
				drawtextures = json.encode(data.drawtextures),
				proptextures = json.encode(data.proptextures),
			})
		else
			return
		end
	end)
end)

RegisterNetEvent("drp_clothing:set_outfit")
AddEventHandler("drp_clothing:set_outfit",function(id, name, data)
	if not id then return end
	local src = source

	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end

	exports.oxmysql:fetch("SELECT Id FROM character_outfits WHERE cid = :cid and Id = :Id LIMIT 1", {
		cid = cid,
		Id = id
	}, function(result)
		if result and result[1] then
			exports.oxmysql:executeSync("UPDATE character_outfits SET model = :model,name = :name,drawables = :drawables,props = :props,drawtextures = :drawtextures,proptextures = :proptextures,hairColor = :hairColor WHERE cid = :cid and Id = :id", {
				id = id,
				cid = cid,
				name = name,
				model = json.encode(data.model),
				drawables = json.encode(data.drawables),
				props = json.encode(data.props),
				drawtextures = json.encode(data.drawtextures),
				proptextures = json.encode(data.proptextures),
				hairColor = json.encode(data.hairColor)
			})
			TriggerClientEvent('erp_phone:sendNotification', src, {img = 'wardrobe.png', title = "Wardrobe", content = "Updated outfit in wardrobe", time = 2500 })
		else
			exports.oxmysql:insert("INSERT INTO character_outfits (cid, model, name, slot, drawables, props, drawtextures, proptextures, hairColor) VALUES (:cid, :model, :name, :slot, :drawables, :props, :drawtextures, :proptextures, :hairColor)", {
				cid = cid,
				slot = cid,
				name = name,
				model = data.model,
				drawables = json.encode(data.drawables),
				props = json.encode(data.props),
				drawtextures = json.encode(data.drawtextures),
				proptextures = json.encode(data.proptextures),
				hairColor = json.encode(data.hairColor)
			}, function(res)
				if res then
					TriggerClientEvent('erp_phone:newOutfit', src, res, name)
				end
			end)
			TriggerClientEvent('erp_phone:sendNotification', src, {img = 'wardrobe.png', title = "Wardrobe", content = "Added outfit to wardrobe", time = 2500 })
		end
	end)
end)

RegisterNetEvent("drp_clothing:rename_outfit")
AddEventHandler("drp_clothing:rename_outfit",function(id, name, data)
	local newName = name
	if not id then return end
	local src = source

	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end

	exports.oxmysql:fetch("SELECT Id FROM character_outfits WHERE cid = :cid and Id = :Id LIMIT 1", {
		cid = cid,
		Id = id
	}, function(result)
		if result and result[1] then
			exports.oxmysql:executeSync("UPDATE character_outfits SET name = :name WHERE cid = :cid and Id = :id",{ name = newName, id = id, cid = cid })
			TriggerClientEvent('erp_phone:sendNotification', src, {img = 'wardrobe.png', title = "Wardrobe", content = "Updated outfit name in wardrobe", time = 2500 })
		end
	end)
end)


RegisterNetEvent("drp_clothing:remove_outfit")
AddEventHandler("drp_clothing:remove_outfit",function(id)
	local src = source
	local id = tonumber(id)
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end
	exports.oxmysql:execute("DELETE FROM character_outfits WHERE cid = :cid AND Id = :id", { cid = cid,  id = id }, function(result)
			if result then
				TriggerClientEvent('erp_phone:sendNotification', src, {img = 'wardrobe.png', title = "Wardrobe", content = "Removed outfit from wardrobe", time = 2500 })
			end
	end)
end)

RegisterNetEvent("drp_clothing:callOutfits")
AddEventHandler("drp_clothing:callOutfits",function()
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	if not cid then return end
	exports.oxmysql:fetch("SELECT Id, name FROM character_outfits WHERE cid = :cid ORDER BY name ASC", { cid = cid}, function(skincheck)
		TriggerClientEvent("erp_phone:getWardrobe",src, skincheck)
	end)
end)

RegisterNetEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function(kvpArmour, kvpStress, kvpThirst, kvpHunger)
	local src = source
	TriggerEvent('echorp:getplayerfromid', src, function(player)
			if player then
					local cid = player.cid
					checkExistenceClothes(cid, function(exists)
							if exists then
									--TriggerClientEvent('drp_clothing:setclothes',src,{},nil,true)
									--TriggerEvent('drp-spawn:getHouses', src, player['jail_time'] ~= 0)
									TriggerEvent("drp_clothing:get_character_current", src, player.cid, true, kvpArmour, kvpStress, kvpThirst, kvpHunger)
							else
									TriggerClientEvent('drp_clothing:setclothes',src,{},nil,true)
							end
					end)
			end
	end)
end)

RegisterNetEvent('erp_newplayer:tutorial')
AddEventHandler('erp_newplayer:tutorial', function()
	local source = source
	--TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = '👋 You have been given a starter pack, check your F2 muscle.', length = 5000 }) Wait(1000)
	--TriggerClientEvent('player:receiveItem', source, 'applephone', 1) TriggerClientEvent('player:receiveItem', source, 'bread', 5) TriggerClientEvent('player:receiveItem', source, 'water', 5)
	TriggerClientEvent('erp_newplayer:imdone', source)
end)

RegisterNetEvent('drp_clothing:chargePlayer')
AddEventHandler('drp_clothing:chargePlayer', function(price)
	TriggerEvent('RemoveBank', source, price, false, true) 
	TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = 'You were charged $'..price..' for the items purchased.', length = 5000 })
end)