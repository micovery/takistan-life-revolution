_action = _this select 0;

if (_action == "created") then {
	["respawn", (_this select 1), -1, 120, ""] execVM "vehdespawn.sqf";
};

if ((_action == "respawn") and (isServer)) then {
	_vcl        = _this select 1;
	_spawnTime  = _this select 2;
	_deletewait = _this select 3;
	_vclname    = _this select 4;
	_vcltype    = typeOf(_vcl);
	_spawnpos   = getpos(_vcl);
	_spawndir   = getdir(_vcl);
	_idlepos    = _spawnpos;
	_exit       = false;
	_idle       = 0;
	_deletewait = 30;

	while { (alive _vcl) && (!isnull _vcl)} do {		
		if (_idle >= (INV_inactive_vcl_maxtime*60)) then {						
			{if (_vcl in (list _x)) then {_idle = 0};} forEach INV_VehicleGaragen;
							
			if (_idle > (INV_inactive_vcl_maxtime*60)) then {
				_exit = true;
			};
		};

		if (_exit) exitWith {};

		sleep 1;

		if ( (_vcl distance _idlepos <= 10) and (count(crew _vcl) == 0) ) then {
			_idle = _idle + 1;
		} 
		else {
			_idlepos = (getpos _vcl);
			_idle = 0;
		};
	};

	if (isNil "_vcl") exitWith {};
	if(isNull _vcl) exitWith {};
	{_x Action ["eject", _vcl];} forEach (crew (_vcl));
	if (!alive _vcl) then {
		sleep _deletewait;
	};
	call compile format ["if (!(isNil ""%1"")) then {%1 = []; PublicVariable ""%1"";};", ([_vcl] call vehicle_storage_name)];
	clearVehicleInit _vcl;
	call compile format["%1 = nil;", _vcl];
	deleteVehicle _vcl;
};