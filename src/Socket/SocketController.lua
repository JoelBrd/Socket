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
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Janitor ---@type Janitor
local Rodux ---@type Rodux
local StudioHandler ---@type StudioHandler
local SocketConstants ---@type SocketConstants
local Logger ---@type Logger
local SocketRoduxStoreController ---@type SocketRoduxStoreController
local WidgetHandler ---@type WidgetHandler

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

    -- Setup plugs to populate store
    SocketController:SetupPlugActions()

    -- Tell the widget handler its go time
    WidgetHandler:Run()
end

---
---@return RoduxStore
---
function SocketController:GetStore()
    return roduxStore
end

---
---Runs the logic for manipulating our RoduxStore from the Plug files in studio.
---Called once per Run().
---
function SocketController:SetupPlugActions()
    ---Will try require the current state of the passed moduleScript, by using a clone.
    ---@param moduleScript ModuleScript
    ---@return table|nil
    local function tryCloneRequire(moduleScript)
        -- Get clone + try require
        local clone = moduleScript:Clone()
        local requiredClone ---@type table
        local requireSuccess, err = pcall(function()
            requiredClone = require(clone)
        end)

        -- Response
        if requireSuccess then
            runJanitor:Add(clone)
            return requiredClone
        else
            Logger:Info(("Encountered issue while managing plug file %q  -  (%s)"):format(moduleScript.Name, err))
        end
    end

    ---Applies changes to our store after a plug has been changed
    ---@param moduleScript ModuleScript
    local function changedPlug(moduleScript)
        local requiredClone = tryCloneRequire(moduleScript)
        if requiredClone then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.WIDGET.UPDATE_PLUG,
                data = {
                    plug = requiredClone,
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
            type = SocketConstants.RoduxActionType.WIDGET.REMOVE_PLUG,
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
        if requiredClone then
            -- Update RoduxStore
            ---@type RoduxAction
            local action = {
                type = SocketConstants.RoduxActionType.WIDGET.ADD_PLUG,
                data = {
                    plug = requiredClone,
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
                local groups = roduxStore:getState()[SocketConstants.RoduxStoreKey.WIDGET].Groups
                for _, groupInfo in pairs(groups) do
                    for plugScript, _ in pairs(groupInfo.Plugs) do
                        if plugScript == cachedActiveScript then
                            changedPlug(cachedActiveScript)
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
end

---@private
function SocketController:FrameworkStart()
    runJanitor = Janitor.new()
end

return SocketController
