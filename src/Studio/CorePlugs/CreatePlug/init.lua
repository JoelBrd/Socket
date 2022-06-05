---
---Creates a new plug!
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Plugs = ServerStorage.SocketPlugin.Plugs
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
-- ...

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
plugDefinition.Function = function(plug)
    -- Get Name
    local name = plug.State.FieldValues.Name or "NewPlug"

    -- Create plug
    local newPlug = script.PlugTemplate:Clone()
    newPlug.Name = name
    newPlug.Parent = Plugs
end

return plugDefinition
