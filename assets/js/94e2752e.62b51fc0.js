"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[8],{56553:function(e){e.exports=JSON.parse('{"functions":[{"name":"GetFieldValue","desc":"Sugar for\\n```lua\\nplug.State.FieldValues[fieldName]\\n```","params":[{"name":"fieldName","desc":"","lua_type":"string"}],"returns":[],"function_type":"method","source":{"line":214,"path":"docs_api/plug_definition.lua"}},{"name":"ToggleIsRunning","desc":"Sugar for\\n```lua\\nplug.State.IsRunning = not plug.State.IsRunning\\nif not plug.State.IsRunning then\\n    plug.RunJanitor:Cleanup()\\nend\\n```","params":[],"returns":[],"function_type":"method","source":{"line":318,"path":"docs_api/plug_definition.lua"}},{"name":"Function","desc":"The function that will be called when we Run the **Plug**.\\n\\n:::caution\\nThis function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent\\n:::","params":[{"name":"plug","desc":"","lua_type":"PlugDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","tags":["Required"],"source":{"line":332,"path":"docs_api/plug_definition.lua"}},{"name":"BindToClose","desc":"This is a function that is called when:\\n1. The Socket Plugin is exited\\n2. The **Plug** is removed while the Socket Plugin is running\\n\\nUse this to clean anything up instantiated by the **Plug**\\n\\n:::tip\\nAlong with `BindToClose` being called, we also set `IsRunning=false`\\n:::\\n:::caution\\nThis function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent\\n:::","params":[{"name":"plug","desc":"","lua_type":"PlugDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","source":{"line":352,"path":"docs_api/plug_definition.lua"}},{"name":"BindToOpen","desc":"This is a function that is called when the Socket plugin is started! This has some rare use cases.\\n\\nFor the most part, Socket is really good at calling `BindToClose` when it is needed, but there are some Roblox limitations.\\nImagine we have a plug that makes significant changes in `game.Workspace` (e.g., changes the `Color3` of part(s)). If Roblox Studio\\nis suddenly closed, or crashes, it\'s possible the changes the plug made will be saved, but the stopping logic is never ran. `BindToOpen` can\\nbe used to run checks to cleanup any mess left from the previous session. This is more a failsafe than a requirement, but will save headaches!\\n\\nFor a good example use-case, see the Socket Core Plug `.Locked`","params":[{"name":"plug","desc":"","lua_type":"PlugDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","source":{"line":368,"path":"docs_api/plug_definition.lua"}}],"properties":[{"name":"Name","desc":"Declares the name that will appear on the Widget for the **Plug**.\\n\\n:::caution\\nLonger names will be less readable on the Widget, depending on a user\'s resolution\\n:::","lua_type":"string","tags":["Required"],"source":{"line":18,"path":"docs_api/plug_definition.lua"}},{"name":"NameColor","desc":"Give your **Plug** a pretty color on the Widget!\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","source":{"line":27,"path":"docs_api/plug_definition.lua"}},{"name":"Icon","desc":"Defines an icon to put alongside the `Name` of the **Plug**.\\n\\nThis can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxassetid`\\n\\n```lua\\n{\\n    Icon = \\"\ud83d\udcc2\\" -- Good\\n    Icon = \\"My Icon\\" -- Probably too long, but good\\n    Icon = \\"\\" -- Bit boring, but good\\n    Icon = \\"rbxassetid://9553550332\\" -- Good ImageId\\n    Icon = \\"https://www.roblox.com/library/9553550338/\\" -- Bad ImageId (Website)\\n    Icon = \\"http://www.roblox.com/asset/?id=9553550332\\" -- Bad ImageId (Decal)\\n}\\n```","lua_type":"string","source":{"line":47,"path":"docs_api/plug_definition.lua"}},{"name":"IconColor","desc":"Give your **Plug** icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","source":{"line":56,"path":"docs_api/plug_definition.lua"}},{"name":"Group","desc":"The group that the **Plug** belongs to. Any plugs with matching `Group` will be group together on the Widget","lua_type":"string","source":{"line":63,"path":"docs_api/plug_definition.lua"}},{"name":"GroupColor","desc":"Give a `Group` a pretty color on the Widget! If you have multiple **Plugs** under the same `Group`, `GroupColor` need only be defined\\non a singular `PlugDefinition`\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","source":{"line":73,"path":"docs_api/plug_definition.lua"}},{"name":"GroupIcon","desc":"Defines an icon to put alongside the name of the `Group` the **Plug** is under. If you have multiple **Plugs** under the same `Group`, `GroupIcon` need only be defined\\non a singular `PlugDefinition`\\n\\nThis can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxassetid`\\n\\n```lua\\n{\\n    Icon = \\"\ud83d\udcc2\\" -- Good\\n    Icon = \\"My Icon\\" -- Probably too long, but good\\n    Icon = \\"\\" -- Bit boring, but good\\n    Icon = \\"rbxassetid://9553550332\\" -- Good ImageId\\n    Icon = \\"https://www.roblox.com/library/9553550338/\\" -- Bad ImageId (Website)\\n    Icon = \\"http://www.roblox.com/asset/?id=9553550332\\" -- Bad ImageId (Decal)\\n}\\n```","lua_type":"string","source":{"line":94,"path":"docs_api/plug_definition.lua"}},{"name":"GroupIconColor","desc":"Give your **Plug** icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input. If you have multiple **Plugs** under the \\nsame `Group`, `GroupIconColor` need only be defined on a singular `PlugDefinition`\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","source":{"line":104,"path":"docs_api/plug_definition.lua"}},{"name":"Description","desc":"Any and all information pertaining to this specific **Plug**. This can be as long as you like as it appears in the output.\\n\\n```lua\\n{\\n    Description = \\"Plug Description Line 1\\\\nPlug Description Line 2\\"\\n}\\n```\\n\\nOutput:\\n```\\n================ Plug Name (Plug Group) | DESCRIPTION ================ \\n\\nPlug Description Line 1\\nPlug Description Line 2\\n\\n================ Plug Name (Plug Group) | DESCRIPTION ================\\n```","lua_type":"string","source":{"line":127,"path":"docs_api/plug_definition.lua"}},{"name":"EnableAutomaticUndo","desc":"If `true`, will automatically setup `ChangeHistoryService` waypoints before and after running the **Plug\'s** `Function`. AKA, any changes\\nto studio that your **Plug** makes, you can undo with `Ctrl+Z` or equivalent.\\n\\nYou can obviously set this to `false` (or don\'t declare the field) if you want to write your own implementation.\\n\\n:::tip\\nWhen you run \\"Undo\\" in Studio, it will undo the last change under the `DataModel` (`game`). If your **Plug** just prints to the output (and doesn\'t\\nmake any changes to the `DataModel`) it will undo your last change unrelated to your **Plug**\\n:::","lua_type":"boolean","source":{"line":142,"path":"docs_api/plug_definition.lua"}},{"name":"IgnoreGameProcessedKeybinds","desc":"Socket uses [UserInputService#InputBegan] for detecting keybinds.\\n```\\ngame:GetService(\\"UserInputService\\").InputBegan:Connect(function(inputObject, gameProcessedEvent)\\n    if gameProcessedEvent and not IgnoreGameProcessedKeybinds then\\n        return\\n    end\\n\\n    ...\\nend)\\n```","lua_type":"boolean","source":{"line":158,"path":"docs_api/plug_definition.lua"}},{"name":"AutoRun","desc":"If `true`, `plug.Function` will be called when Socket starts. Useful if there is a plug you always want running","lua_type":"boolean","source":{"line":165,"path":"docs_api/plug_definition.lua"}},{"name":"Keybind","desc":"An array of `Enum.KeyCode` that can trigger the **Plug** to run.\\n```lua\\n{\\n    Keybind = { Enum.KeyCode.LeftControl, Enum.KeyCode.J }\\n}    \\n```\\n\\n:::tip\\nWill not work if any of the inputs have `gameProcessedEvent` set to true. See: [UserInputService]\\n:::","lua_type":"{Enum.KeyCode}","source":{"line":181,"path":"docs_api/plug_definition.lua"}},{"name":"Fields","desc":"An array of `PlugField`, which define the different fields the **Plug** has\\n```lua\\n{\\n    Fields = { \\n        {\\n            Name = \\"Amount\\";\\n            Type = \\"number\\";\\n            IsRequired = true;\\n        },\\n        {\\n            Name = \\"Title\\";\\n            Type = \\"string\\";\\n        }\\n    }\\n}    \\n```","lua_type":"{PlugField}","source":{"line":203,"path":"docs_api/plug_definition.lua"}},{"name":"FieldChanged","desc":"A `BindableEvent` to listen to field values being changed on the UI!\\n```\\nplug.FieldChanged.Event:Connect(function(fieldName, fieldValue)\\n    -- plug:GetFieldValue(fieldName) === fieldValue\\nend)\\n```\\n\\nMost cases it will suffice to just read `plug:GetFieldValue(fieldName)` as and when you need a field value. But sometimes you may need to re-run some routines\\nafter a field value change.","lua_type":"BindableEvent","source":{"line":229,"path":"docs_api/plug_definition.lua"}},{"name":"State","desc":"A persistent `State` of the **Plug** while the Socket plugin is running. We can write to this inside the `PlugDefinition`, and\\nread/write to it in our `Function` and `BindToState` functions.\\n\\nWe can declare default values for fields:\\n```lua\\n{\\n    Fields = {\\n        {\\n            Name = \\"Size\\";\\n            Type = \\"Vector3\\";\\n        }\\n    }\\n    State = {\\n        FieldValues = {\\n            Size = Vector3.new(2, 2, 2);\\n        }\\n    }\\n}\\n```\\n\\nWe can also access `IsRunning`:\\n```lua\\nlocal Heartbeat = game:GetService(\\"RunService\\").Heartbeat\\n\\n-- PlugDefinition that, when running, will print the time since the last frame\\n{\\n    Fields = {\\n        {\\n            Name = \\"Timer\\";\\n            Type = \\"number\\";\\n            IsRequired = true;\\n        }\\n    }\\n    State = {\\n        IsRunning = false\\n    }\\n    Function = function(plug, plugin)\\n        -- Toggle running state\\n        plug.State.IsRunning = not plug.State.IsRunning\\n\\n        -- Get Variables\\n        local timer = plug.State.FieldValues.Timer\\n        local isRunning = plug.State.IsRunning\\n    \\n        if isRunning then\\n            plug.State.HeartbeatConnection = Heartbeat:Connect(function(dt)\\n                Logger:PlugInfo(plug, (\\"dt: %f\\"))\\n            end)\\n        elseif plug.State.HeartbeatConnection then\\n            plug.State.HeartbeatConnection:Disconnect()\\n            plug.State.HeartbeatConnection = nil\\n        end\\n    end\\n    BindToClose = function(plug, plugin)\\n        if plug.State.HeartbeatConnection then\\n            plug.State.HeartbeatConnection:Disconnect()\\n            plug.State.HeartbeatConnection = nil\\n        end\\n    end\\n}\\n```","lua_type":"PlugState","source":{"line":296,"path":"docs_api/plug_definition.lua"}},{"name":"RunJanitor","desc":"A [Janitor](https://github.com/howmanysmall/Janitor) object, intended to be used to cleanup tasks after a plug stops running.\\n\\nIs automatically cleaned up when using `plug:ToggleIsRunning()`","lua_type":"Janitor","source":{"line":305,"path":"docs_api/plug_definition.lua"}}],"types":[{"name":"PlugState","desc":"A table to store a plug\'s \\"State\\". Socket writes some stuff here, but feel free to use this for whatever you need. If you overwrite any\\nkeys that Socket uses (fields defined here), expect mayhem and tears!","fields":[{"name":"FieldValues","lua_type":"table<PlugField.Name,any>","desc":"Where we can read the values of our fields from"},{"name":"IsRunning","lua_type":"boolean|nil","desc":"Use this variable to toggle the state of a Plug (updates the UI)"},{"name":"Server","lua_type":"PlugState","desc":"Socket-only (used for communcicating Server/Client in Accurate Play Solo)"},{"name":"Client","lua_type":"PlugState","desc":"Socket-only (used for communcicating Server/Client in Accurate Play Solo)"}],"source":{"line":107,"path":"docs_api/sub_definitions.lua"}}],"name":"PlugDefinition","desc":"This is how we define the behaviour of a **Plug**","source":{"line":6,"path":"docs_api/plug_definition.lua"}}')}}]);