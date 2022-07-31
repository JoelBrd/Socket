---
---Utility functions for values
---
---@class ValueUtil
---
local ValueUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local valueToSourceStringToStringTypes = { "number", "boolean" }

---
---Passed a value, will return a string that could represent it in a lua file.
---Example:
---    local value1 = true: boolean
---    print(ValueUtil:ValueToSourceString(value1)) -> "true"
---
---    local value2 = Enum.KeyCode.H
---    print(ValueUtil:ValueToSourceString(value2)) -> "Enum.KeyCode.H"
---
function ValueUtil:ValueToSourceString(value)
    local valueType = typeof(value)

    -- String
    if valueType == "string" then
        return ('"%s"'):format(value)
    end

    -- To String method
    if table.find(valueToSourceStringToStringTypes, valueType) then
        return tostring(value)
    end

    -- Enum Item
    if valueType == "EnumItem" then
        return ("Enum.%s.%s"):format(tostring(value.EnumType), tostring(value.Name))
    end

    -- Color3
    if valueType == "Color3" then
        return ("Color3.fromRGB(%d, %d, %d)"):format(value.R * 255, value.G * 255, value.B * 255)
    end

    error(("Don't know how to convert %q (%s) into a source string"):format(tostring(value), valueType))
end

---
---Passed a list of values, returns the first non-nil value
---@vararg any
---@return any
---
function ValueUtil:ReturnFirstNonNil(...)
    local tbl = table.pack(...)
    for _, value in pairs(tbl) do
        if value ~= nil then
            return value
        end
    end
end

return ValueUtil
