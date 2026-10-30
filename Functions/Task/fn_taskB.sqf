if (!isServer) exitWith {};

if (missionNamespace getVariable ["LL_g_taskB_active", false]) exitWith {};
missionNamespace setVariable ["LL_g_taskB_active", true, true];

params [
    ["_locMarker", "", [""]],
    ["_optionalTasks", [], [[]]]
];

private _targetPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 350; };

[
    group player,
    "task_mandatory_civ",
    [
        localize "STR_LL_Task_Man2_Desc",
        localize "STR_LL_Task_Man2_Title",
        localize "STR_LL_Task_Man2_Marker"
    ],
    objNull,
    "CREATED",
    5,
    true,
    "interact",
    false
] call BIS_fnc_taskCreate;

missionNamespace setVariable ["LL_g_civKilledByPlayers", false, true];

private _ehKilled = addMissionEventHandler ["EntityKilled", {
    params ["_killed", "_killer", "_instigator"];
    if (isNull _instigator) then { _instigator = _killer; };
    if (!isNull _killed && { _killed isKindOf "CAManBase" && side group _killed == civilian && !(_killed getVariable ["LL_isEnemy", false]) }) then {
        if (!isNull _instigator && { side group _instigator == independent || _instigator in (allPlayers + switchableUnits) }) then {
            missionNamespace setVariable ["LL_g_civKilledByPlayers", true, true];
        };
    };
}];

{ _x setVariable ["LL_logic_occupied", false]; } forEach (nearestObjects [_targetPos, ["Logic", "Land_HelipadEmpty_F"], _radius + 150]);
missionNamespace setVariable ["LL_g_usedTaskPos", []];

sleep 3.0;

{
    private _taskId = _x;
    switch (_taskId) do {
        case "TASK_CAPTIVE": { [_locMarker] spawn LL_fnc_taskD_captive; };
        case "TASK_HVT": { [_locMarker] spawn LL_fnc_taskD_hvt; };
        case "TASK_TRANSMISSION": { [_locMarker] spawn LL_fnc_taskD_transmission; };
        case "TASK_CHEMICAL": { [_locMarker] spawn LL_fnc_taskD_chemical; };
        case "TASK_DOCUMENTS": { [_locMarker] spawn LL_fnc_taskD_documents; };
        case "TASK_TIGRIS": { [_locMarker] spawn LL_fnc_taskD_tigris; };
    };
    sleep 5.0;
} forEach _optionalTasks;

[_locMarker, _optionalTasks] spawn LL_fnc_taskBonus;

waitUntil {
    sleep 1;
    missionNamespace getVariable ["LL_g_extractionStarted", false]
};

removeMissionEventHandler ["EntityKilled", _ehKilled];

private _hasBavure = missionNamespace getVariable ["LL_g_civKilledByPlayers", false];

if (!_hasBavure) then {
    ["task_mandatory_civ", "SUCCEEDED", true] call BIS_fnc_taskSetState;
} else {
    ["task_mandatory_civ", "FAILED", true] call BIS_fnc_taskSetState;
};
