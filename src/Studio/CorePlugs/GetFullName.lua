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

---@param plugDefinition PlugDefinition
local plugDefinition = {
    Name = "Get Full Name",
    Group = "Core",
    Icon = "🤏",
    Description = "Prints the FullName of the selected instance(s)",
}

plugDefinition.Function = function(plug, plugin)
    local instances = Selection:Get()
    if #instances == 0 then
        Logger:PlugWarn(plug, "Please select atleast one instance")
    end

    for _, instance in pairs(instances) do
        Logger:PlugInfo(plug, instance:GetFullName())
    end
end

return plugDefinition
