---
---Contains Constants relating to plugins.
---
---@class PlugConstants
---
local PlugConstants = {}

--------------------------------------------------
-- Types

---@class PlugDefinition
---@field Group string
---@field GroupColor Color3
---@field GroupIcon string
---@field GroupIconColor Color3
---@field Name string
---@field NameColor Color3
---@field Icon string
---@field IconColor Color3
---@field Description string
---@field State PlugState
---@field EnableAutomaticUndo boolean
---@field IgnoreGameProcessedKeybinds boolean
---@field AutoRun boolean
---@field Keybind Enum.KeyCode[]
---@field Fields PlugField[]
---@field FieldChanged BindableEvent Fired with (fieldName, fieldValue)
---@field RunJanitor Janitor
---@field ToggleIsRunning fun(plug:PlugDefinition)
---@field GetFieldValue fun(plug:PlugDefinition, fieldName:string)
---@field Function fun(plug:PlugDefinition)
---@field BindToClose fun(plug:PlugDefinition) Called when plugin is closed, or plug is removed from state
---@field _BindToClose fun(plug:PlugDefinition) Wraps BindToClose plus some internal stuff (e.g., IsRunning=false)
---@field _script ModuleScript
---@field _isBroken boolean

---@class PlugState
---@field FieldValues table<PlugField, any>
---@field IsRunning boolean|nil
---@field Server PlugState
---@field Client PlugState

---@class PlugField
---@field Type PlugFieldType
---@field Name string
---@field IsRequired boolean
---@field Validator fun(value:any):string

---@class PlugFieldType
---@field Name string
---@field Icon string
---@field Validate fun(value:any):any|nil
---@field ToString fun(value:any):string

--------------------------------------------------
-- Constants
local PATTERN_3_VALUES = "%s*(%d+),%s*(%d+),%s*(%d+)%s*"

---@param number number
---@return string
local function commaValue(number)
    if number == math.huge then
        return "Infinite"
    end

    -- credit http://richard.warburton.it
    local left, num, right = string.match(tostring(number), "^([^%d]*%d)(%d*)(.-)$")
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

PlugConstants.FieldType = {
    number = {
        Name = "number",
        Icon = "#️⃣",
        Validate = function(value)
            return tonumber(value)
        end,
        ToString = function(value)
            return commaValue(value)
        end,
    },
    boolean = {
        Name = "boolean",
        Icon = "🅱️",
        Validate = function(value)
            if value == "true" or value == "t" then
                return true
            end

            if value == "false" or value == "f" then
                return false
            end
        end,
        ToString = function(value)
            return tostring(value)
        end,
    },
    string = {
        Name = "string",
        Icon = "📝",
        Validate = function(value)
            return value
        end,
        ToString = function(value)
            return value
        end,
    },
    Color3 = {
        Name = "Color3",
        Icon = "🌈",
        Validate = function(value)
            local r, g, b = value:match(PATTERN_3_VALUES)
            if r and g and b then
                return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
            end
        end,
        ToString = function(value)
            return ("%d, %d, %d"):format(value.r * 255, value.g * 255, value.b * 255)
        end,
    },
    Vector3 = {
        Name = "Vector3",
        Icon = "↗️",
        Validate = function(value)
            local x, y, z = value:match(PATTERN_3_VALUES)
            if x and y and z then
                return Vector3.new(x, y, z)
            end
        end,
        ToString = function(value)
            return ("%d, %d, %d"):format(value.X, value.Y, value.Z)
        end,
    },
} ---@type table<string, PlugFieldType>

return PlugConstants
