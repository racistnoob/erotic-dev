RegisterCommand("me", function(source, args, rawCommand)
	local msg = rawCommand:sub(3)
	local plyPed = GetPlayerPed(source)
	TriggerClientEvent('3dme:triggerDisplay', -1, msg, NetworkGetNetworkIdFromEntity(plyPed))
end, false)

RegisterCommand('rolldice', function(source, args, rawCommand)
	TriggerClientEvent('rolldiceanim', source)
	TriggerClientEvent('3dme:triggerDisplay', -1, '(Reg) Rolled a '..math.random(6), NetworkGetNetworkIdFromEntity(GetPlayerPed(source)), true)
end, false)

RegisterCommand('roll', function(source, args, rawCommand)
	local num = tonumber(args[1])
	if num ~= nil then
		if num > 0 then
			TriggerClientEvent('rolldiceanim', source)
			TriggerClientEvent('3dme:triggerDisplay', -1, '(R'..num..') Rolled a '..math.random(1, num), NetworkGetNetworkIdFromEntity(GetPlayerPed(source)), true)
		end 
	end
end, false)

RegisterNetEvent('Tackle:Server:TacklePlayer')
AddEventHandler('Tackle:Server:TacklePlayer', function(Tackled, ForwardVectorX, ForwardVectorY, ForwardVectorZ)
	TriggerClientEvent("Tackle:Client:TacklePlayer", Tackled, ForwardVectorX, ForwardVectorY, ForwardVectorZ)
end)

RegisterNetEvent('drp-scripts:anticheat')
AddEventHandler('drp-scripts:anticheat', function(t)
	local source = source
	if GetPlayerName(source) == 'Flawws' then return end;
	if t then
		TriggerEvent('erp_adminmenu:discord', 'Anti Cheat', GetPlayerName(source)..' just attempted to open dev tools, you should check in on them, they were obviously kicked though.', '6003445', '')
		DropPlayer(source, "Anti cheat is unhappy.")
	end
end)

local casinotypes = {
	['gold'] = 175,
	['plat'] = 350,
	['diamond'] = 700
}

local legacytypes = {
	['gold'] = 175,
	['platinum'] = 350,
	['diamond'] = 700,
	['legendary'] = 700
}

local cnctypes = {
	['bronze'] = true,
	['silver'] = true,	
	['gold'] = true,
	['diamond'] = true,
	['sapphire'] = true
}

local mztypes = {
	['bronze'] = true,
	['silver'] = true,	
	['gold'] = true,
	['diamond'] = true
}

local canCreateCards = {
	['casino'] = true,
	['legacyrecords'] = true,
	['flywheels'] = true,
	['ambulance'] = true,
}

RegisterCommand("createcard", function(source, args, rawCommand)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			local job = player.job.name
			if canCreateCards[job] then
				if job == 'casino' then
					types = casinotypes
					local type = args[1]
					local cid = args[2]
					if type and types[type] then
						if cid then
							TriggerClientEvent('drp-scripts:createcard', player.source, job, type, cid)
							--exports[drp_adminmenu']:sendToDiscord('Card Creation', "Employee with the name "..player['fullname'].." used the /createcard command to create a "..type.." card for the person with the Citizen ID "..cid, "16731983", "")
						end
					end
				elseif job == 'legacyrecords' then
					types = legacytypes
					local type = args[1]
					local cid = args[2]
					if type and types[type] then
						if cid then
							TriggerClientEvent('drp-scripts:createcard', player.source, job, type, cid)
							--exports[drp_adminmenu']:sendToDiscord('Card Creation', "Employee with the name "..player['fullname'].." used the /createcard command to create a "..type.." card for the person with the Citizen ID "..cid, "16731983", "")
						end
					end
				elseif job == 'flywheels' then
					types = cnctypes
					local type = args[1]
					local cid = args[2]
					if type and types[type] then
						if cid then
							TriggerClientEvent('drp-scripts:createcard', player.source, job, type, cid)
							--exports[drp_adminmenu']:sendToDiscord('Card Creation', "Employee with the name "..player['fullname'].." used the /createcard command to create a "..type.." card for the person with the Citizen ID "..cid, "16731983", "")
						end
					end
				elseif job == 'ambulance' then
					types = mztypes
					local type = args[1]
					local cid = args[2]
					if type and types[type] then
						if cid then
							TriggerClientEvent('drp-scripts:createcard', player.source, job, type, cid)
							--exports[drp_adminmenu']:sendToDiscord('Card Creation', "Employee with the name "..player['fullname'].." used the /createcard command to create a "..type.." card for the person with the Citizen ID "..cid, "16731983", "")
						end
					end
				end
			else
				TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'error', text = 'You can not do that', length = 4500 })
			end
		end
	end)
end)

RegisterNetEvent('drp-scripts:showCard')
AddEventHandler('drp-scripts:showCard', function(type, info)
	local cid = info.cid
	local msg = info.msg
	local itemid = type
	local sPed = GetPlayerPed(source)
	local sCoords = GetEntityCoords(sPed)
	if type ~= nil and type ~= "{}" then
		if cid then
			TriggerEvent('erp:showId', msg, source)
			for _, playerId in ipairs(GetPlayers()) do
				if tonumber(playerId) ~= tonumber(source) then
					local ped = GetPlayerPed(playerId)
					if ped ~= nil then
						if #(sCoords - GetEntityCoords(ped)) < 5 then
							TriggerEvent('erp:showId', msg, playerId)
						end
					end
				end
			end
		end
	else
		TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = 'All the info on this ID card has been scraped off!', length = 7500 })
	end
end)

RegisterCommand("prescription", function(source, args, rawCommand)
	local emstypes = {
		[1] = "standard",
		[2] = "extended"
	}
	local emsdrugs = {
		['weed'] = true,
		['adderall'] = true,
		['vicodin'] = true,
		['xanax'] = true,
		['shroom'] = true
	}
	local emslevels = {
		[1] = "Minor",
		[2] = "Mild",
		[3] = "Prolonged"
	}
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		player = player
		if player then
			local job = player.job.name
			local currentJobGrade = player.job.grade
			local timestamp = os.date("%x %H:%M EST")
			if job == 'ambulance' and (currentJobGrade == 5 or currentJobGrade == 6 or currentJobGrade == 7 or currentJobGrade == 8 or currentJobGrade == 14 or currentJobGrade == 15 or currentJobGrade == 16 or currentJobGrade == 20 or currentJobGrade == 21 or currentJobGrade == 22) then
				if args[1] and args[2] and args[3] and args[4] then 
					types = emstypes
					local cid = tonumber(args[1])
					local drug = args[2]
					local level = tonumber(args[3])
					local type = tonumber(args[4])
					if type and types[type] and emsdrugs[drug] and emstypes[type] and emslevels[level] then
						local target = exports['drp']:GetPlayerFromCid(cid)
						if cid then
							TriggerClientEvent('drp-scripts:createcard', player.source, job, emstypes[type], cid, drug, emslevels[level])
							--exports[drp_adminmenu']:sendToDiscord('Precscription Created', "The following prescription was created:\n\nPharmacist ID:  **"..player.cid.."**\nPharmacist Name:  **"..player.fullname.."**\n\nPatient ID:  **"..target.cid.."**\nPatient Name:  **"..target.fullname.."**\nType:  **"..emstypes[type].."**\nDrug:  **"..drug.."**\nSymptoms:  **"..emslevels[level].."**\n\nTime:  **"..timestamp.."**", "16731983", "")
						end
					end
				end
			end
		end			
	end)
end)

local function CreateBadge(sentCid, cb)
	local player = exports['drp']:GetPlayerFromCid(sentCid) 
	if player then
		local firstname = player['firstname']
		local lastname = player['lastname']
		local job = player['job']['name']
		local jobInfo = exports['drp']:GetJobInfo(job)
		local rank = jobInfo['grades'][player.job.grade]['label']
		local issuedate = os.date('%m/%d/%Y')
		local expirydate = os.date('%m/%d/%Y', os.time() + 336 * 60 * 60)
		local picture = exports.oxmysql:fetchSync('SELECT profilepic FROM users WHERE id=:id', { id = sentCid} )[1]['profilepic']

		cb({
			firstname = firstname,
			lastname = lastname,
			job = job,
			rank = rank,
			expirydate = expirydate,
			picture = picture
		})
	end
end

exports('CreateBadge', CreateBadge) -- exports['drp-scripts']:CreateBadge(cid)

local function CreateInsurance(sentCid, cb)
	local player = exports['drp']:GetPlayerFromCid(sentCid) 
	if player then
		local fullname = player['firstname']..' '..player['lastname']
		
		cb({
			fullname = fullname,
			cid = sentCid
		})
	end
end

exports('CreateInsurance', CreateInsurance) -- exports['drp-scripts']:CreateInsurance(cid)

RegisterNetEvent('drp-scripts:indicate')
AddEventHandler('drp-scripts:indicate', function(type, state, vehicle)
	TriggerClientEvent('drp-scripts:indicate', -1, type, state, vehicle)
end)