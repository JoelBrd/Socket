---
---Nice utility functions to handle multiple instances of Socket running in Team Create
---
---@class InstanceUtil
---
local InstanceUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ChangeHistoryService = game:GetService("ChangeHistoryService") ---@type ChangeHistoryService
local StudioService = game:GetService("StudioService") ---@type StudioService
local Logger = require(script.Parent.Logger)

--------------------------------------------------
-- Constants
local WORKSPACE_DIRECTORY_NAME = "_SocketInstances"

--------------------------------------------------
-- Members

---
---Brings an instance into the workspace in the context of Socket and the user calling this function.
---By default, sets a ChangeHistoryService waypoint.
---@param instance Instance
---@param dontSetWaypoint boolean
---
---@overload fun(instance:Instance)
---
function InstanceUtil:IntroduceInstance(instance, dontSetWaypoint)
    local directory = InstanceUtil:GetDirectory(true)
    instance.Parent = directory

    if not dontSetWaypoint then
        ChangeHistoryService:SetWaypoint("Toggled Locked")
    end
end

---
---Clears an instance from our context of Socket and the user calling this function
---@param instance Instance
---@param doDestroy boolean
---
function InstanceUtil:ClearInstance(instance, doDestroy)
    -- Get directory this was introduced into
    local directory = InstanceUtil:GetDirectory(false)
    if not directory then
        Logger:Warn(("Instance %s was not introduced?"):format(instance:GetFullName()))
        return
    end

    -- Manage instance
    instance.Parent = nil
    if doDestroy then
        instance:Destroy()
    end

    -- Manage directory
    if #directory:GetChildren() == 0 then
        InstanceUtil:Cleanup()
    end
end

---
---Gets the directory to place instances in for this user
---@param doCreate boolean
---@return Configuration
---
function InstanceUtil:GetDirectory(doCreate)
    local workspaceDirectory = game.Workspace:FindFirstChild(WORKSPACE_DIRECTORY_NAME, true)
    if not workspaceDirectory and doCreate then
        workspaceDirectory = Instance.new("Configuration") ---@type Configuration
        workspaceDirectory.Name = WORKSPACE_DIRECTORY_NAME
        workspaceDirectory.Parent = game.Workspace
    end

    local userId = tostring(StudioService:GetUserId())
    local userDirectory = workspaceDirectory and workspaceDirectory:FindFirstChild(userId)
    if not userDirectory and doCreate then
        userDirectory = Instance.new("Configuration") ---@type Configuration
        userDirectory.Name = userId
        userDirectory.Parent = workspaceDirectory
    end

    return userDirectory
end

---
---Cleans up as much as possible for this User
---
function InstanceUtil:Cleanup()
    local userId = tostring(StudioService:GetUserId())
    local workspaceDirectory = game.Workspace:FindFirstChild(WORKSPACE_DIRECTORY_NAME, true)
    local userDirectory = workspaceDirectory and workspaceDirectory:FindFirstChild(userId)

    if userDirectory then
        userDirectory:Destroy()
    end

    if workspaceDirectory and #workspaceDirectory:GetChildren() == 0 then
        workspaceDirectory:Destroy()
    end
end

return InstanceUtil