
local lockpos = false
local insidePrompt = false
-- openGui(length,math.random(1000000))
function openGui(sentLength,taskID,namesent,keepWeapon)
    --[[if not keepWeapon then
        TriggerEvent("actionbar:setEmptyHanded")
    end]]
    guiEnabled = true
    SendNUIMessage({runProgress = true, Length = sentLength, Task = taskID, name = namesent})
end
function updateGui(sentLength,taskID,namesent)
    SendNUIMessage({runUpdate = true, Length = sentLength, Task = taskID, name = namesent})
end
local activeTasks = {}
function closeGuiFail(clear)
    guiEnabled = false
    SendNUIMessage({closeFail = true})
end
function closeGui(clear)
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

function closeNormalGui()
    guiEnabled = false
end

RegisterNUICallback('taskCancel', function(data, cb)
    closeGui()
    local taskIdentifier = data.tasknum
    activeTasks[taskIdentifier] = 2
end)


RegisterNUICallback('taskEnd', function(data, cb)
  closeNormalGui()
  
  local taskIdentifier = data.tasknum
  activeTasks[taskIdentifier] = 3
end)
local coffeetimer = 0

-- command is something we do in the loop if we want to disable more, IE a vehicle engine.
-- return true or false, if false, gives the % completed.
local taskInProcess = false
function taskBar(length,name,runCheck,ignoreclear,keepWeapon,vehicle)
    local playerPed = PlayerPedId()
    if taskInProcess then
        return 0
    end
    if coffeetimer > 0 then
        length = math.ceil(length * 0.66)
    end
    taskInProcess = true
    local taskIdentifier = "taskid" .. math.random(1000000)
    openGui(length,taskIdentifier,name,keepWeapon)
    activeTasks[taskIdentifier] = 1

    local maxcount = GetGameTimer() + length
    local curTime
    while activeTasks[taskIdentifier] == 1 do
        Citizen.Wait(0)
        curTime = GetGameTimer()
        if curTime > maxcount or not guiEnabled then
            activeTasks[taskIdentifier] = 2
        end
        local fuck = 100 - (((maxcount - curTime) / length) * 100)
        fuck = math.min(100, fuck)
        updateGui(fuck,taskIdentifier,name)

        if IsPedShooting(PlayerPedId()) then
            SetPlayerControl(PlayerId(), 0, 0)
            local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
            totaldone = math.min(100, totaldone)
            taskInProcess = false
            closeGuiFail(ignoreclear)
            Citizen.Wait(50)
            SetPlayerControl(PlayerId(), 1, 1)
            ClearPedTasks(PlayerPedId())
            Citizen.Wait(50)
            return totaldone
        end

        if IsControlJustPressed(0, 194) then -- Check if the Backspace key is pressed
            closeGui(clear)
            taskInProcess = false
            Citizen.Wait(100)
            ClearPedTasks(PlayerPedId())
        end

        if vehicle ~= nil then
            local driverPed = GetPedInVehicleSeat(vehicle, -1)
            if driverPed ~= playerPed then
                SetPlayerControl(PlayerId(), 0, 0)
                local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
                totaldone = math.min(100, totaldone)
                taskInProcess = false
                closeGuiFail(ignoreclear)
                Citizen.Wait(1000)
                SetPlayerControl(PlayerId(), 1, 1)
                ClearPedTasks(PlayerPedId())
                Citizen.Wait(1000)
                return totaldone
            end
        end
    end

    local resultTask = activeTasks[taskIdentifier]
    if resultTask == 2 then
        local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
        totaldone = math.min(100, totaldone)
        taskInProcess = false
        closeGuiFail(ignoreclear)
        return totaldone
    else
        closeGui(ignoreclear)
        taskInProcess = false
        return 100
    end 
   
end

function CheckCancels()
    if IsPedRagdoll(PlayerPedId()) then
        return true
    end
    return false
end
-- trigger this way for the timer with out stopping another thread
RegisterNetEvent('hud:taskBar')
AddEventHandler('hud:taskBar', function(length,name)
    taskBar(length,name)
end)

RegisterNetEvent('hud:insidePrompt')
AddEventHandler('hud:insidePrompt', function(bool)
    insidePrompt = bool
end)

RegisterNetEvent('event:control:taskBar')
AddEventHandler('event:control:taskBar', function(useID)
    if useID == 1 and not insidePrompt then
        TriggerEvent("radioGui")
    elseif useID == 2 and not insidePrompt then
        TriggerEvent("stereoGui") 
    elseif useID == 3 and not insidePrompt then
        TriggerEvent("phoneGui") 
    elseif useID == 4 and not insidePrompt then 
        TriggerEvent("inventory-open-request")
    elseif useID == 5 and guiEnabled then 
        closeGuiFail() 
    end
end)

AddEventHandler('baseevents:onPlayerDied', function()
    taskInProcess = false
    closeGuiFail(ignoreclear)
end)