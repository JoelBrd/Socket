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
local Janitor ---@type Janitor

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
    -- Check Fields
    for _, field in pairs(plug.Fields) do
        local currentValue = plug.State.FieldValues[field.Name]
        if field.IsRequired and currentValue == nil then
            Logger:PlugWarn(plug, ("Field %q is required!"):format(field.Name))
            return
        end

        local validatorMessage = field.Validator and field.Validator(currentValue)
        if validatorMessage then
            Logger:PlugWarn(plug, ("Field %q: %s"):format(field.Name, validatorMessage))
            return
        end
    end

    -- Task to ensure the function isn't yielding..
    local threadIsGood = false
    task.spawn(function()
        wait(YIELD_TIME)
        if not threadIsGood then
            Logger:PlugWarn(
                plug,
                ("Plug has been yielding for more than %d seconds.. will cause unintended behaviour."):format(plug.Name, YIELD_TIME)
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

---Checks the type of a plug member is correct.
---Returns true if good.
---@param plug PlugDefinition
---@param key string
---@param value any
---@param type string
---@return boolean
local function validateType(plugScript, plug, isRequired, key, type)
    -- Get Variables
    local ourValue = plug[key]
    local ourType = ourValue and typeof(ourValue)

    -- FALSE: Required key is missing
    if plug[key] == nil and isRequired then
        Logger:Warn(("Plug %s does not have required entry %q (%s) (%s)"):format(plugScript.Name, key, type, plugScript:GetFullName()))
        return false
    end

    -- FALSE: Wrong type
    if plug[key] and typeof(plug[key]) ~= type then
        Logger:Warn(
            ("Plug %s entry %q expected type %q, got %q (%s)"):format(plugScript.Name, key, type, ourType, plugScript:GetFullName())
        )
        return false
    end

    -- TRUE
    return true
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
    if not validateType(plugScript, plug, true, "Group", "string") then
        return
    end
    if not validateType(plugScript, plug, false, "GroupColor", "Color3") then
        return
    end
    if not validateType(plugScript, plug, false, "GroupIcon", "string") then
        return
    end
    if not validateType(plugScript, plug, false, "GroupIconColor", "Color3") then
        return
    end

    -- Name
    if not validateType(plugScript, plug, true, "Name", "string") then
        return
    end
    if not validateType(plugScript, plug, false, "NameColor", "Color3") then
        return
    end

    -- Icon
    if not validateType(plugScript, plug, false, "Icon", "string") then
        return
    end
    if not validateType(plugScript, plug, false, "IconColor", "Color3") then
        return
    end

    -- Description
    plug.Description = plug.Description or "No Description"
    if not validateType(plugScript, plug, true, "Description", "string") then
        return
    end

    -- State
    if not validateType(plugScript, plug, false, "State", "table") then
        return
    end
    plug.State = plug.State or {}
    plug.State.FieldValues = plug.State.FieldValues or {}
    plug.State.Server = plug.State.Server or {}
    plug.State.Client = plug.State.Client or {}

    -- EnableAutomaticUndo
    if not validateType(plugScript, plug, false, "EnableAutomaticUndo", "boolean") then
        return
    end

    -- AutoRun
    if not validateType(plugScript, plug, false, "AutoRun", "boolean") then
        return
    end

    -- IgnoreGameProcessedKeybinds
    if not validateType(plugScript, plug, false, "IgnoreGameProcessedKeybinds", "boolean") then
        return
    end

    -- Keybind
    plug.Keybind = plug.Keybind or {}
    if not validateType(plugScript, plug, false, "Keybind", "table") then
        return
    end
    for _, keyCode in pairs(plug.Keybind) do
        if not keyCode.EnumType == Enum.KeyCode then
            Logger:Warn(
                ("Plug %s `Keybind` must have values of only type `Enum.KeyCode` (%s)"):format(plugScript.Name, plugScript:GetFullName())
            )
            return
        end
    end

    -- Fields
    plug.Fields = plug.Fields or {}
    if not validateType(plugScript, plug, false, "Fields", "table") then
        return
    end
    local fieldNames = {}
    for _, field in pairs(plug.Fields) do
        if typeof(field) ~= "table" then
            ("Plug %s `Fields` must contain tables, with entries `Name` and `Type` (%s)"):format(plugScript.Name, plugScript:GetFullName())
            return
        end

        local fieldName = field.Name
        if not (fieldName and typeof(fieldName) == "string") then
            Logger:Warn(("Plug %s has a field with invalid `Name` (string) (%s)"):format(plugScript.Name, plugScript:GetFullName()))
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

        local isRequired = field.IsRequired
        if isRequired ~= nil and (typeof(isRequired) ~= "boolean") then
            Logger:Warn(("Plug %s has a field with invalid `IsRequired` (boolean) (%s)"):format(plugScript.Name, plugScript:GetFullName()))
            return
        end

        field.Type = fieldType
    end

    -- FieldChanged Event
    if not validateType(plugScript, plug, false, "FieldChanged", "BindableEvent") then
        return
    end
    plug.FieldChanged = plug.FieldChanged or Instance.new("BindableEvent")

    -- Run Janitor
    if not validateType(plugScript, plug, false, "Janitor", "table") then
        return
    end
    plug.RunJanitor = plug.RunJanitor or Janitor.new()

    -- Functions
    if not validateType(plugScript, plug, false, "ToggleIsRunning", "function") then
        return
    end
    plug.ToggleIsRunning = function(somePlug)
        somePlug.State.IsRunning = not (somePlug.State.IsRunning and true or false)
        somePlug.RunJanitor:Cleanup()
    end

    if not validateType(plugScript, plug, false, "GetFieldValue", "function") then
        return
    end
    plug.GetFieldValue = function(somePlug, fieldName)
        return somePlug.State.FieldValues[fieldName]
    end

    if not validateType(plugScript, plug, true, "Function", "function") then
        return
    end
    if not validateType(plugScript, plug, false, "BindToOpen", "function") then
        return
    end
    if not validateType(plugScript, plug, false, "BindToClose", "function") then
        return
    end
    plug._BindToClose = function(somePlug, plugin)
        if somePlug.BindToClose then
            somePlug.BindToClose(plug, plugin)
        end
        somePlug.State.IsRunning = false
        somePlug.RunJanitor:Cleanup()
    end

    -- Give script reference
    plug._script = plugScript
    plug._isBroken = plug._isBroken or false

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
    plug.FieldChanged:Fire(field.Name, value)
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
    Janitor = PluginFramework:Require("Janitor")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function PlugHelper:FrameworkStart() end

return PlugHelper
