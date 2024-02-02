local debug = false
local comboZone = nil
local createdZones = {}
local polyZones = {}

local function addToComboZone(zone)
    if comboZone ~= nil then
        comboZone:AddZone(zone)
    else
        comboZone = ComboZone:Create({ zone }, { name = 'polyzone' })
        comboZone:onPlayerInOutExhaustive(function(isPointInside, point, insideZones, enteredZones, leftZones)
            if leftZones ~= nil then
                for i = 1, #leftZones do
                    TriggerEvent('polyzone:exit', leftZones[i].name)
                end
            end
            if enteredZones ~= nil then
                for i = 1, #enteredZones do
                    TriggerEvent('polyzone:enter', enteredZones[i].name, enteredZones[i].data,
                        enteredZones[i].center)
                end
            end
        end, 100)
    end
end

local function doCreateZone(options)
    if options.data and options.data.id then
        local key = options.name .. '_' .. tostring(options.data.id)
        if not createdZones[key] then
            createdZones[key] = true
            return true
        else
            return false
        end
    end
    return true
end

exports('AddBoxZone', function(name, vectors, length, width, options)
    if not options then options = {} end
    options.name = name
    options.debugPoly = debug or options.debugPoly
    if not doCreateZone(options) then return end
    local boxCenter = type(vectors) ~= 'vector3' and vector3(vectors.x, vectors.y, vectors.z) or vectors

    local zone = BoxZone:Create(boxCenter, length, width, options)
    addToComboZone(zone)
    Citizen.Wait(2500)
    return zone
end)

exports('AddPolyZone', function(name, vectors, options)
    if not options then options = {} end
    options.name = name
    options.debugPoly = debug or options.debugPoly
    if not doCreateZone(options) then return end

    local points = {}
    for k, v in pairs(vectors) do
        points[k] = vector2(v.x, v.y)
    end

    local zone = PolyZone:Create(points, options)
    polyZones[name] = zone
    addToComboZone(zone)
end)
