local Webhook = ""

RegisterCommand("copycoords", function(source, args, rawCommand)
    local type = args[1]
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)

    if type == 'vector4' then
        local heading = GetEntityHeading(ped)
        printOUT = "vector4("..tonumber(string.format("%.2f", coords["x"]))..", "..tonumber(string.format("%.2f", coords["y"]))..", "..tonumber(string.format("%.2f", coords["z"]))..", "..tonumber(string.format("%.2f", heading))..")"
        TriggerEvent('erp_adminmenu:discord', 'Coords From: '..GetPlayerName(source), printOUT, '14047329', Webhook)
    else
        printOUT = "vector3("..tonumber(string.format("%.2f", coords["x"]))..", "..tonumber(string.format("%.2f", coords["y"]))..", "..tonumber(string.format("%.2f", coords["z"]))..")"
        TriggerEvent('erp_adminmenu:discord', 'Coords From: '..GetPlayerName(source), printOUT, '3252448', Webhook)
    end
end, false)

RegisterCommand("kvpcheck", function(source, args, rawCommand)
    local toCheck = args[1]
    local type = tonumber(args[2])
    if toCheck and type == 1  then
      print(GetResourceKvpString(toCheck))
    elseif toCheck and type == 2  then
        print(GetResourceKvpInt(toCheck))
    end
end, true)

RegisterCommand("kvpset", function(source, args, rawCommand)
    local toCheck = args[1]
    local toSet = args[2]
    local type = tonumber(args[3])
    if toCheck and toSet and type == 1 then
        SetResourceKvp(toCheck, toSet) 
    elseif toCheck and toSet and type == 2 then
        SetResourceKvpInt(toCheck, tonumber(toSet)) 
    end
end, true)

RegisterCommand("addbank", function(source, args, rawCommand)
    
    local function Notify(msg)
        if source == 0 then print(msg)
        elseif GetPlayerName(source) then TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = msg, length = 5000 }) end 
    end

    local function DiscordLog(title, msg)
        TriggerEvent('erp_adminmenu:discord', title, msg, '6003445', '')
    end
    
    local cid, amount = args[1], tonumber(args[2])
    if cid then
        if amount and amount > 0 then
            local target = GetPlayerFromCid(cid)
            if target then
                TriggerEvent('AddBank', cid, amount, true, false, false, function(res)
                    if res then 
                        Notify('Yay! We just gave someone $'..amount)
                        DiscordLog('Add bank command', GetPlayerName(source)..' added $'..amount..' to '..cid..'\'s bank!')
                    else 
                        Notify('Uh oh... failed to give $'..amount) 
                    end
                end)
            else
                TriggerEvent('AddBankOffline', cid, amount) 
                Notify('Yay! We just gave someone who is offline $'..amount) 
                DiscordLog('Add bank command', GetPlayerName(source)..' added $'..amount..' to '..cid..'\'s bank!') 
            end
        else Notify('You failed to specify an amount greater than $0') end
    else Notify('Please specify a CID, such as 1998') end
end, true)

local TokenTypes = {
    ['Ringtone'] = true,
    ['Number'] = true,
    ['Plate'] = true,
    ['Handle'] = true
}

RegisterCommand("addtoken", function(source, args, rawCommand)
    local type = args[1]
    local discord = args[2]

    if type then
        if TokenTypes[type] then
            if discord then
                exports.oxmysql:executeSync('INSERT INTO `donatorperks` (`type`, `discord`) VALUES (:type, :discord);', { type = type, discord = discord })
                TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = "Donator perk added.", length = 5000 })
            else
                TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = "You did not provide a discord ID", length = 5000 })
            end
        else
            TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = "Invalid token type - Try ringtone, number, plate or handle.", length = 5000 })
        end
    else
        TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = "You failed to provide a token type - Try ringtone, number, plate or handle.", length = 5000 })
    end
end, true)