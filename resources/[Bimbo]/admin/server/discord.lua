
AddEventHandler('erp_adminmenu:discord', function(name, message) sendToDiscord(name, message) end)
function sendToDiscord(name, message)
    local embed = {
        {
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/1202673451148779620/YXU80Rv8MDiiW-dfhwezKrribDgCJ2nDJGLd8a-cFyrkHGhN6-_JDSjMG1ie5qur8aN0", function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end
exports('sendToDiscord', sendToDiscord) -- exports['adminmenu']:sendToDiscord(name, message, color, webhook)