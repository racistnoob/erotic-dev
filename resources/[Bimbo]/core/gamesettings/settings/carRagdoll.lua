local WasOnVehicle = false
local RagdollSpeed = 30.0
local EnableCarRagdoll = false  -- State control variable
local ped = 0
local isOnVehicle = 0

-- Function to control the state of car ragdoll
function SetCarRagdoll(state)
    EnableCarRagdoll = state
end

-- Exporting the function
exports("setCarRagdoll", SetCarRagdoll)

-- Thread for car ragdoll

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ped = PlayerPedId()
        isOnVehicle = IsPedOnVehicle(ped)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if EnableCarRagdoll then
            if isOnVehicle then
                SetRagdollBlockingFlags(ped, 2)
            elseif WasOnVehicle and not isOnVehicle then
                ClearRagdollBlockingFlags(ped, 2)
                if GetEntitySpeed(ped) > RagdollSpeed then
                    SetPedToRagdoll(ped)
                end
            end
            WasOnVehicle = isOnVehicle
        end
    end
end)
