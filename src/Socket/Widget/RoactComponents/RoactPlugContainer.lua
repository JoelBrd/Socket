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
-- ...

--------------------------------------------------
-- Members

---Creates all of the individual lines to populate the PlugContainer
---@param props table
---@return RoactFragment
local function createLinesFragment(props)
    -- Grab variables
    local groups = props.groups ---@type RoactMainWidgetProps.GroupInfo[]
    local elements = {}
    local layoutOrderCount = 0

    local function increaseLayoutOrder()
        layoutOrderCount = layoutOrderCount + 1
    end

    for _, groupInfo in pairs(groups) do
        if groupInfo.isVisible then
            -- Create group line
            increaseLayoutOrder()
            local groupElementName = ("%d_Group_%s"):format(layoutOrderCount, groupInfo.name)
            elements[groupElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Group, {
                name = groupInfo.name,
                isOpen = groupInfo.isOpen,
                totalPlugs = #groupInfo.plugs,
                icon = groupInfo.icon or WidgetConstants.Icons.Unknown,
                layoutOrder = layoutOrderCount,
            })

            if groupInfo.isOpen then
                -- Create plugs
                for _, plugInfo in pairs(groupInfo.plugs) do
                    if plugInfo.isVisible then
                        -- Create plug line
                        increaseLayoutOrder()
                        local plugElementName = ("%d_Group_%s_Plug_%s"):format(layoutOrderCount, groupInfo.name, plugInfo.name)
                        elements[plugElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Plug, {
                            name = plugInfo.name,
                            isOpen = plugInfo.isOpen,
                            icon = plugInfo.plug.Icon or WidgetConstants.Icons.Unknown,
                            layoutOrder = layoutOrderCount,
                            plug = plugInfo.plug,
                            plugScript = plugInfo.moduleScript,
                        })

                        -- Create child lines
                        if plugInfo.isOpen then
                            -- Create fields line
                            increaseLayoutOrder()
                            local hasFields = #plugInfo.plug.Fields > 0
                            local fieldsElementName = ("%d_Group_%s_Plug_%s_Fields"):format(layoutOrderCount, groupInfo.name, plugInfo.name)
                            elements[fieldsElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Fields, {
                                isOpen = plugInfo.isFieldsOpen,
                                plugScript = plugInfo.moduleScript,
                                hasFields = hasFields,
                                layoutOrder = layoutOrderCount,
                            })

                            -- Create keybind line
                            increaseLayoutOrder()
                            local keybindElementName = ("%d_Group_%s_Plug_%s_Keybind"):format(
                                layoutOrderCount,
                                groupInfo.name,
                                plugInfo.name
                            )
                            elements[keybindElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Keybind, {
                                keybind = plugInfo.plug.Keybind or {},
                                layoutOrder = layoutOrderCount,
                            })

                            -- Create setting line
                            increaseLayoutOrder()
                            local settingsElementName = ("%d_Group_%s_Plug_%s_Settings"):format(
                                layoutOrderCount,
                                groupInfo.name,
                                plugInfo.name
                            )
                            elements[settingsElementName] = RoactPlugLines:Get(WidgetConstants.RoactWidgetLine.Type.Settings, {
                                moduleScript = plugInfo.moduleScript,
                                layoutOrder = layoutOrderCount,
                                plug = plugInfo.plug,
                            })
                        end
                    end
                end
            end
        end
    end

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
        CanvasSize = UDim2.new(0, 0, 1, 0),
        ScrollBarThickness = 6,
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
