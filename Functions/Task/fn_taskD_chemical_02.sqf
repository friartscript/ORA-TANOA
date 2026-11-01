/*
    Author: Friart Script
    Description: Déplacement et hélitransport lourd par hélicoptère CH-47F Chinook RACS (Tâche D-04).
    Gère l'approche tactique, l'appui-feu CAS de couverture, le vol stationnaire de précision, 
    l'élingage aux câbles PhysX, le levage vertical et le départ direct en CARELESS hors de la zone d'opération.
    Paramètres:
        _cargo (Object)   : Véhicule / citerne à extraire
        _dropPos (Array)  : Coordonnées de sortie / évacuation (optionnel)
*/

params [
    ["_cargo", objNull, [objNull]],
    ["_dropPos", nil]
];

if (isNull _cargo || !alive _cargo) exitWith {};

// --- Calcul des points d'apparition (1500m du joueur) et de sortie de l'hélicoptère ---
private _playerPos = if (!isNull player && { alive player }) then { getPosATL player } else { getPosATL _cargo };
private _spawnDir = random 360;
private _spawnPosHeli = _playerPos getPos [1500, _spawnDir];

if (_spawnPosHeli select 0 < 50 || { _spawnPosHeli select 0 > (worldSize - 50) || { _spawnPosHeli select 1 < 50 || { _spawnPosHeli select 1 > (worldSize - 50) } } }) then {
    _spawnPosHeli = [50, 50, 250];
} else {
    _spawnPosHeli set [2, 250];
};

if (isNil "_dropPos") then {
    private _exitDir = (_spawnDir + 150 + random 60) % 360;
    _dropPos = _playerPos getPos [2500, _exitDir];
    if (_dropPos select 0 < 50 || { _dropPos select 0 > (worldSize - 50) || { _dropPos select 1 < 50 || { _dropPos select 1 > (worldSize - 50) } } }) then {
        _dropPos = [worldSize - 50, worldSize - 50, 150];
    } else {
        _dropPos set [2, 150];
    };
};

// --- Création de l'hélicoptère lourd CH-47F Chinook RACS et équipage ---
private _heli = createVehicle ["CUP_I_CH47F_VIV_RACS", _spawnPosHeli, [], 0, "FLY"];
_heli setPosATL _spawnPosHeli;
createVehicleCrew _heli;

private _grp = group driver _heli;
private _crew = crew _heli;
private _pilot = driver _heli;
private _gunners = _crew select { _x != _pilot };
private _ropes = [];

private _fnc_heliAbort = {
    params ["_heli", "_grp", "_crew", "_pilot", "_dropPos", ["_ropes", []]];
    if (!alive _heli) exitWith {
        { deleteVehicle _x; } forEach _crew;
        deleteVehicle _heli;
        if (!isNull _grp) then { deleteGroup _grp; };
    };

    { if (!isNull _x) then { ropeDestroy _x; }; } forEach _ropes;

    _pilot enableAI "MOVE";
    _pilot enableAI "PATH";
    _heli flyInHeight 160;
    _heli limitSpeed 160;

    _grp setBehaviour "AWARE";
    _grp setCombatMode "BLUE";

    {
        _x disableAI "FSM";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x disableAI "AUTOCOMBAT";
        _x disableAI "COVER";
        _x setBehaviour "AWARE";
        _x setCombatMode "BLUE";
    } forEach _crew;

    _pilot setBehaviour "AWARE";
    _pilot setCombatMode "BLUE";

    private _v = velocity _heli;
    _heli setVelocity [_v select 0, _v select 1, ((_v select 2) max 5)];

    while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
    private _wpEnd = _grp addWaypoint [_dropPos, 0];
    _wpEnd setWaypointType "MOVE";
    _wpEnd setWaypointSpeed "FULL";
    _wpEnd setWaypointBehaviour "AWARE";
    _heli doMove _dropPos;

    waitUntil {
        sleep 1;
        if (!alive _heli) exitWith { true };

        private _curAlt = (getPosATL _heli) select 2;
        if (_curAlt < 70) then {
            private _vel = velocity _heli;
            _heli setVelocity [_vel select 0, _vel select 1, ((_vel select 2) max 4)];
            _heli flyInHeight 160;
        };

        private _players = allPlayers select { alive _x };
        ({ _x distance2D _heli < 1500 } count _players) == 0 || (_heli distance2D _dropPos < 300)
    };

    { deleteVehicle _x; } forEach (crew _heli);
    deleteVehicle _heli;
    if (!isNull _grp) then { deleteGroup _grp; };
};

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

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
};

// --- PHASE D'APPUI-FEU / SÉCURISATION DU PÉRIMÈTRE ---
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

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
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

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
};

// --- 1. PRISE DE CONTRÔLE ET VOL STATIONNAIRE DE PRÉCISION ---
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

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
};

// --- 2. DESCENTE VERTICALE DOUCE VERS LE STATIONNAIRE BAS (8.0m ASL) ---
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

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
};

// --- 3. FIXATION DES ÉLINGUES ET DÉPLOIEMENT DES CÂBLES AU SOL ---
_cargo allowDamage false;
_cargo enableRopeAttach true;
_heli enableRopeAttach true;
_cargo disableCollisionWith _heli;
_heli disableCollisionWith _cargo;

_cargo setVectorDirAndUp [_fwd, [0, 0, 1]];
_cargo setMass 1;

private _attachedWithRopes = false;
_ropes = [];

// Connexion séquentielle des 4 câbles PhysX au camion au sol
private _ropeLen = 7.0;
_ropes pushBack (ropeCreate [_heli, [0, 2.0, -1.2], _cargo, [-1.2, 2.5, 0.4], _ropeLen]);
_ropes pushBack (ropeCreate [_heli, [0, 2.0, -1.2], _cargo, [1.2, 2.5, 0.4], _ropeLen]);
sleep 0.5;
_ropes pushBack (ropeCreate [_heli, [0, -2.0, -1.2], _cargo, [-1.2, -2.5, 0.4], _ropeLen]);
_ropes pushBack (ropeCreate [_heli, [0, -2.0, -1.2], _cargo, [1.2, -2.5, 0.4], _ropeLen]);

sleep 2.5;

_cargo removeAllEventHandlers "Killed";
_cargo removeAllEventHandlers "HandleDamage";

// Sécurité de nettoyage en cas de blocage (timeout 120s)
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

// --- 4. LEVAGE PHYSIQUE SÉCURISÉ (MONTÉE VERTICALE À 80M HORS DE PORTÉE DU RELIEF) ---
private _climbDistance = 80.0;
private _climbDuration = (_climbDistance / 3.5) max 10 min 20;
private _climbStart = time;
private _truckStartASL = getPosASL _cargo;
private _truckBaseZ = _truckStartASL select 2;

while { (time - _climbStart) < _climbDuration && alive _heli && alive _cargo } do {
    private _t = (time - _climbStart) / _climbDuration;
    private _smoothT = _t * _t * (3 - 2 * _t);
    private _curHeliZ = _targetHoverZ + (_climbDistance * _smoothT);

    _heli setPosASL [_cargoX, _cargoY, _curHeliZ];
    _heli setVelocity [0, 0, 2.5];
    _heli setVectorDirAndUp [_fwd, [0, 0, 1]];

    private _curTruckZ = (_curHeliZ - 8.0) max _truckBaseZ;
    _cargo setPosASL [_cargoX, _cargoY, _curTruckZ];
    _cargo setVelocity [0, 0, 2.5];
    _cargo setVectorDirAndUp [_fwd, [0, 0, 1]];

    sleep 0.02;
};

if (!alive _heli) exitWith {
    { deleteVehicle _x; } forEach crew _heli;
    deleteVehicle _heli;
    deleteGroup _grp;
};
if (!alive _cargo) exitWith {
    [_heli, _grp, _crew, _pilot, _dropPos, _ropes] spawn _fnc_heliAbort;
};

// --- 5. DÉPART SÉCURISÉ EN VOL DE TRANSIT (PLUS DE COMBAT, ÉVITEMENT DE RELIEF ACTIF) ---
{ if (!isNull _x) then { ropeDestroy _x; }; } forEach _ropes;
_ropes = [];

_cargo attachTo [_heli, [0, 0, -8.0]];
_cargo setVectorDirAndUp [[0, 1, 0], [0, 0, 1]];
_attachedWithRopes = true;

// Neutralisation absolue de la physique du camion : 1 kg + désactivation de simulation globale
// (Zéro traînée aérodynamique, zéro collision avec le décor/arbres, zéro interférence PhysX)
_cargo setMass 1;
_cargo enableSimulationGlobal false;
_cargo disableCollisionWith _heli;

// Impulsion initiale ascendante (+5 m/s) pour empêcher tout affaissement lié au cabré d'accélération
_heli setVelocity [(_fwd select 0) * 16, (_fwd select 1) * 16, 5.0];

_pilot enableAI "MOVE";
_pilot enableAI "PATH";
_heli flyInHeight 160;
_heli limitSpeed 140;

// AWARE + BLUE : Le pilote active l'altimétrie et le suivi de relief (évite collines et arbres),
// tandis que BLUE et les IA de combat coupées empêchent tout engagement ou déviation.
_grp setBehaviour "AWARE";
_grp setCombatMode "BLUE";

{
    _x disableAI "FSM";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "AUTOCOMBAT";
    _x disableAI "COVER";
    _x setBehaviour "AWARE";
    _x setCombatMode "BLUE";
} forEach _crew;

_pilot setBehaviour "AWARE";
_pilot setCombatMode "BLUE";

while { count (waypoints _grp) > 0 } do { deleteWaypoint [_grp, 0]; };
private _wpEnd = _grp addWaypoint [_dropPos, 0];
_wpEnd setWaypointType "MOVE";
_wpEnd setWaypointSpeed "FULL";
_wpEnd setWaypointBehaviour "AWARE";
_heli doMove _dropPos;

// --- 6. VALIDATION DE L'OBJECTIF TACTIQUE ---
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

// Attente que l'hélicoptère s'éloigne au loin et disparaisse avec le camion hors de vue des joueurs
// Boucle de sécurité anti-crash relief
waitUntil {
    sleep 1;
    if (!alive _heli) exitWith { true };

    // Sécurité anti-collision relief : correction immédiate si l'altitude descend sous 70m AGL
    private _curAlt = (getPosATL _heli) select 2;
    if (_curAlt < 70) then {
        private _v = velocity _heli;
        _heli setVelocity [_v select 0, _v select 1, ((_v select 2) max 4)];
        _heli flyInHeight 160;
    };

    private _players = allPlayers select { alive _x };
    ({ _x distance2D _heli < 1500 } count _players) == 0 || (_heli distance2D _dropPos < 300)
};

// Suppression simultanée et propre de l'hélicoptère, de son équipage et du camion emporté
if (!isNull _cargo) then {
    detach _cargo;
    deleteVehicle _cargo;
};
{ deleteVehicle _x; } forEach crew _heli;
deleteVehicle _heli;
deleteGroup _grp;
