local players = {}
local playersCid = {}

local function getIdentifier(plyId)
	if players[plyId] then return players[plyId]['identifier'] end;
	local numIdentifiers = GetNumPlayerIdentifiers(plyId)	
	for i=0, numIdentifiers -1 do
		local currIdentifier = GetPlayerIdentifier(plyId, i)
		if string.find(currIdentifier, "steam:") then
			return currIdentifier
		end
	end
	return nil
end

AddEventHandler('echorp:getplayerfromid', function(playerId, cb)
	cb(players[tonumber(playerId)])
end)

AddEventHandler('echorp:getplayerfromcid', function(cid, cb)
	cb(players[playersCid[tonumber(cid)]])
end)

local function GetPlayerFromId(playerId) -- exports['drp']:GetPlayerFromId(playerId)
	local plyId = tonumber(playerId)
	return players[plyId]
end

local function GetOnePlayerInfo(playerId, infoWanted) -- exports['drp']:GetOnePlayerInfo(playerId, 'cid')
	local playerData = players[playerId]
	if playerData then 
		return playerData[infoWanted] 
	end 
	return nil
end

local function GetPlayerFromCid(cid) -- exports['drp']:GetPlayerFromCid(cid)
	local cid = tonumber(cid)
	local plyFromCid = playersCid[cid]
	if plyFromCid then
		return players[plyFromCid]
	end
	return nil
end

local function GetPlayerFromPhone(phonenumber) -- exports['drp']:GetPlayerFromPhone(phonenumber)
	local sentNumber = tostring(phonenumber)
	for k,v in pairs(players) do
		if v.phone_number == sentNumber then
			return v
		end
	end
	return nil
end

local function DoesCidExist(cid) -- exports['drp']:DoesCidExist(cid)
	local cid = tonumber(cid)
	local p = promise.new()
	exports.oxmysql:fetch("SELECT 1 FROM users WHERE `id`=:id LIMIT 1", {id = cid}, function(data) p:resolve(data ~= nil) end)
	return Citizen.Await(p)
end

local function SetPlayerData(source, toChange, targetData)
	players[tonumber(source)][toChange] = targetData
	TriggerClientEvent('echorp:updateinfo', source, toChange, targetData)
end

local function GetFXPlayers() return players end -- exports['drp']:GetFXPlayers()

exports("GetPlayerFromId", GetPlayerFromId)
exports("GetOnePlayerInfo", GetOnePlayerInfo)
exports("GetPlayerFromCid", GetPlayerFromCid)
exports("GetFXPlayers", GetFXPlayers)
exports('identifier', getIdentifier)
exports('getIdentifier', getIdentifier)
exports('SetPlayerData', SetPlayerData)
exports('DoesCidExist', DoesCidExist)
exports('GetPlayerFromPhone', GetPlayerFromPhone)

local function steamIdentifier(plyId)
	local numIdentifiers = GetNumPlayerIdentifiers(plyId)	
	for i=0, numIdentifiers -1 do
		local currIdentifier = GetPlayerIdentifier(plyId, i)
		if currIdentifier then
			if string.find(currIdentifier, "steam:") then
				return currIdentifier
			end
		end
	end
	return nil
end

RegisterNetEvent('echorp:fetchcharacters')
AddEventHandler('echorp:fetchcharacters', function()
	local source = source
	local characters = {}
	local identifier = getIdentifier(source)
	if identifier == nil then DropPlayer(source, 'Make sure Steam is on') end

	local steamIdent = steamIdentifier(source)
	if steamIdent then
		exports.oxmysql:executeSync("UPDATE users SET identifier=:fivemidentifier WHERE identifier=:steamidentifier", { fivemidentifier = identifier, steamidentifier = steamIdent })
	end
	
	local knownCharacters = exports.oxmysql:fetchSync("SELECT id, firstname, lastname, dateofbirth, gender FROM users WHERE identifier=:identifier AND deleted='0'", { identifier = identifier })
	for i=1, #knownCharacters do
		local info = knownCharacters[i]
		local cid = knownCharacters[i]['id']
		local character = { info = info, cPed = {} }
		local Skin = exports.oxmysql:fetchSync("SELECT model, drawables, props, drawtextures, proptextures FROM character_current WHERE cid = :cid LIMIT 1", { cid = cid })
		if Skin and Skin[1] then
			character['cPed'] = {
				model = Skin[1].model,
				drawables = json.decode(Skin[1].drawables),
				props = json.decode(Skin[1].props),
				drawtextures = json.decode(Skin[1].drawtextures),
				proptextures = json.decode(Skin[1].proptextures),
				tattoos = {}
			}
		end

		local Face = exports.oxmysql:fetchSync("SELECT hairColor, headBlend, headOverlay, headStructure FROM character_face WHERE cid = :cid LIMIT 1", {cid = cid})
		if Face and Face[1] then
			character['cPed']['hairColor'] = json.decode(Face[1].hairColor)
			character['cPed']['headBlend'] = json.decode(Face[1].headBlend)
			character['cPed']['headOverlay'] = json.decode(Face[1].headOverlay)
			character['cPed']['headStructure'] = json.decode(Face[1].headStructure)
		end

		local Tats = exports.oxmysql:fetchSync("SELECT tattoos FROM playersTattoos WHERE cid = :cid LIMIT 1", {cid = cid})
		if Tats and Tats[1] and Tats[1]['tattoos'] then
			character['cPed']['tattoos'] = json.decode(Tats[1].tattoos)
		end

		characters[i] = character
	end

	TriggerClientEvent('fetchCharacters', source, characters)
end)

RegisterNetEvent('echorp:deleteCharacter')
AddEventHandler('echorp:deleteCharacter', function(cid)
	local source = source
	exports.oxmysql:fetch("SELECT `identifier` FROM `users` WHERE id=:id LIMIT 1", {
		id = cid,
	}, function(data)
		if data and data[1] then
			local identifier = getIdentifier(source)
			if data[1]['identifier'] == identifier then
				exports.oxmysql:executeSync("UPDATE `users` SET `deleted`='1' WHERE id=:id", { id = cid })
			end
		end
	end)
end)

RegisterNetEvent('echorp:selectCharacter')
AddEventHandler('echorp:selectCharacter', function(cid) 
  local playerId, cid = tonumber(source), tonumber(cid)
	local identifier = getIdentifier(playerId)
	if identifier then
		exports.oxmysql:fetch('SELECT `firstname`, `lastname`, `gender` FROM `users` WHERE `id`=:id LIMIT 1', { id = cid }, function(charInfo)
			if charInfo then
				local dbInfo = charInfo[1]
				local PlayerInfo = {
					source = playerId,
					identifier = identifier,
					cid = cid,
					id = cid,
					firstname = dbInfo['firstname'],
					lastname = dbInfo['lastname'],
					fullname = dbInfo['firstname']..' '..dbInfo['lastname'],
					gender = dbInfo['gender'],
				}
				players[playerId] = PlayerInfo
				playersCid[cid] = playerId

				TriggerClientEvent('echorp:spawnPlayer', playerId, PlayerInfo, GetResourceKvpString(cid.."-coords"), GetResourceKvpInt(cid.."-armour"), GetResourceKvpInt(cid.."-stress"), thirst, hunger)
			end
		end)
	end
end)

RegisterNetEvent('echorp:createCharacter')
AddEventHandler('echorp:createCharacter', function(charInfo) 
	local playerId = source
	local identifier = getIdentifier(playerId)
	if identifier then
		exports.oxmysql:insertSync("INSERT INTO `users` (`identifier`, `firstname`, `lastname`, `dateofbirth`, `gender`) VALUES (:identifier, :firstname, :lastname, :dateofbirth, :gender)", {
			identifier = identifier,
			firstname = charInfo.firstname,
			lastname = charInfo.lastname,
			dateofbirth = charInfo.dob,
			gender = charInfo.gender
		})
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	local playerData = players[source]
	if playerData then 
		TriggerEvent('echorp:playerDropped', playerData) 
		players[source] = nil
		playersCid[playerData.cid] = nil
	end
end)