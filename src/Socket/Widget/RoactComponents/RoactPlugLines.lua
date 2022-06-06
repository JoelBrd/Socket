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
local PluginHandler ---@type PluginHandler
local RoactButton ---@type RoactButton
local SocketController ---@type SocketController
local PlugHelper ---@type PlugHelper

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
    local onArrowClick = props.onArrowClick ---@type function optional (required when isOpen ~= nil)
    local icon = props.icon ---@type string
    local detailsContainer = props.detailsContainer ---@type RoactElement
    local layoutOrder = props.layoutOrder ---@type number

    -- Calculate sizing
    local leftPaddingWidthPixel = indent * WidgetConstants.RoactWidgetLine.Pixel.Indent
    local arrowContainerWidthPixel = WidgetConstants.RoactWidgetLine.Pixel.ArrowWidth - LINE_PADDING * 2
    local iconContainerWidthPixel = WidgetConstants.RoactWidgetLine.Pixel.IconWidth - LINE_PADDING * 2
    local detailsHolderWidthPixel = -(leftPaddingWidthPixel + arrowContainerWidthPixel + iconContainerWidthPixel)

    -- Create children for arrow container
    local arrowContainerChildren = {} ---@type RoactElement[]
    if isOpen ~= nil then
        table.insert(
            arrowContainerChildren,
            Roact.createElement("ImageButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = WidgetConstants.Color.PlugLines.Arrow[SocketController:GetTheme()],
                Image = WidgetConstants.Images.Arrow,
                Rotation = isOpen and 90 or 0,

                [Roact.Event.MouseButton1Down] = onArrowClick,
            })
        )
    end

    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, WidgetConstants.RoactWidgetLine.Pixel.LineHeight),
        LayoutOrder = layoutOrder,
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
        }, arrowContainerChildren),
        IconContainer = Roact.createElement("Frame", {
            LayoutOrder = 3,
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Size = UDim2.new(1, 0, 0, iconContainerWidthPixel),
            BackgroundTransparency = 1,
        }, {
            TextLabel = Roact.createElement("TextLabel", {
                Text = icon,
                TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
                Size = UDim2.fromScale(1, 1),
                TextScaled = true,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = SocketController:GetSetting("Font"),
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
    local name = props.name ---@type string
    local isOpen = props.isOpen ---@type boolean
    local totalPlugs = props.totalPlugs ---@type number
    local icon = props.icon ---@type string
    local layoutOrder = props.layoutOrder ---@type number

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
            Font = SocketController:GetSetting("Font"),
            Text = ("%s (%d)"):format(name, totalPlugs),
            TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
    })

    -- Arrow callback
    local function onArrowClick()
        -- Get Store
        local roduxStore = SocketController:GetStore()

        -- Send action
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.PLUGS.TOGGLE_GROUP_VISIBILITY,
            data = {
                group = name,
            },
        }
        roduxStore:dispatch(action)
    end

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Group,
        isOpen = isOpen,
        icon = icon,
        detailsContainer = detailsContainer,
        onArrowClick = onArrowClick,
        layoutOrder = layoutOrder,
    })
end

---@param props table
---@return RoactElement
local function getPlug(props)
    -- Read props
    local name = props.name ---@type string
    local isOpen = props.isOpen ---@type boolean
    local icon = props.icon ---@type string
    local layoutOrder = props.layoutOrder ---@type number
    local plug = props.plug ---@type PlugDefinition
    local plugScript = props.plugScript ---@type ModuleScript

    -- Create fragment based on studio state
    ---@return RoactFragment
    local function createFragment()
        local isStudioRunning = SocketController:IsRunning()
        if isStudioRunning then
            -- Get variables
            local isServerRunning = plug.State.Server.IsRunning and true or false
            local isClientRunning = plug.State.Client.IsRunning and true or false

            return Roact.createFragment({
                TextLabel = Roact.createElement("TextLabel", {
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Font = SocketController:GetSetting("Font"),
                    Text = name,
                    Size = UDim2.new(1, -WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth * 2, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
                }),
                RunServerButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 2,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = "Server",
                        color = isServerRunning and Color3.fromRGB(191, 255, 139) or Color3.fromRGB(250, 250, 250),
                        strokeThickness = 1.5,
                        activatedDiscColor = Color3.fromRGB(48, 207, 0),
                        activatedCallback = function()
                            PlugHelper:RunPlugAt(plug, true, false)
                        end,
                    }),
                }),
                RunClientButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 3,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = "Client",
                        color = isClientRunning and Color3.fromRGB(191, 255, 139) or Color3.fromRGB(250, 250, 250),
                        strokeThickness = 1.5,
                        activatedDiscColor = Color3.fromRGB(48, 207, 0),
                        activatedCallback = function()
                            PlugHelper:RunPlugAt(plug, false, true)
                        end,
                    }),
                }),
            })
        else
            -- Get variables
            local isRunning = plug.State.IsRunning and true or false

            return Roact.createFragment({
                TextLabel = Roact.createElement("TextLabel", {
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Font = SocketController:GetSetting("Font"),
                    Text = name,
                    Size = UDim2.new(1, -WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
                }),
                RunButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 2,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = isRunning and "Running" or "Run",
                        color = isRunning and Color3.fromRGB(191, 255, 139) or Color3.fromRGB(250, 250, 250),
                        strokeThickness = 1.5,
                        activatedDiscColor = Color3.fromRGB(48, 207, 0),
                        activatedCallback = function()
                            PlugHelper:RunPlug(plug)
                        end,
                    }),
                }),
            })
        end
    end

    -- Create Details
    local detailsContainer = Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 1),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        Fragment = createFragment(),
    })

    -- Arrow callback
    local function onArrowClick()
        -- Get Store
        local roduxStore = SocketController:GetStore()

        -- Send action
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.PLUGS.TOGGLE_PLUG_VISIBILITY,
            data = {
                script = plugScript,
            },
        }
        roduxStore:dispatch(action)
    end

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Plug,
        isOpen = isOpen,
        icon = icon,
        detailsContainer = detailsContainer,
        onArrowClick = onArrowClick,
        layoutOrder = layoutOrder,
    })
end

---@param props table
---@return RoactElement
local function getKeybind(props)
    -- Read props
    local keybind = props.keybind ---@type Enum.KeyCode[]
    local layoutOrder = props.layoutOrder ---@type number

    -- Create keybind string
    local keybindString ---@type string
    if #keybind > 0 then
        keybindString = keybind[1].Name
        for i = 2, #keybind do
            keybindString = ("%s + %s"):format(keybindString, keybind[i].Name)
        end
    else
        keybindString = "None"
    end

    -- Create Details
    local detailsContainer = Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
        }),
        TitleLabel = Roact.createElement("TextLabel", {
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = SocketController:GetSetting("Font"),
            Text = "Keybind",
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
        }),
        KeybindLabel = Roact.createElement("TextLabel", {
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = SocketController:GetSetting("Font"),
            Text = keybindString,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
        }),
    })

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Keybind,
        icon = WidgetConstants.Icons.Keybind,
        detailsContainer = detailsContainer,
        layoutOrder = layoutOrder,
    })
end

---@param props table
---@return RoactElement
local function getSettings(props)
    -- Read props
    local layoutOrder = props.layoutOrder ---@type number
    local moduleScript = props.moduleScript ---@type ModuleScript
    local plug = props.plug ---@type PlugDefinition

    -- Create Details
    local detailsContainer = Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 1),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
        }),
        ViewSourceHolder = Roact.createElement("Frame", {
            LayoutOrder = 1,
            Size = UDim2.fromScale(0.5, 1),
            BackgroundTransparency = 1,
        }, {
            RoactButton:Get({
                text = "View Source",
                color = Color3.fromRGB(255, 244, 160),
                activatedCallback = function()
                    PlugHelper:ViewSource(moduleScript)
                end,
            }),
        }),
        DescriptionHolder = Roact.createElement("Frame", {
            LayoutOrder = 2,
            Size = UDim2.fromScale(0.5, 1),
            BackgroundTransparency = 1,
        }, {
            RoactButton:Get({
                text = "Description",
                color = Color3.fromRGB(111, 182, 230),
                activatedCallback = function()
                    PlugHelper:ShowDescription(plug)
                end,
            }),
        }),
    })

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Settings,
        icon = WidgetConstants.Icons.Settings,
        detailsContainer = detailsContainer,
        layoutOrder = layoutOrder,
    })
end

---@param props table
---@return RoactElement
local function getFields(props)
    -- Read props
    local hasFields = props.hasFields ---@type boolean
    local isOpen = props.isOpen ---@type boolean
    local layoutOrder = props.layoutOrder ---@type number
    local plugScript = props.plugScript ---@type ModuleScript

    -- Update open status (only show arrow if there are fields)
    if not hasFields then
        isOpen = nil
    end

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
            Font = SocketController:GetSetting("Font"),
            Text = "Fields",
            TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
    })

    -- Arrow callback
    local function onArrowClick()
        -- Get Store
        local roduxStore = SocketController:GetStore()

        -- Send action
        ---@type RoduxAction
        local action = {
            type = SocketConstants.RoduxActionType.PLUGS.TOGGLE_FIELDS_VISIBILITY,
            data = {
                script = plugScript,
            },
        }
        roduxStore:dispatch(action)
    end

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Fields,
        isOpen = isOpen,
        icon = WidgetConstants.Icons.Fields,
        detailsContainer = detailsContainer,
        onArrowClick = onArrowClick,
        layoutOrder = layoutOrder,
    })
end

---@param props table
---@return RoactElement
local function getField(props)
    -- Read props
    local field = props.field ---@type PlugField
    local plug = props.plug ---@type PlugDefinition
    local layoutOrder = props.layoutOrder ---@type number

    ---User has clicked off the textbox; try validate input
    ---@param instance TextBox
    local function onFocusLost(instance)
        -- Clear
        local text = instance.Text
        if text:len() == 0 then
            PlugHelper:ClearField(plug, field)
            return
        end

        -- Try update
        local finalValue, didUpdate = PlugHelper:UpdateField(plug, field, text)
        if not didUpdate then
            instance.Text = tostring(finalValue)
        end
    end

    -- Get current value
    local currentValue = plug.State.FieldValues[field.Name]
    local currentValueString = currentValue == nil and "" or tostring(currentValue)

    -- Create Details
    local detailsContainer = Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 2),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        TitleLabel = Roact.createElement("TextLabel", {
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = SocketController:GetSetting("Font"),
            Text = field.Name,
            Size = UDim2.fromScale(0.5, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = WidgetConstants.Color.PlugLines.Text[SocketController:GetTheme()],
        }),
        TextboxHolder = Roact.createElement("Frame", {
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.5, 1),
        }, {
            UIPadding = Roact.createElement("UIPadding", {
                PaddingBottom = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 2),
            }),
            TextBox = Roact.createElement("TextBox", {
                Font = SocketController:GetSetting("Font"),
                PlaceholderColor3 = WidgetConstants.Color.PlugLines.Field.PlaceholderText[SocketController:GetTheme()],
                PlaceholderText = field.Type.Name,
                Text = currentValueString,
                TextColor3 = WidgetConstants.Color.PlugLines.Field.Text[SocketController:GetTheme()],
                TextScaled = true,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,

                [Roact.Event.FocusLost] = onFocusLost,
            }),
            Backing = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
            }, {
                UICorner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(0, 1),
                }),
                UIStroke = Roact.createElement("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color = WidgetConstants.Color.PlugLines.Field.Stroke[SocketController:GetTheme()],
                    LineJoinMode = Enum.LineJoinMode.Round,
                    Thickness = 2,
                    Transparency = 0.2,
                }),
            }),
        }),
    })

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Field,
        icon = field.Type.Icon,
        detailsContainer = detailsContainer,
        layoutOrder = layoutOrder,
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
    PluginHandler = PluginFramework:Require("PluginHandler")
    RoactButton = PluginFramework:Require("RoactButton")
    SocketController = PluginFramework:Require("SocketController")
    PlugHelper = PluginFramework:Require("PlugHelper")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactPlugLines:FrameworkStart()
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Group] = getGroup
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Plug] = getPlug
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Keybind] = getKeybind
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Settings] = getSettings
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Fields] = getFields
    gettersByLineType[WidgetConstants.RoactWidgetLine.Type.Field] = getField
end

return RoactPlugLines
