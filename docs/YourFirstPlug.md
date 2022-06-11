---
sidebar_position: 3
---

# Adding Your First Plug

If you've got this far, let's assume that your interested in adding some **Plugs** of your own to help improve your developer workflow! 

## Creating a new **Plug**

Let's make use of one of our Core **Plugs**, **Create Plug** to create your first plug 
![image](/create_plug.png)

This creates a `ModuleScript` in the `SocketPlugin.Plugs` directory
:::info
You can create folders in this directory to help organise your **Plugs**; but the `Group` of a **Plug** is defined within the `ModuleScript` itself
:::

You'll get a `ModuleScript` with a `Source` similar to:
```lua
---
---Plug Template
---

--------------------------------------------------
-- Types
-- ...

--------------------------------------------------
-- Dependencies
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
-- ...

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
    Group = "No Group", ---@type string
    GroupColor = nil, ---@type Color3
    GroupIcon = nil, ---@type string
    GroupIconColor = nil, ---@type Color3

    Name = "No Name",
    NameColor = nil, ---@type Color3
    Icon = "🔌",
    IconColor = nil, ---@type Color3

    Description = "No Name Description", ---@type string
    State = {}, ---@type PlugState
    EnableAutomaticUndo = false, ---@type boolean
    Keybind = {}, ---@type Enum.KeyCode[]
    Fields = {}, ---@type PlugField[]

    Function = nil, ---@type fun(plug:PlugDefinition, plugin:Plugin)
    BindToClose = nil, ---@type fun(plug:PlugDefinition, plugin:Plugin)
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, "Hello!")
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

We now have a fresh **Plug**, and have played around with how it appears on the *Widget*. Lets take a look at the tools we have when defining our [Function](/api/PlugDefinition#Function)

### Parameters

[Function](/api/PlugDefinition#Function) gets passed 2 parameters; `plug`: [PlugDefinition](/api/PlugDefinition), `plugin`: [Plugin].

* `plug` is our [PlugDefinition](/api/PlugDefinition). It is important we reference `plug`, and **not** `plugDefinition` inside `Function` as necessary changes are made outside the scope of the `ModuleScript` (e.g., if we change a `Field` value on the *Widget*, this is written to `plug` and **not** `plugDefinition`)
* `plugin` is the actual [Plugin] object that **Socket** is under; this is passed for special use cases, as a [Plugin] object has unique API

### Logging

You'll notice in the default **Plug** that gets created, a required `Logger` file. This gives us access to:
```lua
Logger:PlugInfo(plug, "Hello!") -- <==> print(("[%s %s] %s"):format(plug.Icon or "", plug.Name, "Hello!"))
Logger:PlugWarn(plug, "Uh Oh!") -- <==> warn(("[%s %s] %s"):format(plug.Icon or "", plug.Name, "Hello!"))
```
This is just a nice way to print to the output, and show the **Plug** scope it came from. This is the same API used for when **Socket** detects an issue with a **Plug** and wants to inform the user (e.g., a required Field is missing its value)

### Using `plug` Parameter

You can reference any members of `plug` (see [PlugDefinition](/api/PlugDefinition)) - most notably `plug.State` (see [PlugState](/api/PlugDefinition#PlugState))

#### `plug.State.IsRunning`

We can use this value to toggle the state of our **Plug**, so we can have a routine that gets toggled on/off. You can easily declare your own variable in `plug.State` to do this, but using `IsRunning` will give us some nice feedback on the *Widget* UI.

#### `plug.State.FieldValues`

This is where we access the values of our fields, and make use of them. If we have declared a field such as:
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
We can access the value via
`local amount = plug.State.FieldValues.Amount`
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
If `IsRequired=true`, we will get a `Logger:PlugWarn` in our output if the field does not have a defined value. We can assume it exists in our `Function` now!

A nice trick we can do is if we want to declare a default value for a Field, we can create the following structure in our [PlugDefinition](/api/PlugDefinition)
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

Imagine we have a **Plug** that is running routines (`IsRunning=true`), but we then delete the `ModuleScript` for that **Plug**, or we close the [Plugin]? We could still have code running that would've normally been stopped by toggling the **Plug**. This is where [BindToClose](/api/PlugDefinition#BindToClose) comes in.

Example:
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
The loop would stop without the existence of `BindToClose`
:::

## Midas Touch **Plug**

Lets go through an example here by creating a **Plug** that makes parts look golden.

### Create the Plug

We'll start off by placing a `ModuleScript` at `game.ServerStorage.SocketPlugin.Plugs.MidasTouch`:
```lua
---
---Midas Touch
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
    Group = "Golden",
    Name = "Midas Touch",
    Description = "Makes parts gold",
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
    Logger:PlugInfo(plug, "I command you to make parts golden!")
end

return plugDefinition

```
**Result:**

![image](/midas_touch_1.png)

### Make it pretty

This is looking a touch bland on our *Widget*, lets juice it up a bit.
```lua
local plugDefinition = {
	Group = "Golden",
	GroupColor = Color3.fromRGB(255, 180, 0),
	GroupIcon = "👑",
	Name = "Midas Touch",
	Icon = "🤏";
	Description = "Makes parts gold",
}
```
**Better!**

![image](/midas_touch_2.png)

### v1

The **Plug** currently doesn't do anything, other than print a silly message to the output window. Lets make it so when we run the *Midas Touch* **Plug**, it will make any parts that we have selected turn to gold:
```lua
---
---Midas Touch
---

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection")
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
local COLOR_GOLD = Color3.fromRGB(255, 180, 0)

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
	Group = "Golden",
	GroupColor = COLOR_GOLD,
	GroupIcon = "👑",
	Name = "Midas Touch",
	Icon = "🤏";
	Description = "Converts any parts we have selected turn to gold",
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
	-- Get our selected instances, and filter out any non-parts
	local selectedInstances = Selection:Get()
	local parts = {}
	for _,instance in pairs(selectedInstances) then
		if instance:IsA("BasePart") then
			table.insert(parts, instance)
		end
	end

	-- Apply a gold finish to each part
	for _,part in pairs(parts) do
		part.Color = COLOR_GOLD
		part.Material = Enum.Material.Foil
	end

    Logger:PlugInfo(plug, ("I encrusted %d parts with gold!"):format(#parts))
end

return plugDefinition

```
**Cool!**

![image](/midas_touch_3.png)

### v2

#### Automatic Undo

v1 was all well and good, but what if I accidentally gold-ify a part that I didn't want to? We need to setup `ChangeHistoryService` waypoints to implement this, or we can simply do:
```lua
EnableAutomaticUndo = true
```

#### More colors

I'm also not super happy with it always being the same color; lets add 2 color fields that we will uniformly interpolate between.
```lua
{
	Fields = {
		{
			Name = "Color1",
			Type = "Color3",
			IsRequired = true,
		},
		{
			Name = "Color2",
			Type = "Color3",
			IsRequired = true,
		},
	}
}
```

![image](/midas_touch_4.png)

#### Realtime

Finally, I don't want to have to click Run, or use a Keybind, to make a part gold. I want to
1. Make the **Plug** toggleable
2. Whenever the **Plug** is running, any parts I select will turn to gold in realm time.

Lets write some code to make this happen..
```lua
---
---Midas Touch
---

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection")
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
local COLOR_GOLD = Color3.fromRGB(255, 180, 0)

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
	Group = "Golden",
	GroupColor = COLOR_GOLD,
	GroupIcon = "👑",
	Name = "Midas Touch",
	Icon = "🤏";
	Description = "Converts any parts we have selected turn to gold",
	EnableAutomaticUndo = true,
	Fields = {
		{
			Name = "Color1",
			Type = "Color3",
			IsRequired = true,
		},
		{
			Name = "Color2",
			Type = "Color3",
			IsRequired = true,
		},
	},
	State = {
		IsRunning = false,
	},
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
	-- Toggle running
	plug.State.IsRunning = not plug.State.IsRunning
	
	-- Get Variables
	local isRunning = plug.State.IsRunning
	local color1 = plug.State.FieldValues.Color1
	local color2 = plug.State.FieldValues.Color2
	
	if isRunning then
		plug.State.SelectionChangedConnection = Selection.SelectionChanged:Connect(function()
			-- Get our selected instances, and filter out any non-parts
			local selectedInstances = Selection:Get()
			local parts = {}
			for _,instance in pairs(selectedInstances) do
				if instance:IsA("BasePart") then
					table.insert(parts, instance)
				end
			end
			
			-- Apply a gold finish to each part
			for _,part in pairs(parts) do
				part.Color = color1:Lerp(color2, math.random())
				part.Material = Enum.Material.Foil
			end
			
			if #parts > 0 then
				Logger:PlugInfo(plug, ("I encrusted %d parts with gold!"):format(#parts))
			end
		end)
	else
		plug.State.SelectionChangedConnection:Disconnect()
		plug.State.SelectionChangedConnection = nil
	end
end

return plugDefinition
```
**Fantastic**

![image](/midas_touch_v2.gif)

### v3

With v2, if we close **Socket** while running the *Midas Touch* **Plug**, we will be encrusting parts forever as we never toggle the **Plug** back. The Solution:
```lua
---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.BindToClose = function(plug, plugin)
	if plug.State.SelectionChangedConnection then
		plug.State.SelectionChangedConnection:Disconnect()
		plug.State.SelectionChangedConnection = nil
	end
end
```

#### Our Final Plug
```lua
---
---Midas Touch
---

--------------------------------------------------
-- Dependencies
local Selection = game:GetService("Selection")
local ServerStorage = game:GetService("ServerStorage") ---@type ServerStorage
local Utils = ServerStorage.SocketPlugin:FindFirstChild("Utils")
local Logger = require(Utils.Logger) ---@type Logger

--------------------------------------------------
-- Constants
local COLOR_GOLD = Color3.fromRGB(255, 180, 0)

--------------------------------------------------
-- Members

---@type PlugDefinition
local plugDefinition = {
	Group = "Golden",
	GroupColor = COLOR_GOLD,
	GroupIcon = "👑",
	Name = "Midas Touch",
	Icon = "🤏";
	Description = "Converts any parts we have selected turn to gold",
	EnableAutomaticUndo = true,
	Fields = {
		{
			Name = "Color1",
			Type = "Color3",
			IsRequired = true,
		},
		{
			Name = "Color2",
			Type = "Color3",
			IsRequired = true,
		},
	},
	State = {
		IsRunning = false,
	},
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
	-- Toggle running
	plug.State.IsRunning = not plug.State.IsRunning
	
	-- Get Variables
	local isRunning = plug.State.IsRunning
	local color1 = plug.State.FieldValues.Color1
	local color2 = plug.State.FieldValues.Color2
	
	if isRunning then
		plug.State.SelectionChangedConnection = Selection.SelectionChanged:Connect(function()
			-- Get our selected instances, and filter out any non-parts
			local selectedInstances = Selection:Get()
			local parts = {}
			for _,instance in pairs(selectedInstances) do
				if instance:IsA("BasePart") then
					table.insert(parts, instance)
				end
			end
			
			-- Apply a gold finish to each part
			for _,part in pairs(parts) do
				part.Color = color1:Lerp(color2, math.random())
				part.Material = Enum.Material.Foil
			end
			
			if #parts > 0 then
				Logger:PlugInfo(plug, ("I encrusted %d parts with gold!"):format(#parts))
			end
		end)
	else
		plug.State.SelectionChangedConnection:Disconnect()
		plug.State.SelectionChangedConnection = nil
	end
end

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.BindToClose = function(plug, plugin)
	if plug.State.SelectionChangedConnection then
		plug.State.SelectionChangedConnection:Disconnect()
		plug.State.SelectionChangedConnection = nil
	end
end

return plugDefinition
```