---
---SocketSettings
---
---@class SocketSettings
---
local SocketSettings = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local PluginHandler ---@type PluginHandler
local PluginConstants ---@type PluginConstants
local Logger ---@type Logger
local TableUtil ---@type TableUtil

--------------------------------------------------
-- Constants
local TEMPLATE_SOURCE_SETTINGS_LINE = "local settings = {}"

--------------------------------------------------
-- Members
local defaultSettings ---@type SocketSettings
local settingsTemplateFile ---@type ModuleScript

---
---Will ensure the stored settings on the plugin is in line with our template.
---Usually called on startup.
---
function SocketSettings:ValidateSettings()
    local storedSettings = PluginHandler:GetSetting(PluginConstants.Setting) or {}
    TableUtil:Sync(storedSettings, defaultSettings)
    PluginHandler:SetSetting(PluginConstants.Setting, storedSettings)
end

---
---Returns the currently set value for this settingName
---@param settingName string
---@return any
---
function SocketSettings:GetSetting(settingName)
    local storedSettings = PluginHandler:GetSetting(PluginConstants.Setting)
    local settingValue = storedSettings[settingName]

    -- ERROR: Bad settingName
    if settingValue == nil then
        Logger:Error(("No Setting %q"):format(settingName))
    end

    return settingValue
end

---
---Opens up a settings file, with the users settings loaded on.
---When the user closes the file, we read their settings.
---
function SocketSettings:OpenSettings()
    -- Get Settings
    local storedSettings = PluginHandler:GetSetting(PluginConstants.Setting)

    -- Create source
    local templateSource = settingsTemplateFile.Source ---@type string
    local pos0, pos1 = templateSource:find(TEMPLATE_SOURCE_SETTINGS_LINE)

    print(templateSource, pos0, pos1)
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function SocketSettings:FrameworkInit()
    PluginHandler = PluginFramework:Require("PluginHandler")
    PluginConstants = PluginFramework:Require("PluginConstants")
    Logger = PluginFramework:Require("Logger")
    TableUtil = PluginFramework:Require("TableUtil")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function SocketSettings:FrameworkStart()
    defaultSettings = require(script.Parent.Settings.defaultSettings)
    settingsTemplateFile = script.Parent.Settings.settingsTemplate
end

return SocketSettings
