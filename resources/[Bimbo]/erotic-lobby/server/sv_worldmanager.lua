WorldTracker = {};

Config = {}
Config = {
    Worlds = { -- ["WorldName"] = {RoutingBucket, Spawnpoint, PermissionRequired},
        ["1"] = {0, false}, -- DO NOT REMOVE
        ["2"] = {1, false},
        ["3"] = {2, false},
        ["4"] = {3, false},
        ["5"] = {4, false},
        ["6"] = {5, false},
        ["7"] = {6, false},
        ["8"] = {7, false},
        ["9"] = {8, false},
        ["10"] = {9, false},
        ["11"] = {10, false},
        ["12"] = {11, false},
        ["13"] = {12, false},
        ["14"] = {13, false},
        ["15"] = {14, false},
        ["16"] = {15, false},
        ["17"] = {16, false},
        ["18"] = {17, false},
        ["19"] = {18, false},
        ["20"] = {19, false},
    },
}

RegisterNetEvent('erotic-lobby:GetWorld')
AddEventHandler('erotic-lobby:GetWorld', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(WorldTracker[ids.license]);
    end
    cb("Normal");
end)

RegisterNetEvent('erotic-lobby:GetWorldBucketID')
AddEventHandler('erotic-lobby:GetWorldBucketID', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(Config.Worlds[WorldTracker[ids.license]][1]);
    end
    cb(1);
end)

AddEventHandler('playerDropped', function (reason) 
    local src = source;
    local ids = ExtractIdentifiers(src);
    WorldTracker[ids.license] = nil;
    local ids = ExtractIdentifiers(src);
end)

RegisterNetEvent('erotic-lobby:SpawnWorldTrigger')
AddEventHandler('erotic-lobby:SpawnWorldTrigger', function()
    local src = source;
    local ids = ExtractIdentifiers(src);
    if WorldTracker[ids.license] ~= nil then
        local worldName = WorldTracker[ids.license]; 
        local coords = Config.Worlds[worldName][2];
        SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
        TriggerClientEvent("erotic-lobby:updateLobby", src, Config.Worlds[worldName][1], worldName)
    end
end)

RegisterNetEvent('erotic-lobby:ChangeWorld')
AddEventHandler('erotic-lobby:ChangeWorld', function(worldName)
    local src = source;
    if Config.Worlds[worldName] ~= nil then 
        local permission = Config.Worlds[worldName][3];
        local coords = Config.Worlds[worldName][2];
        local ids = ExtractIdentifiers(src);
        if not permission then
            SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
            WorldTracker[ids.license] = worldName;
            TriggerClientEvent("erotic-lobby:updateLobby", src, Config.Worlds[worldName][1], worldName)
            TriggerClientEvent("core:updateRPC", src, worldName)
                -- Changed worlds ...
            return;
        end
    else 
        -- This world does not exist...
    end
end)

RegisterNetEvent('erotic-lobby:getPlayerWorld')
AddEventHandler('erotic-lobby:getPlayerWorld', function(playerID)
    getPlayerWorld(playerID)
end)

RegisterNetEvent('requestLobbyPlayerCount')
AddEventHandler('requestLobbyPlayerCount', function(lobbyID)
    local src = source
    local playerCount = getLobbyPlayerCount(lobbyID) -- Assuming this function exists
    TriggerClientEvent('receiveLobbyPlayerCount', src, lobbyID, playerCount)
end)

function getPlayerWorld(playerID)
    print(GetPlayerRoutingBucket(playerID))
    return GetPlayerRoutingBucket(playerID)
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end  
    return identifiers
end

function getLobbyPlayerCount(worldID)
    worldID = tostring(worldID)
    local playerCount = 0

    for _, v in pairs(WorldTracker) do
        if v == worldID then
            playerCount = playerCount + 1
        end
    end

    return playerCount
end

function updateAndSendPlayerCount(worldID)
    local count = 0

    -- Count players in the specified world
    for _, v in pairs(WorldTracker) do
        if v == worldID then
            count = count + 1
        end
    end

    -- Send this data to the frontend
    TriggerClientEvent('erotic-lobby:sendPlayerCount', -1, worldID, count)
end

exports('getLobbyPlayerCount', getLobbyPlayerCount)
exports('getPlayerWorld', getPlayerWorld)

exports['erotic-lobby']:getLobbyPlayerCount('1')