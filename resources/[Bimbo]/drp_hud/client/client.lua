local HUD = {
  
  isOpen = false,
  healthHud = false,
  carHud = false,
  seatBelt = false,
  plyPed = false,
  plyVehicle = false,
  fuelAlarm = false,
  voiceLevel = 1,
  radioActive = false,
  -- inventoryActive = true,
  blackbars = false,
  compassActive = false,
  carhudPos = 'right',
  carControls = false,

  HarnessVehicles = {},

  ToggleNui = function(self, open)
    self.isOpen = open
    SendReactMessage('setVisible', open)
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
    minimap.leftX = minimapRawX
    minimap.rightX = minimapRawX+minimap.width
    minimap.topY = minimapRawY
    minimap.bottomY = minimapRawY+minimap.height
    minimap.X = minimapRawX+(minimap.width/2)
    minimap.Y = minimapRawY+(minimap.height/2)
    return minimap

  end,

  InfoThread = function(self)
    while true do
      Wait(500)
      self.plyPed = PlayerPedId()
      self.plyVehicle = GetVehiclePedIsIn(self.plyPed, false)
      SendReactMessage('setPauseMenu', IsPauseMenuActive() or IsScreenFadedOut() or IsScreenFadingOut() or self.blackbars)
    end
  end,

  StatusThread = function(self)

    CreateThread(function()
      
      while true do

        Wait(250)

        local armed = self.inventoryActive and GetSelectedPedWeapon(PlayerPedId()) or `WEAPON_UNARMED`;
        local itemId = armed ~= `WEAPON_UNARMED` or false
        
        local weaponImage = itemId or ""

        local pedWeapon = weaponImage ~= "" and GetSelectedPedWeapon(self.plyPed) or false;
        local weaponMaxAmmo = pedWeapon and GetAmmoInPedWeapon(self.plyPed, pedWeapon) or 0;
        local a, weaponClipAmmo = GetAmmoInClip(self.plyPed, pedWeapon);

        local map = self:GetMinimapPosition()
        local rightX = map.rightX * 100
        local bottomY = map.bottomY * 100

        local localState = LocalPlayer.state

        SendReactMessage('setStatusData', {
          isTalking = NetworkIsPlayerTalking(PlayerId()),
          voiceLevel = self.voiceLevel,
          radioActive = self.radioActive,
          -- hunger = math.ceil(localState.hungerLevel / 100),
          -- thirst = math.ceil(localState.thirstLevel  / 100),
          -- stress = math.ceil(localState.stressLevel / 100),
          health = GetEntityHealth(self.plyPed) - 100,
          armor = GetPedArmour(self.plyPed),
          -- isBleeding = exports['mythic_hospital']:BloodLevel() > 0,
          -- isLimp = exports['mythic_hospital']:IsInjuryCausingLimp(),
          weapon = weaponImage,
          maxAmmo = weaponMaxAmmo - weaponClipAmmo,
          clipAmmo = weaponClipAmmo,
          rightX = rightX,
          bottomY = bottomY,
          oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
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
  
        exports['drp_notifications']:SendAlert('error', 'Low fuel.', 2500)
  
        for i=0, 4 do  
          PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
          Wait(250)
        end
  
        Wait(60000)
  
        self.fuelAlarm = false;
      end
      return;
    end)
    

  end,

  ToggleBelt = function(self)

    local vehicleExists = DoesEntityExist(self.plyVehicle or 0)
    if not vehicleExists then return end

    local speed = (GetPedInVehicleSeat(self.plyVehicle, -1) == PlayerPedId()) and GetEntitySpeed(self.plyVehicle) * 2.236936 or 0
    if speed > 50 then
      exports['drp_notifications']:SendAlert('inform', 'Too high speed to toggle seatbelt')
      return 
    end

    self.seatBelt = not self.seatBelt

    TriggerServerEvent('drp-sounds:PlayWithinDistance', 2.0, self.seatBelt and 'seatbelt' or 'seatbeltoff', 0.4)
    exports['drp_notifications']:SendAlert(self.seatBelt and 'success' or 'error', self.seatBelt and 'Seat Belt Enabled' or 'Seat Belt Disabled')

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
      
      local vehicleExists = DoesEntityExist(self.plyVehicle or 0)

      DisplayRadar(vehicleExists and not self.blackbars)

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
  
        
        local engineRunning = GetIsVehicleEngineRunning(self.plyVehicle)

        local rpm = GetVehicleCurrentRpm(self.plyVehicle)
        if rpm < 0.2 then rpm = 0.2 end

        CreateThread(function()
          while GetVehicleCurrentRpm(self.plyVehicle) > 0.2 and not engineRunning do
            SetVehicleCurrentRpm(self.plyVehicle, GetVehicleCurrentRpm(self.plyVehicle) - 0.005)
            Wait(20)
          end
        end)

        local currentRpm = (((rpm * 270 - 160.2)) / 80) * 100

        local fuel = math.ceil(GetVehicleFuelLevel(self.plyVehicle))
        if fuel < 12 then self:CarFuelAlarm() end;
  
        SendReactMessage('setVehicleData', {
          speed = math.ceil(GetEntitySpeed(self.plyVehicle) * 2.236936),
          gear = GetVehicleCurrentGear(self.plyVehicle),
          rpm = currentRpm,
          fuel = fuel,
          engineAlert = GetVehicleEngineHealth(self.plyVehicle) <= 500,
          seatBelt = self.seatBelt,
          -- nitrous = exports['drp-nos']:nitrousInfo(self.plyVehicle).level,
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

  DrawBars = function(self)

    if self.blackbars then
      DrawRect(0.0, 0.0, 2.0, 0.13, 0, 0, 0, 255)
      DrawRect(0.0, 1.0, 2.0, 0.13, 0, 0, 0, 255)
    end

  end,

  HideAmmo = function(self)
    while true do
      Wait(0)
      DisplayAmmoThisFrame(false)
      HideHudComponentThisFrame(14)
      self:DrawBars()
    end
  end,

  UpdateHarnessVehicles = function(self, data)
    self.HarnessVehicles = data;
  end,

  Compass = function(self, toggle)
    self.compassActive = toggle and toggle or not self.compassActive
    SendReactMessage('setCompass', self.compassActive)
  end,

  ItemCheck = function(self)

    if not self.compassActive then return end;
    local hasCompass = exports['drp_inventory']:hasEnoughOfItem('compass', 1)
    self:Compass(hasCompass)

  end,

  MoveCarHud = function(self, position)

    local newState = position == 'center' and 'center' or 'right';
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
      exports['drp_notifications']:SendAlert('success', 'HUD location saved', 5000)
      return 
    end

    exports['drp_notifications']:SendAlert('inform', 'Drag around the HUD to move it, hit ESC to save and confirm. Use /resethud to move the HUD back to default position', 5000)

  end,

  CompassReadability = function(self, size)

    local newState = size and tonumber(size) or 18
    SendReactMessage('setCompassSize', newState)

    exports['drp_notifications']:SendAlert('success', 'Compass text size adjusted', 4000)

  end,
  
}

RegisterNUICallback('stopMovingHud', function(_, cb)
  HUD:MoveHud(false)
  cb('ok')
end)

CreateThread(function()
  Wait(100)
  HUD:ToggleNui(true)
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
  HUD:StatusThread()
end)

CreateThread(function()
  HUD:IdleCam()
end)

CreateThread(function()
  HUD:HideAmmo()
end)

RegisterKeyMapping("seatbelt", "Toggle Seatbelt", "keyboard", "B")
RegisterCommand("-seatbelt", function() end, false) -- Disables chat from opening.

RegisterCommand('seatbelt', function()
  HUD:ToggleBelt()
end, false)

exports("toggleNui", function(...)
  return HUD:ToggleNui(...)
end) -- exports['drp_hud']:toggleNui(false)

exports("IsHarness", function(targetVeh)
  return HUD.HarnessVehicles[VehToNet(targetVeh)] or false;
end) -- exports['drp_hud']:IsHarness(vehicle)

exports('itemCheck', function()
  return HUD:ItemCheck()
end)

exports('seatBeltActive', function()
  return HUD.seatBelt
end)

RegisterCommand("togglehud", function(source, args, rawCommand)
  HUD:ToggleNui(not HUD.isOpen)
  exports.drp_prompts:hidePrompt()
end, false)

RegisterCommand("blackbars", function(source, args, rawCommand) 
  HUD.blackbars = not HUD.blackbars 
  TriggerEvent('chat:toggleChat', HUD.blackbars)
  exports.drp_prompts:hidePrompt()
end, false)

RegisterCommand("carhud", function(source, args, rawCommand) 
  HUD:MoveCarHud(args[1])
end, false)

RegisterCommand("movehud", function(source, args, rawCommand) 
  HUD:MoveHud(args[1])
end, false)

RegisterCommand("compassreadability", function(source, args, rawCommand) 
  HUD:CompassReadability(args[1])
end, false)

RegisterCommand("resethud", function(source, args, rawCommand) 
  SendReactMessage('setHudPosition', { x = 0, y = 0 })
end, false)

TriggerEvent('chat:addSuggestion', '/carhud', 'Toggle the health and driving HUD.', {
  { name="center/right", help="This will move the Car HUD to the center/right."},
})

TriggerEvent('chat:addSuggestion', '/compassreadability', 'Set the HUD\'s compass (bottom middle) text size', {
  { name="Size", help="Specify the size in pixels (e.g. 16)"},
})

TriggerEvent('chat:addSuggestion', '/togglehud', 'Toggle the health and driving HUD.')
TriggerEvent('chat:addSuggestion', '/blackbars', 'Toggle blackbars, will also disable chat.')

AddEventHandler("harness", function(toggle)

  local plyVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if not plyVehicle or not toggle then return end;
  TriggerServerEvent('harness', VehToNet(plyVehicle))

end)

RegisterNetEvent("newHarness", function(newData) HUD:UpdateHarnessVehicles(newData) end)

RegisterNetEvent('pma-voice:setTalkingMode', function(mode)
  HUD.voiceLevel = mode;
end)

RegisterNetEvent('pma-voice:radioActive', function(talking)
  HUD.radioActive = talking
end)

AddEventHandler('drp_carcontrols:toggle', function(toggle)
  HUD.carControls = toggle
end)

AddEventHandler('drp_progressbar:visible', function(toggle)
  HUD.carControls = toggle
end)

AddEventHandler('onResourceStart', function(resourceName)
  if resourceName == 'drp_inventory' then
    HUD.inventoryActive = true;
  end;
end)

AddEventHandler('onResourceStop', function(resourceName)
  if resourceName == 'drp_inventory' then
    HUD.inventoryActive = false;
  end;
end)

AddEventHandler('drp_hud:toggleLandHud', function(sentToggle)
  HUD:Compass(sentToggle)
end)

AddEventHandler('drp_hud:togglesniper', function(sniper)
  HUD.sniper = sniper
end)