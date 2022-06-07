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

    -- What keybind will navigate through same-context fields
    NavigateFieldsKeybind = Enum.KeyCode.Tab,

    -- If true, plugs with identical icons will be next to one another
    GroupMatchingIcons = true,
}

return settings
