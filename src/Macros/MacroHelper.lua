---
---Helper functions for macros
---
---@class MacroHelper
---
local MacroHelper = {}

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
local MacroConstants ---@type MacroConstants
local Logger ---@type Logger
local SocketConstants ---@type SocketConstants
local SocketController ---@type SocketController
local PluginHandler ---@type PluginHandler
local StudioHandler ---@type StudioHandler
local MacroClientServer ---@type MacroClientServer
local Janitor ---@type Janitor
local SocketSettings ---@type SocketSettings
local LocalMacros ---@type LocalMacros

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
        type = SocketConstants.RoduxActionType.MACROS.REFRESH,
        data = {},
    }
    SocketController:GetStore():dispatch(action)
end

local function getMessageAndTracebackOnError(func, ...) -- similar to "tpcall" below
    local traceback
    local errMsg
    local result = table.pack(xpcall(func, function(err)
        traceback = debug.traceback()
        errMsg = err
    end, ...))

    if result[1] then
        return true, nil, nil
    end

    return false, errMsg, traceback
end

---
---Runs a macro, then returns its state after the fact.
---@param macro MacroDefinition
---@return MacroState
---
function MacroHelper:RunMacro(macro)
    -- Check Fields
    for _, field in pairs(macro.Fields) do
        local currentValue = macro.State.FieldValues[field.Name]
        if field.IsRequired and currentValue == nil then
            Logger:MacroWarn(macro, ("Field %q is required!"):format(field.Name))
            return
        end

        local validatorMessage = field.Validator and field.Validator(currentValue)
        if validatorMessage then
            Logger:MacroWarn(macro, ("Field %q: %s"):format(field.Name, validatorMessage))
            return
        end
    end

    -- Task to ensure the function isn't yielding..
    local threadIsGood = false
    task.spawn(function()
        task.wait(YIELD_TIME)
        if not threadIsGood then
            Logger:MacroWarn(
                macro,
                ("Macro has been yielding for more than %d seconds.. will cause unintended behaviour."):format(YIELD_TIME)
            )
        end
    end)

    -- Set waypoint (undo/redo)
    local doSetWaypoint = macro.EnableAutomaticUndo
    if doSetWaypoint then
        ChangeHistoryService:SetWaypoint(("Macro %s Before"):format(macro.Name))
    end

    -- Run Macro
    local success, err, traceback = getMessageAndTracebackOnError(macro.Function, macro, PluginHandler:GetPlugin())
    threadIsGood = true

    -- Show error
    if not success then
        Logger:MacroWarn(macro, ("ERROR: %s\n%s"):format(err, traceback))
    end

    -- Set waypoint
    if doSetWaypoint then
        ChangeHistoryService:SetWaypoint(("Macro %s After"):format(macro.Name))
    end

    -- Macro has `isRunning` enabled, so ensure to refresh the state!
    if macro.State.IsRunning ~= nil then
        refreshState()
    end

    return macro.State
end

---
---Will run the macro at the specified location, regardless of this being called on server or client.
---Warning: Can be called on both client and server simultaneously
---@param macro MacroDefinition
---@param onServer boolean
---@param onClient boolean
---
function MacroHelper:RunMacroAt(macro, onServer, onClient)
    -- ERROR: Bad api
    if not IS_RUNNING then
        Logger:Error("Bad API; only use RunMacroAt when playing.")
    end

    -- Run in this context
    if IS_SERVER and onServer then
        local macroState = MacroHelper:RunMacro(macro)
        macro.State._Server.IsRunning = (macroState.IsRunning == nil and macro.State._Server.IsRunning) or macroState.IsRunning
        refreshState()
    elseif IS_CLIENT and onClient then
        local macroState = MacroHelper:RunMacro(macro)
        macro.State._Client.IsRunning = (macroState.IsRunning == nil and macro.State._Client.IsRunning) or macroState.IsRunning
        refreshState()
    end

    -- Server -> Client
    if IS_SERVER and onClient then
        local player = Players:GetPlayerByUserId(StudioService:GetUserId())
        local macroState = MacroClientServer:RunMacroOnClient(player, macro)
        macro.State._Client.IsRunning = (macroState.IsRunning == nil and macro.State._Client.IsRunning) or macroState.IsRunning
        refreshState()
        return
    end

    -- Client -> Server
    if IS_CLIENT and onServer then
        local macroState = MacroClientServer:RunMacroOnServer(macro)
        macro.State._Server.IsRunning = (macroState.IsRunning == nil and macro.State._Server.IsRunning) or macroState.IsRunning
        refreshState()
        return
    end
end

---
---@param macro MacroDefinition
---
function MacroHelper:ShowDescription(macro)
    local descriptionHolderString = ("================ %s (%s) | DESCRIPTION ================"):format(macro.Name, macro.Group)
    print("\n", descriptionHolderString, "\n\n", macro.Description, "\n\n", descriptionHolderString)
end

---
---@param macroScript ModuleScript
---
function MacroHelper:ViewSource(macroScript)
    PluginHandler:GetPlugin():OpenScript(macroScript)
    Selection:Set({ macroScript })
end

---
---@param macroScript ModuleScript
---
function MacroHelper:ToggleKeybind(macroScript)
    -- Get Store
    local roduxStore = SocketController:GetStore()

    -- Send action
    ---@type RoduxAction
    local action = {
        type = SocketConstants.RoduxActionType.MACROS.TOGGLE_KEYBIND,
        data = {
            script = macroScript,
        },
    }
    roduxStore:dispatch(action)
end

---Checks the type of a macro member is correct.
---Returns true if good.
---@param macro MacroDefinition
---@param key string
---@param value any
---@param type string
---@return boolean
local function validateType(macroScript, macro, isRequired, key, type)
    -- Get Variables
    local ourValue = macro[key]
    local ourType = ourValue and typeof(ourValue)

    -- FALSE: Required key is missing
    if macro[key] == nil and isRequired then
        Logger:Warn(("Macro %s does not have required entry %q (%s) (%s)"):format(macroScript.Name, key, type, macroScript:GetFullName()))
        return false
    end

    -- FALSE: Wrong type
    if macro[key] and typeof(macro[key]) ~= type then
        Logger:Warn(
            ("Macro %s entry %q expected type %q, got %q (%s)"):format(macroScript.Name, key, type, ourType, macroScript:GetFullName())
        )
        return false
    end

    -- TRUE
    return true
end

---Given a keybind, ensures it matches the clients OS
---@param keybind Enum.KeyCode[]
local function translateKeybindToOs(keybind)
    local osType = SocketSettings:GetSetting("OSType")
    local macKeyCodes = MacroConstants.MacKeyCodes
    local keycodeMap = osType == "Mac" and macKeyCodes.WindowsToMac or macKeyCodes.MacToWindows

    for k, keyCode in pairs(keybind) do
        keybind[k] = keycodeMap[keyCode] or keyCode
    end
end

---Will clean up a macro definiton direct from require().
---Injects expected data structures.
---Ensures inputted data is valid.
---Warns of any issues.
---Returns when missing vital information.
---@param macroScript ModuleScript
---@param macro MacroDefinition
---@return MacroDefinition
function MacroHelper:CleanMacroDefinition(macroScript, macro)
    -- Disabled
    if not validateType(macroScript, macro, false, "Disabled", "boolean") then
        return
    end
    macro.Disabled = macro.Disabled or false

    -- Disable some stuff if the macro is disabled!
    if macro.Disabled then
        macro.AutoRun = false
        macro.Name = macro.Name or "Disabled"
        macro.Function = function() end
        macro.BindToClose = function() end
        macro.BindToOpen = function() end
    end

    -- Group
    macro.Group = macro.Group or "No Group"
    if not validateType(macroScript, macro, true, "Group", "string") then
        return
    end
    if not validateType(macroScript, macro, false, "GroupColor", "Color3") then
        return
    end
    if not validateType(macroScript, macro, false, "GroupIcon", "string") then
        return
    end
    if not validateType(macroScript, macro, false, "GroupIconColor", "Color3") then
        return
    end

    -- Name
    if not validateType(macroScript, macro, true, "Name", "string") then
        return
    end
    if not validateType(macroScript, macro, false, "NameColor", "Color3") then
        return
    end

    -- Icon
    if not validateType(macroScript, macro, false, "Icon", "string") then
        return
    end
    if not validateType(macroScript, macro, false, "IconColor", "Color3") then
        return
    end

    -- Description
    macro.Description = macro.Description or "No Description"
    if not validateType(macroScript, macro, true, "Description", "string") then
        return
    end

    -- LayoutOrder
    macro.LayoutOrder = macro.LayoutOrder or 0
    if not validateType(macroScript, macro, false, "LayoutOrder", "number") then
        return
    end

    -- State
    if not validateType(macroScript, macro, false, "State", "table") then
        return
    end
    macro.State = macro.State or {}
    macro.State.IsRunning = false
    macro.State.FieldValues = macro.State.FieldValues or {}
    macro.State.IsKeybindDisabled = false
    macro.State._Server = macro.State._Server or {}
    macro.State._Client = macro.State._Client or {}

    -- EnableAutomaticUndo
    if not validateType(macroScript, macro, false, "EnableAutomaticUndo", "boolean") then
        return
    end

    -- AutoRun
    if not validateType(macroScript, macro, false, "AutoRun", "boolean") then
        return
    end

    -- IgnoreGameProcessedKeybinds
    if not validateType(macroScript, macro, false, "IgnoreGameProcessedKeybinds", "boolean") then
        return
    end

    -- IsLocalMacro
    macro.IsLocalMacro = macroScript:IsDescendantOf(LocalMacros:GetOurDirectory()) and true or false

    -- Keybind
    macro.Keybind = macro.Keybind or {}
    if not validateType(macroScript, macro, false, "Keybind", "table") then
        return
    end
    for _, keyCode in pairs(macro.Keybind) do
        if not keyCode.EnumType == Enum.KeyCode then
            Logger:Warn(
                ("Macro %s `Keybind` must have values of only type `Enum.KeyCode` (%s)"):format(macroScript.Name, macroScript:GetFullName())
            )
            return
        end
    end
    translateKeybindToOs(macro.Keybind)

    -- Fields
    macro.Fields = macro.Fields or {}
    if not validateType(macroScript, macro, false, "Fields", "table") then
        return
    end
    local fieldNames = {}
    for _, field in pairs(macro.Fields) do
        if typeof(field) ~= "table" then
            ("Macro %s `Fields` must contain tables, atleast with entries `Name` and `Type` (%s)"):format(
                macroScript.Name,
                macroScript:GetFullName()
            )
            return
        end

        local fieldName = field.Name
        if not (fieldName and typeof(fieldName) == "string") then
            Logger:Warn(("Macro %s has a field with invalid `Name` (string) (%s)"):format(macroScript.Name, macroScript:GetFullName()))
            return
        end
        if fieldNames[fieldName] then
            Logger:Warn(("Field %q is a duplicate name (%s)"):format(field.Name, macroScript:GetFullName()))
            return
        end

        local fieldTypeId = field.Type
        local fieldType = MacroConstants.FieldType[fieldTypeId]
        if not fieldType then
            Logger:Warn(("Field %q has invalid field type %q (%s)"):format(field.Name, fieldTypeId, macroScript:GetFullName()))
            return
        end

        local isRequired = field.IsRequired
        if isRequired ~= nil and (typeof(isRequired) ~= "boolean") then
            Logger:Warn(
                ("Macro %s has a field with invalid `IsRequired` (boolean) (%s)"):format(macroScript.Name, macroScript:GetFullName())
            )
            return
        end

        local validator = field.Validator
        if validator ~= nil and typeof(validator) ~= "function" then
            Logger:Warn(
                ("Macro %s has a field with invalid `Validator` (function) (%s)"):format(macroScript.Name, macroScript:GetFullName())
            )
            return
        end

        local defaultValue = macro.State.FieldValues[fieldName]
        if defaultValue ~= nil then
            local success, result = pcall(function()
                return MacroConstants.FieldType[fieldTypeId].Validate(defaultValue)
            end)
            if not success or result == nil then
                Logger:Warn(
                    ("Macro %s Field %s has a bad default value set. Field has type %s, default value is %q (%s) (%s)"):format(
                        macroScript.Name,
                        fieldName,
                        fieldTypeId,
                        tostring(defaultValue),
                        tostring(result),
                        macroScript:GetFullName()
                    )
                )
                return
            end
        end

        field.Type = fieldType
    end

    -- FieldChanged Event
    if not validateType(macroScript, macro, false, "FieldChanged", "BindableEvent") then
        return
    end
    macro.FieldChanged = macro.FieldChanged or Instance.new("BindableEvent")

    -- Run Janitor
    if not validateType(macroScript, macro, false, "Janitor", "table") then
        return
    end
    macro.RunJanitor = macro.RunJanitor or Janitor.new()

    -- Functions
    if not validateType(macroScript, macro, false, "ToggleIsRunning", "function") then
        return
    end
    macro.ToggleIsRunning = function(someMacro)
        someMacro.State.IsRunning = not (someMacro.State.IsRunning and true or false)
        someMacro.RunJanitor:Cleanup()
    end

    if not validateType(macroScript, macro, false, "IsRunning", "function") then
        return
    end
    macro.IsRunning = function(someMacro)
        return someMacro.State.IsRunning and true or false
    end

    if not validateType(macroScript, macro, false, "GetFieldValue", "function") then
        return
    end
    macro.GetFieldValue = function(someMacro, fieldName)
        return someMacro.State.FieldValues[fieldName]
    end

    if not validateType(macroScript, macro, true, "Function", "function") then
        return
    end
    if not validateType(macroScript, macro, false, "BindToOpen", "function") then
        return
    end
    if not validateType(macroScript, macro, false, "BindToClose", "function") then
        return
    end
    macro._BindToClose = function(someMacro, plugin)
        if someMacro.BindToClose then
            someMacro.BindToClose(macro, plugin)
        end
        someMacro.State.IsRunning = false
        someMacro.RunJanitor:Cleanup()
    end

    -- Give script reference
    macro._script = macroScript
    macro._isBroken = macro._isBroken or false

    return macro
end

---
---@param macro MacroDefinition
---@param field MacroField
---
function MacroHelper:ClearField(macro, field)
    macro.State.FieldValues[field.Name] = nil
    refreshState()
end

---
---UI has requested to update this field.
---Returns the current value, and true if it was updated.
---@param macro MacroDefinition
---@param field MacroField
---@param text string
---@return any, boolean
---
function MacroHelper:UpdateField(macro, field, text)
    -- Validate value
    local value = field.Type.Validate(text)
    if value == nil then
        -- Validation failed; return stored value.
        local currentValue = macro.State.FieldValues[field.Name]
        return currentValue, false
    end

    -- Update
    macro.State.FieldValues[field.Name] = value
    macro.FieldChanged:Fire(field.Name, value)
    refreshState()
    return value, true
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function MacroHelper:FrameworkInit()
    Logger = PluginFramework:Require("Logger")
    MacroConstants = PluginFramework:Require("MacroConstants")
    SocketController = PluginFramework:Require("SocketController")
    SocketConstants = PluginFramework:Require("SocketConstants")
    PluginHandler = PluginFramework:Require("PluginHandler")
    StudioHandler = PluginFramework:Require("StudioHandler")
    MacroClientServer = PluginFramework:Require("MacroClientServer")
    Janitor = PluginFramework:Require("Janitor")
    SocketSettings = PluginFramework:Require("SocketSettings")
    LocalMacros = PluginFramework:Require("LocalMacros")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function MacroHelper:FrameworkStart() end

return MacroHelper
