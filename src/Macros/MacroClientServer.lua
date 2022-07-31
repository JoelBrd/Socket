---
---Handles server/client communication when running
---
---@class MacroClientServer
---
local MacroClientServer = {}

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
local MacroHelper ---@type MacroHelper
local InstanceUtil ---@type InstanceUtil

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
---Call on Server + Client to ensure identical macros on each
---
function MacroClientServer:RunTransfer()
    -- Send over the macros+utils to the client
    if IS_SERVER then
        local directoryFolder = StudioHandler.Folders.Directory
        local directoryFolderClone = directoryFolder:Clone()
        directoryFolderClone.Name = CLONED_DIRECTORY_FOLDER_NAME
        directoryFolderClone.Parent = game.ReplicatedStorage
    elseif IS_CLIENT then
        local clonedDirectoryFolder = InstanceUtil:WaitForChild(game.ReplicatedStorage, CLONED_DIRECTORY_FOLDER_NAME) ---@type Folder

        -- Clear client
        for _, child in pairs(StudioHandler.Folders.Macros:GetChildren()) do
            child:Destroy()
        end
        for _, child in pairs(StudioHandler.Folders.LocalMacros:GetChildren()) do
            child:Destroy()
        end
        for _, child in pairs(StudioHandler.Folders.Utils:GetChildren()) do
            child:Destroy()
        end

        -- Populate from server
        for _, child in pairs(clonedDirectoryFolder.Utils:GetChildren()) do
            child.Parent = StudioHandler.Folders.Utils
        end
        for _, child in pairs(clonedDirectoryFolder.Macros:GetChildren()) do
            child.Parent = StudioHandler.Folders.Macros
        end
        for _, child in pairs(clonedDirectoryFolder.LocalMacros:GetChildren()) do
            child.Parent = StudioHandler.Folders.LocalMacros
        end
        clonedDirectoryFolder:Destroy()
    end
end

---
---Call on Server + Client to setup remote functions
---
function MacroClientServer:SetupCommunication()
    -- Setup remote function
    remoteFunction = game.ReplicatedStorage:FindFirstChild(REMOTE_FUNCTION_NAME)
    if not remoteFunction then
        remoteFunction = Instance.new("RemoteFunction") ---@type RemoteFunction
        remoteFunction.Name = REMOTE_FUNCTION_NAME
        remoteFunction.Parent = game.ReplicatedStorage
    end

    ---@param macroScriptName string
    ---@param macroScriptParentName string
    ---@param macroFieldValues table
    ---@return MacroState
    local function runMacroFromMacroScript(macroScriptName, macroScriptParentName, macroFieldValues)
        -- Try find macro from this
        local macroDirectory = StudioHandler.Folders.Macros

        -- Grab Possible macros
        local possibleMacros = {}
        for _, descendant in pairs(macroDirectory:GetDescendants()) do
            local isPossibleMacro = descendant.Name == macroScriptName
                and descendant.Parent.Name == macroScriptParentName
                and not descendant.Parent:IsA("ModuleScript")
            if isPossibleMacro then
                table.insert(possibleMacros, descendant)
            end
        end

        -- RETURN: No macros found
        local totalPossibleMacros = #possibleMacros
        if totalPossibleMacros == 0 then
            Logger:Warn(("Could not find macro the macro to invoke (%s)"):format(macroScriptName))
            return
        end

        -- RETURN: More than 1 macro found
        if totalPossibleMacros > 1 then
            Logger:Warn(
                (
                    "Found multiple macros of name %s in directory %s. Please chooose more unique names to be able to invoke across server/client"
                ):format(macroScriptName, macroScriptParentName)
            )
            return
        end

        -- Get Macro
        local macroScript = possibleMacros[1]
        local macro = SocketController:GetMacro(macroScript)
        if not macro then
            Logger:Warn(("Could not find macro %s internally on invoke"):format(macroScriptName))
        end

        -- Load on our field values
        macro.State.FieldValues = macroFieldValues

        return MacroHelper:RunMacro(macro)
    end

    if IS_SERVER then
        remoteFunction.OnServerInvoke = function(player, macroScriptName, macroScriptParentName, macroFieldValues)
            return runMacroFromMacroScript(macroScriptName, macroScriptParentName, macroFieldValues)
        end
    elseif IS_CLIENT then
        remoteFunction.OnClientInvoke = function(macroScriptName, macroScriptParentName, macroFieldValues)
            return runMacroFromMacroScript(macroScriptName, macroScriptParentName, macroFieldValues)
        end
    end
end

---
---@param player Player
---@param macro MacroDefinition
---@return MacroState
---
function MacroClientServer:RunMacroOnClient(player, macro)
    return remoteFunction:InvokeClient(player, macro._script.Name, macro._script.Parent.Name, macro.State.FieldValues)
end

---
---@param macro MacroDefinition
---@return MacroState
---
function MacroClientServer:RunMacroOnServer(macro)
    return remoteFunction:InvokeServer(macro._script.Name, macro._script.Parent.Name, macro.State.FieldValues)
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function MacroClientServer:FrameworkInit()
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketController = PluginFramework:Require("SocketController")
    Logger = PluginFramework:Require("Logger")
    MacroHelper = PluginFramework:Require("MacroHelper")
    InstanceUtil = PluginFramework:Require("InstanceUtil")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function MacroClientServer:FrameworkStart() end

return MacroClientServer
