/*
    Author: Friart Script
    Description: Gestion des effets chimiques, fuites toxiques, dégâts de zone et explosion catastrophique (Tâche D-04).
    Paramètres:
        _truck (Object) : Camion citerne chimique cible
*/

params [
    ["_truck", objNull, [objNull]]
];

if (isNull _truck || !alive _truck) exitWith {};

// --- Fonction interne : Génération de l'anneau de particules toxiques ---
private _fnc_smokeRing = {
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

// --- GESTIONNAIRE DE DÉGÂTS : Fuites de gaz toxique et seuils critiques ---
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

        // Seuil 1 : Fuite toxique initiale (fumée jaune et contamination proche)
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

        // Seuil 2 : Fuite toxique majeure (expansion du rayon de poison)
        if (_cumul >= 0.25 && { (_unit getVariable ["LL_Toxic_Level", 0]) < 2 }) then {
            _unit setVariable ["LL_Toxic_Level", 2];
        };

        // Seuil 3 : Détonation critique
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

    private _subTask = _unit getVariable ["LL_TaskDChemical_SubTask", ""];
    if (_subTask != "") then {
        [_subTask, "FAILED", true] call BIS_fnc_taskSetState;
    };

    if (!(missionNamespace getVariable ["LL_TaskDChemical_Failed", false])) then {
        missionNamespace setVariable ["LL_TaskDChemical_Failed", true];
        ["task_chemical", "FAILED", true] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["LL_g_taskInProgress", false];
    };

    private _posATL = getPosATL _unit;
    private _posASL = getPosASL _unit;

    "HelicopterExploBig" createVehicle _posATL;
    
    // Dispersion du nuage toxique
    private _fnc_ring = {
        params ["_center", "_maxRadius", "_duration", "_color"];
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
    [_posATL, 110, 8, [0.9, 0.85, 0.1, 0.85]] spawn _fnc_ring;

    // Onde de choc physique et létalité progressive
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

