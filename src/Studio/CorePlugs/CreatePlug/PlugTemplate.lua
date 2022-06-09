---
---Plug Template
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
    Group = "%s", ---@type string
    GroupColor = nil, ---@type Color3
    GroupIcon = nil, ---@type string
    GroupIconColor = nil, ---@type Color3

    Name = "%s",
    NameColor = nil, ---@type Color3
    Icon = "%s",
    IconColor = nil, ---@type Color3

    Description = "%s", ---@type string
    State = {}, ---@type PlugState
    EnableAutomaticUndo = false, ---@type boolean
    Keybind = {}, ---@type Enum.KeyCode[]
    Fields = {}, ---@type PlugField[]

    Function = nil, ---@type fun(plug:PlugDefinition, plugin:Plugin)
    BindToClose = nil, ---@type fun(plug:PlugDefinition, plugin:Plugin)
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, "Hello %s!")
end

return plugDefinition
