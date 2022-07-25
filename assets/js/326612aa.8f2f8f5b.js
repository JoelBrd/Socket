"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[850],{84593:e=>{e.exports=JSON.parse('{"functions":[],"properties":[{"name":"Font","desc":"The Font used on the widget.\\n\\nDefaults to `Enum.Font.Highway`","lua_type":"Enum.Font","source":{"line":15,"path":"docs_api/socket_settings.lua"}},{"name":"UIScale","desc":"This can be tweaked to change the scaling of the UI. Useful for users on a high DPI monitor, or a user that benefits from larger text.\\n\\nDefaults to `1`","lua_type":"number","source":{"line":24,"path":"docs_api/socket_settings.lua"}},{"name":"OpenFieldsByDefault","desc":"The widget uses toggle arrows to show/hide information. If `true`, the \\"Fields\\" sections inside macros will be open by default. Just saves the\\nuser another click.\\n\\nDefaults to `true`","lua_type":"boolean","source":{"line":34,"path":"docs_api/socket_settings.lua"}},{"name":"SortType","desc":"Can take a variety of string values to define how Macros and Groups are sorted on the widget.\\n\\n**\\"LayoutOrder\\"**\\nUses [Layout Order](/api/MacroDefinition#LayoutOrder) to define sorting. The group with the Macro with the lowest `LayoutOrder` will be at the\\ntop of the widget.\\n\\n**\\"Icon\\"**\\nWill sort Macros and Groups by their `Icon` using `<`. This results in Macros and Groups with matching Icons being grouped next to one another.\\n\\n**\\"Name\\"**\\nSorts Macros and Groups alphabetically by name. This behaviour also underlies the other sort types when there isn\'t a distinct difference (e.g., same\\n`Icon`, same `LayoutOrder`)\\n\\nDefaults to `\\"Name\\"`","lua_type":"string","source":{"line":54,"path":"docs_api/socket_settings.lua"}},{"name":"OSType","desc":"Can take a variety of string values to define the OS you are on. This is useful to translate the Ctrl/Cmd keybinds across OS types.\\n\\n**\\"Windows\\"**\\nConverts `Enum.KeyCode.LeftMeta` and `Enum.KeyCode.RightMeta` to `Enum.KeyCode.LeftControl` and `Enum.KeyCode.RightControl`\\n\\n**\\"Mac\\"**\\nConverts `Enum.KeyCode.LeftControl` and `Enum.KeyCode.RightControl` to `Enum.KeyCode.LeftMeta` and `Enum.KeyCode.RightMeta`\\n\\nDefaults to `\\"Windows\\"`","lua_type":"string","source":{"line":69,"path":"docs_api/socket_settings.lua"}},{"name":"IgnoreGameProcessedKeybinds","desc":"If `true`, will not discard [UserInputService#InputBegan] events where `gameProcessed=true`.\\n\\nDefaults to `false`","lua_type":"boolean","source":{"line":78,"path":"docs_api/socket_settings.lua"}},{"name":"EnableSocketMacros","desc":"Declares if Socket should automatically add its pre-packaged Macros. If `false`, and you delete all the default Macros, they will not reappear\\nwhen you restart Socket.\\n\\nDefaults to `true`","lua_type":"boolean","source":{"line":88,"path":"docs_api/socket_settings.lua"}},{"name":"EnableSocketMacrosOverwrite","desc":"Slightly softer version of `EnableSocketMacros`. By default, Socket will delete+add its pre-packaged Macros on startup. This means that any\\nuser-made changes to the `ModuleScripts` will be overwritten. Set this to `false` to disable this behaviour.\\n\\nDefaults to `true`","lua_type":"boolean","source":{"line":98,"path":"docs_api/socket_settings.lua"}},{"name":"EnableAutoRun","desc":"If `false`, will ignore the `.AutoRun` member in any [MacroDefinition]\\n\\nDefaults to `true`","lua_type":"boolean","source":{"line":107,"path":"docs_api/socket_settings.lua"}},{"name":"UseDefaultSettings","desc":"If `true`, will reset ALL settings back to their default value (including `UseDefaultSettings=false`)","lua_type":"boolean","source":{"line":114,"path":"docs_api/socket_settings.lua"}}],"types":[],"name":"SocketSettings","desc":"Global settings for Socket that can be accessed + changed via the widget. This persists across Places, but is unique to a specific user.","source":{"line":6,"path":"docs_api/socket_settings.lua"}}')}}]);