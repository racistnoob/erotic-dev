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

local function getIdentifier(plyId, identifier)
    local numIdentifiers = GetNumPlayerIdentifiers(plyId)	
    for i=0, numIdentifiers -1 do
        local currIdentifier = GetPlayerIdentifier(plyId, i)
        if currIdentifier then
            if string.find(currIdentifier, identifier..":") then
                return currIdentifier
            end
        end
    end
    return ""
end

local TX_ADMINS = {}
AddEventHandler("txAdmin:events:adminAuth", function(data)
    if data.netid ~= -1 then
        TX_ADMINS[tostring(data.netid)] = data.isAdmin
    end
end)

local report_Logs = "https://discord.com/api/webhooks/1201644493926060143/UzV2wxPv2af8uSqnXmVtKe9QApREglkTvBgC9Z78Iy12OkqabiYEsCf7HEo1mjAC3hLB"
local txadmin_Logs = "https://discord.com/api/webhooks/1202340309019922433/CqNYAmo_bLhXpy4ywfRnhOO_mN8dgHWlTlEuuS3OrUbtY3R7Fumd063xf715n5lGJHVX"
local function sendToDisc(webhook, title, msg)
    local embed = {
        {
            ["title"] = "**".. title .."**",
            ["description"] = msg,
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end


RegisterCommand("report", function(source, args, rawCommand)
    local report = string.sub(rawCommand, 8)
    if #report > 0 and report ~= nil then
        local src = source
        local name = GetPlayerName(src)
        local discord = getIdentifier(src, "discord")
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
            args = { "[REPORT]", "Report submitted."}
        })

        for adminId, admin in pairs(TX_ADMINS) do
            if admin then
                TriggerClientEvent('chat:addMessage', adminId, {
                    template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                    args = { "[REPORT]", "\n"..name..": "..report}
                })
            end
        end
        sendToDisc(report_Logs, "Player: "..name.." ["..src.."]",
        "**Report:** ```"..report.."```"..
        "\n**Discord:** <@!"..discord:gsub('discord:', '')..">"..
        "\n**Discord ID:** "..discord:gsub('discord:', ''))
    end
end, false)

local function disp_time(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    return string.format("%d days %02d hours %02d minutes %02d seconds",days,hours,minutes,seconds)
end

RegisterCommand("playtime", function(source, args, rawCommand)
    local fivem = getIdentifier(source, "fivem")
    if fivem ~= "" then
        local api = "https://lambda.fivem.net/api/ticket/playtimes/7dvoad?identifiers[]="
        api = api..fivem
        
        PerformHttpRequest(api, function (errorCode, resultData)
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                args = { "[PLAYTIME]", disp_time(json.decode(resultData)[1].seconds)}
            })
        end)
    else
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
            args = { "[PLAYTIME]", "FiveM identifier not connected."}
        })
    end
end)

RegisterCommand("forcelobby", function(source, args, rawCommand)
    local src = source  
    local message = "No permission to use this command"
    if TX_ADMINS[tostring(src)] then
        if #args >= 1 then
            local targetPlayer = (#args == 2) and args[1] or src
            local lobbyID = (#args == 1) and args[1] or args[2]
            local playerName = GetPlayerName(targetPlayer)
                
            sendToDisc(txadmin_Logs, 'Player sent to lobby', "Name: **" .. playerName .. "** \nAdmin: **" .. GetPlayerName(src) .. "** \nLobby: **" .. lobbyID .. "**")
            TriggerClientEvent("erotic-lobby:forceworld", targetPlayer, lobbyID, true)
            message = "Sent "..playerName.." to lobby: "..lobbyID

            if targetPlayer ~= src then
                TriggerClientEvent('chat:addMessage', targetPlayer, {
                    template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
                    args = { "[ADMIN]", "You have been sent to lobby: "..lobbyID}
                })
            end
        else
            message = "Usage: forcelobby <playerid> <lobbyid> / forcelobby <lobbyid>"
        end
    end
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
        args = { "[ADMIN]", message}
    })
end, false)