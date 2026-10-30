if (!hasInterface) exitWith {};

// Protection anti-Renegade locale pour le joueur et son escouade
player removeAllEventHandlers "HandleRating";
player addEventHandler ["HandleRating", {
    params ["_unit", "_rating"];
    if (_rating < 0) then { 0 } else { _rating };
}];
if (rating player < 5000) then {
    player addRating (5000 - (rating player));
};

{
    _x removeAllEventHandlers "HandleRating";
    _x addEventHandler ["HandleRating", {
        params ["_unit", "_rating"];
        if (_rating < 0) then { 0 } else { _rating };
    }];
    if (rating _x < 5000) then {
        _x addRating (5000 - (rating _x));
    };
} forEach (units group player);

if (isNil { player getVariable ["LL_diary_briefing_added", nil] }) then {
    player setVariable ["LL_diary_briefing_added", true];
    {
        _x setVariable ["LL_diary_briefing_added", true];
        _x createDiaryRecord ["diary", [localize "STR_LL_Briefing_Title", localize "STR_LL_Briefing_Text"]];
    } forEach (units group player);
};

[] spawn {
    private _timeout = 0;
    waitUntil {
        sleep 0.5;
        _timeout = _timeout + 0.5;
        (!isNull player && {!isNil { player getVariable "LL_s_identity" }}) || { _timeout >= 30 }
    };

    private _playerUnit = player;
    if (!isNull _playerUnit) then {
        private _identity = _playerUnit getVariable ["LL_s_identity", []];
        if (count _identity >= 5) then {
            _identity params ["_nameData", "_faceType", "_face", "_speaker", "_pitch", ["_beard", "", [""]]];
            [_playerUnit, _nameData, _face, _speaker, _pitch, _beard] call LL_fnc_applyIdentity;
            showHUD false;
            sleep 0.5;
            showHUD true;
        };
    };
};
