---
---Roact stuff for all the macros
---
---@class RoactMacroContainer
---
local RoactMacroContainer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux
local SocketConstants ---@type SocketConstants
local RoactMacroLines ---@type RoactMacroLines
local WidgetConstants ---@type WidgetConstants
local SocketSettings ---@type SocketSettings

--------------------------------------------------
-- Constants
local COLOR_WHITE = Color3.fromRGB(255, 255, 255)

--------------------------------------------------
-- Members

---@param str string
---@return boolean
local function couldStringBeIconImageId(str)
    return str:find("rbxasset")
end

---Creates all of the individual lines to populate the MacroContainer
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
            elements[groupElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Group, {
                name = groupInfo.name,
                nameColor = groupInfo.nameColor,
                isOpen = groupInfo.isOpen,
                totalMacros = #groupInfo.macros,
                icon = groupIcon,
                iconColor = groupInfo.iconColor or COLOR_WHITE,
                isIconImageId = couldStringBeIconImageId(groupIcon),
                layoutOrder = layoutOrderCount,
                scale = scale,
            })

            if groupInfo.isOpen then
                -- Create macros
                for _, macroInfo in pairs(groupInfo.macros) do
                    if macroInfo.isVisible then
                        -- Create macro line
                        increaseLayoutOrder()
                        local macroElementName = ("Group_%s_Macro_%s"):format(groupInfo.name, macroInfo.name)
                        local macroIcon = macroInfo.macro.Icon or WidgetConstants.Icons.Unknown
                        elements[macroElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Macro, {
                            name = macroInfo.name,
                            nameColor = macroInfo.macro.NameColor,
                            isOpen = macroInfo.isOpen,
                            icon = macroIcon,
                            iconColor = macroInfo.macro.IconColor or COLOR_WHITE,
                            isIconImageId = couldStringBeIconImageId(macroIcon),
                            layoutOrder = layoutOrderCount,
                            scale = scale,
                            macro = macroInfo.macro,
                            macroScript = macroInfo.moduleScript,
                            isBroken = macroInfo.isBroken,
                            isLocalMacro = macroInfo.isLocalMacro,
                        })

                        -- Create child lines
                        if macroInfo.isOpen then
                            -- Create fields line
                            local hasFields = #macroInfo.macro.Fields > 0
                            if hasFields or not SocketSettings:GetSetting("HideUnusedFieldsAndKeybind") then
                                increaseLayoutOrder()
                                local fieldsElementName = ("Group_%s_Macro_%s_Fields"):format(groupInfo.name, macroInfo.name)
                                elements[fieldsElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Fields, {
                                    isOpen = macroInfo.isFieldsOpen,
                                    macroScript = macroInfo.moduleScript,
                                    hasFields = hasFields,
                                    layoutOrder = layoutOrderCount,
                                    scale = scale,
                                })

                                -- Create individual fields
                                if hasFields and macroInfo.isFieldsOpen then
                                    for _, field in pairs(macroInfo.macro.Fields) do
                                        increaseLayoutOrder()
                                        local fieldElementName = ("Group_%s_Macro_%s_Field_%s"):format(
                                            groupInfo.name,
                                            macroInfo.name,
                                            field.Name
                                        )
                                        elements[fieldElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Field, {
                                            field = field,
                                            macro = macroInfo.macro,
                                            layoutOrder = layoutOrderCount,
                                            scale = scale,
                                        })
                                    end
                                end
                            end

                            -- Create keybind line
                            local keybindTuple = macroInfo.macro.Keybind or {}
                            if #keybindTuple > 0 or not SocketSettings:GetSetting("HideUnusedFieldsAndKeybind") then
                                increaseLayoutOrder()
                                local keybindElementName = ("Group_%s_Macro_%s_Keybind"):format(groupInfo.name, macroInfo.name)
                                elements[keybindElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Keybind, {
                                    keybind = keybindTuple,
                                    isDisabled = macroInfo.macro.State.IsKeybindDisabled,
                                    layoutOrder = layoutOrderCount,
                                    scale = scale,
                                })
                            end

                            -- Create setting line
                            increaseLayoutOrder()
                            local settingsElementName = ("Group_%s_Macro_%s_Settings"):format(groupInfo.name, macroInfo.name)
                            elements[settingsElementName] = RoactMacroLines:Get(WidgetConstants.RoactWidgetLine.Type.Settings, {
                                moduleScript = macroInfo.moduleScript,
                                layoutOrder = layoutOrderCount,
                                scale = scale,
                                macro = macroInfo.macro,
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
function RoactMacroContainer:Get(props)
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
function RoactMacroContainer:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactRodux = PluginFramework:Require("RoactRodux")
    SocketConstants = PluginFramework:Require("SocketConstants")
    RoactMacroLines = PluginFramework:Require("RoactMacroLines")
    WidgetConstants = PluginFramework:Require("WidgetConstants")
    SocketSettings = PluginFramework:Require("SocketSettings")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactMacroContainer:FrameworkStart() end

return RoactMacroContainer
