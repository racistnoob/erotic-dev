Player = {
    InAnim = false,
    Radio = false,
    CurrentKitGenre = nil,
    CurrentKit = nil,
    InStim = false,
    CanSwitch = nil
}

--[[
    THIS IS THE GLOBAL PED CLASS
]]

RegisterNetEvent("inventory:updateValues", function(genre, kit, canSwitch)
    Player.CurrentKitGenre = genre 
    Player.CurrentKit = kit 
    if canSwitch == nil then Player.CanSwitch = true
    else Player.CanSwitch = canSwitch end
end)


RegisterNetEvent("are   pawned", function()
    Player.InAnim = false 
    Player.InStim = false
end)

function GetPlayer()
    return Player 
end


function Player.InVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function Player.Name()
    return GetPlayerName(GetPlayerIndex())
end

function Player.Health()
    return GetEntityHealth(PlayerPedId())
end

function Player.Armour()
    return GetPedArmour(PlayerPedId())
end

function Player.Ped()
    return PlayerPedId()
end 

function Player.Coords()
    return GetEntityCoords(PlayerPedId())
end

function Player.Kill()
    SetEntityHealth(PlayerPedId(), 0)
end

function Player.ServerID() -- experimental
    return GetPlayerServerId(GetPlayerIndex())
end



function Player.GetTargetVehicle(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end