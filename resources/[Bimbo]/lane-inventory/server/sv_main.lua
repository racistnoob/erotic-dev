INVENTORY = {}
INVENTORY.MAIN = {

    Player = {},

    UseItem = function(self, source, slot)
        if self.Player[source][slot] == 'empty' then return end

        if string.find(self.Player[source][slot].item, "WEAPON") then
            return TriggerClientEvent('arena:useWeapon',source, self.Player[source][slot].item)
        end
    
        TriggerClientEvent('inventory.api:useItem', source, self.Player[source][slot].item, slot)
    end,

    AddItem = function(self, source, data, count)
        if not self.Player[source] then return print("Player not found") end


        print(data.item,data.slot)
        self.Player[source][data.slot] = {item = data.item, itemdata = {weight=0.5}, quantity=count}
        TriggerClientEvent('zbrp:updatePlayerInventory', source, self.Player[source])
    end,

    RemoveItem = function(self, source)

    end,

    ClearInventory = function(self, source)
        if not self.Player[source] then return print("Player not found") end

        self.Player[source] = {
            [1] = 'empty',
            [2] = 'empty',
            [3] = 'empty',
            [4] = 'empty',
            [5] = 'empty',
            [6] = 'empty',
            [7] = 'empty',
            [8] = 'empty',
            [9] = 'empty',
            [10] = 'empty',
            [11] = 'empty',
            [12] = 'empty',
            [13] = 'empty',
            [14] = 'empty',
            [15] = 'empty',
            [16] = 'empty',
            [17] = 'empty',
            [18] = 'empty',
            [19] = 'empty',
            [20] = 'empty',
            [21] = 'empty',
            [22] = 'empty',
            [23] = 'empty',
            [24] = 'empty',
            [25] = 'empty',
            [26] = 'empty',
            [27] = 'empty',
            [28] = 'empty',
            [29] = 'empty',
            [30] = 'empty',
        }
        Wait(200)
        TriggerClientEvent('zbrp:updatePlayerInventory', source, self.Player[source])
    end,


    GiveItem = function(self, ToPlayer, asd,Item)
        local player = ToPlayer
        local item = Item
        if not self.Player[player] then return print("Player not found") end
    
        local slot = self:GetFreeSlot(ToPlayer)
        if type(slot) ~= "number" then return end
        -- local IsSlotAvailable, error = self:IsSlotFree(player, slot)
        -- if not IsSlotAvailable then return print(error) end 
    
        -- print(player, GetPlayerName(player), item)
        -- print("Free Slot:", GetFreeSlot(player))
    
        self.Player[player][slot] = {item = Item, itemdata = {weight=0.5}, quantity = 1}
        TriggerClientEvent('zbrp:updatePlayerInventory', player, self.Player[player])
    end,

    MoveItem = function(self, source, data)
        local PlayerType = data['inventoryType']
        local DroppedTo = data['droppedTo']
        local count = data['count']
        local index = data['index']
        -- print("DEBUG MOVE ITEM: ","Source: "..source, "Player: "..PlayerType, "Slot: "..DroppedTo, "Count: "..count, "Index: "..index)
    
        local IsSlotAvailable, error = self:IsSlotFree(source, DroppedTo)
        if not IsSlotAvailable then return print(error) end 
        self.Player[source][DroppedTo] = self.Player[source][index]
        self.Player[source][index] = 'empty'
        TriggerClientEvent('zbrp:updatePlayerInventory', source, self.Player[source])
    end,

    IsSlotFree = function(self, source, slot)
        if not self.Player[source] then return false, "Player NOT FOUND" end
        if self.Player[source][slot] ~= 'empty' then return false, "SLOT TAKEN" end
    
        return true
    end,

    GetFreeSlot = function(self, source)
        if not self.Player[source] then return "Player NOT FOUND" end
    
        for k,v in pairs(self.Player[source]) do
            if v == 'empty' then return k end
        end 
    end,

    SetupPlayer = function(self, source)
        local source = source 
        if not source then return print("Error 501") end
    
        self.Player[source] = {
            [1] = 'empty',
            [2] = 'empty',
            [3] = 'empty',
            [4] = 'empty',
            [5] = 'empty',
            [6] = 'empty',
            [7] = 'empty',
            [8] = 'empty',
            [9] = 'empty',
            [10] = 'empty',
            [11] = 'empty',
            [12] = 'empty',
            [13] = 'empty',
            [14] = 'empty',
            [15] = 'empty',
            [16] = 'empty',
            [17] = 'empty',
            [18] = 'empty',
            [19] = 'empty',
            [20] = 'empty',
            [21] = 'empty',
            [22] = 'empty',
            [23] = 'empty',
            [24] = 'empty',
            [25] = 'empty',
            [26] = 'empty',
            [27] = 'empty',
            [28] = 'empty',
            [29] = 'empty',
            [30] = 'empty',
        }


        TriggerClientEvent('zbrp:setPlayerStaticData', source, 250, GetPlayerName(source))
        TriggerClientEvent('zbrp:updatePlayerInventory', source, self.Player[source])
        TriggerClientEvent('zbrp:JoinedLobby', source)
    end,

}

RegisterNetEvent('zbrp:Player:addItem', function(...)
    INVENTORY.MAIN:AddItem(source,...)
end)

RegisterNetEvent('zbrp:Player:removeItem', function(...)
    INVENTORY.MAIN:RemoveItem(source,...)
end)

RegisterNetEvent('zbrp:Player:clearItems', function(...)
    print("clearitems")
    INVENTORY.MAIN:ClearInventory(source, ...)
end)

RegisterNetEvent('nui:zbrp:useItem', function(...)
    INVENTORY.MAIN:UseItem(source, ...)
end)

RegisterNetEvent('GiveItem', function(...)
    print(...)
    INVENTORY.MAIN:GiveItem(source, ...)
end)



RegisterNetEvent('nui:zbrp:moveInside', function(...)
    INVENTORY.MAIN:MoveItem(source, ...)
end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ \n'
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ',\n'
       end
       return s .. '} \n'
    else
       return tostring(o)
    end
end


RegisterCommand("inv", function(source,args,rawcommand)
    local source = source 
    if not source then return print("Error 501") end

    INVENTORY.MAIN.Player[source] = {
        [1] = {item = "WEAPON_ASSAULTRIFLE", itemdata = {weight=0.5}, quantity = 1},
        [2] = {item = "WEAPON_HEAVYPISTOL", itemdata = {weight=0.5}, quantity = 1},
        [3] = 'empty',
        [4] = 'empty',
        [5] = 'empty',
        [6] = 'empty',
        [7] = 'empty',
        [8] = 'empty',
        [9] = 'empty',
        [10] = 'empty',
        [11] = 'empty',
        [12] = 'empty',
        [13] = 'empty',
        [14] = 'empty',
        [15] = 'empty',
        [16] = 'empty',
        [17] = 'empty',
        [18] = 'empty',
        [19] = 'empty',
        [20] = 'empty',
        [21] = 'empty',
        [22] = 'empty',
        [23] = 'empty',
        [24] = 'empty',
        [25] = 'empty',
        [26] = 'empty',
        [27] = 'empty',
        [28] = 'empty',
        [29] = 'empty',
        [30] = 'empty',
    }

    TriggerClientEvent('zbrp:setPlayerStaticData', source, 250, GetPlayerName(source))
    TriggerClientEvent('zbrp:updatePlayerInventory', source, INVENTORY.MAIN.Player[source])
    TriggerClientEvent('zbrp:JoinedLobby', source)
end)

RegisterNetEvent('SETUPINVENTORY', function(...)
    INVENTORY.MAIN:SetupPlayer(source, ...)
end)

AddEventHandler('playerDropped', function(reason)
    INVENTORY.MAIN.Player[source] = nil
end)


