---
---The main component; the top of our tree!
---
---@class MainRoactComponent
---
local MainRoactComponent = {}

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local Roact = PluginFramework:Require("Roact") ---@type Roact

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
-- ...

---
---Getter
---@return RoactElement
---
function MainRoactComponent:Get()
    return Roact.createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(308, 450),
    }, {
        uIPadding = Roact.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
        }),

        container = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        }, {
            uIListLayout = Roact.createElement("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            searchHolder = Roact.createElement("Frame", {
                BackgroundColor3 = Color3.fromRGB(147, 147, 147),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, 28),
            }),

            plugHolder = Roact.createElement("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.new(1, 0, 1, -28),
            }),
        }),
    })
end

return MainRoactComponent
