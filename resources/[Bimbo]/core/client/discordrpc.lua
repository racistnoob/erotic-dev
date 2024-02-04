currentState = "Southside #1"

RegisterNetEvent('core:updateLobby')
AddEventHandler("core:updateLobby", function(args)
    local lobbyID = tonumber(args)
    if lobbyID ~= nil then
        local lobbySettings = exports['erotic-lobby']:getLobbySettings(lobbyID)
        currentState = (lobbySettings.name)
        TriggerEvent('erotic:changeWatermark', currentState)
    end
end)

local wait = Wait
local set_discord_app_id = SetDiscordAppId
local set_discord_rich_presence_action = SetDiscordRichPresenceAction
local set_rich_presence = SetRichPresence
local set_discord_rich_presence_asset = SetDiscordRichPresenceAsset
Citizen.CreateThread(function()
    while true do
        wait(10000)
        set_discord_app_id(1186601487720271923)
     
        set_discord_rich_presence_action(0, "Discord", "https://discord.gg/XWjYGqyaHf")
        set_discord_rich_presence_action(1, "Connect", "fivem://connect/45.43.2.17:30120")
     
        set_rich_presence(currentState)
        set_discord_rich_presence_asset('erotic')
    end
end)