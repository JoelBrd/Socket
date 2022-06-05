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
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local SocketController ---@type SocketController
local PluginHandler ---@type PluginHandler
local Logger ---@type Logger
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux
local RoactMainWidget ---@type RoactMainWidget
local SocketConstants ---@type SocketConstants
local Janitor ---@type Janitor

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local roactTree ---@type RoactTree
local runJanitor ---@type Janitor

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
end

---
---Called when we no longer need the widget
---
function WidgetHandler:Stop()
    runJanitor:Cleanup()
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
end

---@private
function WidgetHandler:FrameworkStart()
    runJanitor = Janitor.new()
end

return WidgetHandler
