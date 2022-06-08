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

SocketConstants.ShowDebugUI = false

SocketConstants.RoduxStoreKey = {
    PLUGS = "PLUGS",
    STUDIO = "STUDIO",
} ---@type RoduxStoreKey[]

SocketConstants.RoduxActionType = {
    PLUGS = {
        ADD_PLUG = "ADD_PLUG",
        UPDATE_PLUG = "UPDATE_PLUG",
        REMOVE_PLUG = "REMOVE_PLUG",
        TOGGLE_GROUP_VISIBILITY = "TOGGLE_GROUP_VISIBILITY",
        TOGGLE_PLUG_VISIBILITY = "TOGGLE_PLUG_VISIBILITY",
        TOGGLE_FIELDS_VISIBILITY = "TOGGLE_FIELDS_VISIBILITY",
        SEARCH_TEXT = "SEARCH_TEXT",
        REFRESH = "REFRESH",
    },
    STUDIO = {
        IS_RUNNING = "IS_RUNNING",
    },
} ---@type table<RoduxStoreKey, RoduxActionType[]>

SocketConstants.Version = "v0.0.1"

--------------------------------------------------
-- Members
-- ...

return SocketConstants
