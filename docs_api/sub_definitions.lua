--[=[
    @class MacroField

    This is a datastructure that populates [MacroDefinition#Fields] and defines the different fields that will appear for a macro on the widget.
]=]

--[=[
    @prop Type MacroFieldType
    @tag Required
    @within MacroField

    The type of data this field will take (e.g., `"number"`). See [MacroFieldType#Name] for the options available!
]=]

--[=[
    @prop Name string
    @tag Required
    @within MacroField

    The name of this field. This is the same string used to reference this field within a macro.
]=]

--[=[
    @prop IsRequired boolean
    @within MacroField

    If true, the macro will not run + produce a `MacroWarn` in the output if a value has not been defined.
]=]

--[=[
    @function Validator
    @param value any
    @return string
    @within MacroField

    We can define a `Validator` function to run our field value by when we run the macro. If there is an issue, we have `Validator`
    return a `string` detailing the issue. If everything is OK, return nil.

    An example use case is if we have a `"number"` field, but we want to make sure it is non-negative.
    ```
    {
        Name = "Height";
        MacroFieldType = "number";
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
    @class MacroFieldType

    A data structure to define the different types of macro fields.
]=]

--[=[
    @prop Name string
    @within MacroFieldType

    The string that should be referenced inside a `MacroDefinition` for a `MacroField's` `MacroFieldType`

    Socket comes with the following types:
    ```
    "string"|"number"|"boolean"|"Color3"|"Vector3"
    ```

    There is currently no support for adding new types (unless you fork the repo and develop your own)
]=]

--[=[
    @prop Icon string
    @within MacroFieldType

    A small string/emoji
]=]

--[=[
    @function Validate
    @param value string
    @return any|nil
    @within MacroFieldType

    Takes an input value, and returns a type-safe version. Can return nil if there is nothing we can do with it.
]=]

--[=[
    @function ToString
    @param value any
    @return string
    @within MacroFieldType

    Takes a type-safe value, and returns it as a string that can be put into the field `TextBox` on the UI.
]=]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--[=[
    @interface MacroState
    @field FieldValues table<MacroField.Name,any> -- Where we can read the values in our fields from
    @field IsRunning boolean|nil -- Use this variable to toggle the state of a Macro (updates the UI)
    @field IsKeybindDisabled boolean|nil -- An internal variable for declaring whether a keybind has been disabled or not
    @field _Server MacroState -- Socket-only (used for communcicating Server/Client in Accurate Play Solo)
    @field _Client MacroState -- Socket-only (used for communcicating Server/Client in Accurate Play Solo)
    @within MacroDefinition

    A table to store a macro's "State". Socket writes some stuff here, but feel free to use this for whatever you need. If you overwrite any
    keys that Socket uses (fields defined here), expect mayhem and tears!
]=]
