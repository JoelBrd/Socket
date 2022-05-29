---
---Reducer for actions pertaining to adding/changing/removing plugs
---
---@class SocketRoduxStorePlugsReducer
---
local SocketRoduxStorePlugsReducer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Rodux ---@type Rodux
local SocketConstants ---@type SocketConstants

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@return RoduxReducer
---
function SocketRoduxStorePlugsReducer:Get()
    return Rodux.createReducer({}, {
        -- Add; adds a new plug
        [SocketConstants.RoduxActionType.ADD_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local plug = action.data.plug ---@type PlugDefinition
            local moduleScript = action.data.script ---@type ModuleScript

            -- Write to state
            newState[moduleScript] = plug

            return newState
        end,

        -- Update; will overwrite the existing plug but preserves its .State
        [SocketConstants.RoduxActionType.UPDATE_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local plug = action.data.plug ---@type PlugDefinition
            local moduleScript = action.data.script ---@type ModuleScript

            -- Get state of current plug
            local currentPlug = state[moduleScript] ---@type PlugDefinition
            local currentPlugState = currentPlug.State

            -- Update with new plug
            plug.State = currentPlugState
            newState[moduleScript] = plug

            return newState
        end,

        -- Remove; gets rid of the plug!
        [SocketConstants.RoduxActionType.REMOVE_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local moduleScript = action.data.script ---@type ModuleScript

            -- Remove from state
            newState[moduleScript] = nil

            return newState
        end,
    })
end

---@private
function SocketRoduxStorePlugsReducer:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
end

---@private
function SocketRoduxStorePlugsReducer:FrameworkStart() end

return SocketRoduxStorePlugsReducer
