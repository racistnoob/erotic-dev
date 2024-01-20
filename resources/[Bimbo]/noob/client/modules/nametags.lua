local disPlayerNames = 10
local playerDistances = {}

function DrawText3D(position, text, r, g, b)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(position.x, position.y, position.z + 0.4)
    local dist = #(GetFinalRenderedCamCoord() - position)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.5 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local showing = false

local function ShowIds()
    CreateThread(function()
        while showing do
            for _, id in pairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(id)
                if targetPed ~= PlayerPedId() then
                    if playerDistances[id] then
                        if playerDistances[id] < disPlayerNames and
                            HasEntityClearLosToEntity(PlayerPedId(), targetPed, 17) then
                            local targetPedCords = GetPedBoneCoords(targetPed, 31086)
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(targetPedCords, GetPlayerServerId(id) .. " | " .. GetPlayerName(id), 0, 200, 55)
                            else
                                DrawText3D(targetPedCords, GetPlayerServerId(id) .. " | " .. GetPlayerName(id), 255,255, 255)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(1)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, id in pairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= playerPed then
                local distance = #(playerCoords - GetEntityCoords(targetPed))
                playerDistances[id] = distance
            end
        end
        Wait(1000)
    end
end)

RegisterCommand("+showtags", function()
    showing = not showing
    if showing then
        ShowIds()
        exports['drp-notifications']:SendAlert('inform', 'Nametags enabled', 5000)
    elseif not showing then
        exports['drp-notifications']:SendAlert('inform', 'Nametags disabled', 5000)
    end
end)
RegisterKeyMapping("+showtags", "Show nametags", "keyboard", "u")
