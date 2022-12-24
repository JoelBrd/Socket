-- Creates a new macro

local Selection = game:GetService("Selection")
local ServerStorage = game:GetService("ServerStorage")
local Macros = ServerStorage.SocketPlugin.Macros
local Utils = ServerStorage.SocketPlugin.Utils
local StudioUtil = require(Utils.StudioUtil)
local SocketTypes = require(Utils.SocketTypes)

type MacroDefinition = SocketTypes.MacroDefinition
type PopulatedMacroDefinition = SocketTypes.PopulatedMacroDefinition

local OPEN_ON_LINE = 21

local function getLocalMacrosDirectory()
    return ServerStorage.SocketPlugin.LocalMacros:FindFirstChild(tostring(StudioUtil:GetUserIdentifier()))
end

local function macroFunction(macro: PopulatedMacroDefinition, plugin: Plugin)
    -- Get Fields
    local name = macro:GetFieldValue("Name")
    local icon = macro:GetFieldValue("Icon")
    local isLocal = macro:GetFieldValue("Is Local")

    -- Create variables
    local description = ("%s Description"):format(name)

    -- Create macro
    local newMacro = Instance.new("ModuleScript") :: BaseScript
    newMacro.Name = name:gsub(" ", "") -- Remove whitespace
    newMacro.Source = script.MacroTemplate.Source:format("%s", "%s", name, icon, description)
    newMacro.Parent = isLocal and getLocalMacrosDirectory() or Macros

    -- Open
    plugin:OpenScript(newMacro, OPEN_ON_LINE)
    Selection:Set({ newMacro })
end

local macroDefinition: MacroDefinition = {
    Group = "Core",
    Name = "Create Macro",
    Description = "Creates a new macro",
    Icon = "🟢",
    Fields = {
        {
            Type = "string",
            Name = "Name",
            IsRequired = true,
        },
        {
            Type = "string",
            Name = "Icon",
            IsRequired = true,
        },
        {
            Type = "boolean",
            Name = "Is Local",
            IsRequired = true,
        },
    },
    State = {
        FieldValues = {
            Name = "Macro",
            Icon = "💡",
            ["Is Local"] = false,
        },
    },
    Function = macroFunction,
}

return macroDefinition
