if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]],
    ["_optionalTasks", [], [[]]]
];

if ("TASK_CAPTIVE" in _optionalTasks) exitWith {};

if (random 1 >= 0.5) exitWith {};

private _taskA3Names = [];
{
    switch (_x) do {
        case "TASK_CAPTIVE": { _taskA3Names pushBack "task_d_captive"; };
        case "TASK_HVT": { _taskA3Names pushBack "task_d_hvt"; };
        case "TASK_TRANSMISSION": { _taskA3Names pushBack "task_d_transmission"; };
        case "TASK_CHEMICAL": { _taskA3Names pushBack "task_chemical"; };
        case "TASK_DOCUMENTS": { _taskA3Names pushBack "task_d_documents"; };
        case "TASK_TIGRIS": { _taskA3Names pushBack "task_tigris"; };
    };
} forEach _optionalTasks;

if (count _taskA3Names > 0) then {
    waitUntil {
        sleep 3;
        private _allDone = true;
        {
            private _state = [_x] call BIS_fnc_taskState;
            if (_state != "SUCCEEDED" && _state != "FAILED") exitWith {
                _allDone = false;
            };
        } forEach _taskA3Names;
        _allDone || { missionNamespace getVariable ["LL_g_extractionStarted", false] }
    };
};

if (missionNamespace getVariable ["LL_g_extractionStarted", false]) exitWith {};
if (!alive player) exitWith {};

sleep 4.0;

private _allMarkers = allMapMarkers select { (_x select [0, 7]) == "marker_" };
private _candidateMarkers = _allMarkers - [_locMarker];

private _validMarkers = _candidateMarkers select {
    ((getMarkerPos _x) distance2D (getPosATL player)) >= 950
};

private _bonusMarker = "";
if (count _validMarkers > 0) then {
    _bonusMarker = [_validMarkers, player] call BIS_fnc_nearestPosition;
} else {
    if (count _candidateMarkers > 0) then {
        private _furthest = _candidateMarkers select 0;
        private _maxDist = 0;
        {
            private _d = (getMarkerPos _x) distance2D (getPosATL player);
            if (_d > _maxDist) then {
                _maxDist = _d;
                _furthest = _x;
            };
        } forEach _candidateMarkers;
        _bonusMarker = _furthest;
    } else {
        _bonusMarker = _locMarker;
    };
};

_bonusMarker setMarkerAlpha 1;

["STR_LL_Radio_Emergency_Call"] spawn LL_fnc_radioMessage;

sleep 4.0;

private _targetPos = getMarkerPos _bonusMarker;

[
    group player,
    ["task_bonus_move"],
    [
        localize "STR_LL_Task_Bonus_Move_Desc",
        localize "STR_LL_Task_Bonus_Move_Title",
        localize "STR_LL_Task_Bonus_Move_Marker"
    ],
    _targetPos,
    "ASSIGNED",
    10,
    true,
    "move",
    false
] call BIS_fnc_taskCreate;

["task_bonus_move", true] call BIS_fnc_taskSetCurrent;

waitUntil {
    sleep 2;
    ({ alive _x && (_x distance2D _targetPos) < 500 } count (allPlayers + switchableUnits + [player])) > 0 || { missionNamespace getVariable ["LL_g_extractionStarted", false] }
};

if (missionNamespace getVariable ["LL_g_extractionStarted", false]) exitWith {
    ["task_bonus_move", "CANCELED", true] call BIS_fnc_taskSetState;
};

["task_bonus_move", "SUCCEEDED", true] call BIS_fnc_taskSetState;

sleep 3.0;

private _radius = (markerSize _bonusMarker) select 0;
if (_radius == 0) then { _radius = 350; };
{ _x setVariable ["LL_logic_occupied", false]; } forEach (nearestObjects [_targetPos, ["Logic", "Land_HelipadEmpty_F"], _radius + 150]);
missionNamespace setVariable ["LL_g_usedTaskPos", []];

private _pool = ["TASK_TRANSMISSION", "TASK_CAPTIVE", "TASK_HVT", "TASK_DOCUMENTS"] - _optionalTasks;
if (_pool isEqualTo []) then {
    _pool = ["TASK_TRANSMISSION", "TASK_CAPTIVE", "TASK_HVT", "TASK_DOCUMENTS"];
};
private _chosenTask = selectRandom _pool;

private _taskA3Id = switch (_chosenTask) do {
    case "TASK_CAPTIVE": { "task_d_captive" };
    case "TASK_HVT": { "task_d_hvt" };
    case "TASK_TRANSMISSION": { "task_d_transmission" };
    case "TASK_DOCUMENTS": { "task_d_documents" };
};
if ([_taskA3Id] call BIS_fnc_taskExists) then {
    [_taskA3Id] call BIS_fnc_deleteTask;
};

switch (_chosenTask) do {
    case "TASK_CAPTIVE": { [_bonusMarker] spawn LL_fnc_taskD_captive; };
    case "TASK_HVT": { [_bonusMarker] spawn LL_fnc_taskD_hvt; };
    case "TASK_TRANSMISSION": { [_bonusMarker] spawn LL_fnc_taskD_transmission; };
    case "TASK_DOCUMENTS": { [_bonusMarker] spawn LL_fnc_taskD_documents; };
};

[_taskA3Id] spawn {
    params ["_taskA3Id"];
    waitUntil { sleep 0.5; [_taskA3Id] call BIS_fnc_taskExists };
    [_taskA3Id, true] call BIS_fnc_taskSetCurrent;
};
