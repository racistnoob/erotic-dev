local HUD = {
  isOpen = false,
  healthHud = false,
  carHud = false,
  plyPed = false,
  plyVehicle = 0,
  inventoryActive = true,
  blackbars = false,
  compassActive = false,
  carhudPos = 'center',
  carControls = false,

  ToggleNui = function(self, open)
    self.isOpen = open
    SendReactMessage('setVisible', open)
    DisplayRadar(open)
  end,

  PlayerId = 0,

  InfoThread = function(self)

    self.PlayerId = PlayerId()

    while true do
      Wait(1000)
      self.plyPed = PlayerPedId()
      self.plyVehicle = GetVehiclePedIsIn(self.plyPed, false)
      SendReactMessage('setPauseMenu', IsPauseMenuActive() or IsScreenFadedOut() or IsScreenFadingOut() or self.blackbars)
    end

  end,

  StatusThread = function(self)

    CreateThread(function()
      
      while true do

        Wait(250)
        
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        RemoveMultiplayerHudCash(0x968F270E39141ECA)
        RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
        
        SendReactMessage('setStatusData', {
          health = GetEntityHealth(self.plyPed) - 100,
          armor = GetPedArmour(self.plyPed),
        })

      end

    end)

  end,

  MovingHud = false,

  MoveHud = function(self, state)

    local newState = state or not self.MovingHud

    SetNuiFocus(newState, newState)
    SendReactMessage('setMovingHud', newState)

    self.MovingHud = newState

    if not newState then
      return
    end
  end,
  
}

RegisterNUICallback('stopMovingHud', function(_, cb)
  HUD:MoveHud(false)
  cb('ok')
end)

CreateThread(function()
  Wait(250)
  HUD:ToggleNui(false)
end)

CreateThread(function()
  Wait(500)
  HUD:InfoThread()
end)

CreateThread(function()
  Wait(500)
  HUD:StatusThread()
end)

exports("toggleNui", function(...)
  return HUD:ToggleNui(...)
end) -- exports['drp-hud']:toggleNui(false)

RegisterCommand("movehud", function(source, args, rawCommand) 
  HUD:MoveHud(args[1])
end, false)

RegisterCommand("resethud", function(source, args, rawCommand) 
  SendReactMessage('setHudPosition', { x = 0, y = 0 })
end, false)

AddEventHandler('echorp:playerSpawned', function()
    Wait(500)
    HUD:ToggleNui(true)
end)

RegisterNetEvent('echorp:doLogout')
AddEventHandler('echorp:doLogout', function()
    Wait(500)
    HUD:ToggleNui(false)
end)

--[[AddEventHandler("onResourceStart", function(resourceName)
  if resourceName == GetCurrentResourceName() then

end)]]