# ARCHITECTURE ET CAHIER DES CHARGES — MISSION D'URGENCE (TÂCHE BONUS ALÉATOIRE)

Ce document détaille la conception, la logique opérationnelle et le plan d'intégration de la mécanique de **mission d'urgence lointaine (Tâche Bonus)** pour la mission Single-Player *OPERATION ROYAL ALLIANCE (ORA) — Takistan*.

---

## 1. Vision de Gameplay & Objectifs Immersifs

### 🔹 Rupture de Routine & Tension Tactique
Dans la structure actuelle, le joueur accomplit ses objectifs dans sa zone de départ puis déclenche immédiatement son extraction par hélicoptère. L'introduction d'une mission d'urgence surprise :
* Brise la linéarité prévisible de fin d'opération.
* Prolonge la tension en imposant un redéploiement immédiat en territoire hostile.
* Renforce le réalisme militaire : les forces spéciales en immersion reçoivent fréquemment des ordres opportunistes imprévus du commandement de théâtre.

### 🔹 Valorisation du Soutien Hélicoptère (Menu 0-8)
L'éloignement forcé de la nouvelle zone (minimum 950 mètres à vol d'oiseau à travers le désert ou le relief escarpé de Takistan) crée un besoin opérationnel réel :
* **Largage de véhicule :** Le joueur est fortement incité à appeler un Land Rover armé via le menu radio 0-8 pour traverser la carte rapidement.
* **Largage de caisse de munitions :** Si les munitions de l'escouade ont été consommées lors des premiers combats, la livraison de ravitaillement prend tout son sens tactique avant d'aborder le second objectif.

---

## 2. Conditions d'Éligibilité & Règles Décisionnelles

Le déclencheur de la tâche bonus doit respecter un arbre de décision rigoureux :

```
Fin de toutes les tâches de la zone initiale
                     │
    L'otage faisait-il partie des tâches initiales ?
            ┌────────┴────────┐
           OUI               NON
            │                 │
    [EXCLUSION STRICTE]   [Tirage Aléatoire 50%]
    Aucune tâche bonus    Une chance sur deux (50/50)
    Extraction directe        ┌───────┴───────┐
                           SUCCÈS          ÉCHEC
                             │               │
                     [MISSION D'URGENCE] [EXTRACTION NORMALE]
```

### Règle d'Exclusion Stricte (Gestion de l'Otage)
* Si le joueur a sélectionné la tâche **Libération d'otage** (`TASK_CAPTIVE`) lors de la préparation au menu principal :
  * **Interdiction absolue de déclencher une tâche bonus.**
  * *Justification :* Le joueur a déjà sous sa garde un civil vulnérable rallié à son groupe (`joinSilent`). Lui imposer un transit lourd de 1 km et un nouvel assaut compromettrait la survie de l'otage et surchargerait la gestion de commandement IA en solo.

### Règle d'Activation Aléatoire (50% de chance)
* Si le joueur n'a **pas** choisi la libération d'otage en début de partie :
  * Un tirage aléatoire à deux issues (50% de probabilité) est exécuté dès que le dernier objectif de la zone primaire passe à l'état réussi.
  * En cas de tirage favorable : bascule immédiate vers la procédure d'urgence.
  * En cas de tirage défavorable : la mission suit son cours normal vers l'embarquement d'extraction.

---

## 3. Localisation Spatiale & Sélection de la Nouvelle Zone

### 🔹 Règle des 950 Mètres Minimum & Sélection au Plus Proche
La nouvelle zone ne doit en aucun cas se situer dans le périmètre de combat actuel, tout en évitant des traversées démesurées de la carte :
1. Recherche parmi tous les marqueurs de secteurs de mission disponibles dans la mission (identifiés par le préfixe éditeur `marker_*`).
2. Exclusion stricte du marqueur de la zone courante.
3. Filtrage géographique : ne retenir que les marqueurs dont la distance en 2D avec la position courante du joueur est **strictement supérieure ou égale à 950 mètres**.
4. **Sélection de la première zone la plus proche :** L'algorithme sélectionne automatiquement parmi ces marqueurs valides celui qui est le plus proche de la position du joueur (`BIS_fnc_nearestPosition`), assurant ainsi un déplacement tactique réaliste (environ 1 à 1,5 km) sans expédier l'escouade à l'autre bout de la carte.
5. Gestion de secours (*fallback*) : dans l'éventualité où aucun marqueur ne franchit la barre des 950 m, l'algorithme sélectionne automatiquement le marqueur le plus lointain parmi tous les marqueurs restants.

---

## 4. Narration, Communications & Audio TTS

### 🔹 La Transmission Radio du QG
Dès validation du tirage et choix du secteur :
* Une transmission radio prioritaire du commandement QG est diffusée via le gestionnaire radio officiel.
* **Message clé :** *"Vous êtes appelé à une mission d'urgence !"*
* Le message audio doit être généré au format Lo-Fi radio militaire via le pipeline vocal TTS du projet (script de conversion voix avec filtres Lo-Fi et intégration dans la table de sons).
* Sous-titrage affiché simultanément sur l'interface joueur avec le code couleur officiel du QG.

---

## 5. Découpage Opérationnel en 2 Phases

Pour un déroulement fluide et immersif, la mission bonus s'articule en deux étapes successives :

### Étape 1 : Le Déplacement d'Urgence
* Création d'une tâche de transition dans le journal du joueur (type déplacement / repérage).
* Positionnement du marqueur d'objectif sur le nouveau secteur désigné au loin.
* Le système surveille l'approche de l'escouade.
* Dès que le joueur (ou un membre survivant de l'escouade) franchit le seuil des **500 mètres** de ce nouveau secteur :
  * Validation automatique de la tâche de déplacement.
  * Enchaînement sans temps mort vers le déploiement opérationnel de la cible.

### Étape 2 : L'Objectif Tactique sur Zone
L'objectif est choisi aléatoirement parmi les 4 mécaniques déjà développées et éprouvées dans le projet :
1. **Sabotage Radio :** Neutralisation du relais et du terminal de transmissions ennemi avec pose d'explosifs.
2. **Libération d'Otage :** Sauvetage d'un captif retenu dans un bâtiment sous surveillance armée (parfaitement cohérent ici puisque le joueur n'en avait pas lors de sa première mission).
3. **Élimination HVT :** Traque et neutralisation d'un officier ou commandant retranché avec sa garde rapprochée.
4. **Récupération de Documents :** Infiltration d'un complexe sécurisé et collecte de données sensibles.

> **Principe de réutilisation :** Aucune nouvelle logique de combat n'est réinventée. Le système appelle directement les fonctions de génération existantes en leur transmettant le nom du nouveau marqueur de zone.

---

## 6. Articulation avec l'Extraction Finale (Tâche C)

1. **Maintien de la Tâche de Survie :** La tâche obligatoire de survie de l'escouade (Tâche C) reste active en continu pendant toute la durée de la mission d'urgence.
2. **Suspension de l'Extraction :** Pendant la mission d'urgence, le joueur est notifié que l'extraction par hélicoptère est reportée sur le nouveau secteur opérationnel.
3. **Clôture et Retour au Menu de Soutien :** 
   * Dès que l'objectif d'urgence est accompli avec succès, le QG annonce la fin définitive des opérations terrestres.
   * L'espace aérien est déclaré sécurisé pour l'extraction.
   * Le joueur peut alors composer le `0-8` (Soutien -> Embarquement) pour faire atterrir l'UH-60 à la zone d'atterrissage la plus proche de sa nouvelle position et clore victorieusement la mission.

---

## 7. Plan d'Implémentation Technique (Sans Code)

### A. Fichiers à Intégrer ou Modifier
* **Création d'un Coordonnateur de Mission d'Urgence :**
  Un nouveau script fonctionnel dans l'arborescence des tâches, responsable de vérifier l'état d'achèvement des premières missions, de faire le tirage 50%, de sélectionner le secteur distant et de lancer la chaîne de déplacement.
* **Déclaration dans `description.ext` :**
  Déclaration de la nouvelle fonction dans `CfgFunctions` sous la classe `Task`.
* **Ajout des Entrées Vocales et Textuelles :**
  * Création des clés de localisation pour l'alerte d'urgence dans les fichiers XML de tâches.
  * Compilation vers `stringtable.xml` via l'outil Python du projet.
  * Génération des pistes vocales radio correspondantes via le script TTS.
* **Pont logique dans le Gestionnaire de Tâches Initiales :**
  Insérer un observateur en arrière-plan qui attend la complétion de la liste des tâches optionnelles choisies avant de passer le relais au coordonnateur d'urgence.

### B. Suivi des Variables d'État Recommandées
* Indicateur mémorisant si la tâche captif faisait partie du lot de départ.
* Registre des tâches optionnelles restantes à accomplir en zone primaire.
* Marqueur mémorisant la zone d'urgence sélectionnée.
* Indicateur de verrouillage de la tâche bonus pour interdire les activations multiples.
