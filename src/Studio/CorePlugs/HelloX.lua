---
---Hello X Plug
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
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
    Name = "Hello X",
    Description = "Prints 'Hello {X}!' to the output",
    Icon = "👋",
    State = {
        FieldValues = {},
    },
    Keybind = { Enum.KeyCode.H, Enum.KeyCode.X },
    Fields = {
        {
            Type = "string",
            Name = "Name",
        },
        {
            Type = "number",
            Name = "Amount",
        },
        {
            Type = "boolean",
            Name = "IsMale",
        },
    },
    Function = nil,
}

---@param plug PlugDefinition
plugDefinition.Function = function(plug)
    local name = plug.State.FieldValues.Name or "?"
    local amount = plug.State.FieldValues.Amount or 1
    local isMale = plug.State.FieldValues.IsMale and true or false

    for _ = 1, amount do
        Logger:Plug(plug, ("Hello %s! (%s)"):format(name, isMale and "Male" or "Female"))
    end
end

return plugDefinition
