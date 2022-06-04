---
---Hello World Plug
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
    Name = "Hello World",
    Description = "Prints 'Hello World!' to the output",
    Icon = "🌎",
    State = {},
    Keybind = { Enum.KeyCode.H, Enum.KeyCode.W },
    Fields = {},
    Function = nil,
}

plugDefinition.Function = function()
    Logger:Plug(plugDefinition, "Hello World!")
end

return plugDefinition
