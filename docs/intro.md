---
sidebar_position: 1
---

# Introduction

## Content

- [Installation guide](/docs/Installation)

## What is Socket?

**Socket** is a Roblox plugin that allows us to easily run code in Roblox Studio.

#### Why do I need **Socket** when I have the **Command Line**?
You can run code through the command line, but you're limited to this interface:

![image](/command_line.png)

This interface is much nicer, don't you think?

![image](/widget_interface.png)

**Socket** is a macro manager; we can pre-define code, and run it via the Run buttons on the Widget. There is functionality to run these *"macros"* via a keybind,
we can define fields values for our macros to use and more.

There are other tools out there that provide this *"macro manager"* functionality, so why use **Socket**?

## Why Socket?
:::info
The desire to create Socket came from wanting a plugin that could have the functionality of multiple plugins. You could just add multiple buttons to the plugin toolbar,
but this doesn't scale well. Introducing Socket!

We call individual macros "Plugs", as a Plug will Plug-in to a Socket IRL
:::

### Organisation

**Socket** allows you to organise your **Plugs** into different groups, and easily view/access/run them. It mirrors the functionality of the *Explorer* tab with it's layout and ability to expand/collapse objects. You can also *search* through your **Plugs** to find what you're looking for in an instant.

### Customisation

While the **Socket** plugin adheres to your Studio theme, you can customise each **Group** and **Plug** as well as general settings!
* Names
* Icons (`Text` and `ImageId`)
* Colors (`TextColor3` and `ImageColor3`)
* Sort Order
* Fields
* Keybinds
* Font
* Default State
* UI Scaling

![image](/widget_customised.png) ![image](/settings.png)

### Uses ModuleScripts

The way you define **Plugs** and add/remove/change them is via `ModuleScripts`! There is a `game.ServerStorage.SocketPlugin` directory where you can place multiple **Plugs** and any *utility* `ModuleScripts`.
* Easy management of your **Plugs** through both the *Widget* and *Explorer* tab
* Reroute logic to *Util* files that multiple **Plugs** can access
* Use the Roblox Studio script editor to write your code
* Easily share **Plugs** between all team members on *Team Create*
* Sync your **Plugs** via [Rojo](https://rojo.space/) (!!!)

### Ergonomics

Want to give some instructions on how to use your **Plug** incase your distributing it, or plan to use it 2 weeks from now? You can add a [Description](/api/PlugDefinition#Description) that can be easily viewed in 1 Click via the *Widget*.

Whenever you make a change to a **Plug**, it will automatically update the *Widget*. If any changes break the integrity of the `ModuleScript`, **you will be warned!**

It can be cumbersome to make changes whenever you want to alter the functionality of your **Plug** - `Fields` come to the rescue! You can define field values on the *Widget* that can then be read from instantly in your **Plug** [Function](/api/PlugDefinition#Function)

### Automation

There is an obvious hint at automation with any kind of *"macro manager"*, but with **Socket** specifically:
* 1 Click to run any of your **Plugs**
* Define a *Keybind* to run a **Plug** without using the *Widget*!
* Toggleable **Plugs** to turn routines on/off as you please

**Toggleable Plugs** (See: [PlugState](/api/PlugDefinition#PlugState))

![image](/hello_world_off.png) -> ![image](/hello_world_on.png)

### Server/Client Runners

When playtesting, you have the option to run your **Plugs** on the *Server* or *Client*. Super useful for checking `Client -> Server` security.

![image](/server_client.png)



