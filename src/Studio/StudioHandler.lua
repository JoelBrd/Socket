---
---Utility functions for managing Roblox Instances
---
---@class StudioHandler
---
local StudioHandler = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local RunService = game:GetService("RunService") ---@type RunService
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Logger ---@type Logger
local Framework ---@type Framework
local SocketSettings ---@type SocketSettings

--------------------------------------------------
-- Constants
local DIRECTORY_FOLDER_PARENT = game:GetService("ServerStorage")
local DIRECTORY_FOLDER_NAME = "SocketPlugin"
local PLUGS_FOLDER_NAME = "Plugs"
local UTILS_FOLDER_NAME = "Utils"
local IS_RUNNING = RunService:IsRunning()
local IS_CLIENT = RunService:IsClient()

--------------------------------------------------
-- Members
StudioHandler.Folders = {
    Directory = nil, ---@type Configuration
    Plugs = nil, ---@type Folder
    Utils = nil, ---@type Folder
}

---
---Will ensure the proper Studio requisites exist; will create anything missing.
---
function StudioHandler:ValidateStructure()
    --------------------------------------------------
    -- CREATE FOLDERS

    -- Directory
    local directoryFolder = DIRECTORY_FOLDER_PARENT:FindFirstChild(DIRECTORY_FOLDER_NAME)
    if not directoryFolder then
        directoryFolder = Instance.new("Configuration")
        directoryFolder.Name = DIRECTORY_FOLDER_NAME
        directoryFolder.Parent = DIRECTORY_FOLDER_PARENT
    end
    StudioHandler.Folders.Directory = directoryFolder

    -- Plugs
    local plugsFolder = directoryFolder:FindFirstChild(PLUGS_FOLDER_NAME)
    if not plugsFolder then
        plugsFolder = Instance.new("Folder")
        plugsFolder.Name = PLUGS_FOLDER_NAME
        plugsFolder.Parent = directoryFolder
    end
    StudioHandler.Folders.Plugs = plugsFolder

    -- Utils
    local utilsFolder = directoryFolder:FindFirstChild(UTILS_FOLDER_NAME)
    if not utilsFolder then
        utilsFolder = Instance.new("Folder")
        utilsFolder.Name = UTILS_FOLDER_NAME
        utilsFolder.Parent = directoryFolder
    end
    StudioHandler.Folders.Utils = utilsFolder

    --------------------------------------------------
    -- POPULATE UTILS

    local utilsModuleScripts = PluginFramework:GetDirectory("Utils"):GetChildren() ---@type ModuleScript[]
    for _, moduleScript in pairs(utilsModuleScripts) do
        -- Destroy matching instance
        local matchingStudioInstance = utilsFolder:FindFirstChild(moduleScript.Name) ---@type ModuleScript
        if matchingStudioInstance then
            matchingStudioInstance:Destroy()
        end

        -- Place Clone
        if moduleScript:IsA("ModuleScript") then
            local clone = moduleScript:Clone()
            clone.Parent = utilsFolder

            local isCustomModuleObject = moduleScript:FindFirstChild(Framework.IS_CUSTOM_MODULE_NAME)
            if isCustomModuleObject then
                isCustomModuleObject:Destroy()
            end
        end
    end

    --------------------------------------------------
    -- POPULATE CORE PLUGS

    -- Create Folder
    local corePlugsFolder = plugsFolder:FindFirstChild("Core")
    if not corePlugsFolder then
        corePlugsFolder = Instance.new("Folder") ---@type Folder
        corePlugsFolder.Name = "Core"
        corePlugsFolder.Parent = plugsFolder
    end
end

---
---Ensures our core plugs are initiated
---
function StudioHandler:ValidatePlugs()
    local corePlugsFolder = StudioHandler.Folders.Plugs.Core

    -- Copy over core plugs UNLESS we're running on client (`PlugClientServer` handles this) (or got something disabled)
    local doEnableCorePlugs = SocketSettings:GetSetting("EnableSocketPlugs")
    local doEnableCorePlugsOverwrite = SocketSettings:GetSetting("EnableSocketPlugsOverwrite")
    if not (IS_RUNNING and IS_CLIENT) and doEnableCorePlugs then
        local internalCorePlugsFolder = script.Parent.CorePlugs
        local plugsModuleScripts = internalCorePlugsFolder:GetChildren() ---@type ModuleScript[]
        for _, moduleScript in pairs(plugsModuleScripts) do
            local matchingStudioInstance = corePlugsFolder:FindFirstChild(moduleScript.Name) ---@type ModuleScript
            if doEnableCorePlugsOverwrite then
                -- Destroy matching instance
                if matchingStudioInstance then
                    matchingStudioInstance:Destroy()
                end

                if moduleScript:IsA("ModuleScript") then
                    moduleScript:Clone().Parent = corePlugsFolder
                end
            elseif not matchingStudioInstance then
                if moduleScript:IsA("ModuleScript") then
                    moduleScript:Clone().Parent = corePlugsFolder
                end
            end
        end
    end
end

---
---@private
---
function StudioHandler:FrameworkInit()
    Logger = PluginFramework:Require("Logger")
    Framework = PluginFramework:Require("Framework")
    SocketSettings = PluginFramework:Require("SocketSettings")
end

---
---@private
---
function StudioHandler:FrameworkStart() end

return StudioHandler
