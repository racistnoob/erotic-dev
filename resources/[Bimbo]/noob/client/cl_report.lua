RegisterNetEvent('core:getReport')
AddEventHandler('core:getReport', function(othername, src)
    SendNUIMessage({type = "start", name = GetPlayerName(PlayerId()).." ["..GetPlayerServerId(PlayerId()).."]", othername = othername, src = src})
end)

RegisterNUICallback('sendReport', function(data, cb)
    TriggerServerEvent('core:sendReport', data)
    cb({ok = true})
end)