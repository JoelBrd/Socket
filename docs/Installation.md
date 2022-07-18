---
sidebar_position: 2
---

# Installation

### Method 1 - Plugin

Download the plugin [here](https://www.roblox.com/library/9988470603/Socket) via Roblox

### Method 2 - Git

If you don't trust Method 1 (I get it!), you can download the [repo](https://github.com/JoelBrd/Socket) and compile the plugin yourself!

#### (1) Clone the repository to your local machine

1. Open up the terminal
2. Route to your desired directory
3. Run `git clone https://github.com/JoelBrd/Socket`

:::info
Unsure what the terminal is? Wonder how to route to a desired directory? Got no idea what `git` is? Check [this video](https://www.youtube.com/watch?v=X5e3xQBeqf8&ab_channel=ElektorTV) out, or strongly consider using **Method 1**
:::

#### (2) Use [Wally](https://wally.run/) to download the dependencies

Socket uses [Roact](https://roblox.github.io/roact/), [Rodux](https://github.com/Roblox/rodux), [Roact-Rodux](https://roblox.github.io/roact-rodux/guide/usage/),
[Promise](https://github.com/evaera/roblox-lua-promise) and [Janitor](https://github.com/howmanysmall/Janitor)!

1. Download [Wally](https://wally.run/) onto your machine
2. Open `...\Socket\src\Shared\Libraries` in the terminal 
3. Run the comamnd `wally install`

#### (3) Use [Rojo](https://rojo.space/) to sync the project onto a Roblox Studio place

Please see the [Rojo Docs](https://rojo.space/docs/v7/) on how to do this

#### (4) Compile the plugin

1. Select `game.ServerScriptService.SocketPlugin` **and** `game.ServerScriptService.SocketPlugin.PluginFramework`
2. Right Click `game.ServerScriptService.SocketPlugin` -> Save as Local Plugin
3. After selecting a name and saving, **Socket** should appear on your plugin toolbar!