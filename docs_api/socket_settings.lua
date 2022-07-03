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
    @prop GroupMatchingIcons boolean
    @within SocketSettings

    Plugs are sorted alphabetically on the widget. If this is `true`, this will be superseded by making sure **Plugs** with the same `.Icon` are next
    to one another on the widget.

    Defaults to `true`
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
