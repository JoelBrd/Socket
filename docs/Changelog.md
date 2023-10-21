---
sidebar_position: 8
---

# Changelog

## v1.3.0

- Deprecated `CollapseExplorer` macro as this functionality is now part of Studio
- Updated `PhysicsService` collision API usage to ugprade from deprecated API
- Updated `ChangeHistoryService` API from using deprecated waypoint to new recording
- Updated Socket docs for using change history service and undo

## v1.2.0

- Fix issues with docking from the recent Studio overhaul
- Fixed bug with Local Macros where `ModuleScripts` with duplicate names would silently not get saved
- Removed "Clone" built-in macro, as this behaviour mirrors `Ctrl+D`
- Add in luau type definitions
- Update "Create Macro" macro to use luau type definitions for better UX

### v1.2.1

- Fix typo with luau type `MacroField.Validator`

### v1.2.2

- Pass `self` in Janitor type
- Fixed bug where `LocalMacros` would get duplicated

### v1.2.3

- Fixed bug where `Vector3` field type would not accept any decimal or negative values
- Added `ClearFieldTextBoxOnFocus` setting; can now disable field text boxes automatically clearing on focus

### v1.2.4

- Socket will only startup when the user chooses to manually start up the plugin, or when Socket has already been started up in that place file. (https://devforum.roblox.com/t/socket-a-macro-manager-plugin/1898339/10)
- Fixed bug where `Color3` completion would take `R,B,B` value instead of `R,G,B` defined by the user

### v1.2.5

- Fixed `string.format` typo for yielding thread error
- Added `HideUnusedFieldsAndKeybind` setting; can hide fields and keybind UI elements if they are not used for any given macro

## v1.1.0

- Added Local Macros (see [IsLocalMacro](/api/MacroDefinition#IsLocalMacro)), which allows replication of macros across multiple places via the `plugin` itself.
- Added `LocalMacroColor` setting
- Improved logic behind the settings system to be more scalable + easier to add new settings of different types

## v1.0.0

Release!
