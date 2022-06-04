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
        TOGGLE_GROUP = "TOGGLE_GROUP",
        TOGGLE_PLUG = "TOGGLE_PLUG",
        RUN_PLUG = "RUN_PLUG",
        VIEW_PLUG_SOURCE = "VIEW_PLUG_SOURCE",
    },
} ---@type table<RoduxStoreKey, RoduxActionType[]>

--------------------------------------------------
-- Members
-- ...

return SocketConstants
