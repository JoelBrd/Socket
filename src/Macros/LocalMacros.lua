---
---Handles management of LocalMacros
---
---@class LocalMacros
---
local LocalMacros = {}

-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local StudioHandler ---@type StudioHandler
local StudioUtil ---@type StudioUtil
local PluginHandler ---@type PluginHandler
local PluginConstants ---@type PluginConstants

---
---Creates a folder for our local macros, and creates module scripts
---
function LocalMacros:Load()
    -- Unload if needed
    if LocalMacros:GetOurDirectory() then
        -- Was not previously unloaded..
        LocalMacros:Unload()
    end

    -- Create directory
    local studioUserLocalMacrosFolder = Instance.new("Configuration")
    studioUserLocalMacrosFolder.Name = tostring(StudioUtil:GetUserIdentifier())
    studioUserLocalMacrosFolder.Parent = StudioHandler.Folders.LocalMacros

    -- Read stored macros
    local storedMacros = PluginHandler:GetSetting(PluginConstants.Setting.STORED_LOCAL_MACROS) or {}
    for name, source in pairs(storedMacros) do
        local moduleScript = Instance.new("ModuleScript") ---@type ModuleScript
        moduleScript.Name = name
        moduleScript.Source = source
        moduleScript.Parent = studioUserLocalMacrosFolder
    end
end

---
---Unloads our LocalMacros by storing them in the plugin, and removing the directory
---
function LocalMacros:Unload()
    -- Write stored macros
    -- Hello reader - I didn't fancy writing a whole Instance serializer/deserializer to load whatever structure the user wants inside their LocalMacros folder
    -- There weren't nice existing options at time of writing either.. :c
    local storedMacros = PluginHandler:GetSetting(PluginConstants.Setting.STORED_LOCAL_MACROS) or {}
    for _, moduleScript in pairs(LocalMacros:GetOurDirectory():GetChildren()) do
        -- WARN: Can only do singular modulescripts
        if not moduleScript:IsA("ModuleScript") then
            warn(("LocalMacro instance %q is not a `ModuleScript`, so was not saved."):format(moduleScript:GetFullName()))
            moduleScript.Parent = StudioHandler.Folders.Directory
        else
            -- WARN: Children!
            local children = moduleScript:GetChildren()
            for _, child in pairs(children) do
                warn(("LocalMacro instance %q has a child %q. This cannot be saved!"):format(moduleScript:GetFullName(), child.Name))
            end

            -- Store!
            storedMacros[moduleScript.Name] = moduleScript.Source
        end
    end
    PluginHandler:SetSetting(PluginConstants.Setting.STORED_LOCAL_MACROS, storedMacros)

    -- Remove directory
    local directory = LocalMacros:GetOurDirectory()
    if directory then
        directory:Destroy()
    end
end

---
---@return Folder
---
function LocalMacros:GetOurDirectory()
    return StudioHandler.Folders.LocalMacros:FindFirstChild(tostring(StudioUtil:GetUserIdentifier()))
end

---@private
function LocalMacros:FrameworkInit()
    StudioUtil = PluginFramework:Require("StudioUtil")
    StudioHandler = PluginFramework:Require("StudioHandler")
    PluginHandler = PluginFramework:Require("PluginHandler")
    PluginConstants = PluginFramework:Require("PluginConstants")
end

---@private
function LocalMacros:FrameworkStart() end

return LocalMacros
