---
---Clones the selected instance(s) under the same directories
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---@type MacroDefinition
local macroDefinition = {
    Group = "Core",
    Name = "Clone",
    Description = "Clones the selected instance(s) under the same directories",
    Icon = "🧩",
    State = {},
    EnableAutomaticUndo = true,
    Keybind = { Enum.KeyCode.LeftShift, Enum.KeyCode.C },
    Fields = {},
    Function = nil,
}

---@param macro MacroDefinition
macroDefinition.Function = function(macro, _)
    -- RETURN: No selection
    local instances = Selection:Get()
    if not instances[1] then
        return
    end

    local outputMsg = ""
    local clones = {}
    for _, instance in pairs(instances) do
        local clone = instance:Clone()
        clone.Parent = instance.Parent
        table.insert(clones, clone)

        outputMsg = ("%s\n%s"):format(outputMsg, ("    + %s"):format(clone:GetFullName()))
    end

    Selection:Set(clones)

    -- Logs to output, with the trace of this macro.
    Logger:MacroInfo(macro, ("Cloned %d instances. %s"):format(#instances, outputMsg))
end

return macroDefinition
