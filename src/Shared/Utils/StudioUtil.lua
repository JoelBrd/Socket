---
---Utilities for a Studio session
---
---@class StudioUtil
---
local StudioUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Players = game:GetService("Players") ---@type Players
local StudioService = game:GetService("StudioService") ---@type StudioService

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
-- ...

---
---Returns a nice string to represent the local user
---@return string
---
function StudioUtil:GetUserIdentifier()
    return ("%d"):format(StudioService:GetUserId())
end

return StudioUtil
