local WasOnVehicle = false
local RagdollSpeed = 30.0
local EnableCarRagdoll = false  -- State control variable

-- Function to control the state of car ragdoll
function SetCarRagdoll(state)
    EnableCarRagdoll = state
end

-- Exporting the function
exports("setCarRagdoll", SetCarRagdoll)

-- Thread for car ragdoll
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if EnableCarRagdoll then
            local ped = PlayerPedId()
            local isOnVehicle = IsPedOnVehicle(ped)

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
