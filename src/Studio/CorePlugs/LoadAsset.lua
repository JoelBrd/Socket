---
---Loads an asset
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local InsertService = game:GetService("InsertService") ---@type InsertService
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
    Name = "Load Asset",
    Description = "Will load in an asset with the given Id",
    Icon = "🖨️",
    State = {},
    Keybind = {},
    Fields = {
        {
            Name = "Id",
            Type = "number",
        },
    },
    Function = nil,
}

---Gets passed a `PlugDefinition`, which will be the table defined above (+ its populated .State)
---@param plug PlugDefinition
plugDefinition.Function = function(plug)
    -- Grabs the field values
    local id = plug.State.FieldValues.Id
    if not id then
        Logger:PlugWarn(plug, "`Id` Field undefined")
        return
    end

    local model = InsertService:LoadAsset(id)
    model.Name = ("Asset (%d)"):format(id)
    model.Parent = game.Workspace

    Logger:PlugInfo(plug, ("Inserted Asset %d (%s)"):format(id, model:GetFullName()))
end

return plugDefinition
