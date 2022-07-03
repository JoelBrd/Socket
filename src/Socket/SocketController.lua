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
local PlugConstants ---@type PlugConstants
local PlugHelper ---@type PlugHelper
local PlugClientServer ---@type PlugClientServer
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
    SocketController:SetupPlugActions()

    -- Tell the widget handler its go time
    WidgetHandler:Run()

    -- Setup Keybind listener
    SocketController:SetupKeybindHooks()

    -- One time server/client setup
    if IS_RUNNING then
        PlugClientServer:RunTransfer()
        PlugClientServer:SetupCommunication()
    end

    -- Bind to open on our plugs
    local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.PLUGS].Groups
    for _, groupInfo in pairs(groups) do
        for _, plugInfo in pairs(groupInfo.Plugs) do
            local plug = plugInfo.Plug ---@type PlugDefinition
            if plug.BindToOpen then
                plug.BindToOpen(plug, PluginHandler:GetPlugin())
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
---Gets the currently stored PlugDefiniton from the passed plugScript
---@param plugScript ModuleScript
---@return PlugDefinition
---
function SocketController:GetPlug(plugScript)
    for _, groupInfo in pairs(roduxStore:getState()[SocketConstants.RoduxStoreKey.PLUGS].Groups) do
        for somePlugScript, somePlugInfo in pairs(groupInfo.Plugs) do
            if somePlugScript == plugScript then
                return somePlugInfo.Plug
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
---Runs the logic for manipulating our RoduxStore from the Plug files in studio.
---Called once per Run().
---
function SocketController:SetupPlugActions()
    ---Applies changes to our store after a plug has been changed
    ---@param moduleScript ModuleScript
    local function changedPlug(moduleScript)
        local requiredClone = tryCloneRequire(moduleScript)
        local plugDefinition = requiredClone and PlugHelper:CleanPlugDefinition(moduleScript, requiredClone)
        if plugDefinition then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.PLUGS.UPDATE_PLUG,
                data = {
                    plug = plugDefinition,
                    script = moduleScript,
                },
            }
            roduxStore:dispatch(action)
        else
            -- Had an issue; the user has likely done something wrong
            local currentPlugDefinition = SocketController:GetPlug(moduleScript)
            if currentPlugDefinition then
                currentPlugDefinition._isBroken = true

                -- Update RoduxStore
                ---@type RoduxAction
                local action = {
                    type = SocketConstants.RoduxActionType.PLUGS.UPDATE_PLUG,
                    data = {
                        plug = currentPlugDefinition,
                        script = moduleScript,
                    },
                }
                roduxStore:dispatch(action)
            end
        end
    end

    ---Applies changes to our store after a plug has been removed
    ---@param moduleScript ModuleScript
    local function removedPlug(moduleScript)
        -- Run Bind to close
        local plug = SocketController:GetPlug(moduleScript)
        plug._BindToClose(plug, PluginHandler:GetPlugin())

        -- Update RoduxStore
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.PLUGS.REMOVE_PLUG,
            data = {
                script = moduleScript,
            },
        }
        roduxStore:dispatch(action)
    end

    ---Applies changes to our store after a plug has been added
    ---@param moduleScript ModuleScript
    local function newPlug(moduleScript)
        local requiredClone = tryCloneRequire(moduleScript)
        local plugDefinition = requiredClone and PlugHelper:CleanPlugDefinition(moduleScript, requiredClone)
        if plugDefinition then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.PLUGS.ADD_PLUG,
                data = {
                    plug = plugDefinition,
                    script = moduleScript,
                    isFieldsOpen = SocketSettings:GetSetting("OpenFieldsByDefault"),
                },
            }
            roduxStore:dispatch(action)

            -- Auto run?
            local doRun = plugDefinition.AutoRun and SocketSettings:GetSetting("EnableAutoRun")
            if doRun then
                PlugHelper:RunPlug(plugDefinition)
            end
        end
    end

    ---Returns true if this plugScript is added to our store
    ---@param plugScript ModuleScript
    ---@return boolean
    local function isPlugScriptAdded(plugScript)
        local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.PLUGS].Groups
        for _, groupInfo in pairs(groups) do
            for somePlugScript, _ in pairs(groupInfo.Plugs) do
                if somePlugScript == plugScript then
                    return true
                end
            end
        end

        return false
    end

    -- Variables for tracking plug scripts
    local cachedActiveScript ---@type Instance
    local plugsFolder = StudioHandler.Folders.Plugs

    ---Had a new module script added that is likely a plug
    ---@param plugScript ModuleScript
    local function newPlugScript(plugScript)
        -- RETURN: Parent is a module script
        if plugScript.Parent:IsA("ModuleScript") then
            return
        end

        newPlug(plugScript)

        -- Listen for source changes to update plug
        runJanitor:Add(plugScript.Changed:Connect(function(property)
            if property == "Source" and cachedActiveScript ~= plugScript then
                if isPlugScriptAdded(plugScript) then
                    -- Changed
                    changedPlug(plugScript)
                else
                    -- Wasn't in memory
                    newPlug(plugScript)
                end
            end
        end))
    end

    -- Grab the plugs already sitting there
    for _, descendant in pairs(plugsFolder:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            newPlugScript(descendant)
        end
    end

    -- Hook up listener events for plug files being added/removed
    runJanitor:Add(plugsFolder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            task.wait() -- May have been added through a Rojo Sync
            newPlugScript(descendant)
        end
    end))

    runJanitor:Add(plugsFolder.DescendantRemoving:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            if isPlugScriptAdded(descendant) then
                removedPlug(descendant)
            end
        end
    end))

    -- Listener to the user viewing different scripts; used to trigger "plug changed" events
    runJanitor:Add(StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
        local activeScript = StudioService.ActiveScript

        -- Have we just exited a script file?
        if cachedActiveScript then
            local isPlugScript = cachedActiveScript:IsDescendantOf(plugsFolder)
            if isPlugScript then
                if isPlugScriptAdded(cachedActiveScript) then
                    -- Changed
                    changedPlug(cachedActiveScript)
                else
                    -- Wasn't in memory
                    newPlugScript(cachedActiveScript)
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
---Listens to users input to detect whether to run plugs via keybind
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
        local groups = state[SocketConstants.RoduxStoreKey.PLUGS].Groups
        for _, groupInfo in pairs(groups) do
            for _, plugInfo in pairs(groupInfo.Plugs) do
                local plug = plugInfo.Plug ---@type PlugDefinition

                -- See if we have all held keys in this plug
                local totalKeyCodes = #plug.Keybind
                local hasKeybind = totalKeyCodes > 0
                if hasKeybind then
                    local matchingKeyCodes = 0
                    local allowGameProcessedEventKeyCodes = doIgnoreGameProcessedKeybinds or plug.IgnoreGameProcessedKeybinds
                    for _, someKeyCode in pairs(plug.Keybind) do
                        if heldKeys[someKeyCode] == false or heldKeys[someKeyCode] and allowGameProcessedEventKeyCodes then
                            matchingKeyCodes = matchingKeyCodes + 1
                        end
                    end

                    -- Huzzah!
                    if totalKeyCodes == matchingKeyCodes then
                        -- Run Plug Function
                        PlugHelper:RunPlug(plug)

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

    -- Bind to close on our plugs
    local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.PLUGS].Groups
    for _, groupInfo in pairs(groups) do
        for _, plugInfo in pairs(groupInfo.Plugs) do
            local plug = plugInfo.Plug ---@type PlugDefinition
            plug._BindToClose(plug, PluginHandler:GetPlugin())
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
    PlugConstants = PluginFramework:Require("PlugConstants")
    PlugHelper = PluginFramework:Require("PlugHelper")
    PlugClientServer = PluginFramework:Require("PlugClientServer")
    SocketSettings = PluginFramework:Require("SocketSettings")
    PluginHandler = PluginFramework:Require("PluginHandler")
    InstanceUtil = PluginFramework:Require("InstanceUtil")
end

---@private
function SocketController:FrameworkStart()
    runJanitor = Janitor.new()
end

return SocketController
