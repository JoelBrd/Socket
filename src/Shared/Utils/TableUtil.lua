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

---
---Makes tbl match the layout of templateTbl, with identical keys. Populates any missing keys with the value from templateTbl.
---Will also populate values of the wrong type with the default value.
---@param tbl table
---@param templateTbl table
---
function TableUtil:Sync(tbl, templateTbl)
    for key, value in pairs(tbl) do
        local valueTemplate = templateTbl[key]

        -- Manage existing keys
        if valueTemplate == nil or type(value) ~= type(valueTemplate) then
            tbl[key] = nil
        elseif type(value) == "table" then
            self:Sync(value, valueTemplate)
        end
    end

    -- Add any missing keys
    for key, valueTemplate in pairs(templateTbl) do
        local value = tbl[key]
        if value == nil then
            if type(valueTemplate) == "table" then
                tbl[key] = TableUtil:DeepCopy(valueTemplate)
            else
                tbl[key] = valueTemplate
            end
        end
    end
end

---
---Returns a copy of the table with completely unique references
---@generic T : table
---@param t T
---@return T
---
function TableUtil:DeepCopy(t)
    local tCopy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            tCopy[k] = TableUtil:DeepCopy(v)
        else
            tCopy[k] = v
        end
    end
    return tCopy
end

return TableUtil
