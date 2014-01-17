if (!(isNil "armoredsuv_functions")) exitWith {};

armored_suv_close_minigun =
{
	private["_vehicle"];
	_vehicle = _this select 0;
	_vehicle animate["HideGun_01",1];
	_vehicle animate["HideGun_02",1];
	_vehicle animate["HideGun_03",1];
	_vehicle animate["HideGun_04",1];
	_vehicle animate["CloseCover1",1];
	_vehicle animate["CloseCover2",1];
	_vehicle setVariable ["minigun_open", false, true];
};

armored_suv_open_minigun =
{
	private["_vehicle"];
	_vehicle = _this select 0;
	_vehicle animate["HideGun_01",0];
	_vehicle animate["HideGun_02",0];
	_vehicle animate["HideGun_03",0];
	_vehicle animate["HideGun_04",0];
	_vehicle animate["CloseCover1",0];
	_vehicle animate["CloseCover2",0];
	_vehicle setVariable ["minigun_open", true, true];
};

armored_suv_is_minigun_open =
{
	private["_vehicle","_is_minigun_open"];
	_vehicle = _this select 0;
	_is_minigun_open = _vehicle getVariable "minigun_open";
	if (isNil "_is_minigun_open") exitWith { false };
	if (typeName _is_minigun_open != "BOOL") exitWith { false };
	_is_minigun_open
};

armored_suv_add_actions = 
{
	private["_vehicle"];
	_vehicle = _this select 0;
	
	private ["_has_suv_actions"];
	
	_has_suv_actions = _vehicle getVariable "has_suv_actions";
	if (isNil "_has_suv_actions") then { _has_suv_actions = false;}; 
	if (_has_suv_actions) exitWith {};
	
//	player groupChat format["Adding SUV Actions"];
	_vehicle addaction ["Open Minigun","noscript.sqf",'[_this select 0] call armored_suv_open_minigun;',1,false,true,"","([player, _target] call vehicle_owner) && !([_target] call armored_suv_is_minigun_open)"];
	_vehicle addaction ["Close Minigun","noscript.sqf",'[_this select 0] call armored_suv_close_minigun;',1,false,true,"","([player, _target] call vehicle_owner) && ([_target] call armored_suv_is_minigun_open)"];
	
	_has_suv_actions = true;
	_vehicle setVariable ["has_suv_actions", _has_suv_actions];
};

armoredsuv_functions = true;
