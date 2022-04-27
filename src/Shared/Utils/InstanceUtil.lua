---
---Utility functions for managing Roblox Instances
---
---@class InstanceUtil
---
local InstanceUtil = {}

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
---Designed to be used to sync a template data structure onto an existing/empty data structure. Instances must have unique names.
---Will sync all the descendants of `templateInstance` to `parentInstance`.
---If `strict`=true, any descendants in `parentInstance` that are *not* in `templateInstance` will be removed.
---If `overwite`=true, will completely copy over `templateInstance`, even if descendants of the correct name/type exist in `parentInstance`.
---@param templateInstance Instance
---@param parentInstance Instance
---@param strict boolean
---@param overwrite boolean
---
function InstanceUtil:Sync(templateInstance, parentInstance, strict, overwrite)
    -- If strict, clear any alien instances in `parentInstance`
    if strict then
        for _, child in pairs(parentInstance:GetChildren()) do
            local name = child.Name
            local className = child.ClassName
            local matchingNameInstance = templateInstance:FindFirstChild(name)
            local isMatchingInstance = matchingNameInstance and matchingNameInstance.ClassName == className

            local isAlien = not isMatchingInstance
            if isAlien then
                child:Destroy()
            end
        end
    end

    -- Copy over template children
    for _, child in pairs(templateInstance:GetChildren()) do
        local name = child.Name
        local className = child.ClassName
        local matchingNameInstance = parentInstance:FindFirstChild(name)
        local isMatchingInstance = matchingNameInstance and matchingNameInstance.ClassName == className

        -- If a template child + overwrite is true, destroy so we can put a fresh copy in there
        if overwrite and isMatchingInstance then
            matchingNameInstance:Destroy()
            matchingNameInstance = nil
        end

        if matchingNameInstance == nil then
            child:Clone().Parent = parentInstance
        else
            -- Sync the children of this instances
            InstanceUtil:Sync(child, matchingNameInstance, strict, overwrite)
        end
    end
end

return InstanceUtil
