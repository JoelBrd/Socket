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

--------------------------------------------------
-- Constants

PlugConstants.FieldType = {
    number = { Name = "number" },
    boolean = { Name = "boolean" },
    string = { Name = "string" },
} ---@type table<string, PlugFieldType>

return PlugConstants
