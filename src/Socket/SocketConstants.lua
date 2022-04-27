---
---The main script for running Socket (when the player has "activated" the plugin + has the widget window open)
---
---@class SocketConstants
---
local SocketConstants = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework

--------------------------------------------------
-- Constants
SocketConstants.RoduxActionType = {
    ADD_PLUG = "ADD_PLUG",
    UPDATE_PLUG = "UPDATE_PLUG",
    REMOVE_PLUG = "REMOVE_PLUG",
} ---@type RoduxActionType[]

--------------------------------------------------
-- Members
-- ...

return SocketConstants
