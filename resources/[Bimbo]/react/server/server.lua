RegisterNetEvent("SwitchWorld")
AddEventHandler("SwitchWorld", function(worldId)
    exports['core']:ChangeWorld(worldId)
end)