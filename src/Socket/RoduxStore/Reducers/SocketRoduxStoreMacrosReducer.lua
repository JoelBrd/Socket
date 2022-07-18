---
---Reducer for actions pertaining to adding/changing/removing macros
---
---@class SocketRoduxStoreMacrosReducer
---
local SocketRoduxStoreMacrosReducer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Rodux ---@type Rodux
local SocketConstants ---@type SocketConstants
local TableUtil ---@type TableUtil
local SocketController ---@type SocketController

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@return RoduxReducer
---
function SocketRoduxStoreMacrosReducer:Get()
    return Rodux.createReducer({
        Groups = {},
        SearchText = "",
    }, {

        ---Add a macro to the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.ADD_MACRO] = function(state, action)
            -- Read Action
            local macro = action.data.macro ---@type MacroDefinition
            local macroScript = action.data.script
            local isFieldsOpen = action.data.isFieldsOpen

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Ensure group for this macro exists
            local macroGroup = macro.Group
            newState.Groups[macroGroup] = newState.Groups[macroGroup]
                or {
                    Macros = {},
                    UIState = {
                        IsOpen = false,
                    },
                }

            -- Add macro to group
            newState.Groups[macroGroup].Macros[macroScript] = {
                Macro = macro,
                UIState = {
                    IsOpen = false,
                    IsFieldsOpen = isFieldsOpen,
                },
            }

            return newState
        end,

        ---Update a macro in the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.UPDATE_MACRO] = function(state, action)
            -- Read Action
            local macro = action.data.macro ---@type MacroDefinition
            local macroScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Read stored version of this macro
            local storedMacro ---@type MacroDefinition
            local storedUIState ---@type table
            for _, groupData in pairs(newState.Groups) do
                for someMacroScript, someMacroInfo in pairs(groupData.Macros) do
                    if someMacroScript == macroScript then
                        storedMacro = someMacroInfo.Macro
                        storedUIState = someMacroInfo.UIState
                        groupData.Macros[someMacroScript] = nil
                        break
                    end
                end

                if storedMacro then
                    break
                end
            end

            -- Update new macro from stored version
            macro.State = storedMacro.State
            local macroGroup = macro.Group

            -- Update macro in group
            newState.Groups[macroGroup] = newState.Groups[macroGroup]
                or {
                    Macros = {},
                    UIState = {
                        IsOpen = false,
                    },
                }
            newState.Groups[macroGroup].Macros[macroScript] = {
                Macro = macro,
                UIState = storedUIState,
            }

            -- Clear old group if needed (.Group may have changed)
            if TableUtil:Size(newState.Groups[storedMacro.Group].Macros) == 0 then
                newState.Groups[storedMacro.Group] = nil
            end

            return newState
        end,

        ---Remove a macro from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.REMOVE_MACRO] = function(state, action)
            -- Read Action
            local macroScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Get stored macro + clear
            local clearedMacro = false
            for _, groupData in pairs(newState.Groups) do
                for someMacroScript, someMacroInfo in pairs(groupData.Macros) do
                    if someMacroScript == macroScript then
                        groupData.Macros[someMacroScript] = nil
                        clearedMacro = someMacroInfo.Macro
                        break
                    end
                end

                if clearedMacro then
                    break
                end
            end

            -- Clear old group if needed (.Group may have changed)
            local groupName = clearedMacro.Group
            if TableUtil:Size(newState.Groups[groupName].Macros) == 0 then
                newState.Groups[groupName] = nil
            end

            return newState
        end,

        ---Show/Hide group children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.TOGGLE_GROUP_VISIBILITY] = function(state, action)
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

        ---Show/Hide macro children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.TOGGLE_MACRO_VISIBILITY] = function(state, action)
            -- Read Action
            local macroScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified macro
            for _, groupData in pairs(newState.Groups) do
                for someMacroScript, someMacroInfo in pairs(groupData.Macros) do
                    if someMacroScript == macroScript then
                        someMacroInfo.UIState.IsOpen = not someMacroInfo.UIState.IsOpen
                        return newState
                    end
                end
            end

            return newState
        end,

        ---Show/Hide macro fields children from the widget
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.TOGGLE_FIELDS_VISIBILITY] = function(state, action)
            -- Read Action
            local macroScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified macro
            for _, groupData in pairs(newState.Groups) do
                for someMacroScript, someMacroInfo in pairs(groupData.Macros) do
                    if someMacroScript == macroScript then
                        someMacroInfo.UIState.IsFieldsOpen = not someMacroInfo.UIState.IsFieldsOpen
                        return newState
                    end
                end
            end

            return newState
        end,

        ---Update search text
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.SEARCH_TEXT] = function(state, action)
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
        [SocketConstants.RoduxActionType.MACROS.REFRESH] = function(state, action)
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

        ---Enables/Disables a macro's Keybind
        ---@param state RoduxState
        ---@param action RoduxAction
        [SocketConstants.RoduxActionType.MACROS.TOGGLE_KEYBIND] = function(state, action)
            -- Read Action
            local macroScript = action.data.script

            -- Recreate state
            local newState = {
                Groups = {},
                SearchText = state.SearchText,
            }
            for groupName, groupData in pairs(state.Groups) do
                newState.Groups[groupName] = groupData
            end

            -- Toggle visibility for specified macro
            for _, groupData in pairs(newState.Groups) do
                for someMacroScript, someMacroInfo in pairs(groupData.Macros) do
                    if someMacroScript == macroScript then
                        local macro = someMacroInfo.Macro
                        macro.State.IsKeybindDisabled = not macro.State.IsKeybindDisabled
                        return newState
                    end
                end
            end

            return newState
        end,
    })
end

---@private
function SocketRoduxStoreMacrosReducer:FrameworkInit()
    Rodux = PluginFramework:Require("Rodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    TableUtil = PluginFramework:Require("TableUtil")
    SocketController = PluginFramework:Require("SocketController")
end

---@private
function SocketRoduxStoreMacrosReducer:FrameworkStart() end

return SocketRoduxStoreMacrosReducer
