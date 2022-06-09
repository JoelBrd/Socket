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
        },
    },
    Function = nil,
}

---@param plug PlugDefinition
plugDefinition.Function = function(plug, _)
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
