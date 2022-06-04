---
---Roact stuff for all the plugs
---
---@class RoactPlugContainer
---
local RoactPlugContainer = {}

--------------------------------------------------
-- Types

---@class RoactPlugContainerProps.GroupInfo
---@field name string
---@field icon string
---@field isOpen boolean
---@field isVisible boolean
---@field plugs RoactPlugContainerProps.PlugInfo[]

---@class RoactPlugContainerProps.PlugInfo
---@field name string
---@field isOpen boolean
---@field isVisible boolean
---@field plug PlugDefinition
---@field moduleScript ModuleScript

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
local PlugContainer ---@type RoactComponent

---
---@return RoactElement
---
function RoactPlugContainer:Get()
    return Roact.createElement(PlugContainer)
end

---Creates all of the individual lines to populate the PlugContainer
---@param props table
---@return RoactFragment
local function createLinesFragment(props)
    -- Grab variables
    local groups = props.groups ---@type RoactPlugContainerProps.GroupInfo[]
    local elements = {}
    local layoutOrderCount = 0

    for _, groupInfo in pairs(groups) do
        if groupInfo.isVisible then
            -- Create group line
            layoutOrderCount = layoutOrderCount + 1
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
                        layoutOrderCount = layoutOrderCount + 1
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
                            -- Create keybind line
                            layoutOrderCount = layoutOrderCount + 1
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
                            layoutOrderCount = layoutOrderCount + 1
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
---@private
---
function RoactPlugContainer:Create()
    --------------------------------------------------
    -- Create PlugContainer
    PlugContainer = Roact.Component:extend("PlugContainer")

    function PlugContainer:render()
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
            Lines = createLinesFragment(self.props),
        })
    end

    --------------------------------------------------
    -- Connect RoactRodux

    ---@param state RoduxState
    ---@param props table
    local function mapStateToProps(state, props)
        -- ODD FIX: Ignore duplicate call
        if props.innerProps then
            return
        end

        -- Construct groups
        local groups = {} ---@type RoactPlugContainerProps.GroupInfo[]
        local plugsState = state[SocketConstants.RoduxStoreKey.PLUGS]
        local stateGroups = plugsState.Groups
        for groupName, groupChild in pairs(stateGroups) do
            -- Create group info
            local groupInfo = {
                name = groupName,
                icon = nil,
                isOpen = groupChild.UIState.IsOpen,
                isVisible = true,
                plugs = {}, ---@type RoactPlugContainerProps.GroupInfo[]
            } ---@type RoactPlugContainerProps.GroupInfo
            table.insert(groups, groupInfo)

            -- Construct plugs
            for plugModuleScript, plugChild in pairs(groupChild.Plugs) do
                -- Create plug info
                local plug = plugChild.Plug ---@type PlugDefinition
                local plugInfo = {
                    name = plug.Name,
                    isOpen = plugChild.UIState.IsOpen,
                    isVisible = true,
                    plug = plug, ---@type PlugDefinition
                    moduleScript = plugModuleScript,
                } ---@type RoactPlugContainerProps.GroupInfo
                table.insert(groupInfo.plugs, plugInfo)

                -- Try populate group icon
                if plug.GroupIcon and not groupInfo.icon then
                    groupInfo.icon = plug.GroupIcon
                end
            end

            -- Sort plugs
            ---@param plugInfo0 RoactPlugContainerProps.PlugInfo
            ---@param plugInfo1 RoactPlugContainerProps.PlugInfo
            local function plugsSort(plugInfo0, plugInfo1)
                return plugInfo0.name < plugInfo1.name
            end
            table.sort(groupInfo.plugs, plugsSort)
        end

        -- Sort groups
        ---@param groupInfo0 RoactPlugContainerProps.GroupInfo
        ---@param groupInfo1 RoactPlugContainerProps.GroupInfo
        local function groupsSort(groupInfo0, groupInfo1)
            return groupInfo0.name < groupInfo1.name
        end
        table.sort(groups, groupsSort)

        -- Filter visibility from searchText
        local searchText = plugsState.SearchText ---@type string
        local searchTextUpper = searchText:upper()
        if searchText:len() > 0 then
            for _, groupInfo in pairs(groups) do
                local groupHasGoodName = string.find(groupInfo.name:upper(), searchTextUpper) and true or false
                local groupHasGoodPlug = false
                for _, plugInfo in pairs(groupInfo.plugs) do
                    local plugHasGoodName = string.find(plugInfo.name:upper(), searchTextUpper) and true or false
                    plugInfo.isVisible = plugHasGoodName or groupHasGoodName
                    groupHasGoodPlug = groupHasGoodPlug or plugHasGoodName
                end
                groupInfo.isVisible = groupHasGoodName or groupHasGoodPlug
            end
        end

        -- Return props
        return {
            groups = groups,
        }
    end

    PlugContainer = RoactRodux.connect(mapStateToProps)(PlugContainer)
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
function RoactPlugContainer:FrameworkStart()
    RoactPlugContainer:Create()
end

return RoactPlugContainer
