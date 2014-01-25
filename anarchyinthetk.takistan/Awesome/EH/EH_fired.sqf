// fired event handler script
// EH_fired.sqf
private["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
_unit 			= _this select 0;
_weapon			= _this select 1;
_muzzle			= _this select 2;
_mode			= _this select 3;
_ammo			= _this select 4;
_magazine		= _this select 5;
_projectile		= _this select 6;

///////////////
// Distance checks
///////////////

/*
_bullet = nearestObject  [getpos player, _ammo];
*/

afkTime = time;
lastShot = time;

if (_unit distance (getmarkerpos "respawn_west") < 80) exitwith {
		deletevehicle _projectile;
		if (firestrikes == 0) exitwith {
			[player] call player_reset_gear;
			firestrikes = 3;
		};
		
		firestrikes = firestrikes - 1;
		format['hint "WARNING %1: DO NOT FIRE INSIDE THE COPBASE! %2/%3 chances left.";', name _unit, firestrikes, totalstrikes] call broadcast;
		
	};
	
if ( ((_unit distance (getmarkerpos "respawn_civilian")) < 130) ) exitwith {
		deleteVehicle _projectile;
		if (firestrikes == 0) exitwith {
			[player] call player_reset_gear;
			firestrikes = 3;
		};
		
		firestrikes = firestrikes - 1;
		format['hint "WARNING %1: DO NOT FIRE INSIDE THE CIVILIAN SPAWN! %2/%3 chances left.";', name _unit, firestrikes, totalstrikes] call broadcast;
	};

if ( 
		((_unit distance (getmarkerpos "respawn_east")) < 100) 
		|| ((_unit distance (getmarkerpos "respawn_guerrila")) < 100)
	) exitwith {
		deletevehicle _projectile;
	};

///////////////
// STUN EFFECTS
///////////////

if (
		((_magazine == "15Rnd_9x19_M9SD") && ((_weapon == "M9") || (_weapon == "M9SD")))
		|| ((_magazine == "8Rnd_B_Beneli_74Slug") && (_weapon == "M1014"))
	) then {
		[_unit] spawn stun_tazer;	
	};

///////////////
// Tear Gas
///////////////
if ((toLower _ammo) in ["smokeshell", "g_40mm_smoke"]) then {
		if (!isNull _projectile) then {
				[_projectile, _ammo] spawn Tear_gas;
			};
	};
