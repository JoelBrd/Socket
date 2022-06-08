---
---Roact stuff for all the plugs
---
---@class RoactPlugContainer
---
local RoactPlugContainer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux
local SocketConstants ---@type SocketConstants
local RoactPlugLines ---@type RoactPlugLines
local WidgetConstants ---@type WidgetConstants

--------------------------------------------------
-- Constants
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)

--------------------------------------------------
-- Members

---@param str string
---@return boolean
local function couldStringBeIconImageId(str)
    return str:find("rbxassetid")
end

---Creates all of the individual lines to populate the PlugContainer
---@param props table
---@return RoactFragment
local function createLinesFragment(props)
    -- Grab variables
    local groups = props.groups ---@type RoactMainWidgetProps.GroupInfo[]
    local scale = props.scale ---@type number
    local elements = {}
    local layoutOrderCount = 0

    local function increaseLayoutOrder()
        layoutOrderCount = layoutOrderCount + 1
    end

    for _, groupInfo in pairs(groups) do
        if groupInfo.isVisible then
            -- Create group line
            increaseLayoutOrder()
            local groupElementName = ("Group_%s"):format(groupInfo.name)
            local groupIcon = groupInfo.icon or WidgetConstants.Icons.Unknown
            elements[groupElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Group, {
                name = groupInfo.name,
                isOpen = groupInfo.isOpen,
                totalPlugs = #groupInfo.plugs,
                icon = groupIcon,
                iconColor = groupInfo.iconColor or COLOR_WHITE,
                isIconImageId = couldStringBeIconImageId(groupIcon),
                layoutOrder = layoutOrderCount,
                scale = scale,
            })

            if groupInfo.isOpen then
                -- Create plugs
                for _, plugInfo in pairs(groupInfo.plugs) do
                    if plugInfo.isVisible then
                        -- Create plug line
                        increaseLayoutOrder()
                        local plugElementName = ("Group_%s_Plug_%s"):format(groupInfo.name, plugInfo.name)
                        local plugIcon = plugInfo.plug.Icon or WidgetConstants.Icons.Unknown
                        elements[plugElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Plug, {
                            name = plugInfo.name,
                            isOpen = plugInfo.isOpen,
                            icon = plugIcon,
                            iconColor = plugInfo.plug.IconColor or COLOR_WHITE,
                            isIconImageId = couldStringBeIconImageId(plugIcon),
                            layoutOrder = layoutOrderCount,
                            scale = scale,
                            plug = plugInfo.plug,
                            plugScript = plugInfo.moduleScript,
                        })

                        -- Create child lines
                        if plugInfo.isOpen then
                            -- Create fields line
                            increaseLayoutOrder()
                            local hasFields = #plugInfo.plug.Fields > 0
                            local fieldsElementName = ("Group_%s_Plug_%s_Fields"):format(groupInfo.name, plugInfo.name)
                            elements[fieldsElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Fields, {
                                isOpen = plugInfo.isFieldsOpen,
                                plugScript = plugInfo.moduleScript,
                                hasFields = hasFields,
                                layoutOrder = layoutOrderCount,
                                scale = scale,
                            })

                            -- Create individual fields
                            if hasFields and plugInfo.isFieldsOpen then
                                for _, field in pairs(plugInfo.plug.Fields) do
                                    increaseLayoutOrder()
                                    local fieldElementName = ("Group_%s_Plug_%s_Field_%s"):format(groupInfo.name, plugInfo.name, field.Name)
                                    elements[fieldElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Field, {
                                        field = field,
                                        plug = plugInfo.plug,
                                        layoutOrder = layoutOrderCount,
                                        scale = scale,
                                    })
                                end
                            end

                            -- Create keybind line
                            increaseLayoutOrder()
                            local keybindElementName = ("Group_%s_Plug_%s_Keybind"):format(groupInfo.name, plugInfo.name)
                            elements[keybindElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Keybind, {
                                keybind = plugInfo.plug.Keybind or {},
                                layoutOrder = layoutOrderCount,
                                scale = scale,
                            })

                            -- Create setting line
                            increaseLayoutOrder()
                            local settingsElementName = ("Group_%s_Plug_%s_Settings"):format(groupInfo.name, plugInfo.name)
                            elements[settingsElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Settings, {
                                moduleScript = plugInfo.moduleScript,
                                layoutOrder = layoutOrderCount,
                                scale = scale,
                                plug = plugInfo.plug,
                            })
                        end
                    end
                end
            end
        end
    end

    -- Create bottom padding
    increaseLayoutOrder()
    local paddingElementName = ("BottomPadding"):format()
    elements[paddingElementName] = Roact.createElement("Frame", {
        LayoutOrder = layoutOrderCount,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, WidgetConstants.RoactWidgetLine.Pixel.BottomPaddingHeight),
    })

    return Roact.createFragment(elements)
end

---
---@param props table
---@return RoactElement
---
function RoactPlugContainer:Get(props)
    return Roact.createElement("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 6,
        BorderSizePixel = 0,
    }, {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 4),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
        Lines = createLinesFragment(props),
    })
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactPlugContainer:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactRodux = PluginFramework:Require("RoactRodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    RoactPlugLines = PluginFramework:Require("RoactPlugLines")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactPlugContainer:FrameworkStart() end

return RoactPlugContainer
