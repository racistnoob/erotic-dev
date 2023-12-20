local firstPersonVehicleEnabled = false

function SetFirstPersonVehicleEnabled(state)
    firstPersonVehicleEnabled = state
end

exports("setFirstPersonVehicleEnabled", SetFirstPersonVehicleEnabled)

local disableV = false -- Prevents cam management
local wasInVehicle = false -- A check for if they were in the vehicle.
local disableAim = false -- Variable used to check if their aim should be disabled whilst in a vehicle.
local changeCooldown, lastView = 0, 0
local isAiming = false
local shouldDisable = false;
local isArmed = false;
local isInHeli = false;
local plyId = PlayerId()

local function setViewMode(viewmode)
    for i = 1, 7 do
        SetCamViewModeForContext(i, viewmode)
    end
    SetFollowPedCamViewMode(viewmode)
    SetFollowVehicleCamViewMode(viewmode)
end

local function forceFp(plyId)
    SetCamEffect(0)
    local currCam, currVehCam = GetFollowPedCamViewMode(), GetFollowVehicleCamViewMode()

    if currCam ~= 4 or currVehCam ~= 4 then
        lastView = GetFollowPedCamViewMode()
        setViewMode(4)
        changeCooldown = GetGameTimer() + 2500
        shouldDisable = true
    elseif currCam == 0 then
        SetPlayerCanDoDriveBy(plyId, false)
        disableAim = true
    end

    if GetCamViewModeForContext(GetCamActiveViewModeContext()) ~= 4 then 
        SetPlayerCanDoDriveBy(plyId, false)
        disableAim = true
    elseif disableAim then
        disableAim = false
        SetPlayerCanDoDriveBy(plyId, true)
    end

    disableV = true
end

local function exitFp(plyId)
    shouldDisable = true;
    local currCam = GetFollowPedCamViewMode()
    if currCam == 1 or currCam == 2 then
        if wasInVehicle then 
            SetFollowPedCamViewMode(0)
            SetFollowVehicleCamViewMode(0)
            while GetFollowPedCamViewMode() ~= 0 do
                Wait(0)
                SetFollowPedCamViewMode(0)
                SetFollowVehicleCamViewMode(0)
            end
        else
            setViewMode(0)
            shouldDisable = true
        end
    end
    if disableAim then SetPlayerCanDoDriveBy(plyId, true) disableAim = false end;
    wasInVehicle = false
end

CreateThread(function()
    while true do
        Wait(500)
        isArmed = IsPedArmed(PlayerPedId(), 4)--[[and GetSelectedPedWeapon(plyPed) ~= -1569615261]]
    end
end)

local function SomethingDumb(plyId)
    if changeCooldown ~= 0 then
        if changeCooldown < GetGameTimer() then
            changeCooldown = 0
            setViewMode(lastView)
        end
    end

    if (GetFollowPedCamViewMode() == 2 or GetFollowVehicleCamViewMode() == 2) and not isInHeli then
        setViewMode(4)
        shouldDisable = true
    end

    if disableAim then 
        SetPlayerCanDoDriveBy(plyId, true) 
        disableAim = false 
    end
    disableV = false
end

local vehicle = { id = 0, class = 0 }
RegisterNetEvent('baseevents:enteredVehicle', function(veh, _, class)
    isInHeli = IsPedInAnyHeli(PlayerPedId())
    vehicle = { id = veh, class = class }

    wasInVehicle = true

end)
RegisterNetEvent('baseevents:leftVehicle', function()
    isInHeli = IsPedInAnyHeli(PlayerPedId())
    vehicle = { id = 0, class = 0 }
end)

CreateThread(function()
    SetPlayerLockon(plyId, false)
    while true do
        Wait(100)
        if firstPersonVehicleEnabled then
            if isArmed then
                if disableV then DisableControlAction(1, 0, true) end
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
            if isArmed then
                isAiming = IsPlayerFreeAiming(plyId)
                if not isAiming then isAiming = IsAimCamActive() end
                if isAiming then
                    local model = GetEntityModel(vehicle.id)
                    local inVehicle = vehicle.id ~= 0
                    local isBike = vehicle.class == 8 or vehicle.class == 13
                    if inVehicle and isAiming and not isBike then
                        if shouldDisable and not disableAim then
                            SetPlayerCanDoDriveBy(plyId, false)
                            shouldDisable = false;
                            disableAim = true;
                            while IsAimCamActive() do Wait(0) end
                        end
                        forceFp(plyId)
                    else
                        disableV = false
                        exitFp(plyId)
                    end
                else
                    SomethingDumb(plyId)
                end
            else
                SomethingDumb(plyId)
            end
        end
    end
end)
