CreateThread(function()
    AddTextEntry("FE_THDR_GTAO", "Erotic PVP")      
    ReplaceHudColourWithRgba(116, 144, 138, 255, 255)
end)


local open = false
RegisterCommand('pausemenu', function()
    Wait(250)
    if (IsPauseMenuActive() or IsPauseMenuRestarting()) and not open then
        repeat
            open = true
            SetScriptGfxDrawBehindPausemenu(true)
            DrawSprite("", "", 0.5, 0.5, 1.0, 1.0, 0, 144, 138, 255, 100)
            Wait(3)
        until not IsPauseMenuActive()
        open = false
    end
end, false)

RegisterKeyMapping('pausemenu', 'Pause Menu', 'keyboard', 'ESCAPE')