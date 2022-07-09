---
---Necessary script to initialise the plugin!
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:WaitForChild("PluginFramework")) ---@type Framework
local PluginHandler ---@type PluginHandler

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local pluginFrameworkScript = script.PluginFramework
local sharedDirectory = pluginFrameworkScript.Shared

local librariesDirectory = sharedDirectory.Libraries.Packages

local utilsDirectory = sharedDirectory.Utils
local classesDirectory = sharedDirectory.Classes
local pluginDirectory = pluginFrameworkScript.Plugin
local macrosDirectory = pluginFrameworkScript.Macros
local studioDirectory = pluginFrameworkScript.Studio
local socketDirectory = pluginFrameworkScript.Socket

---Loads everything onto the plugin framework
local function setupFramework()
    -- Libraries
    PluginFramework:AddCustomModule("Roact", librariesDirectory.roact)
    PluginFramework:AddCustomModule("Rodux", librariesDirectory.rodux)
    PluginFramework:AddCustomModule("TestEZ", librariesDirectory.testez)
    PluginFramework:AddCustomModule("RoactRodux", librariesDirectory["roact-rodux"])

    -- General files
    PluginFramework:Load(utilsDirectory, classesDirectory, pluginDirectory, macrosDirectory, studioDirectory, socketDirectory)
end

local function grabDependencies()
    PluginHandler = PluginFramework:Require("PluginHandler")
end

local function loadPlugin()
    PluginHandler:Load(plugin)
end

local function isInPluginContext()
    return not script:IsDescendantOf(game.ServerScriptService)
end

--------------------------------------------------
-- Logic

if isInPluginContext() then
    setupFramework()
    grabDependencies()
    loadPlugin()
end
