local function toggleLocals(worldID, value)
    CreateThread(function()
        SetRoutingBucketPopulationEnabled(worldID, value)
    end)
end

-- disables locals in lobbies 1 -> 20
CreateThread(function()
    for i = 0, 19 do
        toggleLocals(i, false)
    end
end)

exports('noob:toggleLocals', toggleLocals)