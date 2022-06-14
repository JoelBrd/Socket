---
---Manages the widget theme by studio theme
---
---@class WidgetTheme
---
local WidgetTheme = {}

--------------------------------------------------
-- Types

---@class WidgetElementTheme
---@field Dark Color3
---@field Light Color3
---@field GuideColor Enum.StudioStyleGuideColor
---@field GuideModifier Enum.StudioStyleGuideColor

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Logger ---@type Logger

--------------------------------------------------
-- Constants

local mainText = {
    --GuideColor = Enum.StudioStyleGuideColor.MainText,
    Dark = Color3.fromRGB(225, 225, 225),
    Light = Color3.fromRGB(40, 40, 40),
}
local popText = {
    --GuideColor = Enum.StudioStyleGuideColor.MainText,
    Dark = Color3.fromRGB(235, 235, 235),
    Light = Color3.fromRGB(0, 0, 0),
}
local mainBackground = {
    GuideColor = Enum.StudioStyleGuideColor.MainBackground,
    -- Dark = Color3.fromRGB(46, 46, 46),
    -- Light = Color3.fromRGB(255, 255, 255),
}

WidgetTheme.Indexes = {
    Background = mainBackground,
    SearchBar = {
        Background = {
            GuideColor = Enum.StudioStyleGuideColor.InputFieldBackground,
            -- Dark = Color3.fromRGB(30, 30, 30),
            -- Light = Color3.fromRGB(255, 255, 255),
        },
        Stroke = {
            --GuideColor = Enum.StudioStyleGuideColor.Border,
            Dark = Color3.fromRGB(79, 79, 79),
            Light = Color3.fromRGB(185, 185, 185),
        },
        PlaceholderText = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(178, 178, 178),
        },
        Text = mainText,
    },
    PlugLines = {
        Arrow = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(30, 30, 30),
        },
        Text = mainText,
        Plug = {
            Text = popText,
            RunButton = {
                Dark = Color3.fromRGB(230, 230, 230),
                Light = Color3.fromRGB(255, 255, 255),
            },
        },
        Field = {
            PlaceholderText = {
                Dark = Color3.fromRGB(180, 180, 180),
                Light = Color3.fromRGB(135, 135, 135),
            },
            Text = mainText,
            Stroke = {
                Dark = Color3.fromRGB(255, 255, 255),
                Light = Color3.fromRGB(30, 30, 30),
            },
            Backing = mainBackground,
        },
    },
    BottomBar = {
        Divider = {
            Dark = Color3.fromRGB(180, 180, 180),
            Light = Color3.fromRGB(30, 30, 30),
        },
        Version = mainText,
    },
}

--------------------------------------------------
-- Members

---
---@param elementTheme WidgetElementTheme
---@return Color3
---
function WidgetTheme:GetColor(elementTheme)
    local guideColor = elementTheme.GuideColor
    local guideModifier = elementTheme.GuideModifier or Enum.StudioStyleGuideModifier.Default

    local color ---@type Color3
    local theme = settings().Studio.Theme
    if guideColor then
        color = theme:GetColor(guideColor, guideModifier)
    else
        color = elementTheme[theme.Name] or elementTheme.Light
    end

    if not color then
        Logger:Error("Could not calculate color for element theme", elementTheme)
    end

    return color
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function WidgetTheme:FrameworkInit()
    Logger = PluginFramework:Require("Logger")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function WidgetTheme:FrameworkStart()
    -- TODO Logic here
end

return WidgetTheme
