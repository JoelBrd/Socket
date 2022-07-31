--[=[
    @class MacroDefinition
    
    This is how we define the behaviour of a Macro.

    There are a few `Required` members for a [MacroDefinition] to be valid.

    Many fields are `Populated`, where if it is not defined in your [MacroDefinition], will be auto-filled by Socket with a default value.
    
    There are some `Read-Only` fields, that you'll want to avoid defining in your [MacroDefinition] and let them be `Populated` by Socket.
]=]

--[=[
    @prop Name string
    @tag Required
    @within MacroDefinition

    Declares the name that will appear on the Widget for the Macro.
    
    :::caution
    Longer names will be less readable on the Widget, depending on a user's resolution
    :::
]=]

--[=[
    @prop NameColor Color3
    @tag Populated
    @within MacroDefinition

    Give your Macro a pretty color on the Widget!

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Icon string
    @tag Populated
    @within MacroDefinition

    Defines an icon to put alongside the `Name` of the Macro.

    This can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxasset`

    ```lua
    {
        Icon = "📂" -- Good
        Icon = "My Icon" -- Probably too long, but good
        Icon = "" -- Bit boring, but good
        Icon = "rbxassetid://9553550332" -- Good ImageId
        Icon = "https://www.roblox.com/library/9553550338/" -- Bad ImageId (Website)
        Icon = "http://www.roblox.com/asset/?id=9553550332" -- Bad ImageId (Decal)
    }
    ```

    Defaults to `"❓"`
]=]

--[=[
    @prop IconColor Color3
    @tag Populated
    @within MacroDefinition

    Give your Macro icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Group string
    @tag Populated
    @within MacroDefinition

    The group that the Macro belongs to. Any macros with a matching `Group` value will be grouped together on the Widget

    Defaults to `"No Group"`
]=]

--[=[
    @prop GroupColor Color3
    @tag Populated
    @within MacroDefinition

    Give the `Group` text a pretty color on the Widget! If you have multiple Macros under the same `Group`, `GroupColor` need only be defined
    on a singular `MacroDefinition`.

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop GroupIcon string
    @tag Populated
    @within MacroDefinition

    Defines an icon to put alongside the name of the `Group` the Macro is under. If you have multiple Macros under the same `Group`, `GroupIcon` need only be defined
    on a singular `MacroDefinition`

    This can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxasset`

    ```lua
    {
        Icon = "📂" -- Good
        Icon = "My Icon" -- Probably too long, but good
        Icon = "" -- Bit boring, but good
        Icon = "rbxassetid://9553550332" -- Good ImageId
        Icon = "https://www.roblox.com/library/9553550338/" -- Bad ImageId (Website)
        Icon = "http://www.roblox.com/asset/?id=9553550332" -- Bad ImageId (Decal)
    }
    ```

    Defaults to `"❓"`
]=]

--[=[
    @prop GroupIconColor Color3
    @tag Populated
    @within MacroDefinition

    Give your Macro icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input. If you have multiple Macros under the 
    same `Group`, `GroupIconColor` need only be defined on a singular `MacroDefinition`

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Description string
    @tag Populated
    @within MacroDefinition

    Any and all information pertaining to this specific Macro. This can be as long as you like as it appears in the output.

    ```lua
    {
        Description = "Macro Description Line 1\nMacro Description Line 2"
    }
    ```
    
    Output:
    ```
    ================ Macro Name (Macro Group) | DESCRIPTION ================ 

    Macro Description Line 1
    Macro Description Line 2

    ================ Macro Name (Macro Group) | DESCRIPTION ================
    ```

    Defaults to `"No Description"`
]=]

--[=[
    @prop LayoutOrder number
    @tag Populated
    @within MacroDefinition

    Can be used to define the position of where the Macro is rendered on the Widget. Higher numbers are rendered further down the widget. Works very much the same
    as `LayoutOrder` on Roblox Instances.

    See [Settings](/api/SocketSettings#SortType)

    Defaults to `0`
]=]

--[=[
    @prop EnableAutomaticUndo boolean
    @tag Populated
    @within MacroDefinition

    If `true`, will automatically setup `ChangeHistoryService` waypoints before and after running the **Macro's** `Function`. AKA, any changes
    to studio that your Macro makes, you can undo with `Ctrl+Z` or equivalent.

    You can obviously set this to `false` (or don't declare the field) if you want to write your own implementation.

    :::tip
    When you run "Undo" in Studio, it will undo the last change under the `DataModel` (`game`). If, for example, your Macro just prints to the output (and doesn't
    make any changes to the `DataModel`) it will undo the last change unrelated to your Macro
    :::

    Defaults to `false`
]=]

--[=[
    @prop IgnoreGameProcessedKeybinds boolean
    @tag Populated
    @within MacroDefinition

    Socket uses [UserInputService#InputBegan] for detecting keybinds.
    ```
    game:GetService("UserInputService").InputBegan:Connect(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent and not IgnoreGameProcessedKeybinds then
            return
        end

        ...
    end)
    ```

    Defaults to `false`
]=]

--[=[
    @prop AutoRun boolean
    @tag Populated
    @within MacroDefinition

    If `true`, `macro.Function` will be called when Socket starts. Useful if there is a macro you want to run on startup.

    Defaults to `false`
]=]

--[=[
    @prop IsLocalMacro boolean
    @tag Populated
    @within MacroDefinition

    If a macro is a "Local Macro", this value will be populated as true.

    Local Macros replicate across different roblox places by being stored under the Socket `plugin`. You can add a Local Macro by placing it under
    ```
    game.ServerStorage.SocketPlugin.LocalMacros[userId] -- Where userId is your own userId
    ```

    :::tip
    Don't know what your `userId` is? It's the number in the URL of your profile, or you can find it by running the following in the command line:
    ```
    print(game:GetService("StudioService"):GetUserId())
    ```
    :::
]=]

--[=[
    @prop Keybind {Enum.KeyCode}
    @tag Populated
    @within MacroDefinition

    An array of `Enum.KeyCode` that can trigger the Macro to run.
    ```lua
    {
        Keybind = { Enum.KeyCode.LeftControl, Enum.KeyCode.J }
    }    
    ```

    :::tip
    Will not work if any of the inputs have `gameProcessedEvent` set to true. See: [UserInputService]

    To disable this, see [TODO]
    :::

    Defaults to `{}`
]=]

--[=[
    @prop Fields {MacroField}
    @tag Populated
    @within MacroDefinition

    An array of [MacroField], which define the different fields the Macro has. The order they are defined is the order they will appear
    on the widget.
    ```lua
    {
        Fields = { 
            {
                Name = "Amount";
                Type = "number";
                IsRequired = true;
            },
            {
                Name = "Title";
                Type = "string";
            }
        }
    }    
    ```

    Defaults to `{}`
]=]

--[=[
    @method GetFieldValue
    @param fieldName string
    @return any
    @tag Read-Only
    @within MacroDefinition

    Sugar for
    ```lua
    macro.State.FieldValues[fieldName]
    ```
]=]

--[=[
    @prop FieldChanged BindableEvent
    @tag Read-Only
    @within MacroDefinition

    A `BindableEvent` to listen to field values being changed on the UI!
    ```
    macro.FieldChanged.Event:Connect(function(fieldName, fieldValue)
        print(macro:GetFieldValue(fieldName) == fieldValue)
    end)

    -- Output: true
    ```

    Most cases it will suffice to just read `macro:GetFieldValue(fieldName)` as and when you need a field value. But sometimes you may want to re-run routines
    after a field value change.
]=]

--[=[
    @prop State MacroState
    @tag Populated
    @within MacroDefinition

    A persistent `State` of the Macro while the Socket plugin is running. We can write to this inside the `MacroDefinition`, and
    read/write to it in our `Function` and `BindToClose/BindToOpen` functions.

    We can declare default values for fields:
    ```lua
    {
        Fields = {
            {
                Name = "Size";
                Type = "Vector3";
            }
        }
        State = {
            FieldValues = {
                Size = Vector3.new(2, 2, 2); -- Will automatically appear on the Widget
            }
        }
    }
    ```

    We can also access `IsRunning`:
    ```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- MacroDefinition that, when running, will print the time since the last frame
    {
        Function = function(macro, plugin)
            -- Toggle running state
            macro:ToggleIsRunning()
        
            -- Running routine
            if macro:IsRunning() then
                -- Add to our RunJanitor
                -- Automatically gets cleaned up when we toggle IsRunning to false via ToggleIsRunning
                -- Also gets cleaned up when BindToClose is called
                macro.RunJanitor:Add(Heartbeat:Connect(function(dt)
                    Logger:MacroInfo(macro, ("dt: %f"))
                end))
            end
        end
    }
    ```

    Defaults to
    ```
    {
        FieldValues = {};
        IsRunning = false;
        _Server = {};
        _Client = {};
    }
    ```
]=]

--[=[
    @prop RunJanitor Janitor
    @tag Read-Only
    @within MacroDefinition

    A [Janitor](https://github.com/howmanysmall/Janitor) object, intended to be used to cleanup tasks after a macro stops running.

    Is automatically cleaned up when using `macro:ToggleIsRunning()`, and on `BindToClose`
]=]

--[=[
    @method ToggleIsRunning
    @tag Read-Only
    @within MacroDefinition

    Sugar for
    ```lua
    macro.State.IsRunning = not macro.State.IsRunning
    if not macro.State.IsRunning then
        macro.RunJanitor:Cleanup()
    end
    ```
]=]

--[=[
    @method IsRunning
    @return boolean
    @tag Read-Only
    @within MacroDefinition

    Returns true if the Macro is running (`macro.State.IsRunning == true`). False otherwise.

    Sugar for
    ```lua
    macro.State.IsRunning
    ```
]=]

--[=[
    @function Function
    @param macro MacroDefinition
    @param plugin Plugin
    @tag Required
    @within MacroDefinition

    The function that will be called when we Run the Macro.
    
    :::caution
    This function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent
    :::
]=]

--[=[
    @function BindToClose
    @param macro MacroDefinition
    @param plugin Plugin
    @within MacroDefinition

    This is a function that is called when:
    1. The Socket Plugin is exited
    2. The Macro is removed while the Socket Plugin is running

    Use this to clean anything up instantiated by the Macro
    
    :::caution
    This function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent
    :::

    Order of operations:
    1) `BindToClose` is called
    2) `macro.State.IsRunning = false`
    3) `macro.RunJanitor:Cleanup()`
]=]

--[=[
    @function BindToOpen
    @param macro MacroDefinition
    @param plugin Plugin
    @within MacroDefinition

    This is a function that is called when the Socket plugin is started! This has some rare use cases.

    For the most part, Socket is really good at calling `BindToClose` when it is needed, but there are some Roblox limitations.
    Imagine we have a macro that makes significant changes in `game.Workspace` (e.g., changes the `Color3` of part(s)). If Roblox Studio
    is suddenly closed, or crashes, it's possible the changes the macro made will be saved, but the "stopping" logic is never run. `BindToOpen` can
    be used to run checks to cleanup any mess left from the previous session. This is more a failsafe than a requirement, but can save headaches!

    For a good example use-case, see the Socket Core Macro `.Locked`

    :::caution
    This function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent
    :::
]=]

--[=[
    @prop Disabled boolean
    @tag Populated
    @within MacroDefinition

    If `true`, this Macro will not be displayed on the Widget. It's `Function` will also not be required, nor registered. This renders `AutoRun` useless
    for this specific [MacroDefinition](/api/MacroDefinition)

    :::tip
    This can be useful to create a [MacroDefinition](/api/MacroDefinition) solely for defining the aesthetics of a `Group` for organisation purposes.

    ```lua
        {
            Group = "Fruity Macros",
            GroupIcon = "🍎",
            GroupColor = Color3.fromRGB(200, 20, 20),
            Disabled = true,
        }
    ```
    :::

    Defaults to `false`
]=]
