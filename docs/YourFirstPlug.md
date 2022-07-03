---
sidebar_position: 3
---

# Adding Your First Plug

If you've got this far, let's assume that your interested in adding some Plugs of your own to help improve your developer workflow! 

## Creating a new Plug

Let's make use of one of our Core Plugs, **Create Plug** to create your first plug 
![image](/create_plug.png)

This creates a `ModuleScript` in the `SocketPlugin.Plugs` directory
:::info
You can create folders in this directory to help organise your Plugs; but the `Group` of a Plug is defined within the `ModuleScript` itself
:::

You'll get a `ModuleScript` with a `Source` similar to:
```lua
---
-- Plug
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage")
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger)

--------------------------------------------------
-- Members

local plugDefinition = {
    Name = "%s",
    Group = "Plugs",
    Icon = "%s",
    Description = "%s",
}

plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, ("Hello %s!"):format(plug.Name))
    --[[
        ...
        Your Logic Here
        ...
    ]]
end

return plugDefinition

```

You'll notice we're returning a table with key/value pairs. For a full breakdown of what is on offer, and what they each do, see [PlugDefinition](/api/PlugDefinition).

There are 2 required key/value pairs:
* Name
* Function

Everything else is optional, or will be populated with a default value.

:::tip
Try adding + configuring some fields, and see how the Widget updates! Keep an eye on the *output* window incase there are any issues with your [PlugDefinition](/api/PlugDefinition).
:::

## Creating our code

We now have a fresh Plug, and have played around with how it appears on the Widget. Lets take a look at the tools we have when defining our [Function](/api/PlugDefinition#Function)

### Parameters

[Function](/api/PlugDefinition#Function) gets passed 2 parameters; `plug`: [PlugDefinition](/api/PlugDefinition), `plugin`: [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin).

* `plug` is our [PlugDefinition](/api/PlugDefinition). It is important we reference `plug` inside our functions, and **not** `plugDefinition`. Changes are made outside the scope of the `ModuleScript` (e.g., if we change a `Field` value on the Widget, this is written to the `plug` variable and **not** `plugDefinition`)
* `plugin` is the actual [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object that **Socket** is under; this is passed for special use cases, as the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object has unique API

### Logging

You'll notice in the template Plug that gets created, a required `Logger` file. This gives us access to `Logger:PlugInfo(plug, "Hello!")` and `Logger:PlugWarn(plug, "Uh Oh!")`

This is just a nice way to print to the output, and show the Plug scope it came from. This is the same API used for when **Socket** detects an issue with a Plug and wants to inform the user (e.g., a required Field is missing its value)

### Using the `plug` Parameter

You can reference any members of `plug` (see [PlugDefinition](/api/PlugDefinition)).

One of the most useful members is `plug.State` (see [PlugState](/api/PlugDefinition#PlugState)). Let's take a quick look what that gives us access to:

#### `plug.State.IsRunning` & `plug:ToggleIsRunning()`

We may want to have a Plug that has a toggleable routine; aka we can turn it on and off. We can change `plug.State.IsRunning` to keep track of the plug being on or off. We can toggle this using [ToggleIsRunning](/api/PlugDefinition#ToggleIsRunning) and read it via [IsRunning](/api/PlugDefinition#IsRunning). These methods are sugar for manipulating values in `plug`

#### `plug.State.FieldValues`

A strength of Socket is being able to declare values on the fly to be used in our Plugs. These are easily accessible on the Widget, but we then ofcourse need to reference them in our [Function](/api/PlugDefinition#Function). `plug.State.FieldValues` is where the declared values of fields exist. If we have declared a field such as:
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
We can access the value via `plug:GetFieldValue("Amount")` (which is sugar for `plug.State.FieldValues.Amount`)
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
If `IsRequired=true`, we will get a `Logger:PlugWarn` warning in our output if we run the plug and we have not declared a value for the Field. We can assume it exists in our `Function` now!

A nice trick we can do is if we want to declare a default value for a Field, we can mirror the following structure in our [PlugDefinition](/api/PlugDefinition)
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

We may also have an input field that has some specific requirements (e.g., for an `Amount` value, we probably want a positive integer!). We can write these checks in our [Function](/api/PlugDefinition#Function) ofcourse - a cleaner option is this:

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

If there is an issue, return a string detailing the issue. This will be written to the output, along with the context of the Field (Plug, Field Name/Type/Value)

### BindToClose

Imagine we have a Plug that is running routines (`plug.State.IsRunning=true`), but we then delete the `ModuleScript` for that Plug, or we close the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin)? We could still have code running that would've normally been stopped by toggling the Plug. This is where [BindToClose](/api/PlugDefinition#BindToClose) comes in.

Example:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- PlugDefinition that, when running, will print the time since the last frame
    local plugDefinition = {
		-- ...
        Function = function(plug, plugin)
            -- Toggle running state
            plug:ToggleIsRunning()

            -- Get Variables
            local isRunning = plug:IsRunning()
        
            if isRunning then
                plug.State.HeartbeatConnection = Heartbeat:Connect(function(dt)
                    Logger:PlugInfo(plug, ("dt: %f"))
                end)
            elseif plug.State.HeartbeatConnection then
                plug.State.HeartbeatConnection:Disconnect()
                plug.State.HeartbeatConnection = nil
            end
        end;
        BindToClose = function(plug, plugin)
            if plug.State.HeartbeatConnection then
                plug.State.HeartbeatConnection:Disconnect()
                plug.State.HeartbeatConnection = nil
            end
        end;
		-- ...
    }
```

In the above situation, toggling `IsRunning` from outside the scope of `Function` will still cause routines to keep running! [BindToClose](/api/PlugDefinition#BindToClose) saves the day by ensuring `HeartbeatConnection` is disconnected.
:::tip
Naturally when `BindToClose` is called by **Socket**, we also toggle `IsRunning=false` - so if you hade a routine like:
```lua
while plug.State.IsRunning do
-- ...
end
```
The loop would stop and does not require a `BindToClose` function. We also cleanup the `RunJanitor` when `BindToClose` is called. We can pass any Instances, or other routines, to the [RunJanitor](/api/PlugDefinition#RunJanitor) to be cleaned up when the Plug stops running. Check out the API [here](/api/PlugDefinition#BindToClose)
:::

The above example was to demonstrate the functionality of `BindToClose`; a much cleaner structure would be:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- PlugDefinition that, when running, will print the time since the last frame
    local plugDefinition = {
		-- ...
        Function = function(plug, plugin)
            -- Toggle running state
			plug:ToggleIsRunning()

			-- RETURN: Not running
			if not plug:IsRunning() then
				return
			end

			-- Setup Loop
			plug.RunJanitor:Add(Heartbeat:Connect(function(dt)
                Logger:PlugInfo(plug, ("dt: %f"))
            end))
        end
		-- ...
    }
```