RegisterNetEvent('baseevents:onPlayerDied')
RegisterNetEvent('baseevents:onPlayerKilled')
RegisterNetEvent('baseevents:onPlayerWasted')

local Weapons = {
    --[[ Melee Weapons ]]--
    [`weapon_dagger`] = {['weaponName'] = 'Dagger', ['type'] = 'Melee'},
    [`weapon_bat`] = {['weaponName'] = 'Bat', ['type'] = 'Melee'},
    [`weapon_bottle`] = {['weaponName'] = 'Bottle', ['type'] = 'Melee'},
    [`weapon_crowbar`] = {['weaponName'] = 'Crowbar', ['type'] = 'Melee'},
    [`weapon_unarmed`] = {['weaponName'] = 'Unarmed', ['type'] = 'Melee'},
    [`weapon_flashlight`] = {['weaponName'] = 'Flashlight', ['type'] = 'Melee'},
    [`weapon_golfclub`] = {['weaponName'] = 'Golf Club', ['type'] = 'Melee'},
    [`weapon_hammer`] = {['weaponName'] = 'Hammer', ['type'] = 'Melee'},
    [`weapon_hatchet`] = {['weaponName'] = 'Hatchet', ['type'] = 'Melee'},
    [`weapon_knuckle`] = {['weaponName'] = 'Knuckle', ['type'] = 'Melee'},
    [`weapon_knife`] = {['weaponName'] = 'Knife', ['type'] = 'Melee'},
    [`weapon_machete`] = {['weaponName'] = 'Machete', ['type'] = 'Melee'},
    [`weapon_switchblade`] = {['weaponName'] = 'Switchblade', ['type'] = 'Melee'},
    [`weapon_nightstick`] = {['weaponName'] = 'Nightstick', ['type'] = 'Melee'},
    [`weapon_wrench`] = {['weaponName'] = 'Pipe Wrench', ['type'] = 'Melee'},
    [`weapon_battleaxe`] = {['weaponName'] = 'Battle Axe', ['type'] = 'Melee'},
    [`weapon_poolcue`] = {['weaponName'] = 'Pool Cue', ['type'] = 'Melee'},
    [`weapon_stone_hatchet`] = {['weaponName'] = 'Stone Hatchet', ['type'] = 'Melee'},
    --[[ Pistols ]]--
    [`weapon_pistol`] = {['weaponName'] = 'Pistol', ['type'] = 'Pistol'},
    [`weapon_pistol_mk2`] = {['weaponName'] = 'Pistol Mk II', ['type'] = 'Pistol'},
    [`weapon_combatpistol`] = {['weaponName'] = 'Combat Pistol', ['type'] = 'Pistol'},
    [`weapon_appistol`] = {['weaponName'] = 'AP Pistol', ['type'] = 'Pistol'},
    [`weapon_stungun`] = {['weaponName'] = 'Stun Gun (?)', ['type'] = 'Pistol'},
    [`weapon_pistol50`] = {['weaponName'] = 'Pistol .50', ['type'] = 'Pistol'},
    [`weapon_snspistol`] = {['weaponName'] = 'SNS Pistol', ['type'] = 'Pistol'},
    [`weapon_snspistol_mk2`] = {['weaponName'] = 'SNS Pistol Mk II', ['type'] = 'Pistol'},
    [`weapon_heavypistol`] = {['weaponName'] = 'Heavy Pistol', ['type'] = 'Pistol'},
    [`WEAPON_M45A1`] = {['weaponName'] = 'Heavy Pistol', ['type'] = 'Pistol'},
    [`weapon_vintagepistol`] = {['weaponName'] = 'Vintage Pistol', ['type'] = 'Pistol'},
    [`weapon_flaregun`] = {['weaponName'] = 'Flare Gun', ['type'] = 'Pistol'},
    [`weapon_marksmanpistol`] = {['weaponName'] = 'Marksman Pistol', ['type'] = 'Pistol'},
    [`weapon_revolver`] = {['weaponName'] = 'Heavy Revolver', ['type'] = 'Pistol'},
    [`weapon_revolver_mk2`] = {['weaponName'] = 'Heavy Revolver Mk II', ['type'] = 'Pistol'},
    [`weapon_doubleaction`] = {['weaponName'] = 'Double Action Revolver', ['type'] = 'Pistol'},
    [`weapon_raypistol`] = {['weaponName'] = 'Up-n-Atomizer', ['type'] = 'Pistol'},
    [`weapon_ceramicpistol`] = {['weaponName'] = 'Ceramic Pistol', ['type'] = 'Pistol'},
    [`weapon_navyrevolver`] = {['weaponName'] = 'Navy Revolver', ['type'] = 'Pistol'},
    [`weapon_sp45`] = {['weaponName'] = 'Sp45', ['type'] = 'Pistol'},
    [`weapon_1911`] = {['weaponName'] = 'M1911', ['type'] = 'Pistol'},
    --[[ Submachine Guns ]]--
    [`weapon_microsmg`] = {['weaponName'] = 'Micro SMG', ['type'] = 'SMG'},
    [`weapon_smg`] = {['weaponName'] = 'SMG', ['type'] = 'SMG'},
    [`weapon_smg_mk2`] = {['weaponName'] = 'SMG Mk II', ['type'] = 'SMG'},
    [`weapon_assaultsmg`] = {['weaponName'] = 'Assault SMG', ['type'] = 'SMG'},
    [`weapon_combatpdw`] = {['weaponName'] = 'Combat PDW', ['type'] = 'SMG'},
    [`weapon_machinepistol`] = {['weaponName'] = 'Machine Pistol', ['type'] = 'SMG'},
    [`weapon_minismg`] = {['weaponName'] = 'Mini SMG', ['type'] = 'SMG'},
    [`weapon_raycarbine`] = {['weaponName'] = 'Unholy Hellbringer', ['type'] = 'SMG'},
    --[[ Shotguns ]]--
    [`weapon_pumpshotgun`] = {['weaponName'] = 'Pump Shotgun', ['type'] = 'Shotgun'},
    [`weapon_pumpshotgun_mk2`] = {['weaponName'] = 'Pump Shotgun Mk II', ['type'] = 'Shotgun'},
    [`weapon_sawnoffshotgun`] = {['weaponName'] = 'Sawed-Off Shotgun', ['type'] = 'Shotgun'},
    [`weapon_assaultshotgun`] = {['weaponName'] = 'Assault Shotgun', ['type'] = 'Shotgun'},
    [`weapon_bullpupshotgun`] = {['weaponName'] = 'Bullpup Shotgun', ['type'] = 'Shotgun'},
    [`weapon_musket`] = {['weaponName'] = 'Musket', ['type'] = 'Shotgun'},
    [`weapon_heavyshotgun`] = {['weaponName'] = 'Heavy Shotgun', ['type'] = 'Shotgun'},
    [`weapon_dbshotgun`] = {['weaponName'] = 'Double Barrel Shotgun', ['type'] = 'Shotgun'},
    [`weapon_autoshotgun`] = {['weaponName'] = 'Sweeper Shotgun', ['type'] = 'Shotgun'},
    --[[ Assault Rifle ]]--
    [`weapon_assaultrifle`] = {['weaponName'] = 'Assault Rifle', ['type'] = 'Rifle'},
    [`weapon_assaultrifle_mk2`] = {['weaponName'] = 'Assault Rifle Mk II', ['type'] = 'Rifle'},
    [`weapon_carbinerifle`] = {['weaponName'] = 'Carbine Rifle', ['type'] = 'Rifle'},
    [`weapon_carbinerifle_mk2`] = {['weaponName'] = 'Carbine Rifle Mk II', ['type'] = 'Rifle'},
    [`weapon_762`] = {['weaponName'] = 'Carbine Rifle Mk II', ['type'] = 'Rifle'},
    [`weapon_advancedrifle`] = {['weaponName'] = 'Advanced Rifle', ['type'] = 'Rifle'},
    [`weapon_specialcarbine`] = {['weaponName'] = 'Special Carbine', ['type'] = 'Rifle'},
    [`weapon_specialcarbine_mk2`] = {['weaponName'] = 'Special Carbine Mk II', ['type'] = 'Rifle'},
    [`weapon_bullpuprifle`] = {['weaponName'] = 'Bullpup Rifle', ['type'] = 'Rifle'},
    [`weapon_bullpuprifle_mk2`] = {['weaponName'] = 'Bullpup Rifle Mk II', ['type'] = 'Rifle'},
    [`weapon_compactrifle`] = {['weaponName'] = 'Compact Rifle', ['type'] = 'Rifle'},
    [`weapon_heavyrifle`] = {['weaponName'] = 'Heavy Rifle', ['type'] = 'Rifle'},
    [`weapon_tacticalrifle`] = {['weaponName'] = 'M16 Rifle', ['type'] = 'Rifle'},
    --[[ LMG ]]--
    [`weapon_mg`] = {['weaponName'] = 'MG', ['type'] = 'LMG'},
    [`weapon_combatmg`] = {['weaponName'] = 'Combat MG', ['type'] = 'LMG'},
    [`weapon_combatmg_mk2`] = {['weaponName'] = 'Combat MG Mk II', ['type'] = 'LMG'},
    [`weapon_gusenberg`] = {['weaponName'] = 'Gusenberg Sweeper', ['type'] = 'LMG'},
    --[[ Snooper Rifle ]]--
    [`weapon_sniperrifle`] = {['weaponName'] = 'Sniper Rifle', ['type'] = 'Snooper Wifle'},
    [`weapon_heavysniper`] = {['weaponName'] = 'Heavy Rifle', ['type'] = 'Snooper Wifle'},
    [`weapon_heavysniper_mk2`] = {['weaponName'] = 'Heavy Sniper Mk II', ['type'] = 'Snooper Wifle'},
    [`weapon_marksmanrifle`] = {['weaponName'] = 'Marksman Rifle', ['type'] = 'Snooper Wifle'},
    [`weapon_marksmanrifle_mk2`] = {['weaponName'] = 'Marksman Rifle Mk II', ['type'] = 'Snooper Wifle'},
    --[[ Heavy Weapons ]]--
    [`weapon_rpg`] = {['weaponName'] = 'RPG (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_grenadelauncher`] = {['weaponName'] = 'Grenade Launcher (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_grenadelauncher_smoke`] = {['weaponName'] = 'Grenade Launcher Smoke (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_minigun`] = {['weaponName'] = 'Minigun (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_firework`] = {['weaponName'] = 'Firework Launcher (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_railgun`] = {['weaponName'] = 'Railgun (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_hominglauncher`] = {['weaponName'] = 'Homing Launcher (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_compactlauncher`] = {['weaponName'] = 'Compact Grenade Launcher (BAN)', ['type'] = 'Heavy Weapon'},
    [`weapon_rayminigun`] = {['weaponName'] = 'Widowmaker (BAN)', ['type'] = 'Heavy Weapon'},
    --[[ Throwable ]]--
    [`weapon_grenade`] = {['weaponName'] = 'Grenade', ['type'] = 'Throwable'},
    [`weapon_bzgas`] = {['weaponName'] = 'BZ Gas', ['type'] = 'Throwable'},
    [`weapon_molotov`] = {['weaponName'] = 'Molotov Cocktail', ['type'] = 'Throwable'},
    [`weapon_stickybomb`] = {['weaponName'] = 'Sticky Bomb', ['type'] = 'Throwable'},
    [`weapon_proxmine`] = {['weaponName'] = 'Proximity Mines', ['type'] = 'Throwable'},
    [`weapon_snowball`] = {['weaponName'] = 'Snowball(s)', ['type'] = 'Throwable'},
    [`weapon_pipebomb`] = {['weaponName'] = 'Pipe Bombs', ['type'] = 'Throwable'},
    [`weapon_ball`] = {['weaponName'] = 'Baseball', ['type'] = 'Throwable'},
    [`weapon_smokegrenade`] = {['weaponName'] = 'Tear Gas', ['type'] = 'Throwable'},
    [`weapon_flare`] = {['weaponName'] = 'Flare', ['type'] = 'Throwable'},
    --[[ Misc ]]--
    [`weapon_petrolcan`] = {['weaponName'] = 'Jerry Can', ['type'] = 'Miscellaneous'},
    [`gadget_parachute`] = {['weaponName'] = 'Parachute', ['type'] = 'Miscellaneous'},
    [`weapon_fireextinguisher`] = {['weaponName'] = 'Fire Extinguisher', ['type'] = 'Miscellaneous'},
    [`weapon_hazardcan`] = {['weaponName'] = 'Hazardous Jerry Can', ['type'] = 'Miscellaneous'},
    --[[ Vehicle ]]--
    [`VEHICLE_WEAPON_ROTORS`] = {['weaponName'] = 'Vehicle Rotors', ['type'] = 'Vehicle'},
    [`WEAPON_RUN_OVER_BY_CAR`] = {['weaponName'] = 'Run over by car', ['type'] = 'Vehicle'},
}

--[[
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source
	local DeathReason = data.weaponhash

	if Weapons[DeathReason] then
        DeathReason = Weapons[DeathReason]['weaponName']..' ('..Weapons[DeathReason]['type']..')'
    end

	if data['killervehname'] == "" then
		data['killervehname'] = "Unknown"
	end

    if victim then
        local name = GetPlayerName(victim)
        if name then
            local msg = "Name: **"..name.."** (**"..victim.."**)\nBy Player: **True** ("..killedBy.." "..GetPlayerName(killedBy)..")\nDeath Coords: **"..GetEntityCoords(GetPlayerPed(victim)).."**\nDeath Cause: **"..DeathReason.."**\nVehicle: **"..data['killervehname'].."** (**"..data['killervehseat'].."**)\nMelee Modifier: **"..GetPlayerMeleeWeaponDamageModifier(killedBy).."**\nWeapon Modifier: **"..GetPlayerWeaponDamageModifier(killedBy).."**"            
            ----exports[drp_adminmenu']:sendToDiscord('Player Death', msg, "16731983", "")
        end
    end
end)

AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos, discordlog)
	local victim = source
	if discordlog then
		local msg = "Name: **"..GetPlayerName(victim).." **(**"..victim.."**)\nBy Player: **No**\nDeath Coords: **"..GetEntityCoords(GetPlayerPed(victim)).."**\nDeath Cause: **Self**"
		----exports[drp_adminmenu']:sendToDiscord('Player Death', msg, "16732048", "")
	end
end)]]