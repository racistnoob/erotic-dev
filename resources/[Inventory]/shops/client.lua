RegisterNetEvent('shops:anticheatcheck')
AddEventHandler('shops:anticheatcheck', function(type) if type then TriggerEvent("server-inventory-open", type, "Shop"); end end)

local hasGotConfig = false

local promptStatus = 0
local promptType = 0

--[[RegisterNetEvent('drp-shops:sendConfig')
AddEventHandler('drp-shops:sendConfig', function(Cfg)
	if hasGotConfig then return end;
	hasGotConfig = true

	print("Shops configuration received!")

	Wait(500)

	CreateThread(function()
		local tool_shops = Cfg.tool_shops
		local electronic_shops = Cfg.electronic_shops
		local mechanic_parts_shops = Cfg.mechanic_parts_shops
		local police_armory = Cfg.police_armory
		local twentyfourseven_shops = Cfg.twentyfourseven_shops
		local weashop_locations = Cfg.weashop_locations
		local SecretStashes = Cfg.SecretStashes
		local JobShops = Cfg.JobShops
		local Stashes = Cfg.Stashes
		local CustomBlips = Cfg.CustomBlips
		local ShopCounters = Cfg.ShopCounters

		for k,v in pairs(weashop_locations) do
			if v ~= vector3(21.76, -1107.32, 29.79) then
				exports['drp']:createBlip({
					resource = GetCurrentResourceName(),
					group = "Ammu-Nation",
					coords = v,
					sprite = 110,
					scale = 0.7,
					color = 17,
					shortrange = true,
					text = "Ammu-Nation"
				})
			end
		end

		for k,v in ipairs(twentyfourseven_shops) do
			Wait(100)
			if v.blip then
				exports['drp']:createBlip({
					resource = GetCurrentResourceName(),
					group = "Shop",
					coords = v.coords,
					sprite = 52,
					scale = 0.7,
					color = 2,
					shortrange = true,
					text = "Shop"
				})
			end
		end
	
		for k,v in ipairs(tool_shops) do
			Wait(100)
			exports['drp']:createBlip({
				resource = GetCurrentResourceName(),
				group = "Shop",
				coords = v.coords,
				sprite = 402,
				scale = 0.7,
				color = 2,
				shortrange = true,
				text = "Tool Shop"
			})
		end

		local blip = AddBlipForCoord(vector3(-1077.39, -248.11, 37.76))
		SetBlipSprite(blip, 256)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lifeinvader")
		EndTextCommandSetBlipName(blip)
	
		exports['drp']:createBlip({
			resource = GetCurrentResourceName(),
			group = "Shop",
			coords = vector3(143.39, -1722.53, 29.28),
			sprite = 621,
			scale = 0.7,
			color = 34,
			shortrange = true,
			text = "Sex Store"
		})
	
		for i=1, #electronic_shops do
			Wait(100)
			exports['drp']:createBlip({
				resource = GetCurrentResourceName(),
				group = "Shop",
				coords = electronic_shops[i]['coords'],
				sprite = 606,
				scale = 0.7,
				color = 3,
				shortrange = true,
				text = "Electronic Shop"
			})
		end	
	
		for i=1, #CustomBlips do
			Wait(100)
			local info = CustomBlips[i]
			exports['drp']:createBlip({
				resource = GetCurrentResourceName(),
				group = info.group,
				coords = info.coords,
				sprite = info.sprite,
				scale = 0.7,
				color = info.colour,
				shortrange = true,
				text = info.title
			})
		end
	
		exports['drp']:createBlip({
			resource = GetCurrentResourceName(),
			group = "Food Shop",
			coords = vec3(-430.16, 261.79, 83.00),
			sprite = 88,
			scale = 0.7,
			color = 0,
			shortrange = true,
			text = "Fat Mikes Bar & Grill"
		})
	
		exports['drp']:createBlip({
			resource = GetCurrentResourceName(),
			group = "Food Shop",
			coords = vec3(-633.22, 235.48, 81.87),
			sprite = 93,
			scale = 0.7,
			color = 31,
			shortrange = true,
			text = "Coffee Shop"
		})

		while hasGotConfig do
			Wait(0)
			local found = false
			
			local pos = GetEntityCoords(PlayerPedId())
			local job = exports["isPed"]:isPed("myjob")
			local currentJob = job.name
			local currentJobGrade = job.grade
	
			if not found then
				for i=1, #weashop_locations do
					local coords = weashop_locations[i]
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "weaponshop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "weaponshop"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Weapon Shop')
						end
						if IsControlJustPressed(1, 38) then
							TriggerServerEvent('shops:weapons:licensecheck', "5", "Shop")
							--TriggerEvent("server-inventory-open", "5", "Shop");	
							Wait(1000)
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				for i=1, #JobShops do
					local coords = JobShops[i]['coords']
					local shouldPass = false
					if JobShops[i]['job'] == 'all' then
						shouldPass = true
					else
						shouldPass = currentJob == JobShops[i]['job']
					end
					if shouldPass then
						if #(coords - pos) < 2.0 then
							found = true
							if promptStatus == 1 and promptType ~= "jobshops" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
							if promptStatus == 0 then
								promptStatus = 1
								promptType = "jobshops"
								TriggerEvent('drp-prompts:ShowUI', 'show', JobShops[i]['message'] or '[E] Access Shop')
							end
							if IsControlJustPressed(1, 38) then
								if JobShops[i]['emote'] then TriggerEvent('dp:playEmote', JobShops[i]['emote']) end
								TriggerEvent("server-inventory-open", JobShops[i]['type'], JobShops[i]['shopType']);	
								Wait(1000)
							end
						end
					end
					if found then break end;
				end
			end
	
			-- EMS Main Shop
			if not found then
				if #(vector3(-494.07, -342.79, 42.3) - pos) < 3.0 then
					found = true
					if promptStatus == 1 and promptType ~= "emsshop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "emsshop"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Access Shop')
					end
					if IsControlJustPressed(1, 38) and currentJob == 'ambulance' then
						TriggerEvent("server-inventory-open", "15", "Shop");
						Wait(1000)
					end
				end
			end
	
			-- EMS CMMC Shop
			if not found then
				if #(vector3(1826.57, 3686.51, 34.27) - pos) < 3.0 then
					found = true
					if promptStatus == 1 and promptType ~= "cmmcshop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "cmmcshop"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Access Shop')
					end
					if IsControlJustPressed(1, 38) and currentJob == 'cmmc' then
						TriggerEvent("server-inventory-open", "15", "Shop");
						Wait(1000)
					end
				end
			end
	
			if not found then
				if #(vector3(243.28, -1090.52, 29.28) - pos) < 3.0 then
					found = true
					if promptStatus == 1 and promptType ~= "idshop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "idshop"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Collect ID')
					end
					if IsControlJustPressed(1, 38) then
						local PlayerData = exports['drp']:GetPlayerData()
	
						local HairNames = {
							[-1] = "BLK",
							[0] = "BLK",
							[1] = "BLK",
							[2] = "BRO",
							[3] = "BRO",
							[4] = "BRO",
							[5] = "BRO",
							[6] = "BRO",
							[7] = "BRO",
							[8] = "BRO",
							[9] = "SDY",
							[10] = "SDY",
							[11] = "BLN",
							[12] = "BLN",
							[13] = "BLN",
							[14] = "BLN",
							[15] = "BLN",
							[16] = "BRO",
							[17] = "BRO",
							[18] = "RED",
							[19] = "RED",
							[20] = "RED",
							[21] = "RED",
							[22] = "RED",
							[23] = "ONG",
							[24] = "ONG",
							[25] = "ONG",
							[26] = "GRY",
							[27] = "GRY",
							[28] = "GRY",
							[29] = "GRY",
							[30] = "PLE",
							[31] = "PLE",
							[32] = "PLE",
							[33] = "PNK",
							[34] = "PNK",
							[35] = "PNK",
							[36] = "BLU",
							[37] = "BLU",
							[38] = "BLU",
							[39] = "GRN",
							[40] = "GRN",
							[41] = "GRN",
							[42] = "GRN",
							[43] = "GRN",
							[44] = "GRN",
							[45] = "SDY",
							[46] = "SDY",
							[47] = "ONG",
							[48] = "ONG",
							[49] = "ONG",
							[50] = "ONG",
							[51] = "RED",
							[52] = "RED",
							[53] = "RED",
							[54] = "RED",
							[55] = "BLK",
							[56] = "BLK",
							[57] = "BRO",
							[58] = "BRO",
							[59] = "BRO",
							[60] = "BRO",
							[61] = "BLK",
							[62] = "SDY",
							[63] = "BLN",
							[64] = "BLK"
						}
	
						local EyeNames = {
							[-1] = "GRN",
							[0] = "GRN",
							[1] = "GRN",
							[2] = "BLU",
							[3] = "BLU",
							[4] = "HAZ",
							[5] = "BRO",
							[6] = "HAZ",
							[7] = "GRY",
							[8] = "GRY",
							[9] = "PNK",
							[10] = "YLW",
							[11] = "PLE",
							[12] = "BLK",
							[13] = "GRY",
							[14] = "HAZ",
							[15] = "YLW",
							[16] = "GRY",
							[17] = "RED",
							[18] = "ONG",
							[19] = "GRY",
							[20] = "GRN",
							[21] = "RED",
							[22] = "BLU",
							[23] = "SDY",
							[24] = "ONG",
							[25] = "BLK",
							[26] = "RED",
							[27] = "RED",
							[28] = "BLU",
							[29] = "GRY",
							[30] = "WHI",
							[31] = "GRN",
							[32] = "GRN" 
						}
	
						local haircolor = GetPedHairColor(PlayerPedId())
						local eyecolor = GetPedEyeColor(PlayerPedId())
						
						local keyboard = exports["drp-dialog"]:KeyboardInput({
								header = "Mugshot URL", 
								rows = { { id = 0, label = "Mugshot URL", helper = "Input a mugshot URL, must end with .png or .jpg" } }
						})
						if keyboard and keyboard[1] then
							local tmpInput = keyboard[1].input
							if tmpInput == "" or tmpInput == nil then
								exports['drp-notifications']:SendAlert('inform', 'You must provide a link that ends with .png or .jpg')
							elseif (not string.find(tmpInput, "jpg")) and (not string.find(tmpInput, "png")) then
								exports['drp-notifications']:SendAlert('inform', 'You must provide a link that ends with .png or .jpg')
							elseif (string.find(tmpInput, "jpg")) or (string.find(tmpInput, "png")) then
	
								local hName = HairNames[haircolor]
								if not hName then
									hName = "BLK"
								end
	
								local eName = EyeNames[eyecolor]
								if not eName then
									eName = "BLK"
								end
	
								TriggerServerEvent('echorp:createId', hName, eName, tmpInput)
							end	
						end
						Wait(1000)
					end
				end
			end
	
			if not found then
				for i=1, #twentyfourseven_shops do
					local coords = twentyfourseven_shops[i]['coords']
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "twentyfourseven_shops" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "twentyfourseven_shops"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Browse Store')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open", "2", "Shop");	
							Wait(1000)
						end
					end
					if found then break end;
				end
			end

			if not found then -- EMS Public Shop
				if #(vector3(-433.28, -340.56, 34.91) - pos) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "emspublic" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "emspublic"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Access Shop')
					end
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open", "emspublic", "Shop");	
						Wait(1000)
					end
				end
			end
	
			if not found then -- JaiL Food
				if #(vector3(1783.44, 2558.97, 45.66) - pos) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "22shop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "22shop"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Access Shop')
					end
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open", "22", "Shop");	
						Wait(1000)
					end
				end
			end
			
			if not found then
				for i=1, #police_armory do
					local coords = police_armory[i]
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "police_armory" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "police_armory"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Police Armory')
						end
						if IsControlJustPressed(1, 38) then
							if job.isPolice then
								TriggerEvent("server-inventory-open", "10", "Shop")
								Wait(1000)
							end
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				for i=1, #tool_shops do
					local coords = tool_shops[i]['coords']
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "toolstore" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "toolstore"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Tool Store')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open",  tool_shops[i]['type'], "Shop")
							Wait(1000)
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				for i=1, #electronic_shops do
					local coords = electronic_shops[i]['coords']
					local dist = #(coords - pos)
					if dist < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "electronic_shops" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "electronic_shops"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Electronics Store')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open",  electronic_shops[i]['type'], "Shop")
							Wait(1000)
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				for i=1, #mechanic_parts_shops do
					local coords = mechanic_parts_shops[i]['coords']
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "mechanic_parts_shops" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "mechanic_parts_shops"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Mechanic Store')
						end
						if IsControlJustPressed(1, 38) then
							if exports["drp-inventory"]:IsMechanic() then
								TriggerEvent("server-inventory-open",  mechanic_parts_shops[i]['type'], "Shop")
								Wait(1000)
							end
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				local sexStore = vector3(143.39, -1722.53, 29.28)
				if #(sexStore - pos) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "sexStore" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "sexStore"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Sex lol')
					end
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open",  "21", "Shop")
						Wait(1000)
					end
				end
			end
	
			if not found then
				for i=1, #SecretStashes do
					local coords = SecretStashes[i]['coords']
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "SecretStashes" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptStatus = "SecretStashes"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
						end
						if IsControlJustPressed(1, 38) then
							if SecretStashes[i]['job'] == 'nothing' then
								DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
								while (UpdateOnscreenKeyboard() == 0) do
									DisableAllControlActions(0);
									Wait(0);
								end
								if (GetOnscreenKeyboardResult()) then
									local result = GetOnscreenKeyboardResult()
									if not result or result == nil then
										exports['drp-notifications']:SendAlert('inform', 'Hurrrr, you provided no code :(', 5000)
									else
										if tostring(SecretStashes[i]['code']) == tostring(result) then
											Wait(100)
											TriggerEvent("server-inventory-open", SecretStashes[i]['type'], "Shop");
											Wait(1000)
										else
											exports['drp-notifications']:SendAlert('error', 'Wrong code', 5000)
										end
									end
								end
							elseif SecretStashes[i]['job'] == 'jt3nv7' and currentJob == SecretStashes[i]['job'] then
								if exports["isPed"]:isPed("grade") >= 3 then
									DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
									while (UpdateOnscreenKeyboard() == 0) do
										DisableAllControlActions(0);
										Wait(0);
									end
									if (GetOnscreenKeyboardResult()) then
										local result = GetOnscreenKeyboardResult()
										if not result or result == nil then
											exports['drp-notifications']:SendAlert('inform', 'Hurrrr, you provided no code :(', 5000)
										else
											if tostring(SecretStashes[i]['code']) == tostring(result) then
												Wait(100)
												TriggerEvent("server-inventory-open", SecretStashes[i]['type'], "Shop");
												Wait(1000)
											else
												exports['drp-notifications']:SendAlert('error', 'Wrong code', 5000)
											end
										end
									end
								end
							end
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				for i=1, #Stashes do
					local coords = Stashes[i]['coords']
					if #(coords - pos) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "Stashes" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "Stashes"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
						end
						if IsControlJustPressed(1, 38) then
							if currentJob == Stashes[i]['job'] and exports["isPed"]:isPed("grade") >= Stashes[i]['grade'] then
								if string.find(Stashes[i]['name'], "storage") then
									TriggerEvent("server-inventory-open", "1", Stashes[i]['name'])
								else
									TriggerEvent("server-inventory-open", "1", "jobstash-"..Stashes[i]['name'])
								end
								Wait(1000)
							else
								exports['drp-notifications']:SendAlert('inform', 'Access denied.')
								Wait(1000)
							end
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				if #(pos - vector3(472.71, -992.73, 26.26)) < 2.0 then
					found = true
					if promptStatus == 1 and promptType ~= "mrpdstash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "mrpdstash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "missionrow")
							Wait(1000)
						end
					end
				elseif #(pos - vector3(1858.05, 3692.36, 34.27)) < 2.0 then
					found = true
					if promptStatus == 1 and promptType ~= "sheriffstationstash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "sheriffstationstash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "sheriffstation")
							Wait(1000)
						end
					end
				elseif #(pos - vector3(1844.0, 2574.3, 46.01)) < 2.5 then
					found = true
					if promptStatus == 1 and promptType ~= "prisonstash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "prisonstash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "prison-stash")
							Wait(1000)
						end
					end
				elseif #(pos - vector3(387.1949, 796.5566, 187.6775)) < 2.5 then
					found = true
					if promptStatus == 1 and promptType ~= "sapr-stash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "sapr-stash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Stash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "sapr-stash")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if #(pos - vector3(486.53, -995.41, 30.68)) < 2.5 then
					found = true
					if promptStatus == 1 and promptType ~= "mrpdtrash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "mrpdtrash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] MRPD Trash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "trash-mrpd")
							Wait(1000)
						end
					end
				elseif #(pos - vector3(1838.68, 2576.76, 46.01)) < 2.5 then
					found = true
					if promptStatus == 1 and promptType ~= "prisontrash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "prisontrash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Prison Trash')
					end
					if IsControlJustPressed(1, 38) then
						if job.isPolice then
							TriggerEvent("server-inventory-open", "1", "trash-prison")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if #(pos - vector3(-436.69, -318.08, 34.91)) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "emsstash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "emsstash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] EMS Stash')
					end
					if IsControlJustPressed(1, 38) then
						if currentJob == 'ambulance' then
							TriggerEvent("server-inventory-open", "1", "pillbox")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if #(pos - vector3(1822.88, 3666.58, 34.27)) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "cmmcstash" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "cmmcstash"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] CMMC Stash')
					end
					if IsControlJustPressed(1, 38) then
						if currentJob == 'cmmc' then
							TriggerEvent("server-inventory-open", "1", "cmmc")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if #(pos - vector3(-633.22, 235.48, 81.87)) < 1.0 then
					found = true
					if promptStatus == 1 and promptType ~= "coffeeshop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "coffeeshop"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Coffee Shop')
					end
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open", "699", "Shop")
						Wait(1000)
					end
				end
			end
	
			if not found then
				if currentJob == 'vanilla' then 
					if #(pos - vector3(129.9, -1284.36, 29.26)) < 1.0 then
						found = true
						if promptStatus == 1 and promptType ~= "vu" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "vu"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Vanilla Unicorn')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open", "VU", "Shop")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if currentJob == 'cdmortuary' then
					if #(pos - vector3(248.94, -1374.94, 39.52)) < 1.5 then
						found = true
						if promptStatus == 1 and promptType ~= "morgueShop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "morgueShop"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Morgue Shop')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open", "Mort", "Shop")
							Wait(1000)
						end
					end
				end
			end
	
			if not found then
				if currentJob == 'potato' then
					local potCoords = vector3(-45.68, 1918.91, 195.35)
					if #(pos - potCoords) < 2.0 then
						found = true
						if promptStatus == 1 and promptType ~= "ProcessPotato" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "ProcessPotato"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Process Potato')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open", 1011, "Craft");
							Wait(1000)
						end
					end 
				end
			end

			if not found then
				for i=1, #ShopCounters do
					local coords = ShopCounters[i]['coords']
					if #(coords - pos) < 1.1 then
						found = true
						if promptStatus == 1 and promptType ~= "ShopCounters" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "ShopCounters"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Open Counter')
						end
						if IsControlJustPressed(1, 38) then
							if string.find(Stashes[i]['name'], "storage") then
								TriggerEvent("server-inventory-open", "1", ShopCounters[i]['name'])
							else
								TriggerEvent("server-inventory-open", "1", "jobcounter-"..ShopCounters[i]['name'])
							end
							Wait(1000)
						end
					end
					if found then break end;
				end
			end
	
			if not found then
				if #(pos - Cfg.secretguns) < 2.0 then
					found = true
					if IsControlJustPressed(1, 38) then
						SendNUIMessage({ show = true, data = "secretguns" }) 
						SetNuiFocus(true, true)
						Wait(1000)
					end
				end 
			end
	
			if not found then
				local fuckthis = Cfg.baggedpuremeth
				if #(pos - fuckthis) < 2.0 then
					found = true
					if promptStatus == 1 and promptType ~= "baggedpuremeth" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "baggedpuremeth"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Craft')
					end
					if IsControlJustPressed(1, 38) then
						if exports["drp-inventory"]:hasEnoughOfItem("rawmethpile",1,false) then
							if exports["drp-inventory"]:hasEnoughOfItem("ziplock_bag",10,false) then
								TriggerEvent('dp:playEmote', "mechanic4")
								local finished = exports["drp-progressbar"]:taskBar(5000,"Bagging Pure Meth",false,false)
								if (finished == 100) then
									if exports["drp-inventory"]:hasEnoughOfItem("rawmethpile",1,false) and exports["drp-inventory"]:hasEnoughOfItem("ziplock_bag",10,false) then
										TriggerEvent("inventory:removeItem", "ziplock_bag", 10)
										TriggerEvent("inventory:removeItem", "rawmethpile", 1)
										TriggerEvent( "player:receiveItem","baggedpuremeth", math.random(5, 8))
									end
								end
								ExecuteCommand('e c')
							else
								exports['drp-notifications']:SendAlert('inform', 'Missing bags.')
							end
						else
							exports['drp-notifications']:SendAlert('inform', 'Missing an essential meth product.', 5000)
						end
						Wait(1000)
					end
				end
			end
	
			if not found then
				local fuckthis = Cfg.refinedmeth
				if #(pos - fuckthis) < 2.0 then
					found = true
					if promptStatus == 1 and promptType ~= "refinedmeth" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "refinedmeth"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Craft')
					end
					if IsControlJustPressed(1, 38) then
						local baggedpuremeth = exports['drp-inventory']:getQuantity('baggedpuremeth')
						local toTake = math.random(5, 8)
						if baggedpuremeth >= toTake then
							TriggerEvent('dp:playEmote', "mechanic4")
							local finished = exports["drp-progressbar"]:taskBar(5000,"Refined Meth Bags",false,false)
							if finished == 100 then 
								if exports["drp-inventory"]:hasEnoughOfItem("baggedpuremeth",toTake,false) then
									TriggerEvent( "player:receiveItem","refinedmeth", math.random(5, 7))
									TriggerEvent("inventory:removeItem", "baggedpuremeth", toTake)
								end
							end
							ExecuteCommand('e c')
						else
							exports['drp-notifications']:SendAlert('inform', 'Missing pure meth.')
						end
						Wait(1000)
					end
				end
			end
	
			if not found then
				local fuckthis = Cfg.thermalcharge
				if #(pos - fuckthis) < 2.0 then
					found = true
					if promptStatus == 1 and promptType ~= "thermalcharge" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
					if promptStatus == 0 then
						promptStatus = 1
						promptType = "thermalcharge"
						TriggerEvent('drp-prompts:ShowUI', 'show', '[?] ???')
					end
					if IsControlJustPressed(1, 38) then
						TriggerEvent("server-inventory-open", "thermalcharge", "Craft");
						Wait(1000)
					end
				end
			end
	
			if not found then
				local fuckthis = vector3(-589.12, -937.41, 23.8)
				if currentJob == 'weazelnews' then
					if #(pos - fuckthis) < 2.0 then
						found = true
						if promptStatus == 1 and promptType ~= "WeazelShop" then TriggerEvent('drp-prompts:HideUI') Wait(100) end;
						if promptStatus == 0 then
							promptStatus = 1
							promptType = "WeazelShop"
							TriggerEvent('drp-prompts:ShowUI', 'show', '[E] Weazel Shop')
						end
						if IsControlJustPressed(1, 38) then
							TriggerEvent("server-inventory-open", "weazelnews", "Shop");
							Wait(1000)
						end
					end
				end
			end
	
			if not found then 
				if promptStatus == 1 then
					TriggerEvent('drp-prompts:HideUI')
					promptStatus = 0
				end
				Wait(750) 
			end
		end
	end)
end)]]

local mechanicshopblipthing = 0

AddEventHandler('mechanicshopblipthing', function()
  if not DoesBlipExist(mechanicshopblipthing) then
		mechanicshopblipthing = AddBlipForCoord(vector3(810.4, -750.24, 26.74))
		SetBlipSprite(mechanicshopblipthing, 52)
		SetBlipScale(mechanicshopblipthing, 0.7)
		SetBlipColour(mechanicshopblipthing, 9)
		SetBlipAsShortRange(mechanicshopblipthing, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Mechanic Part Shop")
		EndTextCommandSetBlipName(mechanicshopblipthing)
	end
end)

RegisterNetEvent('echorp:playerSpawned') -- Use this to grab player info on spawn.
AddEventHandler('echorp:playerSpawned', function(sentData) 
	Wait(5000)
	if exports["drp-inventory"]:IsMechanic() then TriggerEvent('mechanicshopblipthing') end
end)

RegisterNetEvent('echorp:updateinfo')
AddEventHandler('echorp:updateinfo', function(toChange, targetData) 
	Wait(5000)
	if exports["drp-inventory"]:IsMechanic() then
		TriggerEvent('mechanicshopblipthing')
	end
end)

RegisterNUICallback('getCodeResult', function(data, cb)
	SendNUIMessage({ show = false }) SetNuiFocus(false, false)
	local code = data.code
  if code == "" then exports['drp-notifications']:SendAlert('inform', 'Please enter a code.') return end
  if code then TriggerServerEvent('shops:coderesult', code, data.data) end
  cb(true)
end)