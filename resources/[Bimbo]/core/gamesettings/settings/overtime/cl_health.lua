BodyPartsCache = {}
LastBloodLoss = 0.0
LastClothing = {}
LastInjuryEvents = {}
LastNotify = 0
LastReported = 0
RequestingInjuries = false
ShouldUpdate = true
TotalLegDamage = 0.0
Modifier = 1.0

Info = {
	bones = {},
	bloodLoss = 0.0,
	isHemorrhaging = false,
}

--[[ Initialization ]]--
for bone, info in pairs(Config.BodyParts) do
	if info.Fallback == nil then
		BodyPartsCache[#BodyPartsCache + 1] = bone
	end
end

local get_game_timer = GetGameTimer
local table_unpack = table.unpack
local math_ceil = math.ceil
local wait = Wait
local shake_gameplay_cam = ShakeGameplayCam
local math_floor = math.floor
local math_random = math.random
local math_max =  math.max
local math_min = math.min
local send_nui_message = SendNUIMessage
local is_ped_running = IsPedRunning
local is_ped_walking = IsPedWalking
local is_ped_jumping = IsPedJumping
local is_ped_sprinting = IsPedSprinting
local get_ped_max_health = GetPedMaxHealth
local set_entity_health = SetEntityHealth
local set_ped_max_health = SetPedMaxHealth
local animpost_fx_play = AnimpostfxPlay
local is_ped_dead_or_dying = IsPedDeadOrDying
local set_ped_to_ragdoll = SetPedToRagdoll
local has_anim_set_loaded = HasAnimSetLoaded
local request_anim_set = RequestAnimSet
local set_ped_movement_clipset = SetPedMovementClipset
local trigger_event = TriggerEvent
local does_entity_exist = DoesEntityExist
local set_nui_focus = SetNuiFocus
local set_nui_focus_keep_input = SetNuiFocusKeepInput
local disable_control_action = DisableControlAction
local type = type
local table_insert = table.insert
local get_weapon_damage_type = GetWeaponDamageType
local get_ped_last_damage_bone = GetPedLastDamageBone
local get_entity_health = GetEntityHealth
local pairs = pairs
function nonstop_Injuries()
	CreateThread(function()
		while nonstopcombat do
			wait(1000)
			ShouldUpdate = false

	        set_ped_max_health(PlayerPed, 200)
			ProcessGeneralInjury()
			ProcessHeadInjury()
			ProcessLegInjury()
			ProcessWalkStyle()
			ProcessNotifications()
	
			if ShouldUpdate then
				UpdateInfo()
			end
		end
	end)
end
--[[ Functions: Processing ]]--
function ProcessGeneralInjury()
	-- Bleeding and hemorrhaging.
	Info.isHemorrhaging = false

	LastBloodLoss = 0.0
	TotalLegDamage = 0.0

	for bone, info in pairs(Info.bones) do
		local bodyPart = Config.BodyParts[bone]
		-- Clotting.
		local clotted = info.clotted or 0.0
		local clot = math_max(1.0 - clotted, 0.0)
		if clotted > 0 then
			clotted = clotted - Config.Bleeding.UnclotRate
			info.clotted = clotted
		end
		-- Bleeding.
		local bleed = info.bleed or 0.0
		if bleed > 0 then
			if info.damage <= 0.99 then
				DamageBone(bone, 0.01)
			end
			if info.hemorrhaging and info.hemorrhaging > 0.0 then
				bleed = math_min(bleed + info.hemorrhaging * clot, 1.0)
				Info.isHemorrhaging = true
			else
				bleed = math_max(bleed - Config.Bleeding.ClotRate * GetRandomFloatInRange(math_min(clotted, 1.0), 1.0), 0.0)
			end
			info.bleed = bleed
			LastBloodLoss = LastBloodLoss + bleed * clot
			ShouldUpdate = true
		end
		-- Foot stuff.
		if bodyPart.Limp then
			TotalLegDamage = TotalLegDamage + bodyPart.Limp * (info.damage or 0.0)
		end
		if info.damage < Config.Healing.MaxDamage and info.damage >= 0.001 then
			local amount = Config.Healing.Amount
			local comfort = GetEffect("Comfort")

			if comfort > 0.001 then
				local min, max = table_unpack(Config.Modifiers.Healing)
				amount = amount * ((max - min) * comfort + min)
			end

			info.damage = math_max(info.damage - amount, 0.0)
			ShouldUpdate = true
		end
	end

	-- Blood loss.
	 --print(("Blood loss: %s	Last blood loss: %s"):format(BloodLoss, LastBloodLoss))
	Info.bloodLoss = (Info.bloodLoss or 0.0) + LastBloodLoss

	if Info.bloodLoss > 1.0 then
		Slay()
	else
		Info.bloodLoss = math_max(Info.bloodLoss - Config.Bleeding.HealRate, 0.0)
	end

    --[[ dont work for some erason sad
	if Info.bloodLoss > 0.01 then
    SetTimecycleModifier("li")
    SetTimecycleModifierStrength(Info.bloodLoss)
	end]]
end

local function get_random_float_in_range(min, max)
    return min + math_random() * (max - min)
end

local function get_random_int_in_range(min, max)
    return math_floor(min + math_random() * (max - min + 1))
end

function ProcessHeadInjury()
	if get_game_timer() - (LastInjuryEvents.Head or 0) < 8000 then return end
	LastInjuryEvents.Head = get_game_timer()

	local ped = PlayerPed

	-- Head injuries.
	local headBone = 31086
	local head = Info.bones[headBone]
	if head then
		local concussion = head.concussion or 0.0

		-- Healing.
		if concussion > 0.001 and get_random_float_in_range(0.0, 1.0) < Config.Concussions.HealChance then
			concussion = math_max(concussion - Config.Concussions.HealAmount, 0.0)
			if concussion <= 0.001 then
				exports['drp-notifications']:SendAlert('inform', 'Your head feels clear again.', 1500)
				concussion = 0.0
			end
			head.concussion = concussion
		end

		-- Passing out.
		if concussion > Config.Concussions.PassoutThreshold and get_random_float_in_range(0.0, 1.0) < Config.Concussions.PassoutChance * concussion then
			exports['drp-notifications']:SendAlert('inform', 'Your head is pulsing!', 1500)
			animpost_fx_play("CamPushInMichael", 3000, true)
			DamageBone(headBone, Config.Concussions.DamageAmount * concussion)
			UpdateInfo()
			CheckBones()

			if is_ped_dead_or_dying(ped) then
				return
			end

			wait(3000)

			local ragdollTime = 500
			local ragdollType = 0
			local alert = nil
			local isJumping = is_ped_jumping(ped)

			if is_ped_walking(ped) and not isJumping then
				ragdollTime = 500
				ragdollType = 2
				alert = "You almost pass out..."
			elseif is_ped_running(ped) and not isJumping then
				ragdollTime = 750
				ragdollType = 2
				alert = "Your mind is becoming hazy..."
			elseif is_ped_sprinting(ped) or isJumping then
				ragdollTime = 2000
				ragdollType = 3
				alert = "Your mind goes blank for a second..."
			else
				alert = "You're having trouble staying conscious..."
			end

			shake_gameplay_cam("JOLT_SHAKE", 1.0)
			set_ped_to_ragdoll(ped, ragdollTime, 0, ragdollType, true, true, false)

			if alert then
				exports['drp-notifications']:SendAlert('inform', alert, 1500)
			end
		end
	end
end

function ProcessLegInjury()
	local ped = PlayerPed
	local isJumping = is_ped_jumping(ped)

	if is_ped_sprinting(ped) or isJumping then
		local shouldUpdate = false
		local damage = Config.Limping.SprintingDamage

		-- Bone damage.
		if isJumping then
			damage = damage * Config.Limping.JumpingDamage
		end

		for bone, info in pairs(Info.bones) do
			local bodyPart = Config.BodyParts[bone]
			if (bodyPart.Limp or 0.0) > 0.01 and (info.damage or 0.0) > 0.1 then
				DamageBone(bone, damage, "blunt")
				SpreadDamage(bone, damage, 0.8)
				shouldUpdate = true
			end
		end
		if shouldUpdate then
			CheckBones()
			UpdateInfo()

			if get_game_timer() - LastNotify > 7000 then
				exports['drp-notifications']:SendAlert('inform', 'You feel a sharp pain in your lower body!', 1500)
				LastNotify = get_game_timer()
			end
		end
	end

	-- Staggering.
	if get_game_timer() - (LastInjuryEvents.Stagger or 0) > 8000 then
		LastInjuryEvents.Stagger = get_game_timer()

		if TotalLegDamage > 0.01 and get_random_float_in_range(0.0, 1.0) < Config.Limping.StaggerChance * TotalLegDamage then
			local alert, ragdollTime, ragdollType

			if (is_ped_sprinting(ped) or is_ped_running(ped) or isJumping) and TotalLegDamage > 1.0 then
				ragdollTime = 4000
				ragdollType = 0
				alert = "You have trouble standing..."
			elseif is_ped_running(ped) or isJumping then
				ragdollTime = 500
				ragdollType = 2
				alert = "You have trouble keeping balance..."
			end

			if ragdollType then
				shake_gameplay_cam("JOLT_SHAKE", 1.0)
				set_ped_to_ragdoll(ped, ragdollTime, 0, ragdollType, true, true, false)
				exports['drp-notifications']:SendAlert('inform', alert, 1500)
			end
		end
	end
end

CurrentWalkStyle = nil
OverrideWalkStyle = nil
WalkStyles = {
	["drunk"] = { Name = "move_m@drunk@slightlydrunk" },
	["drunk2"] = { Name = "move_m@drunk@moderatedrunk" },
	["drunk3"] = { Name = "move_m@drunk@verydrunk" },
	["injured"] = { Name = "move_m@injured" },
}

function SetCustomWalkStyle(name)
	OverrideWalkStyle = name
	if name == nil then
		SetWalkStyle(CurrentWalkStyle)
	else
		SetWalkStyle(name)
	end
end

function SetWalkStyle(name)
	if OverrideWalkStyle ~= nil and OverrideWalkStyle ~= name then return end
	
    local plyPed = PlayerPed
	if not name or name:lower() == "reset" then
		ResetPedMovementClipset(plyPed, 1.0)
		CurrentWalkStyle = nil
		return
	end

	local walkStyle = WalkStyles[name]
	if not walkStyle then return end
	
	Citizen.CreateThread(function()
		while not has_anim_set_loaded(walkStyle.Name) do request_anim_set(walkStyle.Name) wait(1) end

		if OverrideWalkStyle == nil then
			CurrentWalkStyle = name
		end
		set_ped_movement_clipset(plyPed, walkStyle.Name, 1.0)
	end)
end

function ProcessWalkStyle()
	local walkStyle = nil
	local bloodLoss = Info.bloodLoss
	if bloodLoss > 0.7 then
		walkStyle = "drunk3"
	elseif bloodLoss > 0.4 then
		walkStyle = "drunk2"
	elseif bloodLoss > 0.1 then
		walkStyle = "drunk"
	elseif TotalLegDamage > Config.Limping.InjuredDamage then
		walkStyle = "injured"
	end
	if walkStyle then
		SetCustomWalkStyle(walkStyle)
	end
end

function ProcessNotifications()
	if get_game_timer() - LastNotify < 12000 then
		return
	end

	-- Notifications.
	local notify = nil
	local bloodLoss = Info.bloodLoss

	if bloodLoss > 0.9 then
		notify = "are having trouble staying conscious..."
	elseif bloodLoss > 0.8 then
		notify = "feel very weak..."
	elseif bloodLoss > 0.6 then
		notify = "feel very light headed..."
	elseif bloodLoss > 0.4 then
		notify = "feel a little weak!"
	elseif bloodLoss > 0.2 then
		notify = "feel light headed..."
	end

	if LastBloodLoss and LastBloodLoss >= 0.001 then
		if notify then
			notify = " and you "..notify
		else
			notify = "!"
		end
		if Info.isHemorrhaging then
			notify = "Blood is gushing from your wounds"..notify
		else
			notify = "You are bleeding from your wounds"..notify
		end
	elseif notify then
		notify = "You "..notify
	end

	if notify then
		LastNotify = get_game_timer()
		exports['drp-notifications']:SendAlert('inform', notify, 1500)
	end
end

--[[ Functions ]]--
function TakeDamage(amount, bone, weapon)
    local ped = PlayerPed
	set_entity_health(ped, get_entity_health(ped) - amount)
	trigger_event("gameEventTriggered", "CEventNetworkEntityDamage", { ped, ped, 0, 0, 0, bone or 0, weapon })
end

function ArmorUp(amount, _type)
	local bones
	if _type == 1 then
		bones = { 24817, 24818, 64729, 10706, 11816, 40269, 45509 }
	elseif _type == 2 then
		bones = { 31086 }
	else
		bones = { 24817, 24818, 64729, 10706 }
	end
	for _, bone in pairs(bones) do
		local boneInfo = Info.bones[bone]
		local boneSettings = Config.BodyParts[bone]
		if not boneInfo then
			boneInfo = {
				injuries = {},
				damage = 0.0,
			}
			Info.bones[bone] = boneInfo
		end
		boneInfo.armor = math_min((boneInfo.armor or 0.0) + amount, boneSettings.MaxArmor or 1.0)
	end
	UpdateInfo()
end

function ClearArmor()
	for bone, info in pairs(Info.bones) do
		info.armor = nil
	end
	UpdateInfo()
end
exports("ClearArmor", ClearArmor)

function HealPed()
	local ped = PlayerPedId()
	local health = get_ped_max_health(ped)
	set_entity_health(ped, health)

	for boneId, boneInfo in pairs(Info.bones) do
		local armor = boneInfo.armor
		if armor and armor > 0.001 then
			boneInfo = { armor = armor, damage = 0.0 }
		else
			boneInfo = nil
		end
		Info.bones[boneId] = boneInfo
	end

	Info.bloodLoss = 0.0
	Info.isHemorrhaging = false

	ClearEffects()
	UpdateInfo()

	SetCustomWalkStyle("reset")
end

function UpdateInfo(check, target, info)
	if not does_entity_exist(PlayerPed) then return end

	if check then
		set_nui_focus(true, true)
		set_nui_focus_keep_input(false)
	end

	send_nui_message({
		info = info or Info,
		check = check
	})
end

function GetDamageValue()
	local value = 0.0
	for bone, info in pairs(Info.bones) do
		value = value + info.damage
	end
	return value
end

function Impact(intensity)
	local bones = { 31086, 24818, 24817, 11816 }
	local bone = bones[get_random_int_in_range(1, #bones)]

	intensity = intensity or get_random_int_in_range(0.0, 1.0)

	if intensity > 0.2 then
		SetFlash(0, 0, 500, 0, 1000)
	end

	shake_gameplay_cam("JOLT_SHAKE", 3.0 * intensity)
	TakeDamage(math_floor(intensity * 30), bone, "WEAPON_FALL")

	Citizen.CreateThread(function()
		local startTime = get_game_timer()
		while get_game_timer() - startTime < math_ceil(2000 * intensity) do
			for k, v in pairs({ 21, 22, 23, 24, 25, 26, 71, 72, 73, 75, 86, 87, 88, 89, 90, 91, 92, 102 }) do
				disable_control_action(0, v, true)
			end
			wait(0)
		end
	end)
end

function Edible()
    for bone, info in pairs(Info.bones) do
        if info.damage and info.damage > 0.3 then
            info.damage = 0.0
        end
    end
    ResurrectPed()
    local ped = PlayerPedId()
	local health = get_ped_max_health(ped)
	set_entity_health(ped, health)
    UpdateInfo()
end
exports("Edible", Edible)

function Joint()
    ResetPedMovementClipset(PlayerPed, 1.0)
    exports['core']:AddEffect("Armor", GetRandomFloatInRange(0.6, 0.9))
    exports['core']:AddEffect("Comfort", GetRandomFloatInRange(0.4, 0.8))
    exports['core']:AddEffect("Drug", 0.7)
    UpdateInfo()
end
exports("Joint", Joint)

function DoOxy()
    for bone, info in pairs(Info.bones) do
        if info.damage and info.damage > 0.1 then
            info.damage = math_max(info.damage - get_random_float_in_range(Config.Bandaging.InstantHealth[1], Config.Bandaging.InstantHealth[2]), 0.0)
        end
    end
end
exports("DoOxy", DoOxy)

function Gauze()
	for bone, info in pairs(Info.bones) do
        if info.damage and info.damage > 0.5 and info.damage < Config.Healing.MaxDamage then
            info.damage = math_max(info.damage - get_random_float_in_range(Config.Bandaging.InstantHealth[1], Config.Bandaging.InstantHealth[2]), 0.0)
        end

        if info.bleed and info.bleed > 0.05 then
            info.bleed = math_max(info.bleed - 0.1, 0.0)
        end

        if info.hemorrhaging and info.hemorrhaging > 0.0 then
            info.hemorrhaging = info.hemorrhaging - 0.5
            if info.hemorrhaging <= 0.0 then
                info.hemorrhaging = nil
            end
        end

        local clotted = info.clotted or 0.0
        info.clotted = clotted + (1.0 / (clotted + 1.5))

        UpdateInfo()
	end
end
exports("Gauze", Gauze)

function DamageBone(bone, damage, injury)
	local bodyPart = Config.BodyParts[bone]
	if not bodyPart then return end

	if not Info.bones[bone] then
		Info.bones[bone] = {}
		Info.bones[bone].injuries = {}
	end
    if not Info.bones[bone].injuries then
        Info.bones[bone].injuries = {}
    end

	local boneInfo = Info.bones[bone]
	local boneDamage = boneInfo.damage or 0

	boneDamage = math_max(boneDamage + damage, 0.0)
	boneInfo.damage = boneDamage

	local clotted = boneInfo.clotted
	if clotted ~= nil and clotted > 0 then
		clotted = math_max(clotted - damage, 0.0)
		boneInfo.clotted = clotted
	end

	if injury then
		local injuryInfo = Config.Injuries[injury]

        local injuries = boneInfo.injuries[injury]
        if not injuries then
            boneInfo.injuries[injury] = {
				occurrences = {}
			}
        end


		injuries = boneInfo.injuries[injury]
		injuries.totalDamage = (injuries.totalDamage or 0.0) + boneDamage

		local occurrence = {
			time = get_game_timer(),
			damage = boneDamage,
		}

		if injury == "gsw" then
			occurrence.show = true
			occurrence.text = ("%s (%s)"):format(injuryInfo.Name, "556_rounds")
		elseif injuryInfo.UseIntensity then
			for k, intensity in pairs(Config.Intensities) do
				if injuries.totalDamage >= intensity[1] then
					injuries.text = intensity[2]:format(injuryInfo.Name)
					break
				end
			end
		else
			injuries.text = injuryInfo.Name
		end

		table_insert(injuries.occurrences, occurrence)

		-- table.insert(boneInfo.injuries, injuries)

		if type(injury) == "string" then
			local injuryInfo = Config.Injuries[injury] or {}
			boneInfo.bleed = (boneInfo.bleed or 0.0) + (injuryInfo.Bleed or 0.0) * damage

			-- Hemorrhaging.
			if injuryInfo.Hemorrhaging and injuryInfo.HemorrhagingChance > get_random_float_in_range(0.0, 1.0) * damage then
				boneInfo.hemorrhaging = (boneInfo.hemorrhaging or 0.0) + (injuryInfo.Hemorrhaging or 1.0) * damage
			end
			-- Concussions.
			if bodyPart.Concussion and injuryInfo.Concussion then
				boneInfo.concussion = (boneInfo.concussion or 0.0) + injuryInfo.Concussion * damage
			end
		end
	end
end

function SpreadDamage(bone, damage, spread)
	local bodyPart = Config.BodyParts[bone]
	if not bodyPart.Nearby then return end
	for k, v in pairs(bodyPart.Nearby) do
		DamageBone(v, damage * spread)
	end
end

function CheckBones()
	local fatal = 0.0

	for bone, info in pairs(Info.bones) do
		local bodyPart = Config.BodyParts[bone]
		fatal = fatal + info.damage * (bodyPart.Fatal or 0.0)
	end

	if fatal >= 0.999 then
		Slay()
		return true
	end
	return false
end

function RandomBone()
	return BodyPartsCache[get_random_int_in_range(1, #BodyPartsCache)]
end

damageEventHandler = nil
function nonstop_damageHandler()
    damageEventHandler = AddEventHandler("gameEventTriggered", function(name, args)
        if not nonstopcombat then return end
        if name ~= "CEventNetworkEntityDamage" then return end
        local ped = PlayerPed
        local targetEntity, sourceEntity, _, _, _, boneOverride, weaponUsed = table_unpack(args)
        if sourceEntity == -1 then return end
    
        if ped ~= targetEntity then
            return
        end
    
        local damageType = get_weapon_damage_type(weaponUsed)
    
        local retval, bone = get_ped_last_damage_bone(targetEntity)
    
        LastWeaponUsed = weaponUsed
    
        -- Injury.
        local injury = nil
    
        if damageType == 2 then
            -- Melee (blunt or stab).
            -- Don't set injury, let it be per weapon.
        elseif damageType == 3 then
            -- Bullet.
            injury = "gsw"
        elseif damageType == 4 then
            -- Force ragdoll fall (bruising/broken bones).
            injury = "blunt"
        elseif damageType == 5 then
            -- Explosive.
            injury = "burn3"
            retval = true
            bone = RandomBone()
        elseif damageType == 6 then
            -- Fire.
            injury = "burn2"
            retval = true
            bone = RandomBone()
        elseif damageType == 8 then
            -- WEAPON_HELI_CRASH.
            injury = "blunt"
        elseif damageType == 10 then
            -- Eletric.
            injury = "burn2"
        elseif damageType == 11 then
            -- Barbed wire.
            injury = "scrapes"
        elseif damageType == 12 then
            -- Extinguisher.
            print("Ow, my lungs!")
        elseif damageType == 13 then
            -- Gas.
            injury = "gas"
        elseif damageType == 14 then
            -- Water cannon.
            injury = "blunt"
        end
    
        if not injury then
            injury = "blunt"
        end
    
        -- Bone defaults.
        if boneOverride ~= 0 and boneOverride ~= nil and Config.BodyParts[boneOverride] then
            bone = boneOverride
        elseif not retval then
            bone = RandomBone()
        end
    
        -- Body parts.
        local bodyPart = Config.BodyParts[bone]
    
        if bodyPart == nil then
            bone = 11816
            bodyPart = Config.BodyParts[11816]
        elseif bodyPart.Fallback then
            bone = bodyPart.Fallback
            bodyPart = Config.BodyParts[bodyPart.Fallback]
        end
    
        -- Damage.
        local maxHealth = get_ped_max_health(ped)
        local health = get_entity_health(ped)
    
        local damageTaken = maxHealth - health
    
        -- Damage.
        local damage = math_min(damageTaken / 100.0, 1.0) * Modifier
        local resistance = GetEffect("Armor")
    
        if resistance > 0.001 then
            local min, max = table_unpack(Config.Modifiers.Resistance)
            resistance = ((max - min) * resistance + min)
    
            damage = damage * resistance
        end
    
        -- Finally set health.
        --set_entity_health(ped, maxHealth)
    
        local injuries = nil
        if type(injury) == "table" then
            injuries = injury
        else
            injuries = { injury }
        end
    
        for k, injury in pairs(injuries) do
            local injuryInfo = Config.Injuries[injury]
            DamageBone(bone, damage * ((injuryInfo or {}).DamageMultiplier or 1.0), injury)
            if injuryInfo and injuryInfo.Spread ~= nil and damage > (injuryInfo.MinSpread or 0.0) then
                SpreadDamage(bone, damage, injuryInfo.Spread)
            end
        end
        UpdateInfo()
    end)    

end


RegisterNetEvent("health:status")
AddEventHandler("health:status", function(type)
	UpdateInfo(type ~= 0)
end)