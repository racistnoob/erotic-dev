RegisterNetEvent('killfeed:server:playerWasKilled')
AddEventHandler('killfeed:server:playerWasKilled', function(killerId, whoWasKilled, weaponName)
    TriggerClientEvent('killfeed:client:feed', -1, GetPlayerRoutingBucket(killerId),  '<strong>' .. tostring(GetPlayerName(killerId)) .. '<img src="img/skull.png" width="15px" style="margin: 2px;"> <strong>' .. tostring(whoWasKilled) .. '</strong>')
end)