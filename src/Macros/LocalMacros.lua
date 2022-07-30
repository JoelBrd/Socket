---
---Handles management of LocalMacros
---
---@class LocalMacros
---
local LocalMacros = {}

-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local StudioService = game:GetService("StudioService") ---@type StudioService
local StudioHandler ---@type StudioHandler

---
---Creates a folder for our local macros, and creates module scripts
---
function LocalMacros:Load()
    -- Create Directory
    if LocalMacros:GetOurDirectory() then
        -- Was not previously unloaded..
        LocalMacros:Unload()
    end

    local studioUserLocalMacrosFolder = Instance.new("Configuration")
    studioUserLocalMacrosFolder.Name = tostring(StudioService:GetUserId())
    studioUserLocalMacrosFolder.Parent = StudioHandler.Folders.LocalMacros
end

---
---Unloads our LocalMacros by storing them in the plugin, and removing the directory
---
function LocalMacros:Unload()
    local directory = LocalMacros:GetOurDirectory()
    if directory then
        directory:Destroy()
    end
end

---
---@return Folder
---
function LocalMacros:GetOurDirectory()
    return StudioHandler.Folders.LocalMacros:FindFirstChild(tostring(StudioService:GetUserId()))
end

---@private
function LocalMacros:FrameworkInit()
    StudioHandler = PluginFramework:Require("StudioHandler")
end

---@private
function LocalMacros:FrameworkStart() end

return LocalMacros
