local weaponCam = nil
local rotationX = 0.0
local rotationY = 0.0
local rotationSpeed = 0.15
local cameraDistance = 0.5
local distanceStep = 0.05
local distanceClamp = {min = 0.25, max = 1.0}

local math_clamp = math.clamp
local math_cos = math.cos
local math_sin = math.sin
local math_pi = math.pi
local get_disabled_control_normal = GetDisabledControlNormal
local is_disabled_control_pressed = IsDisabledControlPressed
local does_entity_exist = DoesEntityExist
local is_nui_focused = IsNuiFocused
local set_nui_focus = SetNuiFocus
local set_cam_coord = SetCamCoord
local point_cam_at_entity = PointCamAtEntity
local get_entity_forward_vector = GetEntityForwardVector
local create_cam = CreateCam
local set_cam_use_shallow_dof_mode = SetCamUseShallowDofMode
local set_cam_near_dof = SetCamNearDof
local set_cam_far_dof = SetCamFarDof
local set_cam_active = SetCamActive
local render_script_cams = RenderScriptCams
local send_nui_message = SendNUIMessage
local does_cam_exist = DoesCamExist
local createthread = CreateThread
local get_active_players = GetActivePlayers
local set_entity_locally_invisible = SetEntityLocallyInvisible
local get_player_ped = GetPlayerPed
local playerid = PlayerId
local hide_hud_and_radar_this_time = HideHudAndRadarThisFrame
local set_use_hi_dof = SetUseHiDof
local wait = Wait
local disable_player_firing = DisablePlayerFiring
local player_ped_id = PlayerPedId
local disable_all_control_actions = DisableAllControlActions
local is_disabled_control_just_pressed = IsDisabledControlJustPressed
local set_nui_focus_keep_input = SetNuiFocusKeepInput
local freeze_entity_position = FreezeEntityPosition
local delete_entity = DeleteEntity
local destroy_cam = DestroyCam
local pairs = pairs
function createWeaponCam(coords, gunHash)
    
    local weaponObject = EDIT_GUN
    rotationX = -0.013061926639404
    rotationY = 10.696850389987
    cameraDistance = 0.6

    local forwardVector = get_entity_forward_vector(weaponObject)
    local cameraX = coords.x + cameraDistance * forwardVector.x
    local cameraY = coords.y + cameraDistance * forwardVector.y
    local cameraZ = coords.z + cameraDistance * forwardVector.z

    weaponCam = create_cam("DEFAULT_SCRIPTED_CAMERA", true)
    set_cam_coord(weaponCam, cameraX, cameraY, cameraZ)
    point_cam_at_entity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    set_cam_use_shallow_dof_mode(weaponCam, true)
    set_cam_near_dof(weaponCam, 0.1)
    set_cam_far_dof(weaponCam, 0.7)
    set_cam_active(weaponCam, true)
    render_script_cams(true, false, 0, true, true)
    local hasChanged = GetWeaponBoneCoords(gunHash)
    if hasChanged then
        send_nui_message({ type = "updatePos", bonePositions = BONE_POSITIONS })
    end
    handleCamUpdates(weaponObject, gunHash, coords)
    createthread(function()
        while does_cam_exist(weaponCam) do
            Wait(1)
            ShowHelpNotification(
                'Press ~INPUT_FRONTEND_RDOWN~ Accept' ..
                '~n~Press ~INPUT_FRONTEND_PAUSE_ALTERNATE~ Cancel' ..
                '~n~Hold ~INPUT_FRONTEND_RB~ Move Camera'
            )
        end
    end)
end

local function camControl(weaponObject, coords)
    if not does_entity_exist(weaponObject) then return end
    if not is_nui_focused() then
        set_nui_focus(true, true)
    end
    if is_disabled_control_pressed(0, 206) then
        set_nui_focus(false, false)

        if is_disabled_control_pressed(2, 241) then
            cameraDistance -= distanceStep
        end

        if is_disabled_control_pressed(2, 242) then
            cameraDistance += distanceStep
        end

        if cameraDistance > distanceClamp.max then
            cameraDistance = distanceClamp.max
        end

        if cameraDistance < distanceClamp.min then
            cameraDistance = distanceClamp.min
        end

        local mouseX = get_disabled_control_normal(0, 1) * rotationSpeed
        local mouseY = get_disabled_control_normal(0, 2) * rotationSpeed

        rotationX = math_clamp(rotationX - mouseY, -math_pi / 2, math_pi / 2)
        rotationY = rotationY - mouseX
    
        local camX = coords.x + cameraDistance * math_cos(rotationY) * math_cos(rotationX)
        local camY = coords.y + cameraDistance * math_sin(rotationY) * math_cos(rotationX)
        local camZ = coords.z + cameraDistance * math_sin(rotationX)

        set_cam_coord(weaponCam, camX, camY, camZ)
        point_cam_at_entity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    end
end

function handleBackground()
    createthread(function()
        while isOpen do
            if not LOADING_VARIATION then
                for k,v in pairs(get_active_players()) do
                    if v ~= playerid() then
                        set_entity_locally_invisible(get_player_ped(v))
                    end
                end
            end
            hide_hud_and_radar_this_time()
            set_use_hi_dof()
            wait()
        end
    end)
end

function handleCamUpdates(weaponObject, gunHash, coords)
    createthread(function()
        while does_entity_exist(weaponObject) do
            wait(0)

            local plyPed = player_ped_id()
            disable_player_firing(plyPed, true)
            disable_all_control_actions(0)
            local hasChanged = GetWeaponBoneCoords(gunHash)

            if hasChanged then
                send_nui_message({ type = "updatePos", bonePositions = BONE_POSITIONS })
            end

            camControl(weaponObject, coords)

            if is_disabled_control_just_pressed(0, 191) then
                exports["erotic"]:toggleHud(true)
                exports["drp-hud"]:toggleNui(true)
                exports["killfeed"]:toggleHud(true)
                send_nui_message({ type = "openUI", toggle = false, gunData = {} })
                set_nui_focus(false, false)
                set_nui_focus_keep_input(false)
                freeze_entity_position(plyPed, false)
                delete_entity(weaponObject)
                destroy_cam(weaponCam, true)
                render_script_cams(false, false, 0, true, true)
                EDIT_GUN = nil
                break
            end
        end
    end)
end

function destroyWeaponCamera()
    destroy_cam(weaponCam, true)
    render_script_cams(false, false, 0, true, true)
    weaponCam = nil
end