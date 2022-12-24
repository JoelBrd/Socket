export type Janitor = {
    Add: (object: any, methodName: boolean | string | nil, index: any?) -> any,
}

export type InstanceUtil = {
    IntroduceInstance: (self: InstanceUtil, instance: Instance, dontSetWaypoint: boolean?) -> nil,
    ClearInstance: (self: InstanceUtil, instance: Instance, doDestroy: boolean) -> nil,
}

export type Logger = {
    MacroInfo: (self: Logger, macro: PopulatedMacroDefinition, ...any) -> nil,
    MacroWarn: (self: Logger, macro: PopulatedMacroDefinition, ...any) -> nil,
}

export type RaycastUtil = {
    RaycastMouse: (self: RaycastUtil, distance: number, raycastParams: RaycastParams?, checkAllCollisionGroups: boolean?) -> RaycastResult,
    Raycast: (
        self: RaycastUtil,
        origin: Vector3,
        direction: Vector3,
        distance: number,
        raycastParams: RaycastParams?,
        checkAllCollisionGroups: boolean?
    ) -> RaycastResult,
}

export type MacroState = {
    FieldValues: { [string]: any }, -- Keys are FieldNames, Values are FieldValues
    IsRunning: boolean?,
    IsKeybindDisabled: boolean?,
    _Server: MacroState?,
    _Client: MacroState?,
}

export type MacroFieldTypeName = "string" | "number" | "boolean" | "Color3" | "Vector3"
export type MacroField = {
    Type: MacroFieldTypeName,
    Name: string,
    IsRequired: boolean?,
    Validator: ((value: any) -> string)?,
}

export type MacroDefinition = {
    Name: string,
    NameColor: Color3?,
    Icon: string?,
    IconColor: Color3?,
    Group: string?,
    GroupColor: Color3?,
    GroupIcon: string?,
    GroupIconColor: Color3?,
    Description: string?,
    LayoutOrder: number?,
    EnableAutomaticUndo: boolean?,
    IgnoreGameProcessedKeybinds: boolean?,
    AutoRun: boolean?,
    Keybind: { Enum.KeyCode }?, -- {}
    Fields: { MacroField }?, -- {}
    State: MacroState?,
    Disabled: boolean?,
    Function: (macro: PopulatedMacroDefinition, plugin: Plugin) -> any,
    BindToClose: ((macro: PopulatedMacroDefinition, plugin: Plugin) -> any)?,
    BindToOpen: ((macro: PopulatedMacroDefinition, plugin: Plugin) -> any)?,
}

export type PopulatedMacroDefinition = MacroDefinition & {
    Icon: string,
    Group: string,
    Description: string,
    LayoutOrder: number,
    EnableAutomaticUndo: boolean,
    IgnoreGameProcessedKeybinds: boolean,
    AutoRun: boolean,
    IsLocalMacro: boolean,
    Keybind: { Enum.KeyCode },
    Fields: { MacroField },
    FieldChanged: BindableEvent,
    State: MacroState,
    RunJanitor: Janitor,
    Disabled: boolean,
    GetFieldValue: (self: PopulatedMacroDefinition, fieldName: string) -> any,
    ToggleIsRunning: (self: PopulatedMacroDefinition) -> (),
    IsRunning: (self: PopulatedMacroDefinition) -> boolean,
}

return {}
