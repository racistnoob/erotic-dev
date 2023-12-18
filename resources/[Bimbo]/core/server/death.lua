local DeadPlayers = {}

AddEventHandler('echorp:playerDropped', function(playerInfo)
    if playerInfo then
        if DeadPlayers[playerInfo.cid] then
			local message = "Player: **"..GetPlayerName(playerInfo.source).."** (**"..playerInfo.source.."**)\nCharacter: **"..playerInfo['firstname']..' '..playerInfo['lastname']..' ['..playerInfo['cid']..']'.."**\nIdentifier: **"..playerInfo['identifier'].."**"
			DeadPlayers[playerInfo.cid] = nil
		end 
    end
end)

RegisterNetEvent('echorp:adjustDead')
AddEventHandler('echorp:adjustDead', function(isDead)
	local source = source
	local cid = exports['drp']:GetOnePlayerInfo(source, 'cid')
	if cid then
		if isDead then
			DeadPlayers[cid] = true
		elseif not isDead then
			DeadPlayers[cid] = nil
		end
		TriggerClientEvent('echorp:adjustDead', source, DeadPlayers[cid])
	end
end)