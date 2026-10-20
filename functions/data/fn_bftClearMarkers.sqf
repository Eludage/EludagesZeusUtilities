/*
 * Author: Eludage
 * Deletes all Custom BFT markers on every machine that currently has some and
 * forgets what was sent. Players that are no longer connected are skipped.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

private _state = missionNamespace getVariable ["EZU_BFT_recipients", createHashMap];

{
    private _uid = _x;
    private _names = _y;
    private _unit = (allPlayers select { getPlayerUID _x isEqualTo _uid }) param [0, objNull];

    if (!isNull _unit) then {
        [[_unit], _names apply { format ["deleteMarkerLocal %1", str _x] }] call EludagesZeusUtilities_fnc_bftMarkerSend;
    };
} forEach _state;

missionNamespace setVariable ["EZU_BFT_recipients", createHashMap];
missionNamespace setVariable ["EZU_BFT_lastSent", createHashMap];
