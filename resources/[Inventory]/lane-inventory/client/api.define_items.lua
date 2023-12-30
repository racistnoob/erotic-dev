function Item.Register(item, data) -- register item to the ReigsteredItems table 
    RegisteredItems[item] = data
end

function Item.RequiresAnimClearance(item) -- check if InAnim check is required for this item to be used
    return RegisteredItems[item].animClearance 
end

function Item.Use(itemid, slot)
    if Item.RequiresAnimClearance(itemid) and Player.InAnim then return end
    local used = RegisteredItems[itemid].func(itemid)
    if used ~= false then
      TriggerEvent("inventory.api:itemUsed")
    end
  end

function API.UseItem(item, slot) -- this is just a translator, its really useless
    Item.Use(item, slot)
end

RegisterNetEvent("inventory.api:useItem", API.UseItem)