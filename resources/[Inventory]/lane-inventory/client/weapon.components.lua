CurrentSkin = 0
WeaponSkins = {
    [0] = "0",
    [1] = "1",
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7"
}

function ApplyWeaponSkin(ped, weaponHash, skinIndex)
    if skinIndex >= 0 and skinIndex <= 7 then
        SetPedWeaponTintIndex(ped, weaponHash, skinIndex)
    else
        SetPedWeaponTintIndex(ped, weaponHash, 0)
    end
end

function toggleWeaponSkins(skinIndex)
    if skinIndex and skinIndex >= 0 and skinIndex <= 7 then
        CurrentSkin = skinIndex
        local currentWeapon = GetSelectedPedWeapon(PlayerPedId())
        if currentWeapon ~= 2725352035 then
            ApplyWeaponComponents(currentWeaponName)
            ApplyWeaponSkin(PlayerPedId(), currentWeapon, CurrentSkin)
        end
        SetResourceKvpInt("weaponTint", CurrentSkin)
    else
        -- print("Invalid skin index. Please use a number between 0 and 7.")
    end
end

RegisterCommand("skin", function(source, args, rawCommand)
    local skinIndex = tonumber(args[1])
    toggleWeaponSkins(skinIndex)
end)

local ComponentStates = {}
for weaponName, components in pairs(WeaponComponents) do
    ComponentStates[weaponName] = {}
    for componentType in pairs(components) do
        ComponentStates[weaponName][componentType] = false
    end
end

local function SaveWeaponComponentStates(weaponName)
    if ComponentStates[weaponName] then
        local stateString = json.encode(ComponentStates[weaponName])
        SetResourceKvp(weaponName .. "_ComponentStates", stateString)
    end
end

local function toggleWeaponComponent(componentType)
    local playerPed = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(playerPed)
    local weaponName = nil

    for name, _ in pairs(WeaponComponents) do
        if GetHashKey(name) == currentWeapon then
            weaponName = name
            break
        end
    end

    if weaponName and WeaponComponents[weaponName][componentType] then
        local componentHash = GetHashKey(WeaponComponents[weaponName][componentType])
        ComponentStates[weaponName][componentType] = not ComponentStates[weaponName][componentType]

        if ComponentStates[weaponName][componentType] then
            GiveWeaponComponentToPed(playerPed, currentWeapon, componentHash)
        else
            RemoveWeaponComponentFromPed(playerPed, currentWeapon, componentHash)
        end

        SaveWeaponComponentStates(weaponName)
    end
end

function ApplyWeaponComponents(weaponName)
    local playerPed = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)

    if WeaponComponents[weaponName] then
        for componentType, componentHashStr in pairs(WeaponComponents[weaponName]) do
            if ComponentStates[weaponName][componentType] then
                local componentHash = GetHashKey(componentHashStr)
                if not HasPedGotWeaponComponent(playerPed, weaponHash, componentHash) then
                    GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
                end
            end
        end
    end
end

local uniqueComponentTypes = {}
for _, components in pairs(WeaponComponents) do
    for componentType in pairs(components) do
        uniqueComponentTypes[componentType] = true
    end
end

for componentType in pairs(uniqueComponentTypes) do
    RegisterCommand(componentType, function(source, args, rawCommand)
        toggleWeaponComponent(componentType)
        ApplyWeaponComponents(currentWeaponName)
    end)
end

local function LoadWeaponComponentStates(weaponName)
    local stateString = GetResourceKvpString(weaponName .. "_ComponentStates")
    if stateString then
        ComponentStates[weaponName] = json.decode(stateString)
    end
end

RegisterNetEvent("Inv:load:components")
AddEventHandler("Inv:load:components", function()
    for weaponName in pairs(WeaponComponents) do
        LoadWeaponComponentStates(weaponName)
    end
    toggleWeaponSkins(GetResourceKvpInt("weaponTint"))
end)

local function WipeWeaponKVPs()
    for weaponName in pairs(WeaponComponents) do
        DeleteResourceKvp(weaponName .. "_ComponentStates")
        -- For Future Development
        -- DeleteResourceKvp(weaponName .. "_SkinState")
    end

    for weaponName, components in pairs(WeaponComponents) do
        ComponentStates[weaponName] = {}
        for componentType in pairs(components) do
            ComponentStates[weaponName][componentType] = false
        end
    end

    for weaponName in pairs(WeaponComponents) do
        CurrentSkin = 0
    end
    SendNotification({
        text = "~r~~h~Wiped Settings.",
        type = 'bottomLeft',
        timeout = 6000,
    })
end

RegisterCommand("reset", function(source, args, rawCommand)
    WipeWeaponKVPs()
end)
