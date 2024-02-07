WorldTracker = {}; -- [license] = {World = worldID, Name = PlayerName, Kills = 0}

Worlds = {}

Config = {
    Worlds = { -- ["worldID"] = {RoutingBucket, Spawnpoint, PermissionRequired},
        ["1"] = {1, false}, -- DO NOT REMOVE
        ["2"] = {2, false},
        ["3"] = {3, false},
        ["4"] = {4, false},
        ["5"] = {5, false},
        ["6"] = {6, false},
        ["7"] = {7, false},
        ["8"] = {8, false},
        ["9"] = {9, false},
        ["10"] = {10, false},
        ["11"] = {11, false},
        ["12"] = {12, false},
        ["13"] = {13, false},
        ["14"] = {14, false},
        ["15"] = {15, false},
        ["16"] = {16, false},
        ["17"] = {17, false},
        ["18"] = {18, false},
        ["19"] = {19, false},
        ["20"] = {20, false},
        ["21"] = {21, false},
        ["22"] = {22, false},
    },
}

local function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 1, GetNumPlayerIdentifiers(src) do
        local id = GetPlayerIdentifier(src, i - 1)
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
        if v.World == worldID then
            playerCount = playerCount + 1
        end
    end

    return playerCount
end

function updateAndSendPlayerCount(worldID, all, src)
    if all then -- all worlds updated to specific player (src)
        for i = 1, #Config.Worlds do
            Wait(10)
            TriggerClientEvent('erotic-lobby:sendPlayerCount', src, getLobbyPlayerCount(i), i)
        end
    else
        TriggerClientEvent('erotic-lobby:sendPlayerCount', -1, getLobbyPlayerCount(worldID), tonumber(worldID))
    end
end

function GetLobbyStats(worldID)
    local stats = {}
    for _, v in pairs(WorldTracker) do
        if v.World == worldID then
            table.insert(stats,{
                License = _,
                Name = v.Name,
                Kills = v.Kills,
                Deaths = v.Deaths,
                Damage = v.Damage,
            })
        end
    end
    table.sort(stats, function(a, b) return a.Kills > b.Kills end)
    return stats
end

function UpdateLobbyStats(source, worldID, type, data)
    local src = source
    local ids = ExtractIdentifiers(src)
    if not ids then return end

    if WorldTracker[ids.license]?.World == worldID then
        if type == "Kills" then
            WorldTracker[ids.license].Kills = WorldTracker[ids.license].Kills + 1
        elseif type == "Deaths" then
            WorldTracker[ids.license].Deaths = WorldTracker[ids.license].Deaths + 1
        elseif type == "Damage" then
            WorldTracker[ids.license].Damage = WorldTracker[ids.license].Damage + data.damage
        end
    end

    UpdateStats(worldID)
end

local function InitializeWorldTracker(license)
    if not WorldTracker[license] then
        WorldTracker[license] = {
            World = nil,
            src = nil,
            Name = nil,
            Kills = 0,
            Deaths = 0,
            Damage = 0,
        }
    end
end

function UpdateStats(worldID)
    for _, v in pairs(WorldTracker) do
        if v.World == worldID then
            TriggerClientEvent('Update:Lobby:Stats',v.src, GetLobbyStats(worldID))
        end
    end
end

function GetWorld(src)
    local ids = ExtractIdentifiers(src);
    if WorldTracker[ids.license]?.World ~= nil then
        return(WorldTracker[ids.license].World);
    end
    return "normal"
end

function getPlayersInLobby(lobbyID)
    lobbyID = tostring(lobbyID)
    local players = {}

    for _, v in pairs(WorldTracker) do
        if v.World == lobbyID then
            players[#players+1] = v.src
        end
    end

    return players
end

exports('getPlayersInLobby', getPlayersInLobby)

RegisterNetEvent('erotic-lobby:GetWorld')
AddEventHandler('erotic-lobby:GetWorld', function(src, cb)
    cb(GetWorld(src))
end)

RegisterNetEvent('erotic-lobby:GetWorldBucketID')
AddEventHandler('erotic-lobby:GetWorldBucketID', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] and WorldTracker[ids.license].World ~= nil) then 
        cb(Config.Worlds[WorldTracker[ids.license].World][1]);
    end
    cb(1);
end)

AddEventHandler('playerDropped', function (reason) 
    local src = source;
    local ids = ExtractIdentifiers(src);
    if WorldTracker[ids.license] and WorldTracker[ids.license].World ~= nil then
        local world = WorldTracker[ids.license].World
        WorldTracker[ids.license] = nil;
        UpdateStats(world)
        updateAndSendPlayerCount(world) -- updates playercount of disconnected players old lobby
    end
end)

RegisterServerEvent("erotic:playerSpawned")
AddEventHandler('erotic:playerSpawned', function()
    local src = source
    local ids = ExtractIdentifiers(src)

    InitializeWorldTracker(ids.license)

    WorldTracker[ids.license].World = "1"
    WorldTracker[ids.license].src = src
    WorldTracker[ids.license].Name = GetPlayerName(src)
    WorldTracker[ids.license].Kills = 0
    WorldTracker[ids.license].Deaths = 0
    WorldTracker[ids.license].Damage = 0

    if WorldTracker[ids.license].World then
        local worldID = WorldTracker[ids.license].World
        local coords = Config.Worlds[worldID][2]
        SetPlayerRoutingBucket(src, Config.Worlds[worldID][1])
        TriggerClientEvent("core:updateLobby", src, Config.Worlds[worldID])
        UpdateStats(worldID)
    end

    TriggerClientEvent("erotic-lobby:updateLobbies", src)
    updateAndSendPlayerCount(1) -- sends every player the new playercount of lobby 1
    Wait(1000)
    updateAndSendPlayerCount(1, true, src) -- sends every playercount only to the new player
end)

RegisterNetEvent('erotic-lobby:ChangeWorld')
AddEventHandler('erotic-lobby:ChangeWorld', function(worldID)
    local src = source;
    if Config.Worlds[worldID] == nil then
        Config.Worlds[worldID] = { tonumber(worldID), false }
    end

    local coords = Config.Worlds[worldID][2];
    local ids = ExtractIdentifiers(src);
    local oldWorld = 1
    if (WorldTracker[ids.license] and WorldTracker[ids.license].World ~= nil) then 
        oldWorld = Config.Worlds[WorldTracker[ids.license].World][1]
    end

    SetPlayerRoutingBucket(src, Config.Worlds[worldID][1]);
    exports.noob:toggleLocals(Config.Worlds[worldID][1], false)
    WorldTracker[ids.license] = {
        OldLobby = WorldTracker[ids.license] and WorldTracker[ids.license].World or worldID,
        World = worldID,
        src = src,
        Name = GetPlayerName(src),
        Kills = 0,
        Deaths = 0,
        Damage = 0,
    }
    UpdateStats(worldID)
    UpdateStats(oldWorld)
    TriggerClientEvent("core:updateLobby", src, worldID)
    updateAndSendPlayerCount(Config.Worlds[worldID][1]) -- sends plr count of new lobby
    updateAndSendPlayerCount(oldWorld) -- updates plr count of old lobby
    -- Changed worlds ...
    return;
end)

exports('getLobbyPlayerCount', getLobbyPlayerCount)
exports('GetLobbyStats', GetLobbyStats)
exports('UpdateLobbyStats', UpdateLobbyStats)
exports('GetWorld', GetWorld)