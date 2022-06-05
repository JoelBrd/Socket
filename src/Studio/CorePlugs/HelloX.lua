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
    State = {},
    Keybind = { Enum.KeyCode.H, Enum.KeyCode.X },
    Fields = {
        {
            Type = "string",
            Name = "X",
        },
    },
    Function = nil,
}

plugDefinition.Function = function()
    Logger:Plug(plugDefinition, "Hello World!")
end

return plugDefinition
