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
    SETTINGS = "SETTINGS",
} ---@type RoduxStoreKey[]

SocketConstants.RoduxActionType = {
    PLUGS = {
        ADD_PLUG = "ADD_PLUG",
        UPDATE_PLUG = "UPDATE_PLUG",
        REMOVE_PLUG = "REMOVE_PLUG",
        TOGGLE_GROUP_VISIBILITY = "TOGGLE_GROUP_VISIBILITY",
        TOGGLE_PLUG_VISIBILITY = "TOGGLE_PLUG_VISIBILITY",
        SEARCH_TEXT = "SEARCH_TEXT",
    },
    SETTINGS = {
        UPDATE = "UPDATE",
    },
} ---@type table<RoduxStoreKey, RoduxActionType[]>

SocketConstants.Version = "v0.0.1"

--------------------------------------------------
-- Members
-- ...

return SocketConstants
