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
    Name = "Load Asset",
    Description = "Will load in an asset with the given Id",
    Icon = "🖨️",
    EnableAutomaticUndo = true,
    Fields = {
        {
            Name = "Id",
            Type = "number",
            IsRequired = true,
        },
    },
}

---@param plug PlugDefinition
plugDefinition.Function = function(plug, _)
    -- Grabs the field values
    local id = plug:GetFieldValue("Id")

    -- Load Model
    local model ---@type Model
    local success, err = pcall(function()
        model = InsertService:LoadAsset(id)
    end)
    if not success then
        Logger:PlugWarn(plug, ("Error loading asset %d (%s)"):format(id, err))
        return
    end

    -- Place model
    model.Name = ("Asset (%d)"):format(id)
    model.Parent = game.Workspace

    Logger:PlugInfo(plug, ("Inserted Asset %d (%s)"):format(id, model:GetFullName()))
end

return plugDefinition
