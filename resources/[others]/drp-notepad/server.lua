local savedNotes = {}
TriggerEvent('drp-notepad:server:LoadsNote')

RegisterNetEvent("drp-notepad:server:LoadsNote")
AddEventHandler("drp-notepad:server:LoadsNote", function()
  TriggerClientEvent('drp-notepad:updateNotes', -1, savedNotes)
end)

RegisterNetEvent("drp-notepad:server:newNote")
AddEventHandler("drp-notepad:server:newNote", function(text)
  local import = { ["text"] = ""..text.."", ["coords"] = GetEntityCoords(GetPlayerPed(source))}
  table.insert(savedNotes, import)
  TriggerEvent("drp-notepad:server:LoadsNote")
  --exports[drp_adminmenu']:sendToDiscord('New Note Created', 'A note was created by **'..GetPlayerName(source)..'** @ **'..import['coords']..'** with the following text:\n\n'..text, "16711680", "")
end)

RegisterNetEvent("drp-notepad:server:updateNote")
AddEventHandler("drp-notepad:server:updateNote", function(noteID, text)
  savedNotes[noteID]["text"] = text
  TriggerEvent("drp-notepad:server:LoadsNote")
end)

RegisterNetEvent("drp-notepad:server:destroyNote")
AddEventHandler("drp-notepad:server:destroyNote", function(noteID)
  table.remove(savedNotes, noteID)
  TriggerEvent("drp-notepad:server:LoadsNote")
end)