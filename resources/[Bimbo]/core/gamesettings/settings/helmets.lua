local helmetsEnabled = false

--[[
  True: bullet proof  helmets enabled
  False: bullet proof helmets disabled
]]

function SetHelmetsEnabled(state)
  helmetsEnabled = state == true
end

function GetHelmetsEnabled()
  return helmetsEnabled
end

exports("setHelmetsEnabled", SetHelmetsEnabled)
exports("getHelmetsEnabled", GetHelmetsEnabled)

local ped = 0
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(2500)
      ped = PlayerPedId()
  end
end)

CreateThread(function()
  while true do
    Wait(1000)
    SetPedConfigFlag(ped, 149, not helmetsEnabled)
    SetPedConfigFlag(ped, 438, not helmetsEnabled)
  end
end)
