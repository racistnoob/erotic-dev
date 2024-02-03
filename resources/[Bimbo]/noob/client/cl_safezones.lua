local safezones = {
    {
        name = "southside",
        points = {
            vector2(244.15701293945, -1422.8563232422), vector2(279.76284790039, -1380.4853515625),
            vector2(318.17694091797, -1335.2751464844), vector2(311.47583007812, -1330.2349853516),
            vector2(305.27590942383, -1327.4866943359), vector2(298.92803955078, -1325.8145751953),
            vector2(279.16598510742, -1325.2359619141), vector2(260.20349121094, -1325.1212158203),
            vector2(249.63441467285, -1325.2188720703), vector2(239.58494567871, -1326.6724853516),
            vector2(234.6471862793, -1328.2790527344), vector2(230.20269775391, -1330.6145019531),
            vector2(226.00729370117, -1333.369140625), vector2(222.21691894531, -1336.7979736328),
            vector2(216.20751953125, -1345.5756835938), vector2(206.01206970215, -1362.3176269531),
            vector2(199.24990844727, -1371.6348876953), vector2(194.04737854004, -1378.2598876953),
            vector2(191.19854736328, -1382.4239501953), vector2(190.04113769531, -1387.1240234375),
            vector2(191.89637756348, -1391.4271240234), vector2(194.80685424805, -1393.8817138672)
        },
        options = {
            maxZ = 49.10112,
            minZ = 27.08866
        },
    },
    {
        name = "casino",
        points = {
            vector2(744.71405029297, -184.51640319824),
            vector2(716.62091064453, -238.47964477539),
            vector2(764.06677246094, -263.01928710938),
            vector2(785.43524169922, -273.27322387695),
            vector2(803.84234619141, -264.13116455078),
            vector2(823.20684814453, -228.90658569336)
        },
        options = {
            minZ = 16.13111114502,
            maxZ = 1001.219345092773
        }
    },
}

CreateThread(function()
    
    Citizen.Wait(1)

    for _, zone in pairs(safezones) do
        exports["noob"]:AddPolyZone(
            zone.name,
            zone.points,
            {
                debugPoly = false,
                minZ = zone.options.minZ,
                maxZ = zone.options.maxZ
            }
        )
    end
end)

AddEventHandler("polyzone:enter", function(name)
    if name == "casino" then
        inSafeZone = true
        SetLocalPlayerAsGhost(false)
        NetworkSetPlayerIsPassive(false)
        NetworkSetFriendlyFireOption(false)
        SetCanAttackFriendly(PlayerPedId(), false, false)
    elseif name == "southside" then
        inSafeZone = true
        SetLocalPlayerAsGhost(true)
        NetworkSetPlayerIsPassive(true)
        NetworkSetFriendlyFireOption(false)
        SetCanAttackFriendly(PlayerPedId(), false, false)
    end
end)

AddEventHandler("polyzone:exit", function(name)
    if name == "casino" or name == "southside" then
        inSafeZone = false
        SetLocalPlayerAsGhost(false)
        NetworkSetPlayerIsPassive(false)
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)
    end
end)

exports("putInSafeZone", function(value)
    inSafeZone = value
    SetLocalPlayerAsGhost(value)
    NetworkSetPlayerIsPassive(value)
    NetworkSetFriendlyFireOption(not value)
    SetCanAttackFriendly(PlayerPedId(), not value, not value)
end)

exports("inSafeZone", function()
    return inSafeZone
end)