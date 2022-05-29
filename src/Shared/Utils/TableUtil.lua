---
---Utility functions for tables
---
---@class TableUtil
---
local TableUtil = {}

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

---
---Returns the size of the passed table (arrays and dictionaries)
---@return number
---
function TableUtil:Size(tbl)
    local count = 0
    for _, _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

return TableUtil
