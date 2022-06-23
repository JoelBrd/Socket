---
sidebar_position: 4
---

# Examples
## Example 1 | Midas Touch Plug

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

The **Plug** currently doesn't do anything, other than print a silly message to the output window. Lets make it so when we run the **Plug**, it will make any parts that we have selected turn golden:
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
{
    -- ...
    EnableAutomaticUndo = true
    -- ...
}
```

#### More colors

I'm also not super happy with it always being the same color; lets add 2 color fields that we will uniformly interpolate between.
```lua
{
	Fields = {
		{
			Name = "ColorA",
			Type = "Color3",
			IsRequired = true,
		},
		{
			Name = "ColorB",
			Type = "Color3",
			IsRequired = true,
		},
	}
}
```

![image](/midas_touch_4.png)

#### Real time

Finally, I don't want to have to click Run, or use a Keybind, to make a part gold. I want to
1. Make the **Plug** toggleable
2. Whenever the **Plug** is running, any parts I select will turn to gold in real time.
3. Define routines so they'll get cleaned up safely

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
			Name = "ColorA",
			Type = "Color3",
			IsRequired = true,
		},
		{
			Name = "ColorB",
			Type = "Color3",
			IsRequired = true,
		},
	},
}

---@param plug PlugDefinition
---@param plugin Plugin
plugDefinition.Function = function(plug, plugin)
	-- Toggle running
    plug:ToggleIsRunning()

    -- RETURN: Not running
    if not plug.State.IsRunning then
        return
    end
	
	-- Get Variables
	local colorA = plug:GetFieldValue("ColorA")
	local colorB = plug:GetFieldValue("ColorB")

    -- Setup Loop
    plug.RunJanitor:Add(Selection.SelectionChanged:Connect(function()
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
			part.Color = colorA:Lerp(colorB, math.random())
			part.Material = Enum.Material.Foil
		end
		
		if #parts > 0 then
			Logger:PlugInfo(plug, ("I encrusted %d parts with gold!"):format(#parts))
		end
	end))
end

return plugDefinition
```
**Fantastic <3**

![image](/midas_touch_v2.gif)