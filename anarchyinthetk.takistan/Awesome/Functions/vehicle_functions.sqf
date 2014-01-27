if (not(isNil "vehicle_functions_defined")) exitWith {};

#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

// --------- Set variable functions
vehicle_set_var = {
	private["_vehicle", "_variable_name", "_variable_value", "_variable_type"];

	_vehicle = _this select 0;
	_variable_name = _this select 1;
	_variable_value = _this select 2;
	_variable_type = _this select 3;
	
	[_vehicle, _variable_name, _variable_value, _variable_type, true] call vehicle_set_var_checked;
};

vehicle_set_var_checked = {
	private["_vehicle", "_variable_name", "_variable_value", "_checked", "_variable_type"];

	_vehicle = _this select 0;
	_variable_name = _this select 1;
	_variable_value = _this select 2;
	_variable_type = _this select 3;
	_checked = _this select 4;
	
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_variable_name") exitWith {};
    if (isNil "_variable_value") exitWith {};
	if (isNil "_variable_type") exitWith {};
	if (isNil "_checked") exitWith {};
	
	if (typeName _variable_name != "STRING") exitWith {};
	if (typeName _variable_type != "STRING") exitWith {};
	if (typeName _variable_value != _variable_type) exitWith {};
	if (typeName _checked != "BOOL") exitWith {};
	
	private["_current_value"];
	_current_value = [_vehicle, _variable_name, _variable_type] call vehicle_get_var;
	if(_checked && (str(_current_value) == str(_variable_value))) exitWith {};
	
	_vehicle setVariable [_variable_name, _variable_value, true];
	[_vehicle, _variable_name, _variable_value] call stats_vehicle_save;
};

vehicle_set_string = {
	_this set [3, "STRING"];
	_this call vehicle_set_var;
};

vehicle_set_string_checked = {
	private["_checked"];
	_checked = _this select 3;
	_this set [3, "STRING"];
	_this set [4, _checked];
	_this call vehicle_set_var_checked;
};

vehicle_set_array = {
	_this set [3, "ARRAY"];
	_this call vehicle_set_var;
};

vehicle_set_array_checked = {
	private["_checked"];
	_checked = _this select 3;
	_this set [3, "ARRAY"];
	_this set [4, _checked];
	_this call vehicle_set_var_checked;
};

vehicle_set_bool = {
	_this set [3, "BOOL"];
	_this call vehicle_set_var;
};

vehicle_set_scalar = {
	_this set [3, "SCALAR"];
	_this call vehicle_set_var;
};

// --- UPDATE functions 

vehicle_update_array = {
	_this set [3, "ARRAY"];
	_this call vehicle_set_var;
};

vehicle_update_bool = {
	_this set [3, "BOOL"];
	_this call vehicle_set_var;
};

vehicle_update_scalar = {
	_this set [3, "SCALAR"];
	_this call vehicle_set_var;
};

vehicle_update_string = {
	_this set [3, "STRING"];
	_this call vehicle_set_var;
};


vehicle_check_getFailure = {
		((_this select 0) == "failure")
	};

// GET functions

vehicle_get_var = {
	private["_vehicle", "_variable_name", "_variable_type", "_variable_value"];
	_vehicle = _this select 0;
	_variable_name = _this select 1;
	_variable_type = _this select 2;
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_variable_name") exitWith {};
	if (isNil "_variable_type") exitWith {};
	if ((typeName _variable_name) != "STRING") exitWith {};
	if ((typeName _variable_type) != "STRING") exitWith {};
	
	_variable_value = _vehicle getVariable _variable_name;
	_variable_value = if(isNil "_variable_value") then { "" } else { _variable_value };
	_variable_value = if ((typeName _variable_value) != _variable_type) then { "" } else { _variable_value };
	
	format['vehicle_get_var: %1-%2-%3-%4', _vehicle, _variable_name, _variable_type, _variable_value] call A_DEBUG_S;
	
	
/*	_variable_value = "failure";
	if !(isNil {_vehicle getVariable _variable_name}) then {
			_variable_value = _vehicle getVariable _variable_name;
			if ((typeName _variable_value) != _variable_type) then {
					_variable_value = "failure";
				};
		};
*/	
	
	
	
	_variable_value
};
vehicle_get_string = {
	_this set [2, "STRING"];
	(_this call vehicle_get_var)
};

vehicle_get_array = {
	_this set [2, "ARRAY"];
	(_this call vehicle_get_var)
};

vehicle_get_bool = {
	_this set [2, "BOOL"];
	(_this call vehicle_get_var)
};

vehicle_get_scalar = {
	_this set [2, "SCALAR"];
	(_this call vehicle_get_var)
};

vehicle_despawn = {
	if (not(isServer)) exitWith {};
	private["_vehicle", "_delay"];
	
	_vehicle = _this select 0;
	_delay = _this select 1;
	
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	
	if (isNil "_delay") exitWith {};
	if (typeName _delay != "SCALAR") exitWith {};
	
	[_vehicle, "saved_driver_uid", ""] call vehicle_set_string;
	[_vehicle] call vehicle_stop_track;
	
	SleepWait(_delay)
	deleteVehicle _vehicle;	
};

vehicle_unload_stats = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	
	private["_stats_uid"];
	_stats_uid = [_vehicle] call stats_get_uid;
	if (_stats_uid == "") exitWith {};
	
	[_stats_uid] call unloadPlayerVariables;
};

vehicle_stop_track = {
	private["_vehicle"];
	_vehicle = _this select 0;
	
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	[_vehicle] call vehicle_save_stats;
	[_vehicle] call vehicle_unload_stats;
	_vehicle setVariable ["track", false];
};

vehicle_track = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	
	private["_track"];
	_track = _vehicle getVariable "track";
	if (isNil "_track") exitWith {};
	if (typeName _track != "BOOL") exitWith {};
	if (not(_track)) exitWith {};
	[_vehicle] call vehicle_save_stats;
};

vehicle_start_track = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	_vehicle setVariable ["track", true, true]; 
};



vehicle_GetIn_handler = {
	private["_vehicle", "_position", "_player"];
	_vehicle = _this select 0;
	_position = _this select 1;
	_player = _this select 2;
	
	if (isServer) exitwith {_this spawn vehicle_clean_getIn};
	if (_player != player) exitWith {};
	
	if (_position == "driver") then {
		[_player] call player_save_side_vehicle;
		private["_entred_driver_uid"];
		_entred_driver_uid = ([_player] call stats_get_uid);
		_vehicle setVariable ["active_driver_uid", _entred_driver_uid, true];
		
		private["_saved_driver_uid"];
		_saved_driver_uid = [_vehicle, "saved_driver_uid"] call vehicle_get_string;
		
		if (_saved_driver_uid == _entred_driver_uid) then {
			[_vehicle, "saved_driver_uid", ""] call vehicle_set_string;
			[_vehicle] call vehicle_stop_track;
		}
		else {
			[_vehicle] call vehicle_track;
		};
		
		
	};
	
	_this spawn A_R_LOOP;
};



vehicle_GetOut_handler = {
	private["_vehicle", "_position", "_player"];
	_vehicle = _this select 0;
	_position = _this select 1;
	_player = _this select 2;
	
	if (isServer) exitwith {_this spawn vehicle_clean_getOut};
	if (_player != player) exitWith {};
	
	vehicleOut = [_vehicle, _position, _player, time];
	
	if (_position == "driver") then {
		[_player] call player_save_side_vehicle;
		_vehicle setVariable ["active_driver_uid", "", true];
		
		private["_exited_driver_uid"];
		_exited_driver_uid = [_player] call stats_get_uid;
		
		private["_saved_driver_uid"];
		_saved_driver_uid = [_vehicle, "saved_driver_uid"] call vehicle_get_string;
		
		if ((_saved_driver_uid == _exited_driver_uid)) then {
			[_vehicle, "saved_driver_uid", ""] call vehicle_set_string;
			[_vehicle] call vehicle_stop_track;
		}
		else {
			[_vehicle] call vehicle_track;
		};
		
		
	};
};

vehicle_clean_getInTimeV = "time_in";
vehicle_clean_getOutTimeV = "time_out";

vehicle_clean_getIn = {(_this select 0) setVariable [vehicle_clean_getInTimeV, time, false];};
vehicle_clean_getOut = {(_this select 0) setVariable [vehicle_clean_getOutTimeV, time, false];};

vehicle_save_gear_request_receive = {
	/*
	private["_str"];
	_str = format["vehicle_save_gear_request_receive %1", _this];
	player groupChat _str;
	diag_log _str;
	*/
	
	private["_variable", "_request"];
	_variable = _this select 0;
	_request = _this select 1;

	if (isNil "_request") exitWith {};
	if (typeName _request != "ARRAY") exitWith {};

	private["_vehicle"];
	_vehicle = _request select 0;
	private["_gear", "_weapons", "_magazines"];
	//diag_log format["getting gear for %1", _vehicle];
	_gear = [_vehicle] call vehicle_get_gear;
	if (isNil "_gear") exitWith {};
	//diag_log format["saving %1, %2", _vehicle, _gear];
	_weapons = _gear select vehicle_gear_weapons_cargo;
	_magazines = _gear select vehicle_gear_magazines_cargo;
	[_vehicle, "weapons", _weapons] call vehicle_set_array;
	[_vehicle, "magazines", _magazines] call vehicle_set_array;
};


vehicle_save_gear_setup = {
	if (not(isServer)) exitWith {};
	//player groupChat format["vehicle_save_gear_setup %1", _this];
	vehicle_side_gear_request_buffer =  " ";
	publicVariableServer "vehicle_side_gear_request_buffer";
	"vehicle_side_gear_request_buffer" addPublicVariableEventHandler { _this call vehicle_save_gear_request_receive;};
};


vehicle_save_gear = {
	private["_vehicle"]; 
	_vehicle = _this select 0;
	if (not([_vehicle] call vehicle_exists)) exitWith {};

	vehicle_side_gear_request_buffer = [_vehicle];
	if (isServer) then {
		["", vehicle_side_gear_request_buffer] call vehicle_save_gear_request_receive;
	}
	else {
		publicVariable "vehicle_side_gear_request_buffer";
	};
};

vehicle_save_stats = {
	/*
	private["_str"];
	_str = format["vehicle_save_stats %1, %2", _this, (driver(_this select 0))];
	diag_log _str;
	player groupChat _str;
	*/
	//diag_log format["item_name = %1", ([_vehicle, "item_name"] call vehicle_get_string)];
	
	private["_vehicle"];

	_vehicle = _this select 0;
	
	if (isNil "_vehicle") exitWith {};
	if (typeName _vehicle != "OBJECT") exitWith {};
	if (_vehicle isKindOf "Man") exitWith {};
	
	private["_driver"];
	_driver = driver(_vehicle);
	
	private["_name", "_class", "_driver_uid", "_velocity", "_position_atl", "_vector_direction", "_vector_up", "_fuel", "_damage", "_engine_state", "_fuel"];
	
	_name = vehicleVarName _vehicle;
	_class = typeOf _vehicle;
	_velocity = velocity _vehicle;
	_position_atl = getPosATL _vehicle;
	_vector_direction = vectorDir _vehicle;
	_vector_up = vectorUp _vehicle;
	_fuel = fuel _vehicle;
	_damage = damage _vehicle;
	_engine_state = isEngineOn _vehicle;
	
	private["_driver_uid"];
	//_driver_uid = [_vehicle, "active_driver_uid"] call vehicle_get_string;
	_driver_uid = "";
	if ([_driver] call player_exists) then {
		_driver_uid = [_driver] call stats_get_uid;
	};
	
	/*
	private["_str"];
	_str = format[ "_driver_uid = %1, typeName _driver_uid = %2 ", _driver_uid,  (typeName _driver_uid)];
	diag_log _str;
	player groupChat _str;
	*/
	
	[_vehicle, "name", _name] call vehicle_set_string;
	[_vehicle, "saved_driver_uid", _driver_uid] call vehicle_set_string;
	[_vehicle, "class", _class] call vehicle_set_string;
	[_vehicle, "velocity", _velocity] call vehicle_set_array;
	[_vehicle, "position_atl", _position_atl] call vehicle_set_array;
	[_vehicle, "vector_direction", _vector_direction] call vehicle_set_array;
	[_vehicle, "vector_up", _vector_up] call vehicle_set_array;
	[_vehicle, "fuel", _fuel] call vehicle_set_scalar;
	[_vehicle, "damage", _damage] call vehicle_set_scalar;
	[_vehicle, "engine_state", _engine_state] call vehicle_set_bool;
	
	[_vehicle, "tuning", (_vehicle getVariable ["tuning", 0])] call vehicle_set_scalar;
	[_vehicle, "nitro", (_vehicle getVariable ["nitro", 0])] call vehicle_set_scalar;
	
	[_vehicle] call vehicle_save_gear;
	[_vehicle] call vehicle_save_storage;
	[_vehicle, "item_name", ([_vehicle, "item_name"] call vehicle_get_string), false] call vehicle_set_string_checked; 
};



vehicle_init_stats = {
	private["_vehicle"];
	
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {false};
	if (typeName _vehicle != "OBJECT") exitWith {false};
	
	private["_driver", "_velocity", "_position_atl", "_vector_direction", "_vector_up", "_fuel", "_damage", "_engine_state", "_weapons", "_magazines", "_speed", "_nitro"];
	
	_velocity = [_vehicle, "velocity"] call vehicle_get_array;
	_position_atl = [_vehicle, "position_atl"] call vehicle_get_array;
				
	_vector_direction = [_vehicle, "vector_direction"] call vehicle_get_array;
	_vector_up =[_vehicle, "vector_up"] call vehicle_get_array;
	_fuel = [_vehicle, "fuel"] call vehicle_get_scalar;
	_damage = [_vehicle, "damage"] call vehicle_get_scalar;
	_engine_state = [_vehicle, "engine_state"] call vehicle_get_bool;
	_weapons = [_vehicle, "weapons"] call vehicle_get_array;
	_magazines= [_vehicle, "magazines"] call vehicle_get_array;
	
	_speed = [_vehicle, "tuning"] call vehicle_get_scalar;
	_nitro =[_vehicle, "nitro"] call vehicle_get_scalar;
	
	if ((typeName _speed) != "SCALAR") then {
		_speed = 0;
	}else{
		if ((_speed <= -1) || (_speed >= 6)) then {
			_speed = 0;
		};
	};
	
	if ((typeName _nitro) != "SCALAR") then {
		_nitro = 0;
	}else{
		if !(_nitro in [0,1]) then {
			_nitro = 0;
		};
	};
	
	if ((typeName _vector_direction) != "ARRAY") exitwith {
			format['vehicle_init_stats: _vector_direction-%1, error', _vector_direction] call A_DEBUG_S;
			false
		};
	if ((typeName _position_atl) != "ARRAY") exitwith {
			format['vehicle_init_stats: _position_atl-%1, error', _position_atl] call A_DEBUG_S;
			false
		};
	
	
	private["_gear"];
	_gear = [];
	_gear set [vehicle_gear_weapons_cargo, _weapons];
	_gear set [vehicle_gear_magazines_cargo, _magazines];
	
	[_vehicle,_gear] call vehicle_set_gear;
	
	[_vehicle] call vehicle_load_storage;
	
	_vehicle setPosATL _position_atl;
	_vehicle setVectorDirAndUp [_vector_direction, _vector_up];
	_vehicle setVelocity _velocity;
	_vehicle engineOn _engine_state;
	_vehicle setDamage _damage;
	_vehicle setFuel _fuel;
	_vehicle setVariable ["tuning", _speed, true];
	_vehicle setVariable ["nitro", _nitro, true];
	
	true
};

vehicle_set_modifications = {
	private["_vehicle", "_item", "_silent"];
	
	_vehicle = _this select 0;
	_item = _this select 1;
	_silent = _this select 2;
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_item") exitWith {};
	if (isNil "_silent") then { _silent = false; };
	
	if (typeName _vehicle != "OBJECT") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (typeName _silent != "BOOL") exitWith {};
	
//	diag_log format['vehicle modifications - item_name - %1', _item];
//	_vehicle setVariable ["item_name", _item, true];
	[_vehicle, "item_name", _item] call vehicle_set_string;
	
	switch (_item) do {
		case "blank": { };
		/* Octavia_ill, Octavia_PMC, Octavia_UN, Octavia_Cop, Octavia_Civ */
		case "Octavia_Civ": {};
		case "Octavia_ill": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(0.5,0,0.5,0.5,ca)"]'; 
			processInitCommands;
		};
		case "Octavia_Cop": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(0,1,0,0.5,ca)"]'; 
			processInitCommands;
		};
		case "Octavia_UN": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(1,1,1,0.5,ca)"]'; 
			processInitCommands;
		};
		case "Octavia_PMC": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(0,0,0,1,ca)"]';
			processInitCommands;
		};
		case "SUV_UN_EP1": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(1,1,1,0.5,ca)"]'; 
			processInitCommands;
		};
		case "SUV_TK_EP1":{
				//_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(0,1,0,0.5,ca)"]'; 
				//processInitCommands;
		};
		case "SUV_PMC_BAF": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(argb,8,8,3)color(0,0,0,0.5,ca)"]'; 
			processInitCommands;
		};
		case "SUV_PMC": {
			_vehicle setVehicleInit 'this setObjectTexture [0, "#(rgb,1,1,1)color(0.1,0.1,0.1,1)"]'; 
			processInitCommands;
		};
		case "ArmoredSUV_PMC": {
			[_vehicle] call armored_suv_close_minigun;
		};
		case "Ka60_PMC": {
			if(not(_silent)) then { hint "Reconfiguring helicopter armament..."; };
			_vehicle removeweapon "57mmLauncher";
		};
		case "Ka60_GL_PMC": {
			if(not(_silent)) then { hint "Reconfiguring helicopter armament..."; };
			_vehicle removeweapon "57mmLauncher";
			
			{_vehicle addmagazine "60Rnd_CMFlareMagazine";}forEach[1];
			_vehicle addweapon "CMFlareLauncher";
			
			{_vehicle addmagazine "100Rnd_762x51_M240";}forEach[1,2,3,4];
			_vehicle addweapon "M240_veh";
		};
		case "AH6J_EP1": {
			if(not(_silent)) then { hint "Reconfiguring helicopter armament..."; };
			_vehicle removeweapon "FFARLauncher_14";
			
			{_vehicle addmagazine "60Rnd_CMFlareMagazine";}forEach[1];
			_vehicle addweapon "CMFlareLauncher";
		};
		case "An2_TK_Cop": {
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			{_vehicle addmagazine "250Rnd_127x99_M3P";}forEach[1,2,3];
			_vehicle addweapon "M3P";
			
			{_vehicle addmagazine "1200Rnd_762x51_M240";}forEach[1,2];
			_vehicle addweapon "M240BC_veh";
		};
		case "An2_TK_Opf": {
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			{_vehicle addmagazine "500Rnd_145x115_KPVT";}forEach[1,2];
			_vehicle addweapon "KPVT";
			
			{_vehicle addmagazine "150Rnd_127x108_KORD";}forEach[1,2,3,4,5];
			_vehicle addweapon "KORD";
		};
		case "An2_TK_Ind": {
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			{_vehicle addmagazine "100Rnd_762x54_PK";}forEach[1,2,3,4,5,6,7,8,9,10];
			_vehicle addweapon "PKTBC_veh";
			
			{_vehicle addmagazine "6Rnd_Grenade_Camel";}forEach[1,2,3,4];
			_vehicle addweapon "CamelGrenades";
		};
		case "L39":{
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			_vehicle removeweapon "GSh23L_L39";
			_vehicle removeweapon "57mmLauncher";
			_vehicle addweapon "CMFlareLauncher";
			_vehicle addmagazine "60Rnd_CMFlareMagazine";
		};
		case "L39_UN":{
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			_vehicle removeweapon "GSh23L_L39";
			_vehicle removeweapon "57mmLauncher";
			_vehicle addweapon "CMFlareLauncher";
			_vehicle addmagazine "60Rnd_CMFlareMagazine";
		};
		case "L39_TK_EP1": {
			if(not(_silent)) then { hint "Reconfiguring plane armament...";};
			_vehicle removeweapon "GSh23L_L39";
			_vehicle removeweapon "57mmLauncher";
			_vehicle addweapon "CMFlareLauncher";
			_vehicle addmagazine "60Rnd_CMFlareMagazine";
		};
		case "BTR40_MG_TK_INS_EP1": {
			if(not(_silent)) then { hint "Reconfiguring vehicle armament...";};
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle removemagazine "50Rnd_127x107_DSHKM";
			_vehicle addmagazine "150Rnd_127x107_DSHKM";
			_vehicle addmagazine "150Rnd_127x107_DSHKM";
			_vehicle addmagazine "150Rnd_127x107_DSHKM";
		};
		case "Ka137_MG_PMC": {
			if(not(_silent)) then { hint "Reconfiguring vehicle armament...";};
			_vehicle removemagazine "200Rnd_762x54_PKT";
			_vehicle removemagazine "200Rnd_762x54_PKT";
			_vehicle addmagazine "1500Rnd_762x54_PKT";
		};
	};
};


vehicle_save_storage = {
	/*
	private["_str"];
	_str =  format["vehicle_save_storage %1", _this];
	player groupChat _str;
	diag_log _str;
	*/
	
	private["_vehicle"];
	_vehicle = _this select 0;
	
	private["_storage_name"];
	_storage_name = [_vehicle] call vehicle_storage_name;
	
	if (_storage_name == "") exitWith {};
	private["_storage_variable"];
	_storage_variable = [_vehicle, _storage_name] call vehicle_get_array;
	
	/*
	private["_str"];
	_str =  format["vehicle_save_storage %1, %2, %3", _vehicle, _storage_name, _storage_variable];
	player groupChat _str;
	diag_log _str;
	*/
		
	[_vehicle, _storage_name, _storage_variable, false] call vehicle_set_array_checked;
};

vehicle_load_storage = {
	private["_vehicle", "_storageName", "_storageArray"];
	_vehicle = _this select 0;
	_storageName = [_vehicle] call vehicle_storage_name;
	_storageArray = [_vehicle, _storageName] call vehicle_get_array;
	_vehicle setVariable [_storageName, _storageArray, true];
};

vehicle_storage_name = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (not([_vehicle] call vehicle_exists)) exitWith {""};
	private["_vehicle_name"];
	_vehicle_name = vehicleVarName _vehicle;
	(format["%1_storage", _vehicle_name])
};

vehicle_set_init = {
	private["_vehicle", "_vehicle_name"];
	_vehicle = _this select 0;
	_vehicle_name = _this select 1;
	
	if (isNil "_vehicle") exitWith {};
	if (isNil "_vehicle_name") exitWith {};
	
	if (typeName _vehicle != "OBJECT") exitWith {};
	if (typeName _vehicle_name != "STRING") exitWith {};
	
	_vehicle setVehicleInit format['
		this setVehicleVarname "%1";
		%1 = this;
		clearWeaponCargo this;
		clearMagazineCargo this;
		this lock true;
		mounted_actions_init = if (isNil "mounted_actions_init") then { [] } else {mounted_actions_init};
		mounted_actions_init = mounted_actions_init + [%1];
		[%1] call mounted_add_actions;
	
		this addEventHandler ["GetIn", { _this spawn vehicle_GetIn_handler}];
		this addEventHandler ["GetOut", { _this spawn vehicle_GetOut_handler}];
	',_vehicle_name];
	processInitCommands;
	
	missionNamespace setVariable [vehicle_set_init_server, _vehicle_name];
	publicVariableServer vehicle_set_init_server;
};

vehicle_set_init_server = "vehicle_server_init_pv";
vehicle_set_init_server addPublicVariableEventHandler {
		private["_vehicle"];
		_vehicle = missionNamespace getVariable (_this select 1);
		
		_vehicle addEventHandler ["handleDamage", {_this call A_fnc_EH_hDamageV}];
		_vehicle addEventHandler ["fired", {_this spawn A_fnc_EH_firedV}];
		_vehicle addMPEventhandler ["MPKilled", {_this call vehicle_handle_mpkilled}];
	};

vehicle_generate_name = {
	private["_restart_count","_vehicle_name"];
	_restart_count = server getVariable "restart_count";
	_vehicle_name = format["vehicle_%1_%2_%3", player, _restart_count, round(time)];
	if ([_vehicle_name] call vehicle_name_exist)then{[] call vehicle_generate_name}else{_vehicle_name};
};

vehicle_name_exist = {
	private["_vehicleName"];
	_vehicleName = _this select 0;
	
	if (!isNull (missionNamespace getVariable [_vehicleName, objNull])) exitwith {true};
	if ((["impound_lot", _vehicleName] call vehicle_storage_contains)) exitWith {true};
	
	false
};

vehicle_handle_mpkilled = { _this spawn {
	private["_unit", "_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
	[_unit, 60] spawn vehicle_despawn;
};};

vehicle_create = {
	private["_class", "_position", "_name", "_exact"];
	
	_class = _this select 0;
	_position = _this select 1;
	_exact = _this select 2;
	
	if (isNil "_class") exitWith {};
	if (isNil "_position") exitWith {};
	if (isNil "_exact") exitWith {};
	
	if (typeName _class != "STRING") exitWith {};
	if (typeName _position != "ARRAY") exitWith {};
	if (typeName _exact != "BOOL") exitWith {};
	
	
	private["_vehicle"];
	_vehicle = createVehicle [_class, _position, [], 0, "NONE"];
	if (_exact) then {
		_vehicle setPosATL _position;
	};
	
	_vehicle setVariable ["isPlayerVehicle", true, true];
	_vehicle setVariable ["created", time, true];
//	[player, _vehicle] call vehicle_add;
	
	_vehicle
};


vehicle_recreate = {
	//player groupChat format["Recreating _this = %1", _this];
	private["_name", "_class"];
	_name = _this select 0;
	_class = _this select 1;
	
	if (isNil "_name") exitWith {};
	if (typeName _name != "STRING") exitWith {nil};
	if (isNil "_class") exitWith {};
	if (typeName _class != "STRING") exitWith {nil};
	
	private["_vehicle"];
	private["_vehicle"];
	_vehicle = missionNamespace getVariable _name;
	if (!(isNil "_vehicle")) exitWith {_vehicle};
	
	private["_data"];
	//player groupChat format["Recreating _name = %1", _name];
	_data = [_name] call stats_load_request_send;
	_vehicle = [_class, [0,0,0], false] call vehicle_create;
	[_vehicle, _name] call vehicle_set_init;	
	[_data, _vehicle] call stats_compile_sequential;
	sleep 1;
	
	private["_return"];
	_return = false;
	_return = [_vehicle] call vehicle_init_stats;
	if !(_return) exitwith {
			player groupChat format['ERROR IN LOADING SAVED VEHICLE'];
			[_vehicle, 0] spawn vehicle_despawn;
			objNull
		};
	
	private["_item_name"];
	_item_name = [_vehicle, "item_name"] call vehicle_get_string;
	[_vehicle, _item_name, true] call vehicle_set_modifications;
	[player, _vehicle] call vehicle_add;
	(_vehicle)
};


vehicle_create_shop_extended = {
	//player groupChat format["vehicle_create_shop_extended %1", _this];
	private["_logic", "_class", "_item", "_exact"];
	_logic = _this select 0;
	_class = _this select 1;
	_item = _this select 2;
	_exact = _this select 3;
	
	private["_vehicle_name", "_position"];
	_vehicle_name = [] call vehicle_generate_name;
	_position = getPosATL _logic;
	
	private["_vehicle"];
	_vehicle = [_class, _position, _exact] call vehicle_create;
	
	if (not(isNil "_vehicle")) then {
		_vehicle setDir (getDir _logic);
	};
	
	if (isCop) then {
		[_vehicle] call vehicle_cop_tuning;
	};
	
	//player groupChat format["_vehicle_name = %1,  _vehicle = %2", _vehicle_name, _vehicle];
	[_vehicle, _vehicle_name] call vehicle_set_init;
	[_vehicle, _item, false] call vehicle_set_modifications;
	[player, _vehicle] call vehicle_add;
	
	(_vehicle)
};


vehicle_create_shop = {
	private["_logic", "_class", "_item"];
	_logic = _this select 0;
	_class = _this select 1;
	_item = _this select 2;
	
	([_logic, _class, _item, not(isPlayer _logic)] call vehicle_create_shop_extended)
};




vehicle_exists = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {false};
	if (typeName _vehicle != "OBJECT") exitWith {false};
	true
};


vehicle_gear_weapons_cargo = 0;
vehicle_gear_magazines_cargo = 1;

vehicle_get_gear = {
	private["_vehicle"]; 
	_vehicle = _this select 0;
	if (not([_vehicle] call vehicle_exists)) exitWith {nil};
	
	private["_weapons_cargo", "_magazines_cargo"];
	_weapons_cargo = getWeaponCargo _vehicle;
	_magazines_cargo = getMagazineCargo  _vehicle;

	private["_gear"];
	_gear = [];
	_gear set [vehicle_gear_weapons_cargo, _weapons_cargo];
	_gear set [vehicle_gear_magazines_cargo, _magazines_cargo];
	_gear
};


vehicle_set_gear = {
	//player groupChat format["vehicle_set_gear %1", _this];
	private["_vehicle", "_gear"];
	_vehicle = _this select 0;
	_gear = _this select 1;
	if (not([_vehicle] call vehicle_exists)) exitWith {};
	if (isNil "_gear") exitWith {};
	if (typeName _gear != "ARRAY") exitWith {};
	
	private["_weapons_cargo", "_magazines_cargo"];	
	
	_weapons_cargo = _gear select vehicle_gear_weapons_cargo;
	_magazines_cargo = _gear select vehicle_gear_magazines_cargo;
	
	if (isNil "_weapons_cargo") exitWith {};
	if (isNil "_magazines_cargo") exitWith {};

	if (typeName _weapons_cargo != "ARRAY") exitWith {};
	if (typename _magazines_cargo != "ARRAY") exitWith {};

	
	private["_cargo_weapons_class", "_cargo_weapons_count", "_cargo_magazines_class", "_cargo_magazines_count"];
	_cargo_weapons_class  = _weapons_cargo select 0;
	_cargo_weapons_count	= _weapons_cargo select 1;
	_cargo_magazines_class = _magazines_cargo select 0;
	_cargo_magazines_count= _magazines_cargo select 1;
		
	private["_i"];
	
	_i = 0;
	while { _i < (count _cargo_weapons_class) } do {
		private["_weapon_class", "_weapon_count"];
		_weapon_class = _cargo_weapons_class select _i;
		_weapon_count = _cargo_weapons_count select _i;
		_vehicle addWeaponCargoGlobal [_weapon_class, _weapon_count];
		_i = _i + 1;
	};
		
	_i = 0;
	while { _i < (count _cargo_magazines_class) } do { 
		private["_magazine_class", "_magazine_count"];
		_magazine_class = _cargo_magazines_class select _i;
		_magazine_count = _cargo_magazines_count select _i;
		_vehicle addMagazineCargoGlobal [_magazine_class, _magazine_count];
		_i = _i + 1;
	};
};

vehicle_reset_gear = {
	//player groupChat format["vehicle_reset_gear %1", _this];
	private["_vehicle"];
	_vehicle = _this select 0;
	if (not([_vehicle] call vehicle_exists)) exitWith {};
	
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
};

vehicle_unflip = {
	private["_vcl"];
	_vcl = (nearestobjects [getpos player, ["LandVehicle"], 10] select 0);
	//if (_vcl == "") exitwith {player groupchat "No vehicles in range";};
	if (([player, _vcl] call vehicle_owner)) then {
		if (({(alive _x) && (isPlayer _x)} count crew _vcl) > 0) exitWith {player groupChat "The vehicle is not empty!";};

		player groupChat "Turning your vehicle over, wait 10 seconds within 10meters.";
		sleep 10;

		if (player distance _vcl <= 10) then {
			_vcl setPosATL [ (getPosATL _vcl select 0), (getPosATL _vcl select 1), (getPosATL _vcl select 2) + 2];;
			format['%1 setvectorup [0.001,0.001,1];', _vcl] call broadcast;
			player groupchat "Your vehicle has been reset";
		} 
		else {
			player groupchat "Try again, stay within 10m";
		};
	}
	else {
		player groupchat "You need the keys to unflip a vehicle";
	};
};

vehicle_cop_tuning = {
	private["_vehicle"];
	_vehicle = _this select 0;
	
	if(!(_vehicle iskindof "car"))exitwith{};
	if (({_vehicle isKindOf _x} count ["BRDM2_Base","BTR90_Base","LAV25_Base","HMMWV_M1151_M2_DES_Base_EP1","StrykerBase_EP1"]) > 0) exitwith {};
	
	_vehicle setVariable ["tuning", 2, true];
};

vehicle_toggle_lock = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (not([_vehicle] call vehicle_exists)) exitWith {};

	private["_state", "_stateV"];
	_state = (locked _vehicle);
	_stateV = "";
	_stateV = if(_state)then{"pv_vehUnlock"}else{"pv_vehLock"};
	
	missionNamespace setVariable [_stateV, _vehicle];
	publicVariable _stateV;
	_vehicle lock !(_state);
	
	_state
};

pv_vehLock = objNull;
"pv_vehLock" addPublicVariableEventHandler {(_this select 1) lock true;};

pv_vehUnlock = objNull;
"pv_vehUnlock" addPublicVariableEventHandler {(_this select 1) lock false;};

vehicle_owner = {
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;
	if (not([_player] call player_human)) exitWith{false};
	if (not([_vehicle] call vehicle_exists)) exitWith {false};
	
	private["_vehicles"];
	_vehicles = [player] call vehicle_list;
	(_vehicle in _vehicles)

};

vehicle_is_player_owner = {
	private["_vehicle"];
	
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {false};
	if (typeName _vehicle != "OBJECT") exitWith {false};
	
	private["_vehicles"];
	_vehicles = [player] call vehicle_list;
	(_vehicle in _vehicles)
};

vehicle_build_string_array = {
	private["_vehicles", "_vehicles_string_array"];
	_vehicles = [];
	_vehicles = [player] call vehicle_list;
	_vehicles_string_array = [];
	
	{
		if (true) then {
			private["_vehicle"];
			_vehicle = _x;
			if (isNil "_vehicle") exitWith {};
			if (typeName _vehicle != "OBJECT") exitWith{};
			if (isNull _vehicle) exitWith {};
			if (not(alive _vehicle)) exitWith {};
			private["_vehicle_name"];
			_vehicle_name = vehicleVarName _vehicle;
			if (isNil "_vehicle_name") exitWith{};
			if (typeName "_vehicle_name" != "STRING") exitWith{};
			
			_vehicles_string_array = _vehicles_string_array + [_vehicle_name];
		};
	} foreach _vehicles;
	
	_vehicles_string_array
};


vehicle_save = {
	private["_vehicles_string_array"];
	_vehicles_string_array = call vehicle_build_string_array;
	["vehicles_name_list", _vehicles_string_array] spawn stats_client_save;
};

//initializes the player's list of owned vehicles from the stats list of vehicle names (strings)
vehicle_load = {
	if (not(isClient)) exitWith {};
	
	private["_player"];
	_player = player;
	
	[_player, "vehicles_list"] call stats_update_variables_list;
	["vehicles_name_list", []] call stats_init_variable;

	private["_vehicle_names"];
	_vehicle_names = vehicles_name_list;
	if (isNil "_vehicle_names") exitWith {};
	if (typeName _vehicle_names != "ARRAY") exitWith {};
	
	private["_vehicle", "_vehicle_name"];
	{
		_vehicle_name = _x;
		_vehicle = missionNamespace getVariable [_vehicle_name, objNull];
//		if ((not(isNull _vehicle)) || ((["impound_lot", _vehicle_name] call vehicle_storage_contains)) ) exitWith {
		if (!(isNull _vehicle)) exitwith {
			[_player, _vehicle] call vehicle_add;
		};
	} foreach _vehicle_names;
		
	
};

vehicle_add = {
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;		
	if (not([_player] call player_human)) exitWith {false};
	if (not([_vehicle] call vehicle_exists)) exitWith {false};
	
	private["_vehicles"];
	_vehicles = [];
	_vehicles  = [_player] call vehicle_list;
	if (_vehicle in _vehicles) exitWith {};
	_vehicles = _vehicles call vehicle_list_removeNull;
	_vehicles = _vehicles + [_vehicle];
	_player setVariable ["vehicles_list", _vehicles, true];
	[] call vehicle_save;
};

vehicle_list_removeNull = {
	private["_vehicles", "_newList", "_listCount", "_vehicle", "_type"];
	
	_vehicles = _this;
	_newList = [];
	_listCount = 0;
	_type = "";
	
	{
		_vehicle = _x;
		_type = typeName _vehicle;
		
/*		if (_type == "STRING") then {
				if (isNull (missionNamespace getVariable [_vehicle, objNull])) then {
						if ((["impound_lot", _vehicle] call vehicle_storage_contains)) then {
								_newList set [_listCount, _vehicle];
								_listCount = _listCount + 1;
							};
					};
			};
*/		if (_type == "OBJECT") then {
				if !(isNull _vehicle) then {
						_newList set [_listCount, _vehicle];
						_listCount = _listCount + 1;
					};
			};
			
	} forEach _vehicles;
	
	_newList
};

vehicle_remove = {
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;
	if (not([_player] call player_human)) exitWith {false};
	if (not([_vehicle] call vehicle_exists)) exitWith {false};
	
	
	private["_vehicles"];
	_vehicles  = [_player] call vehicle_list;
	_vehicles = _vehicles call vehicle_list_removeNull;
	_vehicles = _vehicles - [_vehicle];
	_player setVariable ["vehicles_list", _vehicles, true];
	
	call vehicle_save;
};

vehicle_list = {
	private["_player", "_vehicles"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {[]};
	
	_vehicles = [];
	_vehicles =  _player getVariable ["vehicles_list", []];
	_vehicles = if ((typeName _vehicles) != "ARRAY") then {[]} else {_vehicles};
	
//	diag_log format["VEHICLE LIST CALLED: %1 - %2", _player, _vehicles];
	
	_vehicles
};


vehicle_clean_checkTime = 5 * 60;
vehicle_clean_triggerOn = "trigger_on";

vehicle_clean_ignore = ["headbugbus"];

vehicle_clean_time = {
	private["_vehicle", "_type", "_delay"];
	_vehicle = _this select 0;
	_type = typeOf _vehicle;
	_delay = 5;
	
	_delay = if (({_type isKindOf _x} count ["Motorcycle","ATV_Base_EP1"]) > 0) then {_delay - 3}else{_delay};
	_delay = _delay + (_vehicle getVariable ["tuning", 0]) + (_vehicle getVariable ["nitro", 0]);
	
	_delay
};

vehicle_clean_getArray = {
	private["_classes", "_vehicleArray", "_aCount", "_classEntities", "_timeStart", "_timeEnd"];
	
	_timeStart = diag_tickTime;
	
	_classes = ["Car", "Motorcycle", "Tank", "Air", "Ship"];
	_vehicleArray = [];
	_aCount = 0;
	
	{
		_classEntities = entities _x;
		{
			if !(isNull _x) then {
					if (alive _x) then {
							if !(toLower(str(_x)) in vehicle_clean_ignore) then {
									_vehicleArray set[_aCount, _x];
									_aCount = _aCount + 1;
								};
						};
				};
		} forEach _classEntities;
	} forEach _classes;
	
	_timeEnd = diag_tickTime;
	
	format["VEHICLE CLEAN ARRAY GRAB - %1 Minutes - %2 Grab Time - Count %3", round(time / 60), (_timeEnd - _timeStart), _aCount] call A_DEBUG_S;
	
	_vehicleArray
};

vehicle_clean_varCheck = {
	private["_vehicle", "_timeIn", "_timeOut"];
	
	_vehicle = _this select 0;
	
//	_vehicle setVariable [vehicle_clean_getInTimeV, (_vehicle getVariable [vehicle_clean_getInTimeV, time]), false];
//	_vehicle setVariable [vehicle_clean_getInTimeV, (_vehicle getVariable [vehicle_clean_getInTimeV, time]), false];
	
	_timeIn = 0;
	_timeOut = 0;
	
	if (isNil {_vehicle getVariable vehicle_clean_getInTimeV}) then {
			_timeIn = time;
			_vehicle setVariable [vehicle_clean_getInTimeV, _timeIn, false];
		}else{
			_timeIn = _vehicle getVariable [vehicle_clean_getInTimeV, _timeIn];
		};
	
	if (isNil {_vehicle getVariable vehicle_clean_getOutTimeV}) then {
			_timeOut = time;
			_vehicle setVariable [vehicle_clean_getOutTimeV, _timeOut, false];
		}else{
			_timeOut = _vehicle getVariable [vehicle_clean_getOutTimeV, _timeOut];
		};
	
	[_timeIn, _timeOut]
};

vehicle_clean_check = {
	private["_vehicle"];
	
	_vehicle = _this select 0;
	
	if (_vehicle getVariable [vehicle_clean_triggerOn, false])exitwith{};
	if (({(alive _x)&& (isPlayer _x)} count (crew _vehicle)) != 0)exitwith {};
	
	if ([_vehicle] call A_impound_check) exitwith {
			_this call vehicle_clean_check_impound;
		};
	
	format['Vehicle Clean Check - %1: Starting', _vehicle] call A_DEBUG_S;
	
	private["_checkAllowed", "_despawnTime", "_times", "_timeIn", "_timeOut", "_timeLast"];
	
	_checkAllowed = 0;
	_despawnTime = 0;
	_times = [];
	_timeIn = 0;
	_timeOut = 0;
	_timeLast = 0;
	
	_checkAllowed = [_vehicle] call vehicle_clean_time;
	_despawnTime = _checkAllowed * vehicle_clean_checkTime;
	
	_times = [_vehicle] call vehicle_clean_varCheck;
	_timeIn = _times select 0;
	_timeOut = _times select 1;
	
	_timeLast = if (_timeIn > _timeOut) then {_timeIn}else{_timeOut};
	
	format['Vehicle Clean Check - %1: TL - %2, TI - %3, TO - %4', _vehicle, _timeLast, _timeIn, _timeOut]  call A_DEBUG_S;
	
	if ( (time - _timeLast) <  _despawnTime) exitwith {
			format['Vehicle Clean Check - %1: Time Exit', _vehicle]  call A_DEBUG_S;
		};
	
	format['Vehicle Clean Check - %1: Cleanup', _vehicle]  call A_DEBUG_S;
	
	[_vehicle] call vehicle_clean_cleanUp;
	
/*	
	private["_nearbyHumans"];
	
	_nearbyHumans = [];
	_nearbyHumans = (getPosATL _vehicle) nearEntities ["caManBase", 100];
	
	if (({(isPlayer _x) && (alive _x)} count _nearbyHumans) == 0) then {
			[_vehicle] call vehicle_clean_trigSet;
		}else{
			[_vehicle] call vehicle_clean_cleanUp;
		};
*/	
};

vehicle_clean_check_impound = {
		private["_vehicle", "_impoundtime", "_cleanTime"];
		
		_vehicle = _this select 0;
		_impoundTime = _vehicle getVariable ["impoundTime", 0];
		_cleanTime = ([_vehicle] call vehicle_clean_time) * 3;
		
		if ( (time - _impoundTime) > _cleanTime ) then {
				deleteVehicle _vehicle;
			};
	};

vehicle_clean_cleanUp = {
	[(_this select 0)] call A_impound_vacant;
};

vehicle_clean_trigSet = {
	private["_vehicle", "_trigger"];
	
	_vehicle = _this select 0;
	_vehicle setVariable [vehicle_clean_triggerOn, true, false];
	
	_trigger = createTrigger ["EmptyDetector", (getPosATL _vehicle)];
	_trigger setTriggerArea [100, 100, 0, false];
	_trigger setTriggerActivation ["ANY", "NOT PRESENT", false];
	_trigger setTriggerStatements[
		format["
			['%1'] call vehicle_clean_trigCheck
		", _vehicle], 
		format["['%1', '%2'] call vehicle_clean_trigOn;", _vehicle, _trigger], 
		""
	]; 
};

vehicle_clean_trigCheck = {
		private["_vehicleString", "_vehicle", "_return"];
		
		_vehicleString = _this select 0;
		_vehicle = missionNamespace getVariable [_vehicleString, objNull];
		_return = false;
		
		if (isNull _vehicle) then {
				_return = true;
			}else{
				if (alive _vehicle) then {
						_return = true;
					}else{
						if (( {(alive _x) && (isPlayer _x)}count (crew _vehicle)) > 0) then {
								_return = true;
							}else{
								private["_nearbyHumans"];
				
								_nearbyHumans = [];
								_nearbyHumans = (getPosATL _vehicle) nearEntities ["caManBase", 100];
								
								if (({(isPlayer _x) && (alive _x)} count _nearbyHumans) == 0) then {
										_return = true;
									};
							};
					};
			};
		
		_return
	};

vehicle_clean_trigOn = {
	private["_vehicleString", "_triggerString", "_vehicle", "_trigger", "_nearbyHumans"];
	
	_vehicleString = _this select 0;
	_triggerString = _this select 1;
	
	_vehicle = missionNamespace getVariable [_vehicleString, objNull];
	_trigger = missionNamespace getVariable [_triggerString, objNull];
	
	if (isNull _vehicle) exitwith {
			deleteVehicle _trigger;
		};
	if (isNull _trigger) exitwith {
			diag_log format['VEHICLE CLEAN ERROR - %1 - TRIGGER NULL', _vehicle];
		};
	
	if !(alive _vehicle) exitwith {
			deleteVehicle _trigger;
		};
	
	_nearbyHumans = [];
	_nearbyHumans = (getPosATL _vehicle) nearEntities ["caManBase", 100];
	
	if (({(isPlayer _x) && (alive _x)} count _nearbyHumans) == 0) then {
			[_vehicle] call vehicle_clean_cleanUp
		} else {
			deleteVehicle _trigger;
			_vehicle setVariable [vehicle_clean_triggerOn, false, false];
		};
};


call vehicle_load;
call vehicle_save_gear_setup;
vehicle_functions_defined = true;