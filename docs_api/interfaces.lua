--[=[
    @interface PlugField
    @field Type PlugFieldType
    @field Name string
    @field IsRequired boolean|nil -- If true, Plug will not run until there is a value in this field
    @within PlugDefinition
]=]

--[=[
    @type PlugFieldType "string"|"number"|"boolean"|"Color3"|"Vector3"
    @within PlugDefinition
]=]

--[=[
    @interface PlugState
    @field FieldValues table<PlugField.Name,any> -- Where we can read the values of our fields from
    @field IsRunning boolean|nil -- Use this variable to toggle the state of a Plug (updates the UI)
    @within PlugDefinition
]=]
