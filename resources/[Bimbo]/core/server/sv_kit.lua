local kits = {
    default = {
        { item = '-774507221', amount = 1 },
        { item = 'vicodin', amount = 5 },
        { item = 'HeavyArmor', amount = 10 },
        { item = '-998000829', amount = 1 },
    },
    starter = {
        { item = '-998000829', amount = 1 },
        { item = '-947031628', amount = 1 },
        { item = '-774507221', amount = 1 },
        { item = '-86904375', amount = 1 },
        { item = '-1074790547', amount = 1 },
        { item = '324215364', amount = 1 },
        { item = 'HeavyArmor', amount = 999 },
        { item = 'vicodin', amount = 999 },
        { item = 'blunt', amount = 999 },
        { item = '-2060501776', amount = 1 },
        { item = '-771403250', amount = 1 },
        { item = '1303514201', amount = 1 },
    },
    pvp = {
        { item = 'HeavyArmor', amount = 999 },
        { item = 'vicodin', amount = 999 },
        { item = 'blunt', amount = 999 },
    },
    car = {
        { item = 'nitrous', amount = 1 }
    },
    pistol = {
        { item = '-998000829', amount = 1 },
        { item = 'HeavyArmor', amount = 10 },
        { item = 'vicodin', amount = 5 },
    },
    rifle = {
        { item = '-774507221', amount = 1 },
        { item = 'HeavyArmor', amount = 10 },
        { item = 'vicodin', amount = 5 },
    },
}

RegisterNetEvent('core:applyKit')
AddEventHandler('core:applyKit', function(kitName)
    local source = source
    local kitItems = kits[kitName]

    if kitItems then
        for _, kitItem in ipairs(kitItems) do
            local item = kitItem.item
            local amount = kitItem.amount
            TriggerClientEvent('empty:hands', source)
            TriggerClientEvent('player:receiveItem', source, item, amount)
            Citizen.Wait(50)
        end

        print("Applied the " .. kitName .. " kit to player " .. source)
    else
        print("Invalid kit name:", kitName)
    end
end)

RegisterNetEvent('core:removeKit')
AddEventHandler('core:removeKit', function(kitName)
    local source = source
    local kitItems = kits[kitName]

    if kitItems then
        for _, kitItem in ipairs(kitItems) do
            local item = kitItem.item
            TriggerClientEvent('empty:hands', source)
            TriggerClientEvent('inventory:removeItem', source, item, 999)
        end

        print("Removed items from the " .. kitName .. " kit for player " .. source)
    else
        print("Invalid kit name:", kitName)
    end
end)

TriggerEvent('chat:addSuggestion', '/kit', 'Receive a specific kit.', {
    { name="kitname", help="The name of the kit (e.g., heavyrifle, ak)" }
})

