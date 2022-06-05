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
        IsRunning = false,
    },
    Keybind = { Enum.KeyCode.H, Enum.KeyCode.X },
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
    -- Toggle
    plug.State.IsRunning = not plug.State.IsRunning
    if not plug.State.IsRunning then
        return
    end

    -- Loop
    task.spawn(function()
        local name = plug.State.FieldValues.Name or "?"
        while plug.State.IsRunning do
            Logger:Plug(plug, ("Hello %s!"):format(name))
            wait(1)
        end
    end)
end

return plugDefinition
