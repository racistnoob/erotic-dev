-- Create an event handler to show the kill feed notification
RegisterNetEvent('showKillFeedNotification')
AddEventHandler('showKillFeedNotification', function(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, true)
end)
