params [["_t0", diag_tickTime]];

disableSerialization;

private _layer = "LL_subtitles_layer" call BIS_fnc_rscLayer;
_layer cutRsc ["LL_Legion_Subtitles", "PLAIN", 0];

private _disp = uiNamespace getVariable ["LL_disp_subtitles", displayNull];
private _ctrl = if (!isNull _disp) then { _disp displayCtrl 8888 } else { controlNull };

private _posX = safezoneX;
private _posW = safezoneW;
private _posY = safezoneY + safezoneH - 0.15;
private _posH = 0.14;

if (isNull _ctrl) then {
    _layer cutRsc ["RscDynamicText", "PLAIN", 0];
    _disp = uiNamespace getVariable ["BIS_dynamicText", displayNull];
    if (!isNull _disp) then {
        _ctrl = _disp displayCtrl 9999;
    };
};

if (!isNull _ctrl) then {
    _ctrl ctrlSetPosition [_posX, _posY, _posW, _posH];
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit 0;
};

private _verses = [
    [0.27, 4.23, "La Légion marche vers le front", "STR_LL_Song_Verse_01"],
    [5.12, 4.38, "En chantant nous suivons", "STR_LL_Song_Verse_02"],
    [10.11, 3.81, "Héritiers de ses traditions", "STR_LL_Song_Verse_03"],
    [14.47, 4.62, "Nous aussi nous marchons", "STR_LL_Song_Verse_04"],
    [19.48, 5.14, "Nous aussi nous marchons", "STR_LL_Song_Verse_05"],
    [24.81, 4.45, "Nous sommes les hommes des troupes d'assaut", "STR_LL_Song_Verse_06"],
    [30.03, 4.38, "Soldats de la vieille Légion", "STR_LL_Song_Verse_07"],
    [35.00, 3.90, "Demain brandissant nos drapeaux", "STR_LL_Song_Verse_08"],
    [39.42, 5.12, "En vainqueurs nous défilerons", "STR_LL_Song_Verse_09"],
    [46.71, 4.75, "Pour ce destin de chevalier", "STR_LL_Song_Verse_10"],
    [51.77, 4.92, "Honneur, fidélité", "STR_LL_Song_Verse_11"],
    [57.14, 3.77, "Nous sommes fiers d'appartenir", "STR_LL_Song_Verse_12"],
    [61.33, 4.39, "À ceux qui vont mourir", "STR_LL_Song_Verse_13"],
    [66.18, 4.93, "À ceux qui vont mourir", "STR_LL_Song_Verse_14"],
    [71.56, 3.77, "La Légion marche vers le front", "STR_LL_Song_Verse_15"],
    [75.78, 4.29, "En chantant nous marchons", "STR_LL_Song_Verse_16"],
    [80.58, 4.35, "Héritiers de ses traditions", "STR_LL_Song_Verse_17"],
    [85.33, 4.79, "Nous aussi nous marchons", "STR_LL_Song_Verse_18"]
];

{
    _x params ["_start", "_duration", "_frText", "_strKey"];

    waitUntil { (diag_tickTime - _t0) >= _start };

    if (isNull _disp || isNull _ctrl) then {
        _disp = uiNamespace getVariable ["LL_disp_subtitles", displayNull];
        if (!isNull _disp) then { _ctrl = _disp displayCtrl 8888; };
        if (isNull _ctrl) then {
            _layer cutRsc ["LL_Legion_Subtitles", "PLAIN", 0];
            _disp = uiNamespace getVariable ["LL_disp_subtitles", displayNull];
            if (!isNull _disp) then { _ctrl = _disp displayCtrl 8888; };
        };
        if (isNull _ctrl) then {
            _layer cutRsc ["RscDynamicText", "PLAIN", 0];
            _disp = uiNamespace getVariable ["BIS_dynamicText", displayNull];
            if (!isNull _disp) then { _ctrl = _disp displayCtrl 9999; };
        };
        if (!isNull _ctrl) then {
            _ctrl ctrlSetPosition [_posX, _posY, _posW, _posH];
            _ctrl ctrlCommit 0;
        };
    };

    if (!isNull _ctrl) then {
        private _text = localize _strKey;
        if (_text == "" || _text == _strKey) then { _text = _frText; };

        private _subText = parseText format [
            "<t size='1.16' font='PuristaMedium' color='#FFFFFF' align='center' shadow='2'>« %1 »</t>",
            _text
        ];

        _ctrl ctrlSetStructuredText _subText;
        _ctrl ctrlSetFade 0;
        _ctrl ctrlCommit 0.2;
    };

    waitUntil { (diag_tickTime - _t0) >= (_start + _duration - 0.25) };

    if (!isNull _ctrl) then {
        _ctrl ctrlSetFade 1;
        _ctrl ctrlCommit 0.25;
    };

} forEach _verses;

waitUntil { (diag_tickTime - _t0) >= 90.72 };

_layer cutText ["", "PLAIN"];
