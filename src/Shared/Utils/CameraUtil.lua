---
---Utility functions for the Camera
---
---@class CameraUtil
---
local CameraUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local camera = game.Workspace.CurrentCamera

---
---Will transform the CurrentCamera's CFrame to the passed position, looking at the passed direction
---
function CameraUtil:TeleportTo(position, direction)
    camera.CFrame = CFrame.new(position, position + direction)
    camera.Focus = CFrame.new(position + direction)
end

return CameraUtil
