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

CreateThread(function()
  while true do
    Wait(250)
    SetPedConfigFlag(PlayerPedId(), 149, not helmetsEnabled)
    SetPedConfigFlag(PlayerPedId(), 438, not helmetsEnabled)

    SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
  end
end)
