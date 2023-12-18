local gangMembers = {}

function SpawnHostileGangMembers()

    local playerPed = PlayerId()
    local playerCoords = GetEntityCoords(GetPlayerPed(playerPed))
    local groupHandle = CreateGroup(0)

    RequestModel(GetHashKey("g_m_y_salvagoon_01"))

    for i = 1, 20 do
        local randomX = playerCoords.x + math.random(-100, 100)
        local randomY = playerCoords.y + math.random(-100, 100)
        local gangPed = CreatePed(28, GetHashKey("g_m_y_salvagoon_01"), randomX, randomY, playerCoords.z, 0.0, true, false)

        SetEntityAsMissionEntity(gangPed, true, true)
        SetEntityCanBeDamaged(gangPed, true)
        SetPedCanBeShotInVehicle(gangPed, false)
        SetPedSuffersCriticalHits(gangPed, false)
        TaskCombatPed(gangPed, GetPlayerPed(playerPed), 0, 16)
        SetPedAsGroupMember(gangPed, groupHandle)
        SetGroupSeparationRange(groupHandle, 100.0)
        SetPedRelationshipGroupHash(gangPed, GetHashKey("GANG_1"))

        local weaponHash = GetHashKey("weapon_assaultrifle")
        GiveWeaponToPed(gangPed, weaponHash, 250, false, true)
        SetPedWeaponTintIndex(gangPed, weaponHash, 4)
        SetPedDropsWeaponsWhenDead(gangPed, false)
        GiveWeaponComponentToPed(gangPed, weaponHash, `COMPONENT_AT_SCOPE_MACRO`)

        table.insert(gangMembers, gangPed)
    end
end

function StartGangFight()
    DespawnGangMembers()
    SpawnHostileGangMembers()
end

function AttackGangMembers(attacker)
    for i, ped in ipairs(gangMembers) do
        if DoesEntityExist(ped) and DoesEntityExist(attacker) and ped ~= attacker then
            TaskCombatPed(ped, attacker, 0, 16)
        end
    end
end

AddEventHandler("EntityGotDamaged", function(attacker, weaponHash, _, _, _)
    local attackerType = GetEntityType(attacker)
    if attackerType == 1 then
        AttackGangMembers(attacker)
    end
end)

function DespawnGangMembers()
    for i, ped in ipairs(gangMembers) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    gangMembers = {}
end

RegisterCommand("gangfight", function()
    currentWave = 0  -- Reset the wave counter
    DespawnGangMembers()
    SpawnHostileGangMembers()
end, false)

RegisterCommand("despawngang", function()
    DespawnGangMembers()
end, false)

exports('StartGangFight', StartGangFight)
exports('DespawnGangMembers', ExportedFunction_DespawnGangMembers)