RegisterNetEvent('chat:init')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('_chat:messageEntered')
RegisterNetEvent('chat:server:ClearChat')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:commandFallback')

AddEventHandler("chatMessage", function(source, args, raw)
    CancelEvent()
end)

local function routeMessage(source, author, message, lobbyID)
    if source >= 1 then
        author = GetPlayerName(source)
    end

    local outMessage = {
        template = '<div class="chat-message-ooc"><b>{0}:</b> {1}</div>',
        args = { message },
    }

    if author ~= "" then
        outMessage.args = { author, message }
    end

    local messageCanceled = false

    if messageCanceled then
        return
    end

    local players = exports['erotic-lobby']:getPlayersInLobby(lobbyID)
    for _, id in pairs(players) do
        TriggerClientEvent('chat:addMessage', id, outMessage)
    end
end

AddEventHandler('_chat:messageEntered', function(author, color, message, lobbyID)
    if not message or not author then
        return
    end

    local source = source

    routeMessage(source, author, message, lobbyID)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)
    
    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- command suggestions for clients

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    --refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
