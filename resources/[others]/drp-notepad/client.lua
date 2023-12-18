local isUiOpen, object, TestLocalTable = false, 0, {}

--[[ NUI ]]

RegisterNUICallback('escape', function(data, cb)
    local text = data.text
    TriggerEvent("drp-notepad:CloseNotepad")
    cb('ok')
end)

RegisterNUICallback('dropping', function(data, cb)
    local text = data.text
    TriggerServerEvent("drp-notepad:server:newNote", text)
    TriggerEvent("drp-notepad:CloseNotepad")
    cb('ok')
end)

--[[ Events ]]

RegisterNetEvent("drp-notepad:OpenNotepadGui")
AddEventHandler("drp-notepad:OpenNotepadGui", function() if not isUiOpen then openGui() end end)

RegisterNetEvent('drp-notepad:updateNotes')
AddEventHandler('drp-notepad:updateNotes', function(serverNotesPassed) TestLocalTable = serverNotesPassed end)

RegisterNetEvent("drp-notepad:CloseNotepad")
AddEventHandler("drp-notepad:CloseNotepad", function()
    SendNUIMessage({ action = 'closeNotepad' })
    SetPlayerControl(PlayerId(), 1, 0)
    isUiOpen = false
    SetNuiFocus(false, false)
    TaskPlayAnim(player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Wait(100)
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(prop, 1, 1)
    DeleteObject(prop)
    DetachEntity(secondaryprop, 1, 1)
    DeleteObject(secondaryprop)
end)

RegisterNetEvent('drp-notepad:note')
AddEventHandler('drp-notepad:note', function()
    local player = PlayerPedId()
    local ad = "missheistdockssetup1clipboard@base"  
    local prop_name = prop_name or 'prop_notepad_01'
    local secondaryprop_name = secondaryprop_name or 'prop_pencil_01'
    
    if (DoesEntityExist(player) and not LocalPlayer.state.dead) then 
        loadAnimDict(ad)
        if (IsEntityPlayingAnim(player, ad, "base", 3)) then 
            TaskPlayAnim(player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            Wait(100)
            ClearPedSecondaryTask(PlayerPedId())
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DetachEntity(secondaryprop, 1, 1)
            DeleteObject(secondaryprop)
        else
            local x,y,z = table.unpack(GetEntityCoords(player))
            prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
            secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true) -- drp-notepadpad
            AttachEntityToEntity(secondaryprop, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true) -- pencil
            TaskPlayAnim(player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        end     
    end
end)

--[[ Functions ]]

function openGui() 
    local veh = GetVehiclePedIsUsing(PlayerPedId())  
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then
        TriggerEvent('drp-notepad:note')
        SetPlayerControl(PlayerId(), 0, 0)
        SendNUIMessage({ action = 'openNotepad' }) 
        isUiOpen = true 
        SetNuiFocus(true, true)
    end
end

function openGuiRead(text)
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then
        SetPlayerControl(PlayerId(), 0, 0) TriggerEvent("drp-notepad:note") isUiOpen = true SendNUIMessage({ action = 'openNotepadRead', TextRead = text }) SetNuiFocus(true, true)
    end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function loadAnimDict(dict) while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Wait(5) end end

local tableSize, coords = 0, vec3(0, 0, 0)

CreateThread(function()
    while true do
        tableSize = #TestLocalTable
        if tableSize > 0 then
            coords = GetEntityCoords(PlayerPedId())
        end
        Wait(1000)
    end
end)

--[[ Thread ]]

CreateThread(function()
    while true do 
        Wait(0)
        if tableSize > 0 then
            local closestNoteDistance = 900.0
            local closestNoteId = 0
            for i=1, #TestLocalTable do
                local dist = #(TestLocalTable[i]['coords'] - coords)
                if dist < 5.0 then
                    DrawMarker(27, TestLocalTable[i]['coords']['x'],TestLocalTable[i]['coords']['y'],TestLocalTable[i]['coords']['z']-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 2.0, 255, 255,150, 75, 0, 0, 2, 0, 0, 0, 0)
                end
                if dist < closestNoteDistance then
                    closestNoteDistance = dist
                    closestNoteId = i
                end
            end

            if closestNoteDistance > 10.0 then Wait(1000) end

            if TestLocalTable[closestNoteId] then
                local dist = closestNoteDistance
                if dist < 2.5 then
                    DrawText3Ds(TestLocalTable[closestNoteId]['coords']['x'],TestLocalTable[closestNoteId]['coords']['y'],TestLocalTable[closestNoteId]['coords']['z']-0.5, "~g~E~s~ to read,~g~G~s~ to destroy")
                    if IsControlJustReleased(0, 38) then
                        openGuiRead(TestLocalTable[closestNoteId]["text"])
                    end
                    if IsControlJustReleased(0, 47) then
                        TriggerServerEvent("drp-notepad:server:destroyNote",closestNoteId)
                        table.remove(TestLocalTable,closestNoteId)
                    end
                end
            else
                Wait(500)
            end
        else
            Wait(500)
        end
    end  
end)