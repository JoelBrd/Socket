---
---Holds info components for the different RoactWidgetLineTypes
---
---@class RoactWidgetLineTypeInfo
---
local RoactWidgetLineTypeInfo = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type PluginFramework
local Roact ---@type Roact
local WidgetConstants ---@type WidgetConstants
local Logger ---@type Logger

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local elementFunctionsByType = {} ---@type table<string, fun(props:table):RoactElement>

---Creates the text that appears on any given line
---@param props table
---@return RoactElement
local function createTitleElement(props)
    -- Read Props
    --[[
        size:UDim2
        text:string
        layoutOrder:number
    --]]
    local size = props.size
    local text = props.text
    local layoutOrder = props.layoutOrder

    -- Write Variables
    local font = WidgetConstants.Font.Default

    -- Create Element
    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = size,
    }, {
        uIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
        }),

        textLabel = Roact.createElement("TextLabel", {
            Font = font,
            Text = text,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextScaled = true,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        }),
    })
end

---@param props table
---@return RoactElement
local function createElementGroup(props)
    -- Read Props
    --[[
        groupName:string
    --]]
    local groupName = props.groupName

    return createTitleElement({
        size = UDim2.new(1, 0, 1, 0),
        text = groupName,
        layoutOrder = 1,
    })
end

---
---@param lineType string
---@param props table
---@return RoactElement
---
function RoactWidgetLineTypeInfo:GetElement(lineType, props)
    -- Check parameters
    local isValidLineType = table.find(WidgetConstants.RoactWidgetLine.Type, lineType)
    if not isValidLineType then
        Logger:Error(("Invalid RoactWidgetLineType %q"):format(tostring(lineType)))
    end

    local isValidProps = typeof(props) == "table"
    if not isValidProps then
        Logger:Error(("Invalid Props %q"):format(tostring(props)))
    end

    -- ERROR: No function for `lineType`
    local elementFunction = elementFunctionsByType[lineType]
    if not elementFunction then
        Logger:Error(("No element function for RoactWidgetLineType %q"):format(tostring(lineType)))
    end

    return elementFunction(props)
end

---@private
function RoactWidgetLineTypeInfo:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    Logger = PluginFramework:Require("Logger")
end

---@private
function RoactWidgetLineTypeInfo:FrameworkStart()
    elementFunctionsByType[WidgetConstants.RoactWidgetLine.Type.Group] = createElementGroup
end

return RoactWidgetLineTypeInfo
