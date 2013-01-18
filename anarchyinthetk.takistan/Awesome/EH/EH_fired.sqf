// fired event handler script
// EH_fired.sqf

_unit 			= _this select 0;
_weapon			= _this select 1;
_muzzle			= _this select 2;
_mode			= _this select 3;
_ammo			= _this select 4;
_magazine		= _this select 5;
_projectile		= _this select 6;

liafu = true;

///////////////
// Distance checks
///////////////

_bullet = nearestObject  [getpos player, _ammo];

if (_unit distance (getmarkerpos "respawn_west") < 100) exitwith {
	
		deletevehicle _bullet;
	
		if (firestrikes == 0) exitwith {
			[player] call player_reset_gear;
			firestrikes = 3;
		};
		
		firestrikes = firestrikes - 1;
		format['hint "WARNING %1: DO NOT FIRE INSIDE THE COPBASE! %2/%3 chances left.";', name _unit, firestrikes, totalstrikes] call broadcast;
		
	};
	
if ( ((_unit distance (getmarkerpos "respawn_civilian")) < 130) ) exitwith {
		deleteVehicle _bullet;
		if (firestrikes == 0) exitwith {
			[player] call player_reset_gear;
			firestrikes = 3;
		};
		
		firestrikes = firestrikes - 1;
		format['hint "WARNING %1: DO NOT FIRE INSIDE THE CIVILIAN SPAWN! %2/%3 chances left.";', name _unit, firestrikes, totalstrikes] call broadcast;
		
	};

if ( ((_unit distance (getmarkerpos "respawn_east")) < 100) ) exitwith {
		deletevehicle _bullet;
	};
	
if ( ((_unit distance (getmarkerpos "respawn_guerrila")) < 100) ) exitwith {
		deletevehicle _bullet;
	};

///////////////
// STUN EFFECTS
///////////////

if ((_magazine == "15Rnd_9x19_M9SD") && ((_weapon == "M9") || (_weapon == "M9SD"))) then {
		[1, _unit] execVM "Awesome\Scripts\Stun.sqf"; 		
	};

if ((_magazine == "8Rnd_B_Beneli_74Slug") && (_weapon == "M1014")) then {
		[1, _unit] execVM "Awesome\Scripts\Stun.sqf"; 		
	};

///////////////
// Tear Gas
///////////////
[_this, _bullet] execVM "Awesome\Scripts\Smoke.sqf";