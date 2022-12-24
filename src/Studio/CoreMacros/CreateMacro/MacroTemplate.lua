-- Macro Template

local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local LuauTypes = require(Utils.LuauTypes)
local Logger = require(Utils.Logger) :: LuauTypes.Logger

type MacroDefinition = LuauTypes.MacroDefinition
type PopulatedMacroDefinition = LuauTypes.PopulatedMacroDefinition

--------------------------------------------------
-- Members

local function macroFunction(macro: PopulatedMacroDefinition, plugin: Plugin)
    if true then
        Logger:MacroInfo(macro, ("Hello %s!"):format(macro.Name))
    else
        Logger:MacroWarn(macro, ("Uh oh %s!"):format(macro.Name))
    end

    -- TODO
end

local macroDefinition: MacroDefinition = {
    Name = "%s",
    Group = "Macros",
    Icon = "%s",
    Description = "%s",
    Function = macroFunction,
}

return macroDefinition
