---
---Socket Settings
---

--------------------------------------------------
-- Types

---@class SocketSettings
---@field EnableAutoRun boolean If true, macros with `AutoRun=true` will run on plugin startup
---@field EnableSocketMacros boolean If true, will ensure core macros are created on startup
---@field EnableSocketMacrosOverwrite boolean If true, will overwrite any changes makes to the core macros source code when the plugin is opened
---@field Font Enum.Font The font used on the Widget
---@field SortType string Defines how Macros will be sorted on the Widget. See https://joelbrd.github.io/Socket/api/SocketSettings#SortType for a breakdown.
---@field IgnoreGameProcessedKeybinds boolean If true, will register keybinds assigned to macros even if registered by other areas of Studio (applies to ALL macros). Note: Some keybinds are impossible to hear (e.g., Ctrl+C)
---@field OpenFieldsByDefault boolean If true, all `Fields` inside macros will be toggled open on startup
---@field UIScale number Size of UI elements on the widget
---@field UseDefaultSettings boolean If set to true, will reset all settings back to their default values.

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {}

return settings
