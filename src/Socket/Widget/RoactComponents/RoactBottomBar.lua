---
---Main Widget
---
---@class RoactBottomBar
---
local RoactBottomBar = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactMacroContainer ---@type RoactMacroContainer
local RoactSearchBar ---@type RoactSearchBar
local WidgetConstants ---@type WidgetConstants
local SocketController ---@type SocketController
local RoactButton ---@type RoactButton
local StudioHandler ---@type StudioHandler
local PluginHandler ---@type PluginHandler
local SocketConstants ---@type SocketConstants
local SocketSettings ---@type SocketSettings
local WidgetTheme ---@type WidgetTheme

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@return RoactElement
---
function RoactBottomBar:Get()
    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        DividerLine = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.BottomBar.Divider),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(1, -10, 0, WidgetConstants.BottomBar.Pixel.DividerHeight),
            BorderSizePixel = 0,
        }),

        Space = Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, WidgetConstants.BottomBar.Pixel.DividerHeight),
            Size = UDim2.new(1, 0, 1, -WidgetConstants.BottomBar.Pixel.DividerHeight),
        }, {
            SettingsButtonHolder = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, WidgetConstants.BottomBar.Pixel.SettingsWidth, 1, 0),
            }, {
                UIPadding = Roact.createElement("UIPadding", {
                    PaddingBottom = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 2),
                }),
                SettingsButton = RoactButton:Get({
                    text = "Settings",
                    color = Color3.fromRGB(208, 138, 255),
                    activatedCallback = function()
                        SocketSettings:OpenSettings()
                    end,
                }),
            }),

            VersionLabel = Roact.createElement("TextLabel", {
                Font = SocketSettings:GetSetting("Font"),
                Text = SocketConstants.Version,
                TextColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.BottomBar.Version),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1, 1),
                Size = UDim2.new(1, 0, 0.8, 0),
            }),
        }),
    })
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactBottomBar:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactMacroContainer = PluginFramework:Require("RoactMacroContainer")
    RoactSearchBar = PluginFramework:Require("RoactSearchBar")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    SocketController = PluginFramework:Require("SocketController")
    RoactButton = PluginFramework:Require("RoactButton")
    PluginHandler = PluginFramework:Require("PluginHandler")
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketConstants = PluginFramework:Require("SocketConstants")
    SocketSettings = PluginFramework:Require("SocketSettings")
    WidgetTheme = PluginFramework:Require("WidgetTheme")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactBottomBar:FrameworkStart() end

return RoactBottomBar
