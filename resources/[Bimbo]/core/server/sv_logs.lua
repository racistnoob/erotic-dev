local txadmin_Logs = "https://discord.com/api/webhooks/1202340309019922433/CqNYAmo_bLhXpy4ywfRnhOO_mN8dgHWlTlEuuS3OrUbtY3R7Fumd063xf715n5lGJHVX"

local function sendToDisc(title, msg)
    local embed = {
        {
            ["title"] = "**".. title .."**",
            ["description"] = msg,
        }
    }
    PerformHttpRequest(txadmin_Logs, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('txAdmin:events:playerKicked', function(eventData)

    local target = eventData.target
    local author = eventData.author
    local reason = eventData.reason

    sendToDisc('Player Kicked', "Name: **" .. GetPlayerName(target) .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**")
end)

AddEventHandler('txAdmin:events:playerWarned', function(eventData)

    local target = eventData.target
    local author = eventData.author
    local reason = eventData.reason
    local id = eventData.actionId

    sendToDisc('Player Warned', "Name: **" .. GetPlayerName(target) .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**\nID: **" .. id .. "**")

end)

AddEventHandler('txAdmin:events:playerBanned', function(eventData)

    local target = eventData.target
    local author = eventData.author
    local reason = eventData.reason
    local id = eventData.actionId
    local exp = eventData.expiration

    if not exp then
        exp = 'Never'
    else
        exp = os.date('%c', exp)
    end 

    if (type(target) == "table") then 
        playername = "`Offline Ban`"
    else 
        playername = GetPlayerName(target)
    end
    
    sendToDisc('Player Banned', "Name: **" .. playername .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**\nID: **" .. id .. "**\nExpires: **" .. exp .. "**")

end)

AddEventHandler('txAdmin:events:announcement', function(eventData)

    local author = eventData.author
    local msg = eventData.message

    if Config.FilterAnnouncements then
        if author ~= 'txAdmin' then
            sendToDisc('Announcement', "Admin: **" .. author .. "**\nMessage: **" .. msg .. "**")
        end
    else
        sendToDisc('Announcement', "Admin: **" .. author .. "**\nMessage: **" .. msg .. "**")
    end
end)

AddEventHandler('txAdmin:events:configChanged', function(eventData)
    sendToDisc('Config Changed', "TxAdmin config changes made.")
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)

    local target = eventData.id

    if target == -1 then
        playername = 'Everyone'
    else
        playername = GetPlayerName(target)
    end

    sendToDisc('Player Healed', "Name: **" .. playername .. "**")

end)

AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)

    local delay = eventData.delay
    local author = eventData.author
    local msg = eventData.message
        
        
    sendToDisc('Server Shutdown', "Author: **" .. author .. "**\nMessage: **" .. msg .. "**\nDelay: **" .. delay .. "ms**")
end)