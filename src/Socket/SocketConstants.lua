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
    MACROS = "MACROS",
    STUDIO = "STUDIO",
} ---@type RoduxStoreKey[]

SocketConstants.RoduxActionType = {
    MACROS = {
        ADD_MACRO = "ADD_MACRO",
        UPDATE_MACRO = "UPDATE_MACRO",
        REMOVE_MACRO = "REMOVE_MACRO",
        TOGGLE_GROUP_VISIBILITY = "TOGGLE_GROUP_VISIBILITY",
        TOGGLE_MACRO_VISIBILITY = "TOGGLE_MACRO_VISIBILITY",
        TOGGLE_FIELDS_VISIBILITY = "TOGGLE_FIELDS_VISIBILITY",
        SEARCH_TEXT = "SEARCH_TEXT",
        REFRESH = "REFRESH",
        TOGGLE_KEYBIND = "TOGGLE_KEYBIND",
    },
    STUDIO = {
        IS_RUNNING = "IS_RUNNING",
    },
} ---@type table<RoduxStoreKey, RoduxActionType[]>

SocketConstants.Version = "v1.0.0"

--------------------------------------------------
-- Members
-- ...

return SocketConstants
