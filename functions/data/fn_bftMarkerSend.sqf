/*
 * Author: Eludage
 * Runs SQF statements on the given players' machines. The statements are
 * joined and compiled here, then sent as code via one remoteExec "call" to all
 * targets at once (no mod needed on their side). The own machine is served
 * directly. Values inside the statements must be embedded with str, so strings
 * are quoted and escaped correctly.
 *
 * Arguments:
 * 0: Target players <ARRAY of OBJECT>
 * 1: Statements <ARRAY of STRING>
 *
 * Return Value:
 * None
 */

params ["_targets", "_statements"];

if (_targets isEqualTo [] || {_statements isEqualTo []}) exitWith {};

private _code = compile (_statements joinString ";");

if (player in _targets) then {
    call _code;
    _targets = _targets - [player];
};

if (_targets isNotEqualTo []) then {
    _code remoteExec ["call", _targets, false];
};
