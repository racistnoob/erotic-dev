local hsmultiEnabled = false

--[[
  True: headshots enabled
  False: headshots disabled
]]

function SetHsMulti(state)
    hsmultiEnabled = state == true
end

function GetHsMulti()
  return hsmultiEnabled
end

exports("setHsMulti", SetHsMulti)
exports("getHsMulti", GetHsMulti)

CreateThread(function()
  while true do
    Wait(250)

    SetPedSuffersCriticalHits(PlayerPedId(), hsmultiEnabled)
  end
end)
