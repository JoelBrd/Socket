---
sidebar_position: 8
---

# Changelog

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

## v1.1.0
 - Added Local Macros (see [IsLocalMacro](/api/MacroDefinition#IsLocalMacro)), which allows replication of macros across multiple places via the `plugin` itself.
 - Added `LocalMacroColor` setting
 - Improved logic behind the settings system to be more scalable + easier to add new settings of different types

## v1.0.0
Release!