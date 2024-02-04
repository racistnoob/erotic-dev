config = {}

config.weather = {
    StartWeather = GetConvar("core_startingWeather", "EXTRASUNNY"),
    BaseTime = 8,
    TimeOffset = 0,
    FreezeTime = false,
}

local Weathers = {
  ["neonsky"] = "FOGGY",
  ["redsky"] = "OVERCAST",
  ["noday"] = "NEUTRAL",
  ["variable"] = "SMOG",
  ["greysky"] = "CLEAR",
  ["default"] = "EXTRASUNNY",
  ["sunrise"] = "CLOUDS",
  ["realism"] = "CLEARING",
  ["xmas"] = "XMAS",
  ["snow"] = "SNOWLIGHT",
  ["blizzard"] = "BLIZZARD",
}

local weather = "EXTRASUNNY"
local baseTime = config.weather.BaseTime
local timeOffset = config.weather.TimeOffset
local timer = 0
local freezeTime = config.weather.FreezeTime
local runTimeSync = true
local overrideTime = { 12, 00 }

function setWeather(newWeather) -- Define the setWeather function
    if not newWeather then
        weather = "EXTRASUNNY"
        return
    end

    weather = newWeather
end


exports("getWeather", function()
    return weather
end)

local clear_override_weather = ClearOverrideWeather
local clear_weather_type_persist = ClearWeatherTypePersist
local set_weather_type_persist = SetWeatherTypePersist
local set_weather_type_now = SetWeatherTypeNow
local set_weather_type_now_persist = SetWeatherTypeNowPersist
local set_force_vehicle_trails = SetForceVehicleTrails
local set_force_ped_footsteps_track = SetForcePedFootstepsTracks
local wait = Wait

CreateThread(function()
    while true do
        wait(1000)
        clear_override_weather()
        clear_weather_type_persist()
        set_weather_type_persist(weather)
        set_weather_type_now(weather)
        set_weather_type_now_persist(weather)

        set_force_vehicle_trails(weather == 'XMAS')
        set_force_ped_footsteps_track(weather == 'XMAS')
    end
end)

function ChangeWeather(customName)
  local selectedWeather = Weathers[customName]
  
  if selectedWeather then
      setWeather(selectedWeather)
      print("Weather changed to:", selectedWeather)
  else
      print("Invalid weather name:", customName)
  end
end

RegisterNetEvent('set-weather')
AddEventHandler('set-weather', function(params)
    local customName = params.type
    local selectedWeather = Weathers[customName]
    
    if selectedWeather then
        SetResourceKvp("graphics_weather", customName)
        print('KVP loaded:', customName)
        ChangeWeather(customName)
    else
        print("Invalid weather type.")
    end
end)

AddEventHandler('erotic:playerSpawned', function()
    local kvpValue = GetResourceKvpString("graphics_weather")
        
    if kvpValue then
        print('KVP loaded:', kvpValue)
        ChangeWeather(kvpValue)
    else
        print("Player does not have KVP.")
    end
end)

--[[AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local kvpValue = GetResourceKvpString("graphics_weather")
            
        if kvpValue then
            print("Resource started. Player has KVP:", kvpValue)
            print('KVP loaded:', kvpValue)
            ChangeWeather(kvpValue)
        else
            print("Resource started. Player does not have KVP.")
        end
    end
end)]]
  
local submenu = {
  {
      id = 1,
      header = "< Go Back",
      txt = "",
      params = {
          event = "erp-context:GoBackToMainMenu"
      }
  },
  {
      id = 2,
      header = "Default",
      txt = "Set the weather to default",
      params = {
          event = "set-weather",
          args = {
                type = "default",
                number = 1,
                id = 2
          }
      }
  },
  {
      id = 3,
      header = "Red Sky",
      txt = "Set the weather to redsky",
      params = {
          event = "set-weather",
          args = {
                type = "redsky",
                number = 2,
                id = 3
          }
      }
  },
  {
      id = 4,
      header = "Neon Sky",
      txt = "Set the weather to Neon",
      params = {
          event = "set-weather",
          args = {
                type = "neonsky",
                number = 3,
                id = 4
          }
      }
  },
  {
      id = 5,
      header = "No Day",
      txt = "Set the weather to no day",
      params = {
          event = "set-weather",
          args = {
                type = "noday",
                number = 4,
                id = 5
          }
      }
  },
  {
      id = 6,
      header = "Sunrise",
      txt = "Set the weather to Sunrise",
      params = {
          event = "set-weather",
          args = {
                type = "sunrise",
                number = 5,
                id = 6
          }
      }
  },
  {
      id = 7,
      header = "Nova Sky",
      txt = "Set the weather to Nova Sky",
      params = {
          event = "set-weather",
          args = {
                type = "variable",
                number = 6,
                id = 7
          }
      }
  },
  {
      id = 8,
      header = "Grey Sky",
      txt = "Set the weather to greysky",
      params = {
          event = "set-weather",
          args = {
            type = "greysky",
              number = 7,
              id = 8
          }
      }
  },
  {
      id = 9,
      header = "Realism",
      txt = "Set the weather to Realism",
      params = {
          event = "set-weather",
          args = {
                type = "realism",
                number = 8,
                id = 9
          }
      }
  },
}

exports("getWeatherSubMenu", function()
  return submenu
end)