---
---Main Widget
---
---@class RoactSearchBar
---
local RoactSearchBar = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local WidgetConstants ---@type WidgetConstants
local SocketController ---@type SocketController
local SocketConstants ---@type SocketConstants

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---@param props table
---@return RoactElement
---
function RoactSearchBar:Get(props)
    -- Read props
    local scale = props.scale ---@type number

    ---@param instance TextBox
    local function onTextChanged(instance)
        local text = instance.Text
        local roduxStore = SocketController:GetStore()

        -- Send action with new text
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.PLUGS.SEARCH_TEXT,
            data = {
                text = text,
            },
        }
        roduxStore:dispatch(action)
    end

    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 4),
        }),
        Background = Roact.createElement("Frame", {
            BackgroundColor3 = WidgetConstants.Color.SearchBar.Background[SocketController:GetTheme()],
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.95, 1),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 15),
            }),
            UIListLayout = Roact.createElement("UIListLayout", {
                Padding = UDim.new(0, 2),
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            UIStroke = Roact.createElement("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = WidgetConstants.Color.SearchBar.Stroke[SocketController:GetTheme()],
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 2,
                Transparency = 0.2,
            }),
            UIPadding = Roact.createElement("UIPadding", {
                PaddingLeft = UDim.new(0, 2),
            }),
            IconContainer = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, WidgetConstants.SearchBar.Pixel.IconWidth * scale, 1, 0),
                LayoutOrder = 1,
            }, {
                TextLabel = Roact.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = WidgetConstants.Icons.Search,
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.55),
                    Size = UDim2.fromScale(0.8, 0.8),
                    Font = SocketController:GetSetting("Font"),
                }),
            }),
            TextBoxContainer = Roact.createElement("Frame", {
                Size = UDim2.new(1, -WidgetConstants.SearchBar.Pixel.IconWidth * scale, 1, 0),
                BackgroundTransparency = 1,
                LayoutOrder = 2,
            }, {
                TextBox = Roact.createElement("TextBox", {
                    Font = SocketController:GetSetting("Font"),
                    PlaceholderText = "Search",
                    Text = "",
                    PlaceholderColor3 = WidgetConstants.Color.SearchBar.PlaceholderText[SocketController:GetTheme()],
                    TextColor3 = WidgetConstants.Color.SearchBar.Text[SocketController:GetTheme()],
                    TextScaled = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromScale(0.95, 1),

                    [Roact.Change.Text] = onTextChanged,
                }),
            }),
        }),
    })
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactSearchBar:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    SocketController = PluginFramework:Require("SocketController")
    SocketConstants = PluginFramework:Require("SocketConstants")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactSearchBar:FrameworkStart() end

return RoactSearchBar
