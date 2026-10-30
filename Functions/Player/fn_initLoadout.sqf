private _vests = [
    "CUP_V_JPC_medical_coy",
    "CUP_V_JPC_tl_coy",
    "CUP_V_JPC_weapons_coy",
    "CUP_V_JPC_communicationsbelt_coy",
    "CUP_V_JPC_Fastbelt_coy",
    "CUP_V_JPC_lightbelt_coy",
    "CUP_V_JPC_medicalbelt_coy",
    "CUP_V_JPC_tlbelt_coy",
    "CUP_V_JPC_weaponsbelt_coy"
];
private _helmets = [
    "CUP_H_OpsCore_Tan_SF",
    "CUP_H_OpsCore_Tan",
    "CUP_H_OpsCore_Tan_NohS",
    "CUP_H_OpsCore_Grey_SF",
    "CUP_H_OpsCore_Grey",
    "CUP_H_OpsCore_Grey_NohS"
];
private _backpacks = [
    "CUP_B_AssaultPack_Coyote",
    "B_assaultPack_cbr",
    "B_Kitbag_cbr"
];
private _uniforms = [
    "CUP_U_B_USMC_MCCUU_des_gloves",
    "CUP_U_B_USMC_MCCUU_des_roll_2",
    "CUP_U_B_USMC_MCCUU_des_roll_2_gloves",
    "CUP_U_B_USMC_MCCUU_des_roll_pads",
    "CUP_U_B_USMC_MCCUU_des_roll_2_pads_gloves",
    "CUP_U_B_USMC_MCCUU_des_pads",
    "CUP_U_B_USMC_MCCUU_des_pads_gloves",
    "CUP_U_B_USMC_MCCUU_des_roll",
    "CUP_U_B_USMC_MCCUU_des_roll_gloves",
    "CUP_U_B_USMC_MCCUU_des_roll_pads",
    "CUP_U_B_USMC_MCCUU_des_roll_pads_gloves",
    "CUP_U_B_USMC_MCCUU_des"
];
private _goggles = [
    "CUP_G_Tan_Scarf_Shades_GPSCombo_Beard",
    "CUP_G_Tan_Scarf_Shades_GPS_Beard",
    "CUP_G_Tan_Scarf_GPS",
    "CUP_G_TK_RoundGlasses_blk",
    "CUP_G_Oakleys_Drk",
    "CUP_G_Scarf_Face_Tan",
    "G_Aviator",
    "CUP_G_ESS_KHK_Scarf_Tan_GPS_Beard",
    "CUP_G_ESS_KHK_Facewrap_Tan",
    "G_Bandana_khk"
];
private _binoculars = [
    "CUP_LRTV",
    "CUP_Vector21Nite",
    "CUP_SOFLAM"
];

private _squad = [];
for "_i" from 0 to 5 do {
    private _u = missionNamespace getVariable [format ["player_%1", _i], objNull];
    if (isNull _u) then { _u = missionNamespace getVariable [format ["player_0%1", _i], objNull]; };
    if (!isNull _u) then { _squad pushBackUnique _u; };
};

if (!isNull player && { count _squad < 6 }) then {
    {
        if (alive _x && { side _x == side player || group _x == group player }) then {
            _squad pushBackUnique _x;
        };
    } forEach (units (group player) + playableUnits + switchableUnits);
};

{
    private _unit = _x;
    private _hasLauncher = (secondaryWeapon _unit != "");
    private _loadout = getUnitLoadout _unit;
    
    private _newUniform = selectRandom _uniforms;
    private _newVest = selectRandom _vests;
    private _newHelmet = selectRandom _helmets;
    private _newGoggles = selectRandom _goggles;
    private _newBinocular = selectRandom _binoculars;
    private _newBackpack = if (_hasLauncher) then { "B_Kitbag_cbr" } else { selectRandom _backpacks };
    
    if (count (_loadout select 3) > 0) then {
        (_loadout select 3) set [0, _newUniform];
    } else {
        _loadout set [3, [_newUniform, []]];
    };

    if (count (_loadout select 4) > 0) then {
        (_loadout select 4) set [0, _newVest];
    } else {
        _loadout set [4, [_newVest, []]];
    };
    
    if (count (_loadout select 5) > 0) then {
        (_loadout select 5) set [0, _newBackpack];
    } else {
        _loadout set [5, [_newBackpack, []]];
    };

    _loadout set [6, _newHelmet];
    _loadout set [7, _newGoggles];
    _loadout set [8, [_newBinocular, "", "", "", [], [], ""]];
    
    _unit setUnitLoadout _loadout;

    if (backpack _unit == "") then {
        _unit addBackpack _newBackpack;
    };

    if (binocular _unit != _newBinocular) then {
        if (binocular _unit != "") then {
            _unit removeWeapon (binocular _unit);
        };
        _unit addWeapon _newBinocular;
    };

    if (_newBinocular == "CUP_SOFLAM" && { !("Laserbatteries" in magazines _unit) }) then {
        _unit addMagazine "Laserbatteries";
    };
    
    [_unit] call LL_fnc_badgeManager;

} forEach _squad;