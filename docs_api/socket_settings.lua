--[=[
    @class SocketSettings

    Global settings for Socket that can be accessed + changed via the widget. This persists across Places, but is unique to a specific user.
]=]

--[=[
    @prop Font Enum.Font
    @within SocketSettings

    The Font used on the widget.

    Defaults to `Enum.Font.Highway`
]=]

--[=[
    @prop UIScale number
    @within SocketSettings

    This can be tweaked to change the scaling of the UI. Useful for users on a high DPI monitor, or a user that benefits from larger text.

    Defaults to `1`
]=]

--[=[
    @prop OpenFieldsByDefault boolean
    @within SocketSettings

    The widget uses toggle arrows to show/hide information. If `true`, the "Fields" sections inside macros will be open by default. Just saves the
    user another click.

    Defaults to `true`
]=]

--[=[
    @prop SortType string
    @within SocketSettings

    Can take a variety of string values to define how Macros and Groups are sorted on the widget.

    **"LayoutOrder"**
    Uses [Layout Order](/api/MacroDefinition#LayoutOrder) to define sorting. The group with the Macro with the lowest `LayoutOrder` will be at the
    top of the widget.

    **"Icon"**
    Will sort Macros and Groups by their `Icon` using `<`. This results in Macros and Groups with matching Icons being grouped next to one another.

    **"Name"**
    Sorts Macros and Groups alphabetically by name. This behaviour also underlies the other sort types when there isn't a distinct difference (e.g., same
    `Icon`, same `LayoutOrder`)

    Defaults to `"Name"`
]=]

--[=[
    @prop OSType string
    @within SocketSettings

    Can take a variety of string values to define the OS you are on. This is useful to translate the Ctrl/Cmd keybinds across OS types.

    **"Windows"**
    Converts `Enum.KeyCode.LeftMeta` and `Enum.KeyCode.RightMeta` to `Enum.KeyCode.LeftControl` and `Enum.KeyCode.RightControl`

    **"Mac"**
    Converts `Enum.KeyCode.LeftControl` and `Enum.KeyCode.RightControl` to `Enum.KeyCode.LeftMeta` and `Enum.KeyCode.RightMeta`

    Defaults to `"Windows"`
]=]

--[=[
    @prop IgnoreGameProcessedKeybinds boolean
    @within SocketSettings

    If `true`, will not discard [UserInputService#InputBegan] events where `gameProcessed=true`.

    Defaults to `false`
]=]

--[=[
    @prop EnableSocketMacros boolean
    @within SocketSettings

    Declares if Socket should automatically add its pre-packaged Macros. If `false`, and you delete all the default Macros, they will not reappear
    when you restart Socket.

    Defaults to `true`
]=]

--[=[
    @prop EnableSocketMacrosOverwrite boolean
    @within SocketSettings

    Slightly softer version of `EnableSocketMacros`. By default, Socket will delete+add its pre-packaged Macros on startup. This means that any
    user-made changes to the `ModuleScripts` will be overwritten. Set this to `false` to disable this behaviour.

    Defaults to `true`
]=]

--[=[
    @prop EnableAutoRun boolean
    @within SocketSettings

    If `false`, will ignore the `.AutoRun` member in any [MacroDefinition]

    Defaults to `true`
]=]

--[=[
    @prop LocalMacroColor Color3
    @tag v1.1.0
    @within SocketSettings

    This is the color used to make Local Macros stand out from other macros on the widget.

    Defaults to `Color3.fromRGB(0, 231, 193)`
]=]

--[=[
    @prop UseDefaultSettings boolean
    @within SocketSettings

    If `true`, will reset ALL settings back to their default value (including `UseDefaultSettings=false`)
]=]
