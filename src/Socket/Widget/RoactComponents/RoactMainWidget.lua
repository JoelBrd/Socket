---
---Main Widget
---
---@class RoactMainWidget
---
local RoactMainWidget = {}

--------------------------------------------------
-- Types

---@class RoactMainWidgetProps.GroupInfo
---@field name string
---@field icon string
---@field isOpen boolean
---@field isVisible boolean
---@field plugs RoactMainWidgetProps.PlugInfo[]

---@class RoactMainWidgetProps.PlugInfo
---@field name string
---@field isOpen boolean
---@field isFieldsOpen boolean
---@field isVisible boolean
---@field plug PlugDefinition
---@field moduleScript ModuleScript

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactPlugContainer ---@type RoactPlugContainer
local RoactSearchBar ---@type RoactSearchBar
local WidgetConstants ---@type WidgetConstants
local SocketController ---@type SocketController
local RoactBottomBar ---@type RoactBottomBar
local RoactRodux ---@type RoactRodux
local SocketConstants ---@type SocketConstants
local SocketSettings ---@type SocketSettings
local WidgetTheme ---@type WidgetTheme

--------------------------------------------------
-- Constants
local MARGIN_PADDING = UDim.new(0, 2)

--------------------------------------------------
-- Members
local MainWidget ---@type RoactComponent

---
---@return RoactElement
---
function RoactMainWidget:Get()
    return Roact.createElement(MainWidget)
end

---
---@private
---
function RoactMainWidget:Create()
    --------------------------------------------------
    -- Create PlugContainer
    MainWidget = Roact.Component:extend("MainWidget")

    function MainWidget:render()
        local scale = SocketSettings:GetSetting("UIScale")

        return Roact.createElement("Frame", {
            BackgroundColor3 = WidgetTheme:GetColor(WidgetTheme.Indexes.Background),
            Size = UDim2.fromScale(1, 1),
        }, {
            UIPadding = Roact.createElement("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = MARGIN_PADDING,
                PaddingRight = MARGIN_PADDING,
                PaddingTop = MARGIN_PADDING,
            }),
            Container = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
            }, {
                UIListLayout = Roact.createElement("UIListLayout", {
                    Padding = MARGIN_PADDING,
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
                SearchHolder = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Size = UDim2.new(1, 0, 0, WidgetConstants.SearchBar.Pixel.LineHeight * scale),
                }, {
                    SearchContainer = RoactSearchBar:Get({
                        scale = scale,
                    }),
                }),
                PlugHolder = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(
                        1,
                        0,
                        1,
                        -(WidgetConstants.SearchBar.Pixel.LineHeight * scale + WidgetConstants.BottomBar.Pixel.LineHeight * scale)
                    ),
                }, {
                    PlugContainer = RoactPlugContainer:Get(self.props),
                }),
                BottomHolder = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Size = UDim2.new(1, 0, 0, WidgetConstants.BottomBar.Pixel.LineHeight * scale),
                }, {
                    BottomContainer = RoactBottomBar:Get(),
                }),
            }),
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

        -- Get Variables
        local doGroupMatchingIcons = SocketSettings:GetSetting("GroupMatchingIcons")

        -- Construct groups
        local groups = {} ---@type RoactMainWidgetProps.GroupInfo[]
        local plugsState = state[SocketConstants.RoduxStoreKey.PLUGS]
        local stateGroups = plugsState.Groups
        for groupName, groupChild in pairs(stateGroups) do
            -- Create group info
            local groupInfo = {
                name = groupName,
                icon = nil,
                isOpen = groupChild.UIState.IsOpen,
                isVisible = true,
                plugs = {}, ---@type RoactMainWidgetProps.GroupInfo[]
            } ---@type RoactMainWidgetProps.GroupInfo
            table.insert(groups, groupInfo)

            -- Construct plugs
            for plugModuleScript, plugChild in pairs(groupChild.Plugs) do
                -- Search for duplicate names
                local plug = plugChild.Plug ---@type PlugDefinition
                local duplicateCount = 0
                for _, somePlugInfo in pairs(groupInfo.plugs) do
                    if somePlugInfo.plug.Name == plug.Name then
                        duplicateCount = duplicateCount + 1
                    end
                end

                -- Create plug info
                local name = duplicateCount == 0 and plug.Name or ("%s (%d)"):format(plug.Name, duplicateCount)
                local plugInfo = {
                    name = name,
                    isOpen = plugChild.UIState.IsOpen,
                    isFieldsOpen = plugChild.UIState.IsFieldsOpen,
                    isVisible = true,
                    plug = plug, ---@type PlugDefinition
                    moduleScript = plugModuleScript,
                } ---@type RoactMainWidgetProps.GroupInfo
                table.insert(groupInfo.plugs, plugInfo)

                -- Try populate group icon
                if plug.GroupIcon and not groupInfo.icon then
                    groupInfo.icon = plug.GroupIcon
                end
            end

            -- Sort plugs
            ---@param plugInfo0 RoactMainWidgetProps.PlugInfo
            ---@param plugInfo1 RoactMainWidgetProps.PlugInfo
            local function plugsSort(plugInfo0, plugInfo1)
                if doGroupMatchingIcons and plugInfo0.plug.Icon ~= plugInfo1.plug.Icon then
                    return plugInfo0.plug.Icon < plugInfo1.plug.Icon
                end

                return plugInfo0.name < plugInfo1.name
            end
            table.sort(groupInfo.plugs, plugsSort)
        end

        -- Sort groups
        ---@param groupInfo0 RoactMainWidgetProps.GroupInfo
        ---@param groupInfo1 RoactMainWidgetProps.GroupInfo
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
                groupInfo.isOpen = groupInfo.isOpen or groupHasGoodPlug -- Open up the group if it found plugs inside it.
            end
        end

        -- Return props
        return {
            groups = groups,
            scale = SocketSettings:GetSetting("UIScale"),
        }
    end

    MainWidget = RoactRodux.connect(mapStateToProps)(MainWidget)
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactMainWidget:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactPlugContainer = PluginFramework:Require("RoactPlugContainer")
    RoactSearchBar = PluginFramework:Require("RoactSearchBar")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    SocketController = PluginFramework:Require("SocketController")
    RoactBottomBar = PluginFramework:Require("RoactBottomBar")
    SocketConstants = PluginFramework:Require("SocketConstants")
    RoactRodux = PluginFramework:Require("RoactRodux")
    SocketSettings = PluginFramework:Require("SocketSettings")
    WidgetTheme = PluginFramework:Require("WidgetTheme")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactMainWidget:FrameworkStart()
    RoactMainWidget:Create()
end

return RoactMainWidget
