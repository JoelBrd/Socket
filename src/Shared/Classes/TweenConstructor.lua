---
---Powerful wrapper for tweening an object
---
---@class TweenConstructor:Object
---
local TweenConstructor = {
    ClassName = "TweenConstructor",
}
TweenConstructor.__index = TweenConstructor

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local TweenService = game:GetService("TweenService") ---@type TweenService
local Classes = script.Parent
local Object = require(Classes.Object) ---@type Object

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---Creates a TweenConstructor!
---@vararg any
---@return TweenConstructor
---
function TweenConstructor.new(...)
    local tweenConstructor = Object:CreateObjectFrom(TweenConstructor, Object.new(...))
    tweenConstructor:Constructor(...)
    return tweenConstructor
end

---@private
---
---Constructor for the TweenConstructor
function TweenConstructor:Constructor()
    self.instance = nil ---@type Instance
    self.duration = 1
    self.repeats = 0
    self.delay = 0
    self.reverses = false
    self.easingStyle = Enum.EasingStyle.Linear
    self.easingDirection = Enum.EasingDirection.InOut
    self.properties = {}
end

---
---Sets a singular instance for this tween to apply to
---@param instance Instance
---@return TweenConstructor
---
function TweenConstructor:SetInstance(instance)
    self.instance = instance
    return self
end

---
---Returns the instances currently set for this TweenConstructor object
---@return Instance
---
function TweenConstructor:GetInstance()
    return self.instance
end

---
---Sets the duration of this tween. Defaults to 1.
---@param duration number
---@return TweenConstructor
---
function TweenConstructor:SetDuration(duration)
    self.duration = duration
    return self
end

---
---Returns the duration currently set for this TweenConstructor object
---@return number
---
function TweenConstructor:GetDuration()
    return self.duration
end

---
---Sets the easing style of this tween. Defaults to Linear.
---@param easingStyle Enum.EasingStyle
---@return TweenConstructor
---
function TweenConstructor:SetEasingStyle(easingStyle)
    self.easingStyle = easingStyle
    return self
end

---
---Returns the easing style currently set for this TweenConstructor object
---@return Enum.EasingStyle
---
function TweenConstructor:GetEasingStyle()
    return self.easingStyle
end

---
---Sets the easing direction of this tween. Defaults to InOut.
---@param easingDirection Enum.EasingDirection
---@return TweenConstructor
---
function TweenConstructor:SetEasingDirection(easingDirection)
    self.easingDirection = easingDirection
    return self
end

---
---Returns the easing direction currently set for this TweenConstructor object
---@return Enum.EasingDirection
---
function TweenConstructor:GetEasingDirection()
    return self.easingDirection
end

---
---Define the number of repeats for this tween. Defaults to 0.
---@param repeats number
---@return TweenConstructor
---
function TweenConstructor:SetRepeats(repeats)
    self.repeats = repeats
    return self
end

---
---@return number
---
function TweenConstructor:GetRepeats()
    return self.repeats
end

---
---Define whether this tween should reverse or not
---@param doReverse boolean
---@return TweenConstructor
---
function TweenConstructor:SetReverse(doReverse)
    self.reverses = doReverse
    return self
end

---
---@return boolean
---
function TweenConstructor:IsReverse()
    return self.reverses
end

---
---@param delayTime number
---@return TweenConstructor
---
function TweenConstructor:SetDelay(delayTime)
    self.delayTime = delayTime
    return self
end

---
---@return number
---
function TweenConstructor:GetDelay()
    return self.delayTime
end

---
---Sets the duration, style, and direction based from the given TweenInfo.
---@param tweenInfo TweenInfo
---@return TweenConstructor
---
function TweenConstructor:SetTweenInfo(tweenInfo)
    self.duration = tweenInfo.Time
    self.easingStyle = tweenInfo.EasingStyle
    self.easingDirection = tweenInfo.EasingDirection
    return self
end

---
---Sets the property for this tween.
---@param key string
---@param value any
---@return TweenConstructor
---
function TweenConstructor:SetProperty(key, value)
    self.properties[key] = value
    return self
end

---
---Returns the value for the specified property currently set for this TweenConstructor object
---@param propertyName string
---@return any
---
function TweenConstructor:GetPropertyValue(propertyName)
    return self.properties[propertyName]
end

---
---Returns the properties currently set for this TweenConstructor object
---@return table<string, any>
---
function TweenConstructor:GetProperties()
    return self.properties
end

---
---Builds this tween without playing it.
---@return Tween
---
function TweenConstructor:BuildOnly()
    local tweenInfo = TweenInfo.new(
        self.duration or 1,
        self.style or Enum.EasingStyle.Quad,
        self.direction or Enum.EasingDirection.InOut,
        self.repeats,
        self.reverses,
        self.delay
    )
    local tween = TweenService:Create(self.instance, tweenInfo, self.properties) ---@type Tween
    return tween
end

---
---Builds this tween and plays it.
---@return Tween
---
function TweenConstructor:Play()
    local tween = self:BuildOnly()
    tween:Play()
    return tween
end

return TweenConstructor
