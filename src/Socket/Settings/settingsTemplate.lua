---
---Socket Settings
---

--------------------------------------------------
-- Types

---@class SocketSettings
---@field Font Enum.Font The font used on the Widget
---@field UIScale number Size of UI elements on the widget
---@field OpenFieldsByDefault boolean If true, all `Fields` inside plugs will be toggled open on startup
---@field NavigateFieldsKeybind Enum.KeyCode What keybind will navigate through same-context fields
---@field GroupMatchingIcons boolean If true, plugs with identical icons will be next to one another

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {}

return settings
