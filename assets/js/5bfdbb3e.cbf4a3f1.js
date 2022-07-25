"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[165],{64449:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetFieldValue","desc":"Sugar for\\n```lua\\nmacro.State.FieldValues[fieldName]\\n```","params":[{"name":"fieldName","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"any"}],"function_type":"method","tags":["Read-Only"],"source":{"line":269,"path":"docs_api/macro_definition.lua"}},{"name":"ToggleIsRunning","desc":"Sugar for\\n```lua\\nmacro.State.IsRunning = not macro.State.IsRunning\\nif not macro.State.IsRunning then\\n    macro.RunJanitor:Cleanup()\\nend\\n```","params":[],"returns":[],"function_type":"method","tags":["Read-Only"],"source":{"line":370,"path":"docs_api/macro_definition.lua"}},{"name":"IsRunning","desc":"Returns true if the Macro is running (`macro.State.IsRunning == true`). False otherwise.\\n\\nSugar for\\n```lua\\nmacro.State.IsRunning\\n```","params":[],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","tags":["Read-Only"],"source":{"line":384,"path":"docs_api/macro_definition.lua"}},{"name":"Function","desc":"The function that will be called when we Run the Macro.\\n\\n:::caution\\nThis function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent\\n:::","params":[{"name":"macro","desc":"","lua_type":"MacroDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","tags":["Required"],"source":{"line":398,"path":"docs_api/macro_definition.lua"}},{"name":"BindToClose","desc":"This is a function that is called when:\\n1. The Socket Plugin is exited\\n2. The Macro is removed while the Socket Plugin is running\\n\\nUse this to clean anything up instantiated by the Macro\\n\\n:::caution\\nThis function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent\\n:::\\n\\nOrder of operations:\\n1) `BindToClose` is called\\n2) `macro.State.IsRunning = false`\\n3) `macro.RunJanitor:Cleanup()`","params":[{"name":"macro","desc":"","lua_type":"MacroDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","source":{"line":420,"path":"docs_api/macro_definition.lua"}},{"name":"BindToOpen","desc":"This is a function that is called when the Socket plugin is started! This has some rare use cases.\\n\\nFor the most part, Socket is really good at calling `BindToClose` when it is needed, but there are some Roblox limitations.\\nImagine we have a macro that makes significant changes in `game.Workspace` (e.g., changes the `Color3` of part(s)). If Roblox Studio\\nis suddenly closed, or crashes, it\'s possible the changes the macro made will be saved, but the \\"stopping\\" logic is never run. `BindToOpen` can\\nbe used to run checks to cleanup any mess left from the previous session. This is more a failsafe than a requirement, but can save headaches!\\n\\nFor a good example use-case, see the Socket Core Macro `.Locked`\\n\\n:::caution\\nThis function is not allowed to yield; wrap any yielding routines in a `task.spawn` or equivalent\\n:::","params":[{"name":"macro","desc":"","lua_type":"MacroDefinition"},{"name":"plugin","desc":"","lua_type":"Plugin"}],"returns":[],"function_type":"static","source":{"line":440,"path":"docs_api/macro_definition.lua"}}],"properties":[{"name":"Name","desc":"Declares the name that will appear on the Widget for the Macro.\\n\\n:::caution\\nLonger names will be less readable on the Widget, depending on a user\'s resolution\\n:::","lua_type":"string","tags":["Required"],"source":{"line":24,"path":"docs_api/macro_definition.lua"}},{"name":"NameColor","desc":"Give your Macro a pretty color on the Widget!\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","tags":["Populated"],"source":{"line":34,"path":"docs_api/macro_definition.lua"}},{"name":"Icon","desc":"Defines an icon to put alongside the `Name` of the Macro.\\n\\nThis can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxasset`\\n\\n```lua\\n{\\n    Icon = \\"\ud83d\udcc2\\" -- Good\\n    Icon = \\"My Icon\\" -- Probably too long, but good\\n    Icon = \\"\\" -- Bit boring, but good\\n    Icon = \\"rbxassetid://9553550332\\" -- Good ImageId\\n    Icon = \\"https://www.roblox.com/library/9553550338/\\" -- Bad ImageId (Website)\\n    Icon = \\"http://www.roblox.com/asset/?id=9553550332\\" -- Bad ImageId (Decal)\\n}\\n```\\n\\nDefaults to `\\"\u2753\\"`","lua_type":"string","tags":["Populated"],"source":{"line":57,"path":"docs_api/macro_definition.lua"}},{"name":"IconColor","desc":"Give your Macro icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","tags":["Populated"],"source":{"line":67,"path":"docs_api/macro_definition.lua"}},{"name":"Group","desc":"The group that the Macro belongs to. Any macros with a matching `Group` value will be grouped together on the Widget\\n\\nDefaults to `\\"No Group\\"`","lua_type":"string","tags":["Populated"],"source":{"line":77,"path":"docs_api/macro_definition.lua"}},{"name":"GroupColor","desc":"Give the `Group` text a pretty color on the Widget! If you have multiple Macros under the same `Group`, `GroupColor` need only be defined\\non a singular `MacroDefinition`.\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","tags":["Populated"],"source":{"line":88,"path":"docs_api/macro_definition.lua"}},{"name":"GroupIcon","desc":"Defines an icon to put alongside the name of the `Group` the Macro is under. If you have multiple Macros under the same `Group`, `GroupIcon` need only be defined\\non a singular `MacroDefinition`\\n\\nThis can either be `Text` (e.g., Emoji) or an `ImageId`. `ImageIds` are recognised by the string containing `rbxasset`\\n\\n```lua\\n{\\n    Icon = \\"\ud83d\udcc2\\" -- Good\\n    Icon = \\"My Icon\\" -- Probably too long, but good\\n    Icon = \\"\\" -- Bit boring, but good\\n    Icon = \\"rbxassetid://9553550332\\" -- Good ImageId\\n    Icon = \\"https://www.roblox.com/library/9553550338/\\" -- Bad ImageId (Website)\\n    Icon = \\"http://www.roblox.com/asset/?id=9553550332\\" -- Bad ImageId (Decal)\\n}\\n```\\n\\nDefaults to `\\"\u2753\\"`","lua_type":"string","tags":["Populated"],"source":{"line":112,"path":"docs_api/macro_definition.lua"}},{"name":"GroupIconColor","desc":"Give your Macro icon a pretty color on the Widget! Applies to `TextColor3` or `ImageColor3`, depending on `Icon` input. If you have multiple Macros under the \\nsame `Group`, `GroupIconColor` need only be defined on a singular `MacroDefinition`\\n\\nDefaults to `Color.fromRGB(255, 255, 255)`","lua_type":"Color3","tags":["Populated"],"source":{"line":123,"path":"docs_api/macro_definition.lua"}},{"name":"Description","desc":"Any and all information pertaining to this specific Macro. This can be as long as you like as it appears in the output.\\n\\n```lua\\n{\\n    Description = \\"Macro Description Line 1\\\\nMacro Description Line 2\\"\\n}\\n```\\n\\nOutput:\\n```\\n================ Macro Name (Macro Group) | DESCRIPTION ================ \\n\\nMacro Description Line 1\\nMacro Description Line 2\\n\\n================ Macro Name (Macro Group) | DESCRIPTION ================\\n```\\n\\nDefaults to `\\"No Description\\"`","lua_type":"string","tags":["Populated"],"source":{"line":149,"path":"docs_api/macro_definition.lua"}},{"name":"LayoutOrder","desc":"Can be used to define the position of where the Macro is rendered on the Widget. Higher numbers are rendered further down the widget. Works very much the same\\nas `LayoutOrder` on Roblox Instances.\\n\\nSee [Settings](/api/SocketSettings#SortType)\\n\\nDefaults to `0`","lua_type":"number","tags":["Populated"],"source":{"line":162,"path":"docs_api/macro_definition.lua"}},{"name":"EnableAutomaticUndo","desc":"If `true`, will automatically setup `ChangeHistoryService` waypoints before and after running the **Macro\'s** `Function`. AKA, any changes\\nto studio that your Macro makes, you can undo with `Ctrl+Z` or equivalent.\\n\\nYou can obviously set this to `false` (or don\'t declare the field) if you want to write your own implementation.\\n\\n:::tip\\nWhen you run \\"Undo\\" in Studio, it will undo the last change under the `DataModel` (`game`). If, for example, your Macro just prints to the output (and doesn\'t\\nmake any changes to the `DataModel`) it will undo the last change unrelated to your Macro\\n:::\\n\\nDefaults to `false`","lua_type":"boolean","tags":["Populated"],"source":{"line":180,"path":"docs_api/macro_definition.lua"}},{"name":"IgnoreGameProcessedKeybinds","desc":"Socket uses [UserInputService#InputBegan] for detecting keybinds.\\n```\\ngame:GetService(\\"UserInputService\\").InputBegan:Connect(function(inputObject, gameProcessedEvent)\\n    if gameProcessedEvent and not IgnoreGameProcessedKeybinds then\\n        return\\n    end\\n\\n    ...\\nend)\\n```\\n\\nDefaults to `false`","lua_type":"boolean","tags":["Populated"],"source":{"line":199,"path":"docs_api/macro_definition.lua"}},{"name":"AutoRun","desc":"If `true`, `macro.Function` will be called when Socket starts. Useful if there is a macro you want to run on startup.\\n\\nDefaults to `false`","lua_type":"boolean","tags":["Populated"],"source":{"line":209,"path":"docs_api/macro_definition.lua"}},{"name":"Keybind","desc":"An array of `Enum.KeyCode` that can trigger the Macro to run.\\n```lua\\n{\\n    Keybind = { Enum.KeyCode.LeftControl, Enum.KeyCode.J }\\n}    \\n```\\n\\n:::tip\\nWill not work if any of the inputs have `gameProcessedEvent` set to true. See: [UserInputService]\\n\\nTo disable this, see [TODO]\\n:::\\n\\nDefaults to `{}`","lua_type":"{Enum.KeyCode}","tags":["Populated"],"source":{"line":230,"path":"docs_api/macro_definition.lua"}},{"name":"Fields","desc":"An array of [MacroField], which define the different fields the Macro has. The order they are defined is the order they will appear\\non the widget.\\n```lua\\n{\\n    Fields = { \\n        {\\n            Name = \\"Amount\\";\\n            Type = \\"number\\";\\n            IsRequired = true;\\n        },\\n        {\\n            Name = \\"Title\\";\\n            Type = \\"string\\";\\n        }\\n    }\\n}    \\n```\\n\\nDefaults to `{}`","lua_type":"{MacroField}","tags":["Populated"],"source":{"line":256,"path":"docs_api/macro_definition.lua"}},{"name":"FieldChanged","desc":"A `BindableEvent` to listen to field values being changed on the UI!\\n```\\nmacro.FieldChanged.Event:Connect(function(fieldName, fieldValue)\\n    print(macro:GetFieldValue(fieldName) == fieldValue)\\nend)\\n\\n-- Output: true\\n```\\n\\nMost cases it will suffice to just read `macro:GetFieldValue(fieldName)` as and when you need a field value. But sometimes you may want to re-run routines\\nafter a field value change.","lua_type":"BindableEvent","tags":["Read-Only"],"source":{"line":287,"path":"docs_api/macro_definition.lua"}},{"name":"State","desc":"A persistent `State` of the Macro while the Socket plugin is running. We can write to this inside the `MacroDefinition`, and\\nread/write to it in our `Function` and `BindToClose/BindToOpen` functions.\\n\\nWe can declare default values for fields:\\n```lua\\n{\\n    Fields = {\\n        {\\n            Name = \\"Size\\";\\n            Type = \\"Vector3\\";\\n        }\\n    }\\n    State = {\\n        FieldValues = {\\n            Size = Vector3.new(2, 2, 2); -- Will automatically appear on the Widget\\n        }\\n    }\\n}\\n```\\n\\nWe can also access `IsRunning`:\\n```lua\\nlocal Heartbeat = game:GetService(\\"RunService\\").Heartbeat\\n\\n-- MacroDefinition that, when running, will print the time since the last frame\\n{\\n    Function = function(macro, plugin)\\n        -- Toggle running state\\n        macro:ToggleIsRunning()\\n    \\n        -- Running routine\\n        if macro:IsRunning() then\\n            -- Add to our RunJanitor\\n            -- Automatically gets cleaned up when we toggle IsRunning to false via ToggleIsRunning\\n            -- Also gets cleaned up when BindToClose is called\\n            macro.RunJanitor:Add(Heartbeat:Connect(function(dt)\\n                Logger:MacroInfo(macro, (\\"dt: %f\\"))\\n            end))\\n        end\\n    end\\n}\\n```\\n\\nDefaults to\\n```\\n{\\n    FieldValues = {};\\n    IsRunning = false;\\n    _Server = {};\\n    _Client = {};\\n}\\n```","lua_type":"MacroState","tags":["Populated"],"source":{"line":346,"path":"docs_api/macro_definition.lua"}},{"name":"RunJanitor","desc":"A [Janitor](https://github.com/howmanysmall/Janitor) object, intended to be used to cleanup tasks after a macro stops running.\\n\\nIs automatically cleaned up when using `macro:ToggleIsRunning()`, and on `BindToClose`","lua_type":"Janitor","tags":["Read-Only"],"source":{"line":356,"path":"docs_api/macro_definition.lua"}},{"name":"Disabled","desc":"If `true`, this Macro will not be displayed on the Widget. It\'s `Function` will also not be required, nor registered. This renders `AutoRun` useless\\nfor this specific [MacroDefinition](/api/MacroDefinition)\\n\\n:::tip\\nThis can be useful to create a [MacroDefinition](/api/MacroDefinition) solely for defining the aesthetics of a `Group` for organisation purposes.\\n\\n```lua\\n    {\\n        Group = \\"Fruity Macros\\",\\n        GroupIcon = \\"\ud83c\udf4e\\",\\n        GroupColor = Color3.fromRGB(200, 20, 20),\\n        Disabled = true,\\n    }\\n```\\n:::\\n\\nDefaults to `false`","lua_type":"boolean","tags":["Populated"],"source":{"line":464,"path":"docs_api/macro_definition.lua"}}],"types":[{"name":"MacroState","desc":"A table to store a macro\'s \\"State\\". Socket writes some stuff here, but feel free to use this for whatever you need. If you overwrite any\\nkeys that Socket uses (fields defined here), expect mayhem and tears!","fields":[{"name":"FieldValues","lua_type":"table<MacroField.Name,any>","desc":"Where we can read the values in our fields from"},{"name":"IsRunning","lua_type":"boolean|nil","desc":"Use this variable to toggle the state of a Macro (updates the UI)"},{"name":"IsKeybindDisabled","lua_type":"boolean|nil","desc":"An internal variable for declaring whether a keybind has been disabled or not"},{"name":"_Server","lua_type":"MacroState","desc":"Socket-only (used for communcicating Server/Client in Accurate Play Solo)"},{"name":"_Client","lua_type":"MacroState","desc":"Socket-only (used for communcicating Server/Client in Accurate Play Solo)"}],"source":{"line":114,"path":"docs_api/sub_definitions.lua"}}],"name":"MacroDefinition","desc":"This is how we define the behaviour of a Macro.\\n\\nThere are a few `Required` members for a [MacroDefinition] to be valid.\\n\\nMany fields are `Populated`, where if it is not defined in your [MacroDefinition], will be auto-filled by Socket with a default value.\\n\\nThere are some `Read-Only` fields, that you\'ll want to avoid defining in your [MacroDefinition] and let them be `Populated` by Socket.","source":{"line":12,"path":"docs_api/macro_definition.lua"}}')}}]);