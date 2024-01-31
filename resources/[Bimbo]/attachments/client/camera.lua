local weaponCam = nil
local rotationX = 0.0
local rotationY = 0.0
local rotationSpeed = 0.15
local cameraDistance = 0.5
local distanceStep = 0.05
local distanceClamp = {min = 0.25, max = 1.0}

function createWeaponCam(coords, gunHash)
    
    local weaponObject = EDIT_GUN
    rotationX = -0.013061926639404
    rotationY = 10.696850389987
    cameraDistance = 0.6

    local forwardVector = GetEntityForwardVector(weaponObject)
    local cameraX = coords.x + cameraDistance * forwardVector.x
    local cameraY = coords.y + cameraDistance * forwardVector.y
    local cameraZ = coords.z + cameraDistance * forwardVector.z

    weaponCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(weaponCam, cameraX, cameraY, cameraZ)
    PointCamAtEntity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    SetCamUseShallowDofMode(weaponCam, true)
    SetCamNearDof(weaponCam, 0.1)
    SetCamFarDof(weaponCam, 0.7)
    SetCamActive(weaponCam, true)
    RenderScriptCams(true, false, 0, true, true)
    local hasChanged = GetWeaponBoneCoords(gunHash)
    if hasChanged then
        SendNUIMessage({ type = "updatePos", bonePositions = BONE_POSITIONS })
    end
    handleCamUpdates(weaponObject, gunHash, coords)
    CreateThread(function()
        while DoesCamExist(weaponCam) do
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
    if not DoesEntityExist(weaponObject) then return end
    if not IsNuiFocused() then
        SetNuiFocus(true, true)
    end
    if IsDisabledControlPressed(0, 206) then
        SetNuiFocus(false, false)

        if IsDisabledControlPressed(2, 241) then
            cameraDistance -= distanceStep
        end

        if IsDisabledControlPressed(2, 242) then
            cameraDistance += distanceStep
        end

        if cameraDistance > distanceClamp.max then
            cameraDistance = distanceClamp.max
        end

        if cameraDistance < distanceClamp.min then
            cameraDistance = distanceClamp.min
        end

        local mouseX = GetDisabledControlNormal(0, 1) * rotationSpeed
        local mouseY = GetDisabledControlNormal(0, 2) * rotationSpeed

        rotationX = math.clamp(rotationX - mouseY, -math.pi / 2, math.pi / 2)
        rotationY = rotationY - mouseX
    
        local camX = coords.x + cameraDistance * math.cos(rotationY) * math.cos(rotationX)
        local camY = coords.y + cameraDistance * math.sin(rotationY) * math.cos(rotationX)
        local camZ = coords.z + cameraDistance * math.sin(rotationX)

        SetCamCoord(weaponCam, camX, camY, camZ)
        PointCamAtEntity(weaponCam, weaponObject, 0.0, 0.0, 0.0, true)
    end
end

function handleBackground()
    CreateThread(function()
        while isOpen do
            if not LOADING_VARIATION then
                for k,v in pairs(GetActivePlayers()) do
                    if v ~= PlayerId() then
                        SetEntityLocallyInvisible(GetPlayerPed(v))
                    end
                end
            end
            HideHudAndRadarThisFrame()
            SetUseHiDof()
            Wait()
        end
    end)
end

function handleCamUpdates(weaponObject, gunHash, coords)
    CreateThread(function()
        while DoesEntityExist(weaponObject) do
            Wait(0)

            DisablePlayerFiring(PlayerPedId(), true)
            DisableAllControlActions(0)
            local hasChanged = GetWeaponBoneCoords(gunHash)

            if hasChanged then
                SendNUIMessage({ type = "updatePos", bonePositions = BONE_POSITIONS })
            end

            camControl(weaponObject, coords)

            if IsDisabledControlJustPressed(0, 191) then
                exports["erotic"]:toggleHud(true)
                exports["drp-hud"]:toggleNui(true)
                exports["killfeed"]:toggleHud(true)
                SendNUIMessage({ type = "openUI", toggle = false, gunData = {} })
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                FreezeEntityPosition(PlayerPedId(), false)
                DeleteEntity(weaponObject)
                DestroyCam(weaponCam, true)
                RenderScriptCams(false, false, 0, true, true)
                EDIT_GUN = nil
                break
            end
        end
    end)
end

function destroyWeaponCamera()
    DestroyCam(weaponCam, true)
    RenderScriptCams(false, false, 0, true, true)
    weaponCam = nil
end