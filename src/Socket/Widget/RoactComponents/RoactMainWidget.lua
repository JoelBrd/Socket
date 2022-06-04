---
---Main Widget
---
---@class RoactMainWidget
---
local RoactMainWidget = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactPlugContainer ---@type RoactPlugContainer
local RoactSearchBar ---@type RoactSearchBar
local WidgetConstants ---@type WidgetConstants
local SocketController ---@type SocketController

--------------------------------------------------
-- Constants
local MARGIN_PADDING = UDim.new(0, 2)

--------------------------------------------------
-- Members

---
---@return RoactElement
---
function RoactMainWidget:Get()
    return Roact.createElement("Frame", {
        BackgroundColor3 = WidgetConstants.Color.Background[SocketController:GetTheme()],
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = MARGIN_PADDING,
            PaddingLeft = MARGIN_PADDING,
            PaddingRight = MARGIN_PADDING,
            PaddingTop = MARGIN_PADDING,
        }),
        Container = Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        }, {
            UIListLayout = Roact.createElement("UIListLayout", {
                Padding = MARGIN_PADDING,
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            SearchHolder = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, WidgetConstants.SearchBar.Pixel.LineHeight),
            }, {
                SearchContainer = RoactSearchBar:Get(),
            }),
            PlugHolder = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.new(1, 0, 1, -WidgetConstants.SearchBar.Pixel.LineHeight),
            }, {
                PlugContainer = RoactPlugContainer:Get(),
            }),
        }),
    })
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactMainWidget:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactPlugContainer = PluginFramework:Require("RoactPlugContainer")
    RoactSearchBar = PluginFramework:Require("RoactSearchBar")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    SocketController = PluginFramework:Require("SocketController")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactMainWidget:FrameworkStart() end

return RoactMainWidget
