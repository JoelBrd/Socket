---
---Utility functions for managing Roblox Instances
---
---@class WidgetHandler
---
local WidgetHandler = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local SocketController ---@type SocketController
local PluginHandler ---@type PluginHandler
local Logger ---@type Logger
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux
local RoactMainWidget ---@type RoactMainWidget
local SocketConstants ---@type SocketConstants
local Janitor ---@type Janitor
local SocketSettings ---@type SocketSettings

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local roactTree ---@type RoactTree
local runJanitor ---@type Janitor
local registerTextBoxMemory ---@type table

---
---Called to start the widget population
---
function WidgetHandler:Run()
    local widget = PluginHandler:GetWidget()
    if not widget then
        Logger:Error("Cannot Run; no widget!")
    end

    if roactTree then
        Roact.unmount(roactTree)
        roactTree = nil
    end

    -- Create main component + link with rodux store
    local app = Roact.createElement(RoactRodux.StoreProvider, {
        store = SocketController:GetStore(),
    }, {
        Main = RoactMainWidget:Get(),
    })

    -- Mount to widget
    roactTree = Roact.mount(app, widget)
    runJanitor:Add(function()
        Roact.unmount(roactTree)
        roactTree = nil
    end, true)

    -- TESTING: Debug UI
    if SocketConstants.ShowDebugUI then
        local gui = game.StarterGui
        local screenGui = gui:FindFirstChild("DebugSocketUI")
        if not screenGui then
            screenGui = Instance.new("ScreenGui") ---@type ScreenGui
            screenGui.Name = "DebugSocketUI"
            screenGui.Parent = gui
        end

        local debugRoactTree = Roact.mount(app, screenGui)
        runJanitor:Add(function()
            Roact.unmount(debugRoactTree)
        end, true)
    end

    -- Tracking textbox navigating
    runJanitor:Add(UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
        -- RETURN: Bad keybind
        if inputObject.KeyCode ~= SocketSettings:GetSetting("NavigateFieldsKeybind") then
            return
        end

        -- RETURN: No selected textbox
        local selectedTextBox = registerTextBoxMemory and registerTextBoxMemory.Selected.TextBox
        if not selectedTextBox then
            return
        end

        -- Get index of textbox in its locality
        local index ---@type number
        local dictionary = registerTextBoxMemory.ReferenceDictionary[registerTextBoxMemory.Selected.Reference] or {}
        for someIndex, someTextBox in pairs(dictionary) do
            if someTextBox == selectedTextBox then
                index = someIndex
                break
            end
        end

        -- RETURN: No next textbox
        local nextTextBox = index and dictionary and dictionary[index + 1] ---@type TextBox
        if not nextTextBox then
            return
        end

        -- Focus
        nextTextBox:CaptureFocus()
    end))
end

---
---Refreshes the PLUGS store, and hence the widget
---
function WidgetHandler:Refresh()
    -- Update RoduxStore
    ---@type RoduxAction
    local action = {
        type = SocketConstants.RoduxActionType.PLUGS.REFRESH,
        data = {},
    }
    SocketController:GetStore():dispatch(action)
end

---
---Used to track fields within a RoactComponent, so the user can navigate them easily using "Tab".
---Very very ugly and hacky, but I couldn't be bothered to figure out how to implement this purely with Roact.
---@param reference any
---@param textBox TextBox
---@param layoutOrder number
---
function WidgetHandler:RegisterTextBox(reference, textBox, layoutOrder)
    -- Init memory
    registerTextBoxMemory = registerTextBoxMemory
        or {
            ReferenceDictionary = {}, ---@type table<any, table<number, TextBox>>
            Selected = {
                TextBox = nil, ---@type TextBox
                Reference = nil, ---@type any
            },
        }

    -- Create dictionary for this element
    local dict = registerTextBoxMemory.ReferenceDictionary[reference] or {}
    registerTextBoxMemory.ReferenceDictionary[reference] = dict

    -- Write this textbox to memory
    dict[layoutOrder] = textBox

    -- Setup some listeners
    runJanitor:Add(textBox.Focused:Connect(function()
        registerTextBoxMemory.Selected.TextBox = textBox
        registerTextBoxMemory.Selected.Reference = reference
    end))
    runJanitor:Add(textBox.FocusLost:Connect(function()
        if registerTextBoxMemory.Selected.TextBox == textBox then
            registerTextBoxMemory.Selected.TextBox = nil
            registerTextBoxMemory.Selected.Reference = nil
        end
    end))
end

---
---Called when we no longer need the widget
---
function WidgetHandler:Stop()
    runJanitor:Cleanup()
    registerTextBoxMemory = nil
end

---@private
function WidgetHandler:FrameworkInit()
    PluginHandler = PluginFramework:Require("PluginHandler")
    SocketController = PluginFramework:Require("SocketController")
    Logger = PluginFramework:Require("Logger")
    RoactRodux = PluginFramework:Require("RoactRodux")
    Roact = PluginFramework:Require("Roact")
    RoactMainWidget = PluginFramework:Require("RoactMainWidget")
    SocketConstants = PluginFramework:Require("SocketConstants")
    Janitor = PluginFramework:Require("Janitor")
    SocketSettings = PluginFramework:Require("SocketSettings")
end

---@private
function WidgetHandler:FrameworkStart()
    runJanitor = Janitor.new()
end

return WidgetHandler
