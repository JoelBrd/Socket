---
---The main script for running Socket (when the player has "activated" the plugin + has the widget window open)
---
---@class SocketController
---
local SocketController = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local RunService = game:GetService("RunService") ---@type RunService
local Studio = settings().Studio ---@type Studio
local StudioService = game:GetService("StudioService") ---@type StudioService
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Janitor ---@type Janitor
local Rodux ---@type Rodux
local StudioHandler ---@type StudioHandler
local SocketConstants ---@type SocketConstants
local Logger ---@type Logger
local SocketRoduxStoreController ---@type SocketRoduxStoreController
local WidgetHandler ---@type WidgetHandler
local MacroConstants ---@type MacroConstants
local MacroHelper ---@type MacroHelper
local MacroClientServer ---@type MacroClientServer
local SocketSettings ---@type SocketSettings
local PluginHandler ---@type PluginHandler
local InstanceUtil ---@type InstanceUtil

--------------------------------------------------
-- Constants
local IS_RUNNING = RunService:IsRunning()

--------------------------------------------------
-- Members
local roduxStore ---@type RoduxStore
local runJanitor ---@type Janitor
local isRunning = false ---@type boolean

---
---Runs necessary routines when Socket gets activated
---
function SocketController:Run()
    -- RETURN: Already running
    if isRunning then
        return
    end
    isRunning = true

    -- Init store
    roduxStore = SocketRoduxStoreController:GetRoduxStore()

    -- Setup settings
    SocketSettings:ValidateSettings()

    -- Cleanup any instances from a bad shutdown
    InstanceUtil:Cleanup()

    -- Setup rodux store actions
    SocketController:SetupStudioActions()
    SocketController:SetupMacroActions()

    -- Tell the widget handler its go time
    WidgetHandler:Run()

    -- Setup Keybind listener
    SocketController:SetupKeybindHooks()

    -- One time server/client setup
    if IS_RUNNING then
        MacroClientServer:RunTransfer()
        MacroClientServer:SetupCommunication()
    end

    -- Bind to open on our macros
    local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.MACROS].Groups
    for _, groupInfo in pairs(groups) do
        for _, macroInfo in pairs(groupInfo.Macros) do
            local macro = macroInfo.Macro ---@type MacroDefinition
            if macro.BindToOpen then
                macro.BindToOpen(macro, PluginHandler:GetPlugin())
            end
        end
    end
end

---
---@return Janitor
---
function SocketController:GetRunJanitor()
    return runJanitor
end

---
---@return RoduxStore
---
function SocketController:GetStore()
    return roduxStore
end

---
---Gets the currently stored MacroDefiniton from the passed macroScript
---@param macroScript ModuleScript
---@return MacroDefinition
---
function SocketController:GetMacro(macroScript)
    for _, groupInfo in pairs(roduxStore:getState()[SocketConstants.RoduxStoreKey.MACROS].Groups) do
        for someMacroScript, someMacroInfo in pairs(groupInfo.Macros) do
            if someMacroScript == macroScript then
                return someMacroInfo.Macro
            end
        end
    end
end

---
---@return boolean
---
function SocketController:IsRunning()
    return SocketController:GetStore():getState()[SocketConstants.RoduxStoreKey.STUDIO].IsRunning
end

---Will try require the current state of the passed moduleScript, by using a clone.
---@param moduleScript ModuleScript
---@return table|nil
local function tryCloneRequire(moduleScript)
    -- Get clone + try require
    local clone = moduleScript:Clone()
    runJanitor:Add(clone)

    local requiredClone ---@type table
    local requireSuccess, err = pcall(function()
        requiredClone = require(clone)
    end)

    -- Response
    if requireSuccess then
        return requiredClone
    else
        Logger:Warn(("Encountered issue while managing file %q  -  (%s)"):format(moduleScript.Name, err))
    end
end

---
---Runs the logic for manipulating our RoduxStore from the Macro files in studio.
---Called once per Run().
---
function SocketController:SetupMacroActions()
    ---Applies changes to our store after a macro has been changed
    ---@param moduleScript ModuleScript
    local function changedMacro(moduleScript)
        local requiredClone = tryCloneRequire(moduleScript)
        local macroDefinition = requiredClone and MacroHelper:CleanMacroDefinition(moduleScript, requiredClone)
        if macroDefinition then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.MACROS.UPDATE_MACRO,
                data = {
                    macro = macroDefinition,
                    script = moduleScript,
                },
            }
            roduxStore:dispatch(action)
        else
            -- Had an issue; the user has likely done something wrong
            local currentMacroDefinition = SocketController:GetMacro(moduleScript)
            if currentMacroDefinition then
                currentMacroDefinition._isBroken = true

                -- Update RoduxStore
                ---@type RoduxAction
                local action = {
                    type = SocketConstants.RoduxActionType.MACROS.UPDATE_MACRO,
                    data = {
                        macro = currentMacroDefinition,
                        script = moduleScript,
                    },
                }
                roduxStore:dispatch(action)
            end
        end
    end

    ---Applies changes to our store after a macro has been removed
    ---@param moduleScript ModuleScript
    local function removedMacro(moduleScript)
        -- Run Bind to close
        local macro = SocketController:GetMacro(moduleScript)
        macro._BindToClose(macro, PluginHandler:GetPlugin())

        -- Update RoduxStore
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.MACROS.REMOVE_MACRO,
            data = {
                script = moduleScript,
            },
        }
        roduxStore:dispatch(action)
    end

    ---Applies changes to our store after a macro has been added
    ---@param moduleScript ModuleScript
    local function newMacro(moduleScript)
        local requiredClone = tryCloneRequire(moduleScript)
        local macroDefinition = requiredClone and MacroHelper:CleanMacroDefinition(moduleScript, requiredClone)
        if macroDefinition then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.MACROS.ADD_MACRO,
                data = {
                    macro = macroDefinition,
                    script = moduleScript,
                    isFieldsOpen = SocketSettings:GetSetting("OpenFieldsByDefault"),
                },
            }
            roduxStore:dispatch(action)

            -- Auto run?
            local doRun = macroDefinition.AutoRun and SocketSettings:GetSetting("EnableAutoRun")
            if doRun then
                MacroHelper:RunMacro(macroDefinition)
            end
        end
    end

    ---Returns true if this macroScript is added to our store
    ---@param macroScript ModuleScript
    ---@return boolean
    local function isMacroScriptAdded(macroScript)
        local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.MACROS].Groups
        for _, groupInfo in pairs(groups) do
            for someMacroScript, _ in pairs(groupInfo.Macros) do
                if someMacroScript == macroScript then
                    return true
                end
            end
        end

        return false
    end

    -- Variables for tracking macro scripts
    local cachedActiveScript ---@type Instance
    local macrosFolder = StudioHandler.Folders.Macros

    ---Had a new module script added that is likely a macro
    ---@param macroScript ModuleScript
    local function newMacroScript(macroScript)
        -- RETURN: Parent is a module script
        if macroScript.Parent:IsA("ModuleScript") then
            return
        end

        newMacro(macroScript)

        -- Listen for source changes to update macro
        runJanitor:Add(macroScript.Changed:Connect(function(property)
            if property == "Source" and cachedActiveScript ~= macroScript then
                if isMacroScriptAdded(macroScript) then
                    -- Changed
                    changedMacro(macroScript)
                else
                    -- Wasn't in memory
                    newMacro(macroScript)
                end
            end
        end))
    end

    -- Grab the macros already sitting there
    for _, descendant in pairs(macrosFolder:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            newMacroScript(descendant)
        end
    end

    -- Hook up listener events for macro files being added/removed
    runJanitor:Add(macrosFolder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            task.wait() -- May have been added through a Rojo Sync
            newMacroScript(descendant)
        end
    end))

    runJanitor:Add(macrosFolder.DescendantRemoving:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            if isMacroScriptAdded(descendant) then
                removedMacro(descendant)
            end
        end
    end))

    -- Listener to the user viewing different scripts; used to trigger "macro changed" events
    runJanitor:Add(StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
        local activeScript = StudioService.ActiveScript

        -- Have we just exited a script file?
        if cachedActiveScript then
            local isMacroScript = cachedActiveScript:IsDescendantOf(macrosFolder)
            if isMacroScript then
                if isMacroScriptAdded(cachedActiveScript) then
                    -- Changed
                    changedMacro(cachedActiveScript)
                else
                    -- Wasn't in memory
                    newMacroScript(cachedActiveScript)
                end
            end
        end

        -- Update cache
        cachedActiveScript = activeScript
    end))
end

---
---Runs the logic for manipulating our RoduxStore, reading from the Studio service
---Called once per Run().
---
function SocketController:SetupStudioActions()
    -- Theme
    local function setTheme()
        -- Used to update the store.. now just refresh the widget
        WidgetHandler:Refresh()
    end

    setTheme()
    runJanitor:Add(Studio.ThemeChanged:Connect(setTheme))

    -- Is Running
    -- Update RoduxStore
    ---@type RoduxAction
    local action = {
        type = SocketConstants.RoduxActionType.STUDIO.IS_RUNNING,
        data = {
            isRunning = RunService:IsRunning(),
        },
    }
    SocketController:GetStore():dispatch(action)
end

---
---Listens to users input to detect whether to run macros via keybind
---
function SocketController:SetupKeybindHooks()
    -- Track keys being held down
    local heldKeys = {} ---@type table<Enum.KeyCode, boolean>

    ---@param inputObject InputObject
    ---@param gameProcessedEvent boolean
    local function inputBegan(inputObject, gameProcessedEvent)
        -- Grab setting
        local doIgnoreGameProcessedKeybinds = SocketSettings:GetSetting("IgnoreGameProcessedKeybinds")

        -- Record keypress
        heldKeys[inputObject.KeyCode] = gameProcessedEvent

        -- Does this equate a keybind?
        local state = roduxStore:getState()
        local groups = state[SocketConstants.RoduxStoreKey.MACROS].Groups
        for _, groupInfo in pairs(groups) do
            for _, macroInfo in pairs(groupInfo.Macros) do
                local macro = macroInfo.Macro ---@type MacroDefinition

                -- See if we have all held keys in this macro
                local totalKeyCodes = #macro.Keybind
                local hasKeybind = totalKeyCodes > 0
                if hasKeybind then
                    local matchingKeyCodes = 0
                    local allowGameProcessedEventKeyCodes = doIgnoreGameProcessedKeybinds or macro.IgnoreGameProcessedKeybinds
                    for _, someKeyCode in pairs(macro.Keybind) do
                        if heldKeys[someKeyCode] == false or heldKeys[someKeyCode] and allowGameProcessedEventKeyCodes then
                            matchingKeyCodes = matchingKeyCodes + 1
                        end
                    end

                    -- Huzzah!
                    local isMatchingKeybind = totalKeyCodes == matchingKeyCodes
                    local hasKeybindEnabled = not macro.State.IsKeybindDisabled
                    if isMatchingKeybind and hasKeybindEnabled then
                        -- Run Macro Function
                        MacroHelper:RunMacro(macro)

                        -- Clear heldKeys
                        heldKeys = {}

                        -- Stop
                        return
                    end
                end
            end
        end
    end

    ---@param inputObject InputObject
    ---@param gameProcessedEvent boolean
    local function inputEnded(inputObject, gameProcessedEvent)
        heldKeys[inputObject.KeyCode] = nil
    end

    runJanitor:Add(UserInputService.InputBegan:Connect(inputBegan))
    runJanitor:Add(UserInputService.InputEnded:Connect(inputEnded))
end

---
---Runs necessary routines when Socket gets deactivated
---
function SocketController:Stop()
    -- RETURN: Not running
    if not isRunning then
        return
    end
    isRunning = false

    -- Bind to close on our macros
    local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.MACROS].Groups
    for _, groupInfo in pairs(groups) do
        for _, macroInfo in pairs(groupInfo.Macros) do
            local macro = macroInfo.Macro ---@type MacroDefinition
            macro._BindToClose(macro, PluginHandler:GetPlugin())
        end
    end

    -- Cleanup Instances
    InstanceUtil:Cleanup()

    -- Clear Janitor
    runJanitor:Cleanup()

    -- Clear cache
    roduxStore = nil

    -- Widget handler bye
    WidgetHandler:Stop()
end

---@private
function SocketController:FrameworkInit()
    Janitor = PluginFramework:Require("Janitor")
    Rodux = PluginFramework:Require("Rodux")
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketConstants = PluginFramework:Require("SocketConstants")
    Logger = PluginFramework:Require("Logger")
    SocketRoduxStoreController = PluginFramework:Require("SocketRoduxStoreController")
    WidgetHandler = PluginFramework:Require("WidgetHandler")
    MacroConstants = PluginFramework:Require("MacroConstants")
    MacroHelper = PluginFramework:Require("MacroHelper")
    MacroClientServer = PluginFramework:Require("MacroClientServer")
    SocketSettings = PluginFramework:Require("SocketSettings")
    PluginHandler = PluginFramework:Require("PluginHandler")
    InstanceUtil = PluginFramework:Require("InstanceUtil")
end

---@private
function SocketController:FrameworkStart()
    runJanitor = Janitor.new()
end

return SocketController
