---
---Will teleport the camera to the mouse position in the world
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger
local RaycastUtil = require(Utils.RaycastUtil) ---@type RaycastUtil

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---@type MacroDefinition
local macroDefinition = {
    Group = "Core",
    Name = "Phase Camera",
    Description = "Will teleport the camera to the world position of the mouse.\n`Distance` Field is how far from the camera a point can be registered.",
    Icon = "📷",
    State = {
        FieldValues = {
            Distance = 50000,
        },
    },
    EnableAutomaticUndo = true,
    Keybind = { Enum.KeyCode.LeftShift, Enum.KeyCode.F },
    Fields = {
        {
            Name = "Distance",
            Type = "number",
            IsRequired = true,
        },
    },
}

---@param macro MacroDefinition
macroDefinition.Function = function(macro, _)
    -- Read Fields
    local distance = macro:GetFieldValue("Distance")

    -- Get Camera
    local camera = game.Workspace.CurrentCamera

    -- Raycast for point
    local raycastResult = RaycastUtil:RaycastMouse(distance, nil, true)

    if raycastResult then
        local position = raycastResult.Position
        camera.CFrame = camera.CFrame - camera.CFrame.Position + position - camera.CFrame.LookVector
        camera.Focus = camera.CFrame + camera.CFrame.LookVector
    else
        Logger:MacroWarn(macro, "Could not teleport camera; no hit found.")
    end
end

return macroDefinition
