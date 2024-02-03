Effects = { Thirst = 0.0, Hunger = 0.0 }
NextShake = 0
Affliction = 0.0

local lastBac = 0.0
local wasInVehicle = false
local notified = {}

--[[ Threads ]]--

local get_game_timer = GetGameTimer
local table_unpack = table.unpack
local math_ceil = math.ceil
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local math_abs = math.abs
local wait = Wait
local do_screen_fade_out = DoScreenFadeOut
local do_screen_fade_in = DoScreenFadeIn
local shake_gameplay_cam = ShakeGameplayCam
local math_floor = math.floor
local math_random = math.random
local math_max = math.max
local math_min = math.min
local send_nui_message = SendNUIMessage
local is_ped_sprinting = IsPedSprinting
local is_ped_running = IsPedRunning
local is_ped_walking = IsPedWalking
local pairs = pairs
function nonstop_Effects()
	Citizen.CreateThread(function()
		local lastUpdate = get_game_timer()
		local interval = 1000.0
        Affliction = 0.0

		while nonstopcombat do			
			local delta = (get_game_timer() - lastUpdate) / 1000.0
			local notified = false
			
			for effect, settings in pairs(Config.Effects) do
				local value = Effects[effect] or 0.0
				if settings.Passive and ((settings.Passive > 0.0 and value < (settings.Max or 1.0)) or (settings.Passive < 0.0 and value > (settings.Min or 0.0))) then
					local amount = settings.Passive * delta
					if settings.Modifier then
						amount = _G[settings.Modifier](amount)
					end
					AddEffect(effect, amount)
				end
				if settings.Damage and value >= (settings.DamageAt or 1.0) then
					local damage, bone, weapon = table_unpack(settings.Damage)
					damage = math_ceil(damage * delta)
	
					TakeDamage(damage, bone, weapon)
				end
				if settings.Afflict and value >= settings.Afflict then
					local intensity = (value - settings.Afflict) / (settings.Max - settings.Afflict)
					Affliction = Affliction + intensity
				end
				if settings.Notify and value >= math_min(settings.Afflict or 1.0, settings.DamageAt or 1.0) and get_game_timer() - LastNotify > 12000 then
					exports['drp-notifications']:SendAlert('inform', settings.Notify, 1500)
					notified = true
				end
			end
	
			if notified then
				LastNotify = get_game_timer()
			end
			
			lastUpdate = get_game_timer()
	
			local bac = Effects["Bac"] or 0.0
			local isInVehicle = is_ped_in_any_vehicle(PlayerPed, false)
			if math_abs(lastBac - bac) > 0.1 or (bac <= 0.01 and lastBac >= 0.01) or (bac > 0.01 and isInVehicle ~= wasInVehicle) then
				do_screen_fade_out(500)
				wait(500)
				do_screen_fade_in(500)
	
				local mult = 2.0
				if isInVehicle then
					mult = 4.0
				end
				
				shake_gameplay_cam("DRUNK_SHAKE", bac * mult)
	
				local walkStyle = nil
				if bac >= 0.75 then
					walkStyle = "drunk3"
				elseif bac >= 0.5 then
					walkStyle = "drunk2"
				elseif bac > 0.01 then
					walkStyle = "drunk"
				end
	
				SetCustomWalkStyle(walkStyle)
			end
			lastBac = bac
			wasInVehicle = isInVehicle
	
			wait(math_floor(interval))
		end
	end)
end

local function get_random_float_in_range(min, max)
    return min + math_random() * (max - min)
end

local function get_random_int_in_range(min, max)
    return math_floor(min + math_random() * (max - min + 1))
end

function nonstop_Affliction()
	Citizen.CreateThread(function()
		while nonstopcombat do
			while Affliction <= 0.001 do
				wait(500)
			end
	
			local time = get_random_int_in_range(0, 500)
			wait(time)
	
			shake_gameplay_cam("VIBRATE_SHAKE", get_random_float_in_range(0.3, 0.6) * Affliction)
	
			-- if GetRandomFloatInRange(0.0, 1.0) < 0.1 then
			-- 	time = math.floor(GetRandomIntInRange(500, 1000) * (Affliction * 0.5 + 0.5))
	
			-- 	DoScreenFadeOut(time)
			-- 	Citizen.Wait(math.floor(time / 2))
			-- 	DoScreenFadeIn(time)
			-- end
	
			wait(get_random_int_in_range(1000, 2000))
		end
	end)
end

--[[ Functions ]]--
function AddEffect(name, amount)
	local effect = Effects[name] or 0.0
	local notify = notified[name]
	local settings = Config.Effects[name]

	effect = math_max(math_min(effect + amount, settings.Max or 1.0), settings.Min or 0.0)
	Effects[name] = effect
	
	if not notify or math_abs(effect - notify) >= 0.1 then
		UpdateInfo()
		notified[name] = effect
	end
	send_nui_message({ addEffect = { name = name, amount = effect } })
end
exports("AddEffect", AddEffect)

function GetEffect(name)
	return Effects[name] or 0.0
end
exports("GetEffect", GetEffect)

function ClearEffect(name)
	UpdateInfo()
	Effects[name] = nil
	send_nui_message({ clearEffect = name })
end
exports("ClearEffect", ClearEffect)

function ClearEffects()
	Effects = {}
	Affliction = 0.0
	
	send_nui_message({ clearEffects = true })
	UpdateInfo()
end
exports("ClearEffects", ClearEffects)

function BasicEffectModifier(value)
	local ped = PlayerPed

	-- Movement modifiers.
	if is_ped_sprinting(ped) then
		value = 1.5 * value
	elseif is_ped_running(ped) then
		value = 1.25 * value
	elseif not is_ped_walking(ped) then
		value = 0.5 * value
	end

	-- Return value.
	return value
end