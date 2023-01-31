---
---Contains Constants relating to plugins.
---
---@class MacroConstants
---
local MacroConstants = {}

--------------------------------------------------
-- Types

---@class MacroDefinition
---@field Group string
---@field GroupColor Color3
---@field GroupIcon string
---@field GroupIconColor Color3
---@field Name string
---@field NameColor Color3
---@field Icon string
---@field IconColor Color3
---@field Description string
---@field LayoutOrder number
---@field State MacroState
---@field EnableAutomaticUndo boolean
---@field IgnoreGameProcessedKeybinds boolean
---@field AutoRun boolean
---@field Keybind Enum.KeyCode[]
---@field Fields MacroField[]
---@field FieldChanged BindableEvent Fired with (fieldName, fieldValue)
---@field RunJanitor Janitor
---@field ToggleIsRunning fun(macro:MacroDefinition)
---@field IsRunning fun(macro:MacroDefinition):boolean
---@field IsLocalMacro boolean
---@field GetFieldValue fun(macro:MacroDefinition, fieldName:string)
---@field Function fun(macro:MacroDefinition)
---@field BindToClose fun(macro:MacroDefinition) Called when plugin is closed, or macro is removed from state
---@field BindToOpen fun(macro:MacroDefinition) Called when plugin is started
---@field Disabled boolean If true, will not show this Macro on the widget.
---@field _BindToClose fun(macro:MacroDefinition) Wraps BindToClose plus some internal stuff (e.g., IsRunning=false)
---@field _script ModuleScript
---@field _isBroken boolean

---@class MacroState
---@field FieldValues table<MacroField, any>
---@field IsRunning boolean|nil
---@field _Server MacroState
---@field _Client MacroState

---@class MacroField
---@field Type MacroFieldType
---@field Name string
---@field IsRequired boolean
---@field Validator fun(value:any):string

---@class MacroFieldType
---@field Name string
---@field Icon string
---@field Validate fun(value:string):any|nil
---@field ToString fun(value:any):string

--------------------------------------------------
-- Constants
local PATTERN_3_VALUES = "(.+),(.+),(.+)"

---@param number number
---@return string
local function commaValue(number)
    if number == math.huge then
        return "Infinite"
    end

    -- credit http://richard.warburton.it
    local left, num, right = string.match(tostring(number), "^([^%d]*%d)(%d*)(.-)$")
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local function getNumbersFromPattern3(str: string)
    local str1, str2, str3 = str:match(PATTERN_3_VALUES)
    if str1 and str2 and str3 then
        local num1, num2, num3 = tonumber(str1), tonumber(str2), tonumber(str3)
        if num1 and num2 and num3 then
            return num1, num2, num3
        end
    end

    return nil
end

MacroConstants.FieldType = {
    number = {
        Name = "number",
        Icon = "#️⃣",
        Validate = function(value)
            return tonumber(value)
        end,
        ToString = function(value)
            return commaValue(value)
        end,
    },
    boolean = {
        Name = "boolean",
        Icon = "🅱️",
        Validate = function(value)
            value = tostring(value)

            if string.find("TRUE", value:upper()) then
                return true
            end

            if string.find("FALSE", value:upper()) then
                return false
            end
        end,
        ToString = function(value)
            return tostring(value)
        end,
    },
    string = {
        Name = "string",
        Icon = "📝",
        Validate = function(value)
            return tostring(value)
        end,
        ToString = function(value)
            return value
        end,
    },
    Color3 = {
        Name = "Color3",
        Icon = "🌈",
        Validate = function(value)
            if typeof(value) == "Color3" then
                return value
            end
            value = tostring(value)

            local r, g, b = getNumbersFromPattern3(value)
            if r and g and b then
                return Color3.fromRGB(
                    math.clamp(math.round(r), 0, 255),
                    math.clamp(math.round(b), 0, 255),
                    math.clamp(math.round(b), 0, 255)
                )
            end
        end,
        ToString = function(value)
            return ("%d, %d, %d"):format(value.r * 255, value.g * 255, value.b * 255)
        end,
    },
    Vector3 = {
        Name = "Vector3",
        Icon = "↗️",
        Validate = function(value)
            if typeof(value) == "Vector3" then
                return value
            end
            value = tostring(value)

            local x, y, z = getNumbersFromPattern3(value)
            if x and y and z then
                return Vector3.new(x, y, z)
            end
        end,
        ToString = function(value)
            local x: number = value.X
            local y: number = value.Y
            local z: number = value.Z

            local strX = if math.round(x) == x then ("%d"):format(x) else ("%.3f"):format(x)
            local strY = if math.round(y) == y then ("%d"):format(y) else ("%.3f"):format(y)
            local strZ = if math.round(z) == z then ("%d"):format(z) else ("%.3f"):format(z)

            return ("%s, %s, %s"):format(strX, strY, strZ)
        end,
    },
} ---@type table<string, MacroFieldType>

MacroConstants.MacKeyCodes = {
    WindowsToMac = {
        [Enum.KeyCode.LeftControl] = Enum.KeyCode.LeftMeta,
        [Enum.KeyCode.RightControl] = Enum.KeyCode.RightMeta,
    },
    MacToWindows = {
        [Enum.KeyCode.LeftMeta] = Enum.KeyCode.LeftControl,
        [Enum.KeyCode.RightMeta] = Enum.KeyCode.RightControl,
    },
}

return MacroConstants
