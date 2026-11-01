params [["_crate", objNull, [objNull]]];

if (isNull _crate) exitWith {};

if (!(_crate getVariable ["LL_Crate_Cargo_Filled", false])) then {
    _crate setVariable ["LL_Crate_Cargo_Filled", true, true];

    _crate setMaxLoad 20000;

    clearWeaponCargoGlobal _crate;
    clearMagazineCargoGlobal _crate;
    clearItemCargoGlobal _crate;
    clearBackpackCargoGlobal _crate;

    private _fnc_addCargo = {
        params ["_box", "_class", "_count", "_type"];
        switch (_type) do {
            case "WEAPON": {
                if (isClass (configFile >> "CfgWeapons" >> _class)) then {
                    _box addWeaponCargoGlobal [_class, _count];
                };
            };
            case "MAGAZINE": {
                if (isClass (configFile >> "CfgMagazines" >> _class)) then {
                    _box addMagazineCargoGlobal [_class, _count];
                };
            };
            case "ITEM": {
                if (isClass (configFile >> "CfgWeapons" >> _class) || isClass (configFile >> "CfgMagazines" >> _class) || isClass (configFile >> "CfgVehicles" >> _class)) then {
                    _box addItemCargoGlobal [_class, _count];
                };
            };
            case "BACKPACK": {
                if (isClass (configFile >> "CfgVehicles" >> _class)) then {
                    _box addBackpackCargoGlobal [_class, _count];
                };
            };
        };
    };

    private _cargoList = [
        ["Medikit", 10, "ITEM"],
        ["FirstAidKit", 50, "ITEM"],
        ["ACE_fieldDressing", 60, "ITEM"],
        ["ACE_elasticBandage", 40, "ITEM"],
        ["ACE_packingBandage", 40, "ITEM"],
        ["ACE_quikclot", 40, "ITEM"],
        ["ACE_morphine", 30, "ITEM"],
        ["ACE_epinephrine", 20, "ITEM"],
        ["ACE_adenosine", 15, "ITEM"],
        ["ACE_bloodIV", 15, "ITEM"],
        ["ACE_bloodIV_500", 15, "ITEM"],
        ["ACE_plasmaIV", 10, "ITEM"],
        ["ACE_salineIV", 15, "ITEM"],
        ["ACE_tourniquet", 20, "ITEM"],
        ["ACE_splint", 20, "ITEM"],
        ["ACE_surgicalKit", 5, "ITEM"],
        ["ACE_personalAidKit", 10, "ITEM"],

        ["SmokeShell", 50, "MAGAZINE"],
        ["SmokeShellGreen", 15, "MAGAZINE"],
        ["SmokeShellRed", 15, "MAGAZINE"],
        ["SmokeShellBlue", 15, "MAGAZINE"],
        ["SmokeShellYellow", 10, "MAGAZINE"],
        ["SmokeShellPurple", 10, "MAGAZINE"],
        ["SmokeShellOrange", 10, "MAGAZINE"],
        ["HandGrenade", 30, "MAGAZINE"],
        ["MiniGrenade", 20, "MAGAZINE"],
        ["CUP_HandGrenade_M67", 30, "MAGAZINE"],
        ["CUP_HandGrenade_RGD5", 20, "MAGAZINE"],
        ["1Rnd_HE_Grenade_shell", 40, "MAGAZINE"],
        ["1Rnd_Smoke_Grenade_shell", 25, "MAGAZINE"],
        ["1Rnd_SmokeRed_Grenade_shell", 15, "MAGAZINE"],
        ["1Rnd_SmokeGreen_Grenade_shell", 15, "MAGAZINE"],
        ["UGL_FlareWhite_F", 15, "MAGAZINE"],

        ["AMF_614_FS_01_TAN", 4, "WEAPON"],
        ["AMF_614_long_01_TAN", 4, "WEAPON"],
        ["AMF_Famas_F1_Valo", 4, "WEAPON"],
        ["CUP_arifle_FAMAS_F1", 4, "WEAPON"],
        ["arifle_SPAR_01_blk_F", 4, "WEAPON"],
        ["arifle_SPAR_01_GL_blk_F", 2, "WEAPON"],
        ["arifle_MSBS65_F", 4, "WEAPON"],
        ["arifle_MSBS65_GL_F", 2, "WEAPON"],
        ["arifle_MX_F", 4, "WEAPON"],
        ["arifle_MX_GL_F", 2, "WEAPON"],
        ["CUP_lmg_m249_pip1", 2, "WEAPON"],
        ["LMG_03_F", 2, "WEAPON"],
        ["LMG_Mk200_F", 2, "WEAPON"],
        ["MMG_02_black_F", 2, "WEAPON"],
        ["AMF_617_01_TAN", 3, "WEAPON"],
        ["srifle_DMR_03_F", 3, "WEAPON"],
        ["srifle_EBR_F", 3, "WEAPON"],
        ["CUP_arifle_Mk17_STD_woodland", 3, "WEAPON"],
        ["srifle_LRR_F", 2, "WEAPON"],
        ["launch_NLAW_F", 2, "WEAPON"],
        ["launch_MRAWS_sand_rail_F", 2, "WEAPON"],
        ["launch_RPG32_F", 2, "WEAPON"],
        ["CUP_launch_AT4", 4, "WEAPON"],
        ["hgun_P07_F", 4, "WEAPON"],
        ["CUP_hgun_Glock17_blk", 4, "WEAPON"],
        ["hgun_Pistol_heavy_01_F", 4, "WEAPON"],

        ["30Rnd_556x45_Stanag", 80, "MAGAZINE"],
        ["30Rnd_556x45_Stanag_Tracer_Red", 40, "MAGAZINE"],
        ["AMF_30Rnd_556x45_STANAG_M855A1", 60, "MAGAZINE"],
        ["CUP_30Rnd_556x45_Stanag", 60, "MAGAZINE"],
        ["200Rnd_556x45_Box_F", 20, "MAGAZINE"],
        ["200Rnd_556x45_Box_Tracer_Red_F", 20, "MAGAZINE"],
        ["CUP_200Rnd_TE4_Red_Tracer_556x45_M249", 20, "MAGAZINE"],
        ["150Rnd_556x45_Drum_Mag_F", 20, "MAGAZINE"],
        ["20Rnd_762x51_Mag", 50, "MAGAZINE"],
        ["AMF_20Rnd_762x51_HK417", 40, "MAGAZINE"],
        ["CUP_20Rnd_762x51_B_SCAR", 40, "MAGAZINE"],
        ["130Rnd_338_Mag", 10, "MAGAZINE"],
        ["7Rnd_408_Mag", 15, "MAGAZINE"],
        ["30Rnd_65x39_caseless_mag", 40, "MAGAZINE"],
        ["200Rnd_65x39_cased_Box", 15, "MAGAZINE"],
        ["16Rnd_9x21_Mag", 40, "MAGAZINE"],
        ["CUP_17Rnd_9x19_glock17", 40, "MAGAZINE"],
        ["11Rnd_45ACP_Mag", 30, "MAGAZINE"],
        ["NLAW_F", 8, "MAGAZINE"],
        ["MRAWS_HEAT_F", 8, "MAGAZINE"],
        ["MRAWS_HE_F", 6, "MAGAZINE"],
        ["RPG32_F", 8, "MAGAZINE"],
        ["RPG32_HE_F", 6, "MAGAZINE"],

        ["DemoCharge_F", 15, "MAGAZINE"],
        ["SatchelCharge_F", 6, "MAGAZINE"],
        ["ClaymoreDirectionalMine_Remote_Mag", 10, "MAGAZINE"],
        ["MineDetector", 4, "ITEM"],
        ["DefusalKit", 6, "ITEM"],
        ["ItemGPS", 6, "ITEM"],
        ["NVGoggles", 8, "ITEM"],
        ["AMF_ONYX_NVG", 8, "ITEM"],
        ["Rangefinder", 6, "WEAPON"],
        ["Laserdesignator", 2, "WEAPON"],
        ["Laserbatteries", 6, "MAGAZINE"],

        ["optic_Arco", 6, "ITEM"],
        ["optic_Hamr", 6, "ITEM"],
        ["optic_Holosight", 8, "ITEM"],
        ["optic_ACO_grn", 8, "ITEM"],
        ["optic_SOS", 4, "ITEM"],
        ["optic_DMS", 6, "ITEM"],
        ["optic_ERCO_blk_F", 6, "ITEM"],
        ["optic_NVS", 4, "ITEM"],
        ["muzzle_snds_M", 8, "ITEM"],
        ["muzzle_snds_B", 6, "ITEM"],
        ["acc_flashlight", 10, "ITEM"],
        ["acc_pointer_IR", 10, "ITEM"],
        ["bipod_01_F_blk", 6, "ITEM"],

        ["B_Carryall_cbr", 6, "BACKPACK"],
        ["B_AssaultPack_rgr", 8, "BACKPACK"],
        ["B_Kitbag_cbr", 6, "BACKPACK"],
        ["AMF_rush24_TAN", 6, "BACKPACK"],
        ["AMF_FELIN_BACKPACK", 6, "BACKPACK"]
    ];

    {
        [_crate, _x # 0, _x # 1, _x # 2] call _fnc_addCargo;
    } forEach _cargoList;

    ["AmmoboxInit", [_crate, true]] call BIS_fnc_arsenal;
};

if (!hasInterface) exitWith {};

_crate setVariable ["LL_Resupply_InProgress", false, true];

_crate addAction [
    "<t color='#00DDFF'><img image='\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa'/> Arsenal</t>",
    {
        params ["_target", "_caller"];
        ["Open", [true, _target, _caller]] call BIS_fnc_arsenal;
    },
    nil,
    6.5,
    true,
    true,
    "",
    "alive _target && _this distance _target < 5",
    5
];

_crate addAction [
    format ["<t color='#FFFF00'>%1</t>", localize "STR_LL_Action_Resupply"],
    {
        params ["_target", "_caller", "_actionId"];

        if (_target getVariable ["LL_Resupply_InProgress", false]) exitWith {};
        _target setVariable ["LL_Resupply_InProgress", true, true];

        private _squadAI = (units group _caller) select {
            !isPlayer _x && alive _x && vehicle _x == _x
        };

        _caller playActionNow "gestureAdvance";
        ["STR_LL_Msg_Resupply_Start"] call LL_fnc_radioMessage;

        _target removeAction _actionId;

        [_target, _squadAI, _caller] spawn {
            params ["_crate", "_squadAI", "_leader"];

            private _cratePos = getPos _crate;

            private _fnc_resupply = {
                params ["_unit", "_crate"];
                if (!alive _unit || isNull _crate) exitWith {};

                private _pw = primaryWeapon _unit;
                if (_pw != "") then {
                    private _pwMags = getArray (configFile >> "CfgWeapons" >> _pw >> "magazines");
                    if (count _pwMags > 0) then {
                        private _magClass = _pwMags # 0;
                        private _currentCount = { _x == _magClass } count (magazines _unit);
                        private _needed = (8 - _currentCount) max 0;
                        for "_m" from 1 to _needed do { _unit addMagazine _magClass; };
                    };
                };

                private _hw = handgunWeapon _unit;
                if (_hw != "") then {
                    private _hwMags = getArray (configFile >> "CfgWeapons" >> _hw >> "magazines");
                    if (count _hwMags > 0) then {
                        private _magClass = _hwMags # 0;
                        private _currentCount = { _x == _magClass } count (magazines _unit);
                        private _needed = (4 - _currentCount) max 0;
                        for "_m" from 1 to _needed do { _unit addMagazine _magClass; };
                    };
                };

                private _sw = secondaryWeapon _unit;
                if (_sw != "") then {
                    private _swMags = getArray (configFile >> "CfgWeapons" >> _sw >> "magazines");
                    if (count _swMags > 0) then {
                        private _magClass = _swMags # 0;
                        private _currentCount = { _x == _magClass } count (magazines _unit);
                        private _needed = (3 - _currentCount) max 0;
                        for "_m" from 1 to _needed do { _unit addMagazine _magClass; };
                    };
                };

                private _grenadeCount = { toLower _x find "grenade" != -1 } count (magazines _unit);
                if (_grenadeCount < 3) then {
                    for "_g" from 1 to (3 - _grenadeCount) do { _unit addMagazine "CUP_HandGrenade_M67"; };
                };
                private _smokeCount = { _x == "SmokeShell" } count (magazines _unit);
                if (_smokeCount < 2) then {
                    for "_s" from 1 to (2 - _smokeCount) do { _unit addMagazine "SmokeShell"; };
                };

                private _fak = { _x == "FirstAidKit" } count (items _unit);
                if (_fak < 3) then {
                    for "_f" from 1 to (3 - _fak) do { _unit addItem "FirstAidKit"; };
                };
            };

            [_leader, _crate] call _fnc_resupply;

            if (count _squadAI > 0) then {
                {
                    private _unit = _x;
                    if (alive _unit) then {
                        private _dirToUnit = _cratePos getDir (getPos _unit);
                        private _approachPos = _crate getPos [0.1, _dirToUnit];

                        _unit setSpeedMode "NORMAL";
                        _unit setUnitPos "UP";
                        _unit doMove _approachPos;

                        private _timeout = time + 12;
                        waitUntil {
                            sleep 0.5;
                            !alive _unit || (_unit distance2D _approachPos < 0.2) || time > _timeout
                        };

                        if (alive _unit) then {
                            _unit doWatch _crate;
                            sleep 0.5;

                            [_unit, _crate] call _fnc_resupply;
                            [_unit, "ReloadMagazine"] remoteExecCall ["playActionNow", owner _unit];

                            sleep 4.0;
                            _unit doWatch objNull;
                            _unit doFollow _leader;
                            sleep 1.0;
                        };
                    };
                } forEach _squadAI;
            } else {
                sleep 2.0;
            };

            ["STR_LL_Msg_Resupply_Done"] call LL_fnc_radioMessage;

            if (!isNull _crate && { alive _crate }) then {
                _crate setVariable ["LL_Resupply_InProgress", false, true];
                [_crate] call LL_fnc_addResupplyAction;
            };
        };
    },
    [],
    6.0,
    true,
    true,
    "",
    "leader group player == player && !(_target getVariable ['LL_Resupply_InProgress', false])",
    5
];