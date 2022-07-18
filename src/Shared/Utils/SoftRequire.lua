---Passed a ModuleScript, will require a Clone() of it.
---This has the benefit of softRequire(moduleScript) ~= softRequire(moduleScript), whereas require(moduleScript) == require(moduleScript).
---This gets round the cached value that require() uses.
---This is beneficial for Socket, as you may be constantly updating your Util files and don't want to use an old cached value on the
---same studio session
---@param moduleScript ModuleScript
---@return table
local function softRequire(moduleScript)
    local clonedScript = moduleScript:Clone()
    local result = require(clonedScript)
    clonedScript:Destroy()
    return result
end

return softRequire()
