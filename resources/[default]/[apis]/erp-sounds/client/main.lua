local standardVolumeOutput = 1.0;

RegisterNetEvent('drp-sounds:PlayOnOne')
AddEventHandler('drp-sounds:PlayOnOne', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('drp-sounds:PlayOnAll')
AddEventHandler('drp-sounds:PlayOnAll', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('drp-sounds:PlayWithinDistance')
AddEventHandler('drp-sounds:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume, coords)
    local lCoords = GetEntityCoords(PlayerPedId())
    local eCoords = coords
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)

RegisterNetEvent('drp-sounds:PlayWithinDistanceOfCoords')
AddEventHandler('drp-sounds:PlayWithinDistanceOfCoords', function(maxDistance, soundFile, soundVolume,coords)
    local lCoords = GetEntityCoords(PlayerPedId())
    local distIs = Vdist(lCoords.x, lCoords.y, lCoords.z, coords[1], coords[2], coords[3])
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = soundFile,
            transactionVolume   = soundVolume
        })
    end
end)

RegisterNetEvent('drp-sounds:PlayFlash')
AddEventHandler('drp-sounds:PlayFlash', function(soundFile, soundVolume,time,hold)
    SendNUIMessage({
        transactionType     = 'playSoundFlash',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume,
        transactionTime     = time,
        transactionHold     = hold
    })
end)

