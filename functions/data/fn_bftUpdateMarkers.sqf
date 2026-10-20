/*
 * Author: Eludage
 * Keeps one local marker per tracked group at its leader's current position,
 * but only on the machines of players who are members of a tracked group, plus
 * the Zeus itself. Markers are created once per recipient and afterwards only
 * moved (and re-styled when side or name changed); one remoteExec (code
 * via "call") per change serves all recipients. Markers of groups that were removed, whose leader is
 * gone, or of players who left all tracked groups are deleted.
 * Runs on the Zeus client, every 2.5 seconds while Custom BFT is enabled
 * (see fn_bftSetEnabled.sqf).
 *
 * State (Zeus client only):
 * EZU_BFT_recipients: HashMap player UID -> marker names existing on that player's machine
 * EZU_BFT_lastSent:   HashMap marker name -> [pos, color, text] last sent
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

if (!hasInterface) exitWith {};

private _groups = missionNamespace getVariable ["EZU_BFT_groups", []];
private _state = missionNamespace getVariable ["EZU_BFT_recipients", createHashMap];
private _last = missionNamespace getVariable ["EZU_BFT_lastSent", createHashMap];

// Wanted markers: name -> [pos, color, text]
private _desired = createHashMap;
{
    private _group = _x;
    private _leader = leader _group;

    if (!isNull _group && {!isNull _leader && {alive _leader}}) then {
        private _name = format ["EZU_BFT_%1", (netId _group) splitString ":" joinString "_"];
        _desired set [_name, [getPosATL _leader, format ["Color%1", side _group], groupId _group]];
    };
} forEach _groups;

// Recipients: members of tracked groups, plus the Zeus. UID -> unit
private _eligible = createHashMap;
{
    if (isPlayer _x && {(group _x) in _groups}) then {
        _eligible set [getPlayerUID _x, _x];
    };
} forEach allPlayers;
_eligible set [getPlayerUID player, player];

// Create missing markers and move existing ones
{
    private _name = _x;
    private _data = _y;
    _data params ["_pos", "_color", "_text"];

    private _need = [];
    private _have = [];

    {
        private _uid = _x;
        private _unit = _y;
        private _names = _state getOrDefault [_uid, []];

        if (_name in _names) then {
            _have pushBack _unit;
        } else {
            _need pushBack _unit;
            _names pushBack _name;
            _state set [_uid, _names];
        };
    } forEach _eligible;

    private _prev = _last getOrDefault [_name, []];
    private _sentPos = _pos;

    if (_need isNotEqualTo []) then {
        [_need, [
            format ["createMarkerLocal %1", str [_name, _pos]],
            format ["%1 setMarkerTypeLocal 'mil_dot'", str _name],
            format ["%1 setMarkerColorLocal %2", str _name, str _color],
            format ["%1 setMarkerTextLocal %2", str _name, str _text]
        ]] call EludagesZeusUtilities_fnc_bftMarkerSend;
    };

    if (_have isNotEqualTo [] && {_prev isNotEqualTo []}) then {
        _prev params ["_prevPos", "_prevColor", "_prevText"];
        private _updates = [];

        if (_prevPos distance2D _pos > 1) then {
            _updates pushBack (format ["%1 setMarkerPosLocal %2", str _name, str _pos]);
        } else {
            _sentPos = _prevPos;
        };
        if !(_prevColor isEqualTo _color) then {
            _updates pushBack (format ["%1 setMarkerColorLocal %2", str _name, str _color]);
        };
        if !(_prevText isEqualTo _text) then {
            _updates pushBack (format ["%1 setMarkerTextLocal %2", str _name, str _text]);
        };

        [_have, _updates] call EludagesZeusUtilities_fnc_bftMarkerSend;
    };

    _last set [_name, [_sentPos, _color, _text]];
} forEach _desired;

// Delete markers that are no longer wanted where they exist
private _newState = createHashMap;
private _removals = createHashMap;

{
    private _uid = _x;
    private _names = _y;
    private _eligibleUnit = _eligible getOrDefault [_uid, objNull];
    private _unit = _eligibleUnit;
    if (isNull _unit) then {
        _unit = (allPlayers select { getPlayerUID _x isEqualTo _uid }) param [0, objNull];
    };

    private _keep = [];
    {
        private _name = _x;
        if (!isNull _eligibleUnit && {_name in _desired}) then {
            _keep pushBack _name;
        } else {
            // Disconnected players (null unit) lost their local markers anyway
            if (!isNull _unit) then {
                private _targets = _removals getOrDefault [_name, []];
                _targets pushBack _unit;
                _removals set [_name, _targets];
            };
        };
    } forEach _names;

    if (_keep isNotEqualTo []) then { _newState set [_uid, _keep]; };
} forEach _state;

{
    [_y, [format ["deleteMarkerLocal %1", str _x]]] call EludagesZeusUtilities_fnc_bftMarkerSend;
} forEach _removals;

{
    if !(_x in _desired) then { _last deleteAt _x; };
} forEach (keys _last);

missionNamespace setVariable ["EZU_BFT_recipients", _newState];
missionNamespace setVariable ["EZU_BFT_lastSent", _last];
