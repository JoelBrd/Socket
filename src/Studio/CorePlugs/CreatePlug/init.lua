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
        },
    },
    Function = nil,
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Get Name
    local name = plug.State.FieldValues.Name or "NewPlug"

    -- Create plug
    local newPlug = script.PlugTemplate:Clone()
    newPlug.Name = name
    newPlug.Parent = Plugs

    -- Open
    plugin:OpenScript(newPlug, OPEN_ON_LINE)
    Selection:Set({ newPlug })
end

return plugDefinition
