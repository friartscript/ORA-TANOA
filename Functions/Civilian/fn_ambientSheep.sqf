if (!isServer) exitWith {};

params [
    ["_centerPos", [0,0,0], [[]]],
    ["_count", 8, [0]]
];

if (_centerPos isEqualTo [0,0,0]) exitWith {};

private _bestFlockPos = [];
private _bestScore = 99999;

for "_attempt" from 1 to 80 do {
    private _candPos = _centerPos getPos [15 + random 100, random 360];
    
    if (!surfaceIsWater _candPos) then {
        private _nearLogics = nearestObjects [_candPos, ["Logic", "Land_HelipadEmpty_F"], 8];
        private _nearBuildings = nearestObjects [_candPos, ["House", "Building"], 25];
        
        private _score = (count _nearLogics * 100) + (if (count _nearBuildings > 0) then { 0 } else { 50 });
        
        if (_score < _bestScore) then {
            _bestScore = _score;
            _bestFlockPos = _candPos;
        };
        
        if (_score == 0) exitWith {};
    };
};

if (count _bestFlockPos == 0) then {
    private _cand = _centerPos getPos [30, random 360];
    if (!surfaceIsWater _cand) then { _bestFlockPos = _cand; };
};

if (count _bestFlockPos == 0) exitWith {};

private _spawnedPoultry = [];
private _globalPoultry = missionNamespace getVariable ["MISSION_var_ambientPoultry", []];
private _grp = createGroup [civilian, true];

private _poultryClasses = ["Hen_random_F", "Hen_random_F", "Hen_random_F", "Cock_random_F", "Cock_white_F"];

for "_i" from 1 to _count do {
    private _pos = _bestFlockPos getPos [random 8, random 360];
    _pos set [2, 0];
    
    if (!surfaceIsWater _pos) then {
        private _class = selectRandom _poultryClasses;
        private _bird = _grp createUnit [_class, _pos, [], 0, "CAN_COLLIDE"];
        if (!isNull _bird) then {
            _bird setPosATL _pos;
            
            _bird disableAI "TARGET";
            _bird disableAI "AUTOTARGET";
            _bird disableAI "MINEDETECTION";
            _bird disableAI "SUPPRESSION";
            _bird disableAI "COVER";
            _bird disableAI "AUTOCOMBAT";
            
            _spawnedPoultry pushBack _bird;
            _globalPoultry pushBack _bird;
            
            [_bird, _bestFlockPos] spawn {
                params ["_unit", "_flockCenter"];
                while { !isNull _unit && { alive _unit } } do {
                    private _dest = _flockCenter getPos [random 15, random 360];
                    if (!surfaceIsWater _dest) then {
                        _unit doMove _dest;
                    };
                    sleep (10 + random 20);
                };
            };
        };
    };
};

missionNamespace setVariable ["MISSION_var_ambientPoultry", _globalPoultry];
missionNamespace setVariable ["MISSION_var_ambientSheep", _globalPoultry];

if (isNil "MISSION_var_poultryDespawnLoopStarted") then {
    MISSION_var_poultryDespawnLoopStarted = true;

    [] spawn {
        waitUntil {
            sleep 2;
            private _targetPos = missionNamespace getVariable ["MISSION_var_targetPos", [0,0,0]];
            !(_targetPos isEqualTo [0,0,0]) && { (player distance2D _targetPos) <= 800 }
        };

        while { true } do {
            sleep 120;
            private _allPoultry = missionNamespace getVariable ["MISSION_var_ambientPoultry", []];
            _allPoultry = _allPoultry select { !isNull _x && { alive _x } };

            private _remaining = [];
            {
                if ((player distance2D _x) >= 1500) then {
                    deleteVehicle _x;
                } else {
                    _remaining pushBack _x;
                };
            } forEach _allPoultry;

            missionNamespace setVariable ["MISSION_var_ambientPoultry", _remaining];
            missionNamespace setVariable ["MISSION_var_ambientSheep", _remaining];
        };
    };
};