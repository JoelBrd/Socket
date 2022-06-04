---
---Contains the different lines for our PlugContainer
---
---@class RoactPlugLines
---
local RoactPlugLines = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux
local SocketConstants ---@type SocketConstants
local WidgetConstants ---@type WidgetConstants
local Logger ---@type Logger

--------------------------------------------------
-- Constants
local LINE_PADDING = 1

--------------------------------------------------
-- Members
local gettersByLineType = {} ---@type table<string, fun(props:table):RoactElement>

---@param props table
---@return RoactElement
local function createLine(props)
    -- Read props
    local indent = props.indent ---@type number
    local isOpen = props.isOpen ---@type boolean
    local icon = props.icon ---@type string
    local onArrowClick = props.onArrowClick ---@type function
    local detailsContainer = props.detailsContainer ---@type RoactElement

    -- Calculate sizing
    local leftPaddingWidthPixel = indent * WidgetConstants.RoactWidgetLine.Pixel.Indent
    local arrowContainerWidthPixel = WidgetConstants.RoactWidgetLine.Pixel.ArrowWidth - LINE_PADDING * 2
    local iconContainerWidthPixel = WidgetConstants.RoactWidgetLine.Pixel.IconWidth - LINE_PADDING * 2
    local detailsHolderWidthPixel = -(leftPaddingWidthPixel + arrowContainerWidthPixel + iconContainerWidthPixel)

    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, WidgetConstants.RoactWidgetLine.Pixel.LineHeight),
    }, {
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        UIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 1),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 1),
        }),
        LeftPadding = Roact.createElement("Frame", {
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, leftPaddingWidthPixel, 1, 0),
        }),
        ArrowContainer = Roact.createElement("Frame", {
            LayoutOrder = 2,
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Size = UDim2.new(1, 0, 0, arrowContainerWidthPixel),
            BackgroundTransparency = 1,
        }, {
            ImageButton = Roact.createElement("ImageButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                Image = WidgetConstants.Images.Arrow,
                Rotation = isOpen and 90 or 0,

                [Roact.Event.Activated] = onArrowClick,
            }),
        }),
        IconContainer = Roact.createElement("Frame", {
            LayoutOrder = 3,
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Size = UDim2.new(1, 0, 0, iconContainerWidthPixel),
            BackgroundTransparency = 1,
        }, {
            TextLabel = Roact.createElement("TextLabel", {
                Text = icon,
                Size = UDim2.fromScale(1, 1),
                TextScaled = true,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = Enum.Font.Highway,
            }),
        }),
        DetailsHolder = Roact.createElement("Frame", {
            LayoutOrder = 4,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, detailsHolderWidthPixel, 1, 0),
        }, {
            DetailsContainer = detailsContainer,
        }),
    })
end

---@param props table
---@return RoactElement
local function getGroup(props)
    -- Read props
    local name = props.name

    -- Create Details
    local detailsContainer = Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
        }),
        TextLabel = Roact.createElement("TextLabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.Highway,
            Text = name,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
    })

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Group,
        isOpen = false,
        icon = "?",
        detailsContainer = detailsContainer,
        onArrowClick = function()
            print("click", name)
        end,
    })
end

---
---@param lineType string WidgetConstants.RoactWidgetLine.Type
---@param props table
---@return RoactElement
---
function RoactPlugLines:Get(lineType, props)
    local getter = gettersByLineType[lineType]
    if not getter then
        Logger:Error(("No getter defined for line type %q"):format(lineType))
    end

    return getter(props)
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactPlugLines:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactRodux = PluginFramework:Require("RoactRodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    Logger = PluginFramework:Require("Logger")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactPlugLines:FrameworkStart()
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Group] = getGroup
end

return RoactPlugLines
