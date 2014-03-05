// fired event handler script
// EH_fired_vehicle.sqf
private["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
_unit 			= _this select 0;
_weapon			= _this select 1;
_muzzle			= _this select 2;
_mode			= _this select 3;
_ammo			= _this select 4;
_magazine		= _this select 5;
_projectile		= _this select 6;

// Distance checks
if (
		(_unit distance (getmarkerpos "respawn_west") < 100)
		|| (_unit distance (getmarkerpos "respawn_east") < 100)
		|| (_unit distance (getmarkerpos "respawn_guerrila") < 100)
		|| (_unit distance (getmarkerpos "respawn_civilian") < 100)
	) then {
		deleteVehicle _projectile;
	};
	













	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	