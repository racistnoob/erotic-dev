local function toggleLocals(worldID, value)
    CreateThread(function()
        SetRoutingBucketPopulationEnabled(worldID, value)
    end)
end

CreateThread(function()
    for i = 0, 22 do
        toggleLocals(i, false)
    end
end)

exports('toggleLocals', toggleLocals)