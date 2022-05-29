---
---Framework object, for easy communicate between modules
---
---@class Framework:Object
---
local Framework = {
    ClassName = "Framework",
}
Framework.__index = Framework

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local Utils = script.Parent.Parent.Utils
local Classes = script.Parent
local Object = require(Classes.Object) ---@type Object
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
local FRAMEWORK_IGNORE_INSTANCE_NAME = "FrameworkIgnore"

--------------------------------------------------
-- Members

---
---Creates a framework!
---@vararg any
---@return Framework
---
function Framework.new(...)
    local framework = Object:CreateObjectFrom(Framework, Object.new(...))
    framework:Constructor(...)
    return framework
end

---@private
---
---Constructor for the framework
function Framework:Constructor(...)
    self.isLoaded = false

    self.directories = {} ---@type Instance[]
    self.moduleScriptsDict = {} ---@type table<string, ModuleScript>
    self.modulesDict = {} ---@type table<string, table>
    self.modulesArray = {} ---@type table[]
    self.modulesPriorityStartOrder = {} ---@type table[] Priority list for calling Framework methods on modules
end

---@private
---
---Loads this specific module into this Framework
---@param moduleScript ModuleScript
function Framework:LoadModule(moduleScript)
    -- ERROR: Duplicate name
    local name = moduleScript.Name
    if self.modulesDict[name] then
        Logger:Error(("Preexisting module cached under name %q"):format(name))
    end

    -- Cache
    local requiredModule = require(moduleScript)
    requiredModule._IsFrameworkModule = true

    self.modulesDict[name] = requiredModule
    self.moduleScriptsDict[name] = moduleScript
    table.insert(self.modulesArray, requiredModule)
end

---@private
---
---Will load on any valid modules in the passed directory + recurse through its children.
---@param directory Instance
function Framework:LoadRecurse(directory)
    -- RETURN: No children
    local children = directory:GetChildren()
    if #children == 0 then
        return
    end

    -- RETURN: Ignore
    local ignoreValueObject = directory:FindFirstChild(FRAMEWORK_IGNORE_INSTANCE_NAME) ---@type Insance
    local ignoreValue = ignoreValueObject and ignoreValueObject:IsA("StringValue") and ignoreValueObject.Value
    if ignoreValue and not (ignoreValue == "true" or ignoreValue == "false") then
        Logger:Error(("Bad ignore value; must be a StringValue of `true` or `false` (%s)"):format(ignoreValueObject:GetFullName()))
    end
    if ignoreValue == "true" then
        return
    end

    -- Loop children
    for _, child in pairs(children) do
        -- Load this as a directory
        self:LoadRecurse(child)

        -- Load if applicable
        if child:IsA("ModuleScript") then
            self:LoadModule(child)
        end
    end
end

---
---Passes a tuple of directories.. will load any and all descendants that are module scripts.
---Won't load any module scripts passed in the argument; only looks at the descendants.
---Can only be called once.
---@varag Instance
---
function Framework:Load(...)
    -- ERROR: Already loaded
    if self:IsLoaded() then
        Logger:Error("Framework already loaded")
    end

    -- Load Directories
    self.directories = table.pack(...)
    self.directories.n = nil -- See documentation for table.pack
    for _, directory in pairs(self.directories) do
        self:LoadRecurse(directory)
    end

    -- Declare us loaded
    self.isLoaded = true

    -- Run Framework functions
    self:RunInitFunctions()
    self:RunStartFunctions()
end

---
---@return boolean
---
function Framework:IsLoaded()
    return self.isLoaded
end

---@private
---
---Runs the FrameworkInit() functions on our loaded modules
function Framework:RunInitFunctions()
    for _, module in pairs(self.modulesArray) do
        if module.FrameworkInit and not module._RanFrameworkInit then
            module:FrameworkInit()
        end
        module._RanFrameworkInit = true

        table.insert(self.modulesPriorityStartOrder, module)
    end
end

---@private
---
---Runs the FrameworkStart() functions on our loaded modules
function Framework:RunStartFunctions()
    for _, module in pairs(self.modulesPriorityStartOrder) do
        if module.FrameworkStart and not module._RanFrameworkStart then
            module:FrameworkStart()
        end
        module._RanFrameworkStart = true
    end
end

---
---Adds a custom module that can be Require(), but doesn't conform to the assume structured of the Framework.
---Add 3rd party libraries here.
---@param moduleName string
---@param moduleScript ModuleScript
---
function Framework:AddCustomModule(moduleName, moduleScript)
    -- ERROR: Conflicting name
    local module = require(moduleScript)
    if self.modulesDict[moduleName] then
        Logger:Error(("Preexisting module cached under name %q"):format(moduleName))
    end

    self.modulesDict[moduleName] = module
end

---
---Will return the required module
---@param moduleName string
---@return table
---
function Framework:Require(moduleName)
    -- Wait until we're loaded
    if not self:IsLoaded() then
        Logger:Error("Framework not loaded yet; is Require() called outside of Init()?")
    end

    -- ERROR: No module
    local module = self.modulesDict[moduleName]
    if not module then
        Logger:Error(("No module %q"):format(moduleName))
    end

    -- EDGE CASE: Start not run yet; prioritise!
    if module._IsFrameworkModule and not module._RanFrameworkStart then
        local alreadyPrioritised = table.find(self.modulesPriorityStartOrder, module) and true or false
        if not alreadyPrioritised then
            table.insert(self.modulesPriorityStartOrder, module)
        end
    end

    return module
end

---
---Will return the required ModuleScript
---@param moduleName string
---@return ModuleScript
---
function Framework:GetScript(moduleName)
    -- ERROR: No module
    local moduleScript = self.moduleScriptsDict[moduleName]
    if not moduleScript then
        Logger:Error(("No ModuleScript %q"):format(moduleName))
    end

    return moduleScript
end

---
---Will return the directory with the passed name.
---Directories are instances passed through :Load()
---@param directoryName string
---@return Instance
---
function Framework:GetDirectory(directoryName)
    for _, someDirectory in pairs(self.directories) do
        if someDirectory.Name == directoryName then
            return someDirectory
        end
    end

    Logger:Error(("No Directory %q"):format(directoryName))
end

return Framework
