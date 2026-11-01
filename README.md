# ⚔️ OPERATION ROYAL ALLIANCE — Tanoa

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%5D-blue?style=for-the-badge&logo=arma)
![DLC](https://img.shields.io/badge/DLC%20Required-Apex%20%28Tanoa%29-yellow?style=for-the-badge)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Dependencies-CUP%20%7C%20TCGM%20Girls-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-15%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Un générateur d'opérations dynamiques en bac à sable et un centre de commandement tactique immersif pour Arma 3 Solo.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte & Lore](#-contexte-stratégique--lore) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Opérations Tactiques](#-catalogue-des-missions) • [Commandement & R.O.E](#-règles-dengagement--commandement-descouade) • [Dépendances & Installation](#-installation--dépendances) • [Architecture Détaillée](#-architecture-détaillée-du-projet)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**Operation Royal Alliance (ORA)** est une mission solo tactique non-linéaire se déroulant sur l'archipel tropical de **Tanoa**.

Incarnez le chef de groupe d'une escouade d'élite de la **Branche Française de la Légion Étrangère du RACS** (*Royal Army Corps of Sahrani*). Grâce à un **centre de commandement tactique 3D**, planifiez votre insertion héliportée, sélectionnez votre véhicule terrestre d'appui, réglez la météo en temps réel et enchaînez des missions procédurales infinies dans un environnement insulaire vivant, hostile et hautement réactif.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  CENTRE DE COMMANDEMENT ──► INSERTION HÉLIPORTÉE ──► OPÉRATIONS EN ZONE      │
│  (GUI 3 Panneaux & PiP)     (UH-60L Black Hawk LZ)   (Missions Procédurales) │
│                                                                │             │
│  FIN DE SESSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Rapport de Mission)         (UH-60L CAS & Évacuation)                      │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Contexte Stratégique & Lore

### 1. La Guerre Contre les Cartels & le Narcotrafic (Océan Indien)
L'archipel de **Tanoa** et les îles environnantes sont devenus la plaque tournante du narcotrafic international dans l'Océan Indien. Profitant de la porosité des frontières maritimes, un cartel mafieux surarmé (le **Syndikat**) a transformé la région en sanctuaire de raffinage de drogue dure, de contrebande d'armes de guerre et de piraterie maritime. 

### 2. Le Corps Expéditionnaire de Sahrani (Légion RACS)
Face à la corruption locale et à la menace représentée par les milices du cartel, le gouvernement a fait appel à la **Branche Française de la Légion Étrangère du RACS**. Cette unité d'élite mène des frappes chirurgicales au cœur des sanctuaires de la mafia insulaire avec un mandat strict :
* **Démanteler les infrastructures logistiques clandestines** (laboratoires chimiques, émetteurs radio de contrebande, technicals armés).
* **Traquer et neutraliser les têtes de réseau** (barons de la drogue et lieutenants).
* **Secourir les agents infiltrés et otages** avant leur exécution.
* **Protéger rigoureusement la population civile insulaire** (règle absolue : zéro dommage collatéral).

---

## ⚡ Fonctionnalités Majeures

### 🖥️ 1. Lanceur de Mission Tactique Interactif (GUI)
* **Centre de Commandement 3D :** Interface graphique interactive déployée avant chaque départ en mission.
* **Insertion Héliportée Dédiée :** Dépose cinématique au ras de la canopée et des lagons à bord d'un hélicoptère **UH-60L Black Hawk** sur la zone d'atterrissage (LZ).
* **Visualiseur 3D en Temps Réel (PiP) :** Sélection interactive du véhicule terrestre d'appui (Land Rover MG RACS) avec rendu caméra 3D direct.
* **Météorologie Dynamique :** Paramétrage temps réel de l'heure, du brouillard et de la couverture nuageuse.
* **Bande Son Immersive & Sous-Titres :** *Chant de la Légion Étrangère* synchronisé en temps réel avec une couche d'affichage cinéma haute définition et traduction intégrale dans les 15 langues du jeu.

---

### 🔄 2. Moteur d'Opérations Dynamiques & Procédurales
* **Boucle de Jeu Sans Limites :** Enchaînez autant d'objectifs que souhaité sans jamais interrompre la partie.
* **Génération Procédurale Réactive :** Placement dynamique des camps ennemis, patrouilles, otages, relais de communication, convois chimiques et technicals à travers la jungle, les villages et les installations côtières.
* **Contre-Attaque Ennemie Réactive :** À la réussite d'un objectif majeur, des cellules de sicarios déclenchent une manœuvre de traque et d'interception (*Search & Destroy*).
* **Extraction Cinématique à la Demande :** Demandez l'évacuation à tout moment via la molette. L'UH-60L de soutien vient extraire votre groupe sous couverture armée avec debriefing complet.

---

### 🌴 3. Immersion Insulaire & Vie Locale Vivante
* **Identités Civiles & Régionales :**
  * Noms et patronymes authentiques de l'Océan Indien (Mayotte, Comores, Tanoa).
  * Population masculine vêtue de tenues tropicales civiles, polos, chemisettes et vêtements de travail.
  * **Présence de femmes civiles et de combattantes ennemies :** Séparation stricte et étanche entre citoyennes civiles inoffensives (immunité totale, statut captif et zéro ciblage) et combattantes ennemies armées du cartel.
  * **Système Vocal CUP CZ Dédié :** Voix tchèques natives assignées séparément aux hommes (`CUP_D_Male*_CZ`) et aux femmes (`CUP_D_Female*_CZ`).
* **Faune Insulaire Authentique :** Volailles de basse-cour (poules `Hen_random_F`, coqs `Cock_random_F`) déambulant dans les cours villageoises en remplacement des troupeaux désertiques.
* **Surveillance Anti-Noyade (`fn_preventWater`) :** Algorithme temps réel garantissant que les IA civiles et ennemies ne plongent pas et ne se noient pas dans les lagons ou l'océan.

---

### 🎮 4. Commandement d'Escouade & Continuité Solo
* **Contrôle Tactique R.O.E :** Régulez instantanément la posture de vos coéquipiers IA via la molette (Infiltration, Normal, Défense, Regroupement d'Urgence, Assaut).
* **Transfert de Commandement Transparent (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le commandement basculent immédiatement et sans coupure sur un coéquipier survivant de l'escouade.
* **Auto-Soin des Unités Alliées :** Gestionnaire autonome de premiers secours permettant aux coéquipiers IA de se soigner et de stabiliser leurs blessures au combat.
* **Gestionnaire Intelligent de Portes & Grilles (`fn_doorSecurity`) :** Ouverture automatique universelle des portes, volets métalliques et portails à 4,5 m pour l'infanterie, avec fermeture à 6 m pour éliminer les blocages de pathfinding.

---

### 🚁 5. Appuis Tactiques & Armes Combinées
* **Appui Aérien Rapproché CAS (UH-60L Black Hawk) :** Mitraillage au sol sur coordonnées désignées.
* **Largage de Ravitaillement :** Parachutage de caisses d'armement et munitions sur votre position.
* **Drone de Reconnaissance (MQ-9 Reaper) :** Télémétrie en temps réel et retransmission vidéo de surveillance sur zone.
* **Écusson Officiel :** Insigne brodé de la Légion Étrangère du RACS sur les gilets de combat alliés.

---

## 📋 Catalogue des Missions

Chaque déploiement combine des directives d'engagement globales et des missions procédurales générées à la volée :

| Code Tâche | Type d'Opération | Description Stratégique |
| :---: | :--- | :--- |
| **Tâche A** | **Infiltration du Secteur** | Débarquement discret et progression à travers la jungle vers la zone contrôlée par le cartel. |
| **Tâche B** | **Protection Civile** | Zéro victime collatérale. Respect absolu des règles d'engagement envers les villageois insulaires. |
| **Tâche C** | **Survie du Détachement** | Préservation des effectifs de la Légion et évacuation sécurisée de l'escouade. |
| **Tâche D-00** | **Sauvetage d'Agent Infiltré** | Infiltration d'un camp retranché pour libérer un agent anti-drogue avant son exécution. |
| **Tâche D-01** | **Comptabilité Noire & Documents** | Récupération des registres de corruption et routes maritimes sur le corps d'un lieutenant du cartel. |
| **Tâche D-04** | **Citerne de Précurseurs Chimiques** | Sécurisation d'une citerne de solvants de raffinage et extraction par hélitreuillage lourd (Slingload). |
| **Tâche D-08** | **Destruction de Technical Lourd** | Neutralisation d'un pickup armé lourd (ZU-23-2 / HMG) et d'un camion de brouillage Tempest. |
| **Tâche D-HVT** | **Élimination du Baron de la Drogue** | Traque et neutralisation du chef local du cartel protégé par sa garde rapprochée. |
| **Tâche D-Trans**| **Terminaux Radio de Contrebande** | Sabotage aux explosifs des relais radio clandestins servant à la coordination des go-fast. |

---

## 🎖️ Règles d'Engagement & Commandement d'Escouade

Gérez la tactique de votre escouade en direct via le menu dynamique (molette de la souris) :

| Posture Tactique | Effet sur l'Escouade IA | Cas d'Usage Idéal |
| :--- | :--- | :--- |
| 🤫 **Infiltration** | Déplacement furtif en silence, accroupi, désactivation de l'autocombat. | Approche discrète dans la jungle, contournement de sentinelles. |
| 🛡️ **Normal** | Vitesse standard, engagement libre à portée utile, couverture mutuelle. | Progression générale en terrain ouvert et reconnaissance de village. |
| 🏰 **Défense** | Prise de position statique à 360°, couverture des accès et clairières. | Attente de l'hélicoptère d'extraction, tenue d'un carrefour ou d'un quai. |
| ⚡ **Regroupement d'Urgence** | Sprint immédiat vers le leader, rupture de contact sans riposte. | Désengagement sous tir de mitrailleuse lourde, repli d'urgence. |
| 💥 **Assaut** | Vitesse maximale, tir de suppression soutenu et progression agressive. | Assaut final sur bâtiment fortifié, réduction d'un camp retranché. |

---

## 📦 Installation & Dépendances

### 1. Prérequis (DLC & Mods Requis)
Cette mission nécessite l'extension officielle et les mods suivants :

* **Arma 3 Apex** (DLC officiel Bohemia Interactive — carte de **Tanoa**)
* [CUP Units](https://steamcommunity.com/sharedfiles/filedetails/?id=497661914)
* [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
* [CUP Weapons](https://steamcommunity.com/sharedfiles/filedetails/?id=497660133)
* [TCGM_Girls](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886) (Modèles & tenues féminines civiles et militaires)

### 2. Installation Manuelle
1. Téléchargez ou clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-compte/ORA.Tanoa.git
   ```
2. Déposez le dossier `ORA.Tanoa` dans votre répertoire de missions Solo Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\ORA.Tanoa
   ```
3. Lancez **Arma 3** avec les extensions et mods activés.
4. Rendez-vous dans le menu : **Jouer** ──► **Scénarios** ──► **Operation Royal Alliance**.

---

## 🌐 Localisation Multilingue (15 Langues)

La mission intègre une internationalisation native complète grâce au fichier compilé `stringtable.xml` :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois** | 100% | 🇵🇹 **Portugais** | 100% |
| 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% | 🇨🇳 **Chinois (Alt)** | 100% |

*Pour plus de détails sur le système de localisation, consultez :* [`INFO_STRINTABLE.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_STRINTABLE.md).

---

## 🏗️ Architecture Détaillée du Projet

Le projet repose sur une architecture modulaire en scripts SQF autonomes, conçue spécifiquement pour le jeu Solo (Single-Player) afin d'assurer une fluidité maximale, sans aucune surcharge réseau superflue.

```
ORA.Tanoa/
├── init.sqf                      # Point d'entrée principal de la mission
├── description.ext               # Déclaration des fonctions (CfgFunctions), sons, musiques et GUI
├── stringtable.xml               # Base de données de localisation (15 langues traduites)
├── Dialogs/                      # Définitions des interfaces graphiques (GUI)
│   └── main_menu.hpp             # Panneau de lancement tactique 3D
└── Functions/                    # Modules fonctionnels de la mission
    ├── Spawn/                    # Centre de commandement et préparation de mission
    ├── Task/                     # Moteur procédural des opérations et cinématiques
    ├── Team/ & Player/           # Escouade, identité, R.O.E et continuité Solo
    ├── Medical/                  # Gestion des soins et de l'auto-médication IA
    ├── Helicopter/ & Drone/      # Soutien tactique 0-8 (Largages, CAS, Drone, Extraction)
    ├── Civilian/                 # Foule civile, comportement, fuite et faune
    ├── Environment/              # Météo dynamique, anti-noyade et ouverture de portes
    └── UI/                       # Radio militaire TTS et affichage sous-titré
```

---

### 🔄 1. Pipeline Global d'Exécution (Cycle de Vie de la Mission)

1. **Initialisation (`init.sqf`) :** Dès le chargement, les 6 membres de l'escouade (`player_0` à `player_5`) sont immunisés temporairement, leurs identités procédurales sont assignées, les gestionnaires d'ambiance et de confort démarrent en arrière-plan, et le joueur est plongé dans un fondu noir ouvrant le centre de commandement tactique.
2. **Centre de Commandement 3D (`Functions/Spawn/`) :** Le joueur configure son opération sur un panneau à 3 colonnes : choix de l'heure, de la météo, du véhicule d'appui (visualisé en direct via une caméra 3D PiP) et sélection de 1 à 3 missions optionnelles.
3. **Insertion Cinématique (`fn_intro_01` / `fn_intro_02`) :** Une cinématique immersive dépose l'escouade sur la zone d'opération au ras des arbres en hélicoptère UH-60L Black Hawk (ou largage aéroporté), accompagnée du *Chant de la Légion Étrangère*.
4. **Arsenal & Logistique Véhicule (`fn_spawnStartArsenal`, `fn_initVehicleLoadout`) :** Au point de départ, une caisse d'arsenal complète permet d'ajuster l'armement. Tout équipement choisi par le joueur synchronise automatiquement les munitions et chargeurs correspondants dans le coffre du véhicule de patrouille.
5. **Génération Procédurale en Cascade (`Functions/Task/`) :** L'arrivée à proximité du secteur d'opération déclenche automatiquement la mission d'infiltration (Tâche A), la surveillance de la population civile (Tâche B) et les objectifs optionnels choisis.
6. **Extraction Tactique (`fn_extraction`, `fn_extraction_secure`) :** L'évacuation n'est jamais automatique. Le joueur appelle manuellement l'hélicoptère d'extraction via le menu radio Support (0-8-3) quand il le décide pour terminer sa session.

---

### 🧩 2. Les Sous-Systèmes & Fonctionnalités Clés

#### 🎮 A. Escouade & Continuité Solo (`Functions/Team/` & `Functions/Player/`)
* **Randomisation Procédurale (`fn_initIdentity`, `fn_initLoadout`) :** Chaque partie attribue des visages, voix, lunettes, casques et gilets RACS uniques à chaque coéquipier tout en conservant les uniformes réglementaires et l'armement.
* **Continuité Immédiate sans Game Over (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le contrôle passent instantanément au membre survivant le plus proche au sein de l'escouade.
* **Règles d'Engagement à la Molette (`fn_addRoeActions`, `fn_applyRoE`) :** 5 postures tactiques instantanées modifiant le comportement des coéquipiers (Infiltration discrète, Normal, Défense à 360°, Regroupement d'urgence en sprint, Assaut agressif).
* **Auto-Soin des Coéquipiers (`fn_aiHealSelf`, `fn_addHealAction`) :** Les coéquipiers IA blessés se soignent et se stabilisent de façon autonome dès qu'ils sont hors de danger immédiat.

#### 🎯 B. Moteur des Missions Procédurales (`Functions/Task/`)
* **Tâches Systématiques :**
  * **Tâche A (`fn_taskA`) :** Se rendre sur le secteur d'opération pour débloquer le réseau d'objectifs.
  * **Tâche B (`fn_taskB`) :** Protéger les civils insulaires (toute bavure sanctionne l'opération d'un échec).
  * **Tâche C (`fn_taskC`) :** Assurer la survie du détachement lors de l'évacuation finale.
* **Catalogue des Missions Optionnelles (Tâches D) :**
  * **Captif (`fn_taskD_captive`) :** Libération d'un agent retenu sous surveillance et ralliement au groupe.
  * **Cible Prioritaire HVT (`fn_taskD_hvt`) :** Élimination du baron de la drogue protégé par sa garde d'élite.
  * **Relais Radio (`fn_taskD_transmission`) :** Sabotage d'antennes émettrices avec amorces sonores et détonation.
  * **Citernes Chimiques (`fn_taskD_chemical`) :** Sécurisation et extraction par hélicoptère lourd CH-47 Chinook avec câbles PhysX, ou détonation catastrophique avec onde de choc et nuage toxique (les épaves restent définitivement sur le terrain).
  * **Renseignements (`fn_taskD_documents`) :** Récupération de documents confidentiels sur un officier adverse.
  * **Véhicules Antiaériens (`fn_taskD_tigris`) :** Destruction des DCA blindées du cartel pour libérer l'espace aérien.
* **Mission d'Urgence Bonus (`fn_taskBonus`) :** Le commandement peut contacter par radio l'escouade pour lui assigner un objectif surprise supplémentaire dans un secteur distant.
* **Réaction & Contre-Attaque (`fn_taskCleanup`) :** La complétion d'un objectif déclenche une traque active des insurgés survivants vers la position du joueur.

#### 🚁 C. Soutien Tactique & Appui Aérien (`Functions/Helicopter/` & `Functions/Drone/`)
* **Menu de Communication Dédié (0-8) :** Accessible via la radio tactique native d'Arma 3 :
  * **0-8-1 (Ravitaillement) :** Parachutage d'une caisse logistique complète balisée par des fumigènes tricolores (Bleu-Blanc-Rouge) et réarmement interactif des coéquipiers.
  * **0-8-2 (Véhicule) :** Dépose d'un véhicule de transport de remplacement en cas de perte de mobilité.
  * **0-8-3 (Extraction) :** Évacuation manuelle de l'escouade par hélicoptère allié.
  * **0-8-4 (CAS) :** Appui-feu aérien rapproché au canon sur zone désignée.
  * **0-8-5 (Drone) :** Survol de reconnaissance d'un MQ-9 Reaper avec flux de télémétrie.

#### 🌴 D. Simulation du Monde & Vie Civile (`Functions/Civilian/`)
* **6 Profils de Déplacement Civil (`fn_ambientCivilians`) :** Les civils vivent naturellement (présents à l'intérieur, marcheurs sur routes, voyageurs inter-villages, chalands de marché, personnes assises).
* **4 Stratégies de Fuite Sous le Feu :** Dès les premiers tirs, les civils paniquent, se réfugient dans les habitations ou fuient par les chemins, propageant la panique aux résidents proches.
* **Séparation Civils / Ennemis :** Respect strict entre les femmes civiles inoffensives (immunité totale) et les combattantes armées du cartel.
* **Sécurité Anti-Noyade (`fn_preventWater`) :** Algorithme repositionnant immédiatement toute unité civile ou ennemie égarée dans l'océan ou les canaux pour éliminer les noyades absurdes.

#### 🚪 E. Confort de Jeu & Environnement (`Functions/Environment/`)
* **Portes Automatiques Intelligentes (`fn_doorSecurity`) :** Ouverture automatique à 4,5 m des portes, volets roulants et portails de clôture pour éviter que les coéquipiers IA ne restent coincés, avec fermeture automatique après passage.
* **Météorologie Vivante (`fn_randomWeather`) :** Évolution fluide et naturelle du ciel, de la brume et du vent au fil de l'opération.

#### 🌐 F. Traduction & Audio TTS (`Functions/UI/`, `stringtable.xml`)
* **Sous-Titres & Menus 100% Traduits :** Prise en charge native intégrale des 15 langues d'Arma 3 dans tous les menus, directives et dialogues.
* **Radio Militaire TTS (`fn_radioMessage`) :** Communications audio des pilotes et du QG transmises avec un traitement sonore Lo-Fi radio pour une immersion maximale.

---

## 📚 Documentation Technique Complémentaire

Pour approfondir les détails d'implémentation et les directives de configuration, consultez les guides dédiés :

* **[ARCHI.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/ARCHI.md)** : Répertoire exhaustif de toutes les fonctions SQF déclarées et variables globales de la mission.
* **[INFO_STRINTABLE.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_STRINTABLE.md)** : Guide de gestion et de compilation des traductions multilingues (`stringtable.xml`).
* **[INFO_TANOA.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_TANOA.md)** : Contexte narratif et adaptation géographique de l'archipel.
* **[INFO_STEAM.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/INFO_STEAM.md)** : Modèle de publication officiel pour le Steam Workshop.
* **[Music/MUSIC.md](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Tanoa/Music/MUSIC.md)** : Retranscription intégrale, traduction et chronologie du *Chant de la Légion Étrangère*.

---

## 👤 Auteur & Crédits

* **Créateur & Développeur Principal :** **Friart Script** ([@friartscript](https://steamcommunity.com))
* **Moteur & Univers :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3 Apex*)
* **Assets & Équipements :** [CUP Team](http://cup-arma3.org/) (*Community Upgrade Project*)
* **Modèles Féminins :** [TCGM Girls](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886)
* **Bande Son d'Introduction :** *Chant de la Légion Étrangère* (Legion 001 - Marche)

---

<div align="center">

*« Analyser les données de vos missions et informations qui vous sont données et tout se passera bien. »*  
**OPORD — Commandement de la Légion Étrangère du RACS**

</div>
