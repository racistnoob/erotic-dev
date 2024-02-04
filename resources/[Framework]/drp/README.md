## Grab Player on spawn ##
RegisterNetEvent('erotic:playerSpawned')
AddEventHandler('erotic:playerSpawned', function()

end)

## On resource start ##
AddEventHandler("onResourceStart", function(resourceName)
  if resourceName == GetCurrentResourceName() then
  end
end)

## On resource stop ##
AddEventHandler('onResourceStop', function(resourceName)
  if resourceName == 'drp-inventory' then
  end
end)

## 