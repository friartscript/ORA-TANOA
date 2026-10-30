params [
    ["_unit", objNull, [objNull]],
    ["_isFemale", false, [false]],
    ["_isEnemy", false, [false]]
];

if (isNull _unit || !local _unit) exitWith {};

_unit setVariable ["not_Random", true, true];

if (_isFemale || { (toLower typeOf _unit) find "woman" != -1 } || { (toLower typeOf _unit) find "female" != -1 } || { (typeOf _unit) in (missionNamespace getVariable ["MISSION_CivilianClasses_Female", []]) }) then {
    _isFemale = true;
};

private _fullName = "";
private _firstName = "";
private _lastName = "";

if (_isFemale) then {
    private _fNames = missionNamespace getVariable ["MISSION_CivilianNames_Female", []];
    private _nameArr = if (count _fNames > 0) then { selectRandom _fNames } else { ["Fatima Said", "Fatima", "Said"] };
    _fullName = _nameArr select 0;
    _firstName = _nameArr select 1;
    _lastName = _nameArr select 2;
    private _fFaces = missionNamespace getVariable ["MISSION_CivilianFemaleFaces", []];
    if (count _fFaces > 0) then {
        _unit setFace (selectRandom _fFaces);
    };
    private _fVoices = missionNamespace getVariable ["MISSION_Voices_Female", ["CUP_D_Female01_CZ"]];
    private _spk = if (count _fVoices > 0) then { selectRandom _fVoices } else { "CUP_D_Female01_CZ" };
    _unit setSpeaker _spk;
    _unit setPitch 1.0;
    [_unit, 1.0, _spk, _fullName, _firstName, _lastName] spawn {
        params ["_u", "_p", "_s", "_fn", "_f", "_l"];
        sleep 0.05;
        if (!isNull _u && alive _u) then {
            _u setPitch _p;
            _u setSpeaker _s;
            _u setName [_fn, _f, _l];
        };
    };
} else {
    private _mNames = missionNamespace getVariable ["MISSION_CivilianNames_Male", []];
    private _nameArr = if (count _mNames > 0) then { selectRandom _mNames } else { ["Ali Mohamed", "Ali", "Mohamed"] };
    _fullName = _nameArr select 0;
    _firstName = _nameArr select 1;
    _lastName = _nameArr select 2;
    private _mFaces = missionNamespace getVariable ["MISSION_CivilianMaleFaces", ["TanoanHead_A3_01"]];
    if (count _mFaces > 0) then {
        _unit setFace (selectRandom _mFaces);
    };
    private _mVoices = missionNamespace getVariable ["MISSION_Voices_Male", ["CUP_D_Male01_CZ"]];
    private _spk = if (count _mVoices > 0) then { selectRandom _mVoices } else { "CUP_D_Male01_CZ" };
    _unit setSpeaker _spk;
    _unit setPitch 1.0;
    [_unit, 1.0, _spk, _fullName, _firstName, _lastName] spawn {
        params ["_u", "_p", "_s", "_fn", "_f", "_l"];
        sleep 0.05;
        if (!isNull _u && alive _u) then {
            _u setPitch _p;
            _u setSpeaker _s;
            _u setName [_fn, _f, _l];
        };
    };
};

_unit setName [_fullName, _firstName, _lastName];
_unit setNameSound _firstName;
_unit setVariable ["LL_unitName", _fullName, true];
_unit setVariable ["LL_isFemale", _isFemale, true];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

if (!_isEnemy) then {
    if (_isFemale) then {
        private _uList = missionNamespace getVariable ["MISSION_CivilianUniforms_Female", ["TCGM_F_Mini_Casual2"]];
        if (count _uList == 0) then { _uList = ["TCGM_F_Mini_Casual2"]; };
        _unit forceAddUniform (selectRandom _uList);
    } else {
        private _uList = missionNamespace getVariable ["MISSION_CivilianUniforms_Male", ["U_C_Poloshirt_blue"]];
        if (count _uList == 0) then { _uList = ["U_C_Poloshirt_blue"]; };
        _unit forceAddUniform (selectRandom _uList);

        private _hatList = missionNamespace getVariable ["MISSION_CivilianHats", []];
        if (count _hatList > 0) then {
            private _hat = selectRandom _hatList;
            if (!isNil "_hat" && { _hat != "" }) then {
                _unit addHeadgear _hat;
            };
        };

        private _vestList = missionNamespace getVariable ["MISSION_CivilianVests", []];
        if (count _vestList > 0) then {
            private _vest = selectRandom _vestList;
            if (!isNil "_vest" && { _vest != "" }) then {
                _unit addVest _vest;
            };
        };
    };
} else {
    _unit setVariable ["LL_isEnemy", true, true];

    if (side group _unit != east) then {
        private _grpEast = createGroup [east, true];
        [_unit] joinSilent _grpEast;
    };

    _unit addEventHandler ["Killed", {
        params ["_unit", "_killer", "_instigator"];
        if (isNull _instigator) then { _instigator = _killer; };
        if (!isNull _instigator && { rating _instigator < 2000 }) then {
            _instigator addRating (3000 - (rating _instigator));
        };
    }];

    if (_isFemale) then {
        private _uList = missionNamespace getVariable ["MISSION_EnemyUniforms_Female", ["TCGM_Survival_MTP_Bra"]];
        if (count _uList == 0) then { _uList = ["TCGM_Survival_MTP_Bra"]; };
        _unit forceAddUniform (selectRandom _uList);
    } else {
        private _uList = missionNamespace getVariable ["MISSION_EnemyUniforms_Male", ["U_I_C_Soldier_Bandit_4_F"]];
        if (count _uList == 0) then { _uList = ["U_I_C_Soldier_Bandit_4_F"]; };
        _unit forceAddUniform (selectRandom _uList);

        private _eHats = missionNamespace getVariable ["MISSION_EnemyHats", []];
        if (count _eHats > 0) then {
            private _hat = selectRandom _eHats;
            if (!isNil "_hat" && { _hat != "" }) then {
                _unit addHeadgear _hat;
            };
        };

        private _eGogs = missionNamespace getVariable ["MISSION_EnemyGoggles", []];
        if (count _eGogs > 0) then {
            private _gog = selectRandom _eGogs;
            if (!isNil "_gog" && { _gog != "" }) then {
                _unit addGoggles _gog;
            };
        };
    };

    private _eVests = missionNamespace getVariable ["MISSION_EnemyVests", []];
    if (count _eVests > 0) then {
        private _vest = selectRandom _eVests;
        if (!isNil "_vest" && { _vest != "" }) then {
            _unit addVest _vest;
        };
    };

    private _eBps = missionNamespace getVariable ["MISSION_BanditBackpacks", []];
    if (count _eBps > 0) then {
        private _bp = selectRandom _eBps;
        if (!isNil "_bp" && { _bp != "" }) then {
            _unit addBackpack _bp;
        };
    };

    private _weapons = missionNamespace getVariable ["MISSION_BanditWeapons", ["arifle_AKM_F"]];
    if (count _weapons == 0) then { _weapons = ["arifle_AKM_F"]; };
    private _weapon = selectRandom _weapons;
    if (!isNil "_weapon" && { _weapon != "" }) then {
        private _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
        if (count _magazines > 0) then {
            private _mag = _magazines select 0;
            for "_i" from 1 to 4 do {
                _unit addMagazine _mag;
            };
        };
        _unit addWeapon _weapon;
    };

    _unit addItem "FirstAidKit";
    _unit linkItem "ItemMap";
    _unit linkItem "ItemCompass";
    _unit linkItem "ItemWatch";
    _unit linkItem "ItemRadio";
};

_unit setBleedingRemaining 0;
_unit setDamage 0;
