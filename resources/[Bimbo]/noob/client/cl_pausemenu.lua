Config = Config or {}

Config.RGBA = {
    LINE = { -- Line over the Options
        ["RED"] = 144,
        ["GREEN"] = 138,
        ["BLUE"] = 255,
        ["ALPHA"] = 255,
    }
}

local open = false
RegisterCommand('pausemenu', function()
    Wait(250)
    if (IsPauseMenuActive() or IsPauseMenuRestarting()) and not open then
        repeat
            open = true
            SetScriptGfxDrawBehindPausemenu(true)
            DrawSprite("ps_pause", "background", 0.5, 0.5, 1.0, 1.0, 0, 255, 230, 255, 100)
            Wait(3)
        until not IsPauseMenuActive()
        open = false
        SetStreamedTextureDictAsNoLongerNeeded('ps_pause')
    end
end)

RegisterKeyMapping('pausemenu', 'Pause Menu', 'keyboard', 'ESCAPE')

CreateThread(function()
    AddTextEntry("FE_THDR_GTAO", "Erotic PVP")
        
    RequestStreamedTextureDict('pause', true)

    ReplaceHudColourWithRgba(116, 144, 138, 255, 255)

    while not HasStreamedTextureDictLoaded("pause") do
        Wait(100)
    end
end)
