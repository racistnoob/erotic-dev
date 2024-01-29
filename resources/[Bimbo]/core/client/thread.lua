
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)
--         SetPedCanLosePropsOnDamage(playerPed, false, 0)

--         DisableControlAction(0, 199, true)
--         DisableControlAction(0, 37, true)
--         DisableControlAction(0, 140, true)
--         DisableControlAction(0, 141, true)
--         DisableControlAction(0, 142, true)
--         DisableControlAction(0, 257, true)
--         DisableControlAction(0, 263, true)
--         DisableControlAction(0, 264, true)
--     end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(100)
--         if IsPedFalling(PlayerPedId()) then
--             SetEntityInvincible(PlayerPedId(), true)
--             SetPlayerInvincible(PlayerId(), true)
--             SetPedCanRagdoll(PlayerPedId(), false)
--             ClearPedBloodDamage(PlayerPedId())
--             ResetPedVisibleDamage(PlayerPedId())
--             ClearPedLastWeaponDamage(PlayerPedId())
--             SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
--             SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
--             SetEntityCanBeDamaged(PlayerPedId(), false)
--         else
--             SetEntityInvincible(PlayerPedId(), false)
--             SetPlayerInvincible(PlayerId(), false)
--             SetPedCanRagdoll(PlayerPedId(), true)
--             ClearPedLastWeaponDamage(PlayerPedId())
--             SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
--             SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
--             SetEntityCanBeDamaged(PlayerPedId(), true)
--         end 
-- 	end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(100)
--         if IsCinematicCamRendering() then
--             StopCinematicCamShaking(true)
--             SetCinematicButtonActive(false)
--         end

--         N_0x4757f00bc6323cfe(-1553120962, 0.0) 
--         Wait(1) 

--         ResetPlayerStamina(PlayerId())

        
--         DisableIdleCamera(true)
--         SetPedCanPlayAmbientAnims(playerPed, false)
--     end
-- end)
local getPlayer = PlayerPedId
local getPlayerID = PlayerId
local getIsOnVehicle = IsPedOnVehicle
local wait = Wait

PlayerPed = getPlayer()
isOnVehicle = getIsOnVehicle(PlayerPed)
playerID = getPlayerID()

Citizen.CreateThread(function()
    while true do
        PlayerPed = getPlayer()
        isOnVehicle = getIsOnVehicle(PlayerPed)
        playerID = getPlayerID()
        wait(1000)
    end
end)

local set_ped_can_play_ambient_anims = SetPedCanPlayAmbientAnims
local set_ped_can_lose_props_on_damage = SetPedCanLosePropsOnDamage
Citizen.CreateThread(function()
    DisableIdleCamera(true)
    while true do
        N_0x4757f00bc6323cfe(-1553120962, 0)
        set_ped_can_play_ambient_anims(PlayerPed, false)
        set_ped_can_lose_props_on_damage(PlayerPed, false, 0)
        wait(5000)
    end
 end)