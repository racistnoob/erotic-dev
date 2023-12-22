local locations = {
    -- {coords = vector3(210, -1371.7, 29.59), heading = 317.89, pedcoords = vector3(211.16, -1372.96, 29.59), pedheading = 230.3},

}

local entities = {}

local code = "terbyte"
local pedspawn = "s_m_y_marine_03"
local spawnedAlready = false 

function SpawnCar(hash, atCoords, atHeading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end 
    local veh = CreateVehicle(hash, atCoords, atHeading, false, false)
    SetVehicleCustomPrimaryColour(veh, 0, 0 ,0)
    SetVehicleCustomSecondaryColour(veh, 111,183,22)
    SetVehicleDirtLevel(veh, 0.0)
    Wait(500)
    FreezeEntityPosition(veh, true)
    SetBlockingOfNonTemporaryEvents(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleDoorsLocked(veh, 2)
    table.insert(entities, veh)
end

function SpawnPed(hash, atCoords, atHeading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end 
    local ped = CreatePed(0, hash, atCoords, atHeading, false, false)
    GiveWeaponToPed(ped, GetHashKey("WEAPON_MINIGUN"), 255, false, true)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MINIGUN"), true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    table.insert(entities, ped)
end

function SpawnTruck()
    if spawnedAlready then return end 
    spawnedAlready = true 
CreateThread(function()
    for k,v in pairs(entities) do 
        if DoesEntityExist(entities[k]) then DeleteEntity(entities[k])  end
    end
    for k,v in pairs(locations) do 
        if v.coords ~= nil then
            SpawnCar(GetHashKey(code), v.coords, v.heading)
        end
        SpawnPed(GetHashKey(pedspawn), v.pedcoords, v.pedheading)
    end
end) end 

RegisterNetEvent("zbrp:JoinedLobby", SpawnTruck)