---
---Utility for Macro Fields
---
---@class FieldsUtil
---
local FieldsUtil = {}

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
-- ...

---
---@return fun(value:string):string
---
function FieldsUtil:GetKeybindValidator()
    return function(keyCodeName)
        local isValidKeyCodeName = Enum.KeyCode[keyCodeName] and true or false
        if not isValidKeyCodeName then
            return ("Invalid KeyCode %q"):format(keyCodeName)
        end
    end
end

return FieldsUtil
