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
---@field GroupIcon string
---@field Name string
---@field Icon string
---@field Description string
---@field State PlugState
---@field EnableAutomaticUndo boolean
---@field Keybind Enum.KeyCode[]
---@field Fields PlugField[]
---@field Function fun()
---@field _script ModuleScript

---@class PlugState
---@field FieldValues table<PlugField, any>
---@field IsRunning boolean|nil
---@field Server PlugState
---@field Client PlugState

---@class PlugField
---@field Type PlugFieldType
---@field Name string

---@class PlugFieldType
---@field Name string
---@field Icon string
---@field Validate fun(value:any):any|nil
---@field ToString fun(value:any):string

--------------------------------------------------
-- Constants

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
            if value == true then
                return true
            end

            if value == false then
                return false
            end

            local str = tostring(value)
            if str == "true" or str == "t" then
                return true
            end

            if str == "false" or str == "f" then
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
            return tostring(value)
        end,
        ToString = function(value)
            return value
        end,
    },
} ---@type table<string, PlugFieldType>

return PlugConstants
