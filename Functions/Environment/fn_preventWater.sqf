if (!isServer) exitWith {};

while {true} do {
    sleep 3;

    private _trackedUnits = allUnits select {
        alive _x && { (side group _x in [civilian, east]) || (_x getVariable ["LL_isEnemy", false]) }
    };

    {
        private _unit = _x;
        private _posWorld = getPosWorld _unit;
        private _isSwimming = (animationState _unit) find "swm" != -1;
        private _inWater = surfaceIsWater _posWorld;

        if (_inWater || _isSwimming || { (_posWorld select 2) < 0.2 && underwater _unit }) then {
            private _currentPos = getPosATL _unit;
            private _safePos = [_currentPos, 15, 90, 2, 0, 0.25, 0] call BIS_fnc_findSafePos;

            if (!surfaceIsWater _safePos && { !(_safePos isEqualTo [0, 0, 0]) }) then {
                _unit switchMove "";
                _unit setPosATL [_safePos select 0, _safePos select 1, 0.1];
                _unit setVelocity [0, 0, 0];

                private _grp = group _unit;
                if (!isNull _grp) then {
                    _unit doMove _safePos;
                    private _curWP = [_grp, currentWaypoint _grp];
                    if (surfaceIsWater (waypointPosition _curWP)) then {
                        deleteWaypoint _curWP;
                        private _newWp = _grp addWaypoint [_safePos, 0];
                        _newWp setWaypointType "MOVE";
                        _grp setCurrentWaypoint _newWp;
                    };
                };
            };
        };
    } forEach _trackedUnits;
};
