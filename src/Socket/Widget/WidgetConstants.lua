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
    Keybind = "🖱️",
    Settings = "⚙️",
    Search = "🔍",
    Fields = "📂",
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

WidgetConstants.Color = {
    Background = {
        Dark = Color3.fromRGB(46, 46, 46),
        Light = Color3.fromRGB(255, 255, 255),
    },
    SearchBar = {
        Background = {
            Dark = Color3.fromRGB(30, 30, 30),
            Light = Color3.fromRGB(255, 255, 255),
        },
        Stroke = {
            Dark = Color3.fromRGB(255, 255, 255),
            Light = Color3.fromRGB(30, 30, 30),
        },
        PlaceholderText = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(178, 178, 178),
        },
        Text = {
            Dark = Color3.fromRGB(240, 240, 240),
            Light = Color3.fromRGB(70, 70, 70),
        },
    },
    PlugLines = {
        Arrow = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(30, 30, 30),
        },
        Text = {
            Dark = Color3.fromRGB(240, 240, 240),
            Light = Color3.fromRGB(30, 30, 30),
        },
        Field = {
            PlaceholderText = {
                Dark = Color3.fromRGB(180, 180, 180),
                Light = Color3.fromRGB(178, 178, 178),
            },
            Text = {
                Dark = Color3.fromRGB(240, 240, 240),
                Light = Color3.fromRGB(70, 70, 70),
            },
            Stroke = {
                Dark = Color3.fromRGB(255, 255, 255),
                Light = Color3.fromRGB(30, 30, 30),
            },
        },
    },
    BottomBar = {
        Divider = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(30, 30, 30),
        },
        Version = {
            Dark = Color3.fromRGB(240, 240, 240),
            Light = Color3.fromRGB(30, 30, 30),
        },
    },
}

--------------------------------------------------
-- Members
-- ...

return WidgetConstants
