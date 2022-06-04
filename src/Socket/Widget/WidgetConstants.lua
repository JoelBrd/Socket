---
---Widget Constants
---
---@class WidgetConstants
---
local WidgetConstants = {}

--------------------------------------------------
-- Types

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Constants
WidgetConstants.Images = {
    Arrow = "rbxassetid://9414423690",
}

WidgetConstants.Icons = {
    Unknown = "❓",
    Keybind = "*️⃣",
    Settings = "⚙️",
    Search = "🔍",
}

WidgetConstants.RoactWidgetLine = {}

WidgetConstants.RoactWidgetLine.Type = {
    Group = "Group",
    Plug = "Plug",
    Keybind = "Keybind",
    Settings = "Settings",
}

WidgetConstants.RoactWidgetLine.Indent = {
    Group = 0,
    Plug = 1,
    Keybind = 2,
    Settings = 2,
}

WidgetConstants.RoactWidgetLine.Pixel = {
    Indent = 10,
    LineHeight = 20,
    IconWidth = 20,
    ArrowWidth = 20,
    RunButtonWidth = 70,
}

WidgetConstants.Font = Enum.Font.Highway

WidgetConstants.SearchBar = {}

WidgetConstants.SearchBar.Pixel = {
    LineHeight = 26,
    IconWidth = 20,
}

--------------------------------------------------
-- Members
-- ...

return WidgetConstants
