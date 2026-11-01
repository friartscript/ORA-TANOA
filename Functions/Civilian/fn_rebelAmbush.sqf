if (!isServer) exitWith {};

params [
    ["_dropPos", [0,0,0], [[]]],
    ["_targetPos", [0,0,0], [[]]]
];

if (_dropPos isEqualTo [0,0,0]) exitWith {};

waitUntil {
    sleep 1;
    (missionNamespace getVariable ["MISSION_intro_finished", false]) || 
    { (player distance2D _dropPos) < 250 && isNull (findDisplay 7000) }
};

sleep (3 + random 5);

private _totalRebels = 2 + floor (random 6);
private _groupSizes = [];
private _remaining = _totalRebels;

while { _remaining > 0 } do {
    if (_remaining == 4) then {
        _groupSizes pushBack 2;
        _groupSizes pushBack 2;
        _remaining = 0;
    } else {
        if (_remaining == 2) then {
            _groupSizes pushBack 2;
            _remaining = 0;
        } else {
            if (_remaining >= 3) then {
                private _size = selectRandom [2, 3];
                if ((_remaining - _size) == 1) then { _size = 3; };
                _groupSizes pushBack _size;
                _remaining = _remaining - _size;
            } else {
                _groupSizes pushBack _remaining;
                _remaining = 0;
            };
        };
    };
};

private _excludedObjects = [
    missionNamespace getVariable ["post_camera", objNull],
    missionNamespace getVariable ["vehicles_spawner", objNull],
    missionNamespace getVariable ["post_lamp_0", objNull],
    missionNamespace getVariable ["post_lamp_1", objNull],
    missionNamespace getVariable ["post_lamp_2", objNull]
];

{
    private _grpSize = _x;

    sleep (5 + random 115);

    if (!alive player || { missionNamespace getVariable ["LL_g_extractionStarted", false] }) exitWith {};

    private _allLogics = (allMissionObjects "Logic") + (allMissionObjects "Land_HelipadEmpty_F");
    _allLogics = _allLogics select { !(_x in _excludedObjects) };

    private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
    _allLogics = _allLogics select {
        private _cand = _x;
        (_usedPositions findIf { _x distance2D _cand < 25 }) == -1
    };

    _allLogics = _allLogics select {
        (player distance2D _x) >= 750
    };

    if (count _allLogics > 0) then {
        private _selectedLogic = selectRandom _allLogics;
        private _basePos = getPosATL _selectedLogic;
        _basePos set [2, (_basePos select 2) + 0.2];

        _usedPositions pushBack _basePos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

        private _grpEast = createGroup [east, true];
        _grpEast setSpeedMode "NORMAL";
        _grpEast setBehaviour "AWARE";
        _grpEast setCombatMode "RED";

        for "_u" from 1 to _grpSize do {
            private _spawnPos = _basePos getPos [random 2, random 360];
            _spawnPos set [2, (_basePos select 2)];

            private _fEnemyClasses = (missionNamespace getVariable ["MISSION_EnemyClasses_Female", []]) select { isClass (configFile >> "CfgVehicles" >> _x) && _x != "O_G_Soldier_F" };
            private _isRebelFemale = (random 1) < 0.20 && { count _fEnemyClasses > 0 };
            private _unitClass = "O_G_Soldier_F";
            if (_isRebelFemale) then {
                private _picked = selectRandom _fEnemyClasses;
                if (!isNil "_picked" && { _picked != "" }) then {
                    _unitClass = _picked;
                };
            };

            private _unit = _grpEast createUnit [_unitClass, _spawnPos, [], 0, "CAN_COLLIDE"];
            _unit setVariable ["not_Random", true, true];
            _unit setPosATL _spawnPos;
            [_unit] joinSilent _grpEast;

            [_unit, _isRebelFemale, true] call LL_fnc_applyTakistaniIdentity;

            _unit addEventHandler ["Killed", {
                params ["_killedUnit", "_killer", "_instigator"];
                if (isNull _instigator) then { _instigator = _killer; };
                if (!isNull _instigator && { rating _instigator < 2000 }) then {
                    _instigator addRating (3000 - (rating _instigator));
                };
            }];
        };

        [_grpEast] spawn {
            params ["_grp"];
            while { ({ alive _x } count (units _grp)) > 0 && { !(missionNamespace getVariable ["LL_g_extractionStarted", false]) } } do {
                if (alive player) then {
                    (leader _grp) doMove (getPosATL player);
                };
                sleep 25;
            };

            if (missionNamespace getVariable ["LL_g_extractionStarted", false]) then {
                {
                    if (alive _x && { (_x distance2D player) > 1000 }) then {
                        deleteVehicle _x;
                    };
                } forEach (units _grp);
            };
        };
    };
} forEach _groupSizes;
