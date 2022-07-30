---
---Settings Utilities
---
---@class SettingsUtil
---
local SettingsUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local SocketSettings ---@type SocketSettings

--------------------------------------------------
-- Constants
local VECTOR_3_PATTERN = "(%d+),%s?(%d+),%s?(%d+)"

local TYPE_FUNCTIONS = {
    Color3 = {
        Serialize = function(color3)
            local r, g, b = color3.R, color3.B, color3.G
            return ("%d, %d, %d"):format(r * 255, g * 255, b * 255)
        end,
        Deserialize = function(str, defaultValue)
            local r, g, b = str:match(VECTOR_3_PATTERN)
            return Color3.fromRGB(r, g, b)
        end,
    },
    EnumItem = {
        Serialize = function(enumItem)
            return enumItem.Name
        end,
        Deserialize = function(str, defaultValue)
            return Enum[tostring(defaultValue.EnumType)][str]
        end,
    },
}

--------------------------------------------------
-- Members

---
---@param cleanSettings table
---@return table
---
function SettingsUtil:Serialize(cleanSettings)
    local serializedSettings = {}
    for settingName, settingValue in pairs(cleanSettings) do
        local settingType = typeof(settingValue)
        local serializationFunction = TYPE_FUNCTIONS[settingType] and TYPE_FUNCTIONS[settingType].Serialize
        serializedSettings[settingName] = serializationFunction and serializationFunction(settingValue) or settingValue
    end

    return serializedSettings
end

---
---@param savedSettings table
---@return table
---
function SettingsUtil:Deserialize(savedSettings)
    local defaultSettings = SocketSettings:GetDefaultSettings()
    local deserializedSettings = {}
    for settingName, settingValue in pairs(savedSettings or {}) do
        local defaultValue = defaultSettings[settingName]
        local settingType = typeof(defaultValue)
        if settingType then
            local deserializationFunction = TYPE_FUNCTIONS[settingType] and TYPE_FUNCTIONS[settingType].Deserialize
            print(settingName, settingValue, "| ", defaultValue, settingType, deserializationFunction)
            deserializedSettings[settingName] = deserializationFunction and deserializationFunction(settingValue, defaultValue)
                or settingValue
        end
    end

    return deserializedSettings
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function SettingsUtil:FrameworkInit()
    SocketSettings = PluginFramework:Require("SocketSettings")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function SettingsUtil:FrameworkStart()
    -- TODO Logic here
end

return SettingsUtil
