-- local locations = {
--     {coords = vector3(210, -1371.7, 29.59), heading = 317.89, pedcoords = vector3(211.16, -1372.96, 29.59), pedheading = 230.3},
--     {coords = vector3(1155.77, -462.03, 65.83), heading = 257.98, pedcoords = vector3(1155.36, -463.69, 65.78), pedheading = 167.0},
--     {coords = vector3(1283.65, -2560.82, 42.98), heading = 171.17, pedcoords = vector3(1281.75, -2560.59, 42.85), pedheading = 84.84},
--     {coords = vector3(1584.45, 2893.63, 56.09), heading = 115.13, pedcoords = vector3(1583.69, 2895.07, 56.07), pedheading = 21.57 },
--     {coords = vector3(-230.56, -2435.35, 5.0), heading = 145.68, pedcoords = vector3(-232.62, -2433.64, 5.0 ), pedheading = 54.09 },
--     {coords = vector3(-326.81, 6093.21, 30.46), heading = 46.91, pedcoords = vector3(-325.41, 6094.43, 30.46), pedheading = 308.10},
--     {coords = vector3(1530.17, 6340.21, 23.15), heading = 328.67, pedcoords = vector3(1532.95, 6339.8, 23.2),  pedheading = 240.66},
--     {coords = vector3(-272.19, 6336.46, 31.43), heading = 314.76, pedcoords = vector3(-270.86, 6334.93, 31.43), pedheading = 230.0},
--     {coords = nil, heading = nil, pedcoords = vector3(-654.39, 1963.07, 499.49), pedheading = 21.94},
--     {coords = vector3(3390.74, 4094.93, 223.54), heading = 219.9, pedcoords = vector3(3391.43, 4096.71, 223.71), pedheading = 323.43},
--     {pedcoords = vector3(-1247.065, -1398.573, 3.171693), pedheading = 172.28923034668},
--     {pedcoords = vector3(-1481.769, -656.9156, 27.94311), pedheading = 213.67013549805 },
--     {pedcoords = vector3(-1576.209, -566.868, 115.3284), pedheading = 116.06464385986 }
-- }

-- local entities = {}

-- local code = "terbyte"
-- local pedspawn = "s_m_y_marine_03"
-- local spawnedAlready = false 

-- function SpawnCar(hash, atCoords, atHeading)
--     RequestModel(hash)
--     while not HasModelLoaded(hash) do Wait(0) end 
--     local veh = CreateVehicle(hash, atCoords, atHeading, false, false)
--     SetVehicleCustomPrimaryColour(veh, 0, 0 ,0)
--     SetVehicleCustomSecondaryColour(veh, 111,183,22)
--     SetVehicleDirtLevel(veh, 0.0)
--     Wait(500)
--     FreezeEntityPosition(veh, true)
--     SetBlockingOfNonTemporaryEvents(veh, true)
--     SetEntityInvincible(veh, true)
--     SetVehicleDoorsLocked(veh, 2)
--     table.insert(entities, veh)
-- end

-- function SpawnPed(hash, atCoords, atHeading)
--     RequestModel(hash)
--     while not HasModelLoaded(hash) do Wait(0) end 
--     local ped = CreatePed(0, hash, atCoords, atHeading, false, false)
--     GiveWeaponToPed(ped, GetHashKey("WEAPON_MINIGUN"), 255, false, true)
--     SetCurrentPedWeapon(ped, GetHashKey("WEAPON_MINIGUN"), true)
--     FreezeEntityPosition(ped, true)
--     SetEntityInvincible(ped, true)
--     SetBlockingOfNonTemporaryEvents(ped, true)
--     table.insert(entities, ped)
-- end


-- function SpawnTruck()
--     if spawnedAlready then return end 
--     spawnedAlready = true 
-- CreateThread(function()
--     for k,v in pairs(entities) do 
--         if DoesEntityExist(entities[k]) then DeleteEntity(entities[k])  end
--     end
--     for k,v in pairs(locations) do 
--         if v.coords ~= nil then
--             SpawnCar(GetHashKey(code), v.coords, v.heading)
--         end
--         SpawnPed(GetHashKey(pedspawn), v.pedcoords, v.pedheading)
--     end
-- end) end 

-- RegisterNetEvent("zbrp:JoinedLobby", SpawnTruck)
