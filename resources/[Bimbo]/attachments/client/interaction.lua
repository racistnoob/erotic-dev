local inZone = false
CreateThread(function()
    exports["noob"]:AddBoxZone(
        "weaponbench",
        vector3(241, -1391.5, 29.5600624),
        2.0, 
        2.0, 
        {
            heading = -196,
            scale={1.0, 1.0, 1.0},
            minZ = 29,
            maxZ = 32,
        }
    )
end)

local wait = Wait
local is_control_just_released = IsControlJustReleased
local function interaction()
    Citizen.CreateThread(function()
        while inZone do
            if not isOpen then
                if is_control_just_released(0, 38) then
                    exports['prompts']:hidePrompt()
                    TriggerEvent("erp-weaponbench:openMenu", {
                        editCoords = vec4(241, -1391.5, 29.5600624+1.2, -196)
                    })
                end
            end
            wait()
        end
    end)
end

AddEventHandler("polyzone:enter", function(name)
    if name == "weaponbench" then
        inZone = true
        exports['prompts']:hidePrompt()
        Wait(100)

        exports['prompts']:showPrompt({
            pressText = "Press E",
            text = "to use the bench"
        })            
        interaction()
    end
end)

AddEventHandler("polyzone:exit", function(name)
    if name == "weaponbench" then
        inZone = false
        exports['prompts']:hidePrompt()
    end
end)