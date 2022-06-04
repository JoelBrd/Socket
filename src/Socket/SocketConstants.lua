---
---Socket Constants
---
---@class SocketConstants
---
local SocketConstants = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Constants

SocketConstants.RoduxStoreKey = {
    PLUGS = "PLUGS",
} ---@type RoduxStoreKey[]

SocketConstants.RoduxActionType = {
    PLUGS = {
        ADD_PLUG = "ADD_PLUG",
        UPDATE_PLUG = "UPDATE_PLUG",
        REMOVE_PLUG = "REMOVE_PLUG",
        TOGGLE_GROUP_VISIBILITY = "TOGGLE_GROUP_VISIBILITY",
        TOGGLE_PLUG_VISIBILITY = "TOGGLE_PLUG_VISIBILITY",
    },
} ---@type table<RoduxStoreKey, RoduxActionType[]>

--------------------------------------------------
-- Members
-- ...

return SocketConstants
