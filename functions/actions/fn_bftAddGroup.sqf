/*
 * Author: Eludage
 * Adds the group of the currently selected/attached unit to the Custom BFT
 * system. Intended to be called as a ZEN custom module function, which passes
 * the position under cursor and the attached object (if any).
 *
 * Arguments:
 * 0: Module Position <ARRAY> (unused)
 * 1: Attached Object <OBJECT>
 *
 * Return Value:
 * None
 */

params [["_pos", [], [[]]], ["_object", objNull, [objNull]]];

if (isNull _object) exitWith {
    hint "Custom BFT: No unit selected. Please select a unit of the desired group in the Zeus interface first.";
};

private _group = group _object;

if (isNull _group) exitWith {
    hint "Custom BFT: The selected unit has no group.";
};

private _groups = missionNamespace getVariable ["EZU_BFT_groups", []];

if (_group in _groups) exitWith {
    hint format ["Custom BFT: Group '%1' is already registered.", groupId _group];
};

_groups pushBack _group;
missionNamespace setVariable ["EZU_BFT_groups", _groups];

if (missionNamespace getVariable ["EZU_BFT_enabled", false]) then {
    _group setVariable ["ace_map_hideBlueForceMarker", true, true];
    { _x setVariable ["ace_map_hideBlueForceMarker", true, true]; } forEach (units _group);
};

hint format ["Custom BFT: Group '%1' added.", groupId _group];
