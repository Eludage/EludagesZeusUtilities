/*
 * Author: Eludage
 * Opens a dialog letting Zeus pick one of the predefined Custom Sounds, then
 * plays it once, positionally, for every player in range. The position is
 * the position under the Zeus cursor at the moment this module was clicked
 * (point the cursor at the desired spot first).
 *
 * Arguments:
 * 0: Module Position (ASL) <ARRAY>
 * 1: Attached Object <OBJECT> (unused)
 *
 * Return Value:
 * None
 */

params [["_posASL", [], [[]]]];

if (_posASL isEqualTo []) exitWith {
    hint "Custom Sounds: No position under cursor.";
};

private _sounds = call EludagesZeusUtilities_fnc_soundGetPredefined;

if (_sounds isEqualTo []) exitWith {
    hint "Custom Sounds: No predefined sounds configured.";
};

private _names = _sounds apply { _x select 0 };

[
    "Custom Sounds",
    [
        ["LIST", "Sound", [_names, _names, 0, 6]]
    ],
    {
        params ["_values", "_args"];
        _values params ["_name"];
        _args params ["_sounds", "_posASL"];

        private _entry = (_sounds select { (_x select 0) isEqualTo _name }) param [0, []];
        if (_entry isEqualTo []) exitWith {};
        _entry params ["_label", "_file"];

        // soundPosition is PositionASL; distance 400m caps the audible range.
        playSound3D [_file, objNull, false, _posASL, 1, 1, 400];
    },
    {},
    [_sounds, _posASL]
] call zen_dialog_fnc_create;
