# Eludages Zeus Utilities

Eludages Zeus Utilities is a client-side Arma 3 mod that adds custom Zeus modules to support and streamline Zeus / game-master workflows. It's built on top of [ZEN (Zeus Enhanced)](https://github.com/zen-mod/ZEN)'s Custom Modules framework.

**Status:** Early development. The mod currently ships a single test module ("Working Test") used to validate the module-registration pipeline. More Zeus modules will be added over time.

## Features

- Registers custom modules into Zeus's interface via ZEN's Custom Modules framework
- **Working Test** — a placeholder module that shows a "working" hint, used to verify the mod loads and registers correctly with ZEN

## Dependencies

### Required
- **ZEN (Zeus Enhanced)** - all custom Zeus modules are registered through ZEN's Custom Modules framework
- **CBA_A3** - Community Base Addons A3 (required by ZEN)

## Installation

1. Subscribe to the mod on Steam Workshop
2. Subscribe to and enable ZEN and CBA_A3 as well
3. Enable all of them in the Arma 3 Launcher
4. Launch Arma 3 and start or join a mission as Zeus

## Usage

As Zeus, open the **Modules** list and look under the **Eludages Zeus Utilities** category. Click a module to run its action immediately — ZEN's custom modules execute directly from the menu, no map placement needed.

## How It Works

### Module Registration
Modules are registered per-client at mission start via [functions/core/fn_registerZeusModules.sqf](functions/core/fn_registerZeusModules.sqf), which calls ZEN's `zen_custom_modules_fnc_register` once for each module this mod provides. Registration only runs if the client `hasInterface` and ZEN is loaded, so it fails safely if either isn't the case.

## Documentation

The repository includes developer-facing documents in the `doc/` folder:

- `DEVELOPMENT_HELP.md` — developer reference (build process, ZEN Custom Modules reference, how to add a new module)
- `ARCHITECTURE.md` — architecture overview (function organization, module registration flow, design decisions)

## Compatibility

This mod depends on ZEN's Custom Modules framework — see [ZEN's documentation](https://github.com/zen-mod/ZEN/blob/master/docs/frameworks/custom_modules.md) for details on how modules are registered and displayed in Zeus.

## Credits

- **Author**: Eludage
- The ZEN team for the Zeus Enhanced framework and its Custom Modules API
- The Arma 3 modding community

## Feedback and Issues

Found a bug or have a suggestion? Please report it on the [GitHub repository](https://github.com/Eludage/eludages-zeus-utilities) or in the Steam Workshop comments.
