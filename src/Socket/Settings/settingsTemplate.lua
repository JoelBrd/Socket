---
---Socket Settings
---

--------------------------------------------------
-- Types

---@class SocketSettings
---@field Font Enum.Font The font used on the Widget
---@field GroupMatchingIcons boolean If true, plugs with identical icons will be next to one another
---@field IgnoreGameProcessedKeybinds boolean If true, will register keybinds assigned to plugs even if registered by other areas of Studio
---@field OpenFieldsByDefault boolean If true, all `Fields` inside plugs will be toggled open on startup
---@field UIScale number Size of UI elements on the widget

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {}

return settings
