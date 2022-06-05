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
local TweenConstructor ---@type TweenConstructor
local SocketController ---@type SocketController

--------------------------------------------------
-- Constants
local IMAGE = "http://www.roblox.com/asset/?id=9028010883"
local CORNER_RADIUS = UDim.new(0, 4)
local STROKE_COLOR = Color3.fromRGB(0, 0, 0)
local STROKE_THICKNESS = 1
local STROKE_TRANSPARENCY = 0
local BACKGROUND_COLOR_TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local HOVER_BACKGROUND_HSV_MULTIPLIER = { h = 1, s = 1, v = 0.85 }
local ACTIVATED_DISC_GOAL_SIZE = UDim2.fromOffset(150, 150)
local ACTIVATED_DISC_TWEEN_INFO = TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

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
    local activatedDiscColor = props.activatedDiscColor ---@type Color3 optional
    local cornerRadius = props.cornerRadius ---@type UDim optional
    local strokeColor = props.strokeColor ---@type Color3 optional
    local strokeThickness = props.strokeThickness ---@type number optional
    local strokeTransparency = props.strokeTransparency ---@type number optional

    -- Create variables
    local backgroundColorTween = nil ---@type Tween

    ---@param instance ImageButton
    ---@param toColor Color3
    local function tweenBackgroundColor(instance, toColor)
        if backgroundColorTween then
            backgroundColorTween:Cancel()
            backgroundColorTween:Destroy()
            backgroundColorTween = nil
        end

        backgroundColorTween = TweenConstructor.new()
            :SetInstance(instance)
            :SetTweenInfo(BACKGROUND_COLOR_TWEEN_INFO)
            :SetProperty("ImageColor3", toColor)
            :Play()
    end

    ---@param instance ImageButton
    ---@param x number
    ---@param y number
    local function onActivated(instance, x, y)
        -- Create disc
        local disc = Instance.new("Frame") ---@type Frame
        disc.BackgroundColor3 = activatedDiscColor or Color3.fromRGB(255, 255, 255)
        disc.Size = UDim2.fromScale(0, 0)
        disc.AnchorPoint = Vector2.new(0.5, 0.5)
        disc.Transparency = 0.5
        disc.Parent = instance

        local uiCorner = Instance.new("UICorner") ---@type UICorner
        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = disc

        -- Calculate position
        disc.Position = UDim2.fromOffset(x - instance.AbsolutePosition.X, y - instance.AbsolutePosition.Y)

        -- Tween
        local discTween = TweenConstructor.new()
            :SetInstance(disc)
            :SetTweenInfo(ACTIVATED_DISC_TWEEN_INFO)
            :SetProperty("Transparency", 1)
            :SetProperty("Size", ACTIVATED_DISC_GOAL_SIZE)
            :Play()

        -- Cleanup
        task.spawn(function()
            wait(ACTIVATED_DISC_TWEEN_INFO.Time)
            discTween:Destroy()
            disc:Destroy()
        end)
    end

    ---@param instance ImageButton
    local function onMouseEnter(instance)
        local h, s, v = color:ToHSV()
        local enterColor = Color3.fromHSV(
            h * HOVER_BACKGROUND_HSV_MULTIPLIER.h,
            s * HOVER_BACKGROUND_HSV_MULTIPLIER.s,
            v * HOVER_BACKGROUND_HSV_MULTIPLIER.v
        )
        tweenBackgroundColor(instance, enterColor)
    end

    ---@param instance ImageButton
    local function onMouseLeave(instance)
        tweenBackgroundColor(instance, color)
    end

    return Roact.createElement("ImageButton", {
        BackgroundTransparency = 1,
        HoverImage = IMAGE,
        Image = IMAGE,
        PressedImage = IMAGE,
        ImageColor3 = color,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,

        [Roact.Event.MouseButton1Down] = function(instance, x, y)
            onActivated(instance, x, y)
            activatedCallback(instance)
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
            Font = SocketController:GetSetting("Font"),
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
    TweenConstructor = PluginFramework:Require("TweenConstructor")
    SocketController = PluginFramework:Require("SocketController")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactButton:FrameworkStart() end

return RoactButton
