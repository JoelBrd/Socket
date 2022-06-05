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

--------------------------------------------------
-- Constants

PlugConstants.FieldType = {
    number = { Name = "number", Icon = "#️⃣" },
    boolean = { Name = "boolean", Icon = "🅱️" },
    string = { Name = "string", Icon = "📝" },
} ---@type table<string, PlugFieldType>

return PlugConstants
