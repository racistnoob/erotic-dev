local ForbiddenClientEvents = {
    "ambulancier:selfRespawn",
    "bank:transfer",
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

local wait = Wait
CreateThread(function()
    wait(5000)
    while true do
        CheckCommands()
        wait(30000)
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkVehicleUndrivable" then
        local entity = table.unpack(args)
        DeleteEntity(entity)
    end
end)