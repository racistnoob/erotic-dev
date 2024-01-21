function GetIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers - 1 do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end

function CalculateKD(kills, deaths)
    if not deaths or deaths == 0 then
        return 0
    end

    return (kills / deaths)
end

RegisterServerEvent("Grab:Leaderboard")
AddEventHandler("Grab:Leaderboard", function()
    local src = source
    local count = 0
    local Database = {}
    local players = GetPlayers()

    for _, playerId in ipairs(players) do
        local Steam = GetIdentifier("steam", playerId)
        if Steam then
            local Character = exports.oxmysql:fetchSync("SELECT id, Kills, Deaths FROM users WHERE identifier=:identifier AND deleted='0'", { identifier = Steam })
            if Character and Character[1] then
                count = count + 1
                local Kills = Character[1].Kills or 0
                local Deaths = Character[1].Deaths or 0

                table.insert(Database, {
                    id = count,
                    Name = GetPlayerName(playerId),
                    Kills = Kills,
                    Deaths = Deaths,
                    kd = string.format("%.2f", CalculateKD(Kills, Deaths)),
                })
            end
        end
    end

    table.sort(Database, function(a, b) return a.Kills > b.Kills end)
    TriggerClientEvent('Recieved:Info', src, Database)
end)

RegisterNetEvent('killfeed:server:playerWasKilled')
AddEventHandler('killfeed:server:playerWasKilled', function(killerId, weaponName)
    local Victim = source
    local Killer = killerId

    local KillerSteam = GetIdentifier("steam", Killer)
    local VictimSteam = GetIdentifier("steam", Victim)

    TriggerClientEvent('killfeed:client:feed', -1, GetPlayerRoutingBucket(killerId), '<strong>' .. tostring(GetPlayerName(killerId)) .. '<img src="img/skull.png" width="15px" style="margin: 2px;"> <strong>' .. tostring(GetPlayerName(source)) .. '</strong>')

    if KillerSteam then
        exports.oxmysql:execute("UPDATE users SET Kills = Kills + 1 WHERE identifier=:identifier", { identifier = KillerSteam }, function(result)
            -- Handle the result if needed
        end)
    end

    if VictimSteam then
        exports.oxmysql:execute("UPDATE users SET Deaths = Deaths + 1 WHERE identifier=:identifier", { identifier = VictimSteam }, function(result)
            -- Handle the result if needed
        end)
    end

    local lobby = exports['erotic-lobby']:GetWorld(Killer)
    exports['erotic-lobby']:UpdateLobbyStats(Killer, lobby, "Kills")
    exports['erotic-lobby']:UpdateLobbyStats(Victim, lobby, "Deaths")
end)
