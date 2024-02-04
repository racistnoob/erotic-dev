local player_ped_id = PlayerPedId
local player_id = PlayerId
local wait = Wait
local display_radar = DisplayRadar
local get_active_screen_resolution = GetActiveScreenResolution
local get_aspect_ratio = GetAspectRatio
local set_script_gfx_align = SetScriptGfxAlign
local is_big_map_active = IsBigmapActive
local string_byte = string.byte
local get_script_gfx_position = GetScriptGfxPosition
local reset_script_gfx_align = ResetScriptGfxAlign
local is_pause_menu_active = IsPauseMenuActive
local is_screen_faded_out = IsScreenFadedOut
local is_screen_fading_out = IsScreenFadingOut
local reset_player_stamina = ResetPlayerStamina
local set_player_health_recharge_multiplier = SetPlayerHealthRechargeMultiplier
local remove_multiplayer_hud_cash = RemoveMultiplayerHudCash
local remove_multiplayer_bank_cash= RemoveMultiplayerBankCash
local get_entity_health = GetEntityHealth
local get_ped_armour = GetPedArmour
local set_nui_focus = SetNuiFocus

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
    
    ToggleNui = function(self, open, radar)
        self.isOpen = open
        SendReactMessage('setVisible', open)
        display_radar(open or radar)
    end,
    
    GetMinimapPosition = function(self)
        local minimap = {}
        
        local resX, resY = get_active_screen_resolution()
        
        local aspectRatio = get_aspect_ratio()    
        
        local scaleX = 1 / resX
        local scaleY = 1 / resY
        
        local minimapRawX, minimapRawY
        
        set_script_gfx_align(string_byte('L'), string_byte('B'))
        
        if is_big_map_active() then
            minimapRawX, minimapRawY = get_script_gfx_position(-0.003975, 0.022 + (-0.460416666))
            minimap.width = scaleX * (resX / (2.52 * aspectRatio))
            minimap.height = scaleY * (resY / (2.3374))
        else
            minimapRawX, minimapRawY = get_script_gfx_position(-0.0045, 0.002 + (-0.188888))
            minimap.width = scaleX * (resX / (4 * aspectRatio))
            minimap.height = scaleY * (resY / (5.674))
        end
        
        reset_script_gfx_align()
        
        minimap.rightX = minimapRawX + minimap.width
        minimap.bottomY = minimapRawY + minimap.height
        
        return minimap
    end,
    
    PlayerId = -1,
    
    InfoThread = function(self)
        self.PlayerId = player_id()
        
        while true do
            wait(1000)
            
            self.plyPed = player_ped_id()
            SendReactMessage('setPauseMenu', is_pause_menu_active() or is_screen_faded_out() or is_screen_fading_out() or false)
        end
    end,
    
    StatusThread = function(self)
        CreateThread(function()
            while true do
                wait(250)
                
                local map = self:GetMinimapPosition()
                local rightX = map.rightX * 100
                local bottomY = map.bottomY * 100
                
                reset_player_stamina(player_id())
                set_player_health_recharge_multiplier(player_id(), 0.0)
                
                remove_multiplayer_hud_cash()
                remove_multiplayer_bank_cash()
                
                SendReactMessage('setStatusData', {
                    health = get_entity_health(self.plyPed) - 100,
                    armor = get_ped_armour(self.plyPed),
                    rightX = rightX,
                    bottomY = bottomY,
                })
            end
        end)
    end,
    
    MovingHud = false,
    
    MoveHud = function(self, state)
        local newState = state or not self.MovingHud
        
        set_nui_focus(newState, newState)
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

AddEventHandler('erotic:playerSpawned', function()
    Wait(500)
    HUD:ToggleNui(true)
end)
