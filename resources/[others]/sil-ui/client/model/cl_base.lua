-- CLOSE APP
function SetUIFocus(hasKeyboard, hasMouse)
--  HasNuiFocus = hasKeyboard or hasMouse
  HasNuiFocus = hasKeyboard or hasMouse
  SetNuiFocus(hasKeyboard, hasMouse)

  -- TriggerEvent("arp-voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
  -- TriggerEvent("arp-binds:should-execute", not HasNuiFocus)
end

exports('SetUIFocus', SetUIFocus)

RegisterNUICallback("arp-ui:closeApp", function(data, cb)
    SetUIFocus(false, false)
    cb({data = {}, meta = {ok = true, message = 'done'}})
    Wait(800)
    TriggerEvent("attachedItems:block",false)
end)

RegisterNUICallback("arp-ui:applicationClosed", function(data, cb)
    TriggerEvent("arp-ui:application-closed", data.name, data)
    cb({data = {}, meta = {ok = true, message = 'done'}})
end)

-- FORCE CLOSE
-- RegisterCommand("arp-ui:force-close", function()
--     SendUIMessage({source = "arp-nui", app = "", show = false});
--     SetUIFocus(false, false)
-- end, false)

-- RegisterCommand("arp-ui:debug:hide", function()
--     SendUIMessage({ source = "arp-nui", app = "debuglogs", data = { display = false } });
-- end, false)

RegisterNUICallback("arp-ui:resetApp", function(data, cb)
    SetUIFocus(false, false)
    cb({data = {}, meta = {ok = true, message = 'done'}})
    --sendCharacterData()
end)

