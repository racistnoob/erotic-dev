LocalPlayer.state.radioOpen = false

local function updateRadio()
    SendNUIMessage({ action = 'channel', data = LocalPlayer.state.radioChannel })
    SendNUIMessage({ action = 'volume', data = exports['pma-voice']:getRadioVolume() * 100 })
    SendNUIMessage({ action = 'enabled', data = exports['pma-voice']:getRadioEnabled() })
end

local function leaveRadio(hidden)
    local savedChannel = LocalPlayer.state.radioChannel
    if not hidden and savedChannel and savedChannel > 0 then
        exports['drp-notifications']:SendAlert('inform', ('Disconnected from frequency %s MHz'):format(savedChannel), 1500)
    end

    exports["pma-voice"]:setRadioChannel(0)
    Wait(250)
    updateRadio()
end

local function connectRadio(channel)
    if channel >= 1000 then
        return exports['drp-notifications']:SendAlert('error', 'Unable to connect to this frequency, try something below 1000MHz', 2500)
    end

    local channelString = tostring(channel)
    if channelString:find('%.') then
        return exports['drp-notifications']:SendAlert('error', 'Unable to connect to this frequency, try a whole number', 2500)
    end

    local savedChannel = LocalPlayer.state.radioChannel
    if channel == savedChannel then return end

    if channel <= 0 then
        return leaveRadio()
    end

    exports["pma-voice"]:setVoiceProperty("radioEnabled", true)

    if channel ~= 111 then
        local worldID = tostring(exports['erotic-lobby']:getCurrentWorld())
        channel = tonumber(worldID.."."..channelString)
    end
    exports["pma-voice"]:setRadioChannel(channel)

    Wait(100)
    exports['drp-notifications']:SendAlert('inform', ('Connected to %s MHz'):format(LocalPlayer.state.radioChannel), 1500)
    Wait(250)
    updateRadio()
end

local function openRadio()
    LocalPlayer.state.radioOpen = not LocalPlayer.state.radioOpen

    SetNuiFocus(LocalPlayer.state.radioOpen, LocalPlayer.state.radioOpen)

    updateRadio()
    SendNUIMessage({action = LocalPlayer.state.radioOpen and 'open' or 'close'})
end
exports('openRadio', openRadio)
RegisterNetEvent('erp-radio:openRadio', openRadio)

RegisterNUICallback('joinradio', function(data)
    connectRadio( tonumber(data.channel) )
end)

RegisterNUICallback('togglePower', function()
    local newEnabled = not exports['pma-voice']:getRadioEnabled()

    exports["pma-voice"]:setVoiceProperty("radioEnabled", newEnabled)

    if newEnabled then
        Wait(240)
    else
        local savedChannel = LocalPlayer.state.radioChannel
        if savedChannel and savedChannel > 0 then
            exports['drp-notifications']:SendAlert('inform', ('Disconnected from frequency %s MHz'):format(savedChannel), 1500)
        end      
        exports["pma-voice"]:setRadioChannel(0)
    end

    Wait(newEnabled and 500 or 100)
    updateRadio()
end)

RegisterNUICallback('closeradio', function()
    LocalPlayer.state.radioOpen = false
    SetNuiFocus(LocalPlayer.state.radioOpen, LocalPlayer.state.radioOpen)
end)

RegisterNUICallback('leaveradio', function()
    leaveRadio()
end)

RegisterNUICallback('updatevolume', function(data)
    exports['pma-voice']:setRadioVolume(tonumber(data.vol))
    updateRadio()
end)

exports('changeradio', function(channel) 
    if tonumber(channel) ~= 0 then
        connectRadio(tonumber(channel))
    else
        leaveRadio(true)
    end
end)

RegisterCommand("radio", function(source, args)
    if args and not args[1] or not args then
        TriggerEvent('erp-radio:openRadio')
        return
    end

    local channel = tonumber(args[1])

    if tonumber(channel) ~= 0 then
        connectRadio(tonumber(channel))
    else
        leaveRadio()
    end
end, false)

RegisterKeyMapping("radio", "Radio UI", "keyboard", "I")