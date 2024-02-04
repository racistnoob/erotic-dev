local function Initialize()
    CreateThread(function()
        Wait(1000)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        exports.spawnmanager:setAutoSpawn(false)
        exports.spawnmanager:spawnPlayer({
            x = 0.0,
            y = 0.0,
            z = 0.0,
            heading = 90.0,
            skipFade = true
        }, function()
            Wait(250)
            TriggerEvent('clothing:checkIfNew')
            TriggerEvent('erotic:playerSpawned')
            TriggerServerEvent('erotic:playerSpawned')
        end)
    end)
end
-- 1.
CreateThread(function()
	while true do
		Wait(1000)
        if NetworkIsSessionStarted() then
            Initialize()
			return
		end
	end
end)