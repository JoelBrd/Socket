---
---Will teleport the camera to the mouse position in the world
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
    -- Define group this plug belongs to.
    Group = "Core",

    -- Basic definitions for this plug.
    Name = "Phase Camera",
    Description = "Will teleport the camera to the world position of the mouse.\n`Distance` Field is how far from the camera a point can be registered.",
    Icon = "📷",

    -- Init state (not required, as will get automatically populated).
    State = {
        FieldValues = {
            Distance = 50000,
        },
    },

    -- If true, will automatically implement undo/redo functionality for this plug.
    -- Only functions when the plug makes changes to studio.
    EnableAutomaticUndo = true,

    -- A keybind that will trigger this plug.
    Keybind = { Enum.KeyCode.LeftShift, Enum.KeyCode.C },

    -- The fields for this plug.
    Fields = {
        {
            Name = "Distance",
            Type = "number",
        },
    },

    -- Can declare inside or outside the table
    Function = nil,
}

---Gets passed a `PlugDefinition`, which will be the table defined above (+ its populated .State)
---@param plug PlugDefinition
plugDefinition.Function = function(plug)
    -- Read Fields
    local distance = plug.State.FieldValues.Distance
    if not distance then
        Logger:PlugWarn(plug, "Distance Field must be declared.")
        return
    end

    -- Get Mouse Position on screen
    local mousePoint = UserInputService:GetMouseLocation()

    -- Get Ray
    local camera = game.Workspace.CurrentCamera
    local unitRay = camera:ViewportPointToRay(mousePoint.X, mousePoint.Y)

    -- Raycast for point
    local raycastResult = game.Workspace:Raycast(camera.CFrame.Position, unitRay.Direction * distance)
    if raycastResult then
        local position = raycastResult.Position
        camera.CFrame = camera.CFrame - camera.CFrame.Position + position - camera.CFrame.LookVector
        camera.Focus = camera.CFrame + camera.CFrame.LookVector
    else
        Logger:PlugWarn(plug, "Could not teleport camera; no hit found.")
    end
end

return plugDefinition
