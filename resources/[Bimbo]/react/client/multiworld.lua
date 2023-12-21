RegisterNUICallback('switchWorld', function(data, cb)
    if data.worldId then
        exports['erotic-lobby']:switchWorld(data.worldId)
        cb({ success = true })
    else
        cb({ error = 'Invalid world ID' })
    end
end)
