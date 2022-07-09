---
-- Macro
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Members

local macroDefinition = {
    Name = "%s",
    Group = "Macros",
    Icon = "%s",
    Description = "%s",
}

macroDefinition.Function = function(macro, plugin)
    Logger:MacroInfo(macro, ("Hello %s!"):format(macro.Name))
    --[[
        ...
        Your Logic Here
        ...
    ]]
end

return macroDefinition
