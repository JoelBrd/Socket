--[=[
    @class PlugDefinition
    
    This is how we define the behaviour of a **Plug**
]=]

--[=[
    @prop Name string
    @tag Required
    @within PlugDefinition

    Declares the name that will appear on the Widget for the **Plug**.
    
    :::caution
    Longer names will be less readable on the Widget, depending on a user's resolution
    :::
]=]

--[=[
    @prop NameColor Color3
    @within PlugDefinition

    Give your **Plug** a pretty color on the Widget!

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Icon string
    @within PlugDefinition

    Defines an icon to put alongside the `Name` of the **Plug**.

    This can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxassetid`

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
]=]

--[=[
    @prop IconColor Color3
    @within PlugDefinition

    Give your **Plug** icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Group string
    @within PlugDefinition

    The group that the **Plug** belongs to. Any plugs with matching `Group` will be group together on the Widget
]=]

--[=[
    @prop GroupColor Color3
    @within PlugDefinition

    Give a `Group` a pretty color on the Widget! If you have multiple **Plugs** under the same `Group`, `GroupColor` need only be defined
    on a singular `PlugDefinition`

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop GroupIcon string
    @within PlugDefinition

    Defines an icon to put alongside the name of the `Group` the **Plug** is under. If you have multiple **Plugs** under the same `Group`, `GroupIcon` need only be defined
    on a singular `PlugDefinition`

    This can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxassetid`

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
]=]

--[=[
    @prop GroupIconColor Color3
    @within PlugDefinition

    Give your **Plug** icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input. If you have multiple **Plugs** under the 
    same `Group`, `GroupIconColor` need only be defined on a singular `PlugDefinition`

    Defaults to `Color.fromRGB(255, 255, 255)`
]=]

--[=[
    @prop Description string
    @within PlugDefinition

    Any and all information pertaining to this specific **Plug**. This can be as long as you like as it appears in the output.

    ```lua
    {
        Description = "Plug Description Line 1\nPlug Description Line 2"
    }
    ```
    
    Output:
    ```
    ================ Plug Name (Plug Group) | DESCRIPTION ================ 

    Plug Description Line 1
    Plug Description Line 2

    ================ Plug Name (Plug Group) | DESCRIPTION ================
    ```
]=]

--[=[
    @prop EnableAutomaticUndo boolean
    @within PlugDefinition

    If `true`, will automatically setup `ChangeHistoryService` waypoints before and after running the **Plug's** `Function`. AKA, any changes
    to studio that your **Plug** makes, you can undo with `Ctrl+Z` or equivalent.

    You can obviously set this to `false` (or don't declare the field) if you want to write your own implementation.

    :::tip
    When you run "Undo" in Studio, it will undo the last change under the `DataModel` (`game`). If your **Plug** just prints to the output (and doesn't
    make any changes to the `DataModel`) it will undo your last change unrelated to your **Plug**
    :::
]=]

--[=[
    @prop Keybind {Enum.KeyCode}
    @within PlugDefinition

    An array of `Enum.KeyCode` that can trigger the **Plug** to run.
    ```lua
    {
        Keybind = { Enum.KeyCode.LeftControl, Enum.KeyCode.J }
    }    
    ```

    :::tip
    Will not work if any of the inputs have `gameProcessedEvent` set to true. See: [UserInputService]
    :::
]=]

--[=[
    @prop Fields {PlugField}
    @within PlugDefinition

    An array of `PlugField`, which define the different fields the **Plug** has
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
]=]

--[=[
    @prop State PlugState
    @within PlugDefinition

    A persistent `State` of the **Plug** while the Socket plugin is running. We can write to this inside the `PlugDefinition`, and
    read/write to it in our `Function` and `BindToState` functions.

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
                Size = Vector3.new(2, 2, 2);
            }
        }
    }
    ```

    We can also access `IsRunning`:
    ```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- PlugDefinition that, when running, will print the time since the last frame
    {
        Fields = {
            {
                Name = "Timer";
                Type = "number";
                IsRequired = true;
            }
        }
        State = {
            IsRunning = false
        }
        Function = function(plug, plugin)
            -- Toggle running state
            plug.State.IsRunning = not plug.State.IsRunning

            -- Get Fields
            local timer = plug.State.FieldValues.Timer
            local isRunning = plug.State.IsRunning
        
            if isRunning then
                plug.State.HeartbeatConnection = Heartbeat:Connect(function(dt)
                    Logger:PlugInfo(plug, ("dt: %f"))
                end)
            else
                plug.State.HeartbeatConnection:Disconnect()
            end
        end
        BindToClose = function(plug, plugin)
            if plug.State.HeartbeatConnection then
                plug.State.HeartbeatConnection:Disconnect()
            end
        end
    }
    ```
]=]

--[=[
    @function Function
    @param plug PlugDefinition
    @param plugin Plugin
    @tag Required
    @within PlugDefinition

    The function that will be called when we Run the **Plug**.
    
    :::caution
    This function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent
    :::
]=]

--[=[
    @function BindToClose
    @param plug PlugDefinition
    @param plugin Plugin
    @within PlugDefinition

    This is a function that is called when:
    1. The Socket Plugin is exited
    2. The **Plug** is removed while the Socket Plugin is running

    Use this to clean anything up instantiated by the **Plug**
    
    :::tip
    Along with `BindToClose` being called, we also set `IsRunning=false`
    :::
    :::caution
    This function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent
    :::
]=]
