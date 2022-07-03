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

    The widget uses toggle arrows to show/hide information. If `true`, the "Fields" sections inside plugs will be open by default. Just saves the
    user another click.

    Defaults to `true`
]=]

--[=[
    @prop SortType string
    @within SocketSettings

    Can take a variety of string values to define how Plugs and Groups are sorted on the widget.

    **"LayoutOrder"**
    Uses [Layout Order](/api/PlugDefinition#LayoutOrder) to define sorting. The group with the Plug with the lowest `LayoutOrder` will be at the
    top of the widget.

    **"Icon"**
    Will sort Plugs and Groups by their `Icon` using `<`. This results in Plugs and Groups with matching Icons being grouped next to one another.

    **"Name"**
    Sorts Plugs and Groups alphabetically by name. This behaviour also underlies the other sort types when there isn't a distinct difference (e.g., same
    `Icon`, same `LayoutOrder`)

    Defaults to `"Name"`
]=]

--[=[
    @prop IgnoreGameProcessedKeybinds boolean
    @within SocketSettings

    If `true`, will not discard [UserInputService#InputBegan] events where `gameProcessed=true`.

    Defaults to `false`
]=]

--[=[
    @prop EnableSocketPlugs boolean
    @within SocketSettings

    Declares if Socket should automatically add its pre-packaged Plugs. If `false`, and you delete all the default Plugs, they will not reappear
    when you restart Socket.

    Defaults to `true`
]=]

--[=[
    @prop EnableSocketPlugsOverwrite boolean
    @within SocketSettings

    Slightly softer version of `EnableSocketPlugs`. By default, Socket will delete+add its pre-packaged **Plugs** on startup. This means that any
    user-made changes to the `ModuleScripts` will be overwritten. Set this to `false` to disable this behaviour.

    Defaults to `true`
]=]

--[=[
    @prop EnableAutoRun boolean
    @within SocketSettings

    If `false`, will ignore the `.AutoRun` member in any [PlugDefinition]

    Defaults to `true`
]=]

--[=[
    @prop UseDefaultSettings boolean
    @within SocketSettings

    If `true`, will reset ALL settings back to their default value (including `UseDefaultSettings=false`)
]=]
