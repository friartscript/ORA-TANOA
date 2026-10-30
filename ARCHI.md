# OPERATION ROYAL ALLIANCE — Takistan Restored

Mission Solo (Single-Player) exclusive sur Arma 3.
Faction joueur : **Indépendant — RACS (Royal Army Corps of Sahrani)**.

---

## ⚠️ DIRECTIVES STRICTES DE DÉVELOPPEMENT & ARCHITECTURE

> **1. RÈGLE EXCLUSIVE SINGLE-PLAYER (SP) :**
> Cette mission s'exécute exclusivement en Solo. Tout le code s'exécute localement sur la machine du joueur. Aucune commande multijoueur (`remoteExec`, `publicVariable`, `isServer`, `hasInterface`) ne doit être utilisée ou surchargée inutilement.
>
> **2. RESPECT DES VARIABLES DE L'ÉDITEUR (`INFO_EDITOR.md`) :**
> Tous les scripts doivent se référer strictly aux entités et variables réelles déclarées dans l'éditeur (unités jouables `player_0` à `player_5`, haut-parleurs `ezan_XX`, véhicules RACS, GameLogics).
>
> **3. RÈGLE SUR LA RADIO TTS :**
> Le système de radio/TTS (`LL_fnc_radioMessage`) est STRICTEMENT réservé aux communications globales (ex: QG, Soutien, Drone, Hélicoptère). Il ne doit JAMAIS être utilisé pour les actions locales d'escouade ou les changements de Règles d'Engagement (ROE).
>
> **4. NORMES DE CODE SQF :**
> Aucun commentaire de code (`//` ou `/* */`), aucun log de débogage (`diag_log`), aucun message d'écran (`hint`, `systemChat`) ne doit figurer dans les scripts de production.
>
> **5. NOMENCLATURE DES TÂCHES :**
> Les noms de missions (titres) doivent être littéraux et descriptifs (ex: "Libérer un captif"). Aucun nom "folklorique" (ex: "Opération Broken Cage") ne doit être utilisé afin d'assurer la cohérence stricte entre le menu GUI, les marqueurs en jeu et l'écran de fin.

---

## 1. Variables & Entités Réelles de l'Éditeur (`INFO_EDITOR.md`)

| Élément / Variable | Définition / Modèle | Usage dans la mission |
| :--- | :--- | :--- |
| **`player_0` à `player_5`** | `Indépendant - RACS` | Les 6 unités jouables de l'escouade Légion Étrangère RACS (`player_0` = Joueur / Leader). |
| **`ezan_00` à `ezan_XX`** | `Loudspeaker` | Haut-parleurs répartis dans les villages/minarets pour l'appel à la prière. |
| **Hélicoptère Allié** | `CUP_I_UH60L_FFV_RACS` (UH-60L RACS) | Transport, soutien CAS, livraison de matériel et extraction VIP. |
| **Avion Allié** | `CUP_I_C130J_RACS` (C-130J RACS) | Insertion aéroportée HALO (Cinématique d'intro 02). |
| **Drone Surveillance** | `CUP_B_USMC_DYN_MQ9` (MQ-9 Reaper) | Drone de reconnaissance aérienne et surveillance de zone. |
| **Véhicule Terrestre** | `CUP_I_LR_MG_RACS` (Land Rover MG) | Véhicule léger de patrouille et de soutien au sol. |
| **GameLogics / Hélipads** | `Logic`, `Land_HelipadEmpty_F` | Points d'ancrage de spawn/mission dans les bâtiments et en extérieur (`Z + 0.2`). |
| **Gilets Joueurs RACS** | `CUP_V_JPC_*` | Gilets tactiques RACS (medical, tl, weapons, communicationsbelt, lightbelt, etc.). |
| **Accessoires Civils** | Barbes (`CUP_Beard_*`), Chapeaux (`CPU_H_TKI_Lungee_*`, `Pakol_*`, `SkullCap_*`) | Équipements esthétiques appliqués aux hommes civils takistanis. |

---

## 2. Catalogue Complet des Fonctions Déclarées & Actives (`description.ext`)

Toutes les fonctions ci-dessous sont déclarées dans `CfgFunctions` sous le tag `LL` et rattachées au moteur d'Arma 3 :

### 🔹 Core & Initialisation
* [`init.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/init.sqf) : Point d'entrée principal. Protection immédiate des 6 unités jouables, lancement des gestionnaires serveur et ouverture du menu principal.
* [`description.ext`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/description.ext) : Configuration globale, sons, musiques, `CfgCommunicationMenu`, `CfgFunctions`, `CfgMusic`, `CfgUnitInsignia`.
* [`Dialogs/main_menu.hpp`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Dialogs/main_menu.hpp) : Interface GUI du menu de préparation de mission (insertion, météo, véhicule).
* [`Functions/Spawn/fn_spawn_main_menu.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Spawn/fn_spawn_main_menu.sqf) : Logique d'affichage et de contrôle du menu principal.

### 🔹 Escouade, Identité & Comportement (`Functions/Team/` & `Functions/Player/`)
* [`Functions/Player/fn_initIdentity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_initIdentity.sqf) : Générateur d'identité aléatoire (visages, voix, noms) pour l'escouade.
* [`Functions/Player/fn_initLoadout.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_initLoadout.sqf) : Personnalisation esthétique de l'équipement RACS CUP tout en conservant le kit d'armes d'origine.
* [`Functions/Player/fn_applyLoadout.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_applyLoadout.sqf) : Application d'un ensemble complet d'équipements (uniforme, gilet, sac, casque, lunettes) en préservant et réapprovisionnant les armes compatibles.
* [`Functions/Player/fn_initLocal.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_initLocal.sqf) : Initialisation locale du joueur (journal de bord/briefing et attribution de l'identité locale).

* [`Functions/Team/fn_applyIdentity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_applyIdentity.sqf) : Application des visages et voix.
* [`Functions/Team/fn_badgeManager.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_badgeManager.sqf) : Application forcée de l'insigne officiel RACS (`Images/racs_badge_ca.paa`).
* [`Functions/Team/fn_identityManager.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_identityManager.sqf) : Gestionnaire des profils d'unités de l'escouade.
* [`Functions/Team/fn_randomizeLoadout.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_randomizeLoadout.sqf) : Script alternatif de randomisation de paquetage d'escouade.
* [`Functions/Team/fn_reloadWeapons.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_reloadWeapons.sqf) : Réapprovisionnement automatique et chambrage des munitions post-cinématique d'introduction (`MISSION_intro_finished`) pour toutes les armes (principales, poing, secondaires).
* [`Functions/Team/fn_addRoeActions.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_addRoeActions.sqf) : Menu d'actions utilisateur pour la sélection des Règles d'Engagement (ROE).
* [`Functions/Team/fn_applyRoE.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_applyRoE.sqf) : Application silencieuse du comportement de tir et de discrétion de l'escouade selon la ROE.
* [`Functions/Team/fn_switchToAI.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_switchToAI.sqf) : Gestion de la mort en Solo (transfert instantané de la caméra et du commandement vers une IA survivante).

### 🔹 Vie Ambiante & Population Civile (`Functions/Civilian/`)
* [`Functions/Civilian/fn_ambientCivilians.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_ambientCivilians.sqf) : Système de civils ambiants immersif à 6 profils de déplacement (`INDOOR`, `LOCAL`, `ROAD_WALKER`, `TRAVELER`, `MARKET`, `SITTER`) et 4 stratégies de fuite (`FLEE_ROAD`, `FLEE_DIRECT`, `FLEE_HIDE`, `FLEE_SCATTER`). Pathfinding via `nearRoads`/`roadsConnectedTo` pour les marcheurs de route et voyageurs. Propagation de peur entre civils proches (50m, délai 1-5s). Comportement `AWARE`+`FULL` pour le sprint de fuite, `CARELESS`+`LIMITED` pour la marche normale. Attentes interruptibles par `FiredNear`. Boucle de suppression synchronisée (800m/1500m, 120s).
* [`Functions/Civilian/fn_ambientSheep.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_ambientSheep.sqf) : Système de faune ambiante (10 moutons par zone de spawn). Placement terrain sécurisé hors `Logic` et `Land_HelipadEmpty_F`, patrouille pacifique autonome et boucle de despawn synchronisée (à 800m de l'objectif, suppression à 1500m+ toutes les 2 min).
* [`Functions/Civilian/fn_spawnPresence.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_spawnPresence.sqf) : Instanciation de la population civile locale selon la densité des villages.
* [`Functions/Civilian/fn_applyTakistaniIdentity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_applyTakistaniIdentity.sqf) : Attribution des visages, barbes, turbans, pakols et tenues civiles orientales.
* [`Functions/Civilian/fn_initTakistaniDB.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_initTakistaniDB.sqf) : Base de données des noms et identités takistanis.
* [`Functions/Civilian/fn_secureOpforLanguage.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Civilian/fn_secureOpforLanguage.sqf) : Fonction de sécurité linguistique déclenchée 2 minutes après franchissement des 500m de zone. Assigne de force la langue perse (`Male01PER`, `Male02PER`, `Male03PER`) à toutes les unités OPFOR tout en préservant strictement leur pitch audio et leurs équipements.

### 🔹 Soutien Aérien Hélicoptère & Drone (`Functions/Helicopter/` & `Functions/Drone/`)
* [`Functions/Helicopter/fn_initSupport.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Helicopter/fn_initSupport.sqf) : Initialisation du menu de Soutien natif (`CfgCommunicationMenu`, Touche 0-8).
* [`Functions/Helicopter/fn_heliDispatch.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Helicopter/fn_heliDispatch.sqf) : Dispatcher de priorités des missions hélicoptère (Ravitaillement, Véhicule, Extraction, CAS).
* [`Functions/Helicopter/fn_heliManager.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Helicopter/fn_heliManager.sqf) : Gestionnaire du cycle de vie de l'UH-60 RACS (spawn lointain hors de vue en élingue, dépose physique, CAS, extraction et RTB).
* [`Functions/Helicopter/fn_addResupplyAction.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Helicopter/fn_addResupplyAction.sqf) : Action addAction (`#FFFF00`) animant l'interaction de rechargement réaliste des IA à la caisse de munitions.
* [`Functions/Drone/fn_droneManager.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Drone/fn_droneManager.sqf) : Gestionnaire du drone de reconnaissance MQ-9.
* [`Functions/Drone/fn_droneDispatch.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Drone/fn_droneDispatch.sqf) : Contrôleur des missions de survol et de transmission vidéo/radio du drone.

### 🔹 Environnement, Immersion & Acoustique (`Functions/Environment/`)
* [`Functions/Environment/fn_randomWeather.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Environment/fn_randomWeather.sqf) : Initialisation et transition météo dynamique.
* [`Functions/Environment/fn_initSkills.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Environment/fn_initSkills.sqf) : Compétences dynamiques d'escouade et comportements d'attaque IA.
* [`Functions/Environment/fn_doorSecurity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Environment/fn_doorSecurity.sqf) : Ouverture automatique universelle des portes, volets roulants métalliques de commerces, grilles (`gate`), garages et portes doubles à 4.5m pour toutes les I.A à pied, fermeture automatique à 6.0m.
* [`Functions/Environment/fn_playEzan.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Environment/fn_playEzan.sqf) : Diffusion de l'Ezan en audio Mono spatialisé 3D, clustering anti-cacophonie (< 350m) et écho de vallée (2.2s - 3.4s).

### 🔹 Santé & Soins (`Functions/Medical/` & `Functions/Player/`)
* [`Functions/Medical/fn_aiHealSelf.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Medical/fn_aiHealSelf.sqf) : Auto-soin autonome des unités IA blessées.
* [`Functions/Player/fn_addHealAction.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_addHealAction.sqf) : Action interactive de soin médical sur le terrain.

### 🔹 Journal & Briefing (`Functions/Briefing/` & Racine)
* [`briefing.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/briefing.sqf) : Initialisation native du briefing Arma 3 au chargement du lobby / écran de briefing avant lancement.
* [`Functions/Briefing/fn_initBriefing.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Briefing/fn_initBriefing.sqf) : Génération des entrées de journal de bord (`createDiaryRecord` pour l'onglet natif et le manuel).
* [`Functions/Briefing/fn_initContext.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Briefing/fn_initContext.sqf) : Initialisation du contexte opérationnel.


### 🔹 Générateur de Tâches & Scénarios (`Functions/Task/`)
* **Cinématiques, Extraction & Musique :**
  * [`Functions/Task/fn_intro_01.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_intro_01.sqf) : Cinématique d'insertion UH-60 RACS.
  * [`Functions/Task/fn_intro_02.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_intro_02.sqf) : Cinématique d'insertion C-130J HALO.
  * [`Functions/Task/fn_extraction.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_extraction.sqf) : Séquence d'extraction cinématique par hélicoptère UH-60. Déclenche la musique `Music_Track_03` (`Music\Shadow of the Valley_03.ogg`), active `LL_g_extractionStarted` au décollage et transmet les résultats.
  * [`Functions/Task/fn_extraction_secure.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_extraction_secure.sqf) : Gestionnaire d'embarquement sécurisé des joueurs et alliés IA.
  * [`Functions/Task/fn_spawnStartArsenal.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_spawnStartArsenal.sqf) : Arsenal de départ avec verrouillage d'uniforme Légion.
  * [`Functions/Task/fn_initVehicleLoadout.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_initVehicleLoadout.sqf) : Transfert du loadout d'arsenal vers le véhicule d'équipe.
* **Tâches Systématiques (A, B, C) :**
  * [`Functions/Task/fn_taskA.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskA.sqf) : Tâche A - Se rendre sur la zone d'opération (550m).
  * [`Functions/Task/fn_taskB.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskB.sqf) : Tâche B - Protection des civils. Utilise un EventHandler `Killed` pour détecter les bavures des joueurs (`WEST`) et évalue le succès au décollage (`LL_g_extractionStarted`).
  * [`Functions/Task/fn_taskC.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskC.sqf) : Tâche C - Protection et extraction de l'escouade. Évalue la survie des unités jouables `player_0` à `player_5` au décollage (`LL_g_extractionStarted`).
  * [`Functions/Task/fn_task_generator.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_task_generator.sqf) : Ordonnanceur et générateur dynamique de missions. Initialise la tâche C (survie de l'escouade) puis la tâche A (se rendre sur zone).
  * [`Functions/Task/fn_taskCleanup.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskCleanup.sqf) : Gestionnaire de fin de tâche. Déclenche une contre-attaque agressive `SAD` des insurgés survivants à proximité et nettoie les civils/unités éloignées (> 1500m).
* **Tâches Optionnelles (D) :**
  * [`Functions/Task/fn_taskD_hvt.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_hvt.sqf) : Tâche optionnelle HVT (Éliminer l'officier ennemi). Distribution multi-Logics (PC Commandant, garde rapprochée à 360°, sentinelles aux accès, patrouilles de secteur), postures décontractées hors-combat, détection dynamique des menaces (`FiredNear`, `Killed`, `Hit`) et alerte collective.
  * [`Functions/Task/fn_taskD_captive.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_captive.sqf) : Tâche optionnelle Captif (Libérer l'otage). Génération de gardes, animation de soumission (`Acts_ExecutionVictim_Loop`) avec libération via action `addAction` et ralliement silencieux (`joinSilent`) au groupe du joueur.
  * [`Functions/Task/fn_taskD_transmission.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_transmission.sqf) : Tâche optionnelle Transmission (Interrompre les communications). Sabotage de l'antenne radio et du relais ennemi.
  * [`Functions/Task/fn_taskD_chemical.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_chemical.sqf) : Tâche optionnelle Chimique (Détruire les stocks chimiques). Pose d'explosifs et neutralisation de laboratoire clandestin.
  * [`Functions/Task/fn_taskD_documents.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_documents.sqf) : Tâche optionnelle Documents (Récupérer les renseignements). Fouille de bâtiment sécurisé et collecte de données sensibles.
  * [`Functions/Task/fn_taskD_tigris.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskD_tigris.sqf) : Tâche optionnelle Tigris (Détruire le blindé antiaérien ZSU-39 Tigris).
  * [`Functions/Task/fn_taskBonus.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskBonus.sqf) : Tâche Bonus - Mission d'urgence lointaine (>= 950m). Déclenchée aléatoirement (50%) à l'issue des tâches initiales (si captif non choisi), diffuse l'ordre radio TTS du QG, crée la tâche de déplacement et lance l'objectif d'urgence (Radio, Captif, HVT ou Documents) dès franchissement des 500m.

### 🔹 Interface & Audio TTS (`Functions/UI/` & `TTS/`)
* [`Functions/UI/fn_radioMessage.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/UI/fn_radioMessage.sqf) : Affichage sous-titré et restitution audio des communications radio du QG et du soutien.
* [`TTS/generate_radio.py`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/TTS/generate_radio.py) : Script Python de génération automatique des fichiers voix TTS avec filtres Lo-Fi radio.

### 🔹 Scripts Dépréciés, Orphelins ou Obsolètes (Non déclarés dans `description.ext`)
Les scripts suivants sont présents dans l'arborescence du projet mais ne sont **pas déclarés** dans `CfgFunctions` (`description.ext`) et font l'objet de recommandations d'archivage ou de suppression :
* [`Functions/Task/fn_addTaskAction.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_addTaskAction.sqf) : **Obsolète**. Ancien mécanisme multijoueur d'ajout d'action interactive de requête de tâche (`remoteExec`, `hasInterface`). Non conforme à la directive n°1 (Single-Player exclusif) et non utilisé.
* [`Functions/Task/fn_taskManager.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_taskManager.sqf) : **Déprécié**. Ancien gestionnaire de cycle de vie des tâches basé sur des requêtes serveur MP (`isServer`, broadcast public). Remplacé par le pipeline direct et fluide [`Functions/Task/fn_task_generator.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Task/fn_task_generator.sqf).
* [`Functions/Player/fn_applyIdentity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Player/fn_applyIdentity.sqf) : **Doublon orphelin**. Version non déclarée d'application d'identité. La fonction active officielle déclarée dans `CfgFunctions` est [`Functions/Team/fn_applyIdentity.sqf`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/Functions/Team/fn_applyIdentity.sqf).

---

## 3. Directives Anti-Glitch & Règles de Pathfinding (`INFO_TASKS.md`)

1. **Hauteur de Spawn :** `Z + 0.2` obligatoire pour toutes les unités/GameLogics afin d'éviter les collisions physiques avec le sol ou l'apparition sur les toits.
2. **Placement :** Utiliser systématiquement `"CAN_COLLIDE"` dans `createUnit`.
3. **Protection Initialisation :** `allowDamage false` pendant 3 secondes après le spawn.
4. **Groupes Ambiants Distincts :** Chaque civil ambiant est créé dans son propre groupe pour interdire la formation d'escouade à travers les murs.
5. **Logique de Despawn Ambiant (Civils & Faune) :**
   * **Aucun despawn précoce :** Aucun civil ni mouton ambiant ne disparaît tant que le joueur n'a pas atteint le rayon des **800m** de la zone d'objectif sélectionnée.
   * **Nettoyage périodique (800m / 1500m) :** Dès le rayon des 800m franchi par le joueur, une boucle automatique s'exécute toutes les 2 minutes (120s) et supprime via `deleteVehicle` toutes les entités ambiantes situées à **1500m ou plus** du joueur.
6. **Placement Sécurisé de la Faune :** Les moutons ambiants sont placés dans des espaces extérieurs dégagés à l'écart de tout objet `"Logic"` (GameLogic) et `"Land_HelipadEmpty_F"`.
7. **Pathfinding Découplé par Profil (6 Profils) :**
   * **`INDOOR` (~30% indoor) :** Les ordres `doMove` sont restreints aux `buildingPos` du **MÊME** bâtiment. Longues pauses (15-60s).
   * **`LOCAL` (~25% outdoor) :** Destinations restreintes aux **GameLogics (`Logic`, `Land_HelipadEmpty_F`)**. Pauses moyennes (10-30s).
   * **`ROAD_WALKER` (~20% outdoor) :** Suit les routes via `nearRoads`/`roadsConnectedTo`. Anti-retour via `LL_lastRoadPos`. Pauses courtes (3-8s).
   * **`TRAVELER` (~15% outdoor) :** Se déplace entre zones via routes et villes intermédiaires (`nearestLocations`). Devient `LOCAL` à 150m de la destination.
   * **`MARKET` (~5% outdoor) :** Stationne devant les bâtiments avec changements de direction aléatoires. Longues pauses (30-90s).
   * **`SITTER` (~5% outdoor) :** Se pose (`setUnitPos "DOWN"`) près des bâtiments. Très longues pauses (60-180s).
   * **Dispersion :** Application d'un décalage aléatoire (`_pos getPos [1 + random 3, random 360]`) sur chaque cible pour empêcher l'empilement des unités.
8. **Fuite Diversifiée (4 Stratégies) :**
   * **`FLEE_ROAD` (~30%) :** Fuit vers l'autre zone en suivant les segments de route (`roadsConnectedTo`).
   * **`FLEE_DIRECT` (~25%) :** Court en ligne directe vers l'autre zone (urgence maximale, offset 200m).
   * **`FLEE_HIDE` (~25%) :** Court vers le bâtiment le plus proche et se cache (`setUnitPos "DOWN"` pendant 5-15s). Les civils déjà indoor restent dans leur bâtiment.
   * **`FLEE_SCATTER` (~20%) :** Fuit dans une direction opposée au tireur avec dispersion ±90°.
   * **Propagation de peur :** Chaque civil paniqué propage la peur aux civils civils dans un rayon de 50m avec un délai aléatoire de 1-5s.
   * **Comportement de fuite :** `setBehaviour "AWARE"` + `setSpeedMode "FULL"` (sprint réel). 30% de chance de posture accroupie (`MIDDLE`) entre les mouvements. Toutes les attentes sont interruptibles par un nouvel événement `FiredNear`.
9. **Anti-Superposition (Tâches Multiples) :** Lors du chargement simultané de tâches optionnelles, l'algorithme doit lire la taille exacte du marqueur de zone `(markerSize _locMarker) select 0` pour délimiter la recherche de GameLogics. Il doit exclure tout point situé à moins de 15m d'une position déjà enregistrée dans `LL_g_usedTaskPos`.

---

