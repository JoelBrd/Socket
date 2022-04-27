---
---Contains a definition for a default plug definition
---
---@class PlugDefinitions
---
local PlugDefinitions = {}

--------------------------------------------------
-- Types

---@class PlugField
---@field Type PlugFieldType
---@field Name string
---@field Value any

---@class PlugDefinition
---@field Group string
---@field Name string
---@field Icon string
---@field Description string
---@field State table
---@field Keybind Enum.KeyCode[]
---@field Fields PlugField[]
---@field Function fun(self:PlugDefinition)

--------------------------------------------------
-- Dependencies
local PluginFramework = require(script:FindFirstAncestor("PluginFramework")) ---@type Framework
local ImageUtil ---@type ImageUtil
local Logger ---@type Logger

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members
local plugDefinitionTemplate ---@type PlugDefinition

---
---Returns a boilerplate PlugDefinition.
---Useful to sync an existing PlugDefiniton to ensure all necessary fields exist
---@return PlugDefinition
---
function PlugDefinitions:GetTemplate()
    return plugDefinitionTemplate
end

---@private
function PlugDefinitions:FrameworkInit()
    ImageUtil = PluginFramework:Require("ImageUtil")
    Logger = PluginFramework:Require("Logger")
end

---@private
function PlugDefinitions:FrameworkStart()
    ---@param self PlugDefinition
    local function templateFunction(self)
        Logger:Plug(self, ("Ran %s"):format(self.Name))
    end

    plugDefinitionTemplate = {
        Group = "No Group",
        Name = "Plug",
        Description = "A Template Plug",
        Icon = ImageUtil.Images.Icon.Socket,
        State = {},
        Keybind = {},
        Fields = {},
        Function = templateFunction,
    } ---@type PlugDefinition
end

return PlugDefinitions
