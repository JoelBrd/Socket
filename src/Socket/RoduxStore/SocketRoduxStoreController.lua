---
---The main script for running Socket (when the player has "activated" the plugin + has the widget window open)
---
---@class SocketRoduxStoreController
---
local SocketRoduxStoreController = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Rodux ---@type Rodux
local SocketConstants ---@type SocketConstants
local SocketRoduxStoreMacrosReducer ---@type SocketRoduxStoreMacrosReducer
local SocketRoduxStoreStudioReducer ---@type SocketRoduxStoreStudioReducer

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---Gives a fresh copy of our RoduxStore data structure
---@return RoduxStore
---
function SocketRoduxStoreController:GetRoduxStore()
    local roduxReducer = SocketRoduxStoreController:CreateGlobalReducer()
    local roduxInitialState = nil
    local roduxMiddlewares = table.pack(Rodux.loggerMiddleware)

    return Rodux.Store.new(roduxReducer, roduxInitialState)
end

---
---@private
---
---Creates the global reducer to pass to our rodux store
---@return RoduxReducer
---
function SocketRoduxStoreController:CreateGlobalReducer()
    return Rodux.combineReducers({
        [SocketConstants.RoduxStoreKey.MACROS] = SocketRoduxStoreMacrosReducer:Get(),
        [SocketConstants.RoduxStoreKey.STUDIO] = SocketRoduxStoreStudioReducer:Get(),
    })
end

---@private
function SocketRoduxStoreController:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    SocketRoduxStoreMacrosReducer = PluginFramework:Require("SocketRoduxStoreMacrosReducer")
    SocketRoduxStoreStudioReducer = PluginFramework:Require("SocketRoduxStoreStudioReducer")
end

---@private
function SocketRoduxStoreController:FrameworkStart() end

return SocketRoduxStoreController
