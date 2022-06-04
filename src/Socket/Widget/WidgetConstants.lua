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
    },
}

--------------------------------------------------
-- Members
-- ...

return WidgetConstants
