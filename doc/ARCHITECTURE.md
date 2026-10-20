# Eludages Zeus Utilities Architecture

This document describes the architectural patterns and design decisions of the Eludages Zeus Utilities mod.

## Overview

Eludages Zeus Utilities is a client-side Arma 3 mod that adds custom Zeus modules through [ZEN (Zeus Enhanced)](https://github.com/zen-mod/ZEN)'s Custom Modules framework rather than vanilla `Module_F`-based Zeus modules.

## Core Architectural Principles

### 1. Client-Side Only
- **No server-side code required** - all module logic runs locally in each Zeus's own game instance
- **Per-client registration** - ZEN's `zen_custom_modules_fnc_register` must run on every client that should see a module; this mod does that once at mission start (see Module Registration below)

### 2. Built on ZEN, Not Vanilla Module_F
Two approaches exist for adding Zeus modules:
- **Vanilla `Module_F`**: modules are `CfgVehicles` classes that Zeus places on the map like any other entity. This requires careful `CfgPatches > units[]`, `scope`/`scopeCurator`, and category wiring, and can fail to appear in Zeus's module list with no error if any piece is missing or if the mission's Game Master module restricts available addons.
- **ZEN Custom Modules** (used here): modules are plain script functions registered at runtime via `zen_custom_modules_fnc_register`. They appear as instant-action buttons in Zeus's Custom Modules menu — no map placement, no `CfgVehicles` boilerplate. This mod uses this approach and therefore has a hard dependency on ZEN.

### 3. Namespace Usage
No persistent state is used yet — the current module is stateless. Document namespace conventions here (`uiNamespace` for ephemeral session state, `profileNamespace` for state that must survive game restarts, etc.) once modules start storing data.

## Function Architecture

### Function Categories (`functions/`)
- **`core/`** — entry points and initialization. Currently contains `fn_registerZeusModules.sqf`, which registers all of this mod's Zeus modules with ZEN.
- **`actions/`** — reserved for future user-interaction handlers
- **`data/`** — reserved for future data-source interfaces
- **`ui/`** — reserved for future UI/dialog code
- **`utilities/`** — reserved for future helper functions

## Module Registration Flow

```
1. Mission starts
   `EludagesZeusUtilities_fnc_registerZeusModules` runs automatically
   (CfgFunctions `postInit = 1` on the `core` category's `registerZeusModules` entry)
   ↓
2. Exits early if `!hasInterface` (dedicated server/headless client)
   or if ZEN isn't loaded (`isNil "zen_custom_modules_fnc_register"`)
   ↓
3. For each module this mod provides:
   [category, moduleName, functionCode] call zen_custom_modules_fnc_register
   ↓
4. Zeus opens the Modules list → sees the module under its category
   ↓
5. Zeus clicks the module → functionCode runs immediately (unscheduled, local only)
```

## Adding a New Module

1. Write the module's logic as a new function, e.g. `functions/core/fn_moduleFoo.sqf` (auto-compiles to `EludagesZeusUtilities_fnc_moduleFoo` via `CfgFunctions`)
2. Register it in `functions/core/fn_registerZeusModules.sqf` with a `zen_custom_modules_fnc_register` call
3. Rebuild and verify it shows up under the mod's category in Zeus's Modules list

## Error Handling

- **ZEN availability**: `fn_registerZeusModules.sqf` exits early if `zen_custom_modules_fnc_register` doesn't exist
- **Client-only**: registration exits early on machines without an interface (dedicated server, headless client)

## Dependencies

### Required
- **ZEN (Zeus Enhanced)** — provides the Custom Modules framework this mod registers into
- **CBA_A3** — required by ZEN

## Future Considerations

- Document namespace conventions here once modules start storing persistent or session state
- `CfgFunctions` currently declares an `actions` category pointing at `functions/actions`, but that folder doesn't exist yet — create it (or remove the declaration) before the build tries to reference it
