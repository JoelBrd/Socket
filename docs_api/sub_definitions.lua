--[=[
    @class PlugField
]=]

--[=[
    @prop Type PlugFieldType
    @tag Required
    @within PlugField
]=]

--[=[
    @prop Name string
    @tag Required
    @within PlugField

    The name of this field. This is the same string used to reference this field within a plug.
]=]

--[=[
    @prop IsRequired boolean
    @within PlugField

    If true, the plug will not run + produce a `PlugWarn` in the output if a value has not been defined.
]=]

--[=[
    @function Validator
    @param value any
    @return string
    @within PlugField

    We can define a `Validator` function to run our field value by when we run the plug. If there is an issue, we have `Validator`
    return a `string` detailing the issue. If everything is OK, return nil.

    A good use case is if the user can define a number, but we want to make sure it is non-negative.
    ```
    {
        Name = "Height";
        PlugFieldType = "number";
        Validator = function(someNumber)
            if someNumber < 0 then
                return ("Must be non-negative. Got: %d"):format(someNumber)
            end
        end
    }
    ```
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @class PlugFieldType

    A data structure to define the different types of plug fields.
]=]

--[=[
    @prop Name string
    @within PlugFieldType

    The string that should be referenced inside a `PlugDefinition` for a `PlugField`'s `PlugFieldType` 

    Socket comes with the following types:
    ```
    "string"|"number"|"boolean"|"Color3"|"Vector3"
    ```
]=]

--[=[
    @prop Icon string
    @within PlugFieldType

    A small string/emoji
]=]

--[=[
    @function Validate
    @param value string
    @return any|nil
    @within PlugFieldType

    Takes an input value, and returns a type-safe version. Can return nil if there is nothing we can do with it.
]=]

--[=[
    @function ToString
    @param value any
    @return string
    @within PlugFieldType

    Takes a type-safe value, and returns it as a string that can be put into the field `TextBox` on the UI.
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @interface PlugState
    @field FieldValues table<PlugField.Name,any> -- Where we can read the values of our fields from
    @field IsRunning boolean|nil -- Use this variable to toggle the state of a Plug (updates the UI)
    @field Server PlugState -- Socket-only (used for communcicating Server/Client in Accurate Play Solo)
    @field Client PlugState -- Socket-only (used for communcicating Server/Client in Accurate Play Solo)
    @within PlugDefinition

    A table to store a plug's "State". Socket writes some stuff here, but feel free to use this for whatever you need. If you overwrite any
    keys that Socket uses (fields defined here), expect mayhem and tears!
]=]
