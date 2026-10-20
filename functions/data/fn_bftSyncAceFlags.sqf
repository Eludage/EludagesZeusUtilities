/*
 * Author: Eludage
 * Sets ace_map_hideBlueForceMarker on all players and groups. Only writes (and
 * thereby broadcasts) the variable where it differs from the wanted value, so
 * it is cheap to call repeatedly. Called every marker cycle while Custom BFT
 * is enabled, which also covers players that joined or respawned afterwards.
 *
 * Arguments:
 * 0: Hide ACE BFT markers <BOOL>
 *
 * Return Value:
 * None
 */

params [["_hide", false, [false]]];

{
    if !((_x getVariable ["ace_map_hideBlueForceMarker", false]) isEqualTo _hide) then {
        _x setVariable ["ace_map_hideBlueForceMarker", _hide, true];
    };
} forEach (allPlayers + allGroups);
