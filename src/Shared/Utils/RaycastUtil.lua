---
---RaycastUtil
---
---@class RaycastUtil
---
local RaycastUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local PhysicsService = game:GetService("PhysicsService") ---@type PhysicsService

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---
---Returns the RaycastResult of raycasting toward the position our mouse is at in the world.
---If `checkAllCollisionGroups` is true, will raycast in CollisionGroups that don't collide with the `Default` collision groups as well.
---@param distance number
---@param raycastParams RaycastParams
---@param checkAllCollisionGroups boolean
---@return RaycastResult
---
---@overload fun(distance:number):RaycastResult
---
function RaycastUtil:RaycastMouse(distance, raycastParams, checkAllCollisionGroups)
    -- Get Mouse Position on screen
    local mousePoint = UserInputService:GetMouseLocation()

    -- Get Ray
    local camera = game.Workspace.CurrentCamera
    local unitRay = camera:ViewportPointToRay(mousePoint.X, mousePoint.Y)

    -- Raycast
    return RaycastUtil:Raycast(camera.CFrame.Position, unitRay.Direction, distance, raycastParams, checkAllCollisionGroups)
end

---
---Returns the RaycastResult of this raycast.
---If `checkAllCollisionGroups` is true, will raycast in CollisionGroups that don't collide with the `Default` collision groups as well.
---@param origin Vector3
---@param direction Vector3
---@param distance number
---@param raycastParams RaycastParams
---@param checkAllCollisionGroups boolean
---@return RaycastResult
---
---@overload fun(distance:number):RaycastResult
---
function RaycastUtil:Raycast(origin, direction, distance, raycastParams, checkAllCollisionGroups)
    checkAllCollisionGroups = checkAllCollisionGroups or false
    direction = direction.Unit

    -- Raycast
    local raycastResult = game.Workspace:Raycast(origin, direction * distance, raycastParams)
    if checkAllCollisionGroups then
        -- Get groups that don't collide with default
        local groupNames = {}
        for _, groupInfo in pairs(PhysicsService:GetRegisteredCollisionGroups()) do
            local name = groupInfo.name
            if not PhysicsService:CollisionGroupsAreCollidable("Default", name) then
                table.insert(groupNames, name)
            end
        end

        -- Check if we get a closer raycastResult
        for _, groupName in pairs(groupNames) do
            local newRaycastParams = RaycastParams.new()
            newRaycastParams.CollisionGroup = groupName
            newRaycastParams.FilterDescendantsInstances = raycastParams and raycastParams.FilterDescendantsInstances
                or newRaycastParams.FilterDescendantsInstances
            newRaycastParams.FilterType = raycastParams and raycastParams.FilterType or newRaycastParams.FilterType
            newRaycastParams.IgnoreWater = raycastParams and raycastParams.IgnoreWater or newRaycastParams.IgnoreWater

            local newRaycastResult = game.Workspace:Raycast(origin, direction * distance, newRaycastParams)
            local thisIsABetterResult = not raycastResult or newRaycastResult and raycastResult.Distance > newRaycastResult.Distance
            raycastResult = thisIsABetterResult and newRaycastResult or raycastResult
        end
    end

    return raycastResult
end

return RaycastUtil
