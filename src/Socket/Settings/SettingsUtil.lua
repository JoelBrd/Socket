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
-- ...

--------------------------------------------------
-- Members

---
---@param cleanSettings table
---@return table
---
function SettingsUtil:Serialize(cleanSettings)
    -- TODO Logic here
end

---
---@param savedSettings table
---@return table
---
function SettingsUtil:Deserialize(savedSettings)
    -- TODO Logic here
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
