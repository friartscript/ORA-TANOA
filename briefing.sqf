// briefing.sqf - Exécuté nativement par le moteur Arma 3 lors de la phase de briefing / lobby
if (!hasInterface) exitWith {};

if (isNil { player getVariable ["LL_diary_briefing_added", nil] }) then {
    player setVariable ["LL_diary_briefing_added", true];
    {
        _x setVariable ["LL_diary_briefing_added", true];
        _x createDiaryRecord ["diary", [localize "STR_LL_Briefing_Title", localize "STR_LL_Briefing_Text"]];
    } forEach (units group player);
};

if (!isNil "LL_fnc_initBriefing") then { [] call LL_fnc_initBriefing; };
if (!isNil "LL_fnc_initContext") then { [] call LL_fnc_initContext; };
