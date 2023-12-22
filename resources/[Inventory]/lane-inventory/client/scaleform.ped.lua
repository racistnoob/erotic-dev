clonedPed = nil 

Scaleform = {
    Showing = false
}

function Scaleform.Show()
    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_JOINING_SCREEN"), true, -1)
    Citizen.Wait(100)
    N_0x98215325a695e78a(false)
    clonedPed = ClonePed(PlayerPedId(), 0, false, false)
    SetEntityCoords(clonedPed, 0.0, 0.0, 0.0)
    SetEntityVisible(clonedPed, false)
    NetworkSetEntityInvisibleToNetwork(clonedPed, true)
    FreezeEntityPosition(clonedPed, true)
    N_0x4668d80430d6c299(clonedPed)
    GivePedToPauseMenu(clonedPed, 6)
    SetPauseMenuPedLighting(true)
    SetPauseMenuPedSleepState(true)
    RequestScaleformMovie("PAUSE_MP_MENU_PLAYER_MODEL")
    Scaleform.Showing = true 
end



function Scaleform.Hide()
    EndScaleformMovieMethod()
    SetScaleformMovieAsNoLongerNeeded()
    SetFrontendActive(false)
    DeletePed(clonedPed)
    N_0x98215325a695e78a(false)
    clonedPed = nil 
    Scaleform.Showing = false
end


function Scaleform.Cursor()
    CreateThread(function()
    while inventoryOpened do 
        N_0x98215325a695e78a(false)
        Wait(1)
    end end)
end

