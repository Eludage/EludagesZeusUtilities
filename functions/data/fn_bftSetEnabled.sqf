/*
 * Author: Eludage
 * Enables or disables Custom BFT on this (Zeus) client. Enabling hides ACE's
 * own BFT markers and starts the update loop (which keeps hiding them for
 * players and groups that appear later); disabling restores ACE's
 * markers, stops the loop and deletes all Custom BFT markers.
 *
 * Arguments:
 * 0: Enabled <BOOL>
 *
 * Return Value:
 * None
 */

params [["_enabled", false, [false]]];

missionNamespace setVariable ["EZU_BFT_enabled", _enabled];

[_enabled] call EludagesZeusUtilities_fnc_bftSyncAceFlags;

private _pfhId = missionNamespace getVariable ["EZU_BFT_pfhId", -1];

if (_enabled) then {
    if (_pfhId < 0) then {
        _pfhId = [{
            [true] call EludagesZeusUtilities_fnc_bftSyncAceFlags;
            [] call EludagesZeusUtilities_fnc_bftUpdateMarkers;
        }, 2.5, []] call CBA_fnc_addPerFrameHandler;
        missionNamespace setVariable ["EZU_BFT_pfhId", _pfhId];
    };
} else {
    if (_pfhId >= 0) then {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        missionNamespace setVariable ["EZU_BFT_pfhId", -1];
    };

    [] call EludagesZeusUtilities_fnc_bftClearMarkers;
};
