# OPERATION ROYAL ALLIANCE (ORA) — ADAPTATION TANOA & OCÉAN INDIEN
**Document de Référence, Architecture Technique et Refonte Narrative (Lore Cartel / Mafia / Narcotrafic)**
*Mission : ORA.Tanoa | Faction Joueur : RACS Foreign Legion | Moteur : Arma 3*

---

## 1. NOUVEAU CONTEXTE OPÉRATIONNEL & GÉOPOLITIQUE : GUERRE CONTRE LES CARTELS

### 1.1 Cadre Géographique : L'Archipel de Tanoa / Océan Indien (Canal du Mozambique, Mayotte, Comores)
Le théâtre d'opérations quitte définitivement les déserts arides et les montagnes rocailleuses du Takistan pour l'environnement insulaire, tropical et maritime de **Tanoa**, transposé dans le bassin stratégique du **Sud-Ouest de l'Océan Indien** (archipels voisins du Canal du Mozambique, Mayotte, Comores et Madagascar).

* **Environnement physique** : Archipel tropical morcelé, forêts denses de jungle pluviale, mangroves côtières, lagons coralliens, réseaux fluviaux et zones portuaires clandestines.
* **Problématiques de terrain** : Rupture constante des lignes de vue par la canopée, omniprésence de cours d'eau et de côtes maritimes, dépendance aux pistes de brousse étroites et aux vecteurs héliportés.

### 1.2 La Faction Joueur : Légion Étrangère du RACS (Royal Army Corps of Sahrani)
La **Légion Étrangère du RACS** n'intervient plus dans une guerre civile conventionnelle contre des insurgés politiques du Moyen-Orient, mais sous mandat spécial militaire intergouvernemental de **contre-narcotrafic de haute intensité et de neutralisation des cartels militarisés** :
* **Mandat d'Intervention** : Démanteler les structures logistiques et militaires du syndicat du crime, assécher les voies maritimes d'exportation de stupéfiants, sécuriser les informateurs et officiers de liaison capturés, et rétablir la souveraineté républicaine sur l'archipel.
* **Doctrine Tactique** : Escouade d'opérateurs d'élite autonome héliportée, insertion basse altitude, appui aérien rapproché (CAS UH-60L) et surveillance drone temps réel en orbite haute (MQ-9 Reaper).

### 1.3 Les Factions Locales
* **Population Civile** : Habitants de l'Océan Indien (Mahorais, Comoriens, Créoles, Tanoens). Communautés de pêcheurs, dockers, agriculteurs et villageois pris en étau entre la terreur imposée par les trafiquants et les opérations armées.
* **Opposition Armée (Le Syndicat / Cartel de l'Océan Indien)** : Organisation mafieuse transnationale lourdement armée. Elle contrôle les laboratoires de raffinage clandestins, dispose de vedettes go-fast, de factions de mercenaires étrangers et de milices locales (sicarios, patrouilles en pick-ups armés et guetteurs infiltrés au sein de la population civile).

---

## 2. ANALYSE ET REFONTE INTÉGRALE DU LORE DANS LE BRIEFING ET LES TÂCHES

### 2.1 Refonte des Textes du Carnet de Bord (Journal / Diary / Briefing)
Dans `Functions\Briefing\fn_initContext.sqf` et [stringtable.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/stringtable.xml), les 3 volets du contexte sont réécrits pour évincer la guerre afghane/takistanaise au profit de la lutte contre le narcotrafic :

#### Volet 1 : Contexte Global (`STR_LL_Context_1`)
* **Ancien texte (Takistan)** : Guerre civile dévastatrice au Takistan, crise majeure au Moyen-Orient, RACS déployé pour sécuriser des ressources énergétiques.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *L'archipel de Tanoa et les îles environnantes du canal du Mozambique sont devenus la plaque tournante du narcotrafic international dans l'Océan Indien. Profitant de la porosité des frontières maritimes et de la corruption locale, un cartel mafieux surarmé (le « Syndikat ») a transformé la région en sanctuaire de production et d'acheminement de drogues dures et d'armes de contrebande. Les forces de police locale et les garde-côtes étant submergés et corrompus, le gouvernement a fait appel à la Légion Étrangère du RACS pour mener des frappes chirurgicales au cœur des sanctuaires du cartel.*

#### Volet 2 : Objectifs et Mandat (`STR_LL_Context_2`)
* **Ancien texte (Takistan)** : Restaurer l'ordre, pacifier le Takistan, contre-terrorisme.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *La Légion Étrangère du RACS est déployée avec les directives suivantes :*
  > * **1. Démantèlement des Infrastructures Illicites** : Destruction des laboratoires de traitement chimique, des terminaux radio de contrebande et neutralisation des véhicules d'appui lourd.
  > * **2. Élimination et Capture des Têtes de Réseau** : Traque des barons de la drogue (HVT), arrestation des lieutenants locaux et récupération de leurs livres de comptes clandestins.
  > * **3. Sauvetage & Exfiltration** : Récupération des agents infiltrés des stups et informateurs locaux retenus en otage avant leur exécution.
  > * **4. Protection des Populations** : Sanctionner immédiatement tout dommage collatéral envers les villageois et pêcheurs locaux pour ne pas basculer l'opinion publique en faveur des cartels.

#### Volet 3 : Contexte Narratif & Enjeux Secrets (`STR_LL_Context_3`)
* **Ancien texte (Takistan)** : Les superpuissances (OTAN/CSAT/USA) attisent les braises pour s'emparer des ressources.
* **Nouveau texte (Cartel Tanoa / Océan Indien)** :
  > *Sous couvert d'une simple mafia locale, le cartel bénéficie du soutien clandestin d'entités mercenaires et de réseaux financiers internationaux qui recyclent l'argent sale à travers les ports francs de la région. Le matériel militaire intercepté (pickups militarisés avec armes lourdes, brouilleurs de fréquences Tempest) démontre que les barons du trafic disposent d'un arsenal capable de contester les espaces côtiers et de menacer les aéronefs de patrouille.*

---

### 2.2 Réinterprétation Thématique de Tous les Objectifs de Mission

Chaque tâche SQF existante s'intègre naturellement dans cette trame narrative sans altérer la mécanique de jeu :

| Tâche / Script | Ancien Contexte (Takistan) | Nouveau Contexte Adapté (Cartel / Mafia / Océan Indien) |
| :--- | :--- | :--- |
| **Tâche A (`fn_taskA.sqf`)**<br>`task_mandatory_move` | Atteindre la zone d'opération hostile au Takistan. | **Infiltration du Secteur du Cartel** : Débarquement discret et progression à travers la mangrove/jungle vers la zone contrôlée par la mafia locale. |
| **Tâche B (`fn_taskB.sqf`)**<br>`task_mandatory_civ` | Protéger les civils takistanais contre la guerre. | **Zéro Victime Civile / Population Insulaire** : Interdiction absolue de blesser les habitants mahorais/tanoens. Éviter toute provocation qui pousserait les villageois dans les bras des trafiquants. |
| **Tâche C (`fn_taskC.sqf`)**<br>`task_mandatory_ext` | Extraction et survie de l'équipe face aux insurgés. | **Exfiltration d'Urgence** : Évacuer la zone de poser avant que les renforts de sicarios et de vedettes armées ne submergent le point d'extraction. |
| **Otage (`fn_taskD_captive.sqf`)**<br>`taskD_captive` | Agent de renseignement capturé par des rebelles afghans. | **Agent Anti-Drogue Infiltré** : Un agent des services de renseignement / stups infiltré dans le cartel a été démasqué. Retenu dans un camp retranché, il doit être extrait avant son exécution par les tueurs du cartel. |
| **Cible HVT (`fn_taskD_hvt.sqf`)**<br>`taskD_hvt` | Commandant insurgé / chef de guerre afghan. | **Baron de la Drogue / Parrain du Cartel** : Le capo local supervisant le trafic régional d'armes et de stupéfiants se trouve sur zone, protégé par ses gardes du corps privés lourdement armés. À éliminer ou capturer. |
| **Transmissions (`fn_taskD_transmission.sqf`)**<br>`taskD_transmission` | Stations radio de propagande terroriste. | **Terminaux Radio de Contrebande** : Antennes relais clandestines utilisées par le cartel pour coordonner les go-fast maritimes et brouiller les communications de la gendarmerie maritime. À faire sauter aux explosifs. |
| **Citerne Chimique (`fn_taskD_chemical.sqf`)**<br>`taskD_chemical` | Convoi d'armes chimiques / gaz toxique de guerre. | **Laboratoire Mobile / Citerne de Précurseurs de Drogue** : Citerne contenant des précurseurs chimiques industriels (acétone, acide sulfurique, solvants de pureté) servant au raffinage à grande échelle des stupéfiants. Véhicule inflammable et toxique à sécuriser intact pour extraction par élingage lourd (Slingload). |
| **Documents (`fn_taskD_documents.sqf`)**<br>`taskD_documents` | Plans d'attaque terroriste sur le corps d'un officier. | **Comptabilité Noire & Registres de Corruption** : Fouiller le corps du trésorier/lieutenant du cartel pour récupérer les clés USB et documents listant les fonctionnaires corrompus, comptes offshore et routes de livraison maritime. |
| **Arme Lourde Mobilité (`fn_taskD_tigris.sqf`)**<br>`taskD_tigris` | Blindé chenillé antiaérien Tigris (`O_APC_Tracked_02_AA_F`) volé par les milices. | **Technical du Cartel (Pickup avec Arme Lourde)** : Le blindé Tigris lourd (incohérent pour une mafia insulaire) est remplacé par un **Pickup Tout-Terrain armé d'une mitrailleuse lourde cal. 50 ou d'un bitube lourd (DShKM / ZU-23-2)**, servant de véhicule d'interdiction et d'escorte lourd aux trafiquants. |
| **Embuscade (`fn_rebelAmbush.sqf`)**<br>`rebelAmbush` | Embuscade surprise de paysans armés. | **Guet-apens de Sicarios / Tueurs du Cartel** : Des hommes de main du cartel déguisés en civils locaux tendent une embuscade coordonnée pour intercepter l'escouade. |

---

## 3. REMPLACEMENT DU TIGRIS PAR UN PICKUP ARMÉ LOURD (TECHNICAL DE CARTEL)

### 3.1 Pourquoi Abandonner le Tigris ?
Le **ZSU-39 Tigris** (`O_APC_Tracked_02_AA_F`) est un char antiaérien lourd à chenilles de l'armée régulière CSAT. Dans le contexte d'une organisation criminelle, d'un cartel de drogue ou d'une mafia insulaire sur Tanoa, un char d'assaut lourd rompt totalement l'immersion réaliste. 

Les cartels et guérillas sud-américaines ou africaines utilisent historiquement des **Pickups civils militarisés (« Technicals »)**, modifiés pour accueillir un affût lourd sur la benne arrière.

### 3.2 Choix des Véhicules de Remplacement (Classnames CUP & Vanilla)

Selon les mods actifs, plusieurs options réalistes et immersives s'offrent pour remplacer `O_APC_Tracked_02_AA_F` :

#### Option A : Pickup Hilux avec Bitube Antiaérien Lourd 23mm (CUP) — *Recommandé*
* **Classname** : `CUP_O_Hilux_zu23_TK` ou `CUP_I_Hilux_zu23_TK`
* **Avantages** :
  * Conserve **exactement le même rôle opérationnel que le Tigris** (menace antiaérienne redoutable contre l'hélicoptère allié UH-60L et le vol logistique C-130J).
  * Visuel 100% conforme à un véhicule de cartel / narco-milice (Toyota Hilux civil avec double canon automatique ZU-23-2 monté sur plateau).
  * Menace équilibrée : très dangereux pour l'infanterie et les aéronefs, mais vulnérable aux tirs de précision et aux armes légères bien ciblées sur le tireur.

#### Option B : Pickup Hilux avec Mitrailleuse Lourde DShKM 12.7mm (CUP)
* **Classname** : `CUP_O_Hilux_DShKM_TK` ou `CUP_I_Hilux_DShKM_TK`
* **Avantages** :
  * Le technical classique par excellence. Mitrailleuse lourde soviétique 12.7mm capable de perforer les blindages légers et d'interdire une zone à l'infanterie.

#### Option C : Pickup Offroad Armé HMG Cal. 50 (Arma 3 Vanilla / Apex Tanoa)
* **Classname** : `O_G_Offroad_01_armed_F` ou `I_C_Offroad_02_LMG_F`
* **Avantages** :
  * Véhicule natif de l'archipel de Tanoa (motifs usés, peinture locale Syndikat), sans aucune dépendance additionnelle, armé d'une tourelle M2 calibre .50.

### 3.3 Modifications dans le Code SQF (`fn_taskD_tigris.sqf`)
* À la ligne 100 de [fn_taskD_tigris.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_tigris.sqf) :
```sqf
// Ancien code :
// private _dca = createVehicle ["O_APC_Tracked_02_AA_F", _posVeh, [], 0, "CAN_COLLIDE"];

// Nouveau code (Pickup armé lourd de cartel) :
private _vehClass = if (isClass (configFile >> "CfgVehicles" >> "CUP_O_Hilux_zu23_TK")) then {
    "CUP_O_Hilux_zu23_TK" // Pickup Hilux bitube ZU-23 lourd
} else {
    "O_G_Offroad_01_armed_F" // Alternative Vanilla Apex Offroad HMG cal. 50
};

private _dca = createVehicle [_vehClass, _posVeh, [], 0, "CAN_COLLIDE"];
```

### 3.4 Modifications dans `stringtable.xml`
* Remplacer les chaînes relatives au "DCA Tigris" :
  * `STR_TASK_OPT8` : `"Détruire le Technical armé du cartel"` (au lieu de *"Détruire un DCA Tigris"*).
  * `STR_LL_Task_08_Title` : `"Détruire le Pickup d'appui lourd"`
  * `STR_LL_Task_08_Desc` : `"Détruisez le pickup armé lourd du cartel et le camion de brouillage Tempest pour sécuriser l'espace aérien."`
  * `STR_LL_Diary_Task08_Title` : `"OPORD: Neutralisation du Technical et du Brouilleur"`

---

## 4. MODIFICATION TECHNIQUE 1 : RESTRICTION D'ACCÈS À L'EAU (ANTI-EAU)

### 4.1 Problématique Spécifique à Tanoa
Dans Arma 3, les scripts de patrouille (`BIS_fnc_taskPatrol`), les fuites civiles (`FiredNear`) et les ordres d'assaut IA vers le joueur (`doMove player`) génèrent des positions sans vérifier la présence d'eau. Sur Tanoa, les unités civiles et OPFOR plongent dans l'océan, nagent lentement sans pouvoir riposter, et bloquent la complétion des objectifs.

### 4.2 Architecture de la Solution : `LL_fnc_preventWater`
Deux mécanismes complémentaires sont mis en place :

#### A. Filtrage Amont des Destinations (Prévention Statique)
Chaque génération de point de fuite ou de patrouille doit valider que la position n'est pas aquatique :
```sqf
private _fn_getSafeLandPos = {
    params ["_origin", "_dist", "_dir"];
    private _target = _origin getPos [_dist, _dir];
    if (surfaceIsWater _target) then {
        private _safePos = [_target, 0, 150, 2, 0, 20, 0, [], [_origin, _origin]] call BIS_fnc_findSafePos;
        if !(_safePos isEqualTo _origin) then { _target = _safePos; };
    };
    _target
};
```

#### B. Boucle Serveur de Surveillance et Rapatriement Actif (Watchdog Dynamique)
Une tâche d'arrière-plan inspecte périodiquement toutes les unités civiles et OPFOR :
```sqf
/*
    LL_fnc_preventWater
    Surveillance serveur empêchant les civils et l'OPFOR d'entrer ou de rester dans l'eau.
*/
if (!isServer) exitWith {};

[] spawn {
    while { true } do {
        sleep 4;
        private _trackedUnits = allUnits select {
            alive _x && { (side group _x == civilian || side group _x == east || _x getVariable ["LL_isEnemy", false]) }
        };

        {
            private _unit = _x;
            private _pos = getPosASLW _unit;
            private _anim = animationState _unit;
            private _inWater = surfaceIsWater (getPos _unit) || { (_pos select 2) < 0.2 } || { (_anim find "swm" != -1) };

            if (_inWater) then {
                private _safePos = [getPos _unit, 5, 80, 2, 0, 20, 0] call BIS_fnc_findSafePos;
                
                if !(_safePos isEqualTo []) then {
                    if ((_anim find "swm" != -1) || { (_pos select 2) < -0.8 }) then {
                        _unit setPosATL [_safePos select 0, _safePos select 1, 0.1];
                        _unit switchMove "";
                    } else {
                        _unit doMove _safePos;
                    };
                };
            };
        } forEach _trackedUnits;
    };
};
```

---

## 5. MODIFICATION TECHNIQUE 2 : IDENTITÉS DE MAYOTTE & DE L'OCÉAN INDIEN

### 5.1 Remplacement de la Base de Données (`fn_initTakistaniDB.sqf`)
Suppression des patronymes afghans/iraniens au profit des prénoms et noms authentiques de Mayotte, des Comores et de l'Océan Indien.

#### Noms Masculins (Extrait représentatif) :
* Abdallah Said, Mohamed Bacar, Madi Ahamada, Toihir Soilihi, Ibrahim Youssouf
* Harouna Combo, Boina Anli, Faysoil Kassim, Mansour Zaïdou, Soulaimana Attoumani
* Hamada Ousseni, Djamaldine Mouhamadi, Ali Daoud, Nassur Djaffar, Baco Hassani
* Said Issouf, Ridjali Moussa, Charif Omar, Faouz Dine, Ansoir Chakira

#### Noms Féminins (Extrait représentatif) :
* Fatima Abdou, Amina Said, Mariama Bacar, Zaliha Madi, Hadidja Mohamed
* Roukia Ahamada, Nasra Boina, Siti Soilihi, Halima Combo, Mounira Harouna
* Moina Toihir, Faouzia Youssouf, Chamsia Soulaimana, Yasmina Ousseni, Nadia Attoumani
* Anissa Daoud, Saouda Djaffar, Raïssa Hassani, Echati Issouf, Zoubeida Moussa

### 5.2 Visages & Morphologies Adaptés
* **Visages Masculins** :
  * Pacifique / Tanoan : `TanoanHead_A3_01` à `TanoanHead_A3_09`, `TanoanBossHead`
  * Africain / Océan Indien : `AfricanHead_01`, `AfricanHead_02`, `AfricanHead_03`
  * Métis : `GreekHead_A3_01`, `WhiteHead_08`
* **Visages Féminins** : Modèles féminins civils compatibles sans voile intégral.
* **Pilosité faciale** : Suppression de l'obligation de barbes afghanes massives (`CUP_Beard_Black`). Remplacé par visage rasé ou barbe courte discrète.

---

## 6. MODIFICATION TECHNIQUE 3 : SYSTÈME VOCAL CUP CZ (MÂLE ET FEMELLE)

### 6.1 Classnames des Voix CUP Tchèques
Identifiées directement depuis l'Éditeur Eden :

#### Voix Féminines (CUP Female CZ) :
* `CUP_D_Female01_CZ` (CZ Voice 01 female)
* `CUP_D_Female02_CZ` (CZ Voice 02 female)
* `CUP_D_Female03_CZ` (CZ Voice 03 female)

#### Voix Masculines (CUP Male CZ) :
* `CUP_D_Male01_CZ` (CZ Voice 01)
* `CUP_D_Male02_CZ` (CZ Voice 02)
* `CUP_D_Male03_CZ` (CZ Voice 03)
* `CUP_D_Male04_CZ` (CZ Voice 04)
* `CUP_D_Male05_CZ` (CZ Voice 05)
* Variantes Armée Tchèque (ACR) : `CUP_D_ACR_Male01_CZ` à `CUP_D_ACR_Male05_CZ`

### 6.2 Application dans les Scripts
1. **Civils Féminins** : Assignation directe de `selectRandom ["CUP_D_Female01_CZ", "CUP_D_Female02_CZ", "CUP_D_Female03_CZ"]` avec un `pitch` naturel (1.0). Fin du recours au speaker masculin sur-pitché à 1.35.
2. **Civils Masculins** : Assignation de `selectRandom ["CUP_D_Male01_CZ", "CUP_D_Male02_CZ", "CUP_D_Male03_CZ", "CUP_D_Male04_CZ", "CUP_D_Male05_CZ"]`.
3. **Forces OPFOR (`fn_secureOpforLanguage.sqf`)** : Remplacement des speakers perses `Male01PER...` par le pool masculin CUP CZ.

---

## 7. MODIFICATION TECHNIQUE 4 : LISTES DE VÊTEMENTS & ÉQUIPEMENTS TROPICAUX

### 7.1 Répartition Officielle Hommes / Femmes et Civils / Ennemis (Cartel)
Issue de l'extraction réelle du jeu dans [VETEMENTS.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/VETEMENTS.md), la base de données [fn_initTakistaniDB.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_initTakistaniDB.sqf) sépare rigoureusement :

* **Civils Hommes (`MISSION_CivilianUniforms_Male`)** : IDAP polos/shorts/cargos, T-shirts Art of War, Polos et chemisettes civils, tenues de citoyens, de mécaniciens, commerçants et vêtements de sport.
* **Civils Femmes (`MISSION_CivilianUniforms_Female`)** : Jupes et ensembles civils TCGM Girls (`TCGM_F_Mini_*`), tenues de sport (`TCGM_F_Sport_*`), IDAP, tenues journalistes et compétitrices.
* **Ennemis Hommes / Sicarios (`MISSION_EnemyUniforms_Male`)** : Tenues bandits Apex (`U_I_C_Soldier_Bandit_*`), treillis guérilla (`U_BG_Guerrilla_*`), looter et racketeer.
* **Ennemis Femmes (`MISSION_EnemyUniforms_Female`)** : Tenues de combat et de survie TCGM (`TCGM_Survival_MTP_Bra`, `TCGM_Survival_TNA_Bra`, tenues tactiques).
* **Escouade Joueur (`fn_initLoadout.sqf`)** : Préservation intégrale et stricte du loadout de l'éditeur ([INFO_EDITOR.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_EDITOR.md)) avec treillis USMC MCCUU Desert, casques OpsCore Tan/Grey, gilets JPC Coyote et accessoires d'origine.

### 7.2 Civils Femmes
Suppression intégrale des burqas afghanes (`Burqa1` à `Burqa6`). Remplacement par des jupes, ensembles civils et tenues de sport TCGM Girls adaptées à la communauté insulaire.

### 7.3 Sicarios / Hommes de main du Cartel (OPFOR)
* **Tenues** : Tenues de guérilla tropicale, chemises à motifs fleuris ou débardeurs (`U_I_C_Soldier_Bandit_*`, `U_BG_Guerrilla_*`), looter et racketeer.
* **Gilets & Harnais** : Harnais légers de brousse (`V_BandollierB_oli`, `V_Chestrig_oli`, `V_HarnessO_brn`).
* **Armement** : AKM, AK-12, fusils à pompe de chasse sciés, PDW compactes, FAL / Romat.

### 7.4 Escouade Joueur (Légion RACS)
Conformément à [INFO_EDITOR.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_EDITOR.md), le loadout allié n'est pas modifié :
* **Uniformes** : `CUP_U_B_USMC_MCCUU_des_*` (série complète avec gants, genouillères, manches retroussées).
* **Gilets & Casques** : `CUP_V_JPC_*_coy` et `CUP_H_OpsCore_Tan_*` / `Grey_*`.
* **Cagoules & Lunettes** : Série `CUP_G_Tan_Scarf_*` et verres balistiques.

---

## 8. MODIFICATION TECHNIQUE 5 : VIE ANIMALE AMBIANTE (VOLAILLE / POULTRY)

### 8.1 Pourquoi Remplacer les Moutons ?
Dans le désert du Takistan, de grands troupeaux de moutons (`Sheep_random_F`) étaient générés en plein air pour simuler le pastoralisme afghan. Sur l'archipel tropical de Tanoa et dans les villages de Mayotte / Océan Indien, ce modèle ne correspond pas à la réalité insulaire : les habitants élèvent des **volailles de basse-cour (poules, coqs)** qui errent librement dans les cours, entre les cases et les habitations villageoises.

### 8.2 Implémentation (`LL_fnc_ambientPoultry` / `fn_ambientSheep.sqf`)
* **Classes de Volaille Arma 3** :
  * Poules : `Hen_random_F`
  * Coqs : `Cock_random_F`, `Cock_white_F`
* **Comportement Insulaire** :
  * Les volailles sont générées à proximité immédiate des habitations (`House`, `Building`) plutôt qu'en rase campagne.
  * Rayon de déambulation resserré (8 à 15 mètres autour du centre de groupe).
  * **Sécurité anti-eau intégrée** : vérification `!surfaceIsWater _dest` à chaque déplacement afin d'empêcher les poules d'aller dans l'océan ou les rivières.
  * Conservation de la rétrocompatibilité des variables globales de nettoyage (`MISSION_var_ambientPoultry` et `MISSION_var_ambientSheep`).

---

## 9. INVENTAIRE PRÉCIS DES FICHIERS ET CLÉS À MODIFIER (LORE & CODE)

### 9.1 Fichiers de Configuration Générale
1. **[description.ext](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/description.ext)** :
   * Ligne 3 : `onLoadMission = "Tanoa — Opérations Spéciales Contre-Cartels";` (remplace Takistan).
   * Ligne 7 : `overviewText = "Océan Indien / Tanoa — Traque des cartels et démantèlement des réseaux de narcotrafic par la Légion Étrangère du RACS.";`
   * Déclaration de la nouvelle fonction `class preventWater {};` dans `CfgFunctions >> Environment`.
2. **[init.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/init.sqf)** :
   * Lancement côté serveur du watcher anti-eau : `[] spawn LL_fnc_preventWater;`.

### 9.2 Fichier de Traduction et Textes ([stringtable.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/stringtable.xml) & Fichiers XML Sources) — **Statut : FINALISÉ**
Conformément à la méthodologie modulaire non destructive définie dans [INFO_STRINTABLE.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_STRINTABLE.md), l'intégralité du corpus textuel a été réécrit avec l'anglais en langue de référence (`<Original>` et `<English>`) et une couverture complète dans toutes les langues supportées par Arma 3 (Français, Espagnol, Italien, Allemand, Polonais, Russe, Turc, Tchèque, Portugais, Coréen, Japonais, Chinois).

#### Cadrage Narratif Majeur :
* **Faction Déployée** : **Branche Française de la Légion Étrangère du RACS** (*French Branch of the RACS Foreign Legion*), force d'élite combinant vétérans français et volontaires internationaux sous mandat direct du Haut Commandement.
* **Menace Antagoniste** : **La Mafia de Tanoa / Cartel Insulaire**, qualifiée de **danger international majeur** en raison du contrôle du raffinage de drogue dure, de la contrebande maritime d'armes de guerre, d'alliances mercenaires transnationales et de la déstabilisation des routes commerciales maritimes.

#### Inventaire des Fichiers XML Sources & Clés Finalisées :
1. **[Functions\Briefing\fn_initContext.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Briefing/fn_initContext.xml)** :
   * `STR_LL_Context_1_Title` / `STR_LL_Context_1_Text` : *Contexte Géopolitique (Guerre contre la Mafia de Tanoa)* — Qualification du cartel en tant que danger international majeur et déploiement de la branche française de la Légion Étrangère du RACS.
   * `STR_LL_Context_2_Title` / `STR_LL_Context_2_Text` : *Mandat et Directives d'Intervention* — Démantèlement logistique, élimination des barons de la drogue, libération des agents infiltrés et stricte préservation des populations civiles insulaires.
   * `STR_LL_Context_3_Title` / `STR_LL_Context_3_Text` : *Enjeux Clandestins et Danger International* — Révélation des réseaux mercenaires transnationaux finançant l'armement lourd du cartel (brouilleurs Tempest, pickups antiaériens).
2. **[Functions\Player\fn_initLocal.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Player/fn_initLocal.xml)** :
   * `STR_LL_Briefing_Title` : Ordre d'opération tactique (OPORD).
   * `STR_LL_Briefing_Text` : Directives d'engagement de la Légion RACS face à la mafia de Tanoa avec jargon opérationnel (« *Analyser les données de vos missions...* ») et règles d'engagement.
3. **[Functions\Briefing\fn_initBriefing.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Briefing/fn_initBriefing.xml)** :
   * `STR_LL_Briefing_2_1_Text` : Harmonisation intégrale du théâtre insulaire de Tanoa (élimination définitive des reliquats de Zargabad/Takistan dans toutes les langues).
4. **[Functions\Spawn\fn_spawn_main_menu.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Spawn/fn_spawn_main_menu.xml)** :
   * `STR_TASK_1_DESC` : Reconnaissance dans le sanctuaire du cartel à Tanoa.
   * `STR_TASK_OPT2` (`STR_LL_Task_D_HVT_Desc`) : Éliminer le baron du cartel (HVT).
   * `STR_TASK_OPT4` (`STR_LL_Task_D_Transmission_Desc`) : Neutraliser les relais radio clandestins du cartel.
   * `STR_TASK_OPT5` (`STR_LL_Diary_Task04_Text`) : Sécuriser la citerne de précurseurs chimiques pour le raffinage des stupéfiants.
   * `STR_TASK_OPT7` (`STR_LL_Task_D_Doc_Desc`) : Récupérer les registres de comptabilité secrète du cartel.
   * `STR_TASK_OPT8` (`STR_LL_Task_08_Title`) : Détruire le pickup lourd armé et le brouilleur Tempest.
   * `STR_TASK_OPT9` : Capturer ou neutraliser le lieutenant du cartel.
   * `STR_OPTION_REBEL_AMBUSH` : Menace des sicarios et guetteurs infiltrés du cartel.
5. **[Functions\Task\fn_taskD_hvt.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_hvt.xml)** :
   * `STR_LL_Task_D_HVT_Title`, `STR_LL_Task_D_HVT_Desc` : Traque et élimination du parrain de la mafia de Tanoa.
6. **[Functions\Task\fn_taskD_transmission.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_transmission.xml)** :
   * `STR_LL_Task_D_Transmission_Title`, `STR_LL_Task_D_Transmission_Desc`, `STR_LL_Diary_TaskD_Transmission_Text` : Démantèlement des terminaux de transmission chiffrée du cartel.
7. **[Functions\Task\fn_taskD_tigris.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_tigris.xml)** :
   * `STR_LL_Diary_Task08_Title`, `STR_LL_Diary_Task08_Text`, `STR_LL_Task_08_Title`, `STR_LL_Task_08_Desc`, `STR_LL_Task_08_MarkerVehicles` : Neutralisation du technical lourd (ZU-23-2/HMG) et du brouilleur Tempest pour garantir la sécurité du C-130J logistique de la Légion.
8. **[Functions\Task\fn_taskD_captive.xml](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_captive.xml)** :
   * `STR_LL_Diary_Task00_Title`, `STR_LL_Diary_Task00_Text`, `STR_LL_Task_00_Title`, `STR_LL_Task_00_Desc`, `STR_LL_Task_00_Action` : Sauvetage de l'officier de renseignement infiltré retenu par les sicarios du cartel.

### 9.3 Scripts SQF du Dossier `Functions\`
* **[Functions\Civilian\fn_ambientSheep.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_ambientSheep.sqf)** : **Modifié** — Remplacement des moutons par des poules et coqs (`Hen_random_F`, `Cock_random_F`), placement près des maisons villageoises et filtre anti-noyade.
* **[Functions\Task\fn_taskD_tigris.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Task/fn_taskD_tigris.sqf)** : Remplacement du véhicule créé `O_APC_Tracked_02_AA_F` par un pickup armé (Technical `CUP_O_Hilux_zu23_TK` ou `O_G_Offroad_01_armed_F`).
* **[Functions\Environment\fn_preventWater.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Environment/fn_preventWater.sqf)** : Nouveau script créant la surveillance active et la restriction aquatique.
* **[Functions\Civilian\fn_initTakistaniDB.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_initTakistaniDB.sqf)** : Remplacement de l'intégralité des tableaux de noms, visages, tenues et armes.
* **[Functions\Civilian\fn_applyTakistaniIdentity.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_applyTakistaniIdentity.sqf)** : Intégration des voix CUP CZ (`CUP_D_Female01_CZ`... et `CUP_D_Male01_CZ`...).
* **[Functions\Civilian\fn_secureOpforLanguage.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_secureOpforLanguage.sqf)** : Forçage des voix masculines CUP CZ sur l'OPFOR.
* **[Functions\Civilian\fn_ambientCivilians.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Civilian/fn_ambientCivilians.sqf)** : Intégration de la vérification `!surfaceIsWater` sur toutes les coordonnées de déambulation et de fuite.
* **[Functions\Player\fn_initLoadout.sqf](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Functions/Player/fn_initLoadout.sqf)** : Adaptation du camouflage désert vers le camouflage forêt tropicale/jungle.

---
*Ce document constitue le cahier des charges officiel pour la mise à jour complète de la mission ORA.Tanoa.*
