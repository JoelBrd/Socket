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
---Plug Template
---

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
    Group = "%s", ---@type string
    GroupColor = nil, ---@type Color3
    GroupIcon = nil, ---@type string
    GroupIconColor = nil, ---@type Color3

    Name = "%s",
    NameColor = nil, ---@type Color3
    Icon = "%s",
    IconColor = nil, ---@type Color3

    Description = "%s", ---@type string
    EnableAutomaticUndo = false, ---@type boolean
    AutoRun = false, ---@type boolean
    Keybind = {}, ---@type Enum.KeyCode[]
    Fields = {}, ---@type PlugField[]

    Function = nil, ---@type fun(plug:PlugDefinition, plugin:Plugin)
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, ("Hello, from %s!"):format(plug.Name))
end

return plugDefinition
```

You'll notice we're returning a table with a bunch of key/value pairs. For a full breakdown of these, and what they each do, see [PlugDefinition](/api/PlugDefinition).

There are 2 required key/value pairs:
* Name
* Function

Everything else is optional, or will be populated with a default value.

:::tip
Try editing some of these fields, and see how the *Widget* updates! Keep an eye on the *output* window incase there are any issues with your [PlugDefinition](/api/PlugDefinition).
:::

## Creating our code

We now have a fresh Plug, and have played around with how it appears on the *Widget*. Lets take a look at the tools we have when defining our [Function](/api/PlugDefinition#Function)

### Parameters

[Function](/api/PlugDefinition#Function) gets passed 2 parameters; `plug`: [PlugDefinition](/api/PlugDefinition), `plugin`: [Plugin].

* `plug` is our [PlugDefinition](/api/PlugDefinition). It is important we reference `plug`, and **not** `plugDefinition`. Changes are made outside the scope of the `ModuleScript` (e.g., if we change a `Field` value on the *Widget*, this is written to `plug` and **not** `plugDefinition`)
* `plugin` is the actual [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object that **Socket** is under; this is passed for special use cases, as the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin) object has unique API

### Logging

You'll notice in the template Plug that gets created, a required `Logger` file. This gives us access to:
```lua
Logger:PlugInfo(plug, "Hello!") -- <==> print(("[%s %s] %s"):format(plug.Icon or "", plug.Name, "Hello!"))
Logger:PlugWarn(plug, "Uh Oh!") -- <==> warn(("[%s %s] %s"):format(plug.Icon or "", plug.Name, "Hello!"))
```
This is just a nice way to print to the output, and show the Plug scope it came from. This is the same API used for when **Socket** detects an issue with a Plug and wants to inform the user (e.g., a required Field is missing its value)

### Using `plug` Parameter

You can reference any members of `plug` (see [PlugDefinition](/api/PlugDefinition)) - most notably `plug.State` (see [PlugState](/api/PlugDefinition#PlugState))

#### `plug.State.IsRunning` & `plug:ToggleIsRunning()`

We may want to have a Plug that has a toggleable routine; aka we can turn it on and off. We can change `plug.State.IsRunning` to indicate on the widget if the plug is running or not. Check out the API [here](/api/PlugDefinition#ToggleIsRunning)

#### `plug.State.FieldValues`

This is where the declared values of fields exist. If we have declared a field such as:
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
We can access the value via `local amount = plug.State.FieldValues.Amount` - or more nicely `local amount = plug:GetFieldValue("Amount")`
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
If `IsRequired=true`, we will get a `Logger:PlugWarn` in our output if we run the plug and we have not declared a value for the Field. We can assume it exists in our `Function` now!

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

### BindToClose

Imagine we have a Plug that is running routines (`IsRunning=true`), but we then delete the `ModuleScript` for that Plug, or we close the [Plugin](https://developer.roblox.com/en-us/api-reference/class/Plugin)? We could still have code running that would've normally been stopped by toggling the Plug. This is where [BindToClose](/api/PlugDefinition#BindToClose) comes in.

Example:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- PlugDefinition that, when running, will print the time since the last frame
    local plugDefinition = {
		-- ...
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

            -- Get Variables
            local timer = plug.State.FieldValues.Timer
            local isRunning = plug.State.IsRunning
        
            if isRunning then
                plug.State.HeartbeatConnection = Heartbeat:Connect(function(dt)
                    Logger:PlugInfo(plug, ("dt: %f"))
                end)
            elseif plug.State.HeartbeatConnection then
                plug.State.HeartbeatConnection:Disconnect()
                plug.State.HeartbeatConnection = nil
            end
        end
        BindToClose = function(plug, plugin)
            if plug.State.HeartbeatConnection then
                plug.State.HeartbeatConnection:Disconnect()
                plug.State.HeartbeatConnection = nil
            end
        end
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
The loop would stop and does not require a `BindToClose` function. We also cleanup the `RunJanitor` when `BindToClose` is called. Check out the API [here](/api/PlugDefinition#BindToClose)
:::

The above example was to demonstrate the functionality of `BindToClose`; a much cleaner structure would be:
```lua
    local Heartbeat = game:GetService("RunService").Heartbeat

    -- PlugDefinition that, when running, will print the time since the last frame
    local plugDefinition = {
		-- ...
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
			plug:ToggleIsRunning()

			-- RETURN: Not running
			if not plug.State.IsRunning then
				return
			end

            -- Get Variables
            local timer = plug.State.FieldValues.Timer

			-- Setup Loop
			plug.RunJanitor:Add(Heartbeat:Connect(function(dt)
                    Logger:PlugInfo(plug, ("dt: %f"))
            end))
        end
		-- ...
    }
```