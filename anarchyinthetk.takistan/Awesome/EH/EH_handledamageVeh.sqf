private["_unit", "_select", "_damage", "_source", "_projectile"];
_unit 			= _this select 0;
_select			= _this select 1;
_damage			= _this select 2;
_source			= _this select 3;
_projectile		= _this select 4;

if( ((_unit distance (getmarkerpos "respawn_west")) < 120) || 
	((_unit distance (getmarkerpos "respawn_east")) < 100) || 
	((_unit distance (getmarkerpos "respawn_guerrila")) < 100) || 
	((_unit distance (getmarkerpos "respawn_civilian")) < 130)
	) then {
		0
	}else{
		_this select 2
	};

	