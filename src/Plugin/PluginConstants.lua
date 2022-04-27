---
---Contains Constants relating to plugins.
---
---@class PluginConstants
---
local PluginConstants = {}

--------------------------------------------------
-- Types

---@class PluginSetting
---@field Id string
---@field DefaultValue any

--------------------------------------------------
-- Constants

PluginConstants.Setting = {
    HAS_RUN_BEFORE = {
        Id = "HAS_RUN_BEFORE",
        DefaultValue = true,
    },

    IS_PLUGIN_ACTIVE = {
        Id = "IS_PLUGIN_ACTIVE",
        DefaultValue = false,
    },
} ---@type table<string, PluginSetting>

return PluginConstants
