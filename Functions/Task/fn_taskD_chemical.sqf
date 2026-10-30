params [
    ["_locMarker", "", [""]]
];

if (_locMarker == "" || _locMarker == "init") then { _locMarker = "marker_0"; };

private _centerPos = getMarkerPos _locMarker;
private _radius = (markerSize _locMarker) select 0;
if (_radius == 0) then { _radius = 250; };

private _nearHelipads = nearestObjects [_centerPos, ["Land_HelipadEmpty_F"], _radius];
private _nearLogics = nearestObjects [_centerPos, ["Logic"], _radius];

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

private _numTrucks = 1 + floor(random 2);
if (_numTrucks > count _validSpawnPoints) then { _numTrucks = count _validSpawnPoints; };
if (_numTrucks < 1) then { _numTrucks = 1; };

private _selectedLogics = [];
private _shuffled = _validSpawnPoints call BIS_fnc_arrayShuffle;
for "_i" from 0 to (_numTrucks - 1) do {
    private _chosen = _shuffled select _i;
    _chosen setVariable ["LL_logic_occupied", true];
    _selectedLogics pushBack _chosen;
    _usedPositions pushBack (getPosATL _chosen);
};

missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

missionNamespace setVariable ["LL_TaskDChemical_RemainingTrucks", []];
missionNamespace setVariable ["LL_TaskDChemical_AllUnits", []];
missionNamespace setVariable ["LL_TaskDChemical_Failed", false];

private _allTrucks = [];
private _allUnits = [];

LL_fnc_taskD_chemical_smokeRing = {
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

LL_fnc_taskD_chemical_heliExtract = {
    params ["_cargo", "_dropPos"];
    
    if (!alive _cargo) exitWith {};

    private _spawnPosHeli = (getPosATL _cargo) getPos [1200, random 360];
    if (_spawnPosHeli select 0 < 50 || { _spawnPosHeli select 0 > (worldSize - 50) || { _spawnPosHeli select 1 < 50 || { _spawnPosHeli select 1 > (worldSize - 50) } } }) then {
        _spawnPosHeli = [50, 50, 250];
    } else {
        _spawnPosHeli set [2, 250];
    };

    if (isNil "_dropPos") then {
        _dropPos = _spawnPosHeli getPos [1500, random 360];
        if (_dropPos select 0 < 50 || { _dropPos select 0 > (worldSize - 50) || { _dropPos select 1 < 50 || { _dropPos select 1 > (worldSize - 50) } } }) then {
            _dropPos = [worldSize - 50, worldSize - 50, 150];
        } else {
            _dropPos set [2, 150];
        };
    };

    private _heli = createVehicle ["CUP_I_CH47F_VIV_RACS", _spawnPosHeli, [], 0, "FLY"];
    _heli setPosATL _spawnPosHeli;
    createVehicleCrew _heli;

    private _grp = group driver _heli;
    private _crew = crew _heli;
    private _pilot = driver _heli;
    private _gunners = _crew select { _x != _pilot };

    { _x allowDamage false; } forEach _crew;
    _heli allowDamage false;

    _heli disableCollisionWith _cargo;
    _cargo disableCollisionWith _heli;

    _grp setBehaviour "CARELESS";
    _grp setCombatMode "BLUE";

    {
        _x disableAI "FSM";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x disableAI "AUTOCOMBAT";
        _x disableAI "COVER";
    } forEach _crew;

    private _targetPos = getPosATL _cargo;
    _heli flyInHeight 70;
    _heli setVehicleAmmo 1;

    while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    private _wp = _grp addWaypoint [_targetPos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "CARELESS";
    _wp setWaypointSpeed "FULL";
    _heli doMove _targetPos;

    private _apTimer = 0;
    waitUntil {
        sleep 0.3;
        _apTimer = _apTimer + 0.3;
        (_heli distance2D _targetPos < 180) || _apTimer > 60 || !alive _heli || !alive _cargo
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    private _nearEnemies = allUnits select { side group _x == east && alive _x && (_x distance2D _targetPos < 500) };

    if (count _nearEnemies > 0) then {
        _heli flyInHeight 45;
        _heli limitSpeed 75;
        _heli setVehicleAmmo 1;

        _grp setBehaviour "COMBAT";
        _grp setCombatMode "RED";

        {
            _x enableAI "FSM";
            _x enableAI "TARGET";
            _x enableAI "AUTOTARGET";
            _x enableAI "AUTOCOMBAT";
            _x enableAI "WEAPONAIM";
            _x enableAI "CHECKVISIBLE";
            _x setBehaviour "COMBAT";
            _x setCombatMode "RED";
            _x setSkill ["aimingAccuracy", 1.0];
            _x setSkill ["aimingSpeed", 1.0];
            _x setSkill ["aimingShake", 0.01];
            _x setSkill ["spotDistance", 1.0];
            _x setSkill ["spotTime", 1.0];
            _x setSkill ["courage", 1.0];
            _x setSkill ["commanding", 1.0];
        } forEach _gunners;

        _pilot disableAI "TARGET";
        _pilot disableAI "AUTOTARGET";
        _pilot disableAI "AUTOCOMBAT";
        _pilot disableAI "COVER";
        _pilot setBehaviour "CARELESS";

        while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
        private _wpCombat = _grp addWaypoint [_targetPos, 0];
        _wpCombat setWaypointType "LOITER";
        _wpCombat setWaypointLoiterRadius 120;
        _wpCombat setWaypointLoiterType "CIRCLE_L";
        _wpCombat setWaypointSpeed "LIMITED";

        private _combatTimer = 0;
        while { _combatTimer < 45 && alive _heli && alive _cargo } do {
            private _enemies = allUnits select { side group _x == east && alive _x && (_x distance2D _targetPos < 500 || _x distance2D _heli < 500) };
            if (count _enemies == 0) exitWith {};

            _heli setVehicleAmmo 1;
            {
                private _e = _x;
                _grp reveal [_e, 4];
                _heli reveal [_e, 4];
                {
                    _x reveal [_e, 4];
                    _x commandTarget _e;
                    _heli fireAtTarget [_e];
                } forEach _gunners;
            } forEach _enemies;

            sleep 1.5;
            _combatTimer = _combatTimer + 1.5;
        };

        while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };
    
    _grp setBehaviour "CARELESS";
    _grp setCombatMode "BLUE";

    {
        _x disableAI "FSM";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x disableAI "AUTOCOMBAT";
        _x disableAI "COVER";
    } forEach _crew;

    private _cargoPosASL = getPosASL _cargo;
    private _cargoX = _cargoPosASL select 0;
    private _cargoY = _cargoPosASL select 1;
    private _cargoASL = _cargoPosASL select 2;
    private _transitAlt = 45;
    private _hoverHeight = 7.5;

    _heli flyInHeight _transitAlt;
    _heli flyInHeightASL [_cargoASL + _transitAlt, _cargoASL + _transitAlt, _cargoASL + _transitAlt];
    _heli limitSpeed 60;

    while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    private _wpTransit = _grp addWaypoint [getPos _cargo, 0];
    _wpTransit setWaypointType "MOVE";
    _wpTransit setWaypointBehaviour "CARELESS";
    _wpTransit setWaypointSpeed "NORMAL";
    _heli doMove (getPos _cargo);

    private _transitTimer = 0;
    waitUntil {
        sleep 0.2;
        _transitTimer = _transitTimer + 0.2;
        (_heli distance2D _cargo < 30) || _transitTimer > 40 || !alive _heli || !alive _cargo
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    // 1. ARRIVÉE ET PRISE DE CONTRÔLE POUR VOL STATIONNAIRE DE PRÉCISION
    _pilot disableAI "MOVE";
    _pilot disableAI "PATH";
    doStop _heli;
    _heli limitSpeed 0;

    private _heliDir = getDir _heli;
    private _fwd = [sin _heliDir, cos _heliDir, 0];

    private _startHPos = getPosASL _heli;
    private _startZ = _startHPos select 2;
    private _alignDuration = 3.0;
    private _alignStart = time;

    while { (time - _alignStart) < _alignDuration && alive _heli && alive _cargo } do {
        private _t = (time - _alignStart) / _alignDuration;
        private _smoothT = _t * _t * (3 - 2 * _t);
        private _curX = (_startHPos select 0) + ((_cargoX - (_startHPos select 0)) * _smoothT);
        private _curY = (_startHPos select 1) + ((_cargoY - (_startHPos select 1)) * _smoothT);

        _heli setPosASL [_curX, _curY, _startZ];
        _heli setVelocity [0, 0, 0];
        _heli setVectorDirAndUp [_fwd, [0, 0, 1]];
        sleep 0.02;
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    // 2. DESCENTE VERTICALE DOUCE ET PARFAITEMENT CENTRÉE VERS LE STATIONNAIRE BAS (8.0m ASL)
    private _targetHoverZ = _cargoASL + 8.0;
    private _descentDistance = _startZ - _targetHoverZ;
    private _descendDuration = (_descentDistance / 3.0) max 6 min 15;
    private _descendStart = time;

    while { (time - _descendStart) < _descendDuration && alive _heli && alive _cargo } do {
        private _t = (time - _descendStart) / _descendDuration;
        private _smoothT = _t * _t * (3 - 2 * _t);
        private _curZ = _startZ - (_descentDistance * _smoothT);

        _heli setPosASL [_cargoX, _cargoY, _curZ];
        _heli setVelocity [0, 0, -2.0];
        _heli setVectorDirAndUp [_fwd, [0, 0, 1]];
        sleep 0.02;
    };
    _heli setPosASL [_cargoX, _cargoY, _targetHoverZ];
    _heli setVelocity [0, 0, 0];
    _heli setVectorDirAndUp [_fwd, [0, 0, 1]];

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    // 3. FIXATION DES SÉCURITÉS ET DÉPLOIEMENT DES CÂBLES AU SOL
    _cargo allowDamage false;
    _cargo enableRopeAttach true;
    _heli enableRopeAttach true;
    _cargo disableCollisionWith _heli;
    _heli disableCollisionWith _cargo;

    // Aligner le camion dans le même axe que l'hélicoptère (évite tout croisement des câbles)
    _cargo setVectorDirAndUp [_fwd, [0, 0, 1]];
    private _originalMass = getMass _cargo;
    _cargo setMass 50; // Masse allégée pour neutraliser tout couple PhysX déstabilisant sur l'hélicoptère

    private _attachedWithRopes = false;
    private _ropes = [];

    // Connexion séquentielle des 4 câbles PhysX au camion au sol
    private _ropeLen = 7.0;
    _ropes pushBack (ropeCreate [_heli, [0, 2.0, -1.2], _cargo, [-1.2, 2.5, 0.4], _ropeLen]);
    _ropes pushBack (ropeCreate [_heli, [0, 2.0, -1.2], _cargo, [1.2, 2.5, 0.4], _ropeLen]);
    sleep 0.5;
    _ropes pushBack (ropeCreate [_heli, [0, -2.0, -1.2], _cargo, [-1.2, -2.5, 0.4], _ropeLen]);
    _ropes pushBack (ropeCreate [_heli, [0, -2.0, -1.2], _cargo, [1.2, -2.5, 0.4], _ropeLen]);

    // Pause d'immersion : les 4 câbles relient le Chinook au camion au sol
    sleep 2.5;

    _cargo removeAllEventHandlers "Killed";
    _cargo removeAllEventHandlers "HandleDamage";

    // Sécurité globale (timeout 120s)
    [_heli, _cargo, _dropPos, _grp, _ropes] spawn {
        params ["_heli", "_cargo", "_dropPos", "_grp", "_ropes"];
        sleep 120;
        if (!isNull _heli && { alive _heli }) then {
            if (!isNull _cargo) then {
                detach _cargo;
                if (!isNull (getSlingLoad _heli)) then { _heli setSlingLoad objNull; };
                { if (!isNull _x) then { ropeDestroy _x; }; } forEach _ropes;
                deleteVehicle _cargo;
            };
            { deleteVehicle _x; } forEach (crew _heli);
            deleteVehicle _heli;
            if (!isNull _grp) then { deleteGroup _grp; };
        };
    };

    // 4. MONTÉE ET LEVAGE PHYSIQUE DU CAMION DANS LES AIRS (ASSIETTE STRICTEMENT VERROUILLÉE)
    private _climbDistance = 45.0;
    private _climbDuration = (_climbDistance / 3.0) max 8 min 16;
    private _climbStart = time;
    private _truckStartASL = getPosASL _cargo;
    private _truckBaseZ = _truckStartASL select 2;

    while { (time - _climbStart) < _climbDuration && alive _heli && alive _cargo } do {
        private _t = (time - _climbStart) / _climbDuration;
        private _smoothT = _t * _t * (3 - 2 * _t);
        private _curHeliZ = _targetHoverZ + (_climbDistance * _smoothT);

        _heli setPosASL [_cargoX, _cargoY, _curHeliZ];
        _heli setVelocity [0, 0, 2.5];
        _heli setVectorDirAndUp [_fwd, [0, 0, 1]]; // Maintien rigide de l'assiette horizontale

        // Le camion est hissé à la hauteur des élingues tendues (différence = 8.0m)
        private _curTruckZ = (_curHeliZ - 8.0) max _truckBaseZ;
        _cargo setPosASL [_cargoX, _cargoY, _curTruckZ];
        _cargo setVelocity [0, 0, 2.5];
        _cargo setVectorDirAndUp [_fwd, [0, 0, 1]];

        sleep 0.02;
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    // 5. TRANSIT SÉCURISÉ UNE FOIS EN VOL DE CROISIÈRE
    { if (!isNull _x) then { ropeDestroy _x; }; } forEach _ropes;
    _ropes = [];

    _cargo attachTo [_heli, [0, 0, -8.0]];
    _cargo setVectorDirAndUp [[0, 1, 0], [0, 0, 1]];
    _attachedWithRopes = true;

    // Impulsion initiale vers l'avant pour une reprise de vol fluide
    _heli setVelocity [(_fwd select 0) * 15, (_fwd select 1) * 15, 0];

    // Réactivation des commandes de vol du pilote IA
    _pilot enableAI "MOVE";
    _pilot enableAI "PATH";
    _heli flyInHeight 75;
    _heli limitSpeed 70;

    _grp setBehaviour "CARELESS";
    _grp setCombatMode "BLUE";

    while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    private _wpMove = _grp addWaypoint [_dropPos, 0];
    _wpMove setWaypointType "MOVE";
    _wpMove setWaypointSpeed "NORMAL";
    _wpMove setWaypointBehaviour "CARELESS";
    _heli doMove _dropPos;

    {
        _x enableAI "FSM";
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "WEAPONAIM";
        _x enableAI "CHECKVISIBLE";
        _x setBehaviour "COMBAT";
        _x setCombatMode "RED";
        _x setSkill ["aimingAccuracy", 1.0];
        _x setSkill ["aimingSpeed", 1.0];
        _x setSkill ["aimingShake", 0.01];
        _x setSkill ["spotDistance", 1.0];
        _x setSkill ["spotTime", 1.0];
        _x setSkill ["courage", 1.0];
        _x setSkill ["commanding", 1.0];
    } forEach _gunners;

    private _postClimbCombatTimer = 0;
    while { _postClimbCombatTimer < 15 && alive _heli && alive _cargo } do {
        private _enemies = allUnits select { side group _x == east && alive _x && (_x distance2D _heli < 650 || _x distance2D _cargo < 650) };
        _heli setVehicleAmmo 1;
        _heli doMove _dropPos;

        {
            private _e = _x;
            _grp reveal [_e, 4];
            _heli reveal [_e, 4];
            {
                _x reveal [_e, 4];
                _x commandTarget _e;
                _heli fireAtTarget [_e];
            } forEach _gunners;
        } forEach _enemies;

        sleep 1.5;
        _postClimbCombatTimer = _postClimbCombatTimer + 1.5;
    };

    if (!alive _heli || !alive _cargo) exitWith {
        { deleteVehicle _x; } forEach crew _heli;
        deleteVehicle _heli;
        deleteGroup _grp;
    };

    {
        _x disableAI "FSM";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x disableAI "AUTOCOMBAT";
        _x disableAI "COVER";
    } forEach _crew;

    _heli flyInHeight 120;
    _heli limitSpeed 140;

    while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    private _wpEnd = _grp addWaypoint [_dropPos, 0];
    _wpEnd setWaypointType "MOVE";
    _wpEnd setWaypointSpeed "FULL";
    _wpEnd setWaypointBehaviour "CARELESS";
    _heli doMove _dropPos;

    private _remaining = missionNamespace getVariable ["LL_TaskDChemical_RemainingTrucks", []];
    _remaining = _remaining - [_cargo];
    missionNamespace setVariable ["LL_TaskDChemical_RemainingTrucks", _remaining];

    private _subTask = _cargo getVariable ["LL_TaskDChemical_SubTask", ""];
    if (_subTask != "") then {
        [_subTask, "SUCCEEDED", true] call BIS_fnc_taskSetState;
    };

    if (count _remaining == 0) then {
        ["task_chemical", "SUCCEEDED", true] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["LL_g_taskInProgress", false];
    } else {
        private _nextTruck = _remaining select 0;
        private _nextSub = _nextTruck getVariable ["LL_TaskDChemical_SubTask", ""];
        if (_nextSub != "") then {
            [_nextSub, true] call BIS_fnc_taskSetCurrent;
        };
    };

    waitUntil { sleep 1; (_heli distance2D _dropPos < 300) || !alive _heli };

    if (_attachedWithRopes) then {
        detach _cargo;
    };
    if (!isNull (getSlingLoad _heli)) then {
        _heli setSlingLoad objNull;
    };
    { if (!isNull _x) then { ropeDestroy _x; }; } forEach _ropes;

    sleep 2;
    deleteVehicle _cargo;

    waitUntil {
        sleep 2;
        private _players = allPlayers select { alive _x };
        ({ _x distance2D _heli <= 1500 } count _players) == 0
    };

    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};


{
    private _selectedLogic = _x;
    private _spawnPos = getPosASL _selectedLogic;
    if (typeOf _selectedLogic == "Land_HelipadEmpty_F") then { deleteVehicle _selectedLogic; };
    _spawnPos set [2, (_spawnPos select 2) + 0.2];

    private _grp = createGroup [east, true];
    _grp setBehaviour "SAFE";
    _grp setSpeedMode "LIMITED";
    _grp setCombatMode "YELLOW";

    private _numGuards = 3 + floor (random 2);
    for "_g" from 1 to _numGuards do {
        private _isGuardFemale = (random 1) < 0.15;
        private _guardClass = if (_isGuardFemale) then {
            if (isClass (configFile >> "CfgVehicles" >> "Max_Tak_woman1")) then { selectRandom MISSION_CivilianClasses_Female } else { "O_G_Soldier_F" };
        } else {
            "O_G_Soldier_F"
        };
        private _guard = _grp createUnit [_guardClass, _spawnPos, [], 0, "CAN_COLLIDE"];
        [_guard] joinSilent _grp;
        _guard setVariable ["not_Random", true, true];
        _guard setPosASL _spawnPos;
        _guard allowDamage false;
        [_guard] spawn { sleep 3; (_this select 0) allowDamage true; };
        [_guard, _isGuardFemale, true] call LL_fnc_applyTakistaniIdentity;
        _allUnits pushBack _guard;
        sleep 0.2;
    };
    
    private _wp1 = _grp addWaypoint [_spawnPos getPos [30, random 360], 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "LIMITED";
    _wp1 setWaypointBehaviour "SAFE";
    private _wp2 = _grp addWaypoint [_spawnPos getPos [30, random 360], 0];
    _wp2 setWaypointType "MOVE";
    private _wp3 = _grp addWaypoint [_spawnPos getPos [30, random 360], 0];
    _wp3 setWaypointType "MOVE";
    private _wp4 = _grp addWaypoint [waypointPosition _wp1, 0];
    _wp4 setWaypointType "CYCLE";

    sleep 0.3;

    private _truckClasses = ["O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "I_Truck_02_fuel_F"];
    private _truck = createVehicle [selectRandom _truckClasses, _spawnPos, [], 0, "CAN_COLLIDE"];
    _truck setPosASL _spawnPos;
    _truck setDir (random 360);

    _truck setFuel 0;
    clearWeaponCargoGlobal _truck;
    clearItemCargoGlobal _truck;
    clearMagazineCargoGlobal _truck;
    clearBackpackCargoGlobal _truck;

    _allTrucks pushBack _truck;
    _allUnits pushBack _truck;

    _truck addEventHandler ["HandleDamage", {
        params ["_unit", "_selection", "_damage", "_source", "_projectile"];
        if (!alive _unit) exitWith { 0 };
        if (_unit getVariable ["LL_TaskDChemical_IsExploding", false]) exitWith { _damage };

        private _oldDmg = if (_selection != "") then { _unit getHit _selection } else { damage _unit };
        if (isNil "_oldDmg") then { _oldDmg = 0; };

        private _delta = (_damage - _oldDmg) max 0;
        
        if (_projectile != "" && _selection == "" && _delta < 0.008) then {
            _delta = 0.008; 
        };

        if (_delta > 0) then {
            private _clampedDelta = _delta min 0.15;
            private _cumul = (_unit getVariable ["LL_Truck_AccumDamage", 0]) + (_clampedDelta * 2.5);
            _unit setVariable ["LL_Truck_AccumDamage", _cumul];

            if (_cumul >= 0.05 && { (_unit getVariable ["LL_Toxic_Level", 0]) < 1 }) then {
                _unit setVariable ["LL_Toxic_Level", 1];

                [_unit] spawn {
                    params ["_truck"];
                    private _emitter = "#particlesource" createVehicleLocal (getPos _truck);
                    _emitter attachTo [_truck, [0, -1.5, 0.5]];
                    _emitter setParticleCircle [0.2, [0.2, 0.2, 0.1]];
                    _emitter setParticleRandom [0.5, [0.3, 0.3, 0.2], [0.3, 0.3, 0.2], 0, 0.2, [0, 0, 0, 0.05], 0, 0];
                    _emitter setParticleParams [
                        ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 6,
                        [0, 0, 0], [0, 0, 0.8], 0, 1.28, 1, 0.05, [0.8, 2.5, 4.5],
                        [[0.9, 0.85, 0.1, 0.5], [0.8, 0.75, 0.08, 0.25], [0.6, 0.55, 0.05, 0]], [0.125], 1, 0, "", "", _truck
                    ];
                    _emitter setDropInterval 0.03;

                    while { alive _truck && !isNull _emitter } do {
                        private _lvl = _truck getVariable ["LL_Toxic_Level", 1];
                        if (_lvl >= 2) then {
                            _emitter setDropInterval 0.015;
                            _emitter setParticleParams [
                                ["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48, 1], "", "Billboard", 1, 7,
                                [0, 0, 0], [0, 0, 1.2], 0, 1.28, 1, 0.05, [1.5, 4.0, 7.0],
                                [[0.92, 0.88, 0.1, 0.7], [0.82, 0.75, 0.08, 0.45], [0.6, 0.55, 0.05, 0]], [0.125], 1, 0, "", "", _truck
                            ];
                        };
                        sleep 1;
                    };
                    deleteVehicle _emitter;
                };

                [_unit] spawn {
                    params ["_truck"];
                    while { alive _truck } do {
                        private _lvl = _truck getVariable ["LL_Toxic_Level", 0];
                        if (_lvl >= 1) then {
                            private _radius = if (_lvl >= 2) then { 14 } else { 8 };
                            private _dmg = if (_lvl >= 2) then { 0.03 } else { 0.015 };
                            {
                                if (alive _x && _x distance2D _truck < _radius) then {
                                    _x setDamage ((damage _x) + _dmg);
                                    if (isPlayer _x) then {
                                        _x setFatigue 1;
                                        addCamShake [2, 1, 15];
                                    };
                                };
                            } forEach allUnits;
                        };
                        sleep 1;
                    };
                };
            };

            if (_cumul >= 0.25 && { (_unit getVariable ["LL_Toxic_Level", 0]) < 2 }) then {
                _unit setVariable ["LL_Toxic_Level", 2];
            };

            if (_cumul >= 0.65) then {
                _unit setVariable ["LL_TaskDChemical_IsExploding", true];
                _unit setDamage 1;
            };
        };

        if (_damage >= 0.89) then { _damage = 0.89; };
        _damage
    }];

    _truck setHitPointDamage ["HitEngine", 1];

    _truck addEventHandler ["Killed", {
        params ["_unit"];
        if (missionNamespace getVariable ["LL_TaskDChemical_Failed", false]) exitWith {};
        missionNamespace setVariable ["LL_TaskDChemical_Failed", true];

        ["task_chemical", "FAILED", true] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["LL_g_taskInProgress", false];

        private _subTask = _unit getVariable ["LL_TaskDChemical_SubTask", ""];
        if (_subTask != "") then {
            [_subTask, "FAILED", true] call BIS_fnc_taskSetState;
        };

        private _remaining = missionNamespace getVariable ["LL_TaskDChemical_RemainingTrucks", []];

        {
            private _t = _x;
            if (!isNull _t && _t != _unit) then {
                [_t] spawn {
                    params ["_t"];
                    waitUntil {
                        sleep 5;
                        isNull _t || !alive _t || ({ _x distance2D _t <= 800 } count (allPlayers select { alive _x })) == 0
                    };
                    if (!isNull _t) then { deleteVehicle _t; };
                };
            };
        } forEach _remaining;

        private _posATL = getPosATL _unit;
        private _posASL = getPosASL _unit;

        "HelicopterExploBig" createVehicle _posATL;
        [_posATL, 110, 8, [0.9, 0.85, 0.1, 0.85]] spawn LL_fnc_taskD_chemical_smokeRing;

        [_posATL, _posASL] spawn {
            params ["_posATL", "_posASL"];
            private _maxRadius = 110;
            private _duration = 8;
            private _startTime = time;
            private _damagedUnits = [];

            while { (time - _startTime) < _duration } do {
                private _progress = (time - _startTime) / _duration;
                private _currentRadius = _maxRadius * _progress;
                {
                    if (alive _x && !(_x in _damagedUnits)) then {
                        private _dist = _x distance _posATL;
                        if (_dist <= _currentRadius) then {
                            _damagedUnits pushBack _x;
                            if (_dist <= 30) then {
                                _x setDamage 1;
                            } else {
                                if (_dist <= 80) then {
                                    private _dmg = 0.5 + ((80 - _dist) / 50) * 0.4;
                                    _x setDamage ((damage _x) + _dmg);
                                    if (_x isKindOf "Man") then {
                                        private _dir = _posASL vectorFromTo (getPosASL _x);
                                        _dir set [2, 0.4];
                                        private _vel = velocity _x;
                                        _x setVelocity (_vel vectorAdd (_dir vectorMultiply 15));
                                    };
                                } else {
                                    if (_dist <= 110) then {
                                        private _dmg = 0.1 + ((110 - _dist) / 30) * 0.2;
                                        _x setDamage ((damage _x) + _dmg);
                                    };
                                };
                            };
                        };
                    };
                } forEach (allUnits select { alive _x });
                sleep 0.05;
            };
        };

        private _allUnits = missionNamespace getVariable ["LL_TaskDChemical_AllUnits", []];
        private _guards = _allUnits select { alive _x && _x isKindOf "Man" };
        [_guards] spawn LL_fnc_taskCleanup;
    }];



    _truck addAction [
        format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Task_04_Action"],
        {
            params ["_target", "_caller", "_actionId"];
            if (_target getVariable ["LL_TaskDChemical_Triggered", false]) exitWith {};
            _target setVariable ["LL_TaskDChemical_Triggered", true];

            _target removeAction _actionId;
            _caller playActionNow "PutDown";

            private _spawnPosHeli = (getPosATL _target) getPos [1500, random 360];
            private _dropPos = _spawnPosHeli getPos [1500, random 360];
            
            [_target, _dropPos] spawn LL_fnc_taskD_chemical_heliExtract;
        },
        nil, 6.0, true, true, "", "alive _target && _this distance _target < 15", 15
    ];

} forEach _selectedLogics;

missionNamespace setVariable ["LL_TaskDChemical_RemainingTrucks", _allTrucks];
missionNamespace setVariable ["LL_TaskDChemical_AllUnits", _allUnits];

private _mainDest = if (count _allTrucks > 0) then { [_allTrucks select 0, true] } else { _centerPos };

[
    group player,
    ["task_chemical"],
    [
        localize "STR_LL_Task_04_Desc",
        localize "STR_LL_Task_04_Title",
        ""
    ],
    _mainDest,
    "AUTOASSIGNED",
    5,
    true,
    "danger",
    false
] call BIS_fnc_taskCreate;

{
    private _truck = _x;
    private _idx = _forEachIndex + 1;
    private _subTaskID = format ["task_chemical_%1", _idx];
    private _subState = if (_idx == 1) then { "AUTOASSIGNED" } else { "CREATED" };
    private _subPrio = if (_idx == 1) then { 4 } else { 3 };
    
    [
        group player,
        [_subTaskID, "task_chemical"],
        [
            format ["%1 (%2/%3)", localize "STR_LL_Task_04_MarkerMain", _idx, count _allTrucks],
            format ["%1 (%2/%3)", localize "STR_LL_Task_04_MarkerMain", _idx, count _allTrucks],
            ""
        ],
        [_truck, true],
        _subState,
        _subPrio,
        true,
        "danger",
        false
    ] call BIS_fnc_taskCreate;
    
    _truck setVariable ["LL_TaskDChemical_SubTask", _subTaskID];
} forEach _allTrucks;

if (count _allTrucks > 0) then {
    ["task_chemical_1", true] call BIS_fnc_taskSetCurrent;
};

{ _x createDiaryRecord ["diary", [localize "STR_LL_Diary_Task04_Title", localize "STR_LL_Diary_Task04_Text"]]; } forEach (units group player);