
Citizen.CreateThread(function()
    while true do
        local sleepTimer = 1500
        if exports.noob:inSafeZone() then
            sleepTimer = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())
            local v3Coords = vec3(benchCoords.x, benchCoords.y, benchCoords.z)
            local distance = #(playerCoords - v3Coords)
            if distance < 5 and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                sleepTimer = 1
                if distance < 2 then
                    if not isOpen then
                        DrawText3D(v3Coords.x, v3Coords.y, v3Coords.z, "Press E to use the bench")
                        if IsControlJustReleased(0, 38) and not isOpen then
                            TriggerEvent("erp-weaponbench:openMenu", {
                                editCoords = vec4(241, -1391.5, 29.5600624+1.2, -196)
                            })
                        end
                    else
                        HideHudAndRadarThisFrame()
                        SetUseHiDof()

                        if not LOADING_VARIATION then
                            for k,v in pairs(GetActivePlayers()) do
                                if v ~= PlayerId() then
                                    SetEntityLocallyInvisible(GetPlayerPed(v))
                                end
                            end
                        end
                    end
                end
            end
        else
            sleepTimer = 3000
        end
        Wait(sleepTimer)
    end
end)