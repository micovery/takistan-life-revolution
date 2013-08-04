#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_object"];

_object = _this select 0;

player groupChat "Locking Fortification Down.";

format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", player] call broadcast;
SleepWait(10)

if ([player, _object] call R3F_LOG_FNCT_LOCKCHECK) exitwith {
			player groupChat format["fortification lock failed %1 - %2 - %3 - %4.", (!(alive player)), (player getVariable ["isstunned", false]), (player getVariable ["restrained", false]), ((player distance _object) <= 15)];
		};
		
player groupChat "Fortification Locked.";

_object setVariable ["lockedDown", true, true];
_object setVariable ["copLocked", isCop, true];