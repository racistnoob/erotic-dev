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
    vector4(231.8789, -1390.2084, 30.4853, 142.7518),
}

local revivespots2 = {
    vector4(770.5748, -233.9927, 66.1145, 354.6606)
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