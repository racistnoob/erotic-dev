currentState = "Southside #1"

RegisterNetEvent('core:updateRPC')
AddEventHandler("core:updateRPC", function(args)
    local lobbyID = tonumber(args)
    if lobbyID ~= nil then
        local lobbyData = exports['erotic-lobby']:getLobbyData(lobbyID)
        currentState = (lobbyData.name)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        SetDiscordAppId(1186601487720271923)
     
        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/XWjYGqyaHf")
        SetDiscordRichPresenceAction(1, "Connect", "fivem://connect/45.43.2.17:30120")
     
        SetRichPresence(currentState)
        SetDiscordRichPresenceAsset('erotic')
    end
end)