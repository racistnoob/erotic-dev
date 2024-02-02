local animPlaying = false
local playerArmed = false
local quickSelectEnabled = false
local clipCache = {}

RegisterNetEvent("erotic:quickSelectEnabled", function(newState)
    quickSelectEnabled = newState
end)

AddEventHandler("baseevents:onPlayerDied", function()
    clipCache = {}
end) -- baseevents died

RegisterNetEvent("erotic:joinedlobby", function()
    clipCache = {}
end) -- event joining lobby

local cooldown = false

RegisterNetEvent('erotic:useWeapon')
AddEventHandler('erotic:useWeapon', function(weaponName)
    local ped = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)
    local currentWeapon = GetSelectedPedWeapon(ped)

    if weaponHash == currentWeapon then
      -- Wait(500)
        putawayGun(weaponName)
    elseif not IsPedJumping(ped) and cooldown == false then
      cooldown = true
      Wait(100)
      cooldown = false
            local bulletType = findAmmoType(weaponHash)
            local ammoCount = ammoCount(bulletType)

            GiveWeaponToPed(ped, weaponHash, tonumber(ammoCount), false, true)
            exports["attachments"]:applyComponents(weaponName)
            SetCurrentPedVehicleWeapon(PlayerPedId(), weaponHash)
            SetCurrentPedWeapon(PlayerPedId(), weaponHash, true)
            ClearPedTasks(ped)
            SetAmmoInClip(PlayerPedId(), weaponHash, GetMaxAmmoInClip(PlayerPedId(), weaponHash, 1))
          elseif cooldown == false then
            putawayGun(weaponName, currentWeapon)
        end
    end)

function playerHasWeapon()
    if not IsPedArmed(PlayerPedId(), 1) and not IsPedArmed(PlayerPedId(), 2) and not IsPedArmed(PlayerPedId(), 4) then
        return false
    else
        return true
    end
end

local wait = Wait
local pairs = pairs
local is_ped_armed = IsPedArmed
local player_ped_id = PlayerPedId
Citizen.CreateThread(function()
    while true do
      wait(1000)
        playerArmed = is_ped_armed(player_ped_id(), 4)
    end
end)

local get_selected_ped_weapon = GetSelectedPedWeapon
local get_ammo_in_clip = GetAmmoInClip
CreateThread(function()
  local sleepTimer = 100
    while true do
      wait(sleepTimer)
      if not playerArmed then
        wait(1000)
      end
      if not quickSelectEnabled and playerArmed then
        sleepTimer = 100
        local playerPed = player_ped_id()
        local currentWeapon = get_selected_ped_weapon(playerPed)
  
        local found, clipSize = get_ammo_in_clip(playerPed, currentWeapon)
        if found then
          clipCache[tostring(currentWeapon)] = clipSize
        end
      end
    end
  end)

  function ammoCount(bullet)
    local count = 0
    if inventoryData and type(inventoryData) == 'table' then
      for k, v in pairs(inventoryData) do
        if v and v.item then
          if v.item == bullet then
            count = count + v.quantity
          end
        end
      end
    end
  
    return count
  end
  
  function setDefaultAmmo(forbullet, count)
    if inventoryData and type(inventoryData) == 'table' then
      for k, v in pairs(inventoryData) do
        if v and v.item then
          if v.item == bullet then
            v.quantity = count
          end
        end
      end
    end
  end
  
  function findAmmoType(weaponHash)
    for weaponName, bullet in pairs(Config.Weapons) do
      if GetHashKey(weaponName) == weaponHash then
        if type(bullet) == 'string' then
          return bullet
        end
      end
    end
    return
  end

AddEventHandler('erotic:updatePlayerInventory', function(inventory)
    local localPlayer = PlayerPedId()
    if IsPedArmed(localPlayer, 4) then
      local currentWeapon = GetSelectedPedWeapon(localPlayer)
      local ammoType = findAmmoType(currentWeapon)
      local ammoCount = ammoCount(ammoType)
      SetPedAmmo(localPlayer, currentWeapon, ammoCount)
  
      local hasWeapon = false
      for k, v in pairs(inventory) do
        if v and v.item then
          if GetHashKey(v.item) == currentWeapon then
            hasWeapon = true
          end
        end
      end
  
      if not hasWeapon then
        RemoveAllPedWeapons(localPlayer, false)
      end
    end
end)

-- Citizen.CreateThread(
--     function()
--         while true do
--             local localPlayer = PlayerPedId()
--             -- ammo update
--             if playerArmed then
--                 local currentWeapon = GetSelectedPedWeapon(localPlayer)

--                 if IsPedShooting(localPlayer) then
--                     local ammoType = findAmmoType(currentWeapon)
--                     if ammoType then
--                         TriggerServerEvent('erotic:reduceWeaponAmmo', ammoType)
--                     end
--                 end
--             end

--             Citizen.Wait(0)
--         end
--     end
-- )

function putawayGun(weaponName)
  Citizen.CreateThread(function()
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)

    if currentWeapon == GetHashKey(weaponName) then
      ClearPedTasks(ped)
      RemoveAllPedWeapons(ped, true)
    end
  end)
end

-- local cooldownWeapons = {
--   [`WEAPON_PRECISIONRIFLE`] = 750,
-- }

-- function putawayGun()
--   Citizen.CreateThread(
--     function()
--       local localPlayer = PlayerPedId()
--       if playerHasWeapon() then
--         local weapon = GetSelectedPedWeapon(PlayerPedId())
--         if cooldownWeapons[weapon] ~= nil then
--           CreateThread(function()
--             canEquipWeapon = false
--             local now = GetGameTimer()
--             local toWait = cooldownWeapons[weapon]
--             while GetGameTimer() - now < toWait do
--               Wait(5)
--               if IsEntityDead(PlayerPedId()) then
--                 toWait = 0
--               end
--             end
--             canEquipWeapon = true
--           end)
--         end
--         RemoveAllPedWeapons(localPlayer, false)
--       end
--       TriggerEvent("erotic:useWeapon")
--     end)
-- end
