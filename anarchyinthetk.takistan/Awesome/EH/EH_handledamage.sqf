private["_unit", "_select", "_damage", "_source", "_projectile"];
_unit 			= _this select 0;
_select			= _this select 1;
_damage			= _this select 2;
_source			= _this select 3;
_projectile		= _this select 4;


private["_distance"];
_distance 		= 0;


if( ((_unit distance getmarkerpos "respawn_west" < 100))  || 
	((_unit distance getmarkerpos "respawn_east" < 100)) || 
	((_unit distance getmarkerpos "respawn_guerrila" < 100)) || 
	(_unit distance getmarkerpos "respawn_civilian" < 100)
	) exitwith {};


private["_exit"];
_exit = false;

{
	private["_y"];
	_y = _x select 5;
	if ((_unit distance (getPosATL _y)) <= 10) then {_exit = true;};
} forEach Clothing_Shops;

if !_exit then {
		_exit = [_unit] call player_get_arrest;
	};

if _exit exitwith {};



private["_nvcls"];
_nvcls = nearestObjects [getpos _unit, ["LandVehicle"], 5];

private["_veh","_inveh", "_reduce"];
_reduce = false;

private["_source_cop", "_weapon"];
_source_cop = ([_source] call player_cop);
_weapon = currentWeapon _source;

if (_projectile == "B_9x19_SD") then {
	sleep 1;
	if ( (((_weapon == "M9") || (_weapon == "M9SD")) && _source_cop) ) then {
		_reduce = true;
		_distance = _source distance _unit;
		_veh = vehicle _unit;
		_inveh = ( (_veh iskindof "ATV_Base_EP1") ||  (_veh iskindof "Motorcycle") );	
		[_unit, _source, _distance, _select, _damage, _veh, _inveh] spawn stun_gun_impact;
	};
};

if ((_projectile == "B_12Gauge_74Slug") ) then {
	sleep 1;
	if ( ((_weapon == "M1014") && _source_cop) ) then {	
		_reduce = true;
		_distance = _source distance _unit;
		_veh = vehicle _unit;
		_inveh = ( (_veh iskindof "ATV_Base_EP1") ||  (_veh iskindof "Motorcycle") );	
		[_unit, _source, _distance, _select, _damage, _veh, _inveh] spawn stun_gun_impact;
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