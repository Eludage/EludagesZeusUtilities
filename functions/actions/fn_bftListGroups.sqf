/*
 * Author: Eludage
 * Opens a ZEN dialog listing all registered Custom BFT groups together with
 * their side. Each group has a "Remove" checkbox; on OK the ticked groups are
 * removed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

private _groups = missionNamespace getVariable ["EZU_BFT_groups", []];

if (_groups isEqualTo []) exitWith {
    hint "Custom BFT: No groups registered.";
};

private _sideNames = ["BLUFOR", "OPFOR", "Independent", "Civilian"];
private _sides = [west, east, independent, civilian];

private _controls = _groups apply {
    private _label = if (isNull _x) then {
        "(group no longer exists)"
    } else {
        private _sideIndex = _sides find (side _x);
        private _sideName = if (_sideIndex < 0) then {"Unknown"} else {_sideNames select _sideIndex};
        format ["%1 (%2)", groupId _x, _sideName]
    };

    ["CHECKBOX", [_label, "Tick to remove this group from Custom BFT."], false]
};

[
    "Custom BFT - Registered Groups",
    _controls,
    {
        params ["_values", "_groups"];

        private _toRemove = [];
        { if (_x) then { _toRemove pushBack (_groups select _forEachIndex); }; } forEach _values;

        if (_toRemove isEqualTo []) exitWith {};

        private _remaining = (missionNamespace getVariable ["EZU_BFT_groups", []]) select { !(_x in _toRemove) };
        missionNamespace setVariable ["EZU_BFT_groups", _remaining];
        hint format ["Custom BFT: %1 group(s) removed.", count _toRemove];
    },
    {},
    _groups
] call zen_dialog_fnc_create;
