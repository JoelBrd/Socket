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
local TableUtil ---@type TableUtil

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@return RoduxReducer
---
function SocketRoduxStorePlugsReducer:Get()
    return Rodux.createReducer({
        Groups = {},
        SearchText = "",
    }, {

        ---Add a plug to the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.ADD_PLUG] = function(state, action)
            -- Read Action
            local plug = action.data.plug ---@type PlugDefinition
            local plugScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Ensure group for this plug exists
            local plugGroup = plug.Group
            newState.Groups[plugGroup] = newState.Groups[plugGroup]
                or {
                    Plugs = {},
                    UIState = {
                        IsOpen = false,
                    },
                }

            -- Add plug to group
            newState.Groups[plugGroup].Plugs[plugScript] = {
                Plug = plug,
                UIState = {
                    IsOpen = false,
                    IsFieldsOpen = false,
                },
            }

            return newState
        end,

        ---Update a plug in the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.UPDATE_PLUG] = function(state, action)
            -- Read Action
            local plug = action.data.plug ---@type PlugDefinition
            local plugScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Read stored version of this plug
            local storedPlug ---@type PlugDefinition
            local storedUIState ---@type table
            for _, groupData in pairs(newState.Groups) do
                for somePlugScript, somePlugInfo in pairs(groupData.Plugs) do
                    if somePlugScript == plugScript then
                        storedPlug = somePlugInfo.Plug
                        storedUIState = somePlugInfo.UIState
                        groupData.Plugs[somePlugScript] = nil
                        break
                    end
                end

                if storedPlug then
                    break
                end
            end

            -- Update new plug from stored version
            plug.State = storedPlug.State
            local plugGroup = plug.Group

            -- Update plug in group
            newState.Groups[plugGroup] = newState.Groups[plugGroup]
                or {
                    Plugs = {},
                    UIState = {
                        IsOpen = false,
                    },
                }
            newState.Groups[plugGroup].Plugs[plugScript] = {
                Plug = plug,
                UIState = storedUIState,
            }

            -- Clear old group if needed (.Group may have changed)
            if TableUtil:Size(newState.Groups[storedPlug.Group].Plugs) == 0 then
                newState.Groups[storedPlug.Group] = nil
            end

            return newState
        end,

        ---Remove a plug from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.REMOVE_PLUG] = function(state, action)
            -- Read Action
            local plugScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Get stored plug + clear
            local clearedPlug = false
            for _, groupData in pairs(newState.Groups) do
                for somePlugScript, somePlugInfo in pairs(groupData.Plugs) do
                    if somePlugScript == plugScript then
                        groupData.Plugs[somePlugScript] = nil
                        clearedPlug = somePlugInfo.Plug
                        break
                    end
                end

                if clearedPlug then
                    break
                end
            end

            -- Clear old group if needed (.Group may have changed)
            local groupName = clearedPlug.Group
            if TableUtil:Size(newState.Groups[groupName].Plugs) == 0 then
                newState.Groups[groupName] = nil
            end

            return newState
        end,

        ---Show/Hide group children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.TOGGLE_GROUP_VISIBILITY] = function(state, action)
            -- Read Action
            local group = action.data.group ---@type string

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified group name
            for groupName, groupData in pairs(newState.Groups) do
                if groupName == group then
                    groupData.UIState.IsOpen = not groupData.UIState.IsOpen
                end
            end

            return newState
        end,

        ---Show/Hide plug children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.TOGGLE_PLUG_VISIBILITY] = function(state, action)
            -- Read Action
            local plugScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified plug
            for _, groupData in pairs(newState.Groups) do
                for somePlugScript, somePlugInfo in pairs(groupData.Plugs) do
                    if somePlugScript == plugScript then
                        somePlugInfo.UIState.IsOpen = not somePlugInfo.UIState.IsOpen
                        return newState
                    end
                end
            end

            return newState
        end,

        ---Show/Hide plug fields children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.TOGGLE_FIELDS_VISIBILITY] = function(state, action)
            -- Read Action
            local plugScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified plug
            for _, groupData in pairs(newState.Groups) do
                for somePlugScript, somePlugInfo in pairs(groupData.Plugs) do
                    if somePlugScript == plugScript then
                        somePlugInfo.UIState.IsFieldsOpen = not somePlugInfo.UIState.IsFieldsOpen
                        return newState
                    end
                end
            end

            return newState
        end,

        ---Update search text
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.SEARCH_TEXT] = function(state, action)
            -- Read Action
            local text = action.data.text

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = text,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            return newState
        end,

        ---Refreshes the UI, makes no changes to state
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.PLUGS.REFRESH] = function(state, action)
            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            return newState
        end,
    })
end

---@private
function SocketRoduxStorePlugsReducer:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    TableUtil = PluginFramework:Require("TableUtil")
end

---@private
function SocketRoduxStorePlugsReducer:FrameworkStart() end

return SocketRoduxStorePlugsReducer
