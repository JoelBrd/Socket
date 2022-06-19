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
local CameraUtil = require(Utils.CameraUtil) ---@type CameraUtil

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
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

---@param plug PlugDefinition
plugDefinition.Function = function(plug, _)
    -- Read Fields
    local distance = plug:GetFieldValue("Distance")

    -- Get Camera
    local camera = game.Workspace.CurrentCamera

    -- Raycast for point
    local raycastResult = CameraUtil:RaycastMouse(distance, nil, true)

    if raycastResult then
        local position = raycastResult.Position
        camera.CFrame = camera.CFrame - camera.CFrame.Position + position - camera.CFrame.LookVector
        camera.Focus = camera.CFrame + camera.CFrame.LookVector
    else
        Logger:PlugWarn(plug, "Could not teleport camera; no hit found.")
    end
end

return plugDefinition
