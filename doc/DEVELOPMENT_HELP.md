# Development Help

This document contains helpful development-oriented references for working on Eludages Zeus Utilities.

## Building the Mod

The mod is packed into a `.pbo` and deployed to your local Arma 3 mods folder using `build.bat` in the repository root.

### Prerequisites

- [Arma 3 Tools](https://store.steampowered.com/app/233800/Arma_3_Tools/) installed via Steam (provides `AddonBuilder.exe`)
- A `.biprivatekey` file for signing the PBO *(optional — if the key is not found, the PBO is built unsigned)*

### Setup

1. Copy `.env.example` to `.env` in the repository root.
2. Fill in all paths in `.env` to match your local machine:

| Variable | Description |
|---|---|
| `ADDONBUILDER` | Path to `AddonBuilder.exe` |
| `SOURCE` | Path to the mod source directory (this repo) |
| `DEST` | Output path for the packed `.pbo` (should end in `EludagesZeusUtilities.pbo`) |
| `PRIVATEKEY` | Path to your `.biprivatekey` file *(optional — omit or point to a non-existent file to skip signing)* |
| `TEMPDIR` | Temp directory used by AddonBuilder during packing |
| `PROJECTDIR` | Root project directory (parent of the mod source) |
| `EXCLUDELIST` | Path to AddonBuilder's `exclude.lst` file |
| `EXPORTDIR` | Directory where AddonBuilder writes the output `.pbo` folder |
| `DEPLOYDIR` | Target `addons` folder of your local `@EludagesZeusUtilities` mod |

> `.env` is git-ignored and never committed. Only `.env.example` is tracked.

### Running the Build

Double-click `build.bat` or run it from a terminal:

```bat
build.bat
```

The script will:
1. Load all paths from `.env`
2. Read the PBO prefix from `$PBOPREFIX$`
3. Run AddonBuilder to pack and sign the PBO, using `AddonBuilderIncludes.txt` to determine which file types are copied directly (`.sqf`, `.hpp`, `.cpp`, `.paa`, `.p3d`)
4. On success: clear the deploy folder and move the new `.pbo` and `.bisign` files into it

## Dependencies

- **ZEN (Zeus Enhanced)** — required. All Zeus modules are registered through ZEN's [Custom Modules framework](https://github.com/zen-mod/ZEN/blob/master/docs/frameworks/custom_modules.md).
- **CBA_A3** — required by ZEN.

## ZEN Custom Modules Reference

Modules are added at runtime by calling `zen_custom_modules_fnc_register`. It must run on every client that should see the module — this mod does that once via `CfgFunctions`' `postInit = 1` on `EludagesZeusUtilities_fnc_registerZeusModules` (see `functions/core/fn_registerZeusModules.sqf`).

**`zen_custom_modules_fnc_register` arguments:**

| # | Description | Type | Default |
|---|---|---|---|
| 0 | Category | STRING | — |
| 1 | Module Name | STRING | — |
| 2 | Function | CODE | — |
| 3 | Icon File | STRING | `"\a3\modules_f\data\portraitmodule_ca.paa"` |

**Module function parameters** (passed when Zeus clicks the module; runs unscheduled and locally on the Zeus's own machine):

| # | Description | Type |
|---|---|---|
| 0 | Module Position | ARRAY (ASL) |
| 1 | Attached Object | OBJECT (`objNull` if none) |

A maximum of 200 custom modules can be registered (ZEN's own limit).

## Adding a New Zeus Module

1. Write the module's logic as a new function, e.g. `functions/core/fn_moduleFoo.sqf` (auto-compiles to `EludagesZeusUtilities_fnc_moduleFoo` via `CfgFunctions`)
2. Register it in `functions/core/fn_registerZeusModules.sqf`:
   ```sqf
   ["Eludages Zeus Utilities", "Foo", {call EludagesZeusUtilities_fnc_moduleFoo}] call zen_custom_modules_fnc_register;
   ```
3. Rebuild, open Zeus, and check the **Eludages Zeus Utilities** category in the Modules list

## Notes

- No persistent state (namespaces / profile variables) is used yet — document conventions here once modules start storing data.
- All mod runtime variables should use the `EludagesZeusUtilities_` prefix.
