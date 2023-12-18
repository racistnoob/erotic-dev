local job, sidejob = "None", "None"
local cid = 0

function isPed(sentCheck)
  local checkType = string.lower(sentCheck)
  if checkType == 'cid' then
    return cid
  elseif checkType == 'myjob' then
    return job
  elseif checkType == 'sidejob' then
    return sidejob
  elseif checkType == 'grade' then
    return job.grade
  elseif checkType == 'dead' then
    return LocalPlayer.state.dead
  end
  return false
end

RegisterNetEvent('echorp:updateinfo')
AddEventHandler('echorp:updateinfo', function(toChange, targetData) 
  if toChange == 'job' then
    job = targetData
  end
  if toChange == 'sidejob' then
    sidejob = targetData
  end
end)

RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function(PlayerInfo)
  cid = PlayerInfo["cid"]
  job = PlayerInfo["job"]
  sidejob = PlayerInfo["sidejob"]
  Wait(1000)
  LocalPlayer.state.dead = false
end)

RegisterNetEvent('resetfromfx')
AddEventHandler('resetfromfx', function()
    cid = 0
    TriggerServerEvent('echorp:logout')
end)