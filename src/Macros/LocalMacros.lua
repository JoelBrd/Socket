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
    -- Create directory
    local studioUserLocalMacrosFolder = LocalMacros:GetOurDirectory()
    if not studioUserLocalMacrosFolder then
        studioUserLocalMacrosFolder = Instance.new("Configuration")
        studioUserLocalMacrosFolder.Name = tostring(StudioUtil:GetUserIdentifier())
        studioUserLocalMacrosFolder.Parent = StudioHandler.Folders.LocalMacros
    end

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
    -- RETURN: No local macros directory stored
    local ourDirectory = LocalMacros:GetOurDirectory()
    if not ourDirectory then
        return
    end

    -- Write stored macros
    -- Hello reader - I didn't fancy writing a whole Instance serializer/deserializer to load whatever structure the user wants inside their LocalMacros folder
    -- There weren't nice existing options at time of writing either.. :c
    local storedMacros = {}
    for _, moduleScript in pairs(ourDirectory:GetChildren()) do
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

            -- Check for duplicate names
            if storedMacros[moduleScript.Name] then
                -- Count how many macros have this name
                local totalDuplicateNames = 0
                for _, instance in pairs(ourDirectory:GetChildren()) do
                    if instance.Name == moduleScript.Name then
                        totalDuplicateNames += 1
                    end
                end

                moduleScript.Name = ("%s (%d)"):format(moduleScript.Name, totalDuplicateNames)
            end

            -- Store!
            storedMacros[moduleScript.Name] = moduleScript.Source
        end
    end
    PluginHandler:SetSetting(PluginConstants.Setting.STORED_LOCAL_MACROS, storedMacros)

    -- Remove directory
    if ourDirectory then
        ourDirectory:Destroy()
    end
end

---
---@return Folder
---
function LocalMacros:GetOurDirectory()
    if StudioHandler.Folders.LocalMacros then
        return StudioHandler.Folders.LocalMacros:FindFirstChild(tostring(StudioUtil:GetUserIdentifier()))
    end
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
