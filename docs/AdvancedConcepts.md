---
sidebar_position: 5
---

# Advanced Concepts

You may wish to create some Plugs that have rather complex functionality. Socket tries its best to give you the tools you need. Socket was developed
alongside some non-trivial Plugs which helped flesh out what may be needed, but there may still be some stuff missing - either from oversight, or lack of Roblox
support.

:::tip
Something missing that you need? Feel free to fork the repo and push a PR! Check out [Contributions](/docs/Contributing)
:::

## Run on Startup
You may want some routines that are always running in the background to bolster your workflow (e.g., ensuring no parts are `Anchored=false` under a specific directory)

You can declare `AutoRun=true` in your [PlugDefinition](/api/PlugDefinition) to allow this.
:::note
This functionality can be enabled/disabld in the [Settings](/api/SocketSettings#EnableAutoRun)
:::

:::caution
This may cause unintended behaviour in Team Create, as the same code may be being ran on multiple clients
:::

## Group Aesthetics
For organisation purposes, you may not like having a random [PlugDefinition](/api/PlugDefinition) defining the aesthetics of the Group it is under. Check out [Disabled](/api/PlugDefinition#Disabled) for more information

## Undo/Redo
You have to option to add [EnableAutomaticUndo](/api/PlugDefinition#EnableAutomaticUndo), so if running your Plug makes any changes they can be undone. Your Plug may
need something more advanced than this though (see the "Dot to Dot" plug, where you can undo/redo the placement of nodes) where while it's running will make multiple
changes. In these kind of cases, you'll want to use [ChangeHistoryService](https://developer.roblox.com/en-us/api-reference/class/ChangeHistoryService) directly.

## Messy Plugs
"Messy Plug" meaning a Plug that makes multiple changes/additions while it's running (e.g., add new Instances to `game.Workspace`). Good examples of these are ".Locked" and "Dot to Dot".

### RunJanitor
[Janitor](/api/Janitor) is a very useful class; it's implementation into Socket allows us to pass Instances/Functions/Connections that will be cleaned up when a
Plug stops running. See [RunJanitor](/api/PlugDefinition#RunJanitor) for more details, along with [ToggleIsRunning](/api/PlugDefinition#ToggleIsRunning) and
[BindToClose](/api/PlugDefinition#BindToClose)

### Edge cases for cleaning up

#### BindToClose
When we have a toggleable Plug, that can be turned on/off (indicated on the Widget by a green "Running" button), it's could be messy while it is running. We could
clean stuff up when we click the Run button again (calls [Function](/api/PlugDefinition#Function)), but what if we close Socket or delete the ModuleScript linked
to that Plug? In these cases, [BindToClose](/api/PlugDefinition#BindToClose) should always be utilised for cleaning stuff up for edge cases.

#### BindToOpen
Unfortunately, there is a limitation where we cannot detect when Roblox Studio closes (and some cases when a Plugin is closed). Imagine we have a Plug running that turns
some parts pink, and studio crashes. If we are on Team Create, when we rejoin those parts will be pink.. but the code that would've reverted this change is not running,
and has no knowledge that it should clean up these pink parts!

[BindToOpen](/api/PlugDefinition#BindToClose) saves the day; whenever a Plug is first initiated (Plugin start, ModuleScript added) we run `BindToOpen`. Here you can
put safety routines to ensure any mess from a bad session end is cleaned up. For an example implementation, check out the source of the ".Locked" Plug which utilises
[CollectionService](https://developer.roblox.com/en-us/api-reference/class/CollectionService) to tag Instances that it has made changes to.

## TeamCreate
Socket was designed to try accomodate for Team Create, with multiple team members using Socket at the same time. [InstanceUtil](/api/InstanceUtil) has some *very* useful methods for accomodating for this. Take a look at "Dot to Dot" and the heirachy of Instances it creates in `game.Workspace`.