---
---Socket Settings
---

--------------------------------------------------
-- Types

---@class SocketSettings
---@field EnableAutoRun boolean If true, plugs with `AutoRun=true` will run on plugin startup
---@field EnableSocketPlugs boolean If true, will ensure core plugs are created on startup
---@field EnableSocketPlugsOverwrite boolean If true, will overwrite any changes makes to the core plugs source code when the plugin is opened
---@field Font Enum.Font The font used on the Widget
---@field GroupMatchingIcons boolean If true, plugs with identical icons will be next to one another
---@field IgnoreGameProcessedKeybinds boolean If true, will register keybinds assigned to plugs even if registered by other areas of Studio (applies to ALL plugs). Note: Some keybinds are impossible to hear (e.g., Ctrl+C)
---@field OpenFieldsByDefault boolean If true, all `Fields` inside plugs will be toggled open on startup
---@field UIScale number Size of UI elements on the widget
---@field UseDefaultSettings boolean If set to true, will reset all settings back to their default values.

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {}

return settings
