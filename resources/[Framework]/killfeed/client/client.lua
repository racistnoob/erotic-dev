
local weaponNames = {
    [`WEAPON_UNARMED`] = 'weapon_unarmed',
    [`WEAPON_KNUCKLE`] = 'knuckle',
    [`WEAPON_BOTTLE`] = 'bottle',
    [`WEAPON_MACHETE`] = 'machete',
    [`WEAPON_REVOLVER`] = 'revolver',
    [`WEAPON_BAT`] = 'bat',
    [`WEAPON_GOLFCLUB`] = 'golfclub',
    [`WEAPON_TACTICALRIFLE`] = 'tacticalrifle',
    [`WEAPON_HEAVYRIFLE`] = 'weapon_heavyrifle',
    [`WEAPON_762`] = 'carbinerifle_mk2',
    [`WEAPON_SP45`] = 'weapon_heavypistol',
    [`WEAPON_1911`] = 'weapon_pistol_mk2',
    [`WEAPON_HEAVYPISTOL`] = 'weapon_heavypistol',
    [`WEAPON_PISTOL50`] = 'weapon_pistol50',
    [`WEAPON_MARKSMANRIFLE_MK2`] = 'weapon_marksmanrifle_mk2',
    [`WEAPON_HEAVYSNIPER_MK2`] = 'weapon_heavysniper_mk2',
    [`WEAPON_ASSAULTSMG`] = 'weapon_assaultsmg',
    [`WEAPON_GUSENBERG`] = 'weapon_gusenberg',
    [`WEAPON_MINISMG`] = 'weapon_minismg',
    [`WEAPON_MICROSMG`] = 'weapon_microsmg',
    [`WEAPON_MPX`] = 'weapon_smg_mk2',
    [`WEAPON_SMG_MK2`] = 'weapon_smg_mk2',
    [`WEAPON_COMPACTRIFLE`] = 'weapon_compactrifle',
    [`WEAPON_MACHINEPISTOL`] = 'weapon_machinepistol',
    [`WEAPON_COMBATMG`] = 'weapon_combatmg',
    [`WEAPON_ADVANCEDRIFLE`] = 'weapon_advancedrifle',
    [`WEAPON_MK18`] = 'carbinerifle_mk2',
    [`WEAPON_SPECIALCARBINE`] = 'weapon_specialcarbine',
    [`WEAPON_SCARH`] = 'weapon_scarh',
    [`WEAPON_ASSAULTRIFLE`] = 'weapon_assaultrifle',
    [`WEAPON_APPISTOL`] = 'weapon_appistol',
    [`WEAPON_CERAMICPISTOL`] = 'weapon_ceramicpistol',
    [`WEAPON_PISTOLXM3`] = 'weapon_ceramicpistol',
    [`WEAPON_GLOCK18C`] = 'weapon_appistol',
    [`WEAPON_GLOCK17`] = 'weapon_glock',
    [`WEAPON_FNX45`] = 'pistol',
    [`WEAPON_USP45`] = 'weapon_heavypistol',
    [`WEAPON_VINTAGEPISTOL`] = 'weapon_vintagepistol',
    [`WEAPON_COMBATPISTOL`] = 'weapon_combatpistol',
    [`WEAPON_M45A1`] = 'weapon_combatpistol',
}

local function GetWeaponName(hash)
    return weaponNames[hash.weaponhash] or 'unknown'
end

toggleHud = true

AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local weaponName = GetWeaponName(deathData)
    TriggerServerEvent('killfeed:server:playerWasKilled', killerId, weaponName)
end)

RegisterNetEvent('killfeed:client:feed')
AddEventHandler('killfeed:client:feed', function(worldID, context)
    if exports['erotic-lobby']:getCurrentWorld() == tonumber(worldID) then
        SendNUIMessage({
            type = "killfeed",
            context = context,
            show = toggleHud
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
        show = toggleHud
    })

    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(50)
end)

AddEventHandler('Recieved:Info')
RegisterNetEvent('Recieved:Info', function(data)
    List = data or {}
end)

RegisterNUICallback("exit",function()
    SendNUIMessage({
        type = "ui",
        mode = "close_all",
        show = toggleHud
    })
    SetNuiFocus(false,false)
    TriggerScreenblurFadeOut(50)
end)

local lobbystats = {}
local extended = false
AddEventHandler('Update:Lobby:Stats')
RegisterNetEvent('Update:Lobby:Stats', function(data)
    lobbystats  = data
    SendNUIMessage({
        type = "ui",
        mode = "stats",
        state = extended,
        data = json.encode(data),
        show = toggleHud
    })
end)

exports("toggleHud", function(state)
    toggleHud = state
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)
  
RegisterCommand("+leaderboard_extend", function()
    extended = true
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)

RegisterCommand("-leaderboard_extend", function()
    extended = false
    Wait(100)
    TriggerEvent('Update:Lobby:Stats', lobbystats)
end)
  
RegisterKeyMapping("+leaderboard_extend", "Extend Lobby Leaderboard", "keyboard", "z")