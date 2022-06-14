---
---DrawLines
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ChangeHistoryService = game:GetService("ChangeHistoryService") ---@type ChangeHistoryService
local UserInputService = game:GetService("UserInputService") ---@type UserInputService
local Selection = game:GetService("Selection") ---@type Selection
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger
local Janitor = require(Utils.Janitor) ---@type Janitor
local TeamCreateUtil = require(Utils.TeamCreateUtil) ---@type TeamCreateUtil
local CameraUtil = require(Utils.CameraUtil) ---@type CameraUtil

--------------------------------------------------
-- Constants
local RAYCAST_LENGTH = 1000

--------------------------------------------------
-- Members
local description = "Will draw lines between the defined points.\n"
description = ("%s\n%s"):format(description, "Place Keybind: Keypress to define a point")
description = ("%s\n%s"):format(description, "Part Size: The width of the part line created")
description = ("%s\n%s"):format(
    description,
    "Recurse: If true, draws lines between every point. If false, draws points between each point in the order they were placed"
)

---@param keyCodeName string
---@return boolean, string
local function keybindValidator(keyCodeName)
    local isValidKeyCodeName = Enum.KeyCode[keyCodeName] and true or false
    if not isValidKeyCodeName then
        return ("Invalid KeyCode %q"):format(keyCodeName)
    end
end

---@type PlugDefinition
local plugDefinition = {
    Group = "Core", ---@type string
    Name = "Draw Lines",
    Icon = "🌠",
    Description = description, ---@type string
    Fields = {
        {
            Name = "Confirm Keybind",
            Type = "string",
            IsRequired = true,
            Validator = keybindValidator,
        },
        {
            Name = "Place Keybind",
            Type = "string",
            IsRequired = true,
            Validator = keybindValidator,
        },
        {
            Name = "Part Size",
            Type = "number",
            IsRequired = true,
        },
        {
            Name = "Part Color",
            Type = "Color3",
            IsRequired = true,
        },
        {
            Name = "Recurse",
            Type = "boolean",
            IsRequired = true,
        },
    }, ---@type PlugField[]
    State = {
        FieldValues = {
            ["Confirm Keybind"] = "Y",
            ["Place Keybind"] = "T",
            ["Part Size"] = 0.2,
            ["Part Color"] = Color3.fromRGB(255, 255, 255),
            ["Recurse"] = true,
        },
        IsRunning = false,
    }, ---@type PlugState
}

--================================================================================================================================================
--===
--================================================================================================================================================

---@param plug PlugDefinition
local function init(plug)
    -- Create node directory
    local nodeDirectory = Instance.new("Folder") ---@type Folder
    nodeDirectory.Name = "DrawLinesNodes"
    TeamCreateUtil:IntroduceInstance(nodeDirectory)
    plug.State.NodeDirectory = nodeDirectory
end

---@param plug PlugDefinition
local function placeNode(plug)
    -- Get position to place
    local raycastResult = CameraUtil:RaycastMouse(RAYCAST_LENGTH)
    if not raycastResult then
        return
    end
    local position = raycastResult.Position

    -- Create node
    local node = Instance.new("Part") ---@type Part
    node.Size = Vector3.new(1, 1, 1)
    node.Shape = Enum.PartType.Ball
    node.Name = ("%d"):format(#plug.State.NodeDirectory:GetChildren() + 1)
    node.Position = position
    node.Parent = plug.State.NodeDirectory

    local highlight = Instance.new("Highlight") ---@type Highlight
    highlight.Adornee = node
    highlight.FillTransparency = 0.3
    highlight.Parent = node

    local billboardGui = Instance.new("BillboardGui") ---@type BillboardGui
    billboardGui.Size = UDim2.new(1, 25, 1, 25)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = node

    local textLabel = Instance.new("TextLabel") ---@type TextLabel
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Text = node.Name
    textLabel.Parent = billboardGui

    local uiStroke = Instance.new("UIStroke") ---@type UIStroke
    uiStroke.Thickness = 3
    uiStroke.Parent = textLabel

    plug.RunJanitor:Add(node)
end

---@param plug PlugDefinition
local function drawLines(plug)
    -- Read state
    local partSize = plug.State.FieldValues["Part Size"]
    local partColor = plug.State.FieldValues["Part Color"]
    local doRecurse = plug.State.FieldValues.Recurse
    local nodeDirectory = plug.State.NodeDirectory

    ---@param pos0 Vector3
    ---@param pos1 Vector3
    ---@return Part
    local function createLine(pos0, pos1)
        -- Create part
        local part = Instance.new("Part") ---@type Part
        part.Name = "RopePart"
        part.Anchored = true
        part.CanCollide = false
        part.Color = partColor

        -- Calculations
        local vector01 = pos1 - pos0

        part.CFrame = CFrame.new(pos0, pos1) -- Easy way to get the orientation we need
        part.Position = pos0 + vector01 / 2
        part.Size = Vector3.new(partSize, partSize, vector01.Magnitude)

        return part
    end

    -- Get nodes
    local nodes = nodeDirectory:GetChildren()
    local lines = {}

    -- Create lines
    if doRecurse then
        for _, node0 in pairs(nodes) do
            for _, node1 in pairs(nodes) do
                if node0 ~= node1 then
                    table.insert(lines, createLine(node0.Position, node1.Position))
                end
            end
        end
    else
        for i = 1, #nodes - 1 do
            local node0 = nodes[i]
            local node1 = nodes[i + 1]
            table.insert(lines, createLine(node0.Position, node1.Position))
        end
    end

    -- Finalise
    local linesFolder = Instance.new("Folder") ---@type Folder
    linesFolder.Name = "Lines"
    linesFolder.Parent = game.Workspace
    for _, line in pairs(lines) do
        line.Parent = linesFolder
    end
    for _, node in pairs(nodes) do
        node.Parent = nil
    end
end

---@param plug PlugDefinition
local function stopRunning(plug)
    TeamCreateUtil:ClearInstance(plug.State.NodeDirectory, true)
end

--================================================================================================================================================
--===
--================================================================================================================================================

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    plug:ToggleIsRunning()

    -- Read state
    local isRunning = plug.State.IsRunning
    local confirmKeybind = plug.State.FieldValues["Confirm Keybind"]
    local placeKeybind = plug.State.FieldValues["Place Keybind"]

    if isRunning then
        init(plug)
        ChangeHistoryService:SetWaypoint("DrawLines Init")

        -- Listen to User Input
        plug.RunJanitor:Add(UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
            -- RETURN: gameProcessedEvent
            if gameProcessedEvent then
                return
            end

            -- Place
            local isPlaceKeybind = inputObject.KeyCode.Name == placeKeybind
            if isPlaceKeybind then
                placeNode(plug)
                ChangeHistoryService:SetWaypoint("DrawLines Node 1")
                return
            end

            -- Place
            local isConfirmKeybind = inputObject.KeyCode.Name == confirmKeybind
            if isConfirmKeybind then
                drawLines(plug)
                ChangeHistoryService:SetWaypoint("DrawLines Lines 1")
                return
            end
        end))
    else
        stopRunning(plug)
    end
end

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.BindToClose = function(plug, plugin)
    if plug.State.IsRunning then
        plug:ToggleIsRunning()
        stopRunning(plug)
    end
end

return plugDefinition
