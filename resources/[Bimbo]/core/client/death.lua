local PlayerData = {}

AddEventHandler('baseevents:onPlayerDied', function()
	LocalPlayer.state:set('dead', true, true)
	TriggerServerEvent('echorp:adjustDead', LocalPlayer.state.dead)
	DeathTimer()
    TriggerEvent("actionbar:setEmptyHanded")
end)

RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function(sentData)
	PlayerData = sentData
    TriggerEvent("actionbar:setEmptyHanded")
end)

RegisterNetEvent('echorp:updateinfo')
AddEventHandler('echorp:updateinfo', function(toChange, targetData)
  PlayerData[toChange] = targetData
end)

RegisterNetEvent('echorp:doLogout') -- Use this to logout.
AddEventHandler('echorp:doLogout', function(sentData) 
	PlayerData = {}
	TriggerServerEvent('echorp:adjustDead', false)
    TriggerEvent("actionbar:setEmptyHanded")
end)

AddEventHandler('baseevents:revived', function() 
	LocalPlayer.state:set('dead', false, true)
	TriggerServerEvent('echorp:adjustDead', LocalPlayer.state.dead) 
end)

AddEventHandler('baseevents:revivedarmor', function() 
	LocalPlayer.state:set('dead', false, true)
	TriggerServerEvent('echorp:adjustDead', LocalPlayer.state.dead)
	SetPedArmour(PlayerPedId(), 100)
	SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 100) 
end)

AddEventHandler('baseevents:kill', function() 
	LocalPlayer.state:set('dead', true, true)
	TriggerServerEvent('echorp:adjustDead', true)
    ApplyDamageToPed(PlayerPedId(), 100, false)
end)

function DeathTimer()
    CreateThread(function()
    while LocalPlayer.state.dead do
			Citizen.Wait(1000)
			UndeadedPlayer(true)
		end
    end)
end

local Undeaded = false
local Undeaded2 = false
local Undeaded3 = false

function SetUndeaded(state)
	Undeaded = state == true
    if state then
        Undeaded2 = false
        Undeaded3 = false
    end
end

function SetUndeaded2(state)
	Undeaded2 = state == true
    if state then
        Undeaded = false
        Undeaded3 = false
    end
end

function SetUndeaded3(state)
	Undeaded3 = state == true
    if state then
        Undeaded = false
        Undeaded2 = false
    end
end

exports("setUndeaded", SetUndeaded)
exports("setUndeaded2", SetUndeaded2)
exports("setUndeaded3", SetUndeaded3)

local revivespots1 = {
    vector4(231.8789, -1390.2084, 30.4853, 318.6673),
}

local revivespots2 = {
    vector4(-33.3090, -1858.9119, 25.7237, 325.1187),
	vector4(6.7997, -1896.4618, 23.0529, 327.7787),
	vector4(40.1613, -1841.1782, 23.6709, 134.1668),
	vector4(67.2312, -1866.4969, 22.4190, 276.6609),
    vector4(7.8714, -1835.6271, 24.7835, 175.7639),
    vector4(45.1347, -1915.0593, 21.6420, 198.0363),
    vector4(60.8026, -1948.9991, 21.0235, 254.8569),
    vector4(91.3754, -1897.3522, 23.9444, 16.5324),
}

local revivespots3 = {
    vector4(891.7990, -3243.9780, -98.2615, 85.2399),
    vector4(851.8600, -3238.9521, -98.6992, 35.1324),
    vector4(865.2023, -3217.2617, -98.0399, 250.5616),
    vector4(905.8195, -3229.0405, -98.2945, 212.0459),
    vector4(940.0786, -3230.7434, -98.2933, 303.2994),
    vector4(887.1623, -3191.1826, -98.2325, 185.8266),
    vector4(925.5530, -3205.2161, -98.2601, 259.9512),
}

local revivespots4 = {
    
}

function UndeadedPlayer()
    local immediatePed = PlayerPedId() 
    TriggerEvent("actionbar:setEmptyHanded")
    if Undeaded then
        local reviveSpot = revivespots1[math.random(#revivespots1)]
        NetworkResurrectLocalPlayer(reviveSpot, true, false)
	elseif Undeaded2 then
		local reviveSpot = revivespots2[math.random(#revivespots2)]
		NetworkResurrectLocalPlayer(reviveSpot, true, false)
    elseif Undeaded3 then 
        local reviveSpot = revivespots3[math.random(#revivespots3)]
		NetworkResurrectLocalPlayer(reviveSpot, true, false)
	else
        NetworkResurrectLocalPlayer(GetEntityCoords(immediatePed), 90.0, true, false)
    end
    TriggerEvent('baseevents:revived')
    TriggerServerEvent('baseevents:revived')
end

RegisterCommand('kill', function(source, args, rawCommand)
    exports['drp-notifications']:SendAlert('inform', 'About to die', 5000)
    Citizen.Wait(1800)
	TriggerServerEvent('dst_killfeed:server:playerDied', GetPlayerName(PlayerId()))
    SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
    Citizen.Wait(1200)
    UndeadedPlayer(true)
end)

RegisterCommand('leave', function(source, args, rawCommand)
    local immediatePed = PlayerPedId()
    exports['drp-notifications']:SendAlert('inform', 'leaving', 5000)
    Citizen.Wait(1500)
    exports['erotic-lobby']:switchWorld(1)
end)