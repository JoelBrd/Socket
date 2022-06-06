---
---Reducer for actions pertaining to studio
---
---@class SocketRoduxStoreStudioReducer
---
local SocketRoduxStoreStudioReducer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Rodux ---@type Rodux
local SocketConstants ---@type SocketConstants
local TableUtil ---@type TableUtil

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@return RoduxReducer
---
function SocketRoduxStoreStudioReducer:Get()
    return Rodux.createReducer({
        Theme = "Light",
        IsRunning = false,
    }, {
        ---Update theme
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.STUDIO.SET_THEME] = function(state, action)
            -- Read Action
            local theme = action.data.theme ---@type string

            -- Recreate state
            local newState = {}
            for k, v in pairs(state) do
                newState[k] = v
            end

            newState.Theme = theme == "Dark" and "Dark" or "Light"

            return newState
        end,

        ---Declare if we are in a running state or not
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.STUDIO.IS_RUNNING] = function(state, action)
            -- Read Action
            local isRunning = action.data.isRunning ---@type boolean

            -- Recreate state
            local newState = {}
            for k, v in pairs(state) do
                newState[k] = v
            end

            newState.IsRunning = isRunning

            return newState
        end,
    })
end

---@private
function SocketRoduxStoreStudioReducer:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    TableUtil = PluginFramework:Require("TableUtil")
end

---@private
function SocketRoduxStoreStudioReducer:FrameworkStart() end

return SocketRoduxStoreStudioReducer
