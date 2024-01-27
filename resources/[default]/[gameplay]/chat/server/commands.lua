RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(600000) -- Wait for 10 minutes (600,000 milliseconds)
        TriggerClientEvent('chat:client:ClearChat', -1)
    end
end)
----------------------------
RegisterCommand('announce', function(source, args, rawCommand)
    local msg = rawCommand:sub(9)
    if source == 0 then
        TriggerEvent('chat:server:ServerPSA', msg)
    else
        if IsPlayerAceAllowed(source, 'echorp.mod') or IsPlayerAceAllowed(source, 'echorp.admin') then
			TriggerEvent('chat:server:ServerPSA', msg)
		end
    end
end, false)

RegisterCommand('a', function(source, args, rawCommand)
    local src = source

    if IsPlayerAceAllowed(source, 'echorp.mod') or IsPlayerAceAllowed(source, 'echorp.admin') then
        local msg = rawCommand:sub(2)
        TriggerClientEvent('adminChat:checkPermissions', -1, msg, GetPlayerName(src))
    end
end, false)

RegisterCommand('all', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if source == 0 then
        local user = "Console"
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message-ooc"><b>[ALL] <font color="red"><b>{0}</b></font>:</b> {1}</div>',
            args = { user, msg }
        }) 
    else 
        if player ~= false then
            local user = GetPlayerName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ooc"><b>[ALL] {0}:</b> {1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)