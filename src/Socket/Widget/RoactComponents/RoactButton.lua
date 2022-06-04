---
---Pretty button
---
---@class RoactButton
---
local RoactButton = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local WidgetConstants ---@type WidgetConstants

--------------------------------------------------
-- Constants
local IMAGE = "http://www.roblox.com/asset/?id=9028010883"
local CORNER_RADIUS = UDim.new(0, 4)
local STROKE_COLOR = Color3.fromRGB(0, 0, 0)
local STROKE_THICKNESS = 1
local STROKE_TRANSPARENCY = 0
local HOVER_SATURATION_MULTIPLIER = 0.7
local ACTIVATED_VALUE_MULTIPLIER = 0.7

--------------------------------------------------
-- Members

---
---@param props table
---@return RoactElement
---
function RoactButton:Get(props)
    -- Read props
    local text = props.text ---@type string
    local color = props.color ---@type Color3
    local activatedCallback = props.activatedCallback ---@type function
    local cornerRadius = props.cornerRadius ---@type UDim optional
    local strokeColor = props.strokeColor ---@type Color3 optional
    local strokeThickness = props.strokeThickness ---@type number optional
    local strokeTransparency = props.strokeTransparency ---@type number optional

    ---@param instance Instance
    local function onActivated(instance)
        local h, s, v = color:ToHSV()
        local activatedColor = Color3.fromHSV(h, s, v * ACTIVATED_VALUE_MULTIPLIER)
        instance.ImageColor3 = activatedColor
    end

    ---@param instance Instance
    local function onMouseEnter(instance)
        local h, s, v = color:ToHSV()
        local enterColor = Color3.fromHSV(h, s * HOVER_SATURATION_MULTIPLIER, v)
        instance.ImageColor3 = enterColor
    end

    ---@param instance Instance
    local function onMouseLeave(instance)
        instance.ImageColor3 = color
    end

    return Roact.createElement("ImageButton", {
        BackgroundTransparency = 1,
        HoverImage = IMAGE,
        Image = IMAGE,
        PressedImage = IMAGE,
        ImageColor3 = color,
        Size = UDim2.fromScale(1, 1),

        [Roact.Event.Activated] = function(instance)
            onActivated(instance)
            activatedCallback()
        end,
        [Roact.Event.MouseEnter] = onMouseEnter,
        [Roact.Event.MouseLeave] = onMouseLeave,
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = cornerRadius or CORNER_RADIUS,
        }),
        UIStroke = Roact.createElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = strokeColor or STROKE_COLOR,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = strokeThickness or STROKE_THICKNESS,
            Transparency = strokeTransparency or STROKE_TRANSPARENCY,
        }),
        TextLabel = Roact.createElement("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            TextScaled = true,
            Font = WidgetConstants.Font,
            BackgroundTransparency = 1,
            Text = text,
        }),
    })
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactButton:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactButton:FrameworkStart() end

return RoactButton
