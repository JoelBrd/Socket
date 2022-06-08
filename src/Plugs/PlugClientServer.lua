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
local CLONED_DIRECTORY_FOLDER_NAME = "_SocketDirectoryForClients"

--------------------------------------------------
-- Members
local remoteFunction ---@type RemoteFunction

---
---Call on Server + Client to ensure identical plugs on each
---
function PlugClientServer:RunTransfer()
    -- Send over the plugs+utils to the client
    if IS_SERVER then
        local directoryFolder = StudioHandler.Folders.Directory
        local directoryFolderClone = directoryFolder:Clone()
        directoryFolderClone.Name = CLONED_DIRECTORY_FOLDER_NAME
        directoryFolderClone.Parent = game.ReplicatedStorage
    elseif IS_CLIENT then
        local clonedDirectoryFolder = game.ReplicatedStorage:FindFirstChild(CLONED_DIRECTORY_FOLDER_NAME)
            or game.ReplicatedStorage:WaitForChild(CLONED_DIRECTORY_FOLDER_NAME)

        -- Clear client
        for _, plug in pairs(StudioHandler.Folders.Plugs:GetChildren()) do
            plug:Destroy()
        end
        for _, util in pairs(StudioHandler.Folders.Utils:GetChildren()) do
            util:Destroy()
        end

        -- Populate from server
        for _, util in pairs(clonedDirectoryFolder.Utils:GetChildren()) do
            util.Parent = StudioHandler.Folders.Utils
        end
        for _, plug in pairs(clonedDirectoryFolder.Plugs:GetChildren()) do
            plug.Parent = StudioHandler.Folders.Plugs
        end
        clonedDirectoryFolder:Destroy()
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

    ---@param plugScriptName string
    ---@param plugScriptParentName string
    ---@param plugFieldValues table
    ---@return PlugState
    local function runPlugFromPlugScript(plugScriptName, plugScriptParentName, plugFieldValues)
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

        -- Get Plug
        local plugScript = possiblePlugs[1]
        local plug = SocketController:GetPlug(plugScript)
        if not plug then
            Logger:Warn(("Could not find plug %s internally on invoke"):format(plugScriptName))
        end

        -- Load on our field values
        plug.State.FieldValues = plugFieldValues

        return PlugHelper:RunPlug(plug)
    end

    if IS_SERVER then
        remoteFunction.OnServerInvoke = function(player, plugScriptName, plugScriptParentName, plugFieldValues)
            return runPlugFromPlugScript(plugScriptName, plugScriptParentName, plugFieldValues)
        end
    elseif IS_CLIENT then
        remoteFunction.OnClientInvoke = function(plugScriptName, plugScriptParentName, plugFieldValues)
            return runPlugFromPlugScript(plugScriptName, plugScriptParentName, plugFieldValues)
        end
    end
end

---
---@param player Player
---@param plug PlugDefinition
---@return PlugState
---
function PlugClientServer:RunPlugOnClient(player, plug)
    return remoteFunction:InvokeClient(player, plug._script.Name, plug._script.Parent.Name, plug.State.FieldValues)
end

---
---@param plug PlugDefinition
---@return PlugState
---
function PlugClientServer:RunPlugOnServer(plug)
    return remoteFunction:InvokeServer(plug._script.Name, plug._script.Parent.Name, plug.State.FieldValues)
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
