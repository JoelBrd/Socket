---
-- Prints the FullName of the selected instance(s)
---

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Members

---@param macroDefinition MacroDefinition
local macroDefinition = {
    Name = "Get Full Name",
    Group = "Core",
    Icon = "🤏",
    Description = "Prints the FullName of the selected instance(s)",
}

macroDefinition.Function = function(macro, plugin)
    local instances = Selection:Get()
    if #instances == 0 then
        Logger:MacroWarn(macro, "Please select atleast one instance")
    end

    for _, instance in pairs(instances) do
        Logger:MacroInfo(macro, instance:GetFullName())
    end
end

return macroDefinition
