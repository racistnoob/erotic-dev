WorldTracker = {};

Config = {}
Config = {
    Worlds = { -- ["WorldName"] = {RoutingBucket, Spawnpoint, PermissionRequired},
        ["1"] = {0, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false}, -- DO NOT REMOVE
        ["2"] = {1, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["3"] = {2, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["4"] = {3, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["5"] = {4, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["6"] = {5, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["7"] = {6, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["8"] = {7, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["9"] = {8, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["10"] = {9, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["11"] = {10, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["12"] = {11, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["13"] = {12, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["14"] = {13, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["15"] = {14, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["16"] = {15, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["17"] = {16, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["18"] = {17, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["19"] = {18, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
        ["20"] = {19, { 233.5797, -1393.9111, 30.5152, 143.0110 }, false},
    },
}

RegisterNetEvent('Multiverse:GetWorld')
AddEventHandler('Multiverse:GetWorld', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(WorldTracker[ids.license]);
    end
    cb("Normal");
end)

RegisterNetEvent('Multiverse:GetWorldBucketID')
AddEventHandler('Multiverse:GetWorldBucketID', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(Config.Worlds[WorldTracker[ids.license]][1]);
    end
    cb(1);
end)

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

AddEventHandler('playerDropped', function (reason) 
    local src = source;
    local ids = ExtractIdentifiers(src);
    WorldTracker[ids.license] = nil;
    local ids = ExtractIdentifiers(src);
end)

RegisterNetEvent('Multiverse:SpawnWorldTrigger')
AddEventHandler('Multiverse:SpawnWorldTrigger', function()
    local src = source;
    local ids = ExtractIdentifiers(src);
    if WorldTracker[ids.license] ~= nil then
        local worldName = WorldTracker[ids.license]; 
        local coords = Config.Worlds[worldName][2];
        SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
        TriggerClientEvent("Multiverse:ChangeCoords", src, coords[1], coords[2], coords[3])
    end
end)

RegisterNetEvent('Multiverse:ChangeWorld')
AddEventHandler('Multiverse:ChangeWorld', function(worldName)
    local src = source;
    if Config.Worlds[worldName] ~= nil then 
        local permission = Config.Worlds[worldName][3];
        local coords = Config.Worlds[worldName][2];
        local ids = ExtractIdentifiers(src);
        if not permission then
            SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
            TriggerClientEvent("Multiverse:ChangeCoords", src, coords[1], coords[2], coords[3])
            WorldTracker[ids.license] = worldName;
                -- Changed worlds ...
            return;
        end
    else 
        -- This world does not exist...
    end
end)
