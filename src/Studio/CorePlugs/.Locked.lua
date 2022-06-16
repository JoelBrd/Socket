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
local Janitor = require(Utils.Janitor) ---@type Janitor
local TeamCreateUtil = require(Utils.TeamCreateUtil) ---@type TeamCreateUtil
local FieldsUtil = require(Utils.FieldsUtil) ---@type FieldsUtil

--------------------------------------------------
-- Constants
local COLLISION_GROUP_NAME = "SocketLocked"
local DEFAULT_COLLISION_GROUP_ID = 0
local RAYCAST_DISTANCE = 1000
local DO_TRACE = false
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.CollisionGroup = COLLISION_GROUP_NAME
local EPSILON = 0.01

--------------------------------------------------
-- Members
local description = "When enabled, will put all `Locked=true` instances in game.Workspace into a custom collision group. "
description = ("%s%s"):format(description, "This adds the functionality to be able to select instances through `Locked=true` instances.")
description = ("%s\n%s"):format(description, "Will only affect locked parts with the default collision group (Id=0)")
description = ("%s\n%s"):format(description, "Toggle Keybind: Keybind to toggle locked state of .Locked parts")
description = ("%s\n%s"):format(description, "Use Selection: If true, will only notice .Locked changes of selected Instances.")
description = ("%s%s"):format(
    description,
    "You may want to set this to false if you have other scripts changing .Locked value, as by default"
)
description = ("%s%s"):format(description, "these changes will not be detected (to aid performance)")
description = ("%s\n%s"):format(description, "Do Highlight: If true, will highlight locked parts that would be otherwise selected.")

---@type PlugDefinition
local plugDefinition = {
    Group = "Core", ---@type string
    Name = ".Locked",
    Icon = "🔒",
    Description = description, ---@type string
    Fields = {
        {
            Name = "Toggle Keybind",
            Type = "string",
            IsRequired = true,
            Validator = FieldsUtil:GetKeybindValidator(),
        },
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
            ["Toggle Keybind"] = "LeftAlt",
            ["Use Selection"] = true,
            ["Do Highlight"] = true,
            ["Color"] = Color3.fromRGB(255, 136, 0),
            ["Thickness"] = 0.1,
            ["Transparency"] = 0.2,
        },
        IsRunning = false,
    },
}

--================================================================================================================================================
--===
--================================================================================================================================================

local function trace(plug, ...)
    if not DO_TRACE then
        return
    end

    Logger:PlugInfo(plug, ...)
end

---@param plug PlugDefinition
---@return number
local function setupCollisionGroup(plug)
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

    -- Set id
    plug.State.CollisionGroupId = id
end

---@param plug PlugDefinition
---@param instance Instance
local function manageCollisionsForBasePart(plug, instance)
    -- RETURN: Toggled
    if plug.State.IsToggled then
        return
    end

    -- Get state
    local isRunning = plug.State.IsRunning

    -- Add/Remove from our collision group
    local doAdd = false
    local doRemove = false
    if isRunning then
        doAdd = instance:IsDescendantOf(game.Workspace) and instance.Locked and instance.CollisionGroupId == DEFAULT_COLLISION_GROUP_ID
        doRemove = ((not instance:IsDescendantOf(game.Workspace) and instance.Locked) or not instance.Locked)
            and instance.CollisionGroupId == plug.State.CollisionGroupId
    else
        doRemove = instance.CollisionGroupId == plug.State.CollisionGroupId
    end

    if doAdd then
        instance.CollisionGroupId = plug.State.CollisionGroupId
        table.insert(plug.State.LockedParts, instance)
        trace(plug, ("Added %s"):format(instance:GetFullName()))
    elseif doRemove then
        instance.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
        local index = table.find(plug.State.LockedParts, instance)
        if index then
            table.remove(plug.State.LockedParts, index)
        end
        trace(plug, ("Removed %s"):format(instance:GetFullName()))
    end
end

---Runs routines to keep track of locked instances and bring them into the scope of the plug
---@param plug PlugDefinition
local function trackLockedInstances(plug)
    -- Read/Init state
    local doUseSelection = plug:GetFieldValue("Use Selection")
    if doUseSelection and not plug.State.SelectionJanitor then
        -- Create Janitor
        plug.State.SelectionJanitor = Janitor.new() ---@type Janitor
        plug.RunJanitor:Add(plug.State.SelectionJanitor, "Cleanup")
    end
    plug.State.LockedParts = {}

    ---Tracks the .Locked property of this instance changing + manages it
    ---@param instance Instance
    ---@return RBXScriptConnection
    local function trackLockedProperty(instance)
        return instance:GetPropertyChangedSignal("Locked"):Connect(function()
            manageCollisionsForBasePart(plug, instance)
        end)
    end

    ---@param instance Instance
    local function inspectInstance(instance)
        -- RETURN: Not a BasePart
        if not instance:IsA("BasePart") then
            return
        end

        manageCollisionsForBasePart(plug, instance)

        local connection = trackLockedProperty(instance)
        if doUseSelection then
            plug.State.SelectionJanitor:Add(connection)
        else
            plug.RunJanitor:Add(connection)
        end
    end

    ---@param instances Instance[]
    local function selectionChanged(instances)
        plug.State.SelectionJanitor:Cleanup()

        for _, instance in pairs(instances) do
            inspectInstance(instance)
        end
    end

    plug.RunJanitor:Add(game.Workspace.DescendantAdded:Connect(function(descendant)
        inspectInstance(descendant)
    end))

    plug.RunJanitor:Add(game.Workspace.DescendantRemoving:Connect(function(descendant)
        inspectInstance(descendant)
    end))

    -- Setup listening to .Locked changes
    if doUseSelection then
        plug.RunJanitor:Add(Selection.SelectionChanged:Connect(function()
            selectionChanged(Selection:Get())
        end))
    end

    -- Loop through current descendants
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        inspectInstance(descendant)
    end
end

---Manages the highlighlight of locked parts
---@param plug PlugDefinition
local function manageHighlighting(plug)
    -- Read state
    local doHighlight = plug:GetFieldValue("Do Highlight")
    local highlightColor = plug:GetFieldValue("Color")
    local highlightThickness = plug:GetFieldValue("Thickness")
    local highlightTransparency = plug:GetFieldValue("Transparency")
    if not doHighlight then
        return
    end

    plug.State.SelectionBoxes = {}

    ---@return SelectionBox
    local function createSelection()
        local selectionBox = Instance.new("SelectionBox") ---@type SelectionBox
        selectionBox.Color3 = highlightColor
        selectionBox.SurfaceColor3 = highlightColor
        selectionBox.LineThickness = highlightThickness
        selectionBox.Transparency = highlightTransparency
        TeamCreateUtil:IntroduceInstance(selectionBox)

        return selectionBox
    end

    local renderDebounce = false
    plug.RunJanitor:Add(RunService.RenderStepped:Connect(function()
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
        local isToggled = plug.State.IsToggled
        if isToggled then
            lockedParts = plug.State.LockedParts
        else
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
        end

        -- Manage SelectionBoxes
        for i, lockedPart in pairs(lockedParts) do
            local selection = plug.State.SelectionBoxes[i]
            if not selection then
                selection = createSelection()
                table.insert(plug.State.SelectionBoxes, selection)
            end
            selection.Adornee = lockedPart
            selection.SurfaceTransparency = isToggled and 0.7 or 1
        end
        for j = #plug.State.SelectionBoxes, #lockedParts + 1, -1 do
            TeamCreateUtil:ClearInstance(plug.State.SelectionBoxes[j], true)
            table.remove(plug.State.SelectionBoxes, j)
        end

        renderDebounce = false
    end))
end

---@param plug PlugDefinition
local function listenForToggleInput(plug)
    -- Read state
    local toggleKeybind = plug:GetFieldValue("Toggle Keybind")

    local function toggle()
        if not plug.State.IsToggled then
            plug.State.IsToggled = true
            for _, lockedPart in pairs(plug.State.LockedParts) do
                lockedPart.Locked = false
                lockedPart.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
            end
        else
            for _, lockedPart in pairs(plug.State.LockedParts) do
                lockedPart.Locked = true
                lockedPart.CollisionGroupId = plug.State.CollisionGroupId
            end
            plug.State.IsToggled = false
        end

        Logger:PlugInfo(plug, ("Toggled Locked Parts: %s"):format(tostring(plug.State.IsToggled)))
    end

    plug.RunJanitor:Add(UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
        -- RETURN: gameProcessedEvent
        if gameProcessedEvent then
            return
        end

        local isToggleKeybind = inputObject.KeyCode.Name == toggleKeybind
        if isToggleKeybind then
            toggle()
        end
    end))
end

---@param plug PlugDefinition
local function stoppedRunning(plug)
    plug.State.IsRunning = false

    if plug.State.IsToggled then
        for _, lockedPart in pairs(plug.State.LockedParts) do
            lockedPart.Locked = true
            lockedPart.CollisionGroupId = plug.State.CollisionGroupId
        end
        plug.State.IsToggled = false
    end

    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        if descendant:IsA("BasePart") then
            manageCollisionsForBasePart(plug, descendant)
        end
    end

    for _, selectionBox in pairs(plug.State.SelectionBoxes) do
        TeamCreateUtil:ClearInstance(selectionBox, true)
    end
    plug.State.SelectionBoxes = nil
end

--================================================================================================================================================
--===
--================================================================================================================================================

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    -- Toggle Running
    plug:ToggleIsRunning()

    -- Get state
    local isRunning = plug.State.IsRunning

    -- Run Routines
    if isRunning then
        setupCollisionGroup(plug)
        trackLockedInstances(plug)
        manageHighlighting(plug)
        listenForToggleInput(plug)
    else
        stoppedRunning(plug)
    end
end

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.BindToClose = function(plug, plugin)
    if plug.State.IsRunning then
        plug:ToggleIsRunning()
        stoppedRunning(plug)
    end
end

return plugDefinition
