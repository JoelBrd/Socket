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
    local gui = game.StarterGui
    local debugScreenGui = gui:FindFirstChild("DebugSocketUI")
    if debugScreenGui then
        debugScreenGui:Destroy()
        debugScreenGui = nil
    end

    if SocketConstants.ShowDebugUI then
        debugScreenGui = Instance.new("ScreenGui") ---@type ScreenGui
        debugScreenGui.Name = "DebugSocketUI"
        debugScreenGui.Parent = gui

        local debugRoactTree = Roact.mount(app, debugScreenGui)
        runJanitor:Add(function()
            Roact.unmount(debugRoactTree)
        end, true)
    end
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
