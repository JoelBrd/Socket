---
---Creates a new macro
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Macros = ServerStorage.SocketPlugin.Macros

--------------------------------------------------
-- Constants
local OPEN_ON_LINE = 24

--------------------------------------------------
-- Members

---@type MacroDefinition
local macroDefinition = {
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
    },
    State = {
        FieldValues = {
            Name = "Macro",
            Icon = "💡",
        },
    },
}

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.Function = function(macro, plugin)
    -- Get Fields
    local name = macro:GetFieldValue("Name")
    local icon = macro:GetFieldValue("Icon")

    -- Create variables
    local description = ("%s Description"):format(name)

    -- Create macro
    local newMacro = Instance.new("ModuleScript") ---@type ModuleScript
    newMacro.Name = name:gsub(" ", "") -- Remove whitespace
    newMacro.Source = script.MacroTemplate.Source:format(name, icon, description, "%s")
    newMacro.Parent = Macros

    -- Open
    plugin:OpenScript(newMacro, OPEN_ON_LINE)
    Selection:Set({ newMacro })
end

return macroDefinition
