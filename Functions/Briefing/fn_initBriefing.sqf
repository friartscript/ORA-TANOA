if (!hasInterface) exitWith {};

// Enregistrement dans l'onglet natif "Briefing" d'Arma 3 ("diary")
if (isNil { player getVariable ["LL_diary_briefing_added", nil] }) then {
    player setVariable ["LL_diary_briefing_added", true];
    {
        _x setVariable ["LL_diary_briefing_added", true];
        _x createDiaryRecord ["diary", [localize "STR_LL_Briefing_Title", localize "STR_LL_Briefing_Text"]];
    } forEach (units group player);
};

if (!(player diarySubjectExists "Manuel")) then {
    player createDiarySubject ["Manuel", localize "STR_LL_Briefing_Manual_Tab"];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_3_1_Title", localize "STR_LL_Briefing_3_1_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_3_Title", localize "STR_LL_Briefing_2_3_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_2_Title", localize "STR_LL_Briefing_2_2_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_2_1_Title", localize "STR_LL_Briefing_2_1_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_1_3_Title", localize "STR_LL_Briefing_1_3_Text"]];
    player createDiaryRecord ["Manuel", [localize "STR_LL_Briefing_1_1_Title", localize "STR_LL_Briefing_1_1_Text"]];
};

