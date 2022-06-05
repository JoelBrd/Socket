---
---Helper functions for plugs
---
---@class PlugHelper
---
local PlugHelper = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local PlugConstants ---@type PlugConstants
local Logger ---@type Logger
local SocketConstants ---@type SocketConstants
local SocketController ---@type SocketController

--------------------------------------------------
-- Constants
local YIELD_TIME = 3

--------------------------------------------------
-- Members

---Refreshes the state after we update a field
local function refreshState()
    -- Update RoduxStore
    ---@type RoduxAction
    local action = {
        type = SocketConstants.RoduxActionType.PLUGS.REFRESH,
        data = {},
    }
    SocketController:GetStore():dispatch(action)
end

---
---@param plug PlugDefinition
---
function PlugHelper:RunPlug(plug)
    -- Task to ensure the function isn't yielding..
    local threadIsGood = false
    task.spawn(function()
        wait(YIELD_TIME)
        if not threadIsGood then
            Logger:Warn(
                ("Plug %s has been yielding for more than %d seconds.. if unintentional, may cause unintended behaviour."):format(
                    plug.Name,
                    YIELD_TIME
                )
            )
        end
    end)

    plug.Function(plug)
    threadIsGood = true

    -- Plug has `isRunning` enabled, so ensure to refresh the state!
    if plug.State.IsRunning ~= nil then
        refreshState()
    end
end

---
---@param plug PlugDefinition
---
function PlugHelper:ShowDescription(plug)
    local descriptionHolderString = ("================ %s (%s) | DESCRIPTION ================"):format(plug.Name, plug.Group)
    print("\n", descriptionHolderString, "\n\n", plug.Description, "\n\n", descriptionHolderString)
end

---Will clean up a plug definiton direct from require().
---Injects expected data structures.
---Ensures inputted data is valid.
---Warns of any issues.
---@param plug PlugDefinition
---@return PlugDefinition
function PlugHelper:CleanPlugDefinition(plug)
    -- State
    plug.State = plug.State or {}
    plug.State.FieldValues = plug.State.FieldValues or {}

    -- PlugFields
    local fieldNames = {}
    for _, field in pairs(plug.Fields) do
        local fieldTypeId = field.Type
        local fieldType = PlugConstants.FieldType[fieldTypeId]
        if not fieldType then
            Logger:Warn(("Field %q has invalid field type %q (%s)"):format(field.Name, fieldTypeId, plug.Name))
            return
        end

        local fieldName = field.Name
        if fieldNames[fieldName] then
            Logger:Warn(("Field %q is a duplicate name (%s)"):format(field.Name, plug.Name))
            return
        end

        field.Type = fieldType
    end

    --todo more validation checks!!

    return plug
end

---
---@param plug PlugDefinition
---@param field PlugField
---
function PlugHelper:ClearField(plug, field)
    plug.State.FieldValues[field.Name] = nil
    refreshState()
end

---
---UI has requested to update this field.
---Returns the current value, and true if it was updated.
---@param plug PlugDefinition
---@param field PlugField
---@param text string
---@return any, boolean
---
function PlugHelper:UpdateField(plug, field, text)
    -- Validate value
    local value = field.Type.Validate(text)
    if value == nil then
        -- Validation failed; return stored value.
        local currentValue = plug.State.FieldValues[field.Name]
        return currentValue, false
    end

    -- Update
    plug.State.FieldValues[field.Name] = value
    refreshState()
    return value, true
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function PlugHelper:FrameworkInit()
    Logger = PluginFramework:Require("Logger")
    PlugConstants = PluginFramework:Require("PlugConstants")
    SocketController = PluginFramework:Require("SocketController")
    SocketConstants = PluginFramework:Require("SocketConstants")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function PlugHelper:FrameworkStart()
    -- TODO Logic here
end

return PlugHelper
