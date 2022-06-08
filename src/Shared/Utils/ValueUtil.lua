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
local valueToSourceStringToStringTypes = { "number", "boolean", "string" }

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

    -- To String method
    if table.find(valueToSourceStringToStringTypes, valueType) then
        return tostring(value)
    end

    -- Enum Item
    if valueType == "EnumItem" then
        return ("Enum.%s.%s"):format(tostring(value.EnumType), tostring(value.Name))
    end

    error(("Don't know how to convert %q (%s) into a source string"):format(tostring(value), valueType))
end

return ValueUtil
