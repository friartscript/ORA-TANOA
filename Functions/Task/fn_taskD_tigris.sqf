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
        private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) };
        private _isUnitFemale = (random 1) < 0.15 && { count _fEnemyClasses > 0 };
        private _unitClass = _cls;
        if (_isUnitFemale) then {
            private _picked = selectRandom _fEnemyClasses;
            if (!isNil "_picked" && { _picked != "" }) then {
                _unitClass = _picked;
            };
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

private _vehClass = "CUP_O_Ural_ZU23_TKM";
if (!isClass (configFile >> "CfgVehicles" >> _vehClass)) then {
    if (isClass (configFile >> "CfgVehicles" >> "CUP_O_Ural_ZU23_TK_GUE")) then {
        _vehClass = "CUP_O_Ural_ZU23_TK_GUE";
    } else {
        if (isClass (configFile >> "CfgVehicles" >> "CUP_O_Ural_ZU23_SLA")) then {
            _vehClass = "CUP_O_Ural_ZU23_SLA";
        } else {
            if (isClass (configFile >> "CfgVehicles" >> "CUP_O_Hilux_zu23_TK")) then {
                _vehClass = "CUP_O_Hilux_zu23_TK";
            } else {
                _vehClass = "O_Truck_02_aa_F";
            };
        };
    };
};

private _dirVeh = random 360;
private _posVeh1 = _posVeh getPos [3.5, _dirVeh + 90];
private _posVeh2 = _posVeh getPos [3.5, _dirVeh - 90];
_posVeh1 set [2, 0.2];
_posVeh2 set [2, 0.2];

private _dca1 = createVehicle [_vehClass, _posVeh1, [], 0, "CAN_COLLIDE"];
_dca1 setPosATL _posVeh1;
_dca1 setDir _dirVeh;
_dca1 allowDamage false;
[_dca1] spawn { sleep 3; if (!isNull (_this select 0)) then { (_this select 0) allowDamage true; }; };
createVehicleCrew _dca1;

private _dca2 = createVehicle [_vehClass, _posVeh2, [], 0, "CAN_COLLIDE"];
_dca2 setPosATL _posVeh2;
_dca2 setDir _dirVeh;
_dca2 allowDamage false;
[_dca2] spawn { sleep 3; if (!isNull (_this select 0)) then { (_this select 0) allowDamage true; }; };
createVehicleCrew _dca2;

_dca1 setFuel 0;
_dca2 setFuel 0;
_dca1 setVariable ["LL_Task_Status", "WAIT"];
_dca2 setVariable ["LL_Task_Status", "WAIT"];

{
    [_x, false, true] call LL_fnc_applyTakistaniIdentity;
} forEach ((crew _dca1) + (crew _dca2));

if (!isNull (driver _dca1)) then {
    (group (driver _dca1)) setCombatMode "YELLOW";
    (group (driver _dca1)) setBehaviour "SAFE";
};
if (!isNull (driver _dca2)) then {
    (group (driver _dca2)) setCombatMode "YELLOW";
    (group (driver _dca2)) setBehaviour "SAFE";
};

missionNamespace setVariable ["LL_Heli_Jammed", true];
missionNamespace setVariable ["LL_TaskDTigris_Finished", false];

private _subVehicles = "task_tigris_vehicles";
private _subVeh1 = "task_tigris_veh_1";
private _subVeh2 = "task_tigris_veh_2";

[
    group player,
    ["task_tigris"],
    [
        localize "STR_LL_Task_08_Desc",
        localize "STR_LL_Task_08_Title",
        ""
    ],
    _posVeh,
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
    _posVeh,
    "AUTOASSIGNED",
    4,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

[
    group player,
    [_subVeh1, _subVehicles],
    [
        localize "STR_LL_Task_08_MarkerVehicles",
        format ["%1 #1", localize "STR_LL_Task_08_MarkerVehicles"],
        ""
    ],
    [_dca1, true],
    "AUTOASSIGNED",
    3,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

[
    group player,
    [_subVeh2, _subVehicles],
    [
        localize "STR_LL_Task_08_MarkerVehicles",
        format ["%1 #2", localize "STR_LL_Task_08_MarkerVehicles"],
        ""
    ],
    [_dca2, true],
    "AUTOASSIGNED",
    3,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

[_subVehicles, true] call BIS_fnc_taskSetCurrent;

[_dca1, _subVeh1] spawn {
    params ["_dca", "_sub"];
    waitUntil { sleep 1; isNull _dca || !alive _dca };
    [_sub, "SUCCEEDED", true] call BIS_fnc_taskSetState;
};

[_dca2, _subVeh2] spawn {
    params ["_dca", "_sub"];
    waitUntil { sleep 1; isNull _dca || !alive _dca };
    [_sub, "SUCCEEDED", true] call BIS_fnc_taskSetState;
};

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_Task08_Title", localize "STR_LL_Diary_Task08_Text"]]; } forEach (units group player);

private _addActionCode = {
    params ["_target"];
    _target addAction [
        format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_D_Transmission_Action"],
        {
            params ["_target", "_caller", "_actionId"];
            if (_target getVariable ["LL_TaskD_Tigris_Triggered", false]) exitWith {};
            _target setVariable ["LL_TaskD_Tigris_Triggered", true, true];
            
            _target removeAction _actionId;
            _caller playActionNow "PutDown";
            
            private _pos = getPosATL _target;
            private _charge = createVehicle ["DemoCharge_F", _pos, [], 0, "CAN_COLLIDE"];
            _charge attachTo [_target, [0, -2.0, 0.4]];
            _charge setVectorUp [0, 0, 1];
            
            [_target, _charge] spawn {
                params ["_veh", "_charge"];
                
                private _light = "#lightpoint" createVehicleLocal (getPosATL _charge);
                _light attachTo [_charge, [0, 0, 0.15]];
                _light setLightColor [1.0, 0.45, 0.05];
                _light setLightAmbient [0.25, 0.1, 0.02];
                _light setLightBrightness 0.15;
                _light setLightAttenuation [0.5, 1, 0, 0.5, 1, 5];
                _light setLightDayLight true;
                _light setLightUseFlare true;
                _light setLightFlareSize 0.25;
                _light setLightFlareMaxDistance 60;

                private _elapsed = 0;
                while { _elapsed < 25 && !isNull _veh && !isNull _charge && alive _veh } do {
                    sleep 1;
                    _elapsed = _elapsed + 1;
                };

                private _steps = [
                    [4, 1.5, 1.0],
                    [5, 0.8, 1.1],
                    [6, 0.5, 1.2],
                    [6, 0.22, 1.35],
                    [10, 0.1, 1.5]
                ];

                {
                    _x params ["_count", "_interval", "_pitch"];
                    for "_i" from 1 to _count do {
                        if (isNull _veh || isNull _charge || !alive _veh) exitWith {};
                        playSound3D ["A3\Sounds_F\sfx\beep_target.wss", _charge, false, getPosASL _charge, 1.5, _pitch, 75];
                        _light setLightBrightness 0.5;
                        sleep 0.06;
                        _light setLightBrightness 0.15;
                        sleep (_interval - 0.06);
                    };
                    if (isNull _veh || isNull _charge || !alive _veh) exitWith {};
                } forEach _steps;

                if (!isNull _light) then { deleteVehicle _light; };
                if (!isNull _charge) then { deleteVehicle _charge; };

                if (!isNull _veh && { alive _veh }) then {
                    private _expPos = getPosATL _veh;
                    "Bo_GBU12_LGB" createVehicle _expPos;
                    "HelicopterExploBig" createVehicle _expPos;
                    _veh setDamage 1;
                };
            };
        },
        nil, 6.0, true, true, "", "alive _target && _this distance _target < 7 && !(_target getVariable ['LL_TaskD_Tigris_Triggered', false])", 7
    ];
};

[_dca1] call _addActionCode;
[_dca2] call _addActionCode;

[_posVeh, _dca1, _dca2, _subVehicles, _enemies, _groups] spawn {
    params ["_posVeh", "_dca1", "_dca2", "_subVehicles", "_enemies", "_groups"];
    
    private _delay = 1200 + random 600;
    private _startTime = time;
    private _endTime = _startTime + _delay;

    private _lastMin = -1;
    while { time < _endTime && ((alive _dca1 && !isNull _dca1) || (alive _dca2 && !isNull _dca2)) && !(missionNamespace getVariable ["LL_TaskDTigris_Finished", false]) } do {
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

    if ((alive _dca1 && !isNull _dca1) || (alive _dca2 && !isNull _dca2)) then {
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
    if (!isNull _dca1) then {
        { if (!isNull _x && alive _x && !(_x in _allEnemies)) then { _allEnemies pushBack _x; }; } forEach (crew _dca1);
    };
    if (!isNull _dca2) then {
        { if (!isNull _x && alive _x && !(_x in _allEnemies)) then { _allEnemies pushBack _x; }; } forEach (crew _dca2);
    };
    [_allEnemies] spawn LL_fnc_taskCleanup;
    missionNamespace setVariable ["LL_Heli_Jammed", false];
};
