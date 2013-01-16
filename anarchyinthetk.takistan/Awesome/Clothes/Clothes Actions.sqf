
C_change_original = {
	if (!(C_haschanged)) exitwith {player groupchat "You are already in your original clothes";};
	private ["_class"];
	
	_class = C_original_c;
	[player, _class, false] spawn C_change;
	closeDialog 0;
};

// Called for just buying the clothes instead of buying and switching
C_shop_buy = {
	private ["_c_array", "_moneh", "_side", "_exit", "_c_name", "_c_class", "_c_display", "_c_side", "_c_fac", "_c_bool", "_c_cost", "_c_lic", "_i", "_license", "_haslic_i"];

	
	_c_array = _this select 0;
	
	_moneh = [player, "money"] call INV_GetItemAmount; 
	_side = C_Side;
	_exit = false;
	C_change_fail = false;
	
	_c_name 	= _c_array select 0;
	_c_class	= _c_array select 1;
	_c_display 	= _c_array select 2;
	_c_side 	= _c_array select 3;
	_c_fac		= _c_array select 4;
	_c_bool 	= _c_array select 5;
	_c_cost 	= _c_array select 6;
	_c_lic 		= _c_array select 7;
	
	if (!((C_Side == _c_side) && (_c_bool))) then {
		player groupchat "C shop buy 1";
		player groupchat format["These clothes are not for your side: %1", C_Side];
		_exit = true;
	};

	for [{_i = 0}, {_i < count _c_lic}, {_i = _i + 1}] do {
		_license = (_c_lic select _i);
		_haslic_i = _license call INV_HasLicense;
		
		if (!(_haslic_i)) then {
			player groupchat format ['You require the license: %1',(_license call INV_GetLicenseName)];
			_exit = true;
		};	
	};
	

	if (_moneh < _c_cost) then {
		_exit = true;
		call compile format ['player groupchat "You do not have enough money (Required: $%1)";', _c_cost];
	} else { if (!(_exit)) then {
		[player, "money", -(_c_cost)] call INV_AddInventoryItem;
		player groupchat format ['You bought: %1 for $%2', _c_display, _c_cost];
	};};

	if (_exit) exitwith {};
	
	if (not(_c_name in C_storage)) then {
		C_storage set [count C_storage, _c_name];
		call compile format ['C_storage_%1 set [count C_storage_%1, _c_name];', _side];
	};
	
};

// called for the switch from a shop action, sets up everything then calls the C_change function
C_change_shop = {
	private ["_c_array", "_moneh", "_side", "_exit", "_c_name", "_c_class", "_c_display", "_c_side", "_c_fac", "_c_bool", "_c_cost", "_c_lic", "_i", "_license", "_haslic_i"];

	
	_c_array = _this select 0;
	_shopnum = C_shopnum;
	
	_moneh = [player, "money"] call INV_GetItemAmount; 
	_side = C_Side;
	_exit = false;
	C_change_fail = false;
	
	_c_name 	= _c_array select 0;
	_c_class	= _c_array select 1;
	_c_display 	= _c_array select 2;
	_c_side 	= _c_array select 3;
	_c_fac		= _c_array select 4;
	_c_bool 	= _c_array select 5;
	_c_cost 	= _c_array select 6;
	_c_lic 		= _c_array select 7;
	
	//player groupChat format["_c_cost = %1", _c_cost];
	
	
	if (not((C_Side == _c_side) && (_c_bool))) then {
		player groupchat format["These clothes are not for your side: %1", C_Side];
		_exit = true;
	};

	for [{_i = 0}, {_i < count _c_lic}, {_i = _i + 1}] do {
		_license = (_c_lic select _i);
		_haslic_i = _license call INV_HasLicense;
			
		if (!(_haslic_i)) then {
			player groupchat format ['You require the license: %1',(_license call INV_GetLicenseName)];
			_exit = true;
		};	
	};
	

	if (_moneh < _c_cost) then {
		_exit = true;
		call compile format ['player groupchat "You do not have enough money (Required: $%1)";', _c_cost];
	} else { if (!(_exit)) then {
		[player, "money", -(_c_cost)] call INV_AddInventoryItem;
		player groupchat format ['You bought: %1 for $%2', _c_display, _c_cost];
	};};


	if (_exit) exitwith {};
	
	
	if (!(_c_name in C_storage)) then {
		C_storage set [count C_storage, _c_name];
		call compile format ['C_storage_%1 set [count C_storage_%1, _c_name];', _side];
	};
	
	closeDialog 0;
	[player, _c_class, false] spawn C_change;
	
	sleep 3;
	if (C_change_fail) then {
		player groupchat "Switch failed, check your storage to attempt to switch again";
	};
};

// called for the switch from a storage action, sets up everything then calls the C_change function
C_change_storage = {
	private ["_c_array", "_side", "_exit", "_c_name", "_c_class", "_c_side", "_c_fac", "_c_bool", "_c_cost", "_c_lic","_i", "_license", "_haslic_i"];

	_c_array = _this select 0;
	
	_side = C_Side;
	_exit = false;
	
	_c_name = _c_array select 0;
	_c_class = _c_array select 1;
	_c_side = _c_array select 3;
	_c_fac = _c_array select 4;
	_c_bool = _c_array select 5;
	_c_cost = _c_array select 6;
	_c_lic = _c_array select 7;
	
	
	if (!((C_Side == _c_side) && (_c_bool))) then {
		player groupchat format["These clothes are not for your side: %1", C_Side];
		_exit = true;
	};

	for [{_i = 0}, {_i < count _c_lic}, {_i = _i + 1}] do {
		_license = (_c_lic select _i);
		_haslic_i = _license call INV_HasLicense;
		
		if (!(_haslic_i)) then {
			player groupchat format ['You require the license: %1',(_license call INV_GetLicenseName)];
			_exit = true;
		};	
	};
	
	if ( (!(_c_name in C_storage)) && (_c_class != C_original_c) ) then {
		player groupchat "These clothes are not in your storage";
		_exit = true;
	};
	
	if (_exit) exitwith {};
	
	[player, _c_class, false] spawn C_change;
	closeDialog 0;
};

// Called on load
C_change_load = {
	private ["_class", "_side"];
	_side = C_Side;
	_class = _this select 0;
	([player, _class, true] call C_change)
};

// Replacing unit with new class
C_change = {
	["player_rejoin_camera_complete"] call player_wait;
	
	if (C_changing) exitwith {player groupchat "C ERROR: already changing";};
	C_changing = true;
	
	private ["_class", "_oldUnit", "_varname", "_side", "_group", "_leader", "_rating", "_score", "_rank", "_damage", "_dummyGroup", "_dummyUnit", "_newUnit", "_Gleader", "_x", "_c", "_uid", "_exit"];
	
	private["_first_time"];
	_oldUnit = _this select 0;
	_class = _this select 1;
	_first_time = _this select 2;
	_varname = vehicleVarName _oldUnit;
	
	if (not(_first_time)) then {
		titleText ["Changing Clothes", "BLACK OUT", 1];
		sleep 1.5;
	};
	
	private["_gear", "_inventory"];
	_gear = [_oldUnit] call player_get_gear;
	_inventory = [_oldUnit] call player_get_inventory;
	
	private["_position_atl", "_direction"];
	_position_atl = getPosATL _oldUnit;
	_direction = getDir _oldUnit;
	
	
	private["_failed_change"];
	_failed_change = {
		C_changing = false; 
		C_change_fail = true; 
		titleText ["Clothes - Failed", "BLACK IN", 0];
	};
	
	if (not([_oldUnit] call player_human)) exitWith { call _failed_change;};
	
	if ((_class in pmc_skin_list) && not([player] call player_pmc_whitelist)) exitWith {
		player groupchat "You cannot access PMC Shops: The police chief has not added you to the whitelist";
		call _failed_change;
	};

	if ((_class in pmc_skin_list) && ([player] call player_pmc_blacklist)) exitWith {
		player groupchat "You cannot access PMC Shops: The police chief has added you to the blacklist";
		call _failed_change;
	};
	
	_side = C_Side;
	_group = group _oldUnit;
	_leader = ((leader _oldUnit) == _oldUnit);
	_rating = rating _oldUnit;
	_score = score _oldUnit;
	_rank = rank _oldUnit;
	_damage = damage _olUnit;
	
	_sarmor = _oldUnit getVariable "stun_armor";
	_mask = _oldUnit getVariable "gasmask";
	
	_oldUnit switchCamera "INTERNAL";
	_dummyGroup = (group server);
	
	if (isNull _dummyGroup) exitWith {
		player groupchat "C ERROR: dummyGroup is null";
		C_changing = false; C_change_fail = true; 
		titleText ["Clothes - Failed", "BLACK IN", 0];
	};

	_dummyUnit = _group createUnit [_class, C_spawn, [], 0, "NONE"]; 

	if (isNull _dummyUnit) exitWith {
		player groupchat "C ERROR: dummyUnit is null";
		call _failed_change;
		[_dummyUnit] spawn C_delete;
	};

	[_oldUnit] joinSilent _dummyGroup;

	_newUnit = _dummyGroup createUnit [_class, C_spawn, [], 0, "NONE"];

	if (isNull _newUnit) exitWith {
		player groupchat "C ERROR: newUnit is null"; 
		call _failed_change;
		[_dummyUnit] spawn C_delete; 
		[_newUnit] spawn C_delete;
	};

	addSwitchableUnit _newUnit;
	[player, _newUnit] call stats_copy_variables;	
	_newUnit setRank _rank;
	_newUnit addrating _rating;
	_newUnit addscore _score;
	_newUnit setdamage _damage;
	
	_oldUnit setVehicleInit format["liafu = true; this setVehicleVarName 'old_%1'; old_%1 = this;", _varname];
	_newUnit setVehicleInit format["liafu = true; this setVehicleVarName '%1'; %1 = this;", _varname];
	processInitCommands;

	[_newUnit] call player_reset_gear;
	[_newUnit] call player_reset_side_inventory;
	[_newUnit, _gear] call player_set_gear;
	[_newUnit, _inventory] call player_set_inventory;
	_newUnit setPosATL _position_atl;
	_newUnit setDir _direction;
	_oldUnit setPos C_spawn;
	
	private["_newUnit_side"];
	_newUnit_side = ([_newUnit] call player_side);
	
	if(((count (units _group)) == 0) && (_newUnit_side != C_side))then {
		[_newUnit, _side] call C_change_side
	} else {
		[_newUnit] joinSilent _group;	
		
		private["_newUnit_side"];
		_newUnit_side = ([_newUnit] call player_side);
		
		if (_newUnit_side != C_side) then {
			_Gleader = leader _group;
			[_Gleader, C_side] call C_change_side;
			[_Gleader] joinsilent _group;
			_group selectLeader _Gleader;
		};		
	};

	//delete old unit
	[_oldUnit] spawn C_delete;
	[_dummyUnit] spawn C_delete;
	
	//set the leader
	if (_leader) then {
		(group _newUnit) selectLeader _newUnit;
	};

	if (_class == C_original_c) then {
		C_haschanged = false;
		C_haschanged_c = _class;
	} else {
		C_haschanged = true;
		C_haschanged_c = _class;
	};

	[] spawn C_save;

	if ( C_T_Change ) then {
		private["_c"];
		for [{_c = 0}, {_c < (count C_T_P) }, {_c = _c + 1}] do {
			_x = C_T_P select _c;
			if ( (typeName _x) == "STRING" ) then {
				//_newUnit setObjectTexture [_c, _x];
				//format["%1 setObjectTexture %2", _newUnit, [_c, _x]] call broadcast;
				(vehicle player) setVehicleInit format["liafu = true; this setObjectTexture %1", [_c, _x]];
				processInitCommands;
			};
		};
		C_T_Change = false;
	};
	
	C_changing = false;
	
	_newUnit addEventHandler ["fired", {_this execVM "Awesome\EH\EH_fired.sqf"}];
	_newUnit addEventHandler ["handleDamage", {_this execVM "Awesome\EH\EH_handledamage.sqf"}];
	_newUnit addEventHandler ["WeaponAssembled", {_this execVM "Awesome\EH\EH_weaponassembled.sqf"}];
	_newUnit addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
	_newUnit addMPEventHandler ["MPRespawn", { _this call player_handle_mprespawn }];
	
	_newUnit setVariable ["stun_armor", _sarmor, true];
	_newUnit setVariable ["gasmask", _mask, true];
	[_newUnit, "isstunned", false] call player_set_bool;
	role = _newUnit;

	if (not(_first_time)) then {
		titleText ["Changing Clothes", "BLACK IN", 1];
		sleep 0.5;
	};
	
	(_newUnit)
};

C_change_side = {
	private ["_unit","_newside","_newgroup"];
	_unit = _this select 0;
	_newside = _this select 1;
	
	private["_unit_side"];
	_unit_side = ([_unit] call player_side);
	
	if (_unit_side == _newside) exitWith {};
	_newgroup = createGroup _newside;
//	[format["%1 (%2, %3, %4) - C_change_side: group created %5",  round(time), player, (name player), (getPlayerUID player), _newgroup]] call l4a;
	
	[_unit] joinSilent grpNull;
	[_unit] joinSilent _newgroup;
};


// Deletes a unit
C_delete = {
	private ["_oldUnit"];
	_oldUnit = _this select 0;
	_oldUnit setPosATL [-1, -1, 0];
	_oldUnit setDamage 1;

	waituntil {(!(isPlayer _oldUnit))};
	deleteVehicle _oldUnit;
};