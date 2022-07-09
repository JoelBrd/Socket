---
sidebar_position: 3
---

# Adding Your First Macro

If you've got this far, let's assume that your interested in adding some Macros of your own to help improve your developer workflow! 

## Creating a new Macro

Let's make use of one of our Core Macros, **Create Macro** to create your first macro 
![image](/create_macro.png)

This creates a `ModuleScript` in the `SocketPlugin.Macros` directory
:::info
You can create folders in this directory to help organise your Macros; but the `Group` of a Macro is defined within the `ModuleScript` itself
:::

You'll get a `ModuleScript` with a `Source` similar to:
```lua
---
-- Macro
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Members

local macroDefinition = {
    Name = "%s",
    Group = "Macros",
    Icon = "%s",
    Description = "%s",
}

macroDefinition.Function = function(macro, plugin)
    Logger:MacroInfo(macro, ("Hello %s!"):format(macro.Name))
    --[[
        ...
        Your Logic Here
        ...
    ]]
end

return macroDefinition

```

You'll notice we're returning a table with key/value pairs. For a full breakdown of what is on offer, and what they each do, see [MacroDefinition](/api/MacroDefinition).

There are 2 required key/value pairs:
* Name
* Function

Everything else is optional, or will be populated with a default value.

:::tip
Try adding + configuring some fields, and see how the Widget updates! Keep an eye on the *output* window incase there are any issues with your [MacroDefinition](/api/MacroDefinition).
:::

## Creating our code

We now have a fresh Macro, and have played around with how it appears on the Widget. Lets take a look at the tools we have when defining our [Function](/api/MacroDefinition#Function)

### Parameters

[Function](/api/MacroDefinition#Function) gets passed 2 parameters; `macro`: [MacroDefinition](/api/MacroDefinition), `plugin`: [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin).

* `macro` is our [MacroDefinition](/api/MacroDefinition). It is important we reference `macro` inside our functions, and **not** `macroDefinition`. Changes are made outside the scope of the `ModuleScript` (e.g., if we change a `Field` value on the Widget, this is written to the `macro` variable and **not** `macroDefinition`)
* `plugin` is the actual [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object that **Socket** is under; this is passed for special use cases, as the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object has unique API

### Logging

You'll notice in the template Macro that gets created, a required `Logger` file. This gives us access to `Logger:MacroInfo(macro, "Hello!")` and `Logger:MacroWarn(macro, "Uh Oh!")`

This is just a nice way to print to the output, and show the Macro scope it came from. This is the same API used for when **Socket** detects an issue with a Macro and wants to inform the user (e.g., a required Field is missing its value)

### Using the `macro` Parameter

You can reference any members of `macro` (see [MacroDefinition](/api/MacroDefinition)).

One of the most useful members is `macro.State` (see [MacroState](/api/MacroDefinition#MacroState)). Let's take a quick look what that gives us access to:

#### `macro.State.IsRunning` & `macro:ToggleIsRunning()`

We may want to have a Macro that has a toggleable routine; aka we can turn it on and off. We can change `macro.State.IsRunning` to keep track of the macro being on or off. We can toggle this using [ToggleIsRunning](/api/MacroDefinition#ToggleIsRunning) and read it via [IsRunning](/api/MacroDefinition#IsRunning). These methods are sugar for manipulating values in `macro`

#### `macro.State.FieldValues`

A strength of Socket is being able to declare values on the fly to be used in our Macros. These are easily accessible on the Widget, but we then ofcourse need to reference them in our [Function](/api/MacroDefinition#Function). `macro.State.FieldValues` is where the declared values of fields exist. If we have declared a field such as:
```lua
{
	Fields = {
		{
			Name = "Amount";
			Type = "number";
		}
	}
}
```
We can access the value via `macro:GetFieldValue("Amount")` (which is sugar for `macro.State.FieldValues.Amount`)
Note that amount may not exist, so we can either:
1. Run this check in our `Function`
2. Do 
```lua
{
	Fields = {
		{
			Name = "Amount";
			Type = "number";
			IsRequired = true;
		}
	}
}
```
If `IsRequired=true`, we will get a `Logger:MacroWarn` warning in our output if we run the macro and we have not declared a value for the Field. We can assume it exists in our `Function` now!

A nice trick we can do is if we want to declare a default value for a Field, we can mirror the following structure in our [MacroDefinition](/api/MacroDefinition)
```lua
{
	Fields = {
		{
			Name = "Amount";
			Type = "number";
		}
	}
	State = {
		FieldValues = {
			Amount = 1;
		}
	}
}
```

We may also have an input field that has some specific requirements (e.g., for an `Amount` value, we probably want a positive integer!). We can write these checks in our [Function](/api/MacroDefinition#Function) ofcourse - a cleaner option is this:

```lua
{
    Fields = {
        {
            Name = "Amount";
            Type = "number";
            IsRequired = true;
            Validator = function(value)
                local hasDecimalComponent = math.floor(value) ~= value
                local isLessThanZero = value <= 0
                if hasDecimalComponent or isLessThanZero then
                    return "Must be a positive non-zero integer"
                end
            end
        }
    }
}
```

If there is an issue, return a string detailing the issue. This will be written to the output, along with the context of the Field (Macro, Field Name/Type/Value)

### BindToClose

Imagine we have a Macro that is running routines (`macro.State.IsRunning=true`), but we then delete the `ModuleScript` for that Macro, or we close the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin)? We could still have code running that would've normally been stopped by toggling the Macro. This is where [BindToClose](/api/MacroDefinition#BindToClose) comes in.

Example:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- MacroDefinition that, when running, will print the time since the last frame
    local macroDefinition = {
		-- ...
        Function = function(macro, plugin)
            -- Toggle running state
            macro:ToggleIsRunning()

            -- Get Variables
            local isRunning = macro:IsRunning()
        
            if isRunning then
                macro.State.HeartbeatConnection = Heartbeat:Connect(function(dt)
                    Logger:MacroInfo(macro, ("dt: %f"))
                end)
            elseif macro.State.HeartbeatConnection then
                macro.State.HeartbeatConnection:Disconnect()
                macro.State.HeartbeatConnection = nil
            end
        end;
        BindToClose = function(macro, plugin)
            if macro.State.HeartbeatConnection then
                macro.State.HeartbeatConnection:Disconnect()
                macro.State.HeartbeatConnection = nil
            end
        end;
		-- ...
    }
```

In the above situation, toggling `IsRunning` from outside the scope of `Function` will still cause routines to keep running! [BindToClose](/api/MacroDefinition#BindToClose) saves the day by ensuring `HeartbeatConnection` is disconnected.
:::tip
Naturally when `BindToClose` is called by **Socket**, we also toggle `IsRunning=false` - so if you hade a routine like:
```lua
while macro.State.IsRunning do
-- ...
end
```
The loop would stop and does not require a `BindToClose` function. We also cleanup the `RunJanitor` when `BindToClose` is called. We can pass any Instances, or other routines, to the [RunJanitor](/api/MacroDefinition#RunJanitor) to be cleaned up when the Macro stops running. Check out the API [here](/api/MacroDefinition#BindToClose)
:::

The above example was to demonstrate the functionality of `BindToClose`; a much cleaner structure would be:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- MacroDefinition that, when running, will print the time since the last frame
    local macroDefinition = {
		-- ...
        Function = function(macro, plugin)
            -- Toggle running state
			macro:ToggleIsRunning()

			-- RETURN: Not running
			if not macro:IsRunning() then
				return
			end

			-- Setup Loop
			macro.RunJanitor:Add(Heartbeat:Connect(function(dt)
                Logger:MacroInfo(macro, ("dt: %f"))
            end))
        end
		-- ...
    }
```