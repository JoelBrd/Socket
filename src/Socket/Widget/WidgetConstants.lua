---
---@class WidgetConstants
---
local WidgetConstants = {}

WidgetConstants.Images = {
    Arrow = "rbxassetid://9414423690",
}

WidgetConstants.Icons = {
    Unknown = "❓",
    Keybind = "🖱️",
    Settings = "⚙️",
    Search = "🔍",
    Fields = "📂",
    Warning = "⚠️",
}

WidgetConstants.RoactWidgetLine = {}

WidgetConstants.RoactWidgetLine.Type = {
    Group = "Group",
    Plug = "Plug",
    Keybind = "Keybind",
    Settings = "Settings",
    Fields = "Fields",
    Field = "Field",
}

WidgetConstants.RoactWidgetLine.Indent = {
    Group = 0,
    Plug = 1,
    Keybind = 2,
    Settings = 2,
    Fields = 2,
    Field = 3,
}

WidgetConstants.RoactWidgetLine.Pixel = {
    Indent = 14,
    LineHeight = 22,
    IconWidth = 22,
    ArrowWidth = 22,
    RunButtonWidth = 70,
    BottomPaddingHeight = 4,
    IconDetailsPadding = 2,
    PlugTextButtonPadding = 4,
    PlugRunButtonsPadding = 4,
    FieldTitleTextBoxPadding = 4,
}

WidgetConstants.SearchBar = {}

WidgetConstants.SearchBar.Pixel = {
    LineHeight = 26,
    IconWidth = 20,
}

WidgetConstants.BottomBar = {}

WidgetConstants.BottomBar.Pixel = {
    LineHeight = 22,
    DividerHeight = 2,
    SettingsWidth = 90,
}

return WidgetConstants
