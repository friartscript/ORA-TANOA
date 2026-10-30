# ⚔️ OPERATION ROYAL ALLIANCE — Takistan

<div align="center">

![Arma 3](https://img.shields.io/badge/Arma%203-Scenario%20%5BSP%5D-blue?style=for-the-badge&logo=arma)
![Engine](https://img.shields.io/badge/Engine-Real%20Virtuality%204-red?style=for-the-badge)
![Mods](https://img.shields.io/badge/Dependencies-CUP%20%7C%20Max%20Women-orange?style=for-the-badge)
![Languages](https://img.shields.io/badge/Localization-14%20Languages-green?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Friart%20Script-purple?style=for-the-badge)

**Un générateur d'opérations dynamiques en bac à sable et un centre de commandement tactique immersif pour Arma 3 Solo.**

[Vue d'Ensemble](#-vue-densemble) • [Contexte & Lore](#-contexte-stratégique--lore) • [Fonctionnalités Clés](#-fonctionnalités-majeures) • [Opérations Tactiques](#-catalogue-des-missions) • [Commandement & R.O.E](#-règles-dengagement--commandement-descouade) • [Dépendances & Installation](#-installation--dépendances) • [Architecture](#-architecture-technique)

---

</div>

<br/>

## 🎯 Vue d'Ensemble

**Operation Royal Alliance (ORA)** est une mission solo tactique non-linéaire qui réinvente l'expérience d'engagement en milieu aride sur le théâtre d'opérations du **Takistan**. 

Incarnez le chef de groupe d'une escouade de la **Légion Étrangère du RACS** (*Royal Army Corps of Sahrani*). Grâce à un **lanceur tactique 3D sur mesure**, planifiez votre vecteur d'insertion, sélectionnez votre appui motorisé, réglez la météo et enchaînez des missions procédurales infinies dans un environnement moyen-oriental vivant et hautement réactif.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  CENTRE DE COMMANDEMENT ──► INSERTION TACTIQUE ──► OPÉRATIONS EN ZONE        │
│  (GUI 3 Panneaux & PiP)     (UH-60L ou C-130 HALO) (Missions Procédurales)   │
│                                                                │             │
│  FIN DE SESSION ◄──────────── EXTRACTION HÉLIPORTÉE ◄──────────┘             │
│  (Rapport de Mission)         (UH-60 CAS & Évacuation)                       │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 Contexte Stratégique & Lore

### 1. La Guerre Civile au Takistan (2025–2026)
Le **Takistan** est plongé dans une guerre civile sanglante. Carrefour géostratégique du Moyen-Orient riche en ressources sensibles, la région est devenue le sanctuaire de milices rebelles surarmées, de cellules terroristes et de seigneurs de guerre locaux menaçant la stabilité internationale.

### 2. Le Corps Expéditionnaire de Sahrani (RACS)
À la suite de la réunification du Royaume de Sahrani, la monarchie a créé une unité d'élite dédiée aux interventions extérieures à haut risque : la **Légion Étrangère du RACS** (*RACS Foreign Legion*). Composée de vétérans internationaux aguerris, l'escouade est déployée sous mandat de pacification pour éliminer la menace insurgée et protéger les populations locales sans exposer les forces régulières du Royaume.

---

## ⚡ Fonctionnalités Majeures

### 🖥️ 1. Lanceur de Mission Tactique Interactif (GUI)
* **Centre de Commandement 3D :** Interface graphique à 3 volets déployée avant chaque départ en mission.
* **Vecteurs d'Insertion Dédiés :**
  * *Vol basse altitude :* Insertion cinématique à bord d'un hélicoptère **UH-60L Black Hawk** au ras du relief.
  * *Parachutage HALO :* Largage à haute altitude depuis un avion-cargo **C-130J Hercules**.
* **Visualiseur 3D en Temps Réel (PiP) :** Sélection interactive du véhicule terrestre d'appui (Land Rover MG RACS) avec rendu caméra 3D dynamique.
* **Météorologie Dynamique :** Paramétrage temps réel de l'heure, du brouillard et de la nébulosité.

---

### 🔄 2. Moteur d'Opérations Dynamiques & Infinies
* **Boucle de Jeu Sans Limites :** Enchaînez autant d'objectifs que souhaité sans jamais interrompre la partie.
* **Génération Procédurale :** Placement dynamique des camps ennemis, patrouilles, otages, relais de communication et caches chimiques à travers les villages et montagnes du Takistan.
* **Contre-Attaque Ennemie Réactive :** À la complétion d'un objectif majeur, les cellules insurgées locales déclenchent immédiatement une manœuvre de riposte agressive (*Search & Destroy*).
* **Extraction Cinématique à la Demande :** Demandez l'évacuation à tout moment via la molette. L'hélicoptère de soutien vient extraire votre groupe sous couverture aérienne avec retour à la base et debriefing complet.

---

### 🕌 3. Immersion Culturelle & Vie Rurale Vivante
* **Appel à la Prière 3D Spatialisé (Ezan) :** Diffusion audio Mono 3D ultra-réaliste depuis les minarets des mosquées avec écho naturel de vallée (2.2s - 3.4s) et algorithme anti-cacophonie (< 350m).
* **Population Takistanaise Réaliste :**
  * Hommes civils vêtus de tenues traditionnelles, turbans (*Lungee*), bonnets (*Pakol*, *SkullCap*) et barbes afghanes.
  * **Présence de femmes civiles et combattantes** avec des modèles 3D féminins authentiques (*Mod Max Women*), burqas et tenues régionales.
  * **Protocole Vocal Persan & Pachto :** Voix natives persanes (`RadioProtocolPER`) avec modulation de pitch pour des dialogues et réactions de panique authentiques.
* **Vie Rurale & Faune :** Troupeaux de moutons procéduraux avec comportements de pâturage et dispersion sous les tirs.
* **Profils Comportementaux IA :** 6 états psychologiques civils distincts (fuite paniquée, mise à couvert, résignation, neutralité).

---

### 🎮 4. Commandement d'Escouade & Continuité Solo
* **Contrôle Tactique R.O.E :** Régulez instantanément la posture de vos 5 coéquipiers IA via le menu déroulant (Infiltration, Normal, Défense, Regroupement d'Urgence, Assaut).
* **Transfert de Commandement Transparent (`fn_switchToAI`) :** Si le joueur tombe au combat, la caméra et le commandement basculent immédiatement et sans coupure sur un coéquipier IA survivant de l'escouade.
* **Auto-Soin des Unités Alliées :** Gestionnaire autonome de premiers secours permettant aux coéquipiers IA de se soigner et de stabiliser leurs blessures au combat.
* **Système Intelligent de Portes & Grilles (`fn_doorSecurity`) :** Ouverture automatique universelle des portes, volets métalliques de commerces et portails à 4.5m pour l'infanterie, avec fermeture automatique à 6.0m pour éliminer les blocages de pathfinding d'Arma 3.

---

### 🚁 5. Appuis Tactiques & Armes Combinées
* **Appui Aérien & CAS (UH-60L Black Hawk) :** Mitraillage au sol sur coordonnées désignées.
* **Largage de Ravitaillement :** Parachutage de caisses d'armement et munitions sur votre position.
* **Drone de Reconnaissance (MQ-9 Reaper) :** Télémétrie en temps réel et retransmission vidéo de surveillance sur zone.
* **Radio TTS Vocale & Insignes :** Communications militaires immersives et écusson officiel brodé de la Légion Étrangère du RACS sur les gilets de combat.

---

## 📋 Catalogue des Missions

Chaque déploiement combine des directives d'engagement globales et des missions procédurales générées à la volée :

| Code Tâche | Type d'Opération | Description Stratégique |
| :---: | :--- | :--- |
| **Tâche A** | **Transit & Reconnaissance** | Déploiement initial et prise de position dans le secteur opérationnel (550m). |
| **Tâche B** | **Protection Civile** | Préservation des civils et respect strict des règles d'engagement (ROE). |
| **Tâche C** | **Survie du Détachement** | Préservation des effectifs de la Légion et extraction sécurisée de l'escouade. |
| **Tâche D-00** | **Libération d'Otage** | Infiltration d'un complexe fortifié pour secourir un agent de renseignement captif. |
| **Tâche D-01** | **Capture de Documents** | Récupération de données secrètes et plans de bataille au cœur d'un avant-poste ennemi. |
| **Tâche D-04** | **Neutralisation Chimique** | Infiltration d'une usine clandestine et destruction de fûts de neurotoxiques. |
| **Tâche D-08** | **Sabotage de Relais** | Destruction d'une station de transmission et d'un drone tactique *Tigris*. |
| **Tâche D-HVT** | **Élimination de Cible (HVT)** | Traque et neutralisation d'un haut commandant insurgé retranché. |
| **Tâche D-Trans**| **Piratage de Fréquence** | Piratage et désactivation d'un émetteur radio de propagande rebelle. |

---

## 🎖️ Règles d'Engagement & Commandement d'Escouade

Gérez la tactique de votre escouade en direct via le menu dynamique (molette de la souris) :

| Posture Tactique | Effet sur l'Escouade IA | Cas d'Usage Idéal |
| :--- | :--- | :--- |
| 🤫 **Infiltration** | Déplacement furtif en silence, accroupi, désactivation de l'autocombat. | Approche nocturne, reconnaissance, contournement de patrouilles. |
| 🛡️ **Normal** | Vitesse standard, engagement libre à portée utile, couverture mutuelle. | Progression générale en terrain ouvert et fouille de village. |
| 🏰 **Défense** | Prise de position statique à 360°, couverture des accès et fenêtres. | Attente de l'extraction, sécurisation de VIP, tenue d'un carrefour. |
| ⚡ **Regroupement d'Urgence** | Sprint immédiat vers le leader, rupture de contact sans riposte. | Désengagement sous tir de mortier, extraction précipitée. |
| 💥 **Assaut** | Vitesse maximale, tir de suppression soutenu et progression agressive. | Assaut final sur bâtiment fortifié, réduction d'un nid de résistance. |

---

## 📦 Installation & Dépendances

### 1. Prérequis (Mods Requis)
Cette mission nécessite les mods suivants, disponibles sur le **Steam Workshop** :

* [CUP Terrains - Core](https://steamcommunity.com/sharedfiles/filedetails/?id=583496341)
* [CUP Terrains - Maps](https://steamcommunity.com/sharedfiles/filedetails/?id=583544988)
* [CUP Units](https://steamcommunity.com/sharedfiles/filedetails/?id=497661914)
* [CUP Vehicles](https://steamcommunity.com/sharedfiles/filedetails/?id=541888371)
* [CUP Weapons](https://steamcommunity.com/sharedfiles/filedetails/?id=497660133)
* [Max Women](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886)

### 2. Installation Manuelle
1. Téléchargez ou clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-compte/ORA.Takistan.git
   ```
2. Déposez le dossier `ORA.Takistan` dans votre répertoire de missions Solo Arma 3 :
   ```text
   C:\Users\<VotreNom>\Documents\Arma 3\missions\ORA.Takistan
   ```
3. Lancez **Arma 3** avec les mods CUP et Max Women activés.
4. Rendez-vous dans le menu : **Jouer** ──► **Scénarios** ──► **Operation Royal Alliance**.

---

## 🌐 Localisation Multilingue (14 Langues)

La mission intègre une internationalisation native complète grâce à un pipeline XML compilé :

| Langue | Statut | Langue | Statut | Langue | Statut |
| :--- | :---: | :--- | :---: | :--- | :---: |
| 🇫🇷 **Français** | 100% | 🇬🇧 **Anglais** | 100% | 🇪🇸 **Espagnol** | 100% |
| 🇩🇪 **Allemand** | 100% | 🇮🇹 **Italien** | 100% | 🇵🇱 **Polonais** | 100% |
| 🇷🇺 **Russe** | 100% | 🇹🇷 **Turc** | 100% | 🇯🇵 **Japonais** | 100% |
| 🇰🇷 **Coréen** | 100% | 🇨🇳 **Chinois** | 100% | 🇵🇹 **Portugais** | 100% |
| 🇨🇿 **Tchèque** | 100% | 🌐 **Original** | 100% | | |

*Pour ajouter ou modifier des traductions, consultez le guide dédié :* [`INFO_STRINTABLE.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/INFO_STRINTABLE.md).

---

## 🏗️ Architecture Technique

Le code source de la mission a été conçu selon des normes strictes de modularité et de performance :

* **Zéro Desync :** 100% optimisé pour le moteur Solo (pas de surcharge réseau multijoueur inutile).
* **Architecture Modulaire :** 54 fonctions SQF spécialisées regroupées par domaine sous `Functions/` (`Briefing/`, `Civilian/`, `Drone/`, `Environment/`, `Helicopter/`, `Medical/`, `Player/`, `Spawn/`, `Task/`, `Team/`).
* **Documentation Exhaustive :** Pour une analyse technique détaillée fichier par fichier de l'ensemble du projet, consultez le document d'architecture :  
  👉 **[`ARCHI.md`](file:///c:/Users/kevin/Documents/Arma%203/missions/ORA.Takistan/ARCHI.md)**

---

## 👤 Auteur & Crédits

* **Créateur & Développeur Principal :** **Friart Script** ([@friartscript](https://steamcommunity.com))
* **Moteur & Univers :** [Bohemia Interactive](https://www.bohemia.net/) (*Arma 3*)
* **Assets & Équipements :** [CUP Team](http://cup-arma3.org/) (*Community Upgrade Project*)
* **Modèles Féminins :** [Max](https://steamcommunity.com/sharedfiles/filedetails/?id=1451755886) (*Max Women*)
* **Bande Son Originale :** *Shadow of the Valley* (Tracks 01, 02, 03)

---

<div align="center">

*« Analyser les données de vos missions et informations qui vous sont données et tout se passera bien. »*  
**OPORD — Commandement de la Légion Étrangère du RACS**

</div>
