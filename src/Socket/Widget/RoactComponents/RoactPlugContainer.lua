---
--TODO description
---
---@class RoactPlugContainer
---
local RoactPlugContainer = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact ---@type Roact
local RoactRodux ---@type RoactRodux

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local PlugContainer ---@type RoactComponent

---
---@return RoactElement
---
function RoactPlugContainer:Get()
    return Roact.createElement(PlugContainer)
end

---
---@private
---
function RoactPlugContainer:Create()
    --------------------------------------------------
    -- Create lines

    ---@param props table
    ---@return RoactFragment
    local function getLinesFragment(props)
        return Roact.createFragment({
            Line1 = Roact.createElement("TextLabel", {
                Text = "Line1",
            }),
        })
    end

    local function mapStateToProps(state, props)
        return {}
    end

    local function mapDispatchToProps(dispatch)
        return {}
    end

    getLinesFragment = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(getLinesFragment)

    --------------------------------------------------
    -- Create PlugContainer
    PlugContainer = Roact.Component:extend("PlugContainer")

    function PlugContainer:render()
        return Roact.createElement("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(0, 0, 1, 0),
            ScrollBarThickness = 6,
        }, {
            UIPadding = Roact.createElement("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 4),
            }),
            UIListLayout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            Lines = getLinesFragment(self.props),
        })
    end
end

---
---@private
---
---Asynchronously called with all other FrameworkInit()
---
function RoactPlugContainer:FrameworkInit()
    Roact = PluginFramework:Require("Roact")
    RoactRodux = PluginFramework:Require("RoactRodux")
end

---
---@private
---
---Synchronously called, one after the other, with all other FrameworkStart()
---
function RoactPlugContainer:FrameworkStart()
    RoactPlugContainer:Create()
end

return RoactPlugContainer
