local shifts = {}

local function NewPaycheck(cid, amount, type, source)
    if cid and amount then
        exports.oxmysql:executeSync('UPDATE `users` SET paycheck = paycheck + :amount WHERE id=:id', { amount = amount, id = cid })
        if type == 1 then
            TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = 'Your universal basic income check is ready to collect from the Lifeinvader building', length = 7500 } )
        elseif type == 2 then
            TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = 'Your paycheck is ready to collect from the Lifeinvader building', length = 7500 } )
        end
    end
end

local NoTaxJobs = {
    ['lspd'] = true,
    ['bcso'] = true,
    ['sahp'] = true,
    ['sasp'] = true,
    ['doc'] = true,
    ['sapr'] = true,
    ['pa'] = true,
    ['ambulance'] = true,
    ['cmmc'] = true,
    ['doj'] = true,
    ['legacyrecords'] = true,
}

local Guaranteed = {
    ['lspd'] = true,
    ['bcso'] = true,
    ['sahp'] = true,
    ['sasp'] = true,
    ['doc'] = true,
    ['sapr'] = true,
    ['legacyrecords'] = true,
    ['pa'] = true,
    ['ambulance'] = true,
    ['weazelnews'] = true
}

local function Paychecks()
    local walfareCheck = math.random(50, 75)
    for k,v in pairs(Players) do
        Wait(100)
        if v.job then
            local source, cid, job, grade, duty = v.source, v.cid, v.job.name, v.job.grade, v.job.duty
            NewPaycheck(cid, walfareCheck, 1, source)
            if duty == 1 then
                if Jobs[job] then
                    local gradeInfo = Jobs[job]['grades'][grade]
                    if gradeInfo then
                        local pay = tonumber(gradeInfo['moneys'])
                        if Jobs[job]['business'] then
                            if Guaranteed[job] then
                                NewPaycheck(cid, pay, 2, source)
                            else
                                TriggerEvent('erp_phone:GetMoney', job, function(res)
                                    if res then
                                        if res >= pay then
                                            exports.oxmysql:executeSync("UPDATE businesses SET funds = funds-:pay WHERE name=:name", {pay = pay, name = job})
                                            NewPaycheck(cid, pay, 2, source)
                                        else
                                            TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'inform', text = 'Your current employee does not have enough funds to pay you this week.', length = 7500 })
                                        end
                                    end
                                end)
                            end
                        else
                            NewPaycheck(cid, pay, 2, source)
                        end
                    end
                end
            end
        end
    end
    Citizen.SetTimeout(math.random(1350000, 2250000), function() Paychecks() end) -- 30 mins.
end

Citizen.SetTimeout(math.random(1350000, 2250000), function() Paychecks() end) -- 5 mins.

RegisterNetEvent('echorp:collectpaycheck')
AddEventHandler('echorp:collectpaycheck', function()
    TriggerEvent('echorp:getplayerfromid', source, function(player)
        if player then
            exports.oxmysql:fetch("SELECT paycheck FROM users WHERE id=:id LIMIT 1", {
                id = player.cid
            }, function(res)
                if res and res[1] then
                    if res[1]['paycheck'] then
                        local shouldTax = true
                        if NoTaxJobs[player.job.name] then shouldTax = false end
                        TriggerEvent('AddBank', player['cid'], res[1]['paycheck'], true, shouldTax, false, function(x)
                            TriggerClientEvent('drp-notifications:client:SendAlert', player['source'], { type = 'inform', text = 'Paycheck Collected.', length = 5000 })
                        end)
                    else
                        TriggerClientEvent('drp-notifications:client:SendAlert', player['source'], { type = 'inform', text = 'You have nothing to collect.', length = 5000 })
                    end
                    exports.oxmysql:executeSync('UPDATE `users` SET paycheck = 0 WHERE id=:id', { id = player['cid'] })
                end
            end)
        end
    end)
end)

-- OLD
-- RegisterNetEvent('echorp:updatejob')
-- AddEventHandler('echorp:updatejob', function(job, grade, target, src)
--     local grade = tonumber(grade)
--     if grade == nil or grade == 0 then grade = 1 end
--     if target == nil and source ~= nil then target = source end;
--     local info = Players[tonumber(target)]
--     if info then
--         if Jobs[job] then
--             if Jobs[job]['grades'][grade] then
--                 local isPolice = false
--                 if policeJobs[job] then isPolice = true end;
--                 SetPlayerData(info.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice})
--                 exports.oxmysql:executeSync("UPDATE users SET job=@job, job_grade=@job_grade WHERE id=@cid", {['@job'] = job, ['@job_grade'] = grade, ['@cid'] = info.cid})
--                 if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Job Set', length = 5000 }) end
--             else
--                 if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job grade does not exist!', length = 5000 }) end
--             end 
--         else
--             if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job does not exist!', length = 5000 }) end
--         end 
--     else
--         if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This person does not exist!', length = 5000 }) end
--     end 
-- end)

-- NEW
RegisterNetEvent('echorp:updatejob')
AddEventHandler('echorp:updatejob', function(type, job, grade, cid, src)
    local src = src or source
    local grade = tonumber(grade)
    if grade == nil or grade == 0 then grade = 1 end
    local valid = exports['drp']:DoesCidExist(cid)
    if valid then
        local player = exports['drp']:GetPlayerFromCid(cid)
        if player then
            if Jobs[job] then
                if Jobs[job]['grades'][grade] then
                    if type == "set" then
                        local isPolice = false
                        if policeJobs[job] then isPolice = true end;
                        SetPlayerData(player.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice})
                        exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = job, job_grade = grade, cid = player.cid})
                        if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Job Temporarly Set', length = 5000 }) end
                   
                    elseif type == "add" then
                        exports.oxmysql:fetch("SELECT * FROM user_jobs WHERE cid=:cid AND job=:job", {
                            cid = player.cid,
                            job = job
                        }, function(jobs)
                            if jobs then
                                exports.oxmysql:executeSync("UPDATE user_jobs SET job_grade=:job_grade WHERE cid=:cid AND job=:job", {job = job, job_grade = grade, cid = player.cid})
                                if player.job.name == job then SetPlayerData(player.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice}) exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", { job = job, job_grade = grade, cid = player.cid}) end
                                if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'success', text = 'Job updated for '..player.fullname, length = 5000 }) end
                                if player.source then TriggerClientEvent('drp-notifications:client:SendAlert', player.source, { type = 'success', text = 'Your job role has been updated for '..Jobs[job].label, length = 5000 }) end
                            else
                                exports.oxmysql:executeSync("INSERT INTO `user_jobs` (`cid`, `job`, `job_grade`) VALUES (:cid, :job, :job_grade)", {
                                    cid = player.cid,
                                    job = job,
                                    job_grade = grade
                                })
                                exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = job, job_grade = grade, cid = player.cid})
                                SetPlayerData(player.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice})
                                if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'success', text = 'Added '..player.fullname..' to '..Jobs[job].label, length = 5000 }) end
                                if player.source then TriggerClientEvent('drp-notifications:client:SendAlert', player.source, { type = 'success', text = 'You have been hired by '..Jobs[job].label, length = 5000 }) end
                            end
                        end)
                    
                    elseif type == "remove" then
                        exports.oxmysql:fetch("SELECT * FROM user_jobs WHERE cid=:cid", { cid = player.cid }, function(jobs)
                            local hasJob = false
                            for i,v in pairs(jobs) do if v.job == job then hasJob = true break end end
                            if hasJob then
                                local isPolice = false
                                if policeJobs[job] then isPolice = true end;
                                if #jobs == 1 then
                                    SetPlayerData(player.source, 'job', {name = 'unemployed', grade = 1, duty = 1, isPolice = isPolice})
                                    exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = 'unemployed', job_grade = 1, cid = player.cid})
                                elseif #jobs > 1 then
                                    for i,v in pairs(jobs) do
                                        if v.job ~= job then
                                            SetPlayerData(player.source, 'job', {name = v.job, grade = v.job_grade, duty = 0, isPolice = isPolice})
                                            exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = v.job, job_grade = v.job_grade, cid = player.cid})
                                            break
                                        end
                                    end
                                end
                                exports.oxmysql:execute("DELETE FROM user_jobs WHERE cid=:cid AND job=:job", {job = job, cid = player.cid}, function(affected)
                                    if affected then
                                        if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Removed '..player.fullname..' from '..Jobs[job].label, length = 5000 }) end
                                        if player.source then TriggerClientEvent('drp-notifications:client:SendAlert', player.source, { type = 'inform', text = 'You have been removed from '..Jobs[job].label, length = 5000 }) end
                                    end  
                                end)
                            else
                                if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'error', text = 'Player does not have this job!', length = 5000 }) end
                            end
                        end)
                    end
                else
                    if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job grade does not exist!', length = 5000 }) end
                end 
            else
                if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job does not exist!', length = 5000 }) end
            end
        else
            exports.oxmysql:fetch('SELECT `cash`, `bank`, `job`, `job_grade`, `duty`, `firstname`, `lastname`, `gender`, `phone_number`, `jail_time`, `twitterhandle` FROM `users` WHERE `id`=:id LIMIT 1', {
                id = cid
            }, function(sentInfo) 
                if sentInfo and sentInfo[1] then 
                    StarterInfo = sentInfo[1]
                    local isPolice = false
                    if policeJobs[StarterInfo['job']] == true then isPolice = true end
                    local player = { source = playerId, identifier = identifier, cid = cid, id = cid,
                        cash = tonumber(StarterInfo['cash']),
                        bank = tonumber(StarterInfo['bank']),
                        job = { name = StarterInfo['job'], grade = tonumber(StarterInfo['job_grade']), duty = tonumber(StarterInfo['duty']), isPolice = isPolice },
                        sidejob = { name = "none", label = "None" },
                        firstname = StarterInfo['firstname'],
                        lastname = StarterInfo['lastname'],
                        fullname = StarterInfo['firstname']..' '..StarterInfo['lastname'],
                        gender = StarterInfo['gender'],
                        phone_number = StarterInfo['phone_number'],
                        jail_time = StarterInfo['jail_time'],
                        twitterhandle = StarterInfo['twitterhandle'],
                    }
                    if player then
                        if Jobs[job] then
                            if Jobs[job]['grades'][grade] then
                                if type == "set" then
                                    local isPolice = false
                                    if policeJobs[job] then isPolice = true end;
                                    SetPlayerData(player.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice})
                                    exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", { job = job, job_grade = grade, cid = player.cid})
                                    if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Job Temporarly Set', length = 5000 }) end
                                
                                elseif type == "add" then
                                    exports.oxmysql:fetch("SELECT * FROM user_jobs WHERE cid=:cid AND job=:job", {
                                        cid = player.cid,
                                        job = job
                                    }, function(jobs)
                                        if jobs then
                                            exports.oxmysql:executeSync("UPDATE user_jobs SET job_grade=:job_grade WHERE cid=:cid AND job=:job", {job = job, job_grade = grade, cid = player.cid})
                                            exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = job, job_grade = grade, cid = player.cid})
                                            if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'success', text = 'Job updated for player', length = 5000 }) end
                                        else
                                            exports.oxmysql:executeSync("INSERT INTO `user_jobs` (`cid`, `job`, `job_grade`) VALUES (:cid, :job, :job_grade)", {
                                                cid = player.cid,
                                                job = job,
                                                job_grade = grade
                                            })
                                            exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = job, job_grade = grade, cid = player.cid})
                                            SetPlayerData(player.source, 'job', {name = job, grade = grade, duty = 1, isPolice = isPolice})
                                            if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'success', text = 'Job added for player', length = 5000 }) end
                                        end
                                    end)
                                
                                elseif type == "remove" then
                                    exports.oxmysql:fetch("SELECT * FROM user_jobs WHERE cid=:cid", { cid = player.cid }, function(jobs)
                                        local hasJob = false
                                        for i,v in pairs(jobs) do if v.job == job then hasJob = true break end end
                                        if hasJob then
                                            local isPolice = false
                                            if policeJobs[job] then isPolice = true end;
                                            if #jobs == 1 then
                                                exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = 'unemployed', job_grade = 1, cid = player.cid})
                                            elseif #jobs > 1 then
                                                for i,v in pairs(jobs) do
                                                    if v.job ~= job then
                                                        exports.oxmysql:executeSync("UPDATE users SET job=:job, job_grade=:job_grade WHERE id=:cid", {job = v.job, job_grade = v.job_grade, cid = player.cid})
                                                        break
                                                    end
                                                end
                                            end
                                            exports.oxmysql:execute("DELETE FROM user_jobs WHERE cid=:cid AND job=:job", {job = job, cid = player.cid}, function(affected)
                                                if affected then
                                                    if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'Job removed for player', length = 5000 }) end
                                                end  
                                            end)
                                        else
                                            if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'error', text = 'Player does not have this job!', length = 5000 }) end
                                        end
                                    end)
                                end
                            else
                                if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job grade does not exist!', length = 5000 }) end
                            end 
                        else
                            if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This job does not exist!', length = 5000 }) end
                        end
                    end
                end
            end)
        end
    else
        if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'inform', text = 'This person does not exist!', length = 5000 }) end
    end 
end)

RegisterCommand("setjob", function(source, args, rawCommand) -- /setjob <CID> <job> <job_grade>
    local source = source
	if IsPlayerAceAllowed(source, 'echorp.mod') then 
		TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'error', text = 'Please use /addjob', length = 5000 })
    end
end)

RegisterCommand("addjob", function(source, args, rawCommand) -- /addjob <CID> <job> <job_grade>
    local source = source
	if IsPlayerAceAllowed(source, 'echorp.mod') then 
		if tonumber(args[1]) and args[2] and tonumber(args[3]) then
            local valid = exports['drp']:DoesCidExist(args[1])
            if valid then
                TriggerEvent('echorp:updatejob', "add", args[2], args[3], args[1], source)
            end
        end 
    end
end)

RegisterCommand("removejob", function(source, args, rawCommand) -- /removejob <CID> <job>
    local source = source
	if IsPlayerAceAllowed(source, 'echorp.mod') then 
		if tonumber(args[1]) and args[2] then
            local valid = exports['drp']:DoesCidExist(args[1])
            if valid then
                TriggerEvent('echorp:updatejob', "remove", args[2], "1", args[1], source)
            end
        end 
    end
end)

RegisterCommand("viewjobs", function(source, args, rawCommand) -- /viewjobs <cid>
    local source = source
	if IsPlayerAceAllowed(source, 'echorp.mod') then 
		if tonumber(args[1]) then
            local valid = exports['drp']:DoesCidExist(args[1])
            if valid then
                local cid = args[1]
                exports.oxmysql:fetch("SELECT * FROM user_jobs WHERE cid=:cid", { cid = cid }, function(jobs)
                    if jobs then
                        local output = "Player Jobs:</br>"
                        output = output.."<hr>"
                        for i,v in pairs(jobs) do
                            output = output..v.job..' ('..v.job_grade..')</br>'
                        end
                        TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'success', text = output, length = 8000 })
                    else
                        if src then TriggerClientEvent('drp-notifications:client:SendAlert', src, { type = 'error', text = 'Player does not have any jobs!', length = 5000 }) end
                    end
                end)
            end
        end 
    end
end)

AddEventHandler('echorp:toggleduty', function(source)
    local player = GetPlayerFromId(source)
    if player then
        if player.job then 
            if player.job.duty == 0 then 
                player.job.duty = 1 -- Setting them on duty
            elseif player.job.duty == 1 then 
                player.job.duty = 0 -- Setting them off duty.
            end
            local isPolice = false
            if policeJobs[player.job.name] then isPolice = true end;
            SetPlayerData(player.source, 'job', {name = player.job.name, grade = player.job.grade, duty = player.job.duty, isPolice = isPolice})
            exports.oxmysql:executeSync("UPDATE users SET duty=:duty WHERE id=:cid", {duty = player.job.duty, cid = player.cid})
            notifyDuty(player,"toggle")
        end
    end
end)

RegisterNetEvent('echorp:notityDuty')
AddEventHandler('echorp:notifyDuty', function(ply, status)
    local player = exports['drp']:GetPlayerFromCid(tonumber(ply.cid))
    notifyDuty(player,status)
end)

local webhook_police = ""
local webhook_ems = ""

function notifyDuty(player,status)
    local timestamp = os.date("%x %H:%M EST")
    if status == "toggle" then
        if policeJobs[player.job.name] then
            if player.job.duty == 0 then 
                updateShifts(player.cid,"finish")
                updateShifts(player.cid,"diff")
                diff = shifts[player.cid]["diff"] or "N/A"
                --exports[drp_adminmenu']:sendToDiscord('Police Logging', 'The following person is showing 10-42 **(CLOCKED OUT)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**\n\nShift Length: **'..diff..' Hours**', "16711680", webhook_police)
            elseif player.job.duty == 1 then 
                updateShifts(player.cid,"start")
                --exports[drp_adminmenu']:sendToDiscord('Police Logging', 'The following person is showing 10-41 **(CLOCKED IN)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**', "1834841", webhook_police)
            end 
        end
        if player.job.name == "ambulance" then
            if player.job.duty == 0 then
                updateShifts(player.cid,"finish")
                updateShifts(player.cid,"diff")
                diff = shifts[player.cid]["diff"] or "N/A"
                --exports[drp_adminmenu']:sendToDiscord('EMS Logging', 'The following person is showing 10-42 **(CLOCKED OUT)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**\n\nShift Length: **'..diff..' Hours**', "16711680", webhook_ems)

            elseif player.job.duty == 1 then
                updateShifts(player.cid,"start")
                --exports[drp_adminmenu']:sendToDiscord('EMS Logging', 'The following person is showing 10-41 **(CLOCKED IN)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**', "1834841", webhook_ems)
            end 
        end
    elseif status == "drop" then
        if policeJobs[player.job.name] then
            if player.job.duty == 1 then 
                updateShifts(player.cid,"finish")
                updateShifts(player.cid,"diff")
                diff = shifts[player.cid]["diff"] or "N/A"
                --exports[drp_adminmenu']:sendToDiscord('Police Logging', 'The following person is showing 10-42 **(DISCONNECTED)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**\n\nShift Length: **'..diff..' Hours**', "16711680", webhook_police)
            end 
        end
        if player.job.name == "ambulance" then
            if player.job.duty == 1 then
                updateShifts(player.cid,"finish")
                updateShifts(player.cid,"diff")
                diff = shifts[player.cid]["diff"] or "N/A"
                --exports[drp_adminmenu']:sendToDiscord('EMS Logging', 'The following person is showing 10-42 **(DISCONNECTED)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**\n\nShift Length: **'..diff..' Hours**', "16711680", webhook_ems)
            end 
        end
    elseif status == "join" then
        if policeJobs[player.job.name] then
            if player.job.duty == 1 then 
                updateShifts(player.cid,"start")
                --exports[drp_adminmenu']:sendToDiscord('Police Logging', 'The following person is showing 10-41 **(CONNECTED)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**', "1834841", webhook_police)
            end 
        end
        if player.job.name == "ambulance" then
            if player.job.duty == 1 then
                updateShifts(player.cid,"start")
                --exports[drp_adminmenu']:sendToDiscord('EMS Logging', 'The following person is showing 10-41 **(CONNECTED)**\n\nID: **'..player.id..'**\nName: **'..player.fullname..'**\nTime: **'..timestamp..'**', "1834841", webhook_ems)
            end 
        end
    end
end

RegisterCommand("toggleduty", function(source, args, rawCommand)
    local player = GetPlayerFromId(source)
    if player then
        if player.job then
            if player.job.name == "ambulance" and player.job.duty == 0 then
                local mzDist = #(GetEntityCoords(GetPlayerPed(source)) - vector3(-475.15, -314.0, 62.15))
                if mzDist > 100 then TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'error', text = 'You must be at Mount Zonah to clock in', length = 5000 }) return end
            end
            if player.job.duty == 0 then 
                TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'success', text = 'You are now on duty!', length = 5000 })
                player.job.duty = 1 -- Setting them on duty
            elseif player.job.duty == 1 then 
                TriggerClientEvent('drp-notifications:client:SendAlert', source, { type = 'error', text = 'You are now off duty!', length = 5000 })
                player.job.duty = 0 -- Setting them off duty.
            end 
            local isPolice = false
            if policeJobs[player.job.name] then isPolice = true end;
            SetPlayerData(player.source, 'job', {name = player.job.name, grade = player.job.grade, duty = player.job.duty , isPolice = isPolice})
            exports.oxmysql:executeSync("UPDATE users SET duty=:duty WHERE id=:cid", {duty = player.job.duty, cid = player.cid})
            Wait(100)
            notifyDuty(player,"toggle")
        end
    end
end)

function updateShifts(cid,type)
    local cid = cid
    local type = type
    if not shifts[cid] then shifts[cid] = {} end
    if shifts[cid] and type ~= "diff" then
        if type == 'start' then shifts[cid] = {} shifts[cid][type] = os.time() else shifts[cid][type] = os.time() end
    end
    if shifts[cid] and type == "diff" then
        if shifts[cid]['start'] and shifts[cid]['finish'] then
            shifts[cid][type] = string.format("%.2f",(os.difftime(shifts[cid]['finish'],shifts[cid]['start'])/ 3600))
            return shifts[cid][type]
        end
    end
end