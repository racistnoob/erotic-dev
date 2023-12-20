local taskStatus = {
  active = false,
  id = 0,
  status = 0
}

-- Transfer exports, blah.

function closeGuiFail()
  taskStatus['status'] = 2;
end

function closeGui()
  taskStatus['status'] = 2;
end

exports('closeGui', closeGui)
exports('closeGuiFail', closeGuiFail)

-- Actual code:

RegisterNUICallback('finished', function(data, cb)
  taskStatus['status'] = 3;
  cb("Thank you!")
end)



local function updateStatus(type)
  CreateThread(function()
    SendReactMessage("updateStatus", type);
    Wait(1250)
    SendReactMessage("updateStatus", "normal");
    SendReactMessage("setVisible", false);
    TriggerEvent('lane-taskbar:visible', false)
  end)
end

AddEventHandler('blackbars', function(blackbarson)
  SendReactMessage("updateBlackbars", blackbarson);
end)

local propEmotes = {
  ['janitor'] = {
    hash = `prop_tool_broom`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = -5.0,
    bone = 28422,
    xPos = -0.005,
    yPos = 0.0,
    zPos = 0.0,
    xRot = 360.0,
    yRot = 360.0,
    zRot = 0.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
  ['phone'] = {
    hash = `prop_npc_phone_02`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = 0.0,
    bone = 28422,
    xPos = 0.0,
    yPos = 0.0,
    zPos = 0.0,
    xRot = 0.0,
    yRot = 0.0,
    zRot = 0.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
  ['clipboard'] = {
    hash = `p_amb_clipboard_01`,
    xOffset = 1.0,
    yOffset = 1.0,
    zOffset = 1.0,
    bone = 60309,
    xPos = -0.01,
    yPos = -0.015,
    zPos = 0.005,
    xRot = 0.0,
    yRot = 0.0,
    zRot = -10.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  }, 
  ['Sponge'] = {
    hash = `prop_sponge_01`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = 0.0,
    bone = 28422,
    xPos = 0.0,
    yPos = 0.0,
    zPos = -0.01,
    xRot = 90.0,
    yRot = 0.0,
    zRot = 0.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
  ['Sponge2'] = {
    hash = `prop_sponge_01`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = 0.0,
    bone = 28422,
    xPos = 0.0,
    yPos = 0.0,
    zPos = -0.01,
    xRot = 90.0,
    yRot = 0.0,
    zRot = 0.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
  ['Burger'] = {
    hash = `prop_cs_burger_01`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = 0.0,
    bone = 18905,
    xPos = 0.13,
    yPos = 0.07,
    zPos = 0.02,
    xRot = 120.0,
    yRot = 16.0,
    zRot = 60.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
  ['Water'] = {
    hash = `prop_ld_flow_bottle`,
    xOffset = 0.0,
    yOffset = 0.0,
    zOffset = 0.0,
    bone = 28422,
    xPos = 0.0,
    yPos = 0.0,
    zPos = 0.0,
    xRot = 0.0,
    yRot = 0.0,
    zRot = 0.0,
    softSpinning = 1,
    collision = 0,
    isPed = 1,
    rotationOrder = 0,
    fixedRot = 1
  },
}

exports('updateStatus', updateStatus)

local speaking = false
local speakingWidth = 0

-- length, text, runcheck, ignoreclear, keepweapon, vehicle, distcheck, animation

local function taskBar(data)

  local length, text, runcheck, ignoreclear, keepweapon, vehicle, distcheck, animation, desc, preventCancel, showTime, flopcheck = data.length, data.text, data.runcheck, data.ignoreclear, data.keepweapon, data.vehicle, data.distcheck, data.animation, data.desc, data.preventCancel, data.showTime, data.flopcheck
  local keepoutofvehicle = data.keepoutofvehicle
  local plyPed = PlayerPedId()
  local startPos = GetEntityCoords(plyPed)
  local dict, anim, prop, scenario, stuck = "", "", "", "", false

  speakingWidth = 0
  speaking = data.speaking or false
  
  if not keepweapon then
    TriggerEvent("erp_inventory:weapons:setEmptyHanded", false)
    Wait(500)
  end

  if LocalPlayer.state.caffeinated then length = length * 0.7 end
  if animation and animation['dict'] then
    dict = animation['dict']
    anim = animation['anim']
    prop = animation['prop'] or ""
    stuck = animation['stuck'] or false
    if not HasAnimDictLoaded(dict) and exports['erp_clothes']:IsThisAnAnimalAndCanIAnimate() then
      RequestAnimDict(dict)
      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
      end
    end
  elseif animation and animation['scenario'] then
    scenario = animation['scenario']
    if not IsPedUsingScenario(plyPed, scenario) then
      ClearPedTasks(plyPed)
      TaskStartScenarioInPlace(plyPed, scenario, 0, true)
    end
  end
  
  if taskStatus['active'] then return 0 end -- Return 0% has been completed if there is already an ongoing progress bar!
  taskStatus['active'] = true;
  
  local id = taskStatus['id'] + 1;
  taskStatus['id'] = id;
  taskStatus['status'] = 1;

  SendReactMessage("updateError", false);
  SendReactMessage("setVisible", true);

  TriggerEvent('lane-taskbar:visible', true)

  SendReactMessage("updateWidth", 0);
  SendReactMessage("updateText", text or "")
  SendReactMessage("updateDesc", desc or "")
  SendReactMessage("preventCancel", preventCancel or false)
  SendReactMessage("showTime", showTime or false)
  SendReactMessage("updateTime", math.ceil(length / 1000));

  local targetTimer = GetGameTimer() + length
  local createdProp = 0

  local targetWidth = speaking and length or 100
  
  while taskStatus['id'] == id and taskStatus['status'] == 1 do

    Wait(5)
    
    local currentTimer = GetGameTimer();

    if currentTimer > targetTimer and not speaking then
      taskStatus['status'] = 3
    elseif speaking and speakingWidth > 100.0 then
      taskStatus['status'] = 3
    end

    local diff = length - (targetTimer - currentTimer)
    local width = math.ceil((diff / length) * 100);

    if speaking then
      if NetworkIsPlayerTalking(PlayerId()) then
        speakingWidth = speakingWidth + 0.2
      else
        speakingWidth = speakingWidth - 0.1
      end
      width = speakingWidth
    end

    if speakingWidth > length then
      speakingWidth = length
    elseif speakingWidth < 0 then
      speakingWidth = 0
    end
    
    if width > targetWidth then
      width = targetWidth
    elseif width < 0 then
      width = 0
    end

    if showTime then
      SendReactMessage("updateTime", math.ceil((targetTimer - currentTimer) / 1000));
    end

    SendReactMessage("updateWidth", width);

    if runcheck then
      if IsPedClimbing(plyPed) or IsPedJumping(plyPed) or IsPedSwimming(plyPed) then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if IsPedShooting(plyPed) then
      taskStatus = { active = false, id = 0, status = 0 }
      updateStatus("error")
      if anim ~= "" then
        StopAnimTask(plyPed, dict, anim, 2.0)
        if DoesEntityExist(createdProp) then
          DetachEntity(createdProp, 1, 1)
          DeleteEntity(createdProp)
        end
      end
      if scenario ~= "" then
        ClearPedTasks(plyPed)
      end
      return width
    end

    if keepoutofvehicle then
      if IsPedInAnyVehicle(plyPed, false) then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if vehicle ~= nil and vehicle ~= false then
      local driverPed = GetPedInVehicleSeat(vehicle, -1)
      if driverPed ~= plyPed then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if distcheck ~= nil then
      if #(GetEntityCoords(plyPed) - startPos) > distcheck then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if flopcheck then
      if IsPedRagdoll(plyPed) then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if not preventCancel then
      if IsControlJustReleased(0, 202) then
        taskStatus = { active = false, id = 0, status = 0 }
        updateStatus("error")
        if anim ~= "" then
          StopAnimTask(plyPed, dict, anim, 2.0)
          if DoesEntityExist(createdProp) then
            DetachEntity(createdProp, 1, 1)
            DeleteEntity(createdProp)
          end
        end
        if scenario ~= "" then
          ClearPedTasks(plyPed)
        end
        return width
      end
    end

    if anim ~= "" and exports['erp_clothes']:IsThisAnAnimalAndCanIAnimate() then
      if not IsEntityPlayingAnim(plyPed, dict, anim, 3) then
        local flag = 49
        if stuck then flag = 0; end
        if animation.flag then flag = animation.flag end
        TaskPlayAnim(plyPed, dict, anim, 3.0, 1.0, -1, flag, 0, 0, 0, 0 )
      end
      if prop ~= "" then
        if not DoesEntityExist(createdProp) then
          if propEmotes[prop] then
            local info = propEmotes[prop]
            local tPos = GetOffsetFromEntityInWorldCoords(plyPed, info.xOffset, info.yOffset, info.zOffset)
            createdProp = CreateObject(info.hash, tPos, 1, 1, 0)
            AttachEntityToEntity(createdProp, plyPed, GetPedBoneIndex(plyPed, info.bone), info.xPos, info.yPos, info.zPos, info.xRot, info.yRot, info.zRot, 1, info.softSpinning, info.collision, info.isPed, info.rotationOrder, info.fixedRot)
          end
        end
      end
    end

    if scenario ~= "" and not exports['erp_clothes']:IsThisAnAnimalAndCanIAnimate() then
      if not IsPedUsingScenario(plyPed, scenario) then
        ClearPedTasks(plyPed)
        TaskStartScenarioInPlace(plyPed, scenario, 0, true)
      end
    end

  end

  local res = taskStatus['status']
  if res == 2 then
    local diff = length - GetGameTimer();
    local total = math.ceil((diff / length) * 100);
    taskStatus = { active = false, id = 0, status = 0 }
    updateStatus("orange")
    if anim ~= "" then
      StopAnimTask(plyPed, dict, anim, 2.0)
      if DoesEntityExist(createdProp) then
        DetachEntity(createdProp, 1, 1)
		    DeleteEntity(createdProp)
      end
    end
    if scenario ~= "" then
      ClearPedTasks(plyPed)
    end
    SendReactMessage("updateWidth", 0);
    return total;
  else
    SendReactMessage("setVisible", false);
    TriggerEvent('lane-taskbar:visible', false)
    taskStatus = { active = false, id = 0, status = 0 }
    if anim ~= "" then
      StopAnimTask(plyPed, dict, anim, 2.0)
      if DoesEntityExist(createdProp) then
        DetachEntity(createdProp, 1, 1)
		    DeleteEntity(createdProp)
      end
    end
    if scenario ~= "" then
      ClearPedTasks(plyPed)
    end
    SendReactMessage("updateWidth", 0);
    return 100
  end;
end

exports('taskBar', taskBar)

function isTaskbarFree()
  return not taskStatus['active']
end

exports('isTaskbarFree', isTaskbarFree)