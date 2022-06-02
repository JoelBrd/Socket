---
---Holds components for a singular line in our widget
---
---@class RoactWidgetLine
---
local RoactWidgetLine = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type PluginFramework
local Roact ---@type Roact
local WidgetConstants ---@type WidgetConstants
local Logger ---@type Logger
local RoactWidgetLineTypeInfo ---@type RoactWidgetLineTypeInfo

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---Creates the arrow toggle
---@param props table
---@return RoactElement
local function createArrowToggle(props)
    -- Read Props
    local showArrow = props.showArrow
    local isOpen = props.isOpen

    -- Write Variables
    local image = showArrow and WidgetConstants.Images.Arrow or ""
    local rotation = isOpen and 90 or 0

    -- Create Element
    return Roact.createElement("ImageLabel", {
        Image = image,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        Rotation = rotation,
        Size = UDim2.fromScale(1, 1),
    })
end

---Creates an icon + populates
---@param props table
---@return RoactElement
local function createIcon(props)
    -- Read Props
    local icon = props.icon

    -- Write variables
    local isImageId = string.find(icon, "asset") and true or false
    local font = WidgetConstants.Font.Default

    -- Create element
    if isImageId then
        -- Is an image
        return Roact.createElement("ImageLabel", {
            Image = icon,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Fit,
        })
    else
        -- Is text (e.g., emoji)
        return Roact.createElement("TextLabel", {
            Font = font,
            Text = icon,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = 18,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        })
    end
end

---Creates the basic template that all lines have
--- Indent Padding
--- Arrow Widget (optional)
--- Icon
---@param props table
---@param informationElement RoactElement
---@return RoactElement
---
---@overload fun(props:table):RoactElement
local function createLine(props, informationElement)
    -- Read Props
    --[[
        indent:number
        layoutOrder:number
        icon:string
        showArrow:boolean
        isOpen:boolean
    --]]
    local indent = props.indent or 0
    local layoutOrder = props.layoutOrder

    -- Write variables
    local indentPixels = indent * WidgetConstants.RoactWidgetLine.Pixel.Indent
    local informationPixels = -(
            indentPixels
            + WidgetConstants.RoactWidgetLine.Pixel.ArrowWidth
            + WidgetConstants.RoactWidgetLine.Pixel.IconWidth
        )

    -- Create Element
    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, WidgetConstants.RoactWidgetLine.Pixel.LineHeight),
    }, {
        uIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 1),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 1),
        }),
        uIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        paddingFrame = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(0, indentPixels, 1, 0),
        }),
        arrowContainer = Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.ArrowWidth, 1, 0),
        }, {
            arrow = createArrowToggle(props),
        }),

        iconContainer = Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.IconWidth, 1, 0),
        }, {
            icon = createIcon(props),
        }),

        informationContainer = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.new(1, informationPixels, 1, 0),
        }, {
            information = informationElement,
        }),
    })
end

---
---@param lineType string
---@param props table
---@return RoactElement
---
function RoactWidgetLine:GetElement(lineType, props)
    -- Check parameters
    local isValidLineType = table.find(WidgetConstants.RoactWidgetLine.Type, lineType)
    if not isValidLineType then
        Logger:Error(("Invalid RoactWidgetLineType %q"):format(tostring(lineType)))
    end

    local isValidProps = typeof(props) == "table"
    if not isValidProps then
        Logger:Error(("Invalid Props %q"):format(tostring(props)))
    end

    -- Get Info Element
    local infoElement = RoactWidgetLineTypeInfo:GetElement(lineType, props)

    -- Return Element
    return createLine(props, infoElement)
end

---@private
function RoactWidgetLine:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    Logger = PluginFramework:Require("Logger")
    RoactWidgetLineTypeInfo = PluginFramework:Require("RoactWidgetLineTypeInfo")
end

---@private
function RoactWidgetLine:FrameworkStart() end

return RoactWidgetLine
