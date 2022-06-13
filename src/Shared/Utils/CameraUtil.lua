---
---CameraUtil
---
---@class CameraUtil
---
local CameraUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local UserInputService = game:GetService("UserInputService") ---@type UserInputService

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@param distance number
---@param raycastParams RaycastParams
---@return RaycastResult
---
---@overload fun(distance:number):RaycastResult
---
function CameraUtil:RaycastMouse(distance, raycastParams)
    -- Get Mouse Position on screen
    local mousePoint = UserInputService:GetMouseLocation()

    -- Get Ray
    local camera = game.Workspace.CurrentCamera
    local unitRay = camera:ViewportPointToRay(mousePoint.X, mousePoint.Y)

    -- Raycast
    return game.Workspace:Raycast(camera.CFrame.Position, unitRay.Direction * distance, raycastParams)
end

return CameraUtil
