/*
 * Author: Eludage
 * Opens a ZEN confirmation dialog. Only if the Zeus explicitly answers "Yes"
 * and confirms, the server is asked to reset the Custom BFT system: clears all
 * registered groups, deletes all markers, and disables tracking.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

[
    "Reset Custom BFT",
    [
        ["TOOLBOX:YESNO", ["Reset Custom BFT", "Removes all groups, deletes all markers and disables Custom BFT."], false]
    ],
    {
        params ["_values"];
        _values params ["_confirmed"];

        if (!_confirmed) exitWith {
            hint "Custom BFT: Reset cancelled.";
        };

        missionNamespace setVariable ["EZU_BFT_groups", []];
        [false] call EludagesZeusUtilities_fnc_bftSetEnabled;
        hint "Custom BFT: Reset done.";
    }
] call zen_dialog_fnc_create;
