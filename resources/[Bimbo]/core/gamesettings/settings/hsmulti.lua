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
    Wait(0)

    SetPedSuffersCriticalHits(GetPlayerPed(-1), hsmultiEnabled)

  end
end)
