local recoils = {
	-- Handguns
	[453432689] = 0.3,     --['weapon_pistol']
	[-1075685676] = 0.5,   --['weapon_pistol_mk2']
	[1593441988] = 0.2,    --['weapon_combatpistol']
	[584646201] = 0.3,     --['weapon_appistol']
	[911657153] = 0.1,     --['weapon_stungun']
	[-1716589765] = 0.6,   --['weapon_pistol50']
	[-1076751822] = 0.2,   --['weapon_snspistol']
	[-771403250] = 0.5,    --['weapon_heavypistol']
	[137902532] = 0.4,     --['weapon_vintagepistol']
	[1198879012] = 0.9,    --['weapon_flaregun']
	[-598887786] = 0.9,    --['weapon_marksmanpistol']
	[-1045183535] = 0.6,   --['weapon_revolver']
	[-879347409] = 0.6,    --['weapon_revolver_mk2']
	[-1746263880] = 0.3,   --['WEAPON_PYTHON']
	[-2009644972] = 0.3,   --['weapon_snspistol_mk2']
	[-1355376991] = 0.3,   --['weapon_raypistol']
	[727643628] = 0.3,     --['weapon_ceramicpistol']
	[-1853920116] = 0.3,   --['weapon_navyrevolver']
	[1470379660] = 0.3,    --['weapon_gadgetpistol']
	
	-- Submachine Guns
	[324215364] = 0.5,     --['weapon_microsmg']
	[736523883] = 0.4,     --['weapon_smg']
	[2024373456] = 0.1,    --['weapon_smg_mk2']
	[-270015777] = 0.1,    --['weapon_assaultsmg']
	[171789620] = 0.2,     --['weapon_combatpdw']
	[-619010992] = 0.3,    --['weapon_machinepistol']
	[-1121678507] = 0.1,   --['weapon_minismg']
	[1198256469] = 0.3,    --['weapon_raycarbine']
	
	-- Shotguns
	[487013001] = 0.4,     --['weapon_pumpshotgun']
	[2017895192] = 0.7,    --['weapon_sawnoffshotgun']
	[-494615257] = 0.4,    --['weapon_assaultshotgun']
	[-1654528753] = 0.2,   --['weapon_bullpupshotgun']
	[-1466123874] = 0.7,   --['weapon_musket']
	[984333226] = 0.2,     --['weapon_heavyshotgun']
	[-275439685] = 0.7,    --['weapon_dbshotgun']
	[317205821] = 0.2,     --['weapon_autoshotgun']
	[1432025498] = 0.4,    --['weapon_pumpshotgun_mk2']
	[94989220] = 0.0,      --['weapon_combatshotgun']
	
	-- Assault Rifles
	[-1074790547] = 0.5,   --['weapon_assaultrifle']
	[961495388] = 0.2,     --['weapon_assaultrifle_mk2']
	[-2084633992] = 0.3,   --['weapon_carbinerifle']
	[-86904375] = 0.1,     --['weapon_carbinerifle_mk2']
    [`weapon_762`] = 0.1,     --['weapon_carbinerifle_mk2']
	[-1357824103] = 0.1,   --['weapon_advancedrifle']
	[-1063057011] = 0.2,   --['weapon_specialcarbine']
	[2132975508] = 0.2,    --['weapon_bullpuprifle']
	[1649403952] = 0.3,    --['weapon_compactrifle']
	[-1768145561] = 0.2,   --['weapon_specialcarbine_mk2']
	[-2066285827] = 0.2,   --['weapon_bullpuprifle_mk2']
	[-1658906650] = 0.0,   --['weapon_militaryrifle']
	
	-- Light Machine Guns
	[-1660422300] = 0.1,   --['weapon_mg']
	[2144741730] = 0.1,    --['weapon_combatmg']
	[1627465347] = 0.1,    --['weapon_gusenberg']
	[-608341376] = 0.1,    --['weapon_combatmg_mk2']
	
	-- Sniper Rifles
	[100416529] = 0.5,    --['weapon_sniperrifle']
	[205991906] = 0.7,    --['weapon_heavysniper']
	[-952879014] = 0.3,   --['weapon_marksmanrifle']
	[856002082] = 1.2,    --['weapon_remotesniper']
	[177293209] = 0.6,    --['weapon_heavysniper_mk2']
	[1785463520] = 0.3,   --['weapon_marksmanrifle_mk2']
	
	-- Heavy Weapons
	[-1312131151] = 0.0,   --['weapon_rpg']
	[-1568386805] = 1.0,   --['weapon_grenadelauncher']
	[1305664598] = 1.0,    --['weapon_grenadelauncher_smoke']
	[1119849093] = 0.1,    --['weapon_minigun']
	[2138347493] = 0.3,    --['weapon_firework']
	[1834241177] = 2.4,    --['weapon_railgun']
	[1672152130] = 0.0,    --['weapon_hominglauncher']
	[125959754] = 0.5,     --['weapon_compactlauncher']
	[-1238556825] = 0.3,   --['weapon_rayminigun']
	
	--! CUSTOM WEAPONS
	--? PISTOLS
	[`weapon_m1911`] = 0.3,
	[`weapon_m9`] = 0.2,
	[`weapon_m45a1`] = 0.3,
	[`WEAPON_GLOCK17`] = 0.3,
	[`weapon_browning`] = 0.3,
	[`makarov`] = 0.2,
	
	--? ARS
	[`weapon_mpx`] = 0.4,
	[`weapon_scar`] = 0.5,
	[`weapon_ak74`] = 0.3,
	[`weapon_tacticalrifle`] = 0.2,
	[`weapon_mk47fm`] = 0.5,
	[`weapon_m4`] = 0.2,
	
	--? SMGS
	[`weapon_miniuzi`] = 0.5,
	[`weapon_minismg2`] = 0.5,
	[`weapon_microsmg2`] = 0.5,
	
	--? SHOTGUNS
	[`weapon_combatshotgun`] = 0.4
	
}

local wait = Wait
local is_ped_shooting = IsPedShooting
local is_ped_doing_driveby = IsPedDoingDriveby
local get_current_ped_weapon = GetCurrentPedWeapon
local get_gameplay_cam_relative_pitch = GetGameplayCamRelativePitch
local set_gameplay_cam_relative_pitch = SetGameplayCamRelativePitch
local get_follow_ped_cam_view_mode = GetFollowPedCamViewMode

-- Recoil
Recoil:RegisterMode('qb', function(self)
    local ped = PlayerPed
    if is_ped_shooting(ped) and not is_ped_doing_driveby(ped) then
        local _, wep = get_current_ped_weapon(ped)
        local recoil = recoils[wep]
    
        if recoil and recoil ~= 0 then
            local timeValue = 0
            local followCamMode = get_follow_ped_cam_view_mode()

            repeat
                wait(0)
                local pitch = get_gameplay_cam_relative_pitch()

                if followCamMode ~= 4 then
                    set_gameplay_cam_relative_pitch(pitch + 0.1, 0.2)
                    timeValue = timeValue + 0.1
                else
                    if recoil > 0.1 then
                        set_gameplay_cam_relative_pitch(pitch + 0.6, 1.2)
                        timeValue = timeValue + 0.6
                    else
                        set_gameplay_cam_relative_pitch(pitch + 0.016, 0.333)
                        timeValue = timeValue + 0.1
                    end
                end
            until (timeValue >= recoil) or (self.activeMode ~= 'qb')
        end
    end
end)
