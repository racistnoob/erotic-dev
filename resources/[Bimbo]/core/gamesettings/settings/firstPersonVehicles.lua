local firstPersonVehicleEnabled = false
local shakeCounter = 0
local shakeCounter2 = 0
local isShaking = false

local wait = Wait
local is_ped_in_any_vehicle = IsPedInAnyVehicle
local get_follow_vehicle_cam_view_mode = GetFollowVehicleCamViewMode
local set_follow_vehicle_cam_view_mode = SetFollowVehicleCamViewMode
local is_control_pressed = IsControlPressed
local is_using_keyboard = IsUsingKeyboard
local is_aim_cam_active = IsAimCamActive
local disable_aim_cam_this_update = DisableAimCamThisUpdate

local function firstPersonVehicle()
    CreateThread(function()
        while firstPersonVehicleEnabled do
            wait(10)
            local isInVehicle = is_ped_in_any_vehicle(PlayerPed, false)
            local viewMode = get_follow_vehicle_cam_view_mode()
            local isAiming = (is_control_pressed(0, 25) and is_using_keyboard(0)) or is_aim_cam_active()

            if not isInVehicle then
                wait(1000)
            elseif isInVehicle and isAiming and not WasAimingThirdPerson then
                if viewMode ~= 4 then
                    set_follow_vehicle_cam_view_mode(4)
                    disable_aim_cam_this_update()
                    WasAimingThirdPerson = viewMode
                end
            elseif WasAimingThirdPerson and not isAiming then
                set_follow_vehicle_cam_view_mode(WasAimingThirdPerson)
                WasAimingThirdPerson = false
            end
        end
    end)

    Citizen.CreateThread(function()
        while firstPersonVehicleEnabled do
            local plyPed = PlayerPed
            local isAiming = IsPlayerFreeAiming(PlayerId())
    
            if IsPedInAnyVehicle(plyPed, false) then
                -- Player is in a vehicle
                local isPedStill = IsPedStill(plyPed)
    
                if isAiming and isPedStill and not IsPedAimingFromCover(plyPed) then
                    Wait(100)
                    shakeCounter = shakeCounter + 1
                    shakeCounter2 = 0
    
                    if shakeCounter == 5 then
                        isShaking = true
                        ShakeGameplayCam('HAND_SHAKE', 0.2)
                    end
                elseif isAiming and not isPedStill then
                    Wait(10)
                    shakeCounter2 = shakeCounter2 + 1
                    shakeCounter = 0
    
                    if shakeCounter2 == 5 then
                        isShaking = true
                        ShakeGameplayCam('HAND_SHAKE', 0.9)
                    end
    
                    shakeCounter = 0
                    shakeCounter2 = 0
                else
                    if isShaking then
                        isShaking = false
                        shakeCounter = 0
                        shakeCounter2 = 0
                        StopGameplayCamShaking(true)
                    end
    
                    Wait(1000)
                end
            else
                -- Player is not in a vehicle, reset counters and shaking
                if isShaking then
                    isShaking = false
                    shakeCounter = 0
                    shakeCounter2 = 0
                    StopGameplayCamShaking(true)
                end
    
                Wait(1000)
            end
    
            Wait(0)
        end
    end)
end

function SetFirstPersonVehicleEnabled(state)
    firstPersonVehicleEnabled = state
    isShaking = false
    shakeCounter = 0
    shakeCounter2 = 0
    StopGameplayCamShaking(true)
    if state then
        firstPersonVehicle()
    end
end

exports("setFirstPersonVehicleEnabled", SetFirstPersonVehicleEnabled)