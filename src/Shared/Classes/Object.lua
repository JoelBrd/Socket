---
---OOP class to help create Objects.
---
---@class Object
---
local Object = {
    ClassName = "Object",
}
Object.__index = Object

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
---Creates an object!
---@vararg any
---@return Object
---
function Object.new(...)
    local object = setmetatable({}, Object) ---@type Object
    object:Constructor(...)
    return object
end

---@private
---
---Constructor for the object
function Object:Constructor()
    -- Setup ClassName/Inheritance
    self.ClassName = "Object"
    self._InheritsFrom = { "Object" } ---@type string[]
end

---
---Will create an object, inheriting from a parent object.
---`childClass` is the class as a whole.
---`parentObject` is a specific object, returned from a .new() call.
---@generic C: Object
---@generic K: Object
---@param childClass C
---@param parentObject K
---@return C
---
function Object:CreateObjectFrom(childClass, parentObject)
    -- Setup new object Inheritance Data
    local newObject = parentObject
    local newClassname = childClass.ClassName
    table.insert(newObject._InheritsFrom, newClassname)
    newObject.ClassName = newClassname

    -- Override with new methods + members
    setmetatable(newObject, childClass)

    return newObject
end

---
---Informs us if this object inherits from the passed `className`
---@param className string
---@return boolean
---
function Object:IsA(className)
    return table.find(self._InheritsFrom, className) and true or false
end

---@private
---
---Will be automatically called when object is used in e.g., print()
function Object:__tostring()
    return self.className or "Object"
end

return Object
