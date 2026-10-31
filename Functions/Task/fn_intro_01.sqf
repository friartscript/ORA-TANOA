params [["_selectedLocationMarker", ""], ["_dropPosCenter", [0,0,0]], ["_selectedVehClass", "CUP_I_LR_Transport_RACS"]];

disableSerialization;

cutText ["", "BLACK FADED", 999];
0 fadeSound 0;
0 fadeMusic 0;
showCinemaBorder true;

private _lzRef = _dropPosCenter;
if (_lzRef isEqualTo [0,0,0]) then { _lzRef = getMarkerPos _selectedLocationMarker; };
if (_lzRef isEqualTo [0,0,0]) then { _lzRef = getMarkerPos "marker_0"; };

private _heliports = [];
for "_i" from 0 to 200 do {
    private _hp = objNull;
    {
        private _var = missionNamespace getVariable [_x, objNull];
        if (!isNull _var) exitWith { _hp = _var; };
    } forEach [
        format ["Heliport_%1", _i],
        format ["Heliport_0%1", _i],
        format ["Heliport_00%1", _i]
    ];
    if (!isNull _hp) then { _heliports pushBack _hp; };
};

if (count _heliports == 0) then {
    private _nearPads = nearestObjects [_lzRef, ["Helipad_Invisible_F", "Land_HelipadEmpty_F", "HeliH"], 500];
    if (count _nearPads > 0) then { _heliports = _nearPads; };
};

private _destPos = _lzRef;
if (count _heliports > 0) then {
    private _chosen = [_heliports, _lzRef] call BIS_fnc_nearestPosition;
    if (!isNull _chosen) then { _destPos = getPosATL _chosen; };
};
if (_destPos isEqualTo [0,0,0]) then { _destPos = getMarkerPos "marker_0"; };
private _lzASL = ATLToASL _destPos;

MISSION_intro_lz = _destPos;
publicVariable "MISSION_intro_lz";

private _vehPos = _destPos getPos [18, 90];
_vehPos set [2, 0];
if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { deleteVehicle vehicule_team; };
private _vehClass = missionNamespace getVariable ["MISSION_var_selected_vehicle_class", _selectedVehClass];
vehicule_team = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
vehicule_team setPosATL _vehPos;
vehicule_team setDir (random 360);
publicVariable "vehicule_team";

private _smokePos = _destPos getPos [6, 45];
"SmokeShellGreen" createVehicle _smokePos;
[] spawn LL_fnc_spawnStartArsenal;

private _allUnits = [];
for "_i" from 0 to 5 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (isNull _u) then {
        _u = missionNamespace getVariable [format ["player_0%1", _i], objNull];
    };
    if (!isNull _u) then { _allUnits pushBackUnique _u; };
};

if (count _allUnits < 6 && !isNull player) then {
    {
        if (alive _x) then { _allUnits pushBackUnique _x; };
    } forEach (units (group player) + playableUnits + switchableUnits);
};

{
    _x allowDamage false;
} forEach _allUnits;

private _startDir = random 360;
private _startPos = _destPos getPos [1500, _startDir];
_startPos set [2, 110];

private _heli = createVehicle ["CUP_I_UH60L_FFV_RACS", _startPos, [], 0, "FLY"];
_heli setPosATL _startPos;
_heli setDir (_heli getDir _destPos);

private _cruiseAltASL = (_lzASL select 2) + 110;
_heli flyInHeightASL [_cruiseAltASL, _cruiseAltASL, _cruiseAltASL];
_heli flyInHeight 110;
_heli allowDamage false;

createVehicleCrew _heli;
private _crew = crew _heli;
{ _x allowDamage false; } forEach _crew;

private _grpHeli = group driver _heli;
_grpHeli setBehaviour "CARELESS";
_grpHeli setCombatMode "BLUE";

{
    unassignVehicle _x;
    _x moveInCargo _heli;
    if (vehicle _x != _heli) then { _x moveInAny _heli; };
} forEach _allUnits;

_heli doMove _destPos;
_heli limitSpeed 160;

private _ppColor = ppEffectCreate ["ColorCorrections", 1500];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 0.95, 0.04, [0.15, 0.15, 0.2, 0.0], [0.88, 0.86, 0.9, 0.65], [0.1, 0.1, 0.15, 0]];
_ppColor ppEffectCommit 0;

private _ppGrain = ppEffectCreate ["FilmGrain", 2005];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [0.05, 0.8, 0.9, 0.05, 0.9, false];
_ppGrain ppEffectCommit 0;

private _highCamPos = [(_destPos select 0) - 75, (_destPos select 1) - 75, (_destPos select 2) + 145];
private _lowCamPos = [(_destPos select 0) - 25, (_destPos select 1) - 25, (_destPos select 2) + 45];

private _cam = "camera" camCreate _highCamPos;
_cam cameraEffect ["INTERNAL", "BACK"];
if ((getLighting select 1) < 25) then { camUseNVG true; };

_cam camSetPos _highCamPos;
_cam camSetTarget _destPos;
_cam camSetFov 0.65;
_cam camCommit 0;
waitUntil { camCommitted _cam };

if ((getAudioOptionVolumes select 1) > 0.05) then {
    playMusic "Legion_001";
    0 fadeMusic 1;
} else {
    playSound "Sound_Legion_001";
};
2 fadeSound 1;

private _t0 = diag_tickTime;
[_t0] spawn LL_fnc_subtitles_legion;

cutText ["", "BLACK IN", 2.0];
_cam camSetPos _lowCamPos;
_cam camSetTarget _destPos;
_cam camSetFov 0.48;
_cam camCommit 10.0;

waitUntil { (diag_tickTime - _t0) >= 1.2 };

titleText [
    format [
        "<t size='3.4' font='PuristaBold' shadow='2' align='center'><t color='#1E88E5'>OPERATION</t> <t color='#FFFFFF'>ROYAL</t> <t color='#E53935'>ALLIANCE</t></t><br/>" +
        "<t size='1.5' color='#E5B729' font='PuristaSemiBold' align='center'>%1</t><br/>" +
        "<t size='1.3' color='#FFFFFF' font='PuristaBold' shadow='2' align='center'>ROYAL ARMY CORPS OF SAHRANI - LÉGION ÉTRANGÈRE</t><br/>" +
        "<t size='1.1' color='#87CEEB' font='PuristaLight' shadow='1' align='center'>%2</t>",
        localize "STR_LL_Intro_Presents",
        localize "STR_LL_Intro_CreatedBy"
    ],
    "PLAIN", 1, true, true
];

waitUntil { (diag_tickTime - _t0) >= 8.5 };
titleText ["", "PLAIN", 1.0];

waitUntil { (diag_tickTime - _t0) >= 9.8 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 10.11 };

missionNamespace setVariable ["LL_cam_obj", _cam];
missionNamespace setVariable ["LL_cam_target", _heli];
missionNamespace setVariable ["LL_p2_t0", _t0 + 10.11];

private _ehPlan2 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p2_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.37) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir - 45 + (_smooth * 20);
    private _dist = 56 - (_smooth * 8);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 12 - (_smooth * 3)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 2, 0]);
    _cam camSetFov (0.62 - (_smooth * 0.07));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

[] spawn {
    sleep 0.5;
    private _p2h = date select 3;
    private _p2m = date select 4;
    private _p2time = format ["%1:%2",
        if (_p2h < 10) then {"0" + str _p2h} else {str _p2h},
        if (_p2m < 10) then {"0" + str _p2m} else {str _p2m}
    ];
    private _rawLoc = localize "STR_LL_Intro_Location";
    if (_rawLoc == "" || _rawLoc == "STR_LL_Intro_Location") then { _rawLoc = "TANOA - SECTEUR OPÉRATIONNEL"; };
    private _fullLoc = _rawLoc + " - " + _p2time;
    private _chars = toArray _fullLoc;
    private _built = "";

    {
        _built = _built + toString [_x];
        [
            format ["<t size='1.35' font='PuristaMedium' align='center' shadow='2'><t color='#1E88E5'>[</t> <t color='#FFFFFF'>%1</t> <t color='#E53935'>]</t></t>", _built],
            -1, 0.38, 4, 0, 0, 793
        ] spawn BIS_fnc_dynamicText;
        if (_x != 32) then { playSound "readoutClick"; };
        sleep 0.07;
    } forEach _chars;

    sleep 2.0;
    ["", -1, 0.38, 0.8, 0, 0, 793] spawn BIS_fnc_dynamicText;
};

waitUntil { (diag_tickTime - _t0) >= 19.18 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 19.48 };
removeMissionEventHandler ["EachFrame", _ehPlan2];

_heli animateDoor ["doorLB", 1];
_heli animateDoor ["doorRB", 1];
_heli flyInHeight 65;
_heli limitSpeed 140;

missionNamespace setVariable ["LL_p3_t0", _t0 + 19.48];

private _ehPlan3 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p3_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 10.55) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir + 135 - (_smooth * 25);
    private _dist = 52 + (_smooth * 4);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 9 + (_smooth * 3)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0]);
    _cam camSetFov (0.58 - (_smooth * 0.06));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

waitUntil { (diag_tickTime - _t0) >= 29.73 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 30.03 };
removeMissionEventHandler ["EachFrame", _ehPlan3];

missionNamespace setVariable ["LL_p4_t0", _t0 + 30.03];

private _ehPlan4 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _start = missionNamespace getVariable ["LL_p4_t0", diag_tickTime];
    private _elapsed = diag_tickTime - _start;
    private _prog = (_elapsed / 9.39) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    private _hASL = getPosASLVisual _heli;
    private _hDir = getDirVisual _heli;
    private _angle = _hDir + 35 + (_smooth * 30);
    private _dist = 48 - (_smooth * 4);
    private _cASL = [
        (_hASL select 0) + (sin _angle * _dist),
        (_hASL select 1) + (cos _angle * _dist),
        (_hASL select 2) + 11 - (_smooth * 4)
    ];
    _cam camSetPos (ASLToAGL _cASL);
    _cam camSetTarget (_heli modelToWorldVisual [0, 1, 0]);
    _cam camSetFov (0.56 - (_smooth * 0.06));
    _cam camCommit 0;
}];

cutText ["", "BLACK IN", 0.3];

waitUntil { (diag_tickTime - _t0) >= 39.12 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 39.42 };
removeMissionEventHandler ["EachFrame", _ehPlan4];

_heli land "GET OUT";

private _camGround5 = [
    (_destPos select 0) + 52,
    (_destPos select 1) - 54,
    (_destPos select 2) + 3.5
];
_cam camSetPos _camGround5;
_cam camSetTarget _heli;
_cam camSetFov 0.52;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p5_t0", _t0 + 39.42];
missionNamespace setVariable ["LL_p5_cPos", _camGround5];

private _ehPlan5 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p5_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p5_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 12.35) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) + (sin (_smooth * 80) * 4),
        (_base select 1) + (cos (_smooth * 80) * 4),
        (_base select 2) + (_smooth * 2.8)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.5]);
    _cam camSetFov (0.52 + (_smooth * 0.06));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 51.47 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 51.77 };
removeMissionEventHandler ["EachFrame", _ehPlan5];

private _camGround6 = [
    (_destPos select 0) - 38,
    (_destPos select 1) + 35,
    (_destPos select 2) + 2.5
];
_cam camSetPos _camGround6;
_cam camSetTarget _heli;
_cam camSetFov 0.48;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p6_t0", _t0 + 51.77];
missionNamespace setVariable ["LL_p6_cPos", _camGround6];

private _ehPlan6 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p6_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p6_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 9.56) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) + (_smooth * 5),
        (_base select 1) - (_smooth * 3.5),
        (_base select 2) + (_smooth * 0.8)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.4]);
    _cam camSetFov (0.48 - (_smooth * 0.05));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 61.03 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 61.33 };
removeMissionEventHandler ["EachFrame", _ehPlan6];

private _camGround7 = [
    (_destPos select 0) + 25,
    (_destPos select 1) - 22,
    (_destPos select 2) + 1.8
];
_cam camSetPos _camGround7;
_cam camSetTarget _heli;
_cam camSetFov 0.46;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p7_t0", _t0 + 61.33];
missionNamespace setVariable ["LL_p7_cPos", _camGround7];

private _ehPlan7 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    private _heli = missionNamespace getVariable ["LL_cam_target", objNull];
    if (isNull _cam || isNull _heli) exitWith {};

    private _base = missionNamespace getVariable ["LL_p7_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p7_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 10.23) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) - (_smooth * 3),
        (_base select 1) + (_smooth * 2),
        (_base select 2) + (_smooth * 0.3)
    ];
    _cam camSetTarget (_heli modelToWorldVisual [0, 0, 0.2]);
    _cam camSetFov (0.46 + (_smooth * 0.04));
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 71.26 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 71.56 };
removeMissionEventHandler ["EachFrame", _ehPlan7];

{
    unassignVehicle _x;
    moveOut _x;
} forEach _allUnits;

private _teamRef = if (!isNil "vehicule_team" && {!isNull vehicule_team}) then { getPosATL vehicule_team } else { _destPos };

private _allSquad = [];
for "_i" from 0 to 5 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (isNull _u) then { _u = missionNamespace getVariable [format ["player_0%1", _i], objNull]; };
    if (!isNull _u) then {
        _allSquad pushBack _u;
        private _pos = _teamRef getPos [3.5 + (_i * 1.5), 20 + (_i * 55)];
        _pos set [2, 0];
        _u setPosATL _pos;
        _u setVelocity [0, 0, 0];
        _u switchMove "";
        _u setDir (_pos getDir _teamRef);
    };
};

_heli engineOn true;
private _exitPos = _destPos getPos [5000, (_destPos getDir _startPos)];
_exitPos set [2, 100];
_heli doMove _exitPos;
_heli flyInHeight 100;

[_heli, _destPos] spawn {
    params ["_h", "_dp"];
    waitUntil { sleep 2; (_h distance2D _dp) > 3000 || !alive _h };
    { deleteVehicle _x; } forEach (crew _h);
    deleteVehicle _h;
};

private _camGround8 = [
    (_teamRef select 0) - 16,
    (_teamRef select 1) - 14,
    (_teamRef select 2) + 1.6
];
_cam camSetPos _camGround8;
_cam camSetTarget _teamRef;
_cam camSetFov 0.50;
_cam camCommit 0;
waitUntil { camCommitted _cam };

cutText ["", "BLACK IN", 0.4];

missionNamespace setVariable ["LL_p8_t0", _t0 + 71.56];
missionNamespace setVariable ["LL_p8_cPos", _camGround8];

private _ehPlan8 = addMissionEventHandler ["EachFrame", {
    private _cam = missionNamespace getVariable ["LL_cam_obj", objNull];
    if (isNull _cam) exitWith {};

    private _base = missionNamespace getVariable ["LL_p8_cPos", [0,0,0]];
    private _start = missionNamespace getVariable ["LL_p8_t0", diag_tickTime];
    private _prog = ((diag_tickTime - _start) / 9.02) min 1;
    private _smooth = _prog * _prog * (3 - 2 * _prog);

    _cam camSetPos [
        (_base select 0) + (_smooth * 3),
        (_base select 1) - (_smooth * 2),
        (_base select 2) + (_smooth * 0.2)
    ];
    _cam camCommit 0;
}];

waitUntil { (diag_tickTime - _t0) >= 80.28 };
cutText ["", "BLACK OUT", 0.3];

waitUntil { (diag_tickTime - _t0) >= 80.58 };
removeMissionEventHandler ["EachFrame", _ehPlan8];

private _teammates = _allSquad - [player];
_teammates joinSilent (group player);
(group player) selectLeader player;

{
    _x doFollow player;
    _x setDamage 0;
    _x allowDamage true;
    _x setCaptive false;
    _x enableAI "ALL";
} forEach _allSquad;

_cam cameraEffect ["TERMINATE", "BACK"];
camDestroy _cam;
camUseNVG false;
ppEffectDestroy _ppColor;
ppEffectDestroy _ppGrain;

player switchCamera "INTERNAL";
showCinemaBorder false;

if ((getLighting select 1) < 25) then {
    player action ["NVGoggles", player];
};

cutText ["", "BLACK IN", 1.5];
2 fadeSound 1;

waitUntil { (diag_tickTime - _t0) >= 90.72 };

[
    format [
        "<t size='1.0' color='#bbbbbb' font='PuristaLight' align='center'>%1</t>",
        localize "STR_LL_Intro_MissionStartSubtitle"
    ],
    -1, -1, 5, 1, 0, 793
] spawn BIS_fnc_dynamicText;

missionNamespace setVariable ["MISSION_intro_finished", true, true];
