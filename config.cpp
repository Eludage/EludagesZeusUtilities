class CfgPatches
{
    class EludagesZeusUtilities
    {
        name = "Eludages Zeus Utilities";
        author = "Eludage";
        url = "";
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {
            "zen_main",
            "cba_main"
        };
    };
};

class RscText;
class RscButton;
class RscStructuredText;

class EludagesZeusUtilities_bftReadmeDialog
{
    idd = -1;
    movingEnable = 1;
    controlsBackground[] = { "Background" };
    controls[] = { "Title", "Content", "CloseButton" };

    class Background: RscText
    {
        idc = -1;
        x = 0.3;
        y = 0.22;
        w = 0.4;
        h = 0.56;
        colorBackground[] = { 0, 0, 0, 0.85 };
    };

    class Title: RscText
    {
        idc = -1;
        text = "Eludages Zeus Utilities - Custom BFT";
        x = 0.32;
        y = 0.24;
        w = 0.36;
        h = 0.04;
        sizeEx = 0.03;
        colorBackground[] = { 0, 0, 0, 0 };
    };

    class Content: RscStructuredText
    {
        idc = 100;
        text = "<t align='left'>Adds a custom Blue Force Tracking that runs independently of ACE's own BFT.<br/><br/>- <t color='#ffcc00'>Toggle Custom BFT</t>: Opens a dialog in which you explicitly choose Disabled or Enabled. When enabled, ACE's own BFT markers are hidden for all players.<br/><br/>- <t color='#ffcc00'>Add Group</t>: Select a unit of the desired group in the Zeus interface, then click this module.<br/><br/>- <t color='#ffcc00'>List Groups</t>: Opens a window with all currently registered groups and their side. Tick a group and confirm to remove it.<br/><br/>- <t color='#ffcc00'>Reset Custom BFT</t>: Removes all groups, deletes all markers and turns Custom BFT off.<br/><br/>The markers of the group leaders are only shown to the members of added groups (and to you) and are refreshed every 2.5 seconds.</t>";
        x = 0.32;
        y = 0.29;
        w = 0.36;
        h = 0.44;
        size = 0.025;
    };

    class CloseButton: RscButton
    {
        idc = 101;
        text = "Close";
        x = 0.32;
        y = 0.745;
        w = 0.1;
        h = 0.04;
        action = "closeDialog 0;";
    };
};

class CfgFunctions
{
    class EludagesZeusUtilities
    {
        tag = "EludagesZeusUtilities";
        // ===== Core / Initialization =====
        class core
        {
            file = "EludagesZeusUtilities\functions\core";
            class registerZeusModules
            {
                postInit = 1;
            };
        };
        // ===== Actions / User Interactions =====
        class actions
        {
            file = "EludagesZeusUtilities\functions\actions";
            class bftReadme {};
            class bftToggle {};
            class bftAddGroup {};
            class bftListGroups {};
            class bftReset {};
            class soundPlayAtPosition {};
        };
        // ===== Data / Server-side State =====
        class data
        {
            file = "EludagesZeusUtilities\functions\data";
            class bftSetEnabled {};
            class bftSyncAceFlags {};
            class bftUpdateMarkers {};
            class bftMarkerSend {};
            class bftClearMarkers {};
            class soundGetPredefined {};
        };
        // ===== UI / Interface Updates =====
        class ui
        {
            file = "EludagesZeusUtilities\functions\ui";
        };
        // ===== Utilities / Helpers =====
        class utilities
        {
            file = "EludagesZeusUtilities\functions\utilities";
        };
    };
};