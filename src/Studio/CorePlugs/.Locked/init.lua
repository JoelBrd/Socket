---
---.Locked
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local RunService = game:GetService("RunService") ---@type RunService
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local PhysicsService = game:GetService("PhysicsService") ---@type PhysicsService
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
local COLLISION_GROUP_NAME = "SocketLocked"
local DEFAULT_COLLISION_GROUP_ID = 0
local RAYCAST_DISTANCE = 1000
local DO_TRACE = true
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.CollisionGroup = COLLISION_GROUP_NAME
local EPSILON = 0.01

--------------------------------------------------
-- Members
local description = "When enabled, will put all `Locked=true` instances in game.Workspace into a custom collision group. "
description = ("%s%s"):format(description, "This adds the functionality to be able to select instances through `Locked=true` instances.")
description = ("%s\n%s"):format(description, "Will only affect locked parts with the default collision group (Id=0)")
description = ("%s\n%s"):format(description, "Use Selection: If true, will only notice .Locked changes of selected Instances.")
description = ("%s%s"):format(
    description,
    "You may want to set this to false if you have other scripts changing .Locked value, as by default"
)
description = ("%s%s"):format(description, "these changes will not be detected (to aid performance)")
description = ("%s\n%s"):format(description, "Do Highlight: If true, will highlight locked parts that would be otherwise selected.")

local function trace(plug, ...)
    if not DO_TRACE then
        return
    end

    Logger:PlugInfo(plug, ...)
end

---Returns true if logic was ran; returns false if instance can be totally ignored
---@param plug PlugDefinition
---@param instance Instance
---@return boolean
local function checkInstance(plug, instance)
    -- RETURN: Not basepart
    if not instance:IsA("BasePart") then
        return false
    end

    -- Get state
    local isRunning = plug.State.IsRunning

    -- Add/Remove from our collision group
    if isRunning then
        local doAdd = instance:IsDescendantOf(game.Workspace)
            and instance.Locked
            and instance.CollisionGroupId == DEFAULT_COLLISION_GROUP_ID
        local doRemove = ((not instance:IsDescendantOf(game.Workspace) and instance.Locked) or not instance.Locked)
            and instance.CollisionGroupId == plug.State.CollisionGroupId
        if doAdd then
            instance.CollisionGroupId = plug.State.CollisionGroupId
            trace(plug, ("Added %s"):format(instance:GetFullName()))
        elseif doRemove then
            instance.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
            trace(plug, ("Removed %s"):format(instance:GetFullName()))
        end
    else
        local doRemove = instance.CollisionGroupId == plug.State.CollisionGroupId
        if doRemove then
            instance.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
            trace(plug, ("Removed %s"):format(instance:GetFullName()))
        end
    end

    return true
end

---@return number
local function createCollisionGroup()
    -- Get Collision groups
    local collisionGroups = PhysicsService:GetCollisionGroups()
    local names = {}
    local groupAlreadyCreated = false
    for _, collisionGroupData in pairs(collisionGroups) do
        local isOurCollisionGroup = collisionGroupData.name == COLLISION_GROUP_NAME
        if isOurCollisionGroup then
            groupAlreadyCreated = true
        end

        table.insert(names, collisionGroupData.name)
    end

    -- Create
    local id = groupAlreadyCreated and PhysicsService:GetCollisionGroupId(COLLISION_GROUP_NAME)
        or PhysicsService:CreateCollisionGroup(COLLISION_GROUP_NAME)

    -- Define collisions
    for _, name in pairs(names) do
        PhysicsService:CollisionGroupSetCollidable(name, COLLISION_GROUP_NAME, false)
    end
    PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP_NAME, COLLISION_GROUP_NAME, true)

    -- Return id
    return id
end

---@param plug PlugDefinition
local function stoppedRunning(plug)
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        checkInstance(plug, descendant)
    end

    for _, connection in pairs(plug.State.Connections) do
        trace(plug, "Disconnected", connection)
        connection:Disconnect()
    end

    for _, selectionBox in pairs(plug.State.SelectionBoxes) do
        selectionBox:Destroy()
    end

    plug.State.InstanceCache = nil
    plug.State.SelectionCache = nil
    plug.State.SelectionBoxes = nil
end

---Runs routines to keep track of locked instances and bring them into the scope of the plug
---@param plug PlugDefinition
local function trackLockedInstances(plug)
    -- Read state
    local doUseSelection = plug.State.FieldValues["Use Selection"]

    ---Tracks the .Locked property of this instance changing for all time
    ---@param instance Instance
    ---@return RBXScriptConnection
    local function trackLockedProperty(instance)
        if not plug.State.InstanceTrackingConnections[instance] then
            local connection = instance:GetPropertyChangedSignal("Locked"):Connect(function()
                checkInstance(plug, instance)
            end)
            table.insert(plug.State.Connections, connection)
            plug.State.InstanceTrackingConnections[instance] = connection
            return connection
        end
    end

    ---@param instances Instance[]
    local function selectionChanged(instances)
        -- Disconnect old selection
        for instance, connection in pairs(plug.State.SelectionConnections) do
            local index = table.find(plug.State.Connections, connection)
            if index then
                table.remove(plug.State.Connections, index)
            end
            plug.State.InstanceTrackingConnections[instance] = nil
            connection:Disconnect()
        end
        plug.State.SelectionConnections = {}

        -- Update new selection
        for _, instance in pairs(instances) do
            local doRecognise = checkInstance(plug, instance)
            if doRecognise then
                local connection = trackLockedProperty(instance)
                plug.State.SelectionConnections[instance] = connection
            end
        end
    end

    table.insert(
        plug.State.Connections,
        game.Workspace.DescendantAdded:Connect(function(descendant)
            local doRecognise = checkInstance(plug, descendant)
            if not doUseSelection and doRecognise then
                trackLockedProperty(descendant)
            end
        end)
    )
    table.insert(
        plug.State.Connections,
        game.Workspace.DescendantRemoving:Connect(function(descendant)
            checkInstance(plug, descendant)

            local connection = plug.State.InstanceTrackingConnections[descendant]
            if connection then
                local index = table.find(plug.State.Connections, connection)
                if index then
                    table.remove(plug.State.Connections, index)
                end

                connection:Disconnect()
                plug.State.InstanceTrackingConnections[descendant] = nil
            end
        end)
    )

    -- Setup listening to .Locked changes
    if doUseSelection then
        table.insert(
            plug.State.Connections,
            Selection.SelectionChanged:Connect(function()
                selectionChanged(Selection:Get())
            end)
        )
    end

    -- Loop through current descendants
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        local doRecognise = checkInstance(plug, descendant)
        if not doUseSelection and doRecognise then
            trackLockedProperty(descendant)
        end
    end
end

---Raycasts to check if we're looking through any locked parts
---@param plug PlugDefinition
local function trackMouse(plug)
    -- Read state
    local doHighlight = plug.State.FieldValues["Do Highlight"]
    local highlightColor = plug.State.FieldValues["Color"]
    local highlightThickness = plug.State.FieldValues["Thickness"]
    local highlightTransparency = plug.State.FieldValues["Transparency"]
    if not doHighlight then
        return
    end

    ---@return SelectionBox
    local function createSelection()
        local selectionBox = Instance.new("SelectionBox") ---@type SelectionBox
        selectionBox.Color3 = highlightColor
        selectionBox.LineThickness = highlightThickness
        selectionBox.Transparency = highlightTransparency
        selectionBox.Parent = game.Workspace

        return selectionBox
    end

    local renderDebounce = false
    table.insert(
        plug.State.Connections,
        RunService.RenderStepped:Connect(function()
            -- RETURN: Debounce
            if renderDebounce then
                return
            end
            renderDebounce = true

            -- Get Mouse Position on screen
            local mousePoint = UserInputService:GetMouseLocation()

            -- Get Ray
            local camera = game.Workspace.CurrentCamera
            local unitRay = camera:ViewportPointToRay(mousePoint.X, mousePoint.Y)

            -- Iterate raycast
            local lockedParts = {}
            local origin = camera.CFrame.Position
            while true do
                -- Raycast for point
                local lockedRaycastResult = game.Workspace:Raycast(origin, unitRay.Direction * RAYCAST_DISTANCE, RAYCAST_PARAMS)
                local defaultRaycastResult = game.Workspace:Raycast(origin, unitRay.Direction * RAYCAST_DISTANCE)

                -- Calculations
                local lockedDistance = lockedRaycastResult and (lockedRaycastResult.Position - origin).Magnitude or math.huge
                local defaultDistance = defaultRaycastResult and (defaultRaycastResult.Position - origin).Magnitude or math.huge
                local hitLockedPart = lockedRaycastResult and true or false

                -- Decisions
                if hitLockedPart and lockedDistance < defaultDistance then
                    table.insert(lockedParts, lockedRaycastResult.Instance)
                    origin = lockedRaycastResult.Position + unitRay.Direction * EPSILON
                else
                    break
                end
            end

            -- Manage SelectionBoxes
            for i, lockedPart in pairs(lockedParts) do
                local selection = plug.State.SelectionBoxes[i]
                if not selection then
                    selection = createSelection()
                    table.insert(plug.State.SelectionBoxes, selection)
                end
                selection.Adornee = lockedPart
            end
            for j = #plug.State.SelectionBoxes, #lockedParts + 1, -1 do
                plug.State.SelectionBoxes[j]:Destroy()
                table.remove(plug.State.SelectionBoxes, j)
            end

            renderDebounce = false
        end)
    )
end

---@type PlugDefinition
local plugDefinition = {
    Group = "Core", ---@type string
    Name = ".Locked",
    Icon = "🔒",
    Description = description, ---@type string
    Fields = {
        {
            Name = "Use Selection",
            Type = "boolean",
            IsRequired = true,
        },
        {
            Name = "Do Highlight",
            Type = "boolean",
            IsRequired = true,
        },
        {
            Name = "Color",
            Type = "Color3",
            IsRequired = true,
        },
        {
            Name = "Thickness",
            Type = "number",
            IsRequired = true,
        },
        {
            Name = "Transparency",
            Type = "number",
            IsRequired = true,
        },
    },
    State = {
        FieldValues = {
            ["Use Selection"] = true,
            ["Do Highlight"] = true,
            ["Color"] = Color3.fromRGB(255, 136, 0),
            ["Thickness"] = 0.2,
            ["Transparency"] = 0.2,
        },
        IsRunning = false,
    },
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Toggle Running
    plug.State.IsRunning = not plug.State.IsRunning

    -- Get state
    local isRunning = plug.State.IsRunning

    -- Run Routines
    if isRunning then
        -- Init State
        plug.State.Connections = {} ---@type RBXScriptConnection[]
        plug.State.CollisionGroupId = createCollisionGroup()
        plug.State.InstanceTrackingConnections = {} ---@type table<Instance, RBXScriptConnection>
        plug.State.SelectionConnections = {} ---@type RBXScriptConnection[]
        plug.State.SelectionBoxes = {} ---@type SelectionBox[]

        trackLockedInstances(plug)
        trackMouse(plug)
    else
        stoppedRunning(plug)
    end
end

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.BindToClose = function(plug, plugin)
    -- RETURN: Already not running
    if not plug.State.IsRunning then
        return
    end
    plug.State.IsRunning = false

    stoppedRunning(plug)
end

return plugDefinition
