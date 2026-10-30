params [["_manualObj", objNull, [objNull]], ["_customRange", 2000, [0]]];

if (!isNull _manualObj) exitWith {
    if (hasInterface) then {
        _manualObj say3D ["ezan", _customRange, 1];
    } else {
        [_manualObj, ["ezan", _customRange, 1]] remoteExec ["say3D", 0];
    };
};

if (!isServer) exitWith {};

waitUntil { time > 2 };

private _SOUND_RANGE = 2000;
private _CLUSTER_DIST = 350;
private _EZAN_DURATION = 145;

private _minarets = [];
for "_i" from 0 to 50 do {
    private _suffix = if (_i < 10) then {format ["0%1", _i]} else {str _i};
    {
        private _obj = missionNamespace getVariable [_x, objNull];
        if (!isNull _obj) then {
            _minarets pushBackUnique _obj;
        };
    } forEach [format ["ezan_%1", _suffix], format ["ezan_%1", _i]];
};

{
    private _var = vehicleVarName _x;
    if (_var != "" && { (toLowerANSI _var) find "ezan_" == 0 }) then {
        _minarets pushBackUnique _x;
    };
} forEach (allMissionObjects "All");

if (_minarets isEqualTo []) exitWith {};

private _clusters = [];
{
    private _speaker = _x;
    private _pos = getPosATL _speaker;
    private _foundIdx = _clusters findIf {
        ((_x select 0) distance2D _pos) < _CLUSTER_DIST
    };

    if (_foundIdx != -1) then {
        private _cluster = _clusters select _foundIdx;
        (_cluster select 2) pushBack _speaker;
    } else {
        _clusters pushBack [_pos, _speaker, [_speaker]];
    };
} forEach _minarets;

sleep (120 + random 2280);

while {true} do {
    if !(missionNamespace getVariable ["LL_ezan_playing", false]) then {
        private _alivePlayers = allPlayers select { alive _x };

        if (_alivePlayers isNotEqualTo []) then {
            private _activeSpeakersToPlay = [];

            {
                private _player = _x;
                private _playerPos = getPosATL _player;

                private _audibleClusters = _clusters select {
                    ((_x select 0) distance2D _playerPos) < _SOUND_RANGE
                };

                _audibleClusters = [_audibleClusters, [], { (_x select 0) distance2D _playerPos }, "ASCEND"] call BIS_fnc_sortBy;

                if (count _audibleClusters > 0) then {
                    private _mainCluster = _audibleClusters select 0;
                    private _mainSpeaker = _mainCluster select 1;
                    
                    if (_activeSpeakersToPlay findIf { (_x select 0) == _mainSpeaker } == -1) then {
                        _activeSpeakersToPlay pushBack [_mainSpeaker, 0.0];
                    };
                };
            } forEach _alivePlayers;

            if (_activeSpeakersToPlay isNotEqualTo []) then {
                missionNamespace setVariable ["LL_ezan_playing", true, true];

                {
                    _x params ["_speaker", "_delay"];
                    [_speaker, _delay, _SOUND_RANGE] spawn {
                        params ["_speaker", "_delay", "_range"];
                        if (_delay > 0) then { sleep _delay; };
                        if (!isNull _speaker) then {
                            if (hasInterface) then {
                                _speaker say3D ["ezan", _range, 1];
                            } else {
                                [_speaker, ["ezan", _range, 1]] remoteExec ["say3D", 0];
                            };
                        };
                    };
                } forEach _activeSpeakersToPlay;

                sleep _EZAN_DURATION;
                missionNamespace setVariable ["LL_ezan_playing", false, true];

                sleep (2700 + random 900);
            } else {
                sleep 30;
            };
        } else {
            sleep 30;
        };
    } else {
        sleep 10;
    };
};
