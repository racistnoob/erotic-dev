local BlackListedVehicles = {
    'RHINO',
    'dune4',
    'dune5',
    'phantom2',
    'technical2',
    'technical3',
    'apc',
    'tampa3',
    'dune3',
    'trailersmall2',
    'halftrack',
    'vigilante',
    'barrage',
    'chernobog',
    'thruster',
    'khanjali',
    'volatol',
    'caracara',
    'menacer',
    'oppressor',
    'oppressor2',
    'scramjet',
    'strikeforce',
    'bruiser',
    'bruiser2',
    'bruiser3',
    'cerberus',
    'cerberus2',
    'cerberus3',
    'deathbike2',
    'deathbike3',
    'CargoPlane',
    'jet',
    'hydra',
    'titan',
    'cargobob',
    'cargoplane',
    'buzzard',
    'buzzard2',
    'cargobob2',
    'cargobob3',
    'cargobob4',
    'frogger',
    'frogger2',
    'maverick',
    'savage',
    'skylift',
    'supervolito',
    'supervolito2',
    'swift',
    'swift2',
    'valkyrie',
    'valkyrie2',
    'volatus',
    'hunter',
    'alphaz1',
    'avenger',
    'avenger2',
    'besra',
    'bombushka',
    'dodo',
    'howard',
    'howard2',
    'jet',
    'lazer',
    'mogul',
    'molotok',
    'nimbus',
    'nokota',
    'pyro',
    'rogue',
    'seabreeze',
    'shamal',
    'starling',
    'strikeforce',
    'tula',
    'titan',
    'tula',
    'volatol',
    'vestra',
    'benson',
    'biff',
    'bulldozer',
    'cutter',
    'dump',
    'flatbed',
    'guardian',
    'handler',
    'mixer',
    'mixer2',
    'rubble',
    'tiptruck',
    'tiptruck2',
    'freight',
    'freightcar',
    'freightcont1',
    'freightcont2',
    'freightgrain',
    'freighttrailer',
    'tankercar',
    'metrotrain',
    's_m_m_lsmetro_01',
    's_m_m_lsmetro_02',
    'a_m_y_acult_01',
    's_m_m_lsmetro_03',
    'prop_rail_boxcar',
    'prop_rail_boxcar2',
    'prop_rail_boxcar3',
    'prop_rail_boxcar4',
    'prop_rail_boxcar5',
    'prop_rail_cont_01',
    'prop_rail_cont_02',
    'prop_rail_cont_03',
    'prop_rail_cont_04',
    'prop_rail_container01a',
    'prop_rail_container01b',
    'prop_rail_crane_01',
    'prop_rail_points04',
    'prop_rail_points01',
    'prop_rail_points02',
    'prop_rail_tankcar',
    'prop_rail_tankcar2',
    'prop_rail_tankcar3',
    'prop_rail_wellcar',
    'prop_rail_wellcar2',
    'airtug',
    'caddy',
    'caddy2',
    'caddy3',
    'docktug',
    'dozer',
    'forklift',
    'mower',
    'rentalbus',
    'rallytruck',
    'scraper',
    'towtruck',
    'towtruck2',
    'tractor',
    'tractor2',
    'tractor3',
    'utilitruck2',
    'utilitruck3',
    'utilitruck',
    'ripley',
    'benson',
    'biff',
    'cerberus',
    'cerberus2',
    'cerberus3',
    'hauler',
    'hauler2',
    'mule',
    'mule2',
    'mule3',
    'mule4',
    'packer',
    'phantom',
    'phantom2',
    'phantom3',
    'rubble',
    'stockade',
    'stockade3',
    'dinghy',
    'dinghy2',
    'dinghy3',
    'dinghy4',
    'dinghy5',
    'jetmax',
    'marquis',
    'seashark',
    'seashark2',
    'seashark3',
    'speeder',
    'speeder2',
    'squalo',
    'suntrap',
    'toro',
    'toro2',
    'tropic',
    'tropic2',
    'submersible',
    'submersible2',
    'riot',
    'RIOT2',
    'buffalo4',
    'adder',
    'bus',
    'rcbandito',
    'minitank',
    'voltic2',
    'blimp',
    'blimp2',
    'blimp3',
    'Technical Aqua',
    'Technical',
    'akua',
    'brickade',
    'insurgent',
    'insurgent2',
    'insurgent3',
    'tug',
    'Kosatka',
    'paragon2',
    'cabelcar',
    'Annihilator',
    'scarab',
    'scarab2',
    'scarab3',
    'scarab4',
    'akula',
    'nightshark',
    'duke2',
    'Toreador',
    'Miljet',
    'limo2',
    'luxor',
    'duster',
    'Mammatus',
    'Conada',
    'Velum',
    'zentorno',
    'ignus',
    'ZR380',
    'ZR3802',
    'ZR3803',
    'armytrailer',
    'baletrailer',
    'Annihilator Stealth',
    'Ardent',
    'Alkonost',
    'havok',
    'Avisa',
    'Stromberg',
    'Kuruma',
    'Kuruma2',
    'deluxo',
    'as350',
    'polmav',
    'seasparrow',
    'Annihilator2',
    'firetruk',
    'flatbed',
    'trash',
    'graintrailer',
    'cuban800',
    'stunt',
    'velum2',
    'seasparrow2',
    'seasparrow3',
    'patrolboat',
}

spawningcars = false

function Spawningcars(state)
    spawningcars = state
end

exports("spawningcars", Spawningcars)

RegisterNetEvent("drp:spawnvehicle")
AddEventHandler("drp:spawnvehicle", function(veh)
    if spawningcars then
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.5, 0.0, 0.0))
        local vehiclehash = GetHashKey(veh)
        local playerPed = PlayerPedId()

        local function IsVehicleBlacklisted(model)
            for _, blacklistedModel in ipairs(BlackListedVehicles) do
                if model == GetHashKey(blacklistedModel) then
                    return true
                end
            end
            return false
        end

        if IsVehicleBlacklisted(vehiclehash) then
            exports['drp-notifications']:SendAlert('inform', 'This vehicle cannot be spawned.', 5000)
            return
        end

        RequestModel(vehiclehash)
        Citizen.CreateThread(function()
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
                    return
                end
            end

            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(currentVehicle) then
                Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(currentVehicle))
            end

            local car = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(playerPed), 1, 0)
            if DoesEntityExist(car) then
                SetPedIntoVehicle(playerPed, car, -1)
                exports['drp-notifications']:SendAlert('inform', 'Vehicle spawned', 5000)
                lastSpawnedCarHash = vehiclehash
                TriggerEvent('keys:addNew', car, GetVehicleNumberPlateText(car))

                Citizen.CreateThread(function()
                    local savedMods = GetResourceKvpString("vehicle_" .. tostring(vehiclehash) .. "_mods")
                    if savedMods then
                        local parsedMods = json.decode(savedMods)
                        if parsedMods then
                            exports["core"]:SetVehicleProperties(car, parsedMods)
                        end
                    end
                end)
            else
                exports['drp-notifications']:SendAlert('inform', 'Failed to spawn the vehicle.', 5000)
            end
        end)
    else
        print('cars = ^1{false}')
    end
end)