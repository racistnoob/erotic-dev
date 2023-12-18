local VehicleNitrous = {}


RegisterServerEvent('nitrous:GetNosLoadedVehs')
AddEventHandler('nitrous:GetNosLoadedVehs', function()
    TriggerClientEvent('nitrous:GetNosLoadedVehs', source, VehicleNitrous)
end)

RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    local source = source

    for _, player in ipairs(GetPlayers()) do
        if player ~= tostring(source) then
            TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
        end
    end
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate, veh)
    local source = source
    TriggerClientEvent('nitrous:client:StopSync', -1, plate, veh, source)
end)
