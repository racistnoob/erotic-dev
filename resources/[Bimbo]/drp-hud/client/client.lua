local HUD = {
    isOpen = false,
    healthHud = false,
    carHud = false,
    plyPed = false,
    plyVehicle = 0,
    inventoryActive = true,
    blackbars = false,
    compassActive = false,
    carhudPos = 'center',
    carControls = false,

    ToggleNui = function(self, open)
        self.isOpen = open
        SendReactMessage('setVisible', open)
        DisplayRadar(open)
    end,

    GetMinimapPosition = function(self)
        local minimap = {}

        local resX, resY = GetActiveScreenResolution()

        local aspectRatio = GetAspectRatio()    

        local scaleX = 1 / resX
        local scaleY = 1 / resY

        local minimapRawX, minimapRawY

        SetScriptGfxAlign(string.byte('L'), string.byte('B'))

        if IsBigmapActive() then
            minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
            minimap.width = scaleX * (resX / (2.52 * aspectRatio))
            minimap.height = scaleY * (resY / (2.3374))
        else
            minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
            minimap.width = scaleX * (resX / (4 * aspectRatio))
            minimap.height = scaleY * (resY / (5.674))
        end

        ResetScriptGfxAlign()

        minimap.rightX = minimapRawX + minimap.width
        minimap.bottomY = minimapRawY + minimap.height

        return minimap
    end,

    PlayerId = 0,

    InfoThread = function(self)
        self.PlayerId = PlayerId()

        while true do
            Wait(1000)

            self.plyPed = PlayerPedId()
            SendReactMessage('setPauseMenu', IsPauseMenuActive() or IsScreenFadedOut() or IsScreenFadingOut() or false)
        end
    end,

    StatusThread = function(self)
        CreateThread(function()
            while true do
                Wait(250)

                local map = self:GetMinimapPosition()
                local rightX = map.rightX * 100
                local bottomY = map.bottomY * 100

                ResetPlayerStamina(PlayerId())
                SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

                RemoveMultiplayerHudCash()
                RemoveMultiplayerBankCash()

                SendReactMessage('setStatusData', {
                    health = GetEntityHealth(self.plyPed) - 100,
                    armor = GetPedArmour(self.plyPed),
                    rightX = rightX,
                    bottomY = bottomY,
                })
            end
        end)
    end,

    MovingHud = false,

    MoveHud = function(self, state)
        local newState = state or not self.MovingHud

        SetNuiFocus(newState, newState)
        SendReactMessage('setMovingHud', newState)

        self.MovingHud = newState

        if not newState then
            return
        end
    end,

}

RegisterNUICallback('stopMovingHud', function(_, cb)
    HUD:MoveHud(false)
    cb('ok')
end)

CreateThread(function()
    Wait(250)
    HUD:ToggleNui(false)
end)

CreateThread(function()
    Wait(500)
    HUD:InfoThread()
end)

CreateThread(function()
    Wait(500)
    HUD:StatusThread()
end)

exports("toggleNui", function(...)
    return HUD:ToggleNui(...)
end) -- exports['drp-hud']:toggleNui(false)

RegisterCommand("movehud", function(source, args, rawCommand)
    HUD:MoveHud(args[1])
end, false)

RegisterCommand("resethud", function(source, args, rawCommand)
    SendReactMessage('setHudPosition', { x = 0, y = 0 })
end, false)

AddEventHandler('echorp:playerSpawned', function()
    Wait(500)
    HUD:ToggleNui(true)
end)
