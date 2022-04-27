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
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework

--------------------------------------------------
-- Constants
local DIRECTORY_FOLDER_PARENT = game:GetService("ServerStorage")
local DIRECTORY_FOLDER_NAME = "SocketPlugin"
local PLUGS_FOLDER_NAME = "Plugs"
local UTILS_FOLDER_NAME = "Utils"

--------------------------------------------------
-- Members
StudioHandler.Folders = {
    Directory = nil, ---@type Folder
    Internal = nil, ---@type Folder
    Plugs = nil, ---@type Folder
    Utils = nil, ---@type Folder
}

---
---Will ensure the proper Studio requisites exist; will create anything missing.
---
function StudioHandler:Validate()
    --------------------------------------------------
    -- CREATE FOLDERS

    -- Directory
    local directoryFolder = DIRECTORY_FOLDER_PARENT:FindFirstChild(DIRECTORY_FOLDER_NAME)
    if not directoryFolder then
        directoryFolder = Instance.new("Folder")
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

        if moduleScript:IsA("ModuleScript") then
            moduleScript:Clone().Parent = utilsFolder
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

    local internalCorePlugsFolder = script.Parent.CorePlugs
    local plugsModuleScripts = internalCorePlugsFolder:GetChildren() ---@type ModuleScript[]
    for _, moduleScript in pairs(plugsModuleScripts) do
        -- Destroy matching instance
        local matchingStudioInstance = corePlugsFolder:FindFirstChild(moduleScript.Name) ---@type ModuleScript
        if matchingStudioInstance then
            matchingStudioInstance:Destroy()
        end

        if moduleScript:IsA("ModuleScript") then
            moduleScript:Clone().Parent = corePlugsFolder
        end
    end
end

---
---@private
---
function StudioHandler:FrameworkInit()
    -- TODO Logic here
end

---
---@private
---
function StudioHandler:FrameworkStart()
    -- TODO Logic here
end

return StudioHandler
