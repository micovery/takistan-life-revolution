#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_object", "_copLocked", "_nearby"];

_object = _this select 0;

_copLocked = _object getVariable ["copLocked", false];

if (!isCop) then {
		_nearby = (getPosATL player) nearEntities ["caManBase", 100];
		if ( ({(isPlayer _x) && (alive _x) && ((side _x) == West)} count _nearby) > 0 ) then {
					[player, "Tampering with Police Fortifications", 10000, 35, false] call player_update_warrants;
			};
	};

player groupChat format["Unlocking fortification..."];

format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", player] call broadcast;
SleepWait(10)

if ([player, _object] call R3F_LOG_FNCT_LOCKCHECK) exitwith {
		player groupChat format["fortification unlock failed."];
	};
	
player groupChat format["Fortification unlocked."];
	
_object setVariable ["lockedDown", false, true];
_object setVariable ["copLocked", isCop, true];