---
---Creates a new plug
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Plugs = ServerStorage.SocketPlugin.Plugs

--------------------------------------------------
-- Constants
local OPEN_ON_LINE = 29

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
    Group = "Core",
    GroupIcon = "🔌",
    Name = "Create Plug",
    Description = "Creates a new plug",
    Icon = "🟢",
    Fields = {
        {
            Type = "string",
            Name = "Name",
        },
        {
            Type = "string",
            Name = "Group",
        },
        {
            Type = "string",
            Name = "Icon",
        },
    },
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Get Fields
    local name = plug:GetFieldValue("Name") or "No Name"
    local group = plug:GetFieldValue("Group") or "No Group"
    local icon = plug:GetFieldValue("Icon") or "🔌"

    -- Create variables
    local description = ("%s Description"):format(name)

    -- Create plug
    local newPlug = Instance.new("ModuleScript") ---@type ModuleScript
    newPlug.Name = name:gsub(" ", "") -- Remove whitespace
    newPlug.Source = script.PlugTemplate.Source:format(group, name, icon, description)
    newPlug.Parent = Plugs

    -- Open
    plugin:OpenScript(newPlug, OPEN_ON_LINE)
    Selection:Set({ newPlug })
end

return plugDefinition
