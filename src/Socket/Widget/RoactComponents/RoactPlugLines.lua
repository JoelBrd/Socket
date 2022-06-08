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
local SocketSettings ---@type SocketSettings
local PlugConstants ---@type PlugConstants
local WidgetTheme ---@type WidgetTheme

--------------------------------------------------
-- Constants
local LINE_PADDING = 1
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)

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
    local iconColor = props.iconColor ---@type Color3
    local isIconImageId = props.isIconImageId ---@type boolean
    local detailsContainer = props.detailsContainer ---@type RoactElement
    local layoutOrder = props.layoutOrder ---@type number
    local scale = props.scale ---@type number

    -- Calculate sizing
    local iconDetailsPaddingPixel = WidgetConstants.RoactWidgetLine.Pixel.IconDetailsPadding * scale
    local leftPaddingWidthPixel = (indent * WidgetConstants.RoactWidgetLine.Pixel.Indent) * scale
    local arrowContainerWidthPixel = (WidgetConstants.RoactWidgetLine.Pixel.ArrowWidth - LINE_PADDING * 2) * scale
    local iconContainerWidthPixel = (WidgetConstants.RoactWidgetLine.Pixel.IconWidth - LINE_PADDING * 2) * scale
    local detailsHolderWidthPixel = -(leftPaddingWidthPixel + arrowContainerWidthPixel + iconContainerWidthPixel + iconDetailsPaddingPixel)

    -- Create children for arrow container
    local arrowContainerChildren = {} ---@type RoactElement[]
    if isOpen ~= nil then
        table.insert(
            arrowContainerChildren,
            Roact.createElement("ImageButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Arrow),
                Image = WidgetConstants.Images.Arrow,
                Rotation = isOpen and 90 or 0,

                [Roact.Event.MouseButton1Down] = onArrowClick,
            })
        )
    end

    ---@return RoactElement
    local function getIconElement()
        if isIconImageId then
            return Roact.createElement("ImageLabel", {
                Image = icon,
                ImageColor3 = iconColor,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
            })
        else
            return Roact.createElement("TextLabel", {
                Text = icon,
                TextColor3 = iconColor,
                Size = UDim2.fromScale(1, 1),
                TextScaled = true,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = SocketSettings:GetSetting("Font"),
            })
        end
    end

    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, WidgetConstants.RoactWidgetLine.Pixel.LineHeight * scale),
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
            IconElement = getIconElement(),
        }),
        DetailsHolder = Roact.createElement("Frame", {
            LayoutOrder = 4,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, detailsHolderWidthPixel, 1, 0),
        }, {
            UIPadding = Roact.createElement("UIPadding", {
                PaddingLeft = UDim.new(0, iconDetailsPaddingPixel),
            }),
            DetailsContainer = detailsContainer,
        }),
    })
end

---@param props table
---@return RoactElement
local function getGroup(props)
    -- Read props
    local name = props.name ---@type string
    local nameColor = props.nameColor ---@type Color3
    local isOpen = props.isOpen ---@type boolean
    local totalPlugs = props.totalPlugs ---@type number
    local icon = props.icon ---@type string
    local iconColor = props.iconColor ---@type Color3
    local isIconImageId = props.isIconImageId ---@type boolean
    local layoutOrder = props.layoutOrder ---@type number
    local scale = props.scale ---@type number

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
            Font = SocketSettings:GetSetting("Font"),
            Text = ("%s (%d)"):format(name, totalPlugs),
            TextColor3 = nameColor or WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Text),
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
        iconColor = iconColor,
        isIconImageId = isIconImageId,
        detailsContainer = detailsContainer,
        onArrowClick = onArrowClick,
        layoutOrder = layoutOrder,
        scale = scale,
    })
end

---@param props table
---@return RoactElement
local function getPlug(props)
    -- Read props
    local name = props.name ---@type string
    local nameColor = props.nameColor ---@type Color3
    local isOpen = props.isOpen ---@type boolean
    local icon = props.icon ---@type string
    local iconColor = props.iconColor ---@type Color3
    local isIconImageId = props.isIconImageId ---@type boolean
    local layoutOrder = props.layoutOrder ---@type number
    local plug = props.plug ---@type PlugDefinition
    local plugScript = props.plugScript ---@type ModuleScript
    local scale = props.scale ---@type number

    -- Create fragment based on studio state
    ---@return RoactFragment
    local function createFragment()
        local isStudioRunning = SocketController:IsRunning()
        if isStudioRunning then
            -- Get variables
            local isServerRunning = plug.State.Server.IsRunning and true or false
            local isClientRunning = plug.State.Client.IsRunning and true or false
            local textLabelXOffset = -(
                    WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth * 2
                    + WidgetConstants.RoactWidgetLine.Pixel.PlugTextButtonPadding
                    + WidgetConstants.RoactWidgetLine.Pixel.PlugRunButtonsPadding
                )

            return Roact.createFragment({
                TextLabel = Roact.createElement("TextLabel", {
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Font = SocketSettings:GetSetting("Font"),
                    Text = name,
                    Size = UDim2.new(1, textLabelXOffset, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = nameColor or WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Plug.Text),
                }),
                Padding = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.PlugTextButtonPadding, 1, 0),
                }),
                RunServerButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 3,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = "Server",
                        color = isServerRunning and Color3.fromRGB(191, 255, 139) or WidgetTheme:GetColor(
                            WidgetTheme.Indexes.PlugLines.Plug.RunButton
                        ),
                        strokeThickness = 1.5,
                        activatedDiscColor = Color3.fromRGB(48, 207, 0),
                        activatedCallback = function()
                            PlugHelper:RunPlugAt(plug, true, false)
                        end,
                    }),
                }),
                PaddingButtons = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 4,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.PlugRunButtonsPadding, 1, 0),
                }),
                RunClientButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 5,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = "Client",
                        color = isClientRunning and Color3.fromRGB(191, 255, 139) or WidgetTheme:GetColor(
                            WidgetTheme.Indexes.PlugLines.Plug.RunButton
                        ),
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
            local textLabelXOffset = -(
                    WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth + WidgetConstants.RoactWidgetLine.Pixel.PlugTextButtonPadding
                )

            return Roact.createFragment({
                TextLabel = Roact.createElement("TextLabel", {
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Font = SocketSettings:GetSetting("Font"),
                    Text = name,
                    Size = UDim2.new(1, textLabelXOffset, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = nameColor or WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Plug.Text),
                }),
                Padding = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.PlugTextButtonPadding, 1, 0),
                }),
                RunButtonHolder = Roact.createElement("Frame", {
                    LayoutOrder = 3,
                    Size = UDim2.new(0, WidgetConstants.RoactWidgetLine.Pixel.RunButtonWidth, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    RoactButton:Get({
                        text = isRunning and "Running" or "Run",
                        color = isRunning and Color3.fromRGB(191, 255, 139) or WidgetTheme:GetColor(
                            WidgetTheme.Indexes.PlugLines.Plug.RunButton
                        ),
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
        iconColor = iconColor,
        isIconImageId = isIconImageId,
        detailsContainer = detailsContainer,
        onArrowClick = onArrowClick,
        layoutOrder = layoutOrder,
        scale = scale,
    })
end

---@param props table
---@return RoactElement
local function getKeybind(props)
    -- Read props
    local keybind = props.keybind ---@type Enum.KeyCode[]
    local layoutOrder = props.layoutOrder ---@type number
    local scale = props.scale ---@type number

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
            Font = SocketSettings:GetSetting("Font"),
            Text = "Keybind",
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Text),
        }),
        KeybindLabel = Roact.createElement("TextLabel", {
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = SocketSettings:GetSetting("Font"),
            Text = keybindString,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Text),
        }),
    })

    -- Return line
    return createLine({
        indent = WidgetConstants.RoactWidgetLine.Indent.Keybind,
        icon = WidgetConstants.Icons.Keybind,
        detailsContainer = detailsContainer,
        layoutOrder = layoutOrder,
        scale = scale,
    })
end

---@param props table
---@return RoactElement
local function getSettings(props)
    -- Read props
    local layoutOrder = props.layoutOrder ---@type number
    local moduleScript = props.moduleScript ---@type ModuleScript
    local plug = props.plug ---@type PlugDefinition
    local scale = props.scale ---@type number

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
        scale = scale,
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
    local scale = props.scale ---@type number

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
            Font = SocketSettings:GetSetting("Font"),
            Text = "Fields",
            TextColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Text),
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
        scale = scale,
    })
end

---@param props table
---@return RoactElement
local function getField(props)
    -- Read props
    local field = props.field ---@type PlugField
    local plug = props.plug ---@type PlugDefinition
    local layoutOrder = props.layoutOrder ---@type number
    local scale = props.scale ---@type number

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
            instance.Text = finalValue and field.Type.ToString(finalValue) or ""
        end
    end

    -- Get current value
    local currentValue = plug.State.FieldValues[field.Name]
    local stringValue = currentValue ~= nil and field.Type.ToString(currentValue) or ""

    -- Custom behaviour
    local color = field.Type == PlugConstants.FieldType.Color3 and currentValue
    local doColor = color and true or false

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
            Font = SocketSettings:GetSetting("Font"),
            Text = field.Name,
            Size = UDim2.fromScale(0.5, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Text),
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
                Font = SocketSettings:GetSetting("Font"),
                PlaceholderColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Field.PlaceholderText),
                PlaceholderText = field.Type.Name,
                Text = stringValue,
                TextColor3 = doColor and COLOR_WHITE or WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Field.Text),
                TextScaled = true,
                TextStrokeTransparency = doColor and 0.4 or 1,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,

                [Roact.Event.FocusLost] = onFocusLost,
            }),
            Backing = Roact.createElement("Frame", {
                BackgroundColor3 = doColor and color or WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Field.Backing),
                Size = UDim2.fromScale(1, 1),
            }, {
                UICorner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(0, 1),
                }),
                UIStroke = Roact.createElement("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color = WidgetTheme:GetColor(WidgetTheme.Indexes.PlugLines.Field.Stroke),
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
        scale = scale,
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
    SocketSettings = PluginFramework:Require("SocketSettings")
    PlugConstants = PluginFramework:Require("PlugConstants")
    WidgetTheme = PluginFramework:Require("WidgetTheme")
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
