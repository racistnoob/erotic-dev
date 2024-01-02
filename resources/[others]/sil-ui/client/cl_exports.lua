local Events = {}

function SendUIMessage(data)
  SendNUIMessage({
    action = 'uiMessage',
    data = data
  })
end

exports('SendUIMessage', SendUIMessage)

-- function RegisterUIEvent(eventName)
--     if not Events[eventName] then
--         Events[eventName] = true

--         RegisterNUICallback(eventName, function (...)
--             TriggerEvent(('_sil_uiReq:%s'):format(eventName), ...)
--         end)
--     end
-- end

-- exports('RegisterUIEvent', RegisterUIEvent)

function SetUIFocusCustom(hasKeyboard, hasMouse)
  HasNuiFocus = hasKeyboard or hasMouse

  SetNuiFocus(hasKeyboard, hasMouse)
  SetNuiFocusKeepInput(HasNuiFocus)
end

exports('SetUIFocusCustom', SetUIFocusCustom)

function SetUIFocusKeepInput(hasFocus)
  SetNuiFocusKeepInput(hasFocus)
end
exports('SetUIFocusKeepInput', SetUIFocusKeepInput)


function GetUIFocus()
  return HasNuiFocus
end

exports('GetUIFocus', GetUIFocus)

-- Citizen.CreateThread(function()
--     TriggerEvent('_sil_uiReady')
-- end)


function openApplication(app, data, stealFocus)
  stealFocus = stealFocus == nil and true or false
  SendUIMessage({
      source = "arp-nui",
      app = app,
      show = true,
      data = data or {},
  })
  if stealFocus then
    SetUIFocus(true, true)
  end
end

exports("openApplication", openApplication)

RegisterNetEvent("arp-ui:open-application")
AddEventHandler("arp-ui:open-application", openApplication)

function closeApplication(app, data)
  SendUIMessage({
      source = "arp-nui",
      app = app,
      show = false,
      data = data or {},
  })
  SetUIFocus(false, false)
  TriggerEvent("arp-ui:application-closed", app, { fromEscape = false })
end

exports("closeApplication", closeApplication)

function sendAppEvent(app, data, withExtra)
    local sentData = {
        app = app,
        data = data or {},
        source = "arp-nui",
    }
    if withExtra then
      for k, v in pairs(withExtra) do
        sentData[k] = v
      end
    end
    SendUIMessage(sentData)
end

exports("sendAppEvent", sendAppEvent)

function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

exports("SendReactMessage", SendReactMessage)
