---
-- CollapseExplorer
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Constants
local TOP_CLASS_NAMES = {
    "Workspace",
    "CoreGui",
    "Lighting",
    "ReplicatedFirst",
    "ReplicatedStorage",
    "ServerScriptService",
    "ServerStorage",
    "MaterialService",
    "StarterGui",
    "StarterPack",
    "StarterCharacterScripts",
    "StarterPlayerScripts",
    "Teams",
    "SoundService",
    "Chat",
    "LocalizationService",
    "TestService",
} ---@type string[]

local IGNORE_CLASS_NAMES = {
    "Terrain",
    "Camera",
}

--------------------------------------------------
-- Members

local description = "Collapses all instances in explorer so nothing is 'Open'. This works by setting Parent=nil and then reparenting."
description = ("%s %s"):format(
    description,
    "This does not break the integrity of anything core to Roblox Studio, but ensure other macros/code/plugins are disabled as this may cause unintended effects"
)

local macroDefinition = {
    Name = "Collapse Explorer",
    Group = "Core",
    Icon = "🌂",
    Description = description,
}

macroDefinition.Function = function(macro, plugin)
    -- Grab top level instances to collapse
    local topInstances = {} ---@type Instance[]
    for _, className in pairs(TOP_CLASS_NAMES) do
        local instance = game:FindFirstChildOfClass(className)
        if instance then
            table.insert(topInstances, instance)
        end
    end

    -- Reparent children under each top instance
    for _, topInstance in pairs(topInstances) do
        for _, child in pairs(topInstance:GetChildren()) do
            if not table.find(IGNORE_CLASS_NAMES, child.ClassName) then
                local parent = child.Parent
                child.Parent = nil
                child.Parent = parent
            end
        end
        task.wait() -- Yield to spread workload
    end
end

return macroDefinition
