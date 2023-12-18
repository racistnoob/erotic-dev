--[[ New Banking System ]]--

local discordwebhook = ""

local defaultTax = 0.0712

function GetBank(playerId, isCid) -- exports['drp']:GetBank(source)
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if GetPlayerFromCid(id) then
        return GetPlayerFromCid(id).bank
    end
end

exports('GetBank', GetBank)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

AddEventHandler('SplitTax', function(amount, type)
    if type == "casino" then
        local dojSplit = amount * 0.80 -- 80%
        local casinoSplit = amount * 0.20 -- 20%
        exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="doj"', { amount = dojSplit })
        exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="casino"', { amount = casinoSplit })
    else
        exports.oxmysql:executeSync('UPDATE businesses SET funds=funds+:amount WHERE name="doj"', { amount = amount })
    end
end)

local function TaxPlayer(sentAmount, player, version, varTax)
    local amount = tonumber(sentAmount)
    if varTax == nil or varTax == false then varTax = defaultTax end
    local tableJ = nil
    if type(varTax) == "table" then
        local knownVar = varTax
        varTax, taxType = knownVar['num'], knownVar['type']
    end
    local taxAmount = amount * varTax
    if version == 1 then
        local finalAmount = amount - taxAmount
        TriggerEvent('SplitTax', taxAmount, taxType)
        if player then
            local taxAmount = round(taxAmount, 2)
            TriggerClientEvent('drp-notifications:client:SendAlert', player.source, { type = 'inform', text = 'This transaction was taxed at a rate of '..varTax..'% ($'..taxAmount..')', length = 7500 })
        end
        return finalAmount
    elseif version == 2 then
        TriggerEvent('SplitTax', taxAmount, taxType)
        if player then
            local taxAmount = round(taxAmount, 2)
            TriggerClientEvent('drp-notifications:client:SendAlert', player.source, { type = 'inform', text = 'This transaction was taxed at a rate of 8.22% ($'..taxAmount..')', length = 7500 }) 
        end
        TriggerEvent('RemoveBank', player.cid, taxAmount, true, false)
    end
end

local crazyThreshold = 100000

AddEventHandler('AdjustBank', function(playerId, amount, isCid, shouldTax, cb) 
    local id = playerId
    if isCid == nil or not isCid then id = GetOnePlayerInfo(playerId, 'cid') end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end
    local player = GetPlayerFromCid(id)
    if shouldTax and amount >= 0 then amount = TaxPlayer(amount, player, 1) end

    if amount >= crazyThreshold then
        local msg = "Type: **AdjustBank**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:execute("UPDATE users SET bank = bank+:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            local newBank = player.bank + amount
            SetPlayerData(player.source, 'bank', round(newBank, 2))
            if cb then cb(true) end
        else
            if cb then cb(false) end
        end
    end)
end)

AddEventHandler('AddBank', function(playerId, amount, isCid, shouldTax, taxVar, cb) 
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end
    local player = GetPlayerFromCid(id)
    if taxVar == nil or taxVar == false then taxVar = defaultTax end 
    if shouldTax then amount = TaxPlayer(amount, player, 1, taxVar) end

    if amount >= crazyThreshold then
        local msg = "Type: **AddBank**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end
    
    exports.oxmysql:execute("UPDATE users SET bank = bank+:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            if player then
                local newBank = player.bank + amount
                SetPlayerData(player.source, 'bank', round(newBank, 2))
                TriggerClientEvent("banking:viewBalance", player.source, round(newBank, 2))
                TriggerClientEvent("banking:addBalance", player.source, round(amount, 2))
            end
        end
        if cb then cb(endResult ~= nil)  end
    end)
end)

AddEventHandler('AddBankOffline', function(playerId, amount, shouldTax, taxVar) 
    local id = playerId
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end
    if taxVar == nil or taxVar == false then taxVar = defaultTax end
    if shouldTax then amount = TaxPlayer(amount, player, 1, taxVar) end

    if amount >= crazyThreshold then
        local msg = "Type: **AddBankOffline**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:executeSync("UPDATE users SET bank = bank+:amount WHERE id=:id", {amount = amount, id = id})
end)

AddEventHandler('RemoveBank', function(playerId, amount, isCid, shouldTax) 
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end
    local player = GetPlayerFromCid(id)
    if shouldTax then TaxPlayer(amount, player, 2) end

    if amount >= crazyThreshold then
        local msg = "Type: **RemoveBank**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:execute("UPDATE users SET bank = bank-:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            local newBank = player.bank - amount
            SetPlayerData(player.source, 'bank', round(newBank, 2))
            TriggerClientEvent("banking:viewBalance", player.source, round(newBank, 2))
            TriggerClientEvent("banking:removeBalance", player.source, round(amount, 2))
        end
    end)
end)

AddEventHandler('TransferBank', function(source, target, amount, shouldTax, cb) 
    if type(amount) == 'string' then amount = tonumber(amount) end if type(source) == 'string' then source = tonumber(source) end
    if source then
        if target and amount then
            local player = GetPlayerFromId(source)
            if player then
                exports.oxmysql:execute("UPDATE users SET bank = bank-:amount WHERE id=:id", {amount = amount, id = player.cid}, function(endResult)
                    if endResult then
                        local newBank = player.bank - amount
                        SetPlayerData(player.source, 'bank', round(newBank, 2))
                        if cb then cb(true) end;
                        local targetPly = GetPlayerFromCid(target)
                        local oldAmount = amount
                        if shouldTax then amount = TaxPlayer(amount, targetPly, 1) end
                        exports.oxmysql:execute("UPDATE users SET bank = bank+:amount WHERE id=:id", {amount = amount, id = target}, function(newResult)
                            if newResult then
                                if targetPly then
                                    local newBank = targetPly.bank + amount
                                    SetPlayerData(targetPly.source, 'bank', round(newBank, 2))
                                    TriggerClientEvent('drp-notifications:client:SendAlert', targetPly['source'], { type = 'inform', text = 'You were transferred $'..oldAmount..' from '..player['fullname'], length = 5000 })
                                end
                            end 
                        end)
                    else
                        if cb then cb(false) end;
                    end
                end)
            end
        end 
    end 
end)

--[[ New Cash System ]]--

function GetCash(playerId, isCid) -- exports['drp']:GetCash(source)
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if GetPlayerFromCid(id) then
        return GetPlayerFromCid(id).cash
    end
end

AddEventHandler('AdjustCash', function(playerId, amount, isCid, cb) 
    local id = playerId
    if isCid == nil or not isCid then id = exports['echorp']:GetPlayerFromId(playerId).cid end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end

    if amount >= crazyThreshold then
        local msg = "Type: **AdjustCash**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:execute("UPDATE users SET cash = cash+:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            local player = GetPlayerFromCid(id)
            local newCash = player.cash + amount
            SetPlayerData(player.source, 'cash', round(newCash, 2))
            if cb then cb(true) end
        else
            if cb then cb(false) end
        end
    end)
end)

AddEventHandler('AddCash', function(playerId, amount, isCid) 
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end

    if amount >= crazyThreshold then
        local msg = "Type: **AddCash**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:execute("UPDATE users SET cash = cash+:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            local player = GetPlayerFromCid(id)
            local newCash = player.cash + amount
            SetPlayerData(player.source, 'cash', round(newCash, 2))
            TriggerClientEvent("banking:addCash", player.source, round(amount, 2))
            TriggerClientEvent('banking:viewCash', player.source, round(newCash, 2))
        end
    end)
end)

AddEventHandler('RemoveCash', function(playerId, amount, isCid) 
    local id = playerId
    if isCid == nil or not isCid then id = GetPlayerFromId(playerId).cid end
    if type(amount) == 'string' then amount = tonumber(amount) end if type(playerId) == 'string' then playerId = tonumber(playerId) end

    if amount >= crazyThreshold then
        local msg = "Type: **RemoveCash**\n Citizen ID: **"..id.."**\nAmount: **"..amount.."**\n\nKeep an eye on this one, I was told to transaction over $100,000, "..GetInvokingResource()
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', msg, "16711680", discordwebhook)
    end

    exports.oxmysql:execute("UPDATE users SET cash = cash-:amount WHERE id=:id", {amount = amount, id = id}, function(endResult)
        if endResult then
            local player = GetPlayerFromCid(id)
            local newCash = player.cash - amount
            SetPlayerData(player.source, 'cash', round(newCash, 2))
            TriggerClientEvent("banking:removeCash", player.source, round(amount, 2))
            TriggerClientEvent('banking:viewCash', player.source, round(newCash, 2))
        end
    end)
end)

exports('GetCash', GetCash)