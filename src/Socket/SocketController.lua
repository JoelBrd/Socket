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

--------------------------------------------------
-- Constants
local STORE_KEY_PLUGS = "PLUGS"

--------------------------------------------------
-- Members
local runJanitor ---@type Janitor
local isRunning = false

--- Plug files
local plugModuleScripts = {} ---@type table<string, ModuleScript>

--- Rodux Store
local roduxInitialState ---@type RoduxState
local roduxReducer ---@type RoduxReducer
local roduxMiddlewares ---@type RoduxMiddleware[]
local roduxStore = {} ---@type RoduxStore

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
    roduxStore = Rodux.Store.new(roduxReducer, roduxInitialState, roduxMiddlewares)

    -- Setup plugs
    SocketController:SetupPlugManagement()
end

---
---Runs the logic for manipulating our RoduxStore from the Plug files in studio.
---Called once per Run().
---
function SocketController:SetupPlugManagement()
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
                type = SocketConstants.RoduxActionType.UPDATE_PLUG,
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
            type = SocketConstants.RoduxActionType.REMOVE_PLUG,
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
                type = SocketConstants.RoduxActionType.ADD_PLUG,
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
                -- Check if added; may not be added if newPlug() had a bad require call
                print(roduxStore, roduxStore:getState())
                local isAddedToStore = roduxStore:getState()[STORE_KEY_PLUGS][cachedActiveScript] and true or false
                if isAddedToStore then
                    changedPlug(cachedActiveScript)
                else
                    newPlug(cachedActiveScript)
                end
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
end

---
---Creates the global reducer to pass to our rodux store
---@return RoduxReducer
---
function SocketController:CreateReducer()
    local plugsReducer = Rodux.createReducer({}, {
        -- Add; adds a new plug
        [SocketConstants.RoduxActionType.ADD_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local plug = action.data.plug ---@type PlugDefinition
            local moduleScript = action.data.script ---@type ModuleScript

            -- Write to state
            newState[moduleScript] = plug

            return newState
        end,

        -- Update; will overwrite the existing plug but preserves its .State
        [SocketConstants.RoduxActionType.UPDATE_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local plug = action.data.plug ---@type PlugDefinition
            local moduleScript = action.data.script ---@type ModuleScript

            -- Get state of current plug
            local currentPlug = state[moduleScript] ---@type PlugDefinition
            local currentPlugState = currentPlug.State

            -- Update with new plug
            plug.State = currentPlugState
            newState[moduleScript] = plug

            return newState
        end,

        -- Remove; gets rid of the plug!
        [SocketConstants.RoduxActionType.REMOVE_PLUG] = function(state, action)
            -- Rewrite current state (state is read only)
            local newState = {}
            for someModuleScript, somePlug in pairs(state) do
                newState[someModuleScript] = somePlug
            end

            -- Get Data
            local moduleScript = action.data.script ---@type ModuleScript

            -- Remove from state
            newState[moduleScript] = nil

            return newState
        end,
    })

    return Rodux.combineReducers({
        [STORE_KEY_PLUGS] = plugsReducer,
    })
end

---@private
function SocketController:FrameworkInit()
    Janitor = PluginFramework:Require("Janitor")
    Rodux = PluginFramework:Require("Rodux")
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketConstants = PluginFramework:Require("SocketConstants")
    Logger = PluginFramework:Require("Logger")
end

---@private
function SocketController:FrameworkStart()
    runJanitor = Janitor.new()

    -- Rodux Store
    roduxReducer = SocketController:CreateReducer()
    roduxInitialState = nil
    roduxMiddlewares = table.pack(Rodux.loggerMiddleware)
end

return SocketController
