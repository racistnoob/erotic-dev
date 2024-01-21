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

AddEventHandler('gameEventTriggered', function(name, args)
    if true then
        if name == 'CEventNetworkEntityDamage' then
            local victim = args[1]
            local attacker = args[2]
            if IsPedAPlayer(attacker) then
  
                local victimEntitys, attackEntitys, damages, _s, _s, fatalBools, weaponUseds, _s, _s, _s, entityTypes = table.unpack(args)
  
                args = { victimEntitys, attackEntitys, fatalBools == 1, weaponUseds, entityTypes,
                  math.floor(string.unpack("f", string.pack("i4", damages))) 
                }

                if GetPlayerByEntityID ~= nil then
                  local attackerId = GetPlayerServerId(GetPlayerByEntityID(attacker))
                  TriggerServerEvent('Update:Lobby:Stats',attackerId, damages)
                end
            end
  
        end
    end
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
    SetTimecycleModifier('default')
    TriggerScreenblurFadeOut(50)
end)

local lobbystats = {}
AddEventHandler('Update:Lobby:Stats')
RegisterNetEvent('Update:Lobby:Stats', function(data)
    lobbystats  = data
    SendNUIMessage({
        type = "ui",
        mode = "stats",
        data = json.encode(data),
    })
end)


local function setLeaderboardExtended(state)
    SendNUIMessage({
        type = "ui",
        mode = "extendedview",
        state = state,
        data = json.encode(lobbystats),
    })
end
  
RegisterCommand("+leaderboard_extend", function()
    setLeaderboardExtended(true)
end)

RegisterCommand("-leaderboard_extend", function()
    setLeaderboardExtended(false)
end)
  
RegisterKeyMapping("+leaderboard_extend", "Extend Lobby Leaderboard", "keyboard", "z")