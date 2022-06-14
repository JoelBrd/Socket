---
---Functions to nicely log things to the console under the umbrella of Socket
---
---@class Logger
---
local Logger = {}

--------------------------------------------------
-- Dependencies
-- ...

--------------------------------------------------
-- Types

---@class LoggerLevel
---@field Name string
---@field Enabled boolean
---@field Tag string

--------------------------------------------------
-- Constants

---
---Pattern that extracts the script's name and the current line from a stacktrace.
---
--- - [_%w]+ = Represents all alphanumeric characters, plus underscores. This captures the script's name.
--- - %d+ = Represents all digits. This captures the line of code being executed.
---
---Line where the source can be found in tracebacks.
---
---More information at https://www.lua.org/manual/5.3/manual.html#6.4.1
---
local TRACEBACK_PATTERN = "([_%w]+:%d+)"
local TRACEBACK_SOURCE_LINE = 4

local LEVEL = {
    ERROR = {
        Name = "ERROR",
        Enabled = true,
        Tag = "❌",
    },
    WARN = {
        Name = "WARN",
        Enabled = true,
        Tag = "⚠️",
    },
    INFO = {
        Name = "INFO",
        Enabled = true,
        Tag = "🔹",
    },
    TRACE = {
        Name = "TRACE",
        Enabled = false,
        Tag = "📌",
    },
} ---@type table<string, LoggerLevel>
Logger.Level = LEVEL

--------------------------------------------------
-- Members

---
---Returns the name of the source being executed and its line of code as well.
---@return string
---
local function getSourceName()
    local tracebackLines = debug.traceback():split("\n")
    if tracebackLines and #tracebackLines >= TRACEBACK_SOURCE_LINE then
        local sourceLine = tracebackLines[TRACEBACK_SOURCE_LINE]
        if sourceLine then
            for trace in sourceLine:gmatch(TRACEBACK_PATTERN) do
                return trace
            end
        end
    end
    return "Unknown Source"
end

---
---Concatenates variables into a string. All vararg values are parsed as string before being concatenated.
---
---@return string
---
local function concatVars(...)
    -- Convert to strings
    local stringVars = {}
    for _, var in pairs({ ... }) do
        table.insert(stringVars, tostring(var))
    end

    return table.concat(stringVars, " ")
end

---@param loggerLevel LoggerLevel
local function writeSourceOutput(loggerLevel, ...)
    return ("🔌 %s |%s| %s"):format(loggerLevel.Tag, getSourceName(), concatVars(...))
end

---
---[] A plug wants to show console information
---
---@param plug PlugDefinition
---@vararg any
---
function Logger:PlugInfo(plug, ...)
    -- RETURN: Disabled
    if not Logger.Level.INFO.Enabled then
        return
    end

    local icon = plug.Icon and not string.find(plug.Icon, "rbxassetid") or ""
    print(("[%s %s] %s"):format(icon, plug.Name, concatVars(...)))
end

---
---[] A plug wants to warn
---
---@param plug PlugDefinition
---@vararg any
---
function Logger:PlugWarn(plug, ...)
    -- RETURN: Disabled
    if not Logger.Level.WARN.Enabled then
        return
    end

    local icon = plug.Icon and not string.find(plug.Icon, "rbxassetid") or ""
    warn(("[%s %s] %s"):format(icon, plug.Name, concatVars(...)))
end

---
---📌 Core, detailed system information
---
---@vararg any
---
function Logger:Trace(...)
    -- RETURN: Disabled
    if not Logger.Level.TRACE.Enabled then
        return
    end

    print(writeSourceOutput(Logger.Level.TRACE, ...))
end

---
---🔹 Generic and useful information about system operation.
---
---@vararg any
---
function Logger:Info(...)
    -- RETURN: Disabled
    if not Logger.Level.INFO.Enabled then
        return
    end

    print(writeSourceOutput(Logger.Level.INFO, ...))
end

---
---🚧 Warnings, poor usage of the API, or 'almost' errors.
---
---@vararg any
---
function Logger:Warn(...)
    -- RETURN: Disabled
    if not Logger.Level.WARN.Enabled then
        return
    end

    warn(writeSourceOutput(Logger.Level.WARN, ...))
end

---
---❌ Severe runtime errors or unexpected conditions.
---
---@vararg any
---
function Logger:Error(...)
    -- RETURN: Disabled
    if not Logger.Level.ERROR.Enabled then
        return
    end

    error(writeSourceOutput(Logger.Level.ERROR, ...), TRACEBACK_SOURCE_LINE)
end

return Logger
