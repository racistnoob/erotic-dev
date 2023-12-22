------
-- Interaction Sounds by Scott
-- Version: v0.0.1
-- Path: server/main.lua
--
-- Allows sounds to be played on single clients, all clients, or all clients within
-- a specific range from the entity to which the sound has been created. Triggers
-- client events only. Used to trigger sounds on other clients from the client or
-- server without having to pass directly to another client.
------

------
-- RegisterNetEvent drp-sounds:PlayOnOne
-- Triggers -> ClientEvent drp-sounds:PlayOnOne
--
-- @param clientNetId  - The network id of the client that the sound should be played on.
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client.
------
RegisterNetEvent('drp-sounds:PlayOnOne')
AddEventHandler('drp-sounds:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('drp-sounds:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

------
-- RegisterNetEvent drp-sounds:PlayOnSource
-- Triggers -> ClientEvent drp-sounds:PlayOnSource
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client, which is the source of the event.
------
RegisterNetEvent('drp-sounds:PlayOnSource')
AddEventHandler('drp-sounds:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('drp-sounds:PlayOnOne', source, soundFile, soundVolume)
end)

------
-- RegisterNetEvent drp-sounds:PlayOnAll
-- Triggers -> ClientEvent drp-sounds:PlayOnAll
--
-- @param soundFile     - The name of the soundfile within the client/html/sounds/ folder.
--                      - Can also specify a folder/sound file.
-- @param soundVolume   - The volume at which the soundFile should be played. Nil or don't
--                      - provide it for the default of standardVolumeOutput. Should be between
--                      - 0.1 to 1.0.
--
-- Starts playing a sound on all clients who are online in the server.
------
RegisterNetEvent('drp-sounds:PlayOnAll')
AddEventHandler('drp-sounds:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('drp-sounds:PlayOnAll', -1, soundFile, soundVolume)
end)

------
-- RegisterNetEvent drp-sounds:PlayWithinDistance
-- Triggers -> ClientEvent drp-sounds:PlayWithinDistance
--
-- @param playOnEntity    - The entity network id (will be converted from net id to entity on client)
--                        - of the entity for which the max distance is to be drawn from.
-- @param maxDistance     - The maximum float distance (client uses Vdist) to allow the player to
--                        - hear the soundFile being played.
-- @param soundFile       - The name of the soundfile within the client/html/sounds/ folder.
--                        - Can also specify a folder/sound file.
-- @param soundVolume     - The volume at which the soundFile should be played. Nil or don't
--                        - provide it for the default of standardVolumeOutput. Should be between
--                        - 0.1 to 1.0.
--
-- Starts playing a sound on a client if the client is within the specificed maxDistance from the playOnEntity.
-- @TODO Change sound volume based on the distance the player is away from the playOnEntity.
------
RegisterNetEvent('drp-sounds:PlayWithinDistance')
AddEventHandler('drp-sounds:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local player = source

    if player ~= nil then
        local coords = GetEntityCoords(GetPlayerPed(player))
        TriggerClientEvent('drp-sounds:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume, coords)
    end
end)