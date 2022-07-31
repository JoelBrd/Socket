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
local MACROS_FOLDER_NAME = "Macros"
local LOCAL_MACROS_FOLDER_NAME = "LocalMacros"
local UTILS_FOLDER_NAME = "Utils"
local IS_RUNNING = RunService:IsRunning()
local IS_CLIENT = RunService:IsClient()

--------------------------------------------------
-- Members
StudioHandler.Folders = {
    Directory = nil, ---@type Configuration
    Macros = nil, ---@type Folder
    LocalMacros = nil, ---@type Folder
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

    -- Macros
    local macrosFolder = directoryFolder:FindFirstChild(MACROS_FOLDER_NAME)
    if not macrosFolder then
        macrosFolder = Instance.new("Folder")
        macrosFolder.Name = MACROS_FOLDER_NAME
        macrosFolder.Parent = directoryFolder
    end
    StudioHandler.Folders.Macros = macrosFolder

    -- LocalMacros
    local localMacrosFolder = directoryFolder:FindFirstChild(LOCAL_MACROS_FOLDER_NAME)
    if not localMacrosFolder then
        localMacrosFolder = Instance.new("Folder")
        localMacrosFolder.Name = LOCAL_MACROS_FOLDER_NAME
        localMacrosFolder.Parent = directoryFolder
    end
    StudioHandler.Folders.LocalMacros = localMacrosFolder

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
    -- POPULATE CORE MACROS

    -- Create Folder
    local coreMacrosFolder = macrosFolder:FindFirstChild("Core")
    if not coreMacrosFolder then
        coreMacrosFolder = Instance.new("Folder") ---@type Folder
        coreMacrosFolder.Name = "Core"
        coreMacrosFolder.Parent = macrosFolder
    end
end

---
---Ensures our core macros are initiated
---
function StudioHandler:ValidateBuiltInMacros()
    local coreMacrosFolder = StudioHandler.Folders.Macros.Core

    -- Copy over core macros UNLESS we're running on client (`MacroClientServer` handles this) (or got something disabled)
    local doEnableCoreMacros = SocketSettings:GetSetting("EnableSocketMacros")
    local doEnableCoreMacrosOverwrite = SocketSettings:GetSetting("EnableSocketMacrosOverwrite")
    if not (IS_RUNNING and IS_CLIENT) and doEnableCoreMacros then
        local internalCoreMacrosFolder = script.Parent.CoreMacros
        local macrosModuleScripts = internalCoreMacrosFolder:GetChildren() ---@type ModuleScript[]
        for _, moduleScript in pairs(macrosModuleScripts) do
            if moduleScript:IsA("ModuleScript") then
                local matchingStudioInstance = coreMacrosFolder:FindFirstChild(moduleScript.Name) ---@type ModuleScript
                if doEnableCoreMacrosOverwrite then
                    -- Do we *need* to overwrite? Lets compare the sources.
                    local existingSource = matchingStudioInstance
                        and matchingStudioInstance:IsA("ModuleScript")
                        and matchingStudioInstance.Source
                    local currentSource = moduleScript.Source

                    if existingSource ~= currentSource then
                        -- Destroy matching instance
                        if matchingStudioInstance then
                            matchingStudioInstance:Destroy()
                        end

                        if moduleScript:IsA("ModuleScript") then
                            moduleScript:Clone().Parent = coreMacrosFolder
                        end
                    end
                elseif not matchingStudioInstance then
                    if moduleScript:IsA("ModuleScript") then
                        moduleScript:Clone().Parent = coreMacrosFolder
                    end
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
