---
---Socket Settings
---

--------------------------------------------------
-- Types

---@class SocketSettings
---@field Font Enum.Font
---@field UIScale number

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {
    -- The font used on the Widget
    Font = Enum.Font.Highway,

    -- Increase the size of the elements on the Widget.
    -- Useful for high DPI monitors, or for accessibility reasons.
    UIScale = 1,

    -- If true, all `Fields` inside plugs will be toggled open on startup
    OpenFieldsByDefault = true,
}

return settings
