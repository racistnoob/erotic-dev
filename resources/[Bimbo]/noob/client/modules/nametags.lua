local disPlayerNames = 10
local playerDistances = {}

local get_screen_coord_from_world_coord = GetScreenCoordFromWorldCoord
local get_final_rendered_cam_coord = GetFinalRenderedCamCoord
local get_gameplay_cam_fov = GetGameplayCamFov
local set_text_scale = SetTextScale
local set_text_font = SetTextFont
local set_text_proportional = SetTextProportional
local set_text_colour = SetTextColour
local set_text_dropshadow = SetTextDropshadow
local set_text_edge = SetTextEdge
local set_text_outline = SetTextOutline
local set_text_centre = SetTextCentre
local begin_text_command_display_text = BeginTextCommandDisplayText
local add_text_component_substring_player_name = AddTextComponentSubstringPlayerName
local end_text_command_display_text = EndTextCommandDisplayText

function DrawText3D(position, text, r, g, b)
    local onScreen, _x, _y = get_screen_coord_from_world_coord(position.x, position.y, position.z + 0.4)
    local dist = #(get_final_rendered_cam_coord() - position)

    local scale = (1 / dist) * 2
    local fov = (1 / get_gameplay_cam_fov()) * 100
    local scale = scale * fov

    if onScreen then
        set_text_scale(0.0 * scale, 0.5 * scale)
        set_text_font(0)
        set_text_proportional(1)
        set_text_colour(r, g, b, 255)
        set_text_dropshadow(0, 0, 0, 0, 255)
        set_text_edge(2, 0, 0, 0, 150)
        set_text_dropshadow()
        set_text_outline()
        begin_text_command_display_text("STRING")
        set_text_centre(1)
        add_text_component_substring_player_name(text)
        end_text_command_display_text(_x, _y)
    end
end

local showing = false

local wait = Wait
local player_ped_id = PlayerPedId
local get_entity_coords = GetEntityCoords
local get_active_players = GetActivePlayers
local get_player_ped = GetPlayerPed
local has_entity_clear_los_to_entity = HasEntityClearLosToEntity
local network_is_player_talking = NetworkIsPlayerTalking
local get_ped_bone_coords = GetPedBoneCoords
local get_player_server_id = GetPlayerServerId
local get_player_name = GetPlayerName

local function ShowIds()
    local playerPed = player_ped_id()
    local playerCoords = get_entity_coords(playerPed)

    for _, id in pairs(get_active_players()) do
        local targetPed = get_player_ped(id)
        if targetPed ~= playerPed then
            local distance = #(playerCoords - get_entity_coords(targetPed))
            playerDistances[id] = distance
        end
    end

    CreateThread(function()
        while showing do
            for _, id in pairs(get_active_players()) do
                local targetPed = get_player_ped(id)
                if targetPed ~= player_ped_id() then
                    if playerDistances[id] then
                        if playerDistances[id] < disPlayerNames and
                        has_entity_clear_los_to_entity(player_ped_id(), targetPed, 17) then
                            local targetPedCords = get_ped_bone_coords(targetPed, 31086)
                            if network_is_player_talking(id) then
                                DrawText3D(targetPedCords, get_player_server_id(id) .. " | " .. get_player_name(id), 0, 200, 55)
                            else
                                DrawText3D(targetPedCords, get_player_server_id(id) .. " | " .. get_player_name(id), 255,255, 255)
                            end
                        end
                    end
                end
            end
            wait(1)
        end
    end)
    
    CreateThread(function()
        while showing do
            local playerPed = player_ped_id()
            local playerCoords = get_entity_coords(playerPed)
    
            for _, id in pairs(get_active_players()) do
                local targetPed = get_player_ped(id)
                if targetPed ~= playerPed then
                    local distance = #(playerCoords - get_entity_coords(targetPed))
                    playerDistances[id] = distance
                end
            end
            wait(1000)
        end
    end)
end

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
