
getCW_class = {
	private ["_unit", "_current"];
	_unit = _this select 0;
	_current = currentWeapon _unit;
	([_current] call getClass)
};


getClass = {
	private ["_class"];

	_class	= _this select 0;
	if ([_class] call isPistol_class) exitWith { "pistol" };
	if ([_class] call isRifle_class) exitWith { "rifle" };
	if ([_class] call isMG_class) exitWith { "MG" };
	if ([_class] call isLauncher_class) exitWith { "launcher" };
	if ([_class] call isThrow_class) exitWith { "throw" };
	if ([_class] call isPut_class) exitWith { "put" };
	"none"
};

gear_get_weapon_class_type = {
	private["_class"];
	_class = _this select 0;
	if (isNil "_class") exitWith {-1};
	if (typeName _class != "STRING") exitWith {-1};
	
	private["_type"];
	_type = getNumber(configFile >> "CfgWeapons" >> _class >> "type");
	
	if (isNil "_type") exitWith {-1};
	if (typeName _type != "SCALAR") exitWith {-1};
	_type
};

PISTOL_CLASS_TYPE = 2;
isPistol_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == PISTOL_CLASS_TYPE)
};

RIFLE_CLASS_TYPE = 1;
isRifle_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == RIFLE_CLASS_TYPE)
};

LAUNCHER_CLASS_TYPE = 4;
isLauncher_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == LAUNCHER_CLASS_TYPE)
};

MG_CLASS_TYPE = 5;
isMG_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == MG_CLASS_TYPE)
};

THROW_CLASS_TYPE = 256;
isThrow_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == THROW_CLASS_TYPE)
};

PUT_CLASS_TYPE = 512;
isPut_class = {
	private ["_class"];
	_class = _this select 0;
	(([_class] call gear_get_weapon_class_type) == PUT_CLASS_TYPE)
};