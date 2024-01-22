RegisterNetEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message-server">SERVER: {0}</div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterNetEvent("erp:addChatSystem")
AddEventHandler("erp:addChatSystem", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system"><b>SYSTEM :</b> {1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system"><b>SYSTEM :</b> {1}</div>',
            args = { source, msg }
        })
    end
end)

AddEventHandler("erp:countcommand", function(job, name, class, src)
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div class="'..class..'"><b>{0} :</b> {1}</div>',
        args = { job, name }
    })
end)

RegisterNetEvent("erp:rentalchat")
AddEventHandler("erp:rentalchat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system"><b>RENTAL :</b> {1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system"><b>RENTAL :</b> {1}</div>',
            args = { source, msg }
        })
    end
end)

RegisterNetEvent("erp:addChatNormal")
AddEventHandler("erp:addChatNormal", function(title, msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-random"><b>{2} :</b> {1}</div>',
          args = { source, msg, title }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-random"><b>{2} :</b> {1}</div>',
            args = { source, msg, title }
        })
    end
end)

--[[RegisterNetEvent("erp:phonenumber")
AddEventHandler("erp:phonenumber", function(sentId, sentNumber)
    TriggerClientEvent('chat:addMessage', sentId, {
        template = '<div class="chat-message-system"><b>Phone :</b> {0}</div>',
        args = { sentNumber }
    })
end)]]

RegisterNetEvent("erp:showId")
AddEventHandler("erp:showId", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system">{1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system">{1}</div>',
            args = { source, msg }
        })
    end
end)

RegisterNetEvent("drp-adminchat:checkPermissions")
AddEventHandler("drp-adminchat:checkPermissions", function(msg, user)
    if IsPlayerAceAllowed(source, 'echorp.mod') then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message-anc"><b>STAFF {0}:</b> {1}</div>',
            args = { user, msg }
        })
    end
end)

RegisterNetEvent("erp:emsAddChat")
AddEventHandler("erp:emsAddChat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="stategained"><b>STATUS ({0}) :</b> {1}</div>', args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="stategained"><b>STATUS ({0}) :</b> {1}</div>', args = { source, msg }
        })
    end
end, false)

RegisterNetEvent("erp:addChat")
AddEventHandler("erp:addChat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message-info"><b>INFO :</b> {1}</div>',
            args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-info"><b>INFO :</b> {1}</div>',
            args = { source, msg }
        })
    end
end, false)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end