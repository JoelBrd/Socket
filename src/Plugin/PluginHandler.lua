---
---Script for initialising the plugin
---
---@class PluginHandler
---
local PluginHandler = {}

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local PluginConstants ---@type PluginConstants
local Logger ---@type Logger
local StudioHandler ---@type StudioHandler
local SocketController ---@type SocketController

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Constants
local PLUGIN_NAME = "Socket"

local TOOLBAR_NAME = PLUGIN_NAME
local TOOLBAR_BUTTON_TITLE = "Open"
local TOOLBAR_BUTTON_DESCRIPTION = "Opens the Socket widget"
local TOOLBAR_LOGO_ICON = "rbxassetid://8754658166"

local WIDGET_NAME = PLUGIN_NAME
local WIDGET_INFO = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Right, -- Widget will be initialized in floating panel
    true, -- Widget will be initially enabled
    false, -- Don't override the previous enabled state
    200, -- Default width of the floating window
    300, -- Default height of the floating window
    250, -- Minimum width of the floating window
    300 -- Minimum height of the floating window
)

--------------------------------------------------
-- Members
local plugin ---@type Plugin
local toolbar ---@type PluginToolbar
local toolbarButton ---@type PluginToolbarButton
local widget ---@type DockWidgetPluginGui

local isPluginActive = false ---@type boolean

---
---One time loading of the plugin
---
---@param passedPlugin Plugin
---
function PluginHandler:Load(passedPlugin)
    -- ERROR: Plugin already loaded
    local isAlreadyLoaded = plugin and true or false
    if isAlreadyLoaded then
        Logger:Error("Socket Plugin already loaded!")
        return
    end
    plugin = passedPlugin

    --------------------------------------------------
    -- Initialise (if needed)
    local hasNotRunBefore = not (self:GetSetting(PluginConstants.Setting.HAS_RUN_BEFORE) and true or false)
    if hasNotRunBefore then
        self:Initialise()
    end

    --------------------------------------------------
    -- Create button on the plugin toolbar
    toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
    toolbarButton = toolbar:CreateButton(TOOLBAR_BUTTON_TITLE, TOOLBAR_BUTTON_DESCRIPTION, TOOLBAR_LOGO_ICON)

    toolbarButton.Click:Connect(function()
        self:ToolbarButtonClicked()
    end)

    --------------------------------------------------
    -- Creating widget (if previously active)
    local wasPluginActive = self:GetSetting(PluginConstants.Setting.IS_PLUGIN_ACTIVE) and true or false
    if wasPluginActive then
        self:SetPluginActiveState(true)
    end

    -- Debug Info
    Logger:Info("Plugin Loaded")
end

---
---First time initialisation of the plugin
---
function PluginHandler:Initialise()
    -- Load on default settings
    for _, pluginSetting in pairs(PluginConstants.Setting) do
        self:SetSetting(pluginSetting, pluginSetting.DefaultValue)
    end

    Logger:Info("Initialised plugin with defaults")
end

---
---Sets the value of the given setting
---
---@param pluginSetting PluginSetting
---@param settingValue any
---
function PluginHandler:SetSetting(pluginSetting, settingValue)
    plugin:SetSetting(pluginSetting.Id, settingValue)
end

---
---Returns the value of the given setting
---
---@param pluginSetting PluginSetting
---@return any
---
function PluginHandler:GetSetting(pluginSetting)
    return plugin:GetSetting(pluginSetting.Id)
end

---
---@private
---
---Runs logic on what to do when we've clicked the toolbar button
---
function PluginHandler:ToolbarButtonClicked()
    -- Toggle active status
    self:SetPluginActiveState(not isPluginActive)
    Logger:Info(("Toolbar Button Clicked (Active: %s)"):format(tostring(isPluginActive)))
end

---
---Sets the active state of the plugin (if active, button is active + widget is created!)
---
---@param isActive boolean
---
function PluginHandler:SetPluginActiveState(isActive)
    -- RETURN: Matches our current state
    local differsToCache = not (isActive == isPluginActive)
    if not differsToCache then
        return
    end
    isPluginActive = isActive

    -- Logic for when Plugin is Opened/Closed
    if isPluginActive then
        StudioHandler:Validate()
        self:CreateWidget()
    else
        self:DestroyWidget()
    end

    -- Manage toolbar button state
    -- SetActive() wouldn't visually update `toolbarButton`, so an ugly hack for an ugly feature :D
    toolbarButton.Enabled = false
    toolbarButton.Enabled = true
    toolbarButton:SetActive(isPluginActive)

    Logger:Info("Plugin Active:", isPluginActive)
end

---
---@private
---
---Create widget
---
function PluginHandler:CreateWidget()
    -- Destroy old widget
    self:DestroyWidget()

    -- Create widget
    widget = plugin:CreateDockWidgetPluginGui(WIDGET_NAME, WIDGET_INFO)
    widget.Title = WIDGET_NAME
    widget.Enabled = true

    -- Widget connections
    widget:BindToClose(function()
        self:SetPluginActiveState(false)
    end)

    -- Debug Info
    Logger:Info("Created Widget")

    -- Save as setting
    self:SetSetting(PluginConstants.Setting.IS_PLUGIN_ACTIVE, true)

    -- Inform SocketController
    SocketController:Run()
end

---
---@private
---
---Destroy widget
---
function PluginHandler:DestroyWidget()
    -- ERROR: No widget
    if not widget then
        return
    end

    -- Inform SocketController
    SocketController:Stop()

    -- Destroy widget
    widget:Destroy()
    widget = nil

    -- Debug Info
    Logger:Info("Destroyed Widget")

    -- Save as setting
    self:SetSetting(PluginConstants.Setting.IS_PLUGIN_ACTIVE, false)
end

---
---Returns the current widget of the plugin
---@return DockWidgetPluginGui
---
function PluginHandler:GetWidget()
    return widget
end

---
---@return Plugin
---
function PluginHandler:GetPlugin()
    return plugin
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function PluginHandler:FrameworkInit()
    PluginConstants = PluginFramework:Require("PluginConstants")
    Logger = PluginFramework:Require("Logger")
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketController = PluginFramework:Require("SocketController")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function PluginHandler:FrameworkStart() end

return PluginHandler
