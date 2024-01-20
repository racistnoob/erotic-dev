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

local ped = 0
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(2500)
      ped = PlayerPedId()
  end
end)

CreateThread(function()
  while true do
    Wait(250)

    SetPedSuffersCriticalHits(ped, hsmultiEnabled)
  end
end)
