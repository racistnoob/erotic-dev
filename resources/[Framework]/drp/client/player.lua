-- Functions

local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)
    local ped = GetPlayerPed(player)
    if not freeze then
        if not IsEntityVisible(ped) then SetEntityVisible(ped, true) end
        if not IsPedInAnyVehicle(ped) then SetEntityCollision(ped, true) end
        FreezeEntityPosition(ped, false) SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then SetEntityVisible(ped, false) end
        SetEntityCollision(ped, false) FreezeEntityPosition(ped, true) SetPlayerInvincible(player, true)
        if not IsPedFatallyInjured(ped) then ClearPedTasksImmediately(ped) end
    end
end

-- Logout

RegisterNetEvent('echorp:doLogout')
AddEventHandler('echorp:doLogout', function()
    PlayerData = {}
    DoScreenFadeOut(100) Wait(300)
    local player, ped = PlayerId(), PlayerPedId()
    if IsEntityVisible(ped) then SetEntityVisible(ped, false) end
    SetEntityCollision(ped, false) FreezeEntityPosition(ped, true) SetPlayerInvincible(player, true)
    if not IsPedFatallyInjured(ped) then ClearPedTasksImmediately(ped) end
    SetEntityCoords(ped, vector3(-288.24+math.random(1, 100), -907.95+math.random(1, 100), 676.92+math.random(1, 100)))
    Initialize()
end)