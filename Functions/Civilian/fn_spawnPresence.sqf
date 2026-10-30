if (!isServer) exitWith {};

params [
    ["_spawnCenter", objNull, [objNull, []]],
    ["_spawnSide", civilian, [civilian]],
    ["_maxUnits", 30, [0]],
    ["_spawnRadius", 500, [0]]
];

private _PATROL_DIST = 200;
private _refPos = [];

if (typeName _spawnCenter == "OBJECT") then {
    if (isNull _spawnCenter) exitWith {};
    _refPos = getPosATL _spawnCenter;
} else {
    if (count _spawnCenter == 0) exitWith {};
    _refPos = _spawnCenter;
};

if (count _refPos == 0) exitWith {};

private _buildings = nearestObjects [_refPos, ["House","Building"], _spawnRadius];
if (count _buildings == 0) exitWith {};

private _isEnemy = (_spawnSide == east || _spawnSide == opfor || _spawnSide == independent);
private _spawnedUnits = 0;

{
    if (_spawnedUnits >= _maxUnits) exitWith {};
    
    private _bPosList = _x buildingPos -1;
    if (count _bPosList > 0) then {
        private _bPos = selectRandom _bPosList;
        _bPos set [2, (_bPos select 2) + 0.1];
        
        private _grp = createGroup _spawnSide;
        private _fClasses = missionNamespace getVariable ["MISSION_CivilianClasses_Female", []];
        private _isFemale = (random 1) < 0.40 && { count _fClasses > 0 };
        private _defaultClass = if (_spawnSide == civilian) then { "C_man_1" } else { "O_G_Soldier_F" };
        private _class = if (_isFemale) then {
            selectRandom _fClasses
        } else {
            _defaultClass
        };
        
        private _unit = _grp createUnit [_class, _bPos, [], 0, "NONE"];
        [_unit] joinSilent _grp;
        _unit setVariable ["not_Random", true, true];
        _unit setPosATL _bPos;
        _unit allowDamage false;
        _unit setDamage 0;
        _unit setBleedingRemaining 0;
        [_unit] spawn {
            sleep 3;
            if (!isNull (_this select 0)) then {
                (_this select 0) setDamage 0;
                (_this select 0) setBleedingRemaining 0;
                (_this select 0) allowDamage true;
            };
        };
        
        [_unit, _isFemale, _isEnemy] call LL_fnc_applyTakistaniIdentity;
        
        [_grp, getPosATL _unit, _PATROL_DIST] call BIS_fnc_taskPatrol;
        
        _spawnedUnits = _spawnedUnits + 1;
    };
} forEach _buildings;
