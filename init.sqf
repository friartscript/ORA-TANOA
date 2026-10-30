[] call LL_fnc_initTakistaniDB;
[] spawn LL_fnc_initSkills;
[] execVM "Functions\Player\fn_initIdentity.sqf";
[] execVM "Functions\Player\fn_initLoadout.sqf";

if (isServer) then {
    [] spawn LL_fnc_randomWeather;
    [] spawn LL_fnc_heliManager;
    [] spawn LL_fnc_droneManager;
    [] spawn LL_fnc_doorSecurity;
    [] spawn LL_fnc_playEzan;
    [] spawn LL_fnc_aiHealSelf;
    [] spawn LL_fnc_preventWater;
    [] spawn LL_fnc_identityManager;
};

if (!hasInterface) exitWith {};

MISSION_var_debug = true;

for "_i" from 0 to 5 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (isNull _u) then { _u = missionNamespace getVariable [format ["player_0%1", _i], objNull]; };
    if (!isNull _u) then {
        _u allowDamage false;
        if (rating _u < 5000) then { _u addRating (5000 - (rating _u)); };
        _u removeAllEventHandlers "HandleRating";
        _u addEventHandler ["HandleRating", {
            params ["_unit", "_rating"];
            if (_rating < 0) then { 0 } else { _rating };
        }];
    };
};

[] spawn {
    titleCut ["", "BLACK FADED", 999];
    waitUntil { !isNull player && time > 0 };
    ["OPEN"] spawn LL_fnc_spawn_main_menu;

    waitUntil { sleep 1; missionNamespace getVariable ["MISSION_intro_finished", false] };
    [] spawn LL_fnc_reloadWeapons;

    private _lastPlayer = objNull;
    while {true} do {
        waitUntil { sleep 1; player != _lastPlayer && { !isNull player } };
        _lastPlayer = player;
        
        _lastPlayer removeAllEventHandlers "HandleRating";
        _lastPlayer addEventHandler ["HandleRating", {
            params ["_unit", "_rating"];
            if (_rating < 0) then { 0 } else { _rating };
        }];
        if (rating _lastPlayer < 5000) then {
            _lastPlayer addRating (5000 - (rating _lastPlayer));
        };
        
        _lastPlayer addEventHandler ["Respawn", {
            params ["_newUnit", "_oldUnit"];
            _newUnit removeAllEventHandlers "HandleRating";
            _newUnit addEventHandler ["HandleRating", {
                params ["_unit", "_rating"];
                if (_rating < 0) then { 0 } else { _rating };
            }];
            if (rating _newUnit < 5000) then {
                _newUnit addRating (5000 - (rating _newUnit));
            };
        }];

        _lastPlayer addEventHandler ["Killed", {
            params ["_unit"];
            [_unit] spawn LL_fnc_switchToAI;
        }];
        
        [_lastPlayer] call LL_fnc_addRoeActions;
        [] call LL_fnc_initSupport;
        [] call LL_fnc_initBriefing;
        [] call LL_fnc_initContext;

        [] spawn {
            sleep 0.5;
            private _tasks = [
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
            private _cur = "";
            {
                if ([_x] call BIS_fnc_taskExists) then {
                    private _st = [_x] call BIS_fnc_taskState;
                    if (_st in ["CREATED", "ASSIGNED", "AUTOASSIGNED"]) exitWith { _cur = _x; };
                };
            } forEach _tasks;
            if (_cur != "") then { [_cur, true] call BIS_fnc_taskSetCurrent; };
        };
    };
};
