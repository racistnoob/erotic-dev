local function toggleLocals(worldID, value)
    CreateThread(function()
        SetRoutingBucketPopulationEnabled(worldID, value)
    end)
end

exports('toggleLocals', toggleLocals)