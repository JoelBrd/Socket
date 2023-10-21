---
---.Locked
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ChangeHistoryService = game:GetService("ChangeHistoryService") ---@type ChangeHistoryService
local RunService = game:GetService("RunService") ---@type RunService
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local PhysicsService = game:GetService("PhysicsService") ---@type PhysicsService
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local StudioService = game:GetService("StudioService") ---@type StudioService
local CollectionService = game:GetService("CollectionService") ---@type CollectionService
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger
local Janitor = require(Utils.Janitor) ---@type Janitor
local InstanceUtil = require(Utils.InstanceUtil) ---@type InstanceUtil
local FieldsUtil = require(Utils.FieldsUtil) ---@type FieldsUtil

--------------------------------------------------
-- Constants
local COLLISION_GROUP_NAME = "SocketLocked"
local DEFAULT_COLLISION_GROUP_ID = 0
local RAYCAST_DISTANCE = 1000
local DO_TRACE = true
local RAYCAST_PARAMS = RaycastParams.new()
RAYCAST_PARAMS.CollisionGroup = COLLISION_GROUP_NAME
local EPSILON = 0.01
local TRACK_ATTRIBUTE_FORMAT = "_Socket_.Locked_%d"

--------------------------------------------------
-- Members
local trackingTag = TRACK_ATTRIBUTE_FORMAT:format(StudioService:GetUserId())

local description = "When enabled, will put all `Locked=true` instances in game.Workspace into a custom collision group. "
description = ("%s%s"):format(description, "This adds the functionality to be able to select instances through `Locked=true` instances.")
description = ("%s\n%s"):format(description, "Will only affect locked parts with the default collision group (Id=0)")
description = ("%s\n\n%s"):format(description, "Toggle Keybind: Keybind to toggle locked state of .Locked parts")
description = ("%s\n\n%s"):format(description, "Use Selection: If true, will only notice .Locked changes of selected Instances.")
description = ("%s%s"):format(
    description,
    "You may want to set this to false if you have other scripts changing .Locked value, as by default "
)
description = ("%s%s"):format(description, "these changes will not be detected (to aid performance)")

---@type MacroDefinition
local macroDefinition = {
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

local function trace(macro, ...)
    if not DO_TRACE then
        return
    end

    Logger:MacroInfo(macro, ...)
end

---@param macro MacroDefinition
local function verify(macro)
    -- Assume the worst and that we crashed. Reset any locked parts we had.
    local taggedInstances = CollectionService:GetTagged(trackingTag) ---@type BasePart[]
    for _, instance in pairs(taggedInstances) do
        instance.Locked = true
        instance.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
        CollectionService:RemoveTag(instance, trackingTag)
    end

    -- Log
    if #taggedInstances > 0 then
        Logger:MacroWarn(macro, "Looks like .Locked was running when the place was saved/closed... all fixed now!")
    end
end

---@param macro MacroDefinition
---@return number
local function setupCollisionGroup(macro)
    -- Get Collision groups
    local collisionGroups = PhysicsService:GetRegisteredCollisionGroups()
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
    local id = COLLISION_GROUP_NAME
    if not groupAlreadyCreated then
        PhysicsService:RegisterCollisionGroup(COLLISION_GROUP_NAME)
    end

    -- Define collisions
    for _, name in pairs(names) do
        PhysicsService:CollisionGroupSetCollidable(name, COLLISION_GROUP_NAME, false)
    end
    PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP_NAME, COLLISION_GROUP_NAME, true)

    -- Set id
    macro.State.CollisionGroupId = id
end

---@param macro MacroDefinition
---@param instance Instance
local function manageCollisionsForBasePart(macro, instance)
    -- RETURN: Toggled
    if macro.State.IsToggled then
        return
    end

    -- Get state
    local isRunning = macro:IsRunning()

    -- Add/Remove from our collision group
    local doAdd = false
    local doRemove = false
    if isRunning then
        doAdd = instance:IsDescendantOf(game.Workspace) and instance.Locked and instance.CollisionGroupId == DEFAULT_COLLISION_GROUP_ID
        doRemove = ((not instance:IsDescendantOf(game.Workspace) and instance.Locked) or not instance.Locked)
            and instance.CollisionGroupId == macro.State.CollisionGroupId
    else
        doRemove = instance.CollisionGroupId == macro.State.CollisionGroupId
    end

    if doAdd then
        instance.CollisionGroupId = macro.State.CollisionGroupId
        CollectionService:AddTag(instance, trackingTag)
        table.insert(macro.State.LockedParts, instance)
        trace(macro, ("Added %s"):format(instance:GetFullName()))
    elseif doRemove then
        instance.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
        CollectionService:RemoveTag(instance, trackingTag)
        local index = table.find(macro.State.LockedParts, instance)
        if index then
            instance.Locked = true
            table.remove(macro.State.LockedParts, index)
        end
        trace(macro, ("Removed %s"):format(instance:GetFullName()))
    end
end

---Runs routines to keep track of locked instances and bring them into the scope of the macro
---@param macro MacroDefinition
local function trackLockedInstances(macro)
    -- Read/Init state
    local doUseSelection = macro:GetFieldValue("Use Selection")
    if doUseSelection and not macro.State.SelectionJanitor then
        -- Create Janitor
        macro.State.SelectionJanitor = Janitor.new() ---@type Janitor
        macro.RunJanitor:Add(macro.State.SelectionJanitor, "Cleanup")
    end
    macro.State.LockedParts = {}

    ---Tracks the .Locked property of this instance changing + manages it
    ---@param instance Instance
    ---@return RBXScriptConnection
    local function trackLockedProperty(instance)
        return instance:GetPropertyChangedSignal("Locked"):Connect(function()
            manageCollisionsForBasePart(macro, instance)
        end)
    end

    ---@param instance Instance
    local function inspectInstance(instance)
        -- RETURN: Not a BasePart
        if not instance:IsA("BasePart") then
            return
        end

        manageCollisionsForBasePart(macro, instance)

        local connection = trackLockedProperty(instance)
        if doUseSelection then
            macro.State.SelectionJanitor:Add(connection)
        else
            macro.RunJanitor:Add(connection)
        end
    end

    ---@param instances Instance[]
    local function selectionChanged(instances)
        macro.State.SelectionJanitor:Cleanup()

        for _, instance in pairs(instances) do
            inspectInstance(instance)
        end
    end

    macro.RunJanitor:Add(game.Workspace.DescendantAdded:Connect(function(descendant)
        inspectInstance(descendant)
    end))

    macro.RunJanitor:Add(game.Workspace.DescendantRemoving:Connect(function(descendant)
        inspectInstance(descendant)
    end))

    -- Setup listening to .Locked changes
    if doUseSelection then
        macro.RunJanitor:Add(Selection.SelectionChanged:Connect(function()
            selectionChanged(Selection:Get())
        end))
    end

    -- Loop through current descendants
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        inspectInstance(descendant)
    end
end

---Manages the highlighlight of locked parts
---@param macro MacroDefinition
local function manageHighlighting(macro)
    -- Read state
    local doHighlight = macro:GetFieldValue("Do Highlight")
    local highlightColor = macro:GetFieldValue("Color")
    local highlightThickness = macro:GetFieldValue("Thickness")
    local highlightTransparency = macro:GetFieldValue("Transparency")
    if not doHighlight then
        return
    end

    macro.State.SelectionBoxes = {}

    ---@return SelectionBox
    local function createSelection()
        local selectionBox = Instance.new("SelectionBox") ---@type SelectionBox
        selectionBox.Color3 = highlightColor
        selectionBox.SurfaceColor3 = highlightColor
        selectionBox.LineThickness = highlightThickness
        selectionBox.Transparency = highlightTransparency
        InstanceUtil:IntroduceInstance(selectionBox)

        return selectionBox
    end

    local renderDebounce = false
    macro.RunJanitor:Add(RunService.RenderStepped:Connect(function()
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
        local isToggled = macro.State.IsToggled
        if isToggled then
            lockedParts = macro.State.LockedParts
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
            local selection = macro.State.SelectionBoxes[i]
            if not selection then
                selection = createSelection()
                table.insert(macro.State.SelectionBoxes, selection)
            end
            selection.Adornee = lockedPart
            selection.SurfaceTransparency = isToggled and 0.7 or 1
        end
        for j = #macro.State.SelectionBoxes, #lockedParts + 1, -1 do
            InstanceUtil:ClearInstance(macro.State.SelectionBoxes[j], true)
            table.remove(macro.State.SelectionBoxes, j)
        end

        renderDebounce = false
    end))
end

---@param macro MacroDefinition
local function toggle(macro)
    if not macro.State.IsToggled then
        macro.State.IsToggled = true
        for _, lockedPart in pairs(macro.State.LockedParts) do
            lockedPart.Locked = false
            lockedPart.CollisionGroupId = DEFAULT_COLLISION_GROUP_ID
        end
    else
        for _, lockedPart in pairs(macro.State.LockedParts) do
            lockedPart.Locked = true
            lockedPart.CollisionGroupId = macro.State.CollisionGroupId
        end
        macro.State.IsToggled = false
    end

    ChangeHistoryService:SetWaypoint("Toggled Locked")
    trace(macro, ("Toggled Locked Parts: %s"):format(tostring(macro.State.IsToggled)))
end

---@param macro MacroDefinition
local function listenForToggleInput(macro)
    -- Read state
    local toggleKeybind = macro:GetFieldValue("Toggle Keybind")

    macro.RunJanitor:Add(UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
        -- RETURN: gameProcessedEvent
        if gameProcessedEvent then
            return
        end

        local isToggleKeybind = inputObject.KeyCode.Name == toggleKeybind
        if isToggleKeybind then
            toggle(macro)
        end
    end))
end

---@param macro MacroDefinition
local function stoppedRunning(macro)
    if macro.State.IsToggled then
        toggle(macro)
    end

    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        if descendant:IsA("BasePart") then
            manageCollisionsForBasePart(macro, descendant)
        end
    end

    for _, selectionBox in pairs(macro.State.SelectionBoxes) do
        InstanceUtil:ClearInstance(selectionBox, true)
    end
    macro.State.SelectionBoxes = nil
end

--================================================================================================================================================
--===
--================================================================================================================================================

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.BindToOpen = function(macro, plugin)
    -- Ensure nothing bad was left from .Locked in a previous session
    verify(macro)
end

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.Function = function(macro, plugin)
    -- Toggle Running
    macro:ToggleIsRunning()

    -- Get state
    local isRunning = macro:IsRunning()

    -- Run Routines
    if isRunning then
        setupCollisionGroup(macro)
        trackLockedInstances(macro)
        manageHighlighting(macro)
        listenForToggleInput(macro)
    else
        stoppedRunning(macro)
    end
end

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.BindToClose = function(macro, plugin)
    if macro:IsRunning() then
        macro:ToggleIsRunning()
        stoppedRunning(macro)
    end
end

return macroDefinition
