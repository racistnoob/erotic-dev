local playingEmote = false

loadAnimation = function(d)
    while (not HasAnimDictLoaded(d)) do
        RequestAnimDict(d)
        Citizen.Wait(5)
    end
end

RegisterCommand('p', function(src, args, raw)
    emoteCommandHandler(src, args, raw)
end )

emoteCommandHandler = function(src, args, raw)
    if (#args <= 0 ) then return end
    local animName = string.lower(args[1])

    if (animName == 'c') then
        ClearPedTasks(PlayerPedId())
        playingEmote = false
    end

    
    ClearPedTasks(PlayerPedId())
    loadAnimation(erpEmotes[animName].dict)

    if (erpEmotes[animName].options.noGun and IsPedArmed(PlayerPedId(), 4)) then
        SetCurrentPedWeapon(PlayerPedId(), 0xA2719263, true)
    end

    if (erpEmotes[animName]) then
        if (erpEmotes[animName].options.animDuration == nil) then
            animLength = -1
        else
            animLength = erpEmotes[animName].options.animDuration
        end

        local emoteFlag = 0
        if (erpEmotes[animName].options.walkingEmote) then
            emoteFlag = 51
        elseif (erpEmotes[animName].options.loopedEmote) then
            emoteFlag = 1
        end

        TaskPlayAnim(PlayerPedId(), erpEmotes[animName].dict, erpEmotes[animName].anim, 2.0, 2.0, animLength, emoteFlag, false, false, false)
    end
end