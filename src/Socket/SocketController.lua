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

--------------------------------------------------
-- Constants
-- ...

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

    -- Setup rodux store actions
    SocketController:SetupPlugActions()
    SocketController:SetupSettingsActions()

    -- Tell the widget handler its go time
    WidgetHandler:Run()

    -- Setup Keybind listener
    SocketController:SetupKeybindHooks()
end

---
---@return RoduxStore
---
function SocketController:GetStore()
    return roduxStore
end

---
---Returns the current theme of studio, and hence socket.
---Either `Light` or `Dark`
---@return string
---
function SocketController:GetTheme()
    local themeName = settings().Studio.Theme.Name
    return themeName == "Dark" and "Dark" or "Light"
end

---
---Will read this setting from our current store
---@param settingName string
---@return any
---
function SocketController:GetSetting(settingName)
    local settings = SocketController:GetStore():getState()[SocketConstants.RoduxStoreKey.SETTINGS].Settings

    -- ERROR: Bad setting name
    local settingValue = settings[settingName]
    if settingValue == nil then
        Logger:Error(("No setting %q"):format(settingName))
    end

    return settingValue
end

---
---@param plug PlugDefinition
---
function SocketController:RunPlug(plug)
    plug.Function()
end

---
---@param plug PlugDefinition
---
function SocketController:ShowDescription(plug)
    local descriptionHolderString = ("================ %s (%s) | DESCRIPTION ================"):format(plug.Name, plug.Group)
    print("\n", descriptionHolderString, "\n\n", plug.Description, "\n\n", descriptionHolderString)
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

---Will clean up a plug definiton direct from require().
---Injects expected data structures.
---Ensures inputted data is valid.
---Warns of any issues.
---@param plug PlugDefinition
---@return PlugDefinition
local function cleanPlugDefinition(plug)
    -- PlugFields
    for _, field in pairs(plug.Fields) do
        local fieldTypeId = field.Type
        local fieldType = PlugConstants.FieldType[fieldTypeId]
        if not fieldType then
            Logger:Warn(("Field %q has invalid field type %q (%s)"):format(field.Name, fieldTypeId, plug.Name))
            return
        end
        field.Type = fieldType
    end

    --todo more validation checks!!

    return plug
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
        local plugDefinition = requiredClone and cleanPlugDefinition(requiredClone)
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
        end
    end

    ---Applies changes to our store after a plug has been removed
    ---@param moduleScript ModuleScript
    local function removedPlug(moduleScript)
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
        local plugDefinition = requiredClone and cleanPlugDefinition(requiredClone)
        if plugDefinition then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.PLUGS.ADD_PLUG,
                data = {
                    plug = plugDefinition,
                    script = moduleScript,
                },
            }
            roduxStore:dispatch(action)
        end
    end

    -- Grab the plugs already sitting there
    local plugsFolder = StudioHandler.Folders.Plugs
    for _, descendant in pairs(plugsFolder:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            newPlug(descendant)
        end
    end

    -- Hook up listener events for plug files being added/removed
    runJanitor:Add(plugsFolder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            newPlug(descendant)
        end
    end))

    runJanitor:Add(plugsFolder.DescendantRemoving:Connect(function(descendant)
        if descendant:IsA("ModuleScript") then
            removedPlug(descendant)
        end
    end))

    -- Listener to the user viewing different scripts; used to trigger "plug changed" events
    local cachedActiveScript ---@type Instance
    runJanitor:Add(StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
        local activeScript = StudioService.ActiveScript

        -- Have we just exited a script file?
        if cachedActiveScript then
            local isPlugScript = cachedActiveScript:IsDescendantOf(plugsFolder)
            if isPlugScript then
                -- Search for plug
                local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.PLUGS].Groups
                for _, groupInfo in pairs(groups) do
                    for plugScript, _ in pairs(groupInfo.Plugs) do
                        if plugScript == cachedActiveScript then
                            -- Changed
                            changedPlug(cachedActiveScript)

                            -- Update cache
                            cachedActiveScript = activeScript
                            return
                        end
                    end
                end

                -- Wasn't in memory
                newPlug(cachedActiveScript)
            end
        end

        -- Update cache
        cachedActiveScript = activeScript
    end))
end

---
---Runs the logic for manipulating our RoduxStore from the settings file in Studio
---Called once per Run().
---
function SocketController:SetupSettingsActions()
    ---Put our current settings into the store
    ---@param settingsFile ModuleScript
    local function update(settingsFile)
        local requiredClone = tryCloneRequire(settingsFile)
        if requiredClone then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.SETTINGS.UPDATE,
                data = {
                    settings = requiredClone,
                },
            }
            roduxStore:dispatch(action)
        end
    end

    -- Grab settings file
    local settingsFile = StudioHandler:GetSettingsScript()
    update(settingsFile)

    -- Listener to the user viewing different scripts; used to trigger our update action
    local cachedActiveScript ---@type Instance
    runJanitor:Add(StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
        local activeScript = StudioService.ActiveScript

        -- Have we just exited a script file?
        if cachedActiveScript then
            if cachedActiveScript == settingsFile then
                update(settingsFile)
            end
        end

        -- Update cache
        cachedActiveScript = activeScript
    end))
end

---
---Listens to users input to detect whether to run plugs via keybind
---
function SocketController:SetupKeybindHooks()
    -- Track keys being held down
    local heldKeys = {} ---@type Enum.KeyCode

    ---@param inputObject InputObject
    ---@param gameProcessedEvent boolean
    local function inputBegan(inputObject, gameProcessedEvent)
        -- RETURN: Game processed
        if gameProcessedEvent then
            return
        end

        table.insert(heldKeys, inputObject.KeyCode)

        -- Does this equate a keybind?
        local state = roduxStore:getState()
        local groups = state[SocketConstants.RoduxStoreKey.PLUGS].Groups
        for _, groupInfo in pairs(groups) do
            for _, plugInfo in pairs(groupInfo.Plugs) do
                local plug = plugInfo.Plug ---@type PlugDefinition

                -- See if we have all held keys in this plug
                local totalKeyCodes = #plug.Keybind
                local hasKeybind = totalKeyCodes and totalKeyCodes > 0
                if hasKeybind then
                    local matchingKeyCodes = 0
                    for _, someKeyCode in pairs(plug.Keybind) do
                        if table.find(heldKeys, someKeyCode) then
                            matchingKeyCodes = matchingKeyCodes + 1
                        end
                    end

                    -- Huzzah!
                    if totalKeyCodes == matchingKeyCodes then
                        -- Clear held keys
                        heldKeys = {}

                        -- Run Plug Function
                        SocketController:RunPlug(plug)

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
        -- RETURN: Game processed
        if gameProcessedEvent then
            return
        end

        local index = table.find(heldKeys, inputObject.KeyCode)
        if index then
            table.remove(heldKeys, index)
        end
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
end

---@private
function SocketController:FrameworkStart()
    runJanitor = Janitor.new()
end

return SocketController
