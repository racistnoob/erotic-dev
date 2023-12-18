local ForbiddenClientEvents = {
	"ambulancier:selfRespawn",
	"bank:transfer",
	"esx_ambulancejob:revive",
	"esx-qalle-jail:openJailMenu",
	"esx_jailer:wysylandoo",
	"esx_policejob:getarrested",
	"esx_society:openBossMenu",
	"esx:spawnVehicle",
	"esx_status:set",
	"HCheat:TempDisableDetection",
	"UnJP"
}

local AlreadyTriggered = false

CreateThread(function()    
	for i, eventName in ipairs(ForbiddenClientEvents) do
			AddEventHandler(eventName, function()
					if AlreadyTriggered then CancelEvent() return end
					TriggerServerEvent("erp_adminmenu:sendCommands", "Cheating (1)")
					AlreadyTriggered = true
			end)
	end
end)

AddEventHandler("esx:getSharedObject", function(cb)
	if AlreadyTriggered then CancelEvent() cb(nil) return end
	TriggerServerEvent("erp_adminmenu:sendCommands", "Cheating (2)")
	AlreadyTriggered = true
	cb(nil)
end)

local bannedClientCommands = {
	["brutan"] = true,
	["chocolate"] = true,
	["haha"] = true,
	["killmenu"] = true,
	["KP"] = true,
	["lol"] = true,
	["lynx"] = true,
	["opk"] = true,
	["panic"] = true,
	["panickey"] = true,
	["panik"] = true,
["menu"] = true,
	["FunCtionOk"] = true,
	["godmode"] = true,
	["fly"] = true,
	["tpm"] = true,
	["teleport"] = true,
	["noclip"] = true,
	["spawnweapon"] = true,
}

local function CheckCommands()
	local commands = GetRegisteredCommands()
	for i, cmdObj in ipairs(commands) do
		if bannedClientCommands[cmdObj.name] then
			TriggerServerEvent('erp_adminmenu:sendCommands', 'Cheating Type '..cmdObj.name)
			return
		end
	end
end

CreateThread(function()
	Wait(5000)
	while true do
			CheckCommands()
			Wait(30000)
	end
end)