---
---Creates a new plug!
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
    Description = "Creates a template plug!",
    Icon = "🟢",
    State = {},
    Keybind = {},
    Fields = {
        {
            Type = "string",
            Name = "Name",
            IsRequired = true,
        },
        {
            Type = "string",
            Name = "Group",
            IsRequired = true,
        },
        {
            Type = "string",
            Name = "Icon",
        },
    },
    Function = nil,
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Get Fields
    local name = plug.State.FieldValues.Name
    local group = plug.State.FieldValues.Group
    local icon = plug.State.FieldValues.Icon or "🔌"

    -- Create variables
    local description = ("%s Description"):format(name)

    -- Create plug
    local newPlug = Instance.new("ModuleScript") ---@type ModuleScript
    newPlug.Name = name:gsub(" ", "") -- Remove whitespace
    newPlug.Source = script.PlugTemplate.Source:format(group, name, description, icon, "%s")
    newPlug.Parent = Plugs

    -- Open
    plugin:OpenScript(newPlug, OPEN_ON_LINE)
    Selection:Set({ newPlug })
end

return plugDefinition
