/*
 * Author: Eludage
 * Opens a ZEN dialog in which the Zeus explicitly chooses whether Custom BFT
 * should be disabled or enabled, then applies that state locally.
 * The dialog is preset to the current state.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

private _current = missionNamespace getVariable ["EZU_BFT_enabled", false];

[
    "Edit Custom BFT",
    [
        ["TOOLBOX:ENABLED", "Custom BFT", _current]
    ],
    {
        params ["_values"];
        _values params ["_enabled"];

        [_enabled] call EludagesZeusUtilities_fnc_bftSetEnabled;
        hint format ["Custom BFT: %1.", ["disabled", "enabled"] select _enabled];
    }
] call zen_dialog_fnc_create;
