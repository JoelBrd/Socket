---
---Loads an asset
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local InsertService = game:GetService("InsertService") ---@type InsertService
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
    Name = "Hello World!",
    Description = 'Prints "Hello World!" to the output.',
    Icon = "🌎",
    State = {},
    EnableAutomaticUndo = false,
    Keybind = {},
    Fields = {},
    Function = nil,
}

---Gets passed a `PlugDefinition`, which will be the table defined above (+ its populated .State)
---@param plug PlugDefinition
plugDefinition.Function = function(plug)
    Logger:PlugInfo(plug, "Hello World!")
end

return plugDefinition
