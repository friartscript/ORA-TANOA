params [
    ["_targetPos", [0,0,0], [[]]]
];

if (!isServer) exitWith {};

sleep 120;

private _fn_enforceVoice = {
    private _opforUnits = allUnits select {
        alive _x && { side group _x == east || _x getVariable ["LL_isEnemy", false] || side _x == east }
    };

    private _czSpeakersMale = ["CUP_D_Male01_CZ", "CUP_D_Male02_CZ", "CUP_D_Male03_CZ", "CUP_D_Male04_CZ", "CUP_D_Male05_CZ"];
    private _czSpeakersFemale = ["CUP_D_Female01_CZ", "CUP_D_Female02_CZ", "CUP_D_Female03_CZ"];

    {
        private _unit = _x;
        private _isFem = _unit getVariable ["LL_isFemale", false];
        private _curSpeaker = speaker _unit;

        if (_isFem) then {
            if !(_curSpeaker in _czSpeakersFemale) then {
                _unit setSpeaker (selectRandom _czSpeakersFemale);
                _unit setPitch 1.0;
            };
        } else {
            if !(_curSpeaker in _czSpeakersMale) then {
                _unit setSpeaker (selectRandom _czSpeakersMale);
                _unit setPitch 1.0;
            };
        };
    } forEach _opforUnits;
};

[] call _fn_enforceVoice;

while { !(missionNamespace getVariable ["LL_g_extractionStarted", false]) } do {
    sleep 30;
    [] call _fn_enforceVoice;
};