---
---Contains Constants relating to plugins.
---
---@class PlugConstants
---
local PlugConstants = {}

--------------------------------------------------
-- Types

---@class PlugFieldType
---@field Name string
---@field Icon string
---@field Validate fun(value:any):any|nil

--------------------------------------------------
-- Constants

PlugConstants.FieldType = {
    number = {
        Name = "number",
        Icon = "#️⃣",
        Validate = function(value)
            return tonumber(value)
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
    },
    string = {
        Name = "string",
        Icon = "📝",
        Validate = function(value)
            return tostring(value)
        end,
    },
} ---@type table<string, PlugFieldType>

return PlugConstants
