params [
    ["_deadUnit", objNull, [objNull]]
];

private _allPlayersVars = ["player_0", "player_1", "player_2", "player_3", "player_4", "player_5"];
private _livingUnits = [];

{
    private _u = missionNamespace getVariable [_x, objNull];
    if (!isNull _u && { alive _u && _u != _deadUnit }) then {
        _livingUnits pushBack _u;
    };
} forEach _allPlayersVars;

if (count _livingUnits > 0) then {
    private _targetAI = selectRandom _livingUnits;
    
    _targetAI addScore (score _deadUnit);
    
    selectPlayer _targetAI;
    private _group = group _targetAI;
    _group selectLeader _targetAI;
    
    titleCut ["", "BLACK FADED", 999];
    
    [_targetAI, _group] spawn {
        params ["_targetAI", "_group"];
        sleep 1.5;
        _group selectLeader _targetAI;
        titleCut ["", "BLACK IN", 2];
        [_targetAI] call LL_fnc_addRoeActions;
        [] call LL_fnc_initSupport;

        // Restauration et synchronisation immédiate des marqueurs de tâches sur la nouvelle unité
        private _allCandidateTasks = [
            "task_chemical_1", "task_chemical_2", "task_chemical",
            "task_d_transmission_radio_0", "task_d_transmission_radio_1", "task_d_transmission",
            "task_d_documents",
            "task_d_hvt",
            "task_d_captive",
            "task_tigris_vehicles", "task_tigris",
            "task_bonus_move",
            "task_mandatory_move",
            "task_mandatory_civ",
            "task_mandatory_ext",
            "task_extraction"
        ];
        
        private _activeTask = "";
        {
            if ([_x] call BIS_fnc_taskExists) then {
                private _st = [_x] call BIS_fnc_taskState;
                if (_st in ["CREATED", "ASSIGNED", "AUTOASSIGNED"]) exitWith {
                    _activeTask = _x;
                };
            };
        } forEach _allCandidateTasks;
        
        if (_activeTask != "") then {
            [_activeTask, true] call BIS_fnc_taskSetCurrent;
        };
    };
} else {
    [_deadUnit] spawn {
        params ["_deadUnit"];
        
        private _cam = "camera" camCreate (getPosATL _deadUnit);
        _cam camSetTarget _deadUnit;
        _cam cameraEffect ["internal", "BACK"];
        _cam camSetRelPos [0, -5, 3];
        _cam camCommit 0;
        
        titleCut ["", "BLACK OUT", 4];
        sleep 4;
        
        failMission "LOSER";
    };
};
