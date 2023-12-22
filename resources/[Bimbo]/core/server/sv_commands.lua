Config = {}

Config.commands = {
    {
        commandName = "example",
        restricCommand = false,
        clientevent = "client:event:example",
        serverevent = "server:event:example",
        argsCount = 0,
        argsNil = "example",
        disable = true,
        targetSelf = true,  -- Set this to true to target only the player who called the command
        targetAll = true,  -- Set this to true to target only the player who called the command
    },
    {
        commandName = "dva",
        restricCommand = false,
        clientevent = "drp:scripts:vehwipe",
        argsCount = 0,
        disable = false,
        targetAll = true
    },
    {
        commandName = "car",
        restricCommand = false,
        clientevent = "drp:spawnvehicle",
        argsCount = 1,
        argsNil = "revolter",
        disable = false,
        targetSelf = true  -- Set this to true to target only the player who called the command
    },
}

for _, cmd in pairs(Config.commands) do
    if not cmd.disable then
        RegisterCommand(cmd.commandName, function(source, args, rawCommand)
            local numArgs = #args
            if numArgs == cmd.argsCount or (cmd.argsNil and numArgs == 0) then
                if not cmd.restricCommand or IsPlayerAceAllowed(source, "admin") then
                    local eventToTrigger = cmd.clientevent
                    if cmd.serverevent and cmd.serverevent ~= "" then
                        eventToTrigger = cmd.serverevent
                    end

                    local selectedArg = args[1] or cmd.argsNil
                    local targetPlayer = source -- Default to the player who issued the command

                    if cmd.targetSelf then
                        targetPlayer = source  -- If targetSelf is true, only target the player who issued the command
                    end

                    if cmd.targetAll then
                        targetPlayer = -1  -- If targetSelf is true, only target the player who issued the command
                    end

                    if eventToTrigger then
                        if cmd.serverevent then
                            TriggerEvent(eventToTrigger, selectedArg)
                        else
                            TriggerClientEvent(eventToTrigger, targetPlayer, selectedArg)
                        end
                    else
                        TriggerClientEvent("chatMessage", targetPlayer, "^1Invalid event configuration.")
                    end
                else
                    TriggerClientEvent("chatMessage", source, "^1You don't have permission to use this command.")
                end
            else
                TriggerClientEvent("chatMessage", source, "^1Invalid number of arguments.")
            end
        end, false)
    end
end
