local function GetWeaponName(hash)
    hash = hash.weaponhash
    if hash == GetHashKey('WEAPON_UNARMED') then return 'unarmed'
        elseif hash == GetHashKey('WEAPON_KNUCKLE') then return 'knuckle'
        elseif hash == GetHashKey('WEAPON_BOTTLE') then return 'bottle'
        elseif hash == GetHashKey('WEAPON_MACHETE') then return 'machete'
        elseif hash == GetHashKey('WEAPON_REVOLVER') then return 'revolver'
        elseif hash == GetHashKey('WEAPON_BAT') then return 'bat'
        elseif hash == GetHashKey('WEAPON_GOLFCLUB') then return 'golfclub'
        elseif hash == GetHashKey('WEAPON_TACTICALRIFLE') then return 'tacticalrifle'
        elseif hash == GetHashKey('WEAPON_HEAVYRIFLE') then return 'heavyrifle'
        elseif hash == GetHashKey('WEAPON_CARBINERIFLE_MK2') then return 'carbinerifle_mk2'
        elseif hash == GetHashKey('WEAPON_SP45') then return 'pistol'
        elseif hash == GetHashKey('WEAPON_1911') then return 'pistol'
    end
end

AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local weaponName = GetWeaponName(deathData)
    TriggerServerEvent('killfeed:server:playerWasKilled', killerId, weaponName)
end)

RegisterNetEvent('killfeed:client:feed')
AddEventHandler('killfeed:client:feed', function(worldID, context)
    if exports['erotic-lobby']:getCurrentWorld() == worldID then
        SendNUIMessage({
            type = "killfeed",
            context = context
        })
    
    end
end)


local List = {}
RegisterCommand("stats", function()
    TriggerServerEvent("Grab:Leaderboard")
    Wait(500)

    SendNUIMessage({
        type = "ui",
        mode = "Leaderboard",
        data = json.encode(List),
    })

    SetNuiFocus(true, true)
    SetTimecycleModifier('hud_def_blur')
end)

AddEventHandler('Recieved:Info')
RegisterNetEvent('Recieved:Info', function(data)
    List = data or {}
end)

RegisterNUICallback("exit",function()
    SendNUIMessage({
        type = "ui",
        mode = "close_all",
    })
    SetNuiFocus(false,false)
    TriggerEvent('reset-timecycle')
    TriggerScreenblurFadeOut(50)
end)

AddEventHandler('Update:Lobby:Stats')
RegisterNetEvent('Update:Lobby:Stats', function(data)
    SendNUIMessage({
        type = "ui",
        mode = "stats",
        data = json.encode(data),
    })
end)