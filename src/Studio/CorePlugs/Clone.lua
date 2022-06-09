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

---@type PlugDefinition
local plugDefinition = {
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

---@param plug PlugDefinition
plugDefinition.Function = function(plug, _)
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

    -- Logs to output, with the trace of this plug.
    Logger:PlugInfo(plug, ("Cloned %d instances. %s"):format(#instances, outputMsg))
end

return plugDefinition
