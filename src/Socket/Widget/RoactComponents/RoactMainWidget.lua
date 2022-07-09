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
---@field nameColor Color3
---@field icon string
---@field iconColor Color3
---@field isOpen boolean
---@field isVisible boolean
---@field macros RoactMainWidgetProps.MacroInfo[]

---@class RoactMainWidgetProps.MacroInfo
---@field name string
---@field isOpen boolean
---@field isFieldsOpen boolean
---@field isBroken boolean
---@field isVisible boolean
---@field macro MacroDefinition
---@field moduleScript ModuleScript

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactMacroContainer ---@type RoactMacroContainer
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
    -- Create MacroContainer
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
                MacroHolder = Roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(
                        1,
                        0,
                        1,
                        -(WidgetConstants.SearchBar.Pixel.LineHeight * scale + WidgetConstants.BottomBar.Pixel.LineHeight * scale)
                    ),
                }, {
                    MacroContainer = RoactMacroContainer:Get(self.props),
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
        local sortType = SocketSettings:GetSetting("SortType")

        -- Construct groups
        local groups = {} ---@type RoactMainWidgetProps.GroupInfo[]
        local macrosState = state[SocketConstants.RoduxStoreKey.MACROS]
        local stateGroups = macrosState.Groups
        for groupName, groupChild in pairs(stateGroups) do
            -- Create group info
            local groupInfo = {
                name = groupName,
                nameColor = nil,
                icon = nil,
                iconColor = nil,
                isOpen = groupChild.UIState.IsOpen,
                isVisible = true,
                macros = {}, ---@type RoactMainWidgetProps.GroupInfo[]
            } ---@type RoactMainWidgetProps.GroupInfo
            table.insert(groups, groupInfo)

            -- Construct macros
            for macroModuleScript, macroChild in pairs(groupChild.Macros) do
                -- Search for duplicate names
                local macro = macroChild.Macro ---@type MacroDefinition
                local duplicateCount = 0
                for _, someMacroInfo in pairs(groupInfo.macros) do
                    if someMacroInfo.macro.Name == macro.Name then
                        duplicateCount = duplicateCount + 1
                    end
                end

                -- Create macro info
                local name = duplicateCount == 0 and macro.Name or ("%s (%d)"):format(macro.Name, duplicateCount)
                local macroInfo = {
                    name = name,
                    isOpen = macroChild.UIState.IsOpen,
                    isFieldsOpen = macroChild.UIState.IsFieldsOpen,
                    isBroken = macro._isBroken and true or false,
                    isVisible = true,
                    macro = macro, ---@type MacroDefinition
                    moduleScript = macroModuleScript,
                } ---@type RoactMainWidgetProps.GroupInfo
                if not macro.Disabled then
                    table.insert(groupInfo.macros, macroInfo)
                end

                -- Try populate group icon
                if macro.GroupIcon and not groupInfo.icon then
                    groupInfo.icon = macro.GroupIcon
                end
                if macro.GroupIconColor and not groupInfo.iconColor then
                    groupInfo.iconColor = macro.GroupIconColor
                end
                if macro.GroupColor and not groupInfo.nameColor then
                    groupInfo.nameColor = macro.GroupColor
                end
            end

            -- Sort macros
            ---@param macroInfo0 RoactMainWidgetProps.MacroInfo
            ---@param macroInfo1 RoactMainWidgetProps.MacroInfo
            local function macrosSort(macroInfo0, macroInfo1)
                if sortType == "LayoutOrder" and (macroInfo0.macro.LayoutOrder ~= macroInfo1.macro.LayoutOrder) then
                    return (macroInfo0.macro.LayoutOrder or 0) < (macroInfo1.macro.LayoutOrder or 0)
                elseif sortType == "Icon" and (macroInfo0.macro.Icon ~= macroInfo1.macro.Icon) then
                    return (macroInfo0.macro.Icon or "") < (macroInfo1.macro.Icon or "")
                end

                return macroInfo0.name < macroInfo1.name
            end
            table.sort(groupInfo.macros, macrosSort)
        end

        -- Sort groups
        ---@param groupInfo0 RoactMainWidgetProps.GroupInfo
        ---@param groupInfo1 RoactMainWidgetProps.GroupInfo
        local function groupsSort(groupInfo0, groupInfo1)
            if sortType == "LayoutOrder" then
                -- Calculate lowest layout order from macros in each group
                local lowestLayoutOrder0
                for _, macroInfo in pairs(groupInfo0.macros) do
                    local layoutOrder = macroInfo.macro.LayoutOrder
                    lowestLayoutOrder0 = lowestLayoutOrder0 and lowestLayoutOrder0 < layoutOrder and lowestLayoutOrder0 or layoutOrder
                end
                local lowestLayoutOrder1
                for _, macroInfo in pairs(groupInfo1.macros) do
                    local layoutOrder = macroInfo.macro.LayoutOrder
                    lowestLayoutOrder1 = lowestLayoutOrder1 and lowestLayoutOrder1 < layoutOrder and lowestLayoutOrder1 or layoutOrder
                end
                if lowestLayoutOrder0 ~= lowestLayoutOrder1 then
                    return (lowestLayoutOrder0 or 0) < (lowestLayoutOrder1 or 0)
                end
            elseif sortType == "Icon" and (groupInfo0.icon ~= groupInfo1.icon) then
                return (groupInfo0.icon or "") < (groupInfo1.icon or "")
            end

            return groupInfo0.name < groupInfo1.name
        end
        table.sort(groups, groupsSort)

        -- Filter visibility from searchText
        local searchText = macrosState.SearchText ---@type string
        local searchTextUpper = searchText:upper()
        if searchText:len() > 0 then
            for _, groupInfo in pairs(groups) do
                local groupHasGoodName = string.find(groupInfo.name:upper(), searchTextUpper) and true or false
                local groupHasGoodMacro = false
                for _, macroInfo in pairs(groupInfo.macros) do
                    local macroHasGoodName = string.find(macroInfo.name:upper(), searchTextUpper) and true or false
                    macroInfo.isVisible = macroHasGoodName or groupHasGoodName
                    groupHasGoodMacro = groupHasGoodMacro or macroHasGoodName
                end
                groupInfo.isVisible = groupHasGoodName or groupHasGoodMacro
                groupInfo.isOpen = groupInfo.isOpen or groupHasGoodMacro -- Open up the group if it found macros inside it.
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
    RoactMacroContainer = PluginFramework:Require("RoactMacroContainer")
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
