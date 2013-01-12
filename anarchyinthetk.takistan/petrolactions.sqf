
petrol_refuel_tank = {
	private ["_fuel", "_fuelstartposition", "_liter_price"];
	
	_liter_price = _this select 0;
	if (isNil "_liter_price") exitWith {};
	if (typeName _liter_price != "SCALAR") exitWith {};
	
	_fuel = fuel (vehicle player);
	_fuelstartposition = getpos(vehicle player);

	private["_liters_consumed", "_refuel_cost", "_vehicle"];
	_liters_consumed = 0;
	_refuel_cost = 0;
	_vehicle = vehicle player;
	
	[_vehicle, true] call petrol_set_refueling;
	call petrol_remove_refuel_action;
	
	while {((fuel _vehicle) < 0.99)} do {
		private["_cvehicle", "_next_cost", "_player_money"];
		_next_cost = round((_liters_consumed + fuel_pump_rate) * _liter_price);
		_player_money = ([player, 'money'] call INV_GetItemAmount);
		if (_player_money < _next_cost ) exitWith {
			player groupChat "You don't have enough money to refuel the vehicle completely.";
		};

		_cvehicle = vehicle player;
	
		if (_vehicle != _cvehicle) exitWith {
			player groupChat "Stay inside the car while you are refueling it";
		};

		if (_vehicle distance _fuelstartposition > 3) exitWith {
			player groupChat "You cancelled the refuel-action by moving your vehicle";
		};
		
		private["_i"];
		_i = 0;
		while { _i < fuel_pump_rate && ((fuel _vehicle) < 0.99)} do {
			_vehicle setFuel ((fuel _vehicle) + 0.01);
			_liters_consumed = _liters_consumed + 1;
			_i = _i + 1;
		};
		
		titleText [ format["Refueling %1%2 ...", round(fuel _vehicle * 100), "%"], "PLAIN DOWN"];
		sleep 1;
	};
	
	call petrol_remove_refuel_action;
	[_vehicle, false] call petrol_set_refueling;
	
	if (_liters_consumed > 0) then {
		
		_refuel_cost = round((_liters_consumed * _liter_price));
		_percent_refueled =  round(fuel _vehicle * 100);
		titleText[format["Your total refueling cost was $%1, your vehicle is now %2%3 full.", _refuel_cost, _percent_refueled, "%"], "PLAIN DOWN"];
		[_liters_consumed] call shop_update_fuel_consumed;
		[player, 'money', -(_refuel_cost)] call INV_AddInventoryItem;
	};
};

petrol_set_refueling = {
	private["_vehicle", "_state"];
	
	_vehicle = _this select 0;
	_state = _this select 1;
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_state") exitWith {};
	if (typeName _state != "BOOL") exitWith {};
	
	_vehicle setVariable ["refueling", _state];
	
};

petrol_get_refueling = {
	private["_vehicle", "_state"];
	
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {};
	
	_state = _vehicle getVariable "refueling";
	if (isNil "_state") exitWith { false };
	if (typeName _state != "BOOL") exitWith { false };
	_state
};

petrol_get_nearest_station = {
	private["_distance", "_station"];
	
	_max_distance = _this select 0;
	_station = nil;
	_distance = -1;
	
	{
		private["_cdistance", "_cstation"];
		_cstation = _x;
		_cdistance  = (player distance _cstation);
	
		if (_distance < 0 || _cdistance <= _distance) then {
			_distance = _cdistance;
			_station = _cstation;
		};	
	} foreach GasStationArray;
	
	
	if (_distance > _max_distance) exitWith { nil };
	_station
};


petrol_get_refuel_vehicle = {
	private["_vehicle"];
	_vehicle = player getVariable "refuel_vehicle";
	_vehicle
};


petrol_get_refuel_action = {
	private["_vehicle"];
	_vehicle = call petrol_get_refuel_vehicle;
	if (isNil "_vehicle") exitWith {-1};
	_refuel_action = _vehicle getVariable "refuel_action";
	_refuel_action = if (isNil "_refuel_action") then { -1 } else { _refuel_action };
	_refuel_action
};

petrol_set_refuel_action = {
	private["_action"];
	_vehicle = _this select 0;
	_action = _this select 1;
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_action") exitWith {};
	if (typeName _action != "SCALAR") exitWith{};

	_vehicle setVariable ["refuel_action", _action];
	player setVariable ["refuel_vehicle", _vehicle];
};

petrol_add_refuel_action = {
	private["_liter_price", "_refuel_cost", "_liters_missing",  "_vehicle"];
	
	_vehicle  = vehicle player;
	_liter_price = call shop_get_fuel_price;
	_liters_missing = round((1 - (fuel _vehicle)) * 100);
	_refuel_cost = round(_liters_missing *  _liter_price);
	
	if (_refuel_cost <= 0) exitWith {};
	if (([_vehicle] call petrol_get_refueling)) exitWith {};
	
	
	_refuel_action = _vehicle addAction [format["Fill gas tank for $%1", _refuel_cost], "noscript.sqf", format["[%1] call petrol_refuel_tank", _liter_price], 1];
	
	[_vehicle, _refuel_action] call petrol_set_refuel_action;
	
};

petrol_remove_refuel_action = {
		private["_vehicle"];
		

		_vehicle = call petrol_get_refuel_vehicle;
		if (isNil "_vehicle") exitWith {};
		_refuel_action = call petrol_get_refuel_action;
		if (_refuel_action < 0) exitWith {};
		
		_vehicle removeAction _refuel_action;
		[_vehicle, -1] call petrol_set_refuel_action;
};


petrol_check_actions = {
	private["_vehicle", "_station", "_refuel_action"];
	
	_vehicle  = vehicle player;
	_station = [16] call petrol_get_nearest_station;
	_isDriver = (_vehicle != player) && ((driver _vehicle) == player);
	_isNearStation = (_isDriver && not(isNil "_station"));
	
	_refuel_action = call petrol_get_refuel_action;
	
	if (_isNearStation && _refuel_action < 0 ) then {
		call petrol_add_refuel_action;
	} 
	else { if (not(_isNearStation) && _refuel_action >= 0) then {
		call petrol_remove_refuel_action;
	};};
};

petrol_actions_loop = {
	{_x setFuelCargo 0} foreach (nearestobjects [getpos copbase1, ["Land_Ind_FuelStation_Feed_Ep1"], 6000]);
	_count = count GasStationArray;
	while {true} do {
		call petrol_check_actions;
		sleep 3;
	};
};

[] spawn petrol_actions_loop;