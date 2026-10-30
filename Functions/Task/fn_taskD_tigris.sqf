params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || _locMarker == "init") then { _locMarker = "marker_0"; };

private _centerPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 250; };

private _nearHelipads = nearestObjects [_centerPos, ["Land_HelipadEmpty_F"], _radius];
private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
private _validSpawnPoints = _nearHelipads select {
    private _candidate = _x;
    !(_candidate getVariable ["LL_logic_occupied", false]) && 
    { (_usedPositions findIf { _x distance2D _candidate < 25 }) == -1 }
};

if (count _validSpawnPoints == 0) then {
    private _fallback = _centerPos findEmptyPosition [10, 150, "B_Truck_01_transport_F"];
    if (count _fallback == 0) then { _fallback = _centerPos getPos [40, random 360]; };
    private _dummy = "Land_HelipadEmpty_F" createVehicle _fallback;
    _validSpawnPoints = [_dummy];
};

private _chosenPad = _validSpawnPoints select 0;
_chosenPad setVariable ["LL_logic_occupied", true];
private _posVeh = getPosATL _chosenPad;
if (typeOf _chosenPad == "Land_HelipadEmpty_F") then { deleteVehicle _chosenPad; };

_usedPositions pushBack _posVeh;
missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

_posVeh set [2, (_posVeh select 2) + 0.2];

private _numGroups = 2 + floor(random 3);
private _groupSizes = [];
for "_i" from 1 to _numGroups do {
    _groupSizes pushBack 2;
};
private _enemies = [];
private _groups = [];
private _classes = ["O_G_Soldier_F", "O_G_Soldier_GL_F", "O_G_Soldier_AR_F", "O_G_Soldier_LAT_F"];

for "_gIdx" from 0 to (_numGroups - 1) do {
    private _sz = _groupSizes select _gIdx;
    private _grp = createGroup [east, true];
    _grp setBehaviour "SAFE";
    _grp setSpeedMode "LIMITED";
    _grp setCombatMode "YELLOW";

    for "_u" from 1 to _sz do {
        private _cls = selectRandom _classes;
        private _spawnSpot = _posVeh getPos [15 + random 20, random 360];
        private _isUnitFemale = (random 1) < 0.15;
        private _unitClass = if (_isUnitFemale) then {
            if (isClass (configFile >> "CfgVehicles" >> "Max_Tak_woman1")) then { selectRandom MISSION_CivilianClasses_Female } else { _cls };
        } else {
            _cls
        };
        private _unit = _grp createUnit [_unitClass, _spawnSpot, [], 0, "CAN_COLLIDE"];
        [_unit] joinSilent _grp;
        _unit setVariable ["not_Random", true, true];
        _unit setPosASL _spawnSpot;
        _unit allowDamage false;
        [_unit] spawn { sleep 3; (_this select 0) allowDamage true; };
        [_unit, _isUnitFemale, true] call LL_fnc_applyTakistaniIdentity;

        _unit setSkill ["courage", 1];
        _unit allowFleeing 0;
        _enemies pushBack _unit;
        sleep 0.2;
    };

    if (_gIdx == 0) then {
        private _wp = _grp addWaypoint [_posVeh getPos [20, random 360], 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        private _wp2 = _grp addWaypoint [_posVeh getPos [30, random 360], 0];
        _wp2 setWaypointType "MOVE";
        private _wp3 = _grp addWaypoint [waypointPosition _wp, 0];
        _wp3 setWaypointType "CYCLE";
    } else {
        private _wp = _grp addWaypoint [_posVeh getPos [50, random 360], 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        private _wp2 = _grp addWaypoint [_posVeh getPos [60, random 360], 0];
        _wp2 setWaypointType "MOVE";
        private _wp3 = _grp addWaypoint [_posVeh getPos [50, random 360], 0];
        _wp3 setWaypointType "MOVE";
        private _wp4 = _grp addWaypoint [waypointPosition _wp, 0];
        _wp4 setWaypointType "CYCLE";
    };
    _groups pushBack _grp;
    sleep 0.3;
};

sleep 0.4;

private _vehClass = if (isClass (configFile >> "CfgVehicles" >> "CUP_O_Hilux_zu23_TK")) then { "CUP_O_Hilux_zu23_TK" } else { "O_G_Offroad_01_armed_F" };
private _dca = createVehicle [_vehClass, _posVeh, [], 0, "CAN_COLLIDE"];
_dca setPosATL _posVeh;
_dca allowDamage false;
[_dca] spawn { sleep 3; (_this select 0) allowDamage true; };
createVehicleCrew _dca;

{
    [_x, false, true] call LL_fnc_applyTakistaniIdentity;
} forEach (crew _dca);

(group (driver _dca)) setCombatMode "YELLOW";
(group (driver _dca)) setBehaviour "SAFE";
_dca setFuel 0; 
_dca setVariable ["LL_Task_Status", "WAIT"];

missionNamespace setVariable ["LL_Heli_Jammed", true];
missionNamespace setVariable ["LL_TaskDTigris_Finished", false];

private _subVehicles = "task_tigris_vehicles";

[
    group player,
    ["task_tigris"],
    [
        localize "STR_LL_Task_08_Desc",
        localize "STR_LL_Task_08_Title",
        ""
    ],
    [_dca, true],
    "AUTOASSIGNED",
    5,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

[
    group player,
    [_subVehicles, "task_tigris"],
    [
        localize "STR_LL_Task_08_MarkerVehicles",
        localize "STR_LL_Task_08_MarkerVehicles",
        ""
    ],
    [_dca, true],
    "AUTOASSIGNED",
    4,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

[_subVehicles, true] call BIS_fnc_taskSetCurrent;

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_Task08_Title", localize "STR_LL_Diary_Task08_Text"]]; } forEach (units group player);

LL_fnc_taskD_tigris_smokeRing = {
    params [
        ["_center", [0,0,0], [[]]],
        ["_maxRadius", 40, [0]],
        ["_duration", 3, [0]],
        ["_color", [0.8, 0.8, 0.8, 1], [[]]]
    ];

    private _source = createVehicleLocal ["#particlesource", _center];
    _source setParticleCircle [0.1, [2, 2, 0.1]];
    _source setParticleRandom [0.3, [0.2, 0.2, 0.1], [0.3, 0.3, 0.1], 0, 0.3, [0,0,0,0.05], 0, 0];
    _source setParticleParams [
        ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard",
        1, 2.5, [0,0,0], [0,0,0], 0, 1.275, 1, 0.2,
        [1.5, 6, 10], 
        [
            [_color select 0, _color select 1, _color select 2, (_color select 3) * 0.8],
            [_color select 0, _color select 1, _color select 2, (_color select 3) * 0.4],
            [_color select 0, _color select 1, _color select 2, 0]
        ],
        [0.5], 0.1, 0, "", "", _source
    ];
    _source setDropInterval 0.01;

    private _startTime = time;
    private _radius = 0.1;
    while { _radius < _maxRadius && (time - _startTime) < _duration } do {
        private _progress = (time - _startTime) / _duration;
        _radius = 0.1 + (_maxRadius - 0.1) * _progress;
        _source setParticleCircle [_radius, [2 * (1 - _progress), 2 * (1 - _progress), 0.1]];
        sleep 0.03;
    };
    deleteVehicle _source;
};

private _addActionCode = {
    params ["_target"];
    _target addAction [
        format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_03_Action"],
        {
            params ["_target", "_caller", "_actionId"];
            if (_target getVariable ["LL_TaskDTigris_Triggered", false]) exitWith {};
            _target setVariable ["LL_TaskDTigris_Triggered", true];
            _target removeAction _actionId;
            
            _caller playMove "AinvPknlMstpSnonWnonDnon_medic_1";
            ["STR_LL_Task_03_Warning", [], 6, false] spawn LL_fnc_radioMessage;

            private _pos = getPosATL _target;
            private _charge = createVehicle ["DemoCharge_F", _pos, [], 0, "CAN_COLLIDE"];
            _charge setPosATL _pos;

            [_target, _charge] spawn {
                params ["_tgt", "_chg"];
                sleep 40;
                if (!isNull _chg) then { deleteVehicle _chg; };
                if (!isNull _tgt && alive _tgt) then {
                    private _p = getPos _tgt;
                    "Bo_GBU12_LGB" createVehicle _p;
                    _tgt setDamage 1;
                };
            };
        },
        nil, 6.0, true, true, "", "alive _target && _this distance _target < 6 && (_target getVariable ['LL_Task_Status', 'WAIT'] == 'WAIT')", 6
    ];
};

[_dca] call _addActionCode;

[_posVeh, _dca, _subVehicles, _enemies, _groups] spawn {
    params ["_posVeh", "_dca", "_subVehicles", "_enemies", "_groups"];
    
    private _delay = 1200 + random 600;
    private _startTime = time;
    private _endTime = _startTime + _delay;

    private _lastMin = -1;
    while { time < _endTime && alive _dca && !(missionNamespace getVariable ["LL_TaskDTigris_Finished", false]) } do {
        private _timeLeft = _endTime - time;
        private _min = ceil (_timeLeft / 60);
        
        if (_min != _lastMin) then {
            _lastMin = _min;
            private _timerStr = format ["ETA %1 min", _min];
            
            if (["task_tigris_vehicles"] call BIS_fnc_taskState != "SUCCEEDED" && ["task_tigris_vehicles"] call BIS_fnc_taskState != "FAILED") then {
                [_subVehicles, [localize "STR_LL_Task_08_Desc", format ["%1 (%2)", localize "STR_LL_Task_08_MarkerVehicles", _timerStr], ""]] call BIS_fnc_taskSetDescription;
            };
        };
        sleep 5;
    };

    if (missionNamespace getVariable ["LL_TaskDTigris_Finished", false]) exitWith {};

    if (alive _dca) then {
        ["STR_LL_Task_08_Plane_Incoming"] spawn LL_fnc_radioMessage;

        private _angleIn = random 360;
        private _dist = 3000;
        private _spawnPos = _posVeh getPos [_dist, _angleIn];
        _spawnPos set [2, 600];
        private _targetPos = _posVeh getPos [_dist, _angleIn + 180];
        _targetPos set [2, 300];

        private _grpPlane = createGroup [independent, true];
        private _planeClass = if (isClass (configFile >> "CfgVehicles" >> "CUP_I_C130J_Cargo_RACS")) then { "CUP_I_C130J_Cargo_RACS" } else { "C_Plane_Civil_01_F" };
        private _plane = createVehicle [_planeClass, _spawnPos, [], 0, "FLY"];
        _plane setPosASL _spawnPos;
        _plane setDir (_spawnPos getDir _posVeh);
        _plane setVelocityModelSpace [0, 150, 0];
        _plane flyInHeight 300;
        createVehicleCrew _plane;
        (crew _plane) joinSilent _grpPlane;

        private _wp1 = _grpPlane addWaypoint [_posVeh, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "NORMAL";
        _wp1 setWaypointBehaviour "CARELESS";
        private _wp2 = _grpPlane addWaypoint [_targetPos, 0];
        _wp2 setWaypointType "MOVE";

        waitUntil { sleep 2; !alive _plane || _plane distance2D _targetPos < 500 };

        if (!alive _plane) then {
            ["STR_LL_Task_08_Plane_ShotDown"] spawn LL_fnc_radioMessage;
        };
        
        [_subVehicles, [localize "STR_LL_Task_08_Desc", localize "STR_LL_Task_08_MarkerVehicles", ""]] call BIS_fnc_taskSetDescription;
        [_subVehicles, "FAILED", true] call BIS_fnc_taskSetState;
        ["task_tigris", "FAILED", true] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["LL_TaskDTigris_Finished", true];

        if (alive _plane) then {
            { deleteVehicle _x; } forEach (crew _plane);
            deleteVehicle _plane;
        };
        deleteGroup _grpPlane;
    } else {
        [_subVehicles, [localize "STR_LL_Task_08_Desc", localize "STR_LL_Task_08_MarkerVehicles", ""]] call BIS_fnc_taskSetDescription;
        [_subVehicles, "SUCCEEDED", true] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["LL_Heli_Jammed", false];
        ["STR_LL_Heli_Action_Unjammed"] spawn LL_fnc_radioMessage;

        private _flyoverDelay = 120 + (random 180);
        private _flyoverEnd = time + _flyoverDelay;

        private _lastFlyoverMin = -1;
        while { time < _flyoverEnd } do {
            private _rem = _flyoverEnd - time;
            private _min = ceil (_rem / 60);
            if (_min != _lastFlyoverMin) then {
                _lastFlyoverMin = _min;
                private _etaText = format ["(Survol cargo ETA %1 min)", _min];
                ["task_tigris", [localize "STR_LL_Task_08_Desc", format ["%1 %2", localize "STR_LL_Task_08_Title", _etaText], ""]] call BIS_fnc_taskSetDescription;
            };
            sleep 5;
        };

        ["STR_LL_Task_08_Plane_Incoming"] spawn LL_fnc_radioMessage;

        private _angleIn = random 360;
        private _dist = 2800;
        private _spawnPos = _posVeh getPos [_dist, _angleIn];
        _spawnPos set [2, 65];

        private _planeClass = if (isClass (configFile >> "CfgVehicles" >> "CUP_I_C130J_RACS")) then {
            "CUP_I_C130J_RACS"
        } else {
            if (isClass (configFile >> "CfgVehicles" >> "CUP_I_C130J_Cargo_RACS")) then {
                "CUP_I_C130J_Cargo_RACS"
            } else {
                "C_Plane_Civil_01_F"
            }
        };

        private _plane = createVehicle [_planeClass, _spawnPos, [], 0, "FLY"];
        _plane setPosATL _spawnPos;
        _plane setDir (_spawnPos getDir _posVeh);
        _plane setVelocityModelSpace [0, 130, 0];
        _plane flyInHeight 65;
        _plane allowDamage false;

        createVehicleCrew _plane;
        private _planeCrew = crew _plane;
        { _x allowDamage false; } forEach _planeCrew;

        private _grpPlane = group driver _plane;
        _grpPlane setBehaviour "CARELESS";
        _grpPlane setCombatMode "BLUE";
        _grpPlane setSpeedMode "FULL";

        _plane doMove _posVeh;

        private _flyStartTime = time;
        waitUntil {
            sleep 0.5;
            !alive _plane || { _plane distance2D _posVeh < 250 } || { time - _flyStartTime > 60 }
        };

        private _exitPos = _posVeh getPos [4000, _spawnPos getDir _posVeh];
        _exitPos set [2, 250];
        _plane doMove _exitPos;
        _plane flyInHeight 250;

        waitUntil {
            sleep 1.0;
            !alive _plane || { _plane distance2D _posVeh > 3200 } || { time - _flyStartTime > 130 }
        };

        if (alive _plane) then {
            ["STR_LL_Task_08_Plane_Safe"] spawn LL_fnc_radioMessage;
            ["task_tigris", [localize "STR_LL_Task_08_Desc", localize "STR_LL_Task_08_Title", ""]] call BIS_fnc_taskSetDescription;
            ["task_tigris", "SUCCEEDED", true] call BIS_fnc_taskSetState;
            missionNamespace setVariable ["LL_TaskDTigris_Finished", true];
            
            { deleteVehicle _x; } forEach _planeCrew;
            deleteVehicle _plane;
        } else {
            ["STR_LL_Task_08_Plane_ShotDown"] spawn LL_fnc_radioMessage;
            ["task_tigris", "FAILED", true] call BIS_fnc_taskSetState;
            missionNamespace setVariable ["LL_TaskDTigris_Finished", true];
        };
        deleteGroup _grpPlane;
    };

    private _allEnemies = [];
    { if (!isNull _x && alive _x) then { _allEnemies pushBack _x; }; } forEach _enemies;
    if (!isNull _dca) then {
        { if (!isNull _x && alive _x && !(_x in _allEnemies)) then { _allEnemies pushBack _x; }; } forEach (crew _dca);
    };
    [_allEnemies] spawn LL_fnc_taskCleanup;
    missionNamespace setVariable ["LL_Heli_Jammed", false];
};
