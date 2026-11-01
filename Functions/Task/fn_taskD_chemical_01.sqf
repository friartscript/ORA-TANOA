/*
    Author: Friart Script
    Description: Module d'initialisation et création (Tâche D-04).
    Redirige de manière transparente vers LL_fnc_taskD_chemical pour assurer la cohérence et l'exécution sans erreur.
    Paramètres:
        _locMarker (String) : Nom du marqueur de la zone d'opération
*/

params [
    ["_locMarker", "", [""]]
];

[_locMarker] spawn LL_fnc_taskD_chemical;
