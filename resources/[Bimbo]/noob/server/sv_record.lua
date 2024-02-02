local TX_ADMINS = {}
AddEventHandler("txAdmin:events:adminAuth", function(data)
    if data.netid ~= -1 then
        TX_ADMINS[tostring(data.netid)] = data.isAdmin
    end
end)

RegisterNetEvent('core:sendReport')
AddEventHandler('core:sendReport', function(data)
    local adminID = data["adminID"]
    local src = source
    TriggerClientEvent('chat:addMessage', adminID, {
        template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
        args = { "[ADMIN]", "Recording of "..GetPlayerName(src).. " uploaded" }
    })
end)

RegisterCommand("record", function(source, args, rawCommand)
    local src = source
    local message = {
        template = '<div class="chat-message-report"><b>{0}:</b> {1}</div>',
        args = { "[ADMIN]", "Player ID not specified/invalid"}
    }
    
    if TX_ADMINS[tostring(src)] then
        if #args == 1 then
            local recordTarget = args[1]
            for _, playerId in ipairs(GetPlayers()) do
                if playerId == recordTarget then
                    message.args[2] = "Began recording "..GetPlayerName(recordTarget)
                    TriggerClientEvent("core:getReport", recordTarget, GetPlayerName(src), src)
                    break
                end
            end
        end
    else
        message.args[2] = "No permission to use this command"
    end

    TriggerClientEvent('chat:addMessage', src, message)
end, false)