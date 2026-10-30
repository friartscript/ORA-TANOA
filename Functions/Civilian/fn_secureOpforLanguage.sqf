params [
    ["_targetPos", [0,0,0], [[]]]
];

if (!isServer) exitWith {};

sleep 120;

private _fn_enforceVoice = {
    private _opforUnits = allUnits select {
        alive _x && { side group _x == east || _x getVariable ["LL_isEnemy", false] || side _x == east }
    };

    private _czSpeakers = ["CUP_D_Male01_CZ", "CUP_D_Male02_CZ", "CUP_D_Male03_CZ", "CUP_D_Male04_CZ", "CUP_D_Male05_CZ"];

    {
        private _unit = _x;
        private _curSpeaker = speaker _unit;

        if !(_curSpeaker in _czSpeakers) then {
            private _newSpeaker = selectRandom _czSpeakers;
            _unit setSpeaker _newSpeaker;
            _unit setPitch 1.0;
        };
    } forEach _opforUnits;
};

[] call _fn_enforceVoice;

while { !(missionNamespace getVariable ["LL_g_extractionStarted", false]) } do {
    sleep 30;
    [] call _fn_enforceVoice;
};