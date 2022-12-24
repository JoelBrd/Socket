-- Macro Template

local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local SocketTypes = require(Utils.SocketTypes)
local Logger = require(Utils.Logger) :: SocketTypes.Logger

type MacroDefinition = SocketTypes.MacroDefinition
type PopulatedMacroDefinition = SocketTypes.PopulatedMacroDefinition

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
