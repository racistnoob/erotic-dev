local webhook = ""

RegisterNetEvent('playerJoining')
AddEventHandler('playerJoining', function()
    local source = source
    local steamid  = "Unidentified"
    local license  = "Unidentified"
    local discord  = "Unidentified"
    local ip       = "Unidentified"
    local fivem    = "Unidentified"

    for k,v in pairs(GetPlayerIdentifiers(source))do            
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            license = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            fivem = v
        end
    end
    
    local message = "Player: **"..GetPlayerName(source).."** (**"..source.."**)\nSteam: **"..steamid.."**".."\nsteam: **"..fivem.."**\nsteam: **"..license.."**\nDiscord: **"..discord.."**\nIP: **||"..ip.."||**"
    --sendToDiscord('Player Connecting', message, "2676322", webhook)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local steamid  = "Unidentified"
    local license  = "Unidentified"
    local discord  = "Unidentified"
    local ip       = "Unidentified"
    local fivem    = "Unidentified"

    for k,v in pairs(GetPlayerIdentifiers(source))do            
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            license = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            fivem = v
        end
    end

    local message = "Player: **"..GetPlayerName(source).."** (**"..source.."**)\nReason: **"..reason.."**\nSteam: **"..steamid.."**".."\nsteam: **"..fivem.."**\nsteam: **"..license.."**\nDiscord: **"..discord.."**\nIP: **||"..ip.."||**"
   --sendToDiscord('Player Leaving', message, "15730953", webhook)
end)