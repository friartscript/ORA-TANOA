# INFO_REBEL.md — Système d'Embuscades & Traque Insurgée (Spécification & Code)

Ce document détaille l'architecture, le cycle de vie, la composition des patrouilles, l'intégration GUI au menu de départ et le code SQF complet pour le système de **Rebelles & Traqueurs Insurgés** dans *Takistan Restored*.

---

## 1. Logique Tactique de Déploiement

### 🔹 Déclenchement à la LZ (Arrivée du Joueur)
Le système ne s'active pas à l'aveugle au début de la mission :
* Dès que le joueur termine son insertion (hélicoptère UH-60L ou parachutage HALO C-130) et prend le contrôle au sol à la LZ (`MISSION_intro_finished == true`), la surveillance ennemie se déclenche.
* Si l'option a été cochée dans le menu de départ, le commandement insurgé local prend connaissance de l'intrusion et envoie des cellules intercepter les forces alliées.

### 🔹 Effectif Global & Petits Groupes (2 à 7 insurgés)
* **Nombre total d'insurgés :** Déterminé aléatoirement entre **2 et 7 combattants** au total pour l'opération :
  ```sqf
  private _totalRebels = 2 + floor (random 6);
  ```
* **Taille des groupes :** Les insurgés n'opèrent jamais en armée conventionnelle, mais en **petites cellules de 2 ou 3 hommes**.
  * Si total = 4 : 2 groupes de 2.
  * Si total = 5 : 1 groupe de 2 et 1 groupe de 3.
  * Si total = 6 : 2 groupes de 3.
  * Si total = 7 : 2 groupes de 2 et 1 groupe de 3.

### 🔹 Apparition Échelonnée (Intervalle de 5 secondes à 2 minutes)
* Les groupes d'insurgés ne spawnent **pas tous d'un seul coup**.
* Un délai aléatoire compris entre **5 secondes et 120 secondes (2 minutes)** sépare l'apparition de chaque groupe :
  ```sqf
  sleep (5 + random 115);
  ```
* Cette temporisation crée une menace continue et asymétrique : le joueur peut essuyer une première escarmouche à peine sorti de la LZ, puis être pris à revers 1 à 2 minutes plus tard par un second groupe venu d'une autre direction.

---

## 2. Emplacement d'Apparition : Maisons à plus de 750m

### 🔹 Exploitation des Game Logics d'Intérieur
* Takistan comporte des entités `Logic` et `Land_HelipadEmpty_F` placées précisément à l'intérieur des maisons et cours de village.
* **Filtre de distance strict :** La Game Logic sélectionnée pour faire apparaître un groupe doit impérativement se situer à **plus de 750 mètres du joueur** au moment précis du spawn :
  $$\text{Distance}(\text{Logic}, \text{Joueur}) \ge 750\,\text{m}$$
* **Exclusion des zones de tâches :** Les positions réservées aux tâches de mission (`LL_g_usedTaskPos`) sont exclues afin d'éviter tout conflit avec les otages, scientifiques ou cibles prioritaires.

---

## 3. Comportement Tactique : Traque & Progression vers le Joueur

Dès leur création dans les maisons :
1. **Armement & Allure :**
   * Vêtus en civils takistanais (`CUP_O_TKI_Khet_Partug_*`, turbans, pakols, vestes de combat légères).
   * Armés d'AKM, AKS-74U ou Lee-Enfield avec 3 à 4 chargeurs.
   * Rattachés au camp `east` (OPFOR).
2. **Ordre de Mouvement Constant vers le Joueur :**
   * Le chef de groupe reçoit l'ordre de converger vers la position en temps réel du joueur (`doMove (getPosATL player)`).
   * Une boucle en arrière-plan réactualise leur destination toutes les 25 secondes tant que le groupe est en vie.
   * En chemin, ils profitent du relief, des ruelles et des crêtes pour progresser en mode `AWARE` / `COMBAT`.
3. **Sécurité Moteur Anti-Renegade :**
   * Chaque unité dispose d'un Event Handler `Killed` qui réajuste immédiatement le rating du joueur à 3000 si un modèle d'origine civile est abattu, évitant que les coéquipiers IA ne tirent sur le joueur.

---

## 4. Intégration GUI au Menu Initial (`Dialogs/main_menu.hpp`)

L'option est activable dès l'écran de lancement (`Refour_Main_Menu_Dialog`, IDD 7000) :

* **Case à cocher :** `CB_RebelAmbush` (`idc = 7120;`) à $y = \text{safezoneY} + (0.45 \times \text{safezoneH})$.
* **Texte d'avertissement :** `Txt_RebelAmbush` (`$STR_OPTION_REBEL_AMBUSH`) en couleur dorée (`{0.95, 0.75, 0.2, 1}`).
* **Prise en charge dans `fn_spawn_main_menu.sqf` :**
  * Mode `"OPEN"` : case décochée par défaut.
  * Mode `"LAUNCH"` : si cochée, lancement en tâche de fond du gestionnaire d'embuscades :
    ```sqf
    if (_rebelAmbushEnabled) then {
        [_dropPosCenter, _targetPos] spawn LL_fnc_rebelAmbush;
    };
    ```

---

## 5. Traduction Multilingue (12 Langues)

Définie dans `Functions/Spawn/fn_spawn_main_menu.xml` et compilée dans `stringtable.xml` :
* **Français :** `Menace insurgée (Rares embuscades civiles)`
* **English :** `Insurgent Threat (Rare civilian ambushes)`
* **German :** `Aufständischen-Bedrohung (Seltene Zivilisten-Hinterhalte)`
* **Spanish :** `Amenaza insurgente (Raras emboscadas civiles)`
* **Italian :** `Minaccia ribelle (Rare imboscate civili)`
* **Polish :** `Zagrożenie powstańcze (Rzadkie zasadzki cywilne)`
* **Portuguese :** `Ameaça insurgente (Raras emboscadas civis)`
* **Russian :** `Угроза повстанцев (Редкие засады в гражданском)`
* **Czech :** `Povstalecká hrozba (Vzácné léčky civilistů)`
* **Korean :** `반군 위협 (드문 민간인 위장 매복)`
* **Japanese :** `反乱軍の脅威 (民間人に偽装した奇襲)`
* **Chinese :** `叛軍威脅 (罕見的平民偽裝伏擊)`
* **Chinesesimp :** `叛军威胁 (罕见的平民伪装伏击)`
* **Turkish :** `İsyancı Tehdidi (Nadir sivil pusuları)`

---

## 6. Architecture des Fichiers

| Fichier | Modification | Rôle |
| :--- | :--- | :--- |
| `INFO_REBEL.md` | Spécification | Ce document de référence. |
| `Dialogs/main_menu.hpp` | Modification GUI | Ajout du contrôle CheckBox IDC `7120` et séparateur. |
| `Functions/Spawn/fn_spawn_main_menu.xml` | Localisation | Clé `$STR_OPTION_REBEL_AMBUSH`. |
| `stringtable.xml` | Localisation | Fichier maître compilé via `compile_stringtable.py`. |
| `Functions/Spawn/fn_spawn_main_menu.sqf` | Script | Capture de l'option (7120) et lancement conditionnel. |
| `Functions/Civilian/fn_rebelAmbush.sqf` | Nouveau Script | Attente arrivée LZ, découpage en 2-3 unités, intervalles 5s-2min, spawn > 750m et traque du joueur. |
| `description.ext` | Configuration | Déclaration de `class rebelAmbush {};` dans `CfgFunctions -> Civilian`. |

---

## 7. Code Source Complet : `Functions/Civilian/fn_rebelAmbush.sqf`

```sqf
if (!isServer) exitWith {};

params [
    ["_dropPos", [0,0,0], [[]]],
    ["_targetPos", [0,0,0], [[]]]
];

if (_dropPos isEqualTo [0,0,0]) exitWith {};

waitUntil {
    sleep 1;
    (missionNamespace getVariable ["MISSION_intro_finished", false]) || 
    { (player distance2D _dropPos) < 250 && isNull (findDisplay 7000) }
};

sleep (3 + random 5);

private _totalRebels = 2 + floor (random 6);
private _groupSizes = [];
private _remaining = _totalRebels;

while { _remaining > 0 } do {
    if (_remaining == 4) then {
        _groupSizes pushBack 2;
        _groupSizes pushBack 2;
        _remaining = 0;
    } else {
        if (_remaining == 2) then {
            _groupSizes pushBack 2;
            _remaining = 0;
        } else {
            if (_remaining >= 3) then {
                private _size = selectRandom [2, 3];
                if ((_remaining - _size) == 1) then { _size = 3; };
                _groupSizes pushBack _size;
                _remaining = _remaining - _size;
            } else {
                _groupSizes pushBack _remaining;
                _remaining = 0;
            };
        };
    };
};

private _excludedObjects = [
    missionNamespace getVariable ["post_camera", objNull],
    missionNamespace getVariable ["vehicles_spawner", objNull],
    missionNamespace getVariable ["post_lamp_0", objNull],
    missionNamespace getVariable ["post_lamp_1", objNull],
    missionNamespace getVariable ["post_lamp_2", objNull]
];

{
    private _grpSize = _x;

    sleep (5 + random 115);

    if (!alive player || { missionNamespace getVariable ["LL_g_extractionStarted", false] }) exitWith {};

    private _allLogics = (allMissionObjects "Logic") + (allMissionObjects "Land_HelipadEmpty_F");
    _allLogics = _allLogics select { !(_x in _excludedObjects) };

    private _usedPositions = missionNamespace getVariable ["LL_g_usedTaskPos", []];
    _allLogics = _allLogics select {
        private _cand = _x;
        (_usedPositions findIf { _x distance2D _cand < 25 }) == -1
    };

    _allLogics = _allLogics select {
        (player distance2D _x) >= 750
    };

    if (count _allLogics > 0) then {
        private _selectedLogic = selectRandom _allLogics;
        private _basePos = getPosATL _selectedLogic;
        _basePos set [2, (_basePos select 2) + 0.2];

        _usedPositions pushBack _basePos;
        missionNamespace setVariable ["LL_g_usedTaskPos", _usedPositions];

        private _grpEast = createGroup [east, true];
        _grpEast setSpeedMode "NORMAL";
        _grpEast setBehaviour "AWARE";
        _grpEast setCombatMode "RED";

        for "_u" from 1 to _grpSize do {
            private _spawnPos = _basePos getPos [random 2, random 360];
            _spawnPos set [2, (_basePos select 2)];

            private _unit = _grpEast createUnit ["C_man_1", _spawnPos, [], 0, "CAN_COLLIDE"];
            _unit setVariable ["not_Random", true, true];
            _unit setPosATL _spawnPos;
            [_unit] joinSilent _grpEast;

            [_unit, false, true] call LL_fnc_applyTakistaniIdentity;

            _unit addEventHandler ["Killed", {
                params ["_killedUnit", "_killer", "_instigator"];
                if (isNull _instigator) then { _instigator = _killer; };
                if (!isNull _instigator && { rating _instigator < 2000 }) then {
                    _instigator addRating (3000 - (rating _instigator));
                };
            }];
        };

        [_grpEast] spawn {
            params ["_grp"];
            while { ({ alive _x } count (units _grp)) > 0 && { !(missionNamespace getVariable ["LL_g_extractionStarted", false]) } } do {
                if (alive player) then {
                    (leader _grp) doMove (getPosATL player);
                };
                sleep 25;
            };

            if (missionNamespace getVariable ["LL_g_extractionStarted", false]) then {
                {
                    if (alive _x && { (_x distance2D player) > 1000 }) then {
                        deleteVehicle _x;
                    };
                } forEach (units _grp);
            };
        };
    };
} forEach _groupSizes;
```
