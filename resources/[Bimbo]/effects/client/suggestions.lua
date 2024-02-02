local function addSuggestion(commandName, commandDescription, arguments)
  TriggerEvent('chat:addSuggestion', "/" .. tostring(commandName), commandDescription, arguments)
end

local suggestions = {
  {
      name = "kit",
      desc = "(starter, pvp, car, pistol)"
  },
  {
      name = "car",
      desc = "spawn any model"
  },
  {
      name = "kill",
      desc = "Die"
  },
  {
    name = "settings",
    desc = "[open game settings]"
  },
}

for _, suggestion in pairs(suggestions) do
  addSuggestion(suggestion.name, suggestion.desc, suggestion.args)
end
