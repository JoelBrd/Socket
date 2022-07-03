---
-- Plug
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Members

local plugDefinition = {
    Name = "%s",
    Group = "Plugs",
    Icon = "%s",
    Description = "%s",
}

plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, ("Hello %s!"):format(plug.Name))
    --[[
        ...
        Your Logic Here
        ...
    ]]
end

return plugDefinition
