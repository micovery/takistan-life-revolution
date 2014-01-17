private["_action"];
_action = _this select 0;

if (_action == 1) then {
	private ["_unit"];
	_unit = _this select 1;
	if !(alive _unit) exitwith {};
	if(not(isCop)) exitWith {};
	if (((currentWeapon _unit) == "M9") || ((currentWeapon _unit) == "M9SD")) then {
		format["%1 say ""tazer"";", _unit] call broadcast;
	};
};
	
if (_action == 2) then {
	private ["_unit", "_shooter", "_distance", "_selection", "_damage", "_veh", "_inveh", "_armor", "_pass"];

	_unit = _this select 1;
	_shooter = _this select 2;
	_distance = _this select 3;
	_selection = _this select 4;
	_damage = _this select 5;
	_veh = _this select 6;
	_inveh = _this select 7;
	
	if !(alive _unit) exitwith {};
	
	if (_unit distance getMarkerpos "respawn_west" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_east" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_guerrila" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_civilian" < 100) exitwith {};

	_armor = _unit getvariable "stun_armor";
	
	_pass = [];
	_pass = [_unit, _shooter, _selection, _damage, _armor, _veh, _inveh, _distance];
	
	if (_selection == "") exitwith {};
	if (_damage < 0.1) exitwith {};
	
	private["_is_shotgun"];
	_is_shotgun = ((currentWeapon _shooter) == ("M1014"));
	
	if ( _is_shotgun && _distance <= 50 ) then {
		_pass spawn stun_shot_close;
	} else { if (_is_shotgun && (_distance > 50) && (_distance <= 100)) then {
		_pass spawn stun_shot_far;	
	} else { if (_distance <= 5) then {
		_pass spawn stun_shot_close;
	} else { if ((_distance <= 15) && (_distance > 5)) then {
		_pass spawn stun_shot_far;			
	};};};};
};

if (_action == 3) then {
	private ["_unit", "_man", "_men", "_currentw", "_exit", "_y"];

	_unit = _this select 1;
	
	if !(alive _unit) exitwith {};
	
	if (_unit distance getMarkerpos "respawn_west" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_east" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_guerrila" < 100) exitwith {};
	if (_unit distance getMarkerpos "respawn_civilian" < 100) exitwith {};
	
	_currentw	= [_unit] call getCW_class;
	
	_men = nearestobjects [getpos _unit, ["CAManBase"], 3] - [_unit];
	
	if ((count _men) == 0) exitwith {};
	
	_man = _men select 0;
	
	if (isNull _man) exitwith {};
	if ((_man in shopusearray) || (_man == bailflag)) exitWith {};
	
	_exit = false;
	
	{
		_y = _x select 5;
		if ((_unit distance (getPosATL _y)) <= 10) then {_exit = true;};
	} forEach Clothing_Shops;
	
	if (_unit in (list Jail)) then {_exit = true;};
	
	if (_exit) exitWith {};
	
	if ((_currentw == "none") || (_currentw == "throw") || (_currentw == "put")	) exitWith {
		[_unit, _man] spawn stun_hands;
	};
	
	if (_currentw == "pistol") exitWith {
		[_unit, _man] spawn stun_pistol;
	};
		
	if ((_currentw == "rifle") || (_currentw == "MG")	) exitWith {
		[_unit, _man] spawn stun_rifle;	
	};
};