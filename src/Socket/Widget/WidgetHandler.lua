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

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local roactTree ---@type RoactTree

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
end

---
---Called when we no longer need the widget
---
function WidgetHandler:Stop()
    -- Destroy mounted component
    if roactTree then
        Roact.unmount(roactTree)
        roactTree = nil
    end
end

---@private
function WidgetHandler:FrameworkInit()
    PluginHandler = PluginFramework:Require("PluginHandler")
    SocketController = PluginFramework:Require("SocketController")
    Logger = PluginFramework:Require("Logger")
    RoactRodux = PluginFramework:Require("RoactRodux")
    Roact = PluginFramework:Require("Roact")
    RoactMainWidget = PluginFramework:Require("RoactMainWidget")
end

---@private
function WidgetHandler:FrameworkStart() end

return WidgetHandler
