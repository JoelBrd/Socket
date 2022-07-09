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
local InstanceUtil = require(Utils.InstanceUtil) ---@type InstanceUtil
local RaycastUtil = require(Utils.RaycastUtil) ---@type RaycastUtil

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

---@type MacroDefinition
local macroDefinition = {
    Group = "Core", ---@type string
    Name = "Dot To Dot",
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
    }, ---@type MacroField[]
    State = {
        FieldValues = {
            ["Confirm Keybind"] = "Y",
            ["Place Keybind"] = "T",
            ["Part Size"] = 0.2,
            ["Part Color"] = Color3.fromRGB(255, 255, 255),
            ["Recurse"] = true,
        },
        IsRunning = false,
    }, ---@type MacroState
}

--================================================================================================================================================
--===
--================================================================================================================================================

---@param macro MacroDefinition
local function init(macro)
    -- Create node directory
    local nodeDirectory = Instance.new("Folder") ---@type Folder
    nodeDirectory.Name = "DrawLinesNodes"
    InstanceUtil:IntroduceInstance(nodeDirectory)
    macro.State.NodeDirectory = nodeDirectory
end

---@param macro MacroDefinition
local function placeNode(macro)
    -- Get position to place
    local raycastResult = RaycastUtil:RaycastMouse(RAYCAST_LENGTH, nil, true)
    if not raycastResult then
        return
    end
    local position = raycastResult.Position

    -- Create node
    local node = Instance.new("Part") ---@type Part
    node.Size = Vector3.new(1, 1, 1)
    node.Shape = Enum.PartType.Ball
    node.Name = ("%d"):format(#macro.State.NodeDirectory:GetChildren() + 1)
    node.Position = position
    node.Parent = macro.State.NodeDirectory

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

    macro.RunJanitor:Add(node)
end

---@param macro MacroDefinition
local function drawLines(macro)
    -- Read state
    local partSize = macro.State.FieldValues["Part Size"]
    local partColor = macro.State.FieldValues["Part Color"]
    local doRecurse = macro.State.FieldValues.Recurse
    local nodeDirectory = macro.State.NodeDirectory

    ---@param pos0 Vector3
    ---@param pos1 Vector3
    ---@return Part
    local function createLine(pos0, pos1)
        -- Create part
        local part = Instance.new("Part") ---@type Part
        part.Name = "Part"
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
        local totalNodes = #nodes
        for i = 1, totalNodes do
            local node0 = nodes[i]
            for j = i + 1, totalNodes do
                local node1 = nodes[j]
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

---@param macro MacroDefinition
local function stopRunning(macro)
    InstanceUtil:ClearInstance(macro.State.NodeDirectory, true)
end

--================================================================================================================================================
--===
--================================================================================================================================================

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.Function = function(macro, plugin)
    macro:ToggleIsRunning()

    -- Read state
    local isRunning = macro:IsRunning()
    local confirmKeybind = macro.State.FieldValues["Confirm Keybind"]
    local placeKeybind = macro.State.FieldValues["Place Keybind"]

    if isRunning then
        init(macro)
        ChangeHistoryService:SetWaypoint("DrawLines Init")

        -- Listen to User Input
        macro.RunJanitor:Add(UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
            -- RETURN: gameProcessedEvent
            if gameProcessedEvent then
                return
            end

            -- Place
            local isPlaceKeybind = inputObject.KeyCode.Name == placeKeybind
            if isPlaceKeybind then
                placeNode(macro)
                ChangeHistoryService:SetWaypoint("DrawLines Node 1")
                return
            end

            -- Place
            local isConfirmKeybind = inputObject.KeyCode.Name == confirmKeybind
            if isConfirmKeybind then
                drawLines(macro)
                ChangeHistoryService:SetWaypoint("DrawLines Lines 1")
                return
            end
        end))
    else
        stopRunning(macro)
    end
end

---@param macro MacroDefinition
---@param plugin Plugin
macroDefinition.BindToClose = function(macro, plugin)
    if macro:IsRunning() then
        macro:ToggleIsRunning()
        stopRunning(macro)
    end
end

return macroDefinition
