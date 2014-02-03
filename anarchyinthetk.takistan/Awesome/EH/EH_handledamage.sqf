private["_unit", "_select", "_damage", "_source", "_projectile", "_distance", "_nvcls","_veh","_inveh", "_reduce","_source_cop", "_weapon", "_exit"];
_unit 			= _this select 0;
_select			= _this select 1;
_damage			= _this select 2;
_source			= _this select 3;
_projectile		= _this select 4;


_distance 		= 0;


format['EH_handleDamage: Starting, %1', _this] call A_DEBUG_S;

if( ((_unit distance getmarkerpos "respawn_west" < 100))  || 
	((_unit distance getmarkerpos "respawn_east" < 100)) || 
	((_unit distance getmarkerpos "respawn_guerrila" < 100)) || 
	(_unit distance getmarkerpos "respawn_civilian" < 100)
	) exitwith {
		format['EH_handleDamage: Exit 1'] call A_DEBUG_S;
	};

_exit = false;

{
	private["_y"];
	_y = _x select 5;
	if ((_unit distance (getPosATL _y)) <= 10) then {_exit = true; format['EH_handleDamage: Exit 2'] call A_DEBUG_S;};
} forEach Clothing_Shops;

if !_exit then {
	_exit = if isCop then {
		 [_unit, "roeprison"] call player_get_bool
	}else{
		[_unit] call player_get_arrest
	};
	
	if _exit then {
		format['EH_handleDamage: Exit 3'] call A_DEBUG_S;
	};
};

if _exit exitwith {
	format['EH_handleDamage: Exit Passed'] call A_DEBUG_S;
};

format['EH_handleDamage: Exit Checks passed'] call A_DEBUG_S;


_nvcls = nearestObjects [getPosATL _unit, ["LandVehicle"], 5];

_reduce = false;

_source_cop = [_source] call player_cop;
_weapon = currentWeapon _source;

if (_projectile == "B_9x19_SD") then {
	if ( (((_weapon == "M9") || (_weapon == "M9SD")) && _source_cop) ) then {
		_reduce = true;
		_distance = _source distance _unit;
		_mounted = false;
		_veh = vehicle _unit;
		if (_veh == _unit) then {
			if !(isNull ([_unit] call mounted_player_get_vehicle)) then {
				_veh = [_unit] call mounted_player_get_vehicle;
				_mounted = true;
			};
		};
		_inveh = ((_veh iskindof "ATV_Base_EP1") ||  (_veh iskindof "Motorcycle")) || _mounted;	
		[_unit, _source, _distance, _select, _damage, _veh, _inveh, _mounted] spawn stun_gun_impact;
	};
};

if (_projectile == "B_12Gauge_74Slug") then {
	if ( ((_weapon == "M1014") && _source_cop) ) then {	
		_reduce = true;
		_distance = _source distance _unit;
		_mounted = false;
		_veh = vehicle _unit;
		if (_veh == _unit) then {
			if !(isNull ([_unit] call mounted_player_get_vehicle)) then {
				_veh = [_unit] call mounted_player_get_vehicle;
				_mounted = true;
			};
		};
		_inveh = ((_veh iskindof "ATV_Base_EP1") ||  (_veh iskindof "Motorcycle")) || _mounted;	
		[_unit, _source, _distance, _select, _damage, _veh, _inveh, _mounted] spawn stun_gun_impact;
	};
};
	
[_select,_damage,_source, _unit, _nvcls, _reduce] spawn {
	private["_select", "_damage", "_shooter", "_unit", "_nvcls", "_reduce"];
	_select		= _this select 0;
	_damage		= _this select 1;
	_shooter	= _this select 2;
	_unit		= _this select 3;
	_nvcls		= _this select 4;
	_reduce		= _this select 5;
	
	if (_reduce) then {
		_damage = _damage * 0.25;
	};
	
	_unit SetHit [_select, _damage];
	_unit setVariable [_select, _damage, true];

	if(_select == "" and _damage >= 1 and !isnull _shooter) then {
		_unit setdamage 1;
	};

	//player groupChat format["EH: %1, %2", _this, (alive _unit)];
	if (alive _unit) exitWith {};
	[_shooter, _unit] call victim;
};