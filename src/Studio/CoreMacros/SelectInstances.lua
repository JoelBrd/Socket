---
---SelectInstances
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local description =
    "Will select all instances that are descendants of the selected instance, that meet our parameters defined in our fields.\n"
description = ("%s\n%s"):format(description, "Name: The .Name of an eligible instance")
description = ("%s\n%s"):format(description, "ClassName: Instance is eligible if :IsA(className) == true")
description = ("%s\n%s"):format(description, "Child Name: Instance is eligible if :didFindFirstChild(childName, recurse) == true")
description = ("%s\n%s"):format(description, "Recurse Children: Defines `recurse` boolean value for `Child Name`")
description = ("%s\n%s"):format(
    description,
    "Exact Match: If true, instance is eligible if e.g., its .Name == `Name`. If false, instance is eligible if only part of the e.g., .Name matches `Name`"
)
description = ("%s\n%s"):format(description, "Case Sensitive: If false, all eligibility logic ignores lower case/upper case")
description = ("%s\n%s"):format(description, "Max Amount: Will not select any instances more than this")

---@type MacroDefinition
local macroDefinition = {
    Group = "Core", ---@type string
    Name = "Select Instances",
    Icon = "❇️",
    Description = description, ---@type string
    EnableAutomaticUndo = true, ---@type boolean
    Fields = {
        {
            Name = "Name",
            Type = "string",
        },
        {
            Name = "ClassName",
            Type = "string",
        },
        {
            Name = "Child Name",
            Type = "string",
        },
        {
            Name = "Recurse Children",
            Type = "boolean",
        },
        {
            Name = "Exact Match",
            Type = "boolean",
        },
        {
            Name = "Case Sensitive",
            Type = "boolean",
        },
        {
            Name = "Max Amount",
            Type = "number",
        },
    },
    State = {
        FieldValues = {
            ["Recurse Children"] = false,
            ["Exact Match"] = true,
            ["Case Sensitive"] = true,
        },
    },
}

---@param parent Instance
---@param name string
---@param recurseChildren boolean
---@param exactMatch boolean
---@param caseSensitive boolean
---@return boolean
local function didFindFirstChild(parent, name, recurseChildren, exactMatch, caseSensitive)
    local options = recurseChildren and parent:GetDescendants() or parent:GetChildren()
    for _, option in pairs(options) do
        local optionName = caseSensitive and option.Name or option.Name:upper()
        local doesMatch = exactMatch and optionName == name or string.find(optionName, name)
        if doesMatch then
            return true
        end
    end

    return false
end

---@param instances Instance[]
---@param name string|nil
---@param className string|nil
---@param childName string|nil
---@param recurseChildren boolean
---@param exactMatch boolean
---@param caseSensitive boolean
---@param maxAmount number|nil
---@return Instances[]
local function search(instances, name, className, childName, recurseChildren, exactMatch, caseSensitive, maxAmount)
    local results = {}

    -- Transform data
    name = name and (caseSensitive and name or name:upper())
    childName = childName and (caseSensitive and childName or childName:upper())

    -- Loop instance descendants
    for _, instance in pairs(instances) do
        for _, descendant in pairs(instance:GetDescendants()) do
            -- Transform data
            local descendantName = caseSensitive and descendant.Name or descendant.Name:upper()

            -- Check if an eligible instance
            local hasMatchingName = not name or (exactMatch and descendantName == name or string.find(descendantName, name))
            local hasMatchingChildOfName = not childName
                or didFindFirstChild(descendant, childName, recurseChildren, exactMatch, caseSensitive)
            local hasMatchingClassName = not className or descendant:IsA(className)
            if hasMatchingName and hasMatchingClassName and hasMatchingChildOfName then
                table.insert(results, descendant)
            end

            -- Return if we met the cap
            if #results == maxAmount then
                return results
            end
        end
    end

    return results
end

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.Function = function(macro, plugin)
    -- Get Selection
    local selectedInstances = Selection:Get()
    if #selectedInstances == 0 then
        Logger:MacroWarn(macro, "Please select atleast 1 instance to search in")
        return
    end

    -- Get State
    local name = macro:GetFieldValue("Name")
    local className = macro:GetFieldValue("ClassName")
    local childName = macro:GetFieldValue("Child Name")
    local recurseChildren = macro:GetFieldValue("Recurse Children") and true or false
    local exactMatch = macro:GetFieldValue("Exact Match") and true or false
    local caseSensitive = macro:GetFieldValue("Case Sensitive") and true or false
    local maxAmount = macro:GetFieldValue("Max Amount")

    -- Search
    local results = search(selectedInstances, name, className, childName, recurseChildren, exactMatch, caseSensitive, maxAmount)

    -- Select
    Selection:Set(results)

    -- Log
    Logger:MacroInfo(macro, ("Selected %d eligible instances"):format(#results))
end

return macroDefinition
