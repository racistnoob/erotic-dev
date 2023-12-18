KVP = {}

function KVP:GetString(key, defaultValue)
    local storedString = GetResourceKvpString(key)
    if not storedString then
        storedString = defaultValue
    end
    return storedString
end

function KVP:SetString(key, value)
    SetResourceKvp(key, value)
end

function KVP:GetFloat(key, defaultValue)
    local storedFloat = GetResourceKvpFloat(key)
    if not storedFloat then
        storedFloat = defaultValue
    end
    return storedFloat
end

function KVP:SetFloat(key, value)
    SetResourceKvpFloat(key, value)
end

function KVP:GetInt(key, defaultValue)
    local storedInt = GetResourceKvpInt(key)
    if not storedInt then
        storedInt = defaultValue
    end
    return storedInt
end

function KVP:SetInt(key, value)
    SetResourceKvpInt(key, value)
end
