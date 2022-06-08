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
local Players = game:GetService("Players") ---@type Players
local StudioService = game:GetService("StudioService") ---@type StudioService
local RunService = game:GetService("RunService") ---@type RunService
local ChangeHistoryService = game:GetService("ChangeHistoryService") ---@type ChangeHistoryService
local Selection = game:GetService("Selection") ---@type Selection
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local PlugConstants ---@type PlugConstants
local Logger ---@type Logger
local SocketConstants ---@type SocketConstants
local SocketController ---@type SocketController
local PluginHandler ---@type PluginHandler
local StudioHandler ---@type StudioHandler
local PlugClientServer ---@type PlugClientServer

--------------------------------------------------
-- Constants
local YIELD_TIME = 3
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()
local IS_RUNNING = RunService:IsRunning()

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
---Runs a plug, then returns its state after the fact.
---@param plug PlugDefinition
---@return PlugState
---
function PlugHelper:RunPlug(plug)
    -- Task to ensure the function isn't yielding..
    local threadIsGood = false
    task.spawn(function()
        wait(YIELD_TIME)
        if not threadIsGood then
            Logger:Warn(
                ("Plug %s has been yielding for more than %d seconds.. if unintentional, will cause unintended behaviour."):format(
                    plug.Name,
                    YIELD_TIME
                )
            )
        end
    end)

    -- Set waypoint (undo/redo)
    local doSetWaypoint = plug.EnableAutomaticUndo
    if doSetWaypoint then
        ChangeHistoryService:SetWaypoint(("Plug %s Before"):format(plug.Name))
    end

    -- Run Plug
    local success, err = pcall(function()
        plug.Function(plug, PluginHandler:GetPlugin())
    end)
    threadIsGood = true

    -- Show error
    if not success then
        Logger:PlugWarn(plug, ("ERROR: %s"):format(err))
    end

    -- Set waypoint
    if doSetWaypoint then
        ChangeHistoryService:SetWaypoint(("Plug %s After"):format(plug.Name))
    end

    -- Plug has `isRunning` enabled, so ensure to refresh the state!
    if plug.State.IsRunning ~= nil then
        refreshState()
    end

    return plug.State
end

---
---Will run the plug at the specified location, regardless of this being called on server or client.
---Warning: Can be called on both client and server simultaneously
---@param plug PlugDefinition
---@param onServer boolean
---@param onClient boolean
---
function PlugHelper:RunPlugAt(plug, onServer, onClient)
    -- ERROR: Bad api
    if not IS_RUNNING then
        Logger:Error("Bad API; only use RunPlugAt when playing.")
    end

    -- Run in this context
    if IS_SERVER and onServer then
        local plugState = PlugHelper:RunPlug(plug)
        plug.State.Server.IsRunning = (plugState.IsRunning == nil and plug.State.Server.IsRunning) or plugState.IsRunning
        refreshState()
    elseif IS_CLIENT and onClient then
        local plugState = PlugHelper:RunPlug(plug)
        plug.State.Client.IsRunning = (plugState.IsRunning == nil and plug.State.Client.IsRunning) or plugState.IsRunning
        refreshState()
    end

    -- Server -> Client
    if IS_SERVER and onClient then
        local player = Players:GetPlayerByUserId(StudioService:GetUserId())
        local plugState = PlugClientServer:RunPlugOnClient(player, plug)
        plug.State.Client.IsRunning = (plugState.IsRunning == nil and plug.State.Client.IsRunning) or plugState.IsRunning
        refreshState()
        return
    end

    -- Client -> Server
    if IS_CLIENT and onServer then
        local plugState = PlugClientServer:RunPlugOnServer(plug)
        plug.State.Server.IsRunning = (plugState.IsRunning == nil and plug.State.Server.IsRunning) or plugState.IsRunning
        refreshState()
        return
    end
end

---
---@param plug PlugDefinition
---
function PlugHelper:ShowDescription(plug)
    local descriptionHolderString = ("================ %s (%s) | DESCRIPTION ================"):format(plug.Name, plug.Group)
    print("\n", descriptionHolderString, "\n\n", plug.Description, "\n\n", descriptionHolderString)
end

---
---@param plugScript ModuleScript
---
function PlugHelper:ViewSource(plugScript)
    PluginHandler:GetPlugin():OpenScript(plugScript)
    Selection:Set({ plugScript })
end

---Will clean up a plug definiton direct from require().
---Injects expected data structures.
---Ensures inputted data is valid.
---Warns of any issues.
---Returns when missing vital information.
---@param plugScript ModuleScript
---@param plug PlugDefinition
---@return PlugDefinition
function PlugHelper:CleanPlugDefinition(plugScript, plug)
    -- Group
    plug.Group = plug.Group or "No Group"
    if typeof(plug.Group) ~= "string" then
        Logger:Warn(("Plug %s `Group` must be of type `string` (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end

    -- Name
    if not plug.Name then
        Logger:Warn(("Plug %s has no `Name` (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end
    if typeof(plug.Name) ~= "string" then
        Logger:Warn(("Plug %s `Name` must be of type `string` (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end

    -- Description
    if not plug.Description then
        Logger:Warn(("Plug %s has no `Description` (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end
    if typeof(plug.Description) ~= "string" then
        Logger:Warn(("Plug %s `Description` must be of type `string` (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end

    -- State
    plug.State = plug.State or {}
    plug.State.FieldValues = plug.State.FieldValues or {}
    plug.State.Server = plug.State.Server or {}
    plug.State.Client = plug.State.Client or {}

    -- EnableAutomaticUndo
    plug.EnableAutomaticUndo = plug.EnableAutomaticUndo and true or false

    -- Keybind
    plug.Keybind = plug.Keybind or {}
    for _, keyCode in pairs(plug.Keybind) do
        if not keyCode.EnumType == Enum.KeyCode then
            Logger:Warn(
                ("Plug %s `Keybind` must have values of only type `Enum.KeyCode` (%s)"):format(plugScript.Name, plugScript:GetFullName())
            )
            return
        end
    end

    -- Fields
    local fieldNames = {}
    for _, field in pairs(plug.Fields) do
        if typeof(field) ~= "table" then
            ("Plug %s `Fields` must contain tables, with entries `Name` and `Type` (%s)"):format(plugScript.Name, plugScript:GetFullName())
            return
        end

        local fieldName = field.Name
        if not (fieldName and typeof(fieldName) == "string") then
            ("Plug %s has a field with no `Name` (string) (%s)"):format(plugScript.Name, plugScript:GetFullName())
            return
        end
        if fieldNames[fieldName] then
            Logger:Warn(("Field %q is a duplicate name (%s)"):format(field.Name, plugScript:GetFullName()))
            return
        end

        local fieldTypeId = tostring(field.Type)
        local fieldType = PlugConstants.FieldType[fieldTypeId]
        if not fieldType then
            Logger:Warn(("Field %q has invalid field type %q (%s)"):format(field.Name, fieldTypeId, plugScript:GetFullName()))
            return
        end

        field.Type = fieldType
    end

    -- Function
    if not (plug.Function and typeof(plug.Function) == "function") then
        Logger:Warn(("Plug %s has no `Function`! (%s)"):format(plugScript.Name, plugScript:GetFullName()))
        return
    end

    -- Give script reference
    plug._script = plugScript

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
    PluginHandler = PluginFramework:Require("PluginHandler")
    StudioHandler = PluginFramework:Require("StudioHandler")
    PlugClientServer = PluginFramework:Require("PlugClientServer")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function PlugHelper:FrameworkStart() end

return PlugHelper
