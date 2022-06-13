---
---Nice utility functions to handle multiple instances of Socket running in Team Create
---
---@class TeamCreateUtil
---
local TeamCreateUtil = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local StudioService = game:GetService("StudioService") ---@type StudioService

--------------------------------------------------
-- Constants
local WORKSPACE_DIRECTORY_NAME = "_SocketInstances"

--------------------------------------------------
-- Members

---
---Brings an instance into the workspace in the context of Socket and the user calling this function
---
function TeamCreateUtil:IntroduceInstance(instance)
    local directory = TeamCreateUtil:GetDirectory()
    instance.Parent = directory
end

---
---Gets the directory to place instances in for this user
---@return Configuration
---
function TeamCreateUtil:GetDirectory()
    local workspaceDirectory = game.Workspace:FindFirstChild(WORKSPACE_DIRECTORY_NAME, true)
    if not workspaceDirectory then
        workspaceDirectory = Instance.new("Configuration") ---@type Configuration
        workspaceDirectory.Name = WORKSPACE_DIRECTORY_NAME
        workspaceDirectory.Parent = game.Workspace
    end

    local userId = tostring(StudioService:GetUserId())
    local userDirectory = workspaceDirectory:FindFirstChild(userId)
    if not userDirectory then
        userDirectory = Instance.new("Configuration") ---@type Configuration
        userDirectory.Name = userId
        userDirectory.Parent = workspaceDirectory
    end

    return userDirectory
end

---
---Cleans up as much as possible for this User
---
function TeamCreateUtil:Cleanup()
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

return TeamCreateUtil
