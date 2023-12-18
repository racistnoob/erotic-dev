## Grab Player on spawn ##
RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function()

end)

## Grab Player on logout ##
RegisterNetEvent('echorp:doLogout')
AddEventHandler('echorp:doLogout', function()

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