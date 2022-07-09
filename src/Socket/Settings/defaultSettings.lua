---
---Default Socket Settings
---

-- Constants
local SORT_TYPES = { "Name", "LayoutOrder", "Icon" }

--------------------------------------------------
-- Members

---@type SocketSettings
local settings = {
    Font = Enum.Font.Highway,
    UIScale = 1,
    OpenFieldsByDefault = true,
    SortType = "Name",
    IgnoreGameProcessedKeybinds = false,
    EnableSocketMacros = true,
    EnableSocketMacrosOverwrite = true,
    EnableAutoRun = true,
    UseDefaultSettings = false,
}

---@type table<string, fun(value:any):string|nil>
local validationFunctions = {
    Font = function(value)
        if not value.EnumType == Enum.Font then
            return "Not passed an Enum.Font value"
        end
    end,
    SortType = function(value)
        if not table.find(SORT_TYPES, value) then
            return ("Bad SortType. Good SortTypes: %s"):format(table.concat(SORT_TYPES, ", "))
        end
    end,
}

return {
    defaultSettings = settings,
    validationFunctions = validationFunctions,
}
