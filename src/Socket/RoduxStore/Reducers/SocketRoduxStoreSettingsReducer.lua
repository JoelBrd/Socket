---
---Reducer for actions pertaining to adding/changing/removing plugs
---
---@class SocketRoduxStoreSettingsReducer
---
local SocketRoduxStoreSettingsReducer = {}

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
function SocketRoduxStoreSettingsReducer:Get()
    return Rodux.createReducer({
        Settings = {},
    }, {
        ---Update the store to current settings
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.SETTINGS.UPDATE] = function(state, action)
            -- Read Action
            local settings = action.data.settings ---@type SocketSettings

            -- Recreate state
            local newState = {
                Settings = settings,
            }

            return newState
        end,
    })
end

---@private
function SocketRoduxStoreSettingsReducer:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    TableUtil = PluginFramework:Require("TableUtil")
end

---@private
function SocketRoduxStoreSettingsReducer:FrameworkStart() end

return SocketRoduxStoreSettingsReducer
