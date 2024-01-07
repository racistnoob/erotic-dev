function GetIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end

function Roundnumber(num, dp)
    local mult = 10 ^ (dp or 0)
  
    if num > 0 then
        return math.floor(num * mult + 0.5) / mult
    else
      return 0
    end
end

function CalculateKD(kills,deaths)
    if not deaths and not deaths then return 0 end
    if not deaths then 
        return (kills/0)
    end

    return (kills/deaths)
end

RegisterServerEvent("Grab:Leaderboard")
AddEventHandler("Grab:Leaderboard", function()
    local src = source
    local count = 0
    local Database = {}
    local players = GetPlayers()

    for _, playerId in ipairs(players) do
        local Steam = GetIdentifier("steam", playerId)
        if not Steam then goto skip end
        local Character = exports.oxmysql:fetchSync("SELECT id, Kills, Deaths FROM users WHERE identifier=:identifier AND deleted='0'", { identifier = Steam })[1]
        count = count + 1

        table.insert(Database, {
            id = count,
            Name = GetPlayerName(playerId),
            Kills = Character.Kills or 0,
            Deaths = Character.Deaths or 0,
            kd = Roundnumber(CalculateKD(Character.Kills,Character.Deaths)),
        })
        ::skip::
    end
    table.sort(Database, function(a, b) return a.Kills > b.Kills end)
    TriggerClientEvent('Recieved:Info', src, Database)
end)   

RegisterNetEvent('killfeed:server:playerWasKilled')
AddEventHandler('killfeed:server:playerWasKilled', function(killerId, weaponName)
    Victim = source
    Killer = killerId

    KillerSteam = GetIdentifier("steam", Killer)
    VictimSteam = GetIdentifier("steam", Victim)

    TriggerClientEvent('killfeed:client:feed', -1, GetPlayerRoutingBucket(killerId),  '<strong>' .. tostring(GetPlayerName(killerId)) .. '<img src="img/skull.png" width="15px" style="margin: 2px;"> <strong>' .. tostring(GetPlayerName(source)) .. '</strong>')

    if KillerSteam then
        exports.oxmysql:executeSync("UPDATE users SET Kills = Kills + 1 WHERE identifier=:identifier", { identifier = KillerSteam })
    end
    if VictimSteam then
        exports.oxmysql:executeSync("UPDATE users SET Deaths = Deaths + 1 WHERE identifier=:identifier", { identifier = VictimSteam })
    end
    local lobby = exports['erotic-lobby']:GetWorld(Killer)
    exports['erotic-lobby']:UpdateLobbyStats(Killer, lobby, "Kills")
end)