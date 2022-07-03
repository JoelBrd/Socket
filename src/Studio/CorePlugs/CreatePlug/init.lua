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
local OPEN_ON_LINE = 24

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
            IsRequired = true,
        },
        {
            Type = "string",
            Name = "Icon",
            IsRequired = true,
        },
    },
    State = {
        FieldValues = {
            Name = "Plug",
            Icon = "💡",
        },
    },
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Get Fields
    local name = plug:GetFieldValue("Name")
    local icon = plug:GetFieldValue("Icon")

    -- Create variables
    local description = ("%s Description"):format(name)

    -- Create plug
    local newPlug = Instance.new("ModuleScript") ---@type ModuleScript
    newPlug.Name = name:gsub(" ", "") -- Remove whitespace
    newPlug.Source = script.PlugTemplate.Source:format(name, icon, description, "%s")
    newPlug.Parent = Plugs

    -- Open
    plugin:OpenScript(newPlug, OPEN_ON_LINE)
    Selection:Set({ newPlug })
end

return plugDefinition
