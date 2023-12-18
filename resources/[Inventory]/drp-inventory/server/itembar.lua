local charset = {}  do -- [0-9a-zA-Z]
	for c = 48, 57  do table.insert(charset, string.char(c)) end
	for c = 65, 90  do table.insert(charset, string.char(c)) end
	for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local function randomString(length)
	if not length or length <= 0 then return '' end
	math.randomseed(os.clock()^5)
	return randomString(length - 1) .. charset[math.random(1, #charset)]
end

RegisterNetEvent('drp-weapons:setAmmo')
AddEventHandler('drp-weapons:setAmmo', function(id, info, hash, sentCid)
	local src = source
	local cid = exports['drp']:GetOnePlayerInfo(src, 'cid')
	local newInfo = {
		serial = cid,
		quality = "Good",
		ammo = "0",
		cartridge = cid..'-'..randomString(3)..'-'..math.random(100, 999)
	}

	if info.information then
		local decodedInformation = json.decode(info.information)
		if decodedInformation['serial'] then newInfo['serial'] = decodedInformation['serial'] end
		if decodedInformation['quality'] then newInfo['quality'] = decodedInformation['quality'] end
		if decodedInformation['cartridge'] then newInfo['cartridge'] = decodedInformation['cartridge'] end
		if decodedInformation['ammo'] then newInfo['ammo'] = decodedInformation['ammo'] end
	end

	exports.oxmysql:execute("UPDATE user_inventory2 SET information=:information WHERE id=:id", { information = json.encode(newInfo), id = id }, function(result)
		if result then
			TriggerClientEvent('drp-weapons:setAmmo', src, info, hash)
			TriggerEvent('server-request-update-src', 'ply-'..''..sentCid, src)
		end
	end)
end)

RegisterNetEvent('drp-weapons:fixInfo')
AddEventHandler('drp-weapons:fixInfo', function(id, data)
	local src = source
	local serial = exports['drp']:GetOnePlayerInfo(src, 'cid')
	local quality = "Good"
	local cartridge = serial..'-'..randomString(3)..'-'..math.random(100, 999)
	local ammo = "0"

	if json.encode(data) ~= "[]" then
		if data.serial then serial = data.serial end
		if data.cartridge then cartridge = data.cartridge end
		if data.ammo then ammo = data.ammo end
	end

	local info = json.encode({
		serial = serial,
		quality = quality,
		cartridge = cartridge,
		ammo = ammo
	})

	exports.oxmysql:execute("UPDATE user_inventory2 SET information=:information WHERE id=:id", { information = info, id = id })
end)