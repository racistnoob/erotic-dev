RegisterNetEvent("zbrp:inv:client:giveItemTable", function(items)
    if not items then return false end
    if #items == 0 then return false end
    for _, group in pairs(items) do 
      local item = group[1]
      local amount = group[2]
      API.GiveItem(item, amount)
    end
  end)

function API.GiveItem(item, count, slot) -- slot is not a required param
    TriggerServerEvent("zbrp:Player:addItem", {item = item, slot = slot}, count)
end

function API.RemoveItem(item, count)
    TriggerServerEvent("zbrp:Player:removeItem", item, count)
    Player.InAnim = false -- when oxy and armour is removed etc...
end

RegisterNetEvent("zbrp:inv.RemoveItem", API.RemoveItem)
RegisterNetEvent("zbrp:inv.GiveItem", API.GiveItem)

function API.HasItem(item) -- check if player has item
    if not inventoryData then return end
    for k, v in pairs(inventoryData) do
      if v.item == item then return v end
    end
    return false
end

exports("PlayerHasItem", API.HasItem)

function API.HasWeapon(weaponHash)
    if not inventoryData then return false end
    for k, v in pairs(inventoryData) do
      if GetHashKey(v.item) == tonumber(weaponHash) then
        return true
      end
    end
    return false
end
  
exports("PlayerHasWeapon", API.HasWeapon)

function API.GetItemInSlot(slot)
    return inventoryData[slot].item 
end

function API.SyncAmmo() -- when a player picks up an item or something changes in their inventory it syncs the ammo
    local currentWeapon = GetSelectedPedWeapon(Player.Ped())
    local ammoType = findAmmoType(currentWeapon)
    local ammoCount = ammoCount(ammoType)
    SetPedAmmo(Player.Ped(), currentWeapon, ammoCount)
end

function API.ThrowItem(itemData, atCoords) -- experimental, not to be used in live environment yet
    TriggerServerEvent('nui:zbrp:throwItem', data, atCoords)
end