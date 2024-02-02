local hudColours = {
    red = 6,
    blue = 9,
    yellow = 12,
    orange = 15,
    green = 18,
    pink = 30,
    purple = 29,
    cyan = 211,
    lime = 210,
    yellow_light = 13,
    white = 0,
}

local killEffectOptions = {
    {"White Flash (Default)", "FocusOut", "white"},
    {"Red Flash", "CrossLineOut", "red"},
    {"Green Flash", "MinigameEndFranklin", "green"},
    {"Blue Flash", "MinigameEndMichael", "blue"},
    {"Yellow Flash", "HeistLocate", "yellow_light"},
    {"Cyan Flash", "MP_SmugglerCheckpoint", "cyan"},
    {"Orange Flash", "PPOrangeOut", "orange"},
    {"Lime Flash", "PPGreenOut", "lime"},
    {"Pink Flash", "PPPinkOut", "pink"},
    {"Purple Flash", "PPPurpleOut", "purple"},
    {"Pink Short Flash", "TinyRacerPinkOut", "pink"},
    {"White Long Flash", "MP_Celeb_Lose_Out", "white"},
    {"Green Long Flash", "MP_Celeb_Preload_Fade", "green"},
    {"Orange Long Flash", "MP_Celeb_Win_Out", "orange"},
    {"Yellow Long Flash", "MP_corona_switch", "yellow"},
    {"Blue Long Flash", "WeaponUpgrade", "blue"},
    {"Green Fuzzy", "DefaultFlash", "green"},
    {"Red Lightning", "LostTimeDay", "red"},
    {"Peyote", "PeyoteOut", "pink"},
    {"Rampage", "RampageOut", "red"},
}

local killEffect = {
    name = "Kill Effect",
    options = {},
    selected = GetResourceKvpInt("graphics_killEffect"),
    onChange = function(self)
        SetResourceKvpInt("graphics_killEffect", self.selected)
        playSelectedKillEffect()
    end,
    onClick = playSelectedKillEffect
}

for _, option in pairs(killEffectOptions) do
    table.insert(killEffect.options, option[1])
end

function playKillEffect(name)
    AnimpostfxStop(name)
    AnimpostfxPlay(name, 500, false)
end

function playSelectedKillEffect()
    local _, postFxName, hudColour = unpack(killEffectOptions[killEffect.selected])
    playKillEffect(postFxName)
    FlashMinimapDisplayWithColor(hudColours[hudColour])
end

-- Register a command to change the kill effect option
RegisterCommand('setkillEffect', function(source, args)
    if #args == 1 then
        local selectedEffect = tonumber(args[1])
        if selectedEffect and selectedEffect >= 1 and selectedEffect <= #killEffectOptions then
            killEffect.selected = selectedEffect
            killEffect:onChange()
        else
            TriggerClientEvent('chatMessage', source, "Invalid kill effect option.")
        end
    else
        TriggerClientEvent('chatMessage', source, "Usage: /setkillEffect <option>")
    end
end, false)

-- Command handler for displaying the available kill effect options
RegisterCommand('showkillEffects', function(source, args)
    for i, option in pairs(killEffectOptions) do
        TriggerClientEvent('chatMessage', source, i .. ": " .. option[1])
    end
end, false)