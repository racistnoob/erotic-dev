local unholsteringactive = false
local armed = `WEAPON_UNARMED`
local currentWeaponInfo = {}
local currentAmmo = {}

pullfromback = {
	[1] = "WEAPON_MicroSMG",
	[2] = "WEAPON_SMG",
	[3] = "WEAPON_AssaultSMG",
	[4] = "WEAPON_Gusenberg",
	[5] = "WEAPON_AssaultShotgun",
	[6] = "WEAPON_BullpupShotgun",
	[7] = "WEAPON_HeavyShotgun",
	[8] = "WEAPON_Autoshotgun",
	[9] = "WEAPON_SawnoffShotgun",
	[10] = "WEAPON_AssaultRifle",
	[11] = "WEAPON_CarbineRifle",
	[12] = "WEAPON_AdvancedRifle",
	[13] = "WEAPON_SpecialCarbine",
	[14] = "WEAPON_BullpupRifle",
	[15] = "WEAPON_SniperRifle",
	[16] = "WEAPON_HeavySniper",
	[17] = "WEAPON_MarksmanRifle",
	[18] = "WEAPON_Firework",
	[19] = "WEAPON_PetrolCan",
	[20] = "WEAPON_Bat",
	[21] = "WEAPON_Crowbar",
	[22] = "WEAPON_Golfclub",
	[23] = "WEAPON_Hatchet",
	[24] = "WEAPON_Machete",
	[25] = "WEAPON_Poolcue",
	[26] = "WEAPON_Wrench",
	[27] = "WEAPON_PUMPSHOTGUN",
	[28] = "WEAPON_COMBATPDW",
}


local throwableWeapons = {}
throwableWeapons["741814745"] = true
throwableWeapons["741814745"] = true
throwableWeapons["615608432"] = true
throwableWeapons["1233104067"] = true
throwableWeapons["2874559379"] = true
throwableWeapons["126349499"] = true
throwableWeapons["3125143736"] = true
throwableWeapons["-73270376"] = true
throwableWeapons["-37975472"] = true

RegisterNUICallback('dropweapon', function(data, cb)
	cb('ok')
end)

function loadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(5) end
end

local animDict = "combat@gestures@gang@pistol_1h@beckon"

local prop = "prop_ballistic_shield"
local pistol = `WEAPON_PISTOL`

local lastWeaponDeg = 0
function attemptToDegWeapon()
	if math.random(1, 100) > 50 then
		local hasTimer = 99999
		hasTimer = (GetGameTimer()-lastWeaponDeg)
		if hasTimer >= 2000 then
			lastWeaponDeg = GetGameTimer()
			TriggerServerEvent("inventory:degItem",currentWeaponInfo.id, 1000 * 60 * math.random(8, 13))
		end
	end
end

Controlkey = {["actionBar"] = {37,"TAB"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["actionBar"] = table["actionBar"]
end)

local ped

CreateThread(function()
	while true do
		ped = PlayerPedId()
		Wait(2500)
	end
end)

local AmmoTypes = {
	['pistolammo'] = {
		[453432689] = true,
		[1593441988] = true,
		[584646201] = true,
		[2578377531] = true,
		[3218215474] = true,
		[3696079510] = true,
		[3523564046] = true,
		[137902532] = true,
		[-771403250] = true,
		[-1716589765] = true,
		[-1746263880] = true,
		[-1045183535] = true,
		[-1075685676] = true,
		[-1076751822] = true,
		[1303514201] = true,
		[-998000829] = true,
	},
	['subammo'] = {
		[324215364] = true,
		[736523883] = true,
		[4024951519] = true,
		[3173288789] = true,
		[-270015777] = true,
		[2024373456] = true,
		[-1121678507] = true,
		[171789620] = true,
		[1627465347] = true,
		[3675956304] = true,
		[-619010992] = true,
		[506038341] = true,
	},
	['rifleammo'] = {
		[3220176749] = true,
		[2210333304] = true,
		[2937143193] = true,
		[3231910285] = true,
		[2132975508] = true,
		[1649403952] = true,
		[-1357824103] = true,
		[-1074790547] = true,
		[-86904375] = true,
		[-2084633992] = true,
		[-494615257] = true,
		[-774507221] = true,
		[-1063057011] = true,
		[-1949706116] = true,
		[-947031628] = true,
	},
	['shotgunammo'] = {
		[487013001] = true,
		[2017895192] = true,
		[3800352039] = true,
		[2640438543] = true,
		[984333226] = true,
		[4019527611] = true,
		[317205821] = true,
		[-1654528753] = true,
		[-275439685] = true,
		[1432025498] = true,
	},
	['sniperammo'] = {
		[100416529] = true,
		[2138347493] = true,
		[`WEAPON_FIREWORK`] = true
	},
	['bbammo'] = {
		[`WEAPON_BBSHOTGUN`] = true
	}
}

RegisterKeyMapping("+hotbar", "Open Inventory Hotbar", "keyboard", "TAB")

RegisterCommand("-hotbar", function() 
	if exports["drp-characterui"]:InCharacterUI() then return end if exports["drp_clothing"]:inMenu() then return end 
	TriggerEvent("inventory-bar",false)
end, false) -- Disables chat from opening.

RegisterCommand("+hotbar", function(source, args, rawCommand) 
	if exports["drp-characterui"]:InCharacterUI() then return end if exports["drp_clothing"]:inMenu() then return end 
	TriggerEvent("inventory-bar",true)
end, false)

local Uhh = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
}

CreateThread(function()
	for i=1, #Uhh do
		RegisterKeyMapping("+hotbar"..i, "Hotbar slot "..i, "keyboard", i)
		RegisterCommand("+hotbar"..i, function(source, args, rawCommand) if exports["drp-characterui"]:InCharacterUI() then return end if exports["drp_clothing"]:inMenu() then return end  TriggerEvent("inventory-bind",i) end, false)
		RegisterCommand("-hotbar"..i, function() end, false)
	end
end)

local unarmedHash = `WEAPON_UNARMED`

CreateThread( function()
	while true do
		Wait(0)

		local hash = GetSelectedPedWeapon(ped)

		if armed ~= unarmedHash then hash = armed end
		if hash ~= unarmedHash then
			if currentAmmo[hash] == nil then currentAmmo[hash] = 0 end
			currentAmmo[hash] = GetAmmoInPedWeapon(ped, hash) or 0
		end

		-- if hash ~= `WEAPON_SNIPERRIFLE` then HideHudComponentThisFrame(14) end

		if IsPedShooting(ped) then
			if hash ~= `WEAPON_SNOWBALL` then attemptToDegWeapon() end
			local weapon = "".. hash ..""
			if throwableWeapons[weapon] then
				if exports["drp-inventory"]:hasEnoughOfItem(weapon,1,false) then
					TriggerEvent("inventory:removeItem", weapon, 1)
					Wait(3000)
				elseif hash ~= `WEAPON_SNOWBALL` then
					armed = unarmedHash
					RemoveAllPedWeapons(ped)
				end
			end
		end

		if unholsteringactive then
			DisablePlayerFiring(ped, true) -- Disable weapon firing
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		end
	end
end)

RegisterNUICallback('equipweapon', function(data)
	equipWeaponID(data.saveid)
end)

RegisterNetEvent('equipWeaponID')
AddEventHandler('equipWeaponID', function(hash,ItemInfo)
	local dead = LocalPlayer.state.dead
	if dead then return end
	if unholsteringactive then return end;

	local currentArmed = armed

	SetPedAmmo(PlayerPedId(),  `WEAPON_FIREEXTINGUISHER`, 10000)
	currentAmmo[`WEAPON_FIREEXTINGUISHER`] = 10000
	SetPedAmmo(PlayerPedId(),  `WEAPON_PetrolCan`, 10000)
	currentAmmo[`WEAPON_PetrolCan`] = 10000
	
	if tonumber(currentArmed) ~= tonumber(`WEAPON_UNARMED`) then
		TriggerEvent("hud-display-item", currentArmed, '<span style="color:red">Holster</span>')

		local holster = holster1h(true)
		if tonumber(currentArmed) ~= tonumber(hash) then
			while unholsteringactive do Wait(0) end
			TriggerEvent("hud-display-item",tonumber(hash),"Equip")
			unholster1h(tonumber(hash),ItemInfo)
		end
	else
		TriggerEvent("hud-display-item",tonumber(hash),"Equip")
		unholster1h(tonumber(hash),ItemInfo)
	end

	SetPedAmmo(PlayerPedId(),  `WEAPON_FIREEXTINGUISHER`, 10000)
	currentAmmo[`WEAPON_FIREEXTINGUISHER`] = 10000
	SetPedAmmo(PlayerPedId(),  `WEAPON_PetrolCan`, 10000)
	currentAmmo[`WEAPON_PetrolCan`] = 10000
end)

RegisterNetEvent('brokenWeapon')
AddEventHandler('brokenWeapon', function()
	local dead = LocalPlayer.state.dead
	if dead then return end
	holster1h(true)
	armed = `WEAPON_UNARMED`
	SetPedAmmo(PlayerPedId(),  `WEAPON_FIREEXTINGUISHER`, 10000)
	currentAmmo[`WEAPON_FIREEXTINGUISHER`] = 10000
	SetPedAmmo(PlayerPedId(),  `WEAPON_PetrolCan`, 10000)
	currentAmmo[`WEAPON_PetrolCan`] = 10000
end)

RegisterNetEvent('drp-weapons:setAmmo')
AddEventHandler('drp-weapons:setAmmo', function(info, hash)
	currentWeaponInfo = info
	local info = json.decode(currentWeaponInfo.information)
	currentAmmo[hash] = math.ceil(tonumber(info.ammo)) or 0
	SetPedAmmo(PlayerPedId(), hash, math.ceil(tonumber(info.ammo)))
end)

RegisterNetEvent('actionbar:ammo')
AddEventHandler('actionbar:ammo', function(type,amount,addition)
    local hash = GetSelectedPedWeapon(PlayerPedId())
    if AmmoTypes[type][hash] then

        local ItemInfo = currentWeaponInfo
        local information = json.decode(ItemInfo.information)
        local ammo = information.ammo

        if ammo == nil then
            TriggerServerEvent('drp-weapons:fixInfo', ItemInfo.id, information)
            ammo = 0
            return
        end

        ammo = tonumber(ammo) or 0

        if addition then newammo = ammo + amount else newammo = ammo - amount end
        if (ammo == newammo) then newammo = newammo + 999 end
        if newammo > 999 then newammo = 999
        elseif newammo < 999 then newammo = 999 end

        TriggerEvent("inventory:removeItem", type, 1)

        ItemInfo.information = json.encode({
            serial = information.serial,
            quality = "Good",
            cartridge = information.cartridge,
            ammo = tostring(newammo)
        })

        TriggerServerEvent('drp-weapons:setAmmo', ItemInfo.id, ItemInfo, hash, exports['isPed']:isPed("cid"))
    else
        exports['drp-notifications']:SendAlert('inform', 'This ammo is not suitable for this weapon.', 5000)
    end
end)

function tablesize(T)
	local count = 0
	for k,v in pairs(T) do
		count = count + 1
	end
	return count
end

RegisterNetEvent('actionbar:setEmptyHanded')
AddEventHandler('actionbar:setEmptyHanded', function()
	if armed ~= `WEAPON_UNARMED` then
		TriggerEvent("hud-display-item",tonumber(hash),"Holster")
		holster1h(false)
	end
end)

function updateAmmo()
	local ped = PlayerPedId()
	local amount = currentAmmo[armed] or 0
	local ItemInfo = currentWeaponInfo
	local information = json.decode(ItemInfo.information)

	ItemInfo.information = json.encode({
		serial = information.serial,
		quality = "Good",
		cartridge = information.cartridge,
		ammo = tostring(amount)
	})

	TriggerServerEvent('drp-weapons:setAmmo', ItemInfo.id, ItemInfo, armed, exports['isPed']:isPed("cid"))
	return true
end

function unholster1h(weaponHash,ItemInfo)
	currentWeaponInfo = ItemInfo
	local info = json.decode(currentWeaponInfo.information)
	local ammo = 0

	--print(".", throwableWeapons["".. weaponHash ..""])
	if throwableWeapons["".. weaponHash ..""] then
		ammo = exports["drp-inventory"]:getQuantity("".. weaponHash .."")
		--print(ammo)
	else
		ammo = tonumber(info.ammo)
		if ammo == nil then TriggerServerEvent('drp-weapons:fixInfo', ItemInfo.id, info) ammo = 0 end
	end

	unholsteringactive = true

	local dict = "reaction@intimidation@1h"
	local anim = "intro"
	local j = exports["isPed"]:isPed("myjob")
	local ped = PlayerPedId()

    SetWeaponsNoAutoswap(true)

	if j.isPolice and j.duty == 1 then
		copunholster(weaponHash, ammo)
		return
	end	

	RemoveAllPedWeapons(ped)

	if weaponHash ~= -538741184 and weaponHash ~= 615608432 then
		local animLength = GetAnimDuration(dict, anim) * 1000
	  loadAnimDict(dict) 
	  TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		Wait(900)
		SetAmmoInClip(ped, weaponHash, 0)
		GiveWeaponToPed(PlayerPedId(), weaponHash, math.ceil(ammo), false, true)
    SetCurrentPedWeapon(PlayerPedId(), weaponHash, true)
		-- TriggerEvent('drp-hunting:huntingRifle', weaponHash == `weapon_sniperrifle`)
		armed = weaponHash
		currentAmmo[armed] = math.ceil(ammo)
	else
		SetAmmoInClip(ped, weaponHash, 0)
		GiveWeaponToPed(PlayerPedId(), weaponHash, math.ceil(ammo), false, true)
    SetCurrentPedWeapon(PlayerPedId(), weaponHash, true)
		-- TriggerEvent('drp-hunting:huntingRifle', weaponHash == `weapon_sniperrifle`)
		armed = weaponHash
		currentAmmo[armed] = math.ceil(ammo)
	end

	exports["drp-inventory"]:AttachmentCheck(weaponHash) Wait(200)
    ClearPedTasks(ped) Wait(200)
    unholsteringactive = false
end
-- Function to set the gun ammo to maximum (9999)
function setGunAmmoToMax(weaponHash)
    local maxAmmo = 250
    local ammoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
    AddAmmoToPed(PlayerPedId(), weaponHash, maxAmmo)
    Citizen.InvokeNative(0xB3B1CB349FF9C75D, PlayerPedId(), weaponHash, maxAmmo, true, true)
end

-- Main loop to check peds and their weapons
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Adjust the wait time as needed

        local ped = PlayerPedId() -- Get the current player's ped
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            local weaponHash = GetSelectedPedWeapon(ped) -- Get the currently equipped weapon
            setGunAmmoToMax(weaponHash) -- Set the ammo to maximum for the equipped gun
        end
    end
end)

function copunholster(weaponHash, ammo)
	local dic = "reaction@intimidation@cop@unarmed"
	local anim = "intro"
	loadAnimDict(dic)
	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped)
	TaskPlayAnim(ped, dic, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0 )
	Wait(600)
    GiveWeaponToPed(ped, weaponHash, math.ceil(ammo), 0, 1)
	SetCurrentPedWeapon(ped, weaponHash, 1)
	-- TriggerEvent('drp-hunting:huntingRifle', weaponHash == `weapon_sniperrifle`)
	armed = weaponHash
	--currentAmmo[armed] = math.ceil(ammo)
	ClearPedTasks(ped)

	if tonumber(math.ceil(GetAmmoInPedWeapon(ped, weaponHash))) ~= math.ceil(ammo) then
		GiveWeaponToPed(ped, weaponHash, math.ceil(ammo), 0, 1)
		-- TriggerEvent('drp-hunting:huntingRifle', weaponHash == `weapon_sniperrifle`)
	end

	exports["drp-inventory"]:AttachmentCheck(weaponHash)

	Wait(1)
	unholsteringactive = false
end

function copholster(playAnim)
	local dic = "reaction@intimidation@cop@unarmed"
	local anim = "intro"
	loadAnimDict(dic)
	local ped = PlayerPedId()

	if playAnim then
		TaskPlayAnim(ped, dic, anim, 10.0, 2.3, -1, 49, 1, 0, 0, 0 )
		Wait(1)
	end

	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, 1)
	armed = `WEAPON_UNARMED`
	RemoveAllPedWeapons(ped)
	ClearPedTasks(ped)
end

function holster1h(playAnim)
	local ammoUpdated = updateAmmo()
	while not ammoUpdated do Wait(0) end
	unholsteringactive = true
	local dict = "reaction@intimidation@1h"
	local anim = "outro"
	local j = exports["isPed"]:isPed("myjob")
	if (j.isPolice or j.name == "mib") and j.duty == 1 then
		copholster(playAnim)
		Citizen.Wait(200)
		unholsteringactive = false
		return
	end

	local ped = PlayerPedId()

	if playAnim then
		local animLength = GetAnimDuration(dict, anim) * 1
		loadAnimDict(dict) 
		TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)   
		Citizen.Wait(animLength - 1)
	end
    
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, 1)
	armed = `WEAPON_UNARMED`
    Citizen.Wait(300)
    RemoveAllPedWeapons(ped)
    ClearPedTasks(ped)
    Citizen.Wait(800)
	unholsteringactive = false
end