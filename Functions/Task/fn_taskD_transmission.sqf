if (!isServer) exitWith {};

params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "") then { _locMarker = "marker_0"; };

private _centerPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 250; };
private _nearHelipads = nearestObjects [_centerPos, ["Land_HelipadEmpty_F"], _radius];
private _nearLogics = nearestObjects [_centerPos, ["Logic"], _radius];

private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
private _validSpawnPoints = (_nearLogics + _nearHelipads) select {
    private _candidate = _x;
    !(_candidate getVariable ["LL_logic_occupied", false]) && 
    { (_usedPositions findIf { _x distance2D _candidate < 20 }) == -1 }
};

if (count _validSpawnPoints < 2) then {
    while { count _validSpawnPoints < 2 } do {
        private _dummyLogic = "Logic" createVehicleLocal (_centerPos getPos [100 + random 200, random 360]);
        _validSpawnPoints pushBack _dummyLogic;
    };
};

private _numRadios = (1 + floor (random 2)) min (count _validSpawnPoints);
private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
private _selectedLogics = _shuffled select [0, _numRadios];

{
    _x setVariable ["LL_logic_occupied", true];
    private _p = getPosATL _x;
    if (_p isEqualTo [0,0,0]) then { _p = getPos _x; };
    _usedPositions pushBack _p;
} forEach _selectedLogics;
missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

missionNamespace setVariable ["LL_TaskD_Trans_AllUnits", [], true];
missionNamespace setVariable ["LL_TaskD_Trans_Destroyed", 0, true];
missionNamespace setVariable ["LL_TaskD_Trans_Total", _numRadios, true];

private _firstLogicPos = getPosATL (_selectedLogics select 0);
if (_firstLogicPos isEqualTo [0,0,0]) then { _firstLogicPos = getPos (_selectedLogics select 0); };

[
    group player,
    ["task_d_transmission"],
    [
        localize "STR_LL_Task_D_Transmission_Desc",
        localize "STR_LL_Task_D_Transmission_Title",
        localize "STR_LL_Task_D_Transmission_Marker"
    ],
    _firstLogicPos,
    "AUTOASSIGNED",
    5,
    true,
    "destroy",
    false
] call BIS_fnc_taskCreate;

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_TaskD_Transmission_Title", localize "STR_LL_Diary_TaskD_Transmission_Text"]]; } forEach (units group player);

for "_i" from 0 to (_numRadios - 1) do {
    private _logic = _selectedLogics select _i;
    private _spawnPos = getPosATL _logic;
    if (_spawnPos isEqualTo [0,0,0]) then { _spawnPos = getPos _logic; };
    _spawnPos set [2, (_spawnPos select 2) + 0.2];

    private _zoneGuards = [];
    
    private _numPatrols = 1 + floor (random 2);
    for "_p" from 1 to _numPatrols do {
        private _grp = createGroup [east, true];
        _grp setBehaviour "SAFE";
        _grp setCombatMode "RED";

        private _numGuards = 2 + floor (random 2);
        for "_g" from 1 to _numGuards do {
            private _guardPos = _spawnPos getPos [random 5, random 360];
            _guardPos set [2, (_spawnPos select 2)];
            private _isGuardFemale = (random 1) < 0.15;
            private _guardClass = if (_isGuardFemale) then {
                if (isClass (configFile >> "CfgVehicles" >> "Max_Tak_woman1")) then { selectRandom MISSION_CivilianClasses_Female } else { "O_G_Soldier_F" };
            } else {
                "O_G_Soldier_F"
            };
            private _guard = _grp createUnit [_guardClass, _guardPos, [], 0, "CAN_COLLIDE"];
            [_guard] joinSilent _grp;
            _guard setVariable ["not_Random", true, true];
            _guard setPosATL _guardPos;
            _guard allowDamage false;
            [_guard] spawn { sleep 3; (_this select 0) allowDamage true; };
            [_guard, _isGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
            _zoneGuards pushBack _guard;
            sleep 0.2;
        };
        [_grp, _spawnPos, 40 + random 60] call BIS_fnc_taskPatrol;
    };

    private _allUnits = missionNamespace getVariable ["LL_TaskD_Trans_AllUnits", []];
    _allUnits append _zoneGuards;
    missionNamespace setVariable ["LL_TaskD_Trans_AllUnits", _allUnits, true];

    private _radioClass = "RuggedTerminal_01_communications_F";
    private _radio = createVehicle [_radioClass, _spawnPos, [], 0, "CAN_COLLIDE"];
    _radio setPosATL [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) - 0.2];
    _radio setDir (getDir _logic);
    _radio setVectorUp [0, 0, 1];

    _radio allowDamage false;
    [_radio] spawn { sleep 3; (_this select 0) allowDamage true; };

    private _taskChildId = format ["task_d_transmission_radio_%1", _i];
    [
        group player,
        [_taskChildId, "task_d_transmission"],
        [
            localize "STR_LL_Task_D_Transmission_Sub_Desc",
            localize "STR_LL_Task_D_Transmission_Sub_Title",
            localize "STR_LL_Task_D_Transmission_Sub_Marker"
        ],
        [_radio, true],
        "AUTOASSIGNED",
        4,
        true,
        "destroy",
        false
    ] call BIS_fnc_taskCreate;

    _radio addAction [
        format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_D_Transmission_Action"],
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_radio", "_taskChildId"];
            
            if (_radio getVariable ["LL_TaskD_Trans_Triggered", false]) exitWith {};
            _radio setVariable ["LL_TaskD_Trans_Triggered", true, true];
            
            _target removeAction _actionId;
            _caller playActionNow "PutDown";
            
            private _pos = getPosATL _radio;
            private _charge = createVehicle ["DemoCharge_F", _pos, [], 0, "CAN_COLLIDE"];
            _charge attachTo [_radio, [0, 0, 0.2]];
            _charge setVectorUp [0, 0, 1];
            
            [_radio, _charge, _taskChildId] spawn {
                params ["_radio", "_charge", "_taskChildId"];
                
                // Lumière orange douce réhaussée et bien visible dans la nuit (diode / balise)
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

                // Phase 1 : 25 secondes d'attente (permet au joueur d'évacuer la zone)
                private _elapsed = 0;
                while { _elapsed < 25 && !isNull _radio && !isNull _charge } do {
                    sleep 1;
                    _elapsed = _elapsed + 1;
                };

                // Phase 2 : Les 15 dernières secondes avant l'explosion (bips accélérés et flashs orange synchronisés)
                private _steps = [
                    [4, 1.5, 1.0],    // 4 bips espacés de 1.5s  -> 6.0s (T-15s à T-9s)
                    [5, 0.8, 1.1],    // 5 bips espacés de 0.8s  -> 4.0s (T-9s à T-5s)
                    [6, 0.5, 1.2],    // 6 bips espacés de 0.5s  -> 3.0s (T-5s à T-2s)
                    [6, 0.22, 1.35],  // 6 bips espacés de 0.22s -> 1.32s (T-2s à T-0.7s)
                    [7, 0.10, 1.5]    // 7 bips ultra-rapides    -> 0.70s (T-0.7s à T-0s)
                ];

                {
                    _x params ["_count", "_interval", "_pitch"];
                    for "_i" from 1 to _count do {
                        if (isNull _radio || isNull _charge) exitWith {};
                        
                        // Flash orange et son natif Arma 3 de bip en 3D
                        if (!isNull _light) then {
                            _light setLightBrightness 0.5;
                            _light setLightFlareSize 0.5;
                        };
                        playSound3D ["A3\Sounds_F\sfx\beep_target.wss", _charge, false, getPosASL _charge, 2.8, _pitch, 60];
                        
                        sleep 0.06;
                        if (!isNull _light) then {
                            _light setLightBrightness 0.15;
                            _light setLightFlareSize 0.25;
                        };
                        sleep ((_interval - 0.06) max 0.01);
                    };
                    if (isNull _radio || isNull _charge) exitWith {};
                } forEach _steps;

                // Nettoyage de la lumière et de la charge avant la détonation
                if (!isNull _light) then { deleteVehicle _light; };
                if (!isNull _charge) then { deleteVehicle _charge; };
                
                private _pos = getPosATL _radio;
                "Bo_GBU12_LGB" createVehicle _pos;
                
                if (!isNull _radio) then { deleteVehicle _radio; };
                
                [_taskChildId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                
                private _destroyed = (missionNamespace getVariable ["LL_TaskD_Trans_Destroyed", 0]) + 1;
                missionNamespace setVariable ["LL_TaskD_Trans_Destroyed", _destroyed, true];
                private _total = missionNamespace getVariable ["LL_TaskD_Trans_Total", 1];
                
                if (_destroyed >= _total) then {
                    ["task_d_transmission", "SUCCEEDED", true] call BIS_fnc_taskSetState;
                    missionNamespace setVariable ["LL_g_taskInProgress", false, true];
                    
                    private _allUnits = missionNamespace getVariable ["LL_TaskD_Trans_AllUnits", []];
                    private _guards = _allUnits select { alive _x };
                    if (count _guards > 0) then {
                        [_guards] spawn LL_fnc_taskCleanup;
                    };
                } else {
                    if (["task_d_transmission_radio_1"] call BIS_fnc_taskExists) then {
                        ["task_d_transmission_radio_1", true] call BIS_fnc_taskSetCurrent;
                    };
                };
            };
        },
        [_radio, _taskChildId],
        10, true, true, "", "_this distance _target < 4", 4
    ];
};
