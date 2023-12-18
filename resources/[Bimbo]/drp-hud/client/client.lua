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

  GetMinimapPosition = function(self)

    local minimap = {}

    local resX, resY = GetActiveScreenResolution()

    local aspectRatio = GetAspectRatio()

    local scaleX = 1/resX
    local scaleY = 1/resY

    local minimapRawX, minimapRawY

    SetScriptGfxAlign(string.byte('L'), string.byte('B'))

    if IsBigmapActive() then
      minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
      minimap.width = scaleX*(resX/(2.52*aspectRatio))
      minimap.height = scaleY*(resY/(2.3374))
    else
      minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
      minimap.width = scaleX*(resX/(4*aspectRatio))
      minimap.height = scaleY*(resY/(5.674))
    end

    ResetScriptGfxAlign()

    minimap.rightX = minimapRawX+minimap.width
    minimap.bottomY = minimapRawY+minimap.height
    
    return minimap

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

        local map = self:GetMinimapPosition()
        local rightX = map.rightX * 100
        local bottomY = map.bottomY * 100

        local localState = LocalPlayer.state

        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        RemoveMultiplayerHudCash(0x968F270E39141ECA)
        RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
        
        SendReactMessage('setStatusData', {
          health = GetEntityHealth(self.plyPed) - 100,
          armor = GetPedArmour(self.plyPed),
          rightX = rightX,
          bottomY = bottomY,
        })

      end

    end)

  end,

  -- Car Stuff:

  ToggleCarHud = function(self)
    SendReactMessage('setCarHud', self.carHud)
  end,

  CarFuelAlarm = function(self)

    CreateThread(function()

      if not self.fuelAlarm then
        self.fuelAlarm = true;
  
        exports['drp-notifications']:SendAlert('error', 'Low fuel.', 2500)
  
        for i=0, 4 do  
          PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
          Wait(250)
        end
  
        Wait(60000)
  
        self.fuelAlarm = false;
      end

    end)
    

  end,

  GetLocation = function(self)

    local x, y, z = table.unpack(GetEntityCoords(self.plyPed))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    local zone = tostring(GetNameOfZone(x, y, z))
    local area = GetLabelText(zone)
    local playerStreetsLocation = area

    if not zone then zone = "UNKNOWN" end;

    if intersectStreetName ~= nil and intersectStreetName ~= "" then playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [ " .. area .. " ]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then playerStreetsLocation = currentStreetName .. " | [ " .. area .. " ]" end

    local direction = "N"
    local heading = GetEntityHeading(self.plyPed)
    if heading >= 315 or heading < 45 then direction = "N"
    elseif heading >= 45 and heading < 135 then direction = "W"
    elseif heading >=135 and heading < 225 then direction = "S"
    elseif heading >= 225 and heading < 315 then direction = "E" end

    return '['..direction..'] '..playerStreetsLocation

  end,

  LocationThread = function(self)

    while true do

      Wait(250)
      if self.carHud or self.compassActive then SendReactMessage('setLocation', self:GetLocation()) end

    end

  end,

  CarThread = function(self)

    self.carhudPos = GetResourceKvpString('carhudpos') or 'right'

    while true do
      
      local vehicleExists = DoesEntityExist(self.plyVehicle)

      DisplayRadar(vehicleExists and not self.blackbars and self.isOpen)

      if not vehicleExists then
        if self.carHud then
          self.carHud = false;
          self:ToggleCarHud();
        end
        if self.seatBelt then
          self.seatBelt = false;
        end
      else

        if not self.carHud then
          self.carHud = true
          self:ToggleCarHud();
        end
  
        local rpm = GetVehicleCurrentRpm(self.plyVehicle)
        if rpm < 0.2 then rpm = 0.2 end

        if rpm > 0.2 and not GetIsVehicleEngineRunning(self.plyVehicle) then
          CreateThread(function()
            while GetVehicleCurrentRpm(self.plyVehicle) > 0.2 and not GetIsVehicleEngineRunning(self.plyVehicle) do
              SetVehicleCurrentRpm(self.plyVehicle, GetVehicleCurrentRpm(self.plyVehicle) - 0.005)
              Wait(20)
            end
            return
          end)
        end

        local currentRpm = (((rpm * 270 - 160.2)) / 80) * 100
  
        SendReactMessage('setVehicleData', {
          speed = math.ceil(GetEntitySpeed(self.plyVehicle) * 2.236936),
          gear = GetVehicleCurrentGear(self.plyVehicle),
          rpm = currentRpm,
          engineAlert = GetVehicleEngineHealth(self.plyVehicle) <= 500,
          seatBelt = self.seatBelt,
          nitrous = exports['drp-nos']:nitrousInfo(self.plyVehicle).level,
          position = self.carhudPos,
          visible = not (self.carhudPos == 'center' and self.carControls)
        })

        if self.seatBelt then
          DisableControlAction(0, 75, true) 
        end

      end

      

      Wait(self.carHud and 25 or 500)

    end
  end,

  IdleCam = function()
    while true do
      Wait(15000)
      InvalidateIdleCam()
      InvalidateVehicleIdleCam()
    end
  end,

  Compass = function(self, toggle)
    self.compassActive = toggle and toggle or not self.compassActive
    SendReactMessage('setCompass', self.compassActive)
  end,

  MoveCarHud = function(self, position)

    local newState = position == 'center' and 'center';
    SetResourceKvp('carhudpos', newState)
    self.carhudPos = newState

  end,

  MovingHud = false,

  MoveHud = function(self, state)

    local newState = state or not self.MovingHud

    SetNuiFocus(newState, newState)
    SendReactMessage('setMovingHud', newState)

    self.MovingHud = newState

    if not newState then
      exports['drp-notifications']:SendAlert('success', 'HUD location saved', 5000)
      return 
    end

    exports['drp-notifications']:SendAlert('inform', 'Drag around the HUD to move it, hit ESC to save and confirm. Use /resethud to move the HUD back to default position', 5000)

  end,
  
}

RegisterNUICallback('stopMovingHud', function(_, cb)
  HUD:MoveHud(false)
  cb('ok')
end)

CreateThread(function()
  Wait(250)
  HUD:ToggleNui(false)
  return
end)

CreateThread(function()
  Wait(500)
  HUD:InfoThread()
end)

CreateThread(function()
  Wait(500)
  HUD:CarThread()
end)

CreateThread(function()
  Wait(500)
  HUD:LocationThread()
end)

CreateThread(function()
  Wait(500)
  HUD:StatusThread()
end)

CreateThread(function()
  HUD:IdleCam()
end)

exports("toggleNui", function(...)
  return HUD:ToggleNuit(...)
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