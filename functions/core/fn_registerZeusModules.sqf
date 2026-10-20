/*
 * Author: Eludage
 * Registers Eludages Zeus Utilities' custom modules with Zen (Zeus Enhanced).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

if (!hasInterface) exitWith {};
if (isNil "zen_custom_modules_fnc_register") exitWith {};

["Eludages Zeus Utilities", "Working Test", {hint "working"}] call zen_custom_modules_fnc_register;

["Eludages Zeus Utilities - Custom BFT", "ReadMe", {call EludagesZeusUtilities_fnc_bftReadme}] call zen_custom_modules_fnc_register;
["Eludages Zeus Utilities - Custom BFT", "Toggle Custom BFT", {call EludagesZeusUtilities_fnc_bftToggle}] call zen_custom_modules_fnc_register;
["Eludages Zeus Utilities - Custom BFT", "Add Group", {_this call EludagesZeusUtilities_fnc_bftAddGroup}] call zen_custom_modules_fnc_register;
["Eludages Zeus Utilities - Custom BFT", "List Groups", {call EludagesZeusUtilities_fnc_bftListGroups}] call zen_custom_modules_fnc_register;
["Eludages Zeus Utilities - Custom BFT", "Reset Custom BFT", {call EludagesZeusUtilities_fnc_bftReset}] call zen_custom_modules_fnc_register;
