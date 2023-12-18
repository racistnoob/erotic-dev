Players = {}
PlayersCID = {}

function identifier(playerId) return GetPlayerIdentifier(playerId, 0) end  -- exports['drp']:identifier(playerId)

AddEventHandler('playerDropped', function(reason)
    local playerData = Players[source]
    if playerData then 
        TriggerEvent('echorp:playerDropped', playerData) 
        Players[playerData.source] = nil
        PlayersCID[playerData.cid] = nil
    end
end)

AddEventHandler('echorp:getplayerfromid', function(playerId, cb)
    local playerId = tonumber(playerId)
    if playerId and playerId > 0 then if Players[playerId] then cb(Players[playerId]) else cb(nil) end
    else cb(nil) end
end)


function GetPlayerFromId(playerId) -- exports['drp']:GetPlayerFromId(playerId)
    if tonumber(playerId) then
        if Players[tonumber(playerId)] then return Players[tonumber(playerId)] else return nil end 
    end 
end

function GetOnePlayerInfo(playerId, infoWanted) -- exports['drp']:GetOnePlayerInfo(playerId, 'cid')
    local playerData = Players[playerId]
    if playerData then return playerData[infoWanted] end return nil
end -- This is useful for just grabbing one or two pieces of info rather than the whole player object, #performance.

function GetPlayerFromCid(cid) -- exports['drp']:GetPlayerFromCid(cid)
    local cid = tonumber(cid)
    if cid then
        if PlayersCID[cid] then
            return Players[PlayersCID[cid]]
        else
            return nil
        end
    end
end

AddEventHandler('echorp:GetPlayerFromCid', function(cid, cb)
    local cid = tonumber(cid)
    if cid then
        if PlayersCID[cid] then
            cb(Players[PlayersCID[cid]])
        else
            cb(nil)
        end
    end
end)

function GetPlayerFromIdentifier(identifier) -- exports['drp']:GetPlayerFromIdentifier(identifier)
    if identifier then
        local data = nil
        for k,v in pairs(Players) do if v.identifier == identifier then data = Players[k] break end
        end return data
    end 
end

function GetPlayerFromPhone(phonenumber) -- exports['drp']:GetPlayerFromPhone(phonenumber)
    local phonenumber = tostring(phonenumber)
    if phonenumber then
        local data = nil
        for k,v in pairs(Players) do if v.phone_number == phonenumber then data = Players[k] break end
        end return data
    end 
end

function DoesCidExist(cid) -- exports['drp']:DoesCidExist(cid)
    local cid = tonumber(cid)
    local p = promise.new()
    exports.oxmysql:fetch("SELECT 1 FROM users WHERE `id`=:id LIMIT 1", {id = cid}, function(data) p:resolve(data) end)
    return Citizen.Await(p)
end

function SetPlayerData(source, toChange, targetData) -- exports['drp']:SetPlayerData(source, 'phone_number', number)
    Players[tonumber(source)][toChange] = targetData
    TriggerClientEvent('echorp:updateinfo', source, toChange, targetData)
end

function GetFXPlayers() return Players end -- exports['drp']:GetFXPlayers()

--[[ Exports ]]--

exports("GetPlayerFromId", GetPlayerFromId)
exports("GetOnePlayerInfo", GetOnePlayerInfo)
exports("GetPlayerFromCid", GetPlayerFromCid)
exports("GetFXPlayers", GetFXPlayers)
exports('identifier', identifier)
exports('SetPlayerData', SetPlayerData)
exports('DoesCidExist', DoesCidExist)
exports('GetPlayerFromPhone', GetPlayerFromPhone)
exports('GetPlayerFromIdentifier', GetPlayerFromIdentifier)

--[[ Character selector events & callbacks ]]

RegisterNetEvent('echorp:fetchcharacters')
AddEventHandler('echorp:fetchcharacters', function()
    
    local source = source
    local Characters = {}
    local steam = ""

    for i=0, GetNumPlayerIdentifiers(source) - 1 do
        local identifier = GetPlayerIdentifier(source, i)
        if identifier then
            if string.find(identifier, "steam:") then
                steam = identifier
                break
            end
        end
    end

    if not string.find(steam, "steam:") then
        DropPlayer(source, "EchoRP core was unable to find your steam identifier!")
        return
    end

    local KnownCharacters = exports.oxmysql:fetchSync("SELECT id, cash, bank, firstname, lastname FROM users WHERE identifier=:identifier", { identifier = steam })
    
    for i=1, #KnownCharacters do
        local cid = KnownCharacters[i]['id']
        Characters[i] = { info = KnownCharacters[i], cPed = {} }
        local Skin = exports.oxmysql:fetchSync("SELECT model, drawables, props, drawtextures, proptextures FROM character_current WHERE cid = :cid LIMIT 1", {cid = cid })
        if Skin and Skin[1] then

            Characters[i]['cPed'] = {
                model = Skin[1].model,
                drawables = json.decode(Skin[1].drawables),
                props = json.decode(Skin[1].props),
                drawtextures = json.decode(Skin[1].drawtextures),
                proptextures = json.decode(Skin[1].proptextures),
                tattoos = {}
            }

            local Face = exports.oxmysql:fetchSync("SELECT hairColor, headBlend, headOverlay, headStructure FROM character_face WHERE cid = :cid LIMIT 1", {cid = cid})
            if Face and Face[1] then
                Characters[i]['cPed']['hairColor'] = json.decode(Face[1].hairColor)
                Characters[i]['cPed']['headBlend'] = json.decode(Face[1].headBlend)
                Characters[i]['cPed']['headOverlay'] = json.decode(Face[1].headOverlay)
                Characters[i]['cPed']['headStructure'] = json.decode(Face[1].headStructure)                
            end

            local Tats = exports.oxmysql:fetchSync("SELECT tattoos FROM playersTattoos WHERE cid = :cid LIMIT 1", {cid = cid})
            if Tats and Tats[1] and Tats[1]['tattoos'] then
                Characters[i]['cPed']['tattoos'] = json.decode(Tats[1].tattoos)
            end
            
        end
    end

    TriggerClientEvent('fetchCharacters', source, Characters)
    
end)

RegisterNetEvent('echorp:deleteCharacter')
AddEventHandler('echorp:deleteCharacter', function(cid)
    local source = source
    if source then
        exports.oxmysql:fetch("SELECT `identifier` FROM `users` WHERE id=:id LIMIT 1", {
            id = cid,
        }, function(data)
            if data and data[1] then
                if data[1]['identifier'] == GetPlayerIdentifier(source, 0) then
                    exports.oxmysql:execute("DELETE FROM `users` WHERE id=:id", {
                        id = cid,
                    }, function(data)
                        if data then
                            TriggerEvent('echorp:sql:deleteCharacter', cid)
                        end 
                    end)
                else
                    --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', source..' at this time attempted to delete character with CID: '..cid..' but is not the owner...', "16711680", "")
                end
            else
                --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', source..' at this time attempted to delete character with CID: '..cid..' but it does not exist...', "16711680", "")
            end 
        end)
    else
        --exports[drp_adminmenu']:sendToDiscord('Anti Cheat', 'Someone attempted to delete character without having a source...', "16711680", "")
    end    
end)

local names = {
    ['iyruk'] = true,
    ['Flawws'] = true
}

policeJobs = {
    ['lspd'] = true,
    ['bcso'] = true,
    ['sahp'] = true,
    ['sasp'] = true,
    ['doc'] = true,
    ['sapr'] = true,
    ['pa'] = true
}

RegisterNetEvent('echorp:selectCharacter')
AddEventHandler('echorp:selectCharacter', function(cid) 
    local playerId, cid = tonumber(source), tonumber(cid)
    if Players[playerId] or PlayersCID[cid] then
        if not names[GetPlayerName(playerId)] then
            DropPlayer(playerId, 'You already appear to be loaded on our Framework\nDropping you as a caution measure.') 
            return 
        end
    end
    local identifier = GetPlayerIdentifier(playerId, 0)
    if identifier and string.find(identifier, "steam") then
        exports.oxmysql:fetch('SELECT `cash`, `bank`, `job`, `job_grade`, `duty`, `firstname`, `lastname`, `gender`, `phone_number`, `jail_time`, `twitterhandle` FROM `users` WHERE `id`=:id LIMIT 1', {
            id = cid
        }, function(sentInfo) 
            if sentInfo and sentInfo[1] then 
                StarterInfo = sentInfo[1]
                local isPolice = false
                if policeJobs[StarterInfo['job']] == true then isPolice = true end
                local PlayerInfo = { source = playerId, identifier = identifier, cid = cid, id = cid,
                    cash = tonumber(StarterInfo['cash']),
                    bank = tonumber(StarterInfo['bank']),
                    job = { name = StarterInfo['job'], grade = tonumber(StarterInfo['job_grade']), duty = tonumber(StarterInfo['duty']), isPolice = isPolice },
                    sidejob = { name = "none", label = "None" },
                    isPolice = isPolice,
                    firstname = StarterInfo['firstname'],
                    lastname = StarterInfo['lastname'],
                    fullname = StarterInfo['firstname']..' '..StarterInfo['lastname'],
                    gender = StarterInfo['gender'],
                    phone_number = StarterInfo['phone_number'],
                    jail_time = StarterInfo['jail_time'],
                    twitterhandle = StarterInfo['twitterhandle'],
                }
                Players[playerId] = PlayerInfo
                PlayersCID[cid] = playerId

                local thirst = GetResourceKvpInt(PlayerInfo['cid'].."-thirst")
                if thirst == 0 or thirst == nil then
                    thirst = 5000
                end

                local hunger = GetResourceKvpInt(PlayerInfo['cid'].."-hunger")
                if hunger == 0 or hunger == nil then
                    hunger = 5000
                end

                TriggerClientEvent('echorp:spawnPlayer', playerId, PlayerInfo, GetResourceKvpString(PlayerInfo['cid'].."-coords"), GetResourceKvpInt(PlayerInfo['cid'].."-armour"), GetResourceKvpInt(PlayerInfo['cid'].."-stress"), thirst, hunger)
                local message = "Player: **"..GetPlayerName(PlayerInfo['source']).."** (**"..PlayerInfo['source'].."**)\nCharacter: **"..PlayerInfo['fullname']..' ['..PlayerInfo['cid']..']'.."**\nIdentifier: **"..PlayerInfo['identifier'].."**\nCash: `$"..PlayerInfo['cash'].."` · Bank: `$"..PlayerInfo['bank'].."` · Job: `"..PlayerInfo['job']['name'].."` | `"..PlayerInfo['job']['grade'].."`"
                --exports[drp_adminmenu']:sendToDiscord('Player Logging In', message, "8598763", "")
                if isPolice or PlayerInfo.job.name == 'ambulance' then TriggerEvent('echorp:notifyDuty',PlayerInfo,'join') end
            else
                DropPlayer(playerId, 'Missing selected character information\nDropping you as a caution measure.')
            end
        end)
    else DropPlayer(playerId, 'Missing steam identifier') end
end)

RegisterNetEvent('echorp:createCharacter')
AddEventHandler('echorp:createCharacter', function(charInfo) 
    local src = source
    if charInfo then
        local gender = 'm' if charInfo.gender == 1 then gender = 'f' end
        local steam = GetPlayerIdentifier(src, 0)
        exports.oxmysql:insert("INSERT INTO `users` (`identifier`, `firstname`, `lastname`, `dateofbirth`, `gender`) VALUES (:identifier, :firstname, :lastname, :dateofbirth, :gender)", {
            identifier = steam,
            firstname = charInfo.firstname,
            lastname = charInfo.lastname,
            dateofbirth = charInfo.dob,
            gender = gender
        }, function(res)
            if res then 
                exports.oxmysql:fetch('SELECT id FROM `startermoney` WHERE steam=:steam LIMIT 1', {
                    steam = steam
                }, function(result)
                    if result and result[1] then 
                        TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'No starter money was given for this character, this is intentional.', length = 5000 })
                        exports.oxmysql:executeSync("UPDATE `users` SET `cash`='0', `bank`='0' WHERE `id`=:id", {
                            id = res
                        })
                    else
                        exports.oxmysql:executeSync('INSERT INTO `startermoney` (`steam`) VALUES (:steam)', {steam = steam})
                    end
                end)
            end
        end)
    end
end)

-- Logout

RegisterNetEvent('echorp:logout')
AddEventHandler('echorp:logout', function()
    local src = source
    local playerData = Players[src]
    if playerData then
        Players[src] = nil 
        PlayersCID[playerData.cid] = nil
        TriggerClientEvent('echorp:doLogout', src, playerData)
        TriggerEvent('echorp:doLogout', playerData)
        local message = "Player: **"..GetPlayerName(src).."** (**"..src.."**)\nCharacter: **"..playerData['fullname']..' ['..playerData['cid']..']'.."**\nIdentifier: **"..playerData['identifier'].."**\nCash: `$"..playerData['cash'].."` · Bank: `$"..playerData['bank'].."` · Job: `"..playerData['job']['name'].."` | `"..playerData['job']['grade'].."`"
        --exports[drp_adminmenu']:sendToDiscord('Player Logging Off', message, "16758838", "")
    end
end)

RegisterCommand("logout", function(source, args, rawCommand)
    local source = source
    if Players[source] then
        TriggerClientEvent('resetfromfx', source)
    end
end, false)

-- Coords Saving

CreateThread(function()
    while true do
        local time = 0
        for k, player in pairs(Players) do
            Wait(100)
            time = time + 100
            if Players[player['source']] then
                local source, cid = player['source'], player['cid']
                local plyPed = GetPlayerPed(source)
                local plyPos, armour = GetEntityCoords(plyPed), GetPedArmour(plyPed)
                SetResourceKvpNoSync(cid..'-coords', json.encode(plyPos))
                SetResourceKvpIntNoSync(cid..'-armour', armour)
                SetResourceKvpIntNoSync(cid..'-stress', Player(source).state.stressLevel)
                SetResourceKvpIntNoSync(cid..'-thirst', Player(source).state.thirstLevel)
                SetResourceKvpIntNoSync(cid..'-hunger', Player(source).state.hungerLevel)
            end
        end
        Wait(15000)
    end
end)