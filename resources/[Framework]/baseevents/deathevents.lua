local isDead, plyPed, playerCID, validPlayer = false, PlayerPedId(), false, false

local wait = Wait
local pairs = pairs
local player_ped_id = PlayerPedId
local does_entity_exist = DoesEntityExist
CreateThread(function()
    while true do 
        wait(5000)
        plyPed = player_ped_id()
        validPlayer = does_entity_exist(plyPed)
    end
end)

local get_vehicle_ped_is_in = GetVehiclePedIsIn
local get_vehicle_max_number_of_passengers = GetVehicleMaxNumberOfPassengers
local get_ped_in_vehicle_seat = GetPedInVehicleSeat
local function GetPedVehicleSeat(ped)
    local vehicle = get_vehicle_ped_is_in(ped, false)
    for i=-2,get_vehicle_max_number_of_passengers(vehicle) do
        if(get_ped_in_vehicle_seat(vehicle, i) == ped) then return i end
    end
    return -2
end

RegisterNetEvent('baseevents:revived')
AddEventHandler('baseevents:revived', function()
	isDead = false
    SetPedArmour(player_ped_id(), 100)
end)

local get_active_players = GetActivePlayers
local network_is_player_active = NetworkIsPlayerActive
local get_player_ped = GetPlayerPed
local function GetPlayerByEntityID(id)
    for _, player in pairs(get_active_players()) do 
        if network_is_player_active(player) and get_player_ped(player) == id  then 
            return player 
        end 
    end
    return nil
end

RegisterNetEvent('erotic:playerSpawned') -- Use this to grab player info on spawn.
AddEventHandler('erotic:playerSpawned', function() 
    validPlayer = does_entity_exist(plyPed)
end)

local is_ped_fatally_injured = IsPedFatallyInjured
local network_get_entity_killer_of_player = NetworkGetEntityKillerOfPlayer
local get_entity_type = GetEntityType
local get_ped_type = GetPedType
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local get_display_name_from_vehicle_model = GetDisplayNameFromVehicleModel
local get_entity_model = GetEntityModel
local player_id = PlayerId
local get_vehicle_ped_is_using = GetVehiclePedIsUsing
local get_player_by_entity_id = GetPlayerByEntityID
local get_player_server_id = GetPlayerServerId
local get_entity_coords = GetEntityCoords
local trigger_event = TriggerEvent
local trigger_server_event = TriggerServerEvent
local table_unpack = table.unpack
local get_ped_vehicle_seat = GetPedVehicleSeat

CreateThread(function()
    wait(8000)
    while true do 
        wait(0)

        if validPlayer then
            if is_ped_fatally_injured(plyPed) and not isDead then
                if GetPlayerInvincible(plyPed) then
                    return
                end
                isDead = true
                local killer, killerweapon = network_get_entity_killer_of_player(player_id())
                local killerentitytype = get_entity_type(killer)
                local killertype, killerinvehicle, killervehiclename, killervehicleseat = -1, false, '', 0

                if killerentitytype == 1 then
                    killertype = get_ped_type(killer)
                    if is_ped_in_any_vehicle(killer, false) == 1 then
                        killerinvehicle = true
                        killervehiclename = get_display_name_from_vehicle_model(get_entity_model(get_vehicle_ped_is_using(killer))) or "None"
                        killervehicleseat = get_ped_vehicle_seat(killer)
                    else killerinvehicle = false
                    end
                end
                
                local killerid = get_player_by_entity_id(killer)
                if killer ~= plyPed and killerid ~= nil and network_is_player_active(killerid) then killerid = get_player_server_id(killerid)
                else killerid = -1
                end

                local coords = table_unpack(get_entity_coords(plyPed))
                if killer == plyPed or killer == -1 then
                    trigger_event('baseevents:onPlayerDied', killertype, coords, true)
                    trigger_server_event('baseevents:onPlayerDied', killertype, coords, true)
                else
                    trigger_event('baseevents:onPlayerDied', killertype, coords )
                    trigger_server_event('baseevents:onPlayerDied', killertype, coords)
                    trigger_event('baseevents:onPlayerKilled', killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=coords})
                    trigger_server_event('baseevents:onPlayerKilled', killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=coords})
                end
            end
        end
    end
end)    