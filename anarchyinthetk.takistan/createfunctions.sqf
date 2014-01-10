INV_CreateGunboxLocal = {};

INV_CreateFort = {
	_this spawn {
		private ["_class", "_kind", "_logic", "_vehicle", "_vehicle_name"];
		_logic = _this select 0;
		_class = _this select 1;
		_kind = _this select 2;	
		if (not(alive player)) exitWith {};
		_vehicle = createVehicle [_class, (getPosATL _logic), [], 0, "NONE"];
		
		switch _kind do {
			case "Static" do {
				_vehicle_name = format["%1_%2_%3", _kind, player, round(time)];
				_vehicle setVehicleInit format[
				'
				this setVehicleVarName "%1";
				%1 = this;
				this lock false;', _vehicle_name];
				processInitCommands;				
			};
			case "Fort" do {};
			case "Box" do {
				clearBackpackCargoGlobal _vehicle;
				clearMagazineCargoGlobal _vehicle;
				clearWeaponCargoGlobal _vehicle;
			};
		};
	};
};

INV_CreateWeapon = {
	private["_class", "_amount", "_crate"];
	_class = _this select 0;
	_amount = _this select 1;
	_crate = _this select 2;
	_in_hands = if (count _this > 3) then { _this select 3 } else { false };
	
	if (_in_hands) then {
		player addWeapon _class;
		player action ["switchweapon", player, player, 0];
	}
	else {
		_crate addweaponCargoGlobal [_class,_amount];
	};
};

INV_CreateMag = {
	private["_class", "_amount", "_crate"];
	_class = _this select 0;
	_amount = _this select 1;
	_crate = _this select 2;

	_crate addmagazineCargoGlobal [_class,_amount];

};

INV_CreatePack = {
	private["_class", "_amount", "_crate"];
	_class = _this select 0;
	_amount = _this select 1;
	_crate = _this select 2;
	_in_hands = if (count _this > 3) then { _this select 3 } else { false };
	

	if (_in_hands) then {
		player addBackpack _class;
	}
	else {
		_crate addBackpackCargoGlobal [_class, _amount];
	};
	
	//remove the backpack's contents 
	[] spawn {
		sleep 1;
		private["_backpack"];
		_backpack = unitBackpack player;
		if (isNil "_backpack") exitWith {};
		clearWeaponCargoGlobal _backpack;
		clearMagazineCargoGlobal _backpack;
	};
};


INV_CreateItem = {
	private["_object", "_class", "_amount", "_storage"];
	_object = _this select 0;
	_class = _this select 1;
	_amount = _this select 2;
	_storage = _this select 3;
	[_object, _class, _amount, _storage] call INV_AddItemStorage;
};

INV_IsPlayerVehicle = {
	private["_isPlayerVehicle", "_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith { false };
	
	_isPlayerVehicle = _vehicle getVariable "isPlayerVehicle";
	if (isNil "_isPlayerVehicle") exitWith { false };
	if (typeName _isPlayerVehicle != "BOOL") exitWith { false };
	_isPlayerVehicle
};

INV_LocateClosestVehicle = {
	private["_i", "_list", "_vehicle", "_distance"];
	_distance = _this select 0;
	if (isNil "_distance") exitWith {nil};
	if (typeName _distance != "SCALAR") exitWith { nil };
	
	_list = nearestObjects [player, ["LandVehicle", "Air"], _distance];
	//player groupChat format["_list = %1", _list];
	_i = (count _list - 1);
	_vehicle = nil;
	while { _i >= 0 } do {
		private["_current", "_found"];
		_current = _list select _i;
		//player groupChat format["_current = %1", _current];
		if (alive(_current) && ([_current] call INV_IsPlayerVehicle)) then {
			_vehicle = _current;
		};
		_i = _i - 1;
	};
	
	_vehicle
};