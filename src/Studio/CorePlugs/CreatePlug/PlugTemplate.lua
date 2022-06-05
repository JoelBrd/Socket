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
    -- Define group this plug belongs to.
    Group = "New",
    GroupIcon = "🔌",

    -- Basic definitions for this plug.
    Name = "New Plug",
    Description = "A new plug",
    Icon = "❓",

    -- Init state (not required, as will get automatically populated).
    State = {
        FieldValues = {
            ["Field 1"] = "Default",
        },
        IsRunning = nil,
    },

    -- If true, will automatically implement undo/redo functionality for this plug.
    -- Only functions when the plug makes changes to studio.
    EnableAutomaticUndo = false,

    -- A keybind that will trigger this plug.
    Keybind = { Enum.KeyCode.A, Enum.KeyCode.B, Enum.KeyCode.C },

    -- The fields for this plug.
    Fields = {
        {
            Name = "Field 1",
            Type = "string",
        },
        {
            Name = "Field 2",
            Type = "number",
        },
        {
            Name = "Field 3",
            Type = "boolean",
        },
    },

    -- Can declare inside or outside the table
    Function = nil,
}

---Gets passed a `PlugDefinition`, which will be the table defined above (+ its populated .State)
---@param plug PlugDefinition
plugDefinition.Function = function(plug)
    -- Grabs the field values
    local field1 = plug.State.FieldValues["Field 1"]
    local field2 = plug.State.FieldValues["Field 2"]
    local field3 = plug.State.FieldValues["Field 3"]

    -- Logs to output, with the trace of this plug.
    Logger:PlugInfo(plug, "New Plug", field1, field2, field3)
end

return plugDefinition
