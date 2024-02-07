local FFABUNKER = {
    [1] = {x = 895.6183, y = -3245.4922,  z = -98.2509, h = 143.0110},
    [2] = {x = 843.3173, y = -3235.2666, z = -98.6991, h = 143.0110},
    [3] ={x = 856.9405, y = -3212.1631, z = -98.4711, h = 143.0110},
    [4] ={x = 872.1874, y = -3211.3135, z = -97.2462, h = 143.0110},
    [5] ={x = 867.2796, y = -3186.1096, z = -96.2488, h = 143.0110},
    [6] ={x = 900.2949, y = -3182.2495, z = -97.0675, h = 143.0110},
    [7] ={x = 904.9290, y = -3199.6267, z = -97.1880, h = 143.0110},
    [8] ={x = 909.7304, y = -3236.9119, z = -98.2942, h = 143.0110},
    [9] ={x = 945.9636, y = -3210.4885, z = -98.2774, h = 143.0110},
    [10] ={x = 918.3181, y = -3201.2510, z = -98.2621, h = 143.0110},
    [11] ={x = 906.0173, y = -3230.5940, z = -98.2944, h = 143.0110},
    [12] = {x = 884.8878, y = -3211.9189, z = -98.1962, h = 143.0110},
}

local MirrorPark = {
    x = 770.5748, 
    y = -233.9927, 
    z = 66.1145, 
    h = 354.6606
}

local worlds = {
    { ID = 1, custom = false, playerCount = 0, settings = {
        name = 'Southside #1',
        tags = {'Pistols', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true,
        hsMulti = false,
        maxPlayers = 30,
        kits = {'pistols'},
        kit = {'pistols', 'sp'},
    }},
    { ID = 2, custom = false, playerCount = 0, settings = {
        name = 'Southside #2',
        tags = {'FPS Mode', 'ARS', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true,
        hsMulti = false,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'}
    }},
    { ID = 3, custom = false, playerCount = 0, settings = {
        name = 'Car Fights',
        tags = {'Pistols', 'Rena'},
        recoilMode = 'roleplay3',
        firstPersonVehicle = false, 
        hsMulti = false,
        maxPlayers = 30,
        kit = {'pistols', 'heavypistol'},
        kits = {'pistols'},
    }},
    { ID = 4, custom = false, playerCount = 0, settings = {
        name = 'Pistol FFA',
        tags = {'FFA', 'Pistols', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = false,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'pistols'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 5, custom = false, playerCount = 0, settings = {
        name = 'AR FFA',
        tags = {'FFA', 'ARs', 'RP Preset #1'},
        recoilMode = 'roleplay',
        firstPersonVehicle = true, 
        hsMulti = true,
        maxPlayers = 30,
        kit = {'ars', '762'},
        kits = {'ars'},
        RandomSpawns = FFABUNKER
    }},
    { ID = 6, custom = false, playerCount = 0, settings = {
        name = 'Envy',
        tags = {'FPS Mode', 'Headshots', 'Envy'},
        recoilMode = 'envy',
        firstPersonVehicle = true, 
        hsMulti = true,
        maxPlayers = 30,
        kit = {'pistols', 'sp'},
        kits = {'ars','pistols','smgs'},
    }},
    { ID = 7, custom = false, playerCount = 0, settings = {
        name = 'Deluxo',
        tags = {'Deluxo', 'Snipers'},
        recoilMode = 'roleplay2',
        firstPersonVehicle = true, 
        hsMulti = false,
        maxPlayers = 30,
        spawningcars = false,
        kits = {'snipers'},
        kit = {'snipers', 'trick2'},
        spawn = MirrorPark
    }},
    { ID = 8, custom = false, playerCount = 0, settings = {
        name = 'Overtime (BETA)',
        tags = {'Headshots', 'FPS Mode', 'OT Combat', 'OT Recoil'},
        recoilMode = 'nonstop',
        nonstopcombat = true,
        firstPersonVehicle = true,
        hsMulti = true,
        kits = {'ars','pistols','smgs'},
        maxPlayers = 30,
    }}
}

RegisterServerEvent('RemoveEmptyCustomLobby')
AddEventHandler('RemoveEmptyCustomLobby', function(lobbyID)
    for i = #worlds, 1, -1 do
        local lobby = worlds[i]
        if lobby.ID == lobbyID and lobby.custom and getLobbyPlayerCount(lobbyID) == 0 then
            table.remove(worlds, i)
            --print("Removed empty custom lobby:", json.encode(lobby))
            TriggerClientEvent('UpdateLobbies', -1, worlds)
            break
        end
    end
end)

local recoilModeTags = {
    roleplay = "RP Preset #1",
    envy = "Envy",
    hardcore = "Hardcore",
    roleplay3 = "Rena",
    roleplay2 = "RP Preset #2",
    qb = "qb"
}

function generateTags(settings)
    local tags = {}

    -- Check and add "FPS Mode" tag
    if settings.firstPersonVehicle then
        table.insert(tags, "FPS Mode")
    end

    -- Check and add "Headshots" tag
    if settings.hsMulti then
        table.insert(tags, "Headshots")
    end

    local recoilModeTag = recoilModeTags[settings.recoilMode]
    if recoilModeTag then
        table.insert(tags, recoilModeTag)
    end

    return tags
end

RegisterNetEvent('AddCustomLobby')
AddEventHandler('AddCustomLobby', function(customLobbySettings)
    local playerName = GetPlayerName(source)

    if playerName then
        for _, lobby in ipairs(worlds) do
            if lobby.custom and lobby.settings.name == playerName .. "'s Lobby" then
                TriggerClientEvent('Notify', source, 'You already have a custom lobby.')
                return
            end
        end

        customLobbySettings.name = playerName .. "'s Lobby"
        customLobbySettings.tags = generateTags(customLobbySettings)
        local customLobby = {
            ID = #worlds + 1,
            custom = true,
            playerCount = 0,
            settings = customLobbySettings,
        }
        table.insert(worlds, customLobby)

        TriggerClientEvent('updateLobbies', -1, worlds)
        TriggerSwitchWorldToClient(source, customLobby.ID)
    end
end)


function TriggerSwitchWorldToClient(source, worldID)
    TriggerClientEvent('SwitchWorldData',source, worldID)
end

RegisterNetEvent('RequestWorldsData')
AddEventHandler('RequestWorldsData', function()
    TriggerClientEvent('ReceiveWorldsData', source, worlds)
end)

RegisterServerEvent('getWorldsData')
AddEventHandler('getWorldsData', function()
    TriggerClientEvent('receiveWorldsData', -1, worlds)
end)