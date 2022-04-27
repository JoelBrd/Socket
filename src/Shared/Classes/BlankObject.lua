---
---BlankObject object
---
---@class BlankObject:Object
---
local BlankObject = {
    ClassName = "BlankObject",
}
BlankObject.__index = BlankObject

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Classes = script.Parent
local Object = require(Classes.Object) ---@type Object

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---Creates a BlankObject!
---@vararg any
---@return BlankObject
---
function BlankObject.new(...)
    local blankObject = Object:CreateObjectFrom(BlankObject, Object.new(...))
    blankObject:Constructor(...)
    return blankObject
end

---@private
function BlankObject:Constructor(...)
    --todo
end

return BlankObject
