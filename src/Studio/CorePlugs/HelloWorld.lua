---
---Loads an asset
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
    Name = "Hello World!",
    Description = 'Prints "Hello World!" to the output.',
    Icon = "🌎",
    State = {
        IsRunning = false,
    },
    EnableAutomaticUndo = false,
    Keybind = { Enum.KeyCode.LeftShift, Enum.KeyCode.H, Enum.KeyCode.W },
    Fields = {
        {
            Name = "Do Loop",
            Type = "boolean",
            IsRequired = true,
        },
        {
            Name = "Time",
            Type = "number",
        },
    },
    Function = nil,
    BindToClose = nil,
}

---@param plug PlugDefinition
plugDefinition.Function = function(plug, _)
    local doLoop = plug.State.FieldValues["Do Loop"]
    local time = plug.State.FieldValues["Time"]

    if doLoop and time then
        plug.State.IsRunning = not plug.State.IsRunning

        task.spawn(function()
            while plug.State.IsRunning do
                wait(time)
                Logger:PlugInfo(plug, "Hello World!")
            end
        end)
    else
        Logger:PlugInfo(plug, "Hello World!")
    end
end

---@param plug PlugDefinition
plugDefinition.BindToClose = function(plug)
    Logger:PlugInfo(plug, "Goodbye World!")
end

return plugDefinition
