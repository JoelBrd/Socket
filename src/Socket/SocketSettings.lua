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
local StudioService = game:GetService("StudioService") ---@type StudioService
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local PluginHandler ---@type PluginHandler
local PluginConstants ---@type PluginConstants
local Logger ---@type Logger
local TableUtil ---@type TableUtil
local ValueUtil ---@type ValueUtil
local StudioHandler ---@type StudioHandler
local SocketController ---@type SocketController
local WidgetHandler ---@type WidgetHandler
local StudioUtil ---@type StudioUtil
local SettingsUtil ---@type SettingsUtil

--------------------------------------------------
-- Constants
local TEMPLATE_SOURCE_SETTINGS_LINE = "local settings = {}"

--------------------------------------------------
-- Members
local cachedLoadedSettings ---@type SocketSettings
local defaultSettings ---@type SocketSettings
local validationFunctions ---@type table
local settingsTemplateFile ---@type ModuleScript
local isValidated = false

---
---Cleans the table of passed settings; syncs with default values, ensures correct types and runs any validation functions.
---If any issues, uses the currently stored value or default value (whichever exists first)
---@param settings SocketSettings
---
function SocketSettings:CleanSettings(settings)
    -- Validate settings
    for settingName, defaultValue in pairs(defaultSettings) do
        -- Get values
        local storedValue = cachedLoadedSettings and cachedLoadedSettings[settingName] or nil
        local setValue = settings[settingName]
        local overrideValue = ValueUtil:ReturnFirstNonNil(storedValue, defaultValue)

        -- SILENT: Doesn't exist
        if settings[settingName] == nil then
            settings[settingName] = overrideValue
            setValue = overrideValue
        end

        -- ISSUE: Bad type
        local defaultType = typeof(defaultValue)
        local setType = typeof(setValue)
        if defaultType ~= setType then
            Logger:Warn(
                ("Issue with Setting %s:%s. Expected type %q, got %q. New value: %q"):format(
                    settingName,
                    tostring(setValue),
                    defaultType,
                    setType,
                    tostring(overrideValue)
                )
            )
            settings[settingName] = overrideValue
        end

        -- ISSUE: Bad validation
        local validationFunction = validationFunctions[settingName]
        local validationError = validationFunction and validationFunction(setValue)
        if validationError then
            Logger:Warn(
                ("Issue with Setting (%s:%s). %s. New value: %q"):format(
                    settingName,
                    tostring(setValue),
                    validationError,
                    tostring(overrideValue)
                )
            )
            settings[settingName] = overrideValue
        end
    end

    -- Sync
    TableUtil:Sync(settings, defaultSettings)
end

---
---Stores the passed settings into our plugin
---
function SocketSettings:SaveSettings(settings)
    -- Clean
    SocketSettings:CleanSettings(settings)

    -- Cache
    cachedLoadedSettings = settings

    -- Serialize
    local serializedSettings = SettingsUtil:Serialize(settings)

    -- Store
    PluginHandler:SetSetting(PluginConstants.Setting, serializedSettings)
end

---
---@return table
---
function SocketSettings:LoadSettings()
    -- Deserialize
    local serializedSettings = PluginHandler:GetSetting(PluginConstants.Setting) or {}
    local deserializedSettings = SettingsUtil:Deserialize(serializedSettings)

    -- Clean
    SocketSettings:CleanSettings(deserializedSettings)

    -- Cache
    cachedLoadedSettings = deserializedSettings

    return deserializedSettings
end

---
---Will ensure the stored settings on the plugin is in line with our template.
---Usually called on startup.
---
function SocketSettings:ValidateSettings()
    -- Load, then save incase anything happened during cleaning
    local loadedSettings = SocketSettings:LoadSettings()
    SocketSettings:SaveSettings(loadedSettings)

    -- Cache Action
    isValidated = true
end

---
---Returns the currently set value for this settingName
---@param settingName string
---@return any
---
function SocketSettings:GetSetting(settingName)
    -- Ensure validated
    while not isValidated do
        task.wait()
    end

    local settings = cachedLoadedSettings or SocketSettings:LoadSettings()
    local settingValue = settings[settingName]

    -- ERROR: Bad settingName
    if settingValue == nil then
        Logger:Error(("No Setting %q"):format(settingName))
    end

    return settingValue
end

---
---@return SocketSettings
---
function SocketSettings:GetDefaultSettings()
    return defaultSettings
end

---
---Opens up a settings file, with the users settings loaded on.
---When the user closes the file, we read their settings.
---
function SocketSettings:OpenSettings()
    -- Get Settings Names
    local storedSettings = PluginHandler:GetSetting(PluginConstants.Setting)
    local settingsNames = TableUtil:KeysToArray(storedSettings)
    table.sort(settingsNames) -- Alphabetical order

    -- Create source
    local templateSource = settingsTemplateFile.Source ---@type string
    local pos0, pos1 = templateSource:find(TEMPLATE_SOURCE_SETTINGS_LINE)
    if not (pos0 and pos1) then
        Logger:Error(("Could not find pattern %q in \n%q"):format(TEMPLATE_SOURCE_SETTINGS_LINE, templateSource))
    end

    -- Replace settings = {} with a populated version
    local newSettingsLine = "local settings = {"
    for _, settingName in pairs(settingsNames) do
        local settingValue = SocketSettings:GetSetting(settingName)
        newSettingsLine = ("%s\n    %s = %s,"):format(newSettingsLine, settingName, ValueUtil:ValueToSourceString(settingValue))
    end
    newSettingsLine = ("%s\n}"):format(newSettingsLine)

    -- Swap out with our populated version
    local newSource = templateSource:gsub(TEMPLATE_SOURCE_SETTINGS_LINE, newSettingsLine, 1)

    -- Create module script to host the settings, with the new source
    local settingsScript = Instance.new("ModuleScript") ---@type ModuleScript
    settingsScript.Name = StudioUtil:GetUserIdentifier()
    settingsScript.Source = newSource
    settingsScript.Parent = StudioHandler.Folders.Directory

    -- Open her up
    PluginHandler:GetPlugin():OpenScript(settingsScript)

    --------------------------------------------------
    local function saveSettingsOnClose()
        -- Get Settings
        local newSettings ---@type SocketSettings
        local success, err = pcall(function()
            newSettings = require(settingsScript)
        end)
        if not success then
            Logger:Warn(("Error occured when exiting settings, no changes were able to be saved (%s)"):format(err))
        else
            -- Save
            SocketSettings:SaveSettings(newSettings)

            -- OVERRIDE: Has default settings been enabled?
            if SocketSettings:GetSetting("UseDefaultSettings") == true then
                SocketSettings:SaveSettings(TableUtil:DeepCopy(defaultSettings))
            end

            -- Refresh widget
            WidgetHandler:Refresh()

            Logger:Info("Settings updated!")
        end
    end

    -- Listener to the user viewing different scripts; used to know when to read + write the settingsScript
    local cachedActiveScript ---@type Instance
    local activeScriptConnection ---@type RBXScriptConnection
    activeScriptConnection = StudioService:GetPropertyChangedSignal("ActiveScript"):Connect(function()
        local justClosedSettings = cachedActiveScript and cachedActiveScript == settingsScript
        if justClosedSettings then
            saveSettingsOnClose()

            -- Close up shop!
            settingsScript:Destroy()
            activeScriptConnection:Disconnect()
        end

        -- Update cache
        cachedActiveScript = StudioService.ActiveScript
    end)

    -- Cleanup incase plugin closes
    local runJanitor = SocketController:GetRunJanitor()
    runJanitor:Add(function()
        saveSettingsOnClose()
        settingsScript:Destroy()
        activeScriptConnection:Disconnect()
    end)
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
    ValueUtil = PluginFramework:Require("ValueUtil")
    StudioHandler = PluginFramework:Require("StudioHandler")
    SocketController = PluginFramework:Require("SocketController")
    WidgetHandler = PluginFramework:Require("WidgetHandler")
    StudioUtil = PluginFramework:Require("StudioUtil")
    SettingsUtil = PluginFramework:Require("SettingsUtil")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function SocketSettings:FrameworkStart()
    local defaultSettingsTable = require(script.Parent.Settings.defaultSettings)
    defaultSettings = defaultSettingsTable.defaultSettings
    validationFunctions = defaultSettingsTable.validationFunctions

    settingsTemplateFile = script.Parent.Settings.settingsTemplate
end

return SocketSettings
