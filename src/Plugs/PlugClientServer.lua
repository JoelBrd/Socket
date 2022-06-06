---
---Handles server/client communication when running
---
---@class PlugClientServer
---
local PlugClientServer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local RunService = game:GetService("RunService") ---@type RunService
local StudioHandler ---@type StudioHandler
local Logger ---@type Logger
local SocketController ---@type SocketController
local PlugHelper ---@type PlugHelper

--------------------------------------------------
-- Constants
local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()
local REMOTE_FUNCTION_NAME = "SocketPluginRemoteFunction"
local CLONED_PLUGS_FOLDER_NAME = "_SocketPlugsForClients"

--------------------------------------------------
-- Members
local remoteFunction ---@type RemoteFunction

---
---Call on Server + Client to ensure identical plugs on each
---
function PlugClientServer:RunTransfer()
    -- Send over the plugs to the client
    if IS_SERVER then
        local plugsFolder = StudioHandler.Folders.Plugs
        local plugsFolderClone = plugsFolder:Clone()
        plugsFolderClone.Name = CLONED_PLUGS_FOLDER_NAME
        plugsFolderClone.Parent = game.ReplicatedStorage
    elseif IS_CLIENT then
        local clonedPlugsFolder = game.ReplicatedStorage:FindFirstChild(CLONED_PLUGS_FOLDER_NAME)
            or game.ReplicatedStorage:WaitForChild(CLONED_PLUGS_FOLDER_NAME)

        -- Clear client
        for _, child in pairs(StudioHandler.Folders.Plugs:GetChildren()) do
            child:Destroy()
        end

        -- Populate from server
        for _, child in pairs(clonedPlugsFolder:GetChildren()) do
            child.Parent = StudioHandler.Folders.Plugs
        end
        clonedPlugsFolder:Destroy()
    end
end

---
---Call on Server + Client to setup remote functions
---
function PlugClientServer:SetupCommunication()
    -- Setup remote function
    remoteFunction = game.ReplicatedStorage:FindFirstChild(REMOTE_FUNCTION_NAME)
    if not remoteFunction then
        remoteFunction = Instance.new("RemoteFunction") ---@type RemoteFunction
        remoteFunction.Name = REMOTE_FUNCTION_NAME
        remoteFunction.Parent = game.ReplicatedStorage
    end

    -- Callback
    ---@param plugScript ModuleScript
    local function runPlugFromPlugScript(plugScriptName, plugScriptParentName)
        -- Try find plug from this
        local plugDirectory = StudioHandler.Folders.Plugs

        -- Grab Possible plugs
        local possiblePlugs = {}
        for _, descendant in pairs(plugDirectory:GetDescendants()) do
            local isPossiblePlug = descendant.Name == plugScriptName
                and descendant.Parent.Name == plugScriptParentName
                and not descendant.Parent:IsA("ModuleScript")
            if isPossiblePlug then
                table.insert(possiblePlugs, descendant)
            end
        end

        -- RETURN: No plugs found
        local totalPossiblePlugs = #possiblePlugs
        if totalPossiblePlugs == 0 then
            Logger:Warn(("Could not find plug the plug to invoke (%s)"):format(plugScriptName))
            return
        end

        -- RETURN: More than 1 plug found
        if totalPossiblePlugs > 1 then
            Logger:Warn(
                (
                    "Found multiple plugs of name %s in directory %s. Please chooose more unique names to be able to invoke across server/client"
                ):format(plugScriptName, plugScriptParentName)
            )
            return
        end

        -- Run!
        local plugScript = possiblePlugs[1]
        local plug = SocketController:GetPlug(plugScript)
        if not plug then
            Logger:Warn(("Could not find plug %s internally on invoke"):format(plugScriptName))
        end

        PlugHelper:RunPlug(plug)
    end

    if IS_SERVER then
        remoteFunction.OnServerInvoke = function(player, plugScriptName, plugScriptParentName)
            runPlugFromPlugScript(plugScriptName, plugScriptParentName)
        end
    elseif IS_CLIENT then
        remoteFunction.OnClientInvoke = function(plugScriptName, plugScriptParentName)
            runPlugFromPlugScript(plugScriptName, plugScriptParentName)
        end
    end
end

---
---@param player Player
---@param plugScriptName string
---@param plugScriptParentName string
---
function PlugClientServer:RunPlugOnClient(player, plugScriptName, plugScriptParentName)
    remoteFunction:InvokeServer(player, plugScriptName, plugScriptParentName)
end

---
---@param plugScriptName string
---@param plugScriptParentName string
---
function PlugClientServer:RunPlugOnServer(plugScriptName, plugScriptParentName)
    remoteFunction:InvokeServer(plugScriptName, plugScriptParentName)
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function PlugClientServer:FrameworkInit()
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketController = PluginFramework:Require("SocketController")
    Logger = PluginFramework:Require("Logger")
    PlugHelper = PluginFramework:Require("PlugHelper")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function PlugClientServer:FrameworkStart()
    -- TODO Logic here
end

return PlugClientServer
