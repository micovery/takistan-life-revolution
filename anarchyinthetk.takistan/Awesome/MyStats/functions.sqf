#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE
#include "constants.h"
#include "ASCII.h"

stats_use_factions = false;
stats_server_uid = "__SERVER__";

if (not(isNil "stats_functions_defined")) exitWith {};

stats_load_request_uid = 0;
stats_load_request_response_variable = 1;

stats_load_request_receive = {
	private["_variable", "_request"];
	
	_variable = _this select 0;
	_request = _this select 1;
	
	//player groupChat format["LOAD_REQUEST_RECV: %1", _request];
	
	if (isNil "_request") exitWith {};
	if (typeName _request != "ARRAY") exitWith {};
	
	private["_uid", "_response_variable"];
	_uid = _request select stats_load_request_uid;
	_response_variable = _request select stats_load_request_response_variable;
	
	
	if (isNil "_uid") exitWith {};
	if (typeName _uid != "STRING") exitWith {};
	if (isNil "_response_variable") exitWith {};
	if (typeName _response_variable != "STRING") exitWith {};
	
	private["_data"];
	_data = [_uid] call getAllPlayerVariables;
	server setVariable[_response_variable, _data, true];
};

stats_build_load_request = {
	private["_uid"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith {nil};
	if (typeName _uid != "STRING") exitWith {nil};
	
	private["_response_variable"];
	_response_variable = _uid;
	server setVariable [_response_variable, nil, true];
	
	private["_request"];
	
	_request = [];
	_request set [stats_load_request_uid, _uid];
	_request set [stats_load_request_response_variable, _response_variable];
	_request
};


stats_load_request_send = {
	private["_uid", "_request", "_response_variable"];
	
	_uid = _this select 0;
	_request = [_uid] call stats_build_load_request;
	if (isNil "_request") exitWith {[]};
	
	private["_response_variable"];
	_response_variable = _request select stats_load_request_response_variable;
	server setVariable [_response_variable, nil, true];
	
	if (isServer) then {
		//on the server we can call the receive function directly
		["", _request] call stats_load_request_receive;
	}
	else {
		//from the client we have to send request across the network
		stats_load_request_buffer = _request;
		publicVariableServer "stats_load_request_buffer";
	};
	
	//wait for the response
	private["_data", "_complete"];
	
	_data = [];
	_complete =  false;

	while {true} do {  
		
/*		_data = server getVariable _response_variable;
		_complete = true;
		_complete = if (isNil "_data") then {false} else {_complete};
		_complete = if (typeName _data != "ARRAY") then {false} else { _complete };
*/
		if !(isNil {server getVariable _response_variable}) then {
				if ( (typeName (server getVariable _response_variable)) == "ARRAY" ) then {
						_data = server getVariable _response_variable;
						_complete = true;
					};
			};
		
		if (_complete) exitWith {};
		uiSleep 0.1;
	};
	
	_data
};

stats_save_request_uid = 0;
stats_save_request_key = 1;
stats_save_request_value = 2;

stats_save_request_receive = {
	private["_variable", "_request"];
	
	_variable = _this select 0;
	_request = _this select 1;
	
	if (isNil "_request") exitWith {};
	if (typeName _request != "ARRAY") exitWith {};
	
	private["_uid", "_key", "_value"];
	_uid = _request select stats_save_request_uid;
	_key = _request select stats_save_request_key;
	_value = _request select stats_save_request_value;
	
	
	if (isNil "_uid") exitWith {};
	if (isNil "_key") exitWith {};
	if (isNil "_value") exitWith {};
	if (typeName _uid != "STRING") exitWith {};
	if (typeName _key != "STRING") exitWith {};
	
	_value = [_value];
	[_uid, _key, _value] call updatePlayerVariable;
};

stats_build_save_request = {
	private["_uid", "_variable", "_value"];
	
	_uid = _this select 0;
	_variable = _this select 1;
	_value = _this select 2;
	
	if (isNil "_uid") exitWith {nil};
	if (isNil "_variable") exitWith {nil};
	if (isNil "_value") exitWith {nil};
	
	if (typeName _uid != "STRING") exitWith{nil};
	if (_uid == "") exitWith {};
	if (typeName _variable != "STRING") exitWith {nil};
	
	private["_request"];

	_request = [];
	_request set [stats_save_request_uid, _uid];
	_request set [stats_save_request_key, _variable];
	_request set [stats_save_request_value, _value];
	_request
};

stats_save_request_send = {
	private["_request"];
	_request = _this call stats_build_save_request;
	if (isNil "_request") exitWith {};

	
	if (isServer) then {
		// if we are on server, we can call the receive method directly
		["", _request] call stats_save_request_receive;
	}
	else {
		// if we are on client, then we need to send it across the network
		stats_save_request_buffer = _request;
		publicVariableServer "stats_save_request_buffer";
	};
};

stats_human_side = {
	private ["_player"];
	_player = _this select 0;
	if (isNil "_player") exitWith {sideUnknown};
	if (typeName _player != "OBJECT") exitWith {sideUnknown};
	if (isNull _player) exitWith {sideUnknown};
	
	private["_player_str", "_data", "_ch1", "_ch2"];
	_player_str = toUpper(str(_player));
	_data = toArray _player_str;
	_ch1 = (_data select 1);
	_ch2 = (_data select 2);
	
	if (_ch1 == ASCII_P && _ch2 == ASCII_F) exitWith { east};			// o pf
	if (_ch1 == ASCII_I && _ch2 == ASCII_V) exitWith { civilian };		// c iv
	if (_ch1 == ASCII_N && _ch2 == ASCII_S) exitWith { resistance };	// i ns
	if (_ch1 == ASCII_O && _ch2 == ASCII_P) exitWith { west };			// c op
	
	 sideUnknown
};


stats_get_faction = {
	private ["_player"];
	_player = _this select 0;
	private["_side"];
	_side = [_player] call player_human_side;
	if (_side == east) exitWith {"Opfor"};
	if (_side == west) exitWith {"Cop"};
	if (_side == civilian) exitWith {"Civilian"};
	if (_side == resistance) exitWith {"Insurgent"};
	""
};





stats_get_uid = {
	private["_object","_uid"];
	_object = _this select 0;
	
	_uid = _object getVariable "stats_uid";
	if (not(isNil "_uid")) exitWith {_uid};
	
	if (not(_object isKindOf "Man")) exitWith {
		([_object] call starts_get_vehicle_uid)
	};
	
	([_object] call stats_get_player_uid)
};

starts_get_vehicle_uid = {
	private["_object"];
	
	_object = _this select 0;
	if (isNil "_object") exitWith {""};
	
	private["_uid"];
	_uid = vehicleVarName _object;
	if (isNil "_uid") exitWith {""};
	if (typeName _uid != "STRING") exitWith {};
	
	_object setVariable ["stats_uid", _uid, true];
	(_uid)
};

stats_get_player_uid = {
	private["_player", "_uid"];
	_player = _this select 0;
	
	_uid = _player getVariable "stats_uid";
	if (not(isNil "_uid")) exitWith {_uid};
	
	_uid = getPlayerUID _player;
	if (isNil "_uid") exitWith {""};
	if (typeName _uid != "STRING") exitWith {""};
	if (_uid == "") exitWith {""};
	
	_player setVariable ["real_uid", _uid, true];
	_player setVariable ["name", (name _player), true];
	
	private["_faction"];
	_faction = [_player] call stats_get_faction;
	_uid = if (stats_use_factions) then { _uid + "_" + _faction } else {_uid};
	_player setVariable ["stats_uid", _uid, true];
	_uid	
};

//generic method for saving variables, can be called either from server or client
//Arguments are [uid,key,value]
stats_save = {
	_this call stats_save_request_send;
};

//Method intended to be run on server-side, it is used for saving SERVER specific variables
//Arguments are [key,value]
stats_server_save = {
	private["_variable", "_value"];
	
	_variable = _this select 0;
	_value = _this select 1;
	
	if (isNil "_variable") exitWith {};
	if (isNil "_value") exitWith {};
	if (typeName _variable != "STRING") exitWith {};
	
	private["_uid"];
	[stats_server_uid, _variable, _value] call stats_save;
};

//Method intended to be run on client-side, for saving CLIENT specific variables
stats_client_save = {
	private["_variable", "_value"];
	
	_variable = _this select 0;
	_value = _this select 1;
	
	[player, _variable, _value] call stats_player_save;
	true
};

//method intended saving player stats ... it can be run on any client, or even cross-client to save stats for another player
stats_player_save = {
	private["_player", "_variable", "_value"];
	_player = _this select 0;
	_variable = _this select 1;
	_value = _this select 2;
	
	private["_uid"];
	_uid = [_player] call stats_get_uid;
	if (_uid == "") exitWith {};
	
	if (isNil "_variable") exitWith {};
	if (isNil "_value") exitWith {};
	if (typeName _variable != "STRING") exitWith {};
		
	[_uid, _variable, _value] call stats_save;
};

//method intended saving vehicle stats ... it can be run on any client
stats_vehicle_save = {
	private["_vehicle", "_variable", "_value"];
	_vehicle = _this select 0;
	_variable = _this select 1;
	_value = _this select 2;
	
	private["_uid"];
	_uid = [_vehicle] call stats_get_uid;
	
	if (_uid == "") exitWith {};
	
	if (isNil "_variable") exitWith {};
	if (isNil "_value") exitWith {};
	if (typeName _variable != "STRING") exitWith {};
		
	[_uid, _variable, _value] call stats_save;
};


stats_server_player_disconnected = {
	private["_id", "_name", "_uid"];
	_id = _this select 0; 
	_name = _this select 1; 
	_uid  = _this select 2; 
	
	if (isNil "_uid") exitWith {};
	if (typeName _uid != "STRING") exitWith {};
	if (_uid == "") exitWith {};
	
	private["_player"]; 
	_player = [_name] call player_lookup_name;
	
	diag_log format["%1,%2,%3 - disconnected saving start", _player, _name, _uid];
	[_player] call player_save_side_gear;
	[_player] call player_save_side_inventory;
	[_player] call player_save_side_position;
	[_player] call player_save_side_damage;
	[_player] call player_save_side_vehicle;
	[_player] call gang_player_disconnected;
	[_uid, _player] call ftf_disconnected;
	[_player] spawn bankRob_disconnect;
	diag_log format["%1,%2,%3 - disconnected saving end", _player, _name, _uid];
	

	private["_vehicle"];
	_vehicle = (vehicle _player);
//	diag_log 'checking player in vehicle';
	if (_vehicle != _player) then {
//			diag_log format['Checking vehicle in keylist: %1', _player];
//			diag_log format['VEHICLE LIST - %1 - %2', _player, ([_player] call vehicle_list)];
			if ( _vehicle in  ([_player] call vehicle_list)) then {
//					diag_log 'vehicle in keylist';
					[_vehicle] call vehicle_save_stats;
					[_vehicle] call vehicle_start_track;
				}else{
//					diag_log format['%1 - %2 - vehicle not in vehicles_list', _player, _vehicle];
				};
		};
		
	private["_stats_uid"];
	_stats_uid =  [_player] call stats_get_uid;
	[_stats_uid] call unloadPlayerVariables;
};


stats_load_core_libraries = {
	private["_h"];

	_h = [] execVM "Awesome\Functions\vehicle_functions.sqf";
	waitUntil {scriptDone _h};
	
//	_h = [] execVM "Awesome\Functions\player_functions.sqf";
//	waitUntil {scriptDone _h};
	[] call player_save_side_gear_setup;
	[] call player_init_arrays;
	ExecSQF("broadcast.sqf");
	
	_h = [] execVM "Awesome\Clothes\Clothes.sqf";
	waitUntil {scriptDone _h};
};

stats_server_setup = {
	onPlayerDisconnected { [_id, _name, _uid] call stats_server_player_disconnected };
	
	//setup event listener for players trying to load their stats	
		
	stats_load_request_buffer =  " ";
	publicVariableServer "stats_load_request_buffer";
	"stats_load_request_buffer" addPublicVariableEventHandler { _this call stats_load_request_receive;};
	
	//setup event lister for players trying to save their stats
	stats_save_buffer = " ";
	publicVariableServer "stats_save_request_buffer";
	"stats_save_request_buffer" addPublicVariableEventhandler { _this call stats_save_request_receive; };
	
	//load the SERVER's own variables
	private["_data"];
	_data = [stats_server_uid] call stats_load_request_send;
	[_data, server] call stats_compile_sequential;
	
	
	//keep a count of how many times the server has restarted
	private["_restart_count"];
	_restart_count = server getVariable "restart_count";
	_restart_count = if (isNil "_restart_count") then {0} else {_restart_count};
	_restart_count = if (typeName _restart_count != "SCALAR") then {0} else {_restart_count};
	_restart_count = _restart_count + 1;
	server setVariable ["restart_count", _restart_count, true];
	["restart_count", _restart_count] call stats_server_save;
	
	[] call stats_load_core_libraries;
	

	server setVariable ["stats_server_setup_complete", true, true];
};


stats_client_server_setup_wait = {
	private["_complete"];
	
	while {true} do {
		_complete = server getVariable "stats_server_setup_complete";
		_complete = if (isNil "_complete") then {false} else { _complete};
		_complete = if (typeName _complete != "BOOL") then {false} else { _complete };
		if (_complete) exitWith {};
		uiSleep 0.1;
	};
	_complete
};

stats_compile_loading = {
	private["_data", "_object"];
	_data = _this select 0;
	_object = _this select 1;
	[_data, _object, true, true] call stats_compile;
};

stats_compile_sequential = {
	private["_data", "_object"];
	_data = _this select 0;
	_object = _this select 1;
	[_data, _object, true, false] call stats_compile;
};

stats_compile_parallel = {
	private["_data", "_object"];
	_data = _this select 0;
	_object = _this select 1;
	[_data, _object, false, false] call stats_compile;
};

stats_compile = {
	private["_data", "_object", "_sequential", "_loading"];
	_data = _this select 0;
	_object = _this select 1;
	_sequential = _this select 2;
	_loading = _this select 3;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	
	if (isNil "_sequential") exitWith {};
	if (typeName _sequential != "BOOL") exitWith {};
	
	if (isNil "_loading") exitWith {};
	if (typeName _loading != "BOOL") exitWith {};
	
	
	private["_i", "_count"];
	
	_count = count _data;
	_i = 0;
	while { _i < _count } do {
		private["_entry"];
		_entry = _data select _i;
		
		[_entry, _object] spawn stats_compile_entry;
		
		if (_loading) then {
			[format["Initializing %1/%2 client stats ... ", (_i + 1), (count _data)]] call stats_client_update_loading_title;
		};
		
		if (_sequential) then {
			//uses a time-out approach as opposed to just "CALLING" stats_compile_entry
			//this is so that compilation errors of a single stat entry do not affect compliation
			//of all other stats ... since the error happens in a separate thread
			[_entry, _object, 0.2] call stats_wait_entry;
		};
		_i = _i + 1;
	};
};


stats_wait_entry = {
	private["_entry", "_object", "_timeout"];
	_entry = _this select 0;
	_object = _this select 1;
	_timeout = _this select 2;
	
	if (isNil "_entry") exitWith {};
	if (typeName _entry !="ARRAY") exitWith {};
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	if (isNull _object) exitWith {};
	if (isNil "_timeout") exitWith {};
	if (typeName _timeout != "SCALAR") exitWith {};
	
	private["_end_time"];
	_end_time = serverTime + 1;
	private["_variable_name"];
	_variable_name = _entry select 0;
	
	while {true} do {
		private["_variable_value"];
		_variable_value = _object getVariable _variable_name;
		if (not(isNil "_variable_value")) exitWith {};
		if (_end_time < serverTime) exitWith {
			private["_message"];
			_message = format["WARNING: Time-out occurred while initializing %1", _variable_name];
			player groupChat _message;
			diag_log _message;
		};
	};
};

stats_update_variables_list = {
	private["_object", "_variable_name"];
	_object = _this select 0;
	_variable_name = _this select 1;
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	if (isNil "_variable_name") exitWith{};
	if (typeName _variable_name != "STRING") exitWith {};
	
	private["_variables_list"];
	_variables_list = [_object] call stats_get_variables_list;
	
	if (not(_variable_name in _variables_list)) then {
		_variables_list = _variables_list + [_variable_name];
		[_object, _variables_list] call stats_set_variables_list;
	};
};

stats_set_variables_list = {
	private["_object", "_variables_list"];
	_object = _this select  0;
	_variables_list = _this select 1;
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	if (isNil "_variables_list") exitWith {};
	if (typeName _variables_list != "ARRAY") exitWith {};

	_object setVariable ["stats_variables_list", _variables_list];
};

stats_get_variables_list = {
	private["_player"];
	_player = _this select 0;
	if (isNil "_player") exitWith {};
	if (typeName _player != "OBJECT") exitWith {};
	
	private["_variables_list"];
	_variables_list = _player getVariable "stats_variables_list";
	_variables_list = if (isNil "_variables_list") then {[]} else {_variables_list};
	_variables_list = if (typeName _variables_list != "ARRAY") then {[]} else {_variables_list};
	_variables_list	
};

stats_copy_variables = {
	private["_old_player", "_new_player"];
	_old_player = _this select 0;
	_new_player = _this select 1;
	
	if (isNil "_old_player") exitWith {};
	if (typeName _old_player != "OBJECT") exitWith {};
	if (isNil "_new_player") exitWith {};
	if (typeName _new_player != "OBJECT") exitWith {};
	
	private["_variables_list"];
	_variables_list = [];
	_variables_list = [_old_player] call stats_get_variables_list;
	
	diag_log format["StatsCopy: Starting"];
	
	{
		private["_variable_name", "_variable_value"];
		_variable_name = _x;
//		_variable_value = _old_player getVariable _variable_name;
//		_new_player setVariable [_variable_name, _variable_value, true];

//		diag_log format["StatsCopy: %1", _variable_name];
		
		if (isNil{_old_player getVariable _variable_name}) then {
//				diag_log "Value nil";
			}else{
//				diag_log "Value exists";
				_variable_value = _old_player getVariable _variable_name;
				_new_player setVariable [_variable_name, _variable_value, true];
			};
		
//		diag_log "";
	} forEach _variables_list;
	
	
//	diag_log format["StatsCopy: Ending"];
	
	[_new_player, _variables_list] call stats_set_variables_list;
};


stats_compile_entry = {
	private["_entry", "_object"];
	
	_entry = _this select 0;
	_object = _this select 1;
	
	if (isNil "_entry") exitWith {};
	if (typeName _entry != "ARRAY") exitWith {};
	if (count _entry != 2) exitWith {};
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	
	private["_name", "_value"];
	
	_name = _entry select 0;
	_value = _entry select 1;
	_value = (call compile _value) select 0;
	
	[_object, _name, _value] call stats_init_entry;
};



stats_init_entry = {
	private["_object", "_variable", "_value"];
	
	_object = _this select 0;
	_variable = _this select 1;
	_value = _this select 2;
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	if (isNil "_variable") exitWith {};
	if (typeName _variable != "STRING") exitWith {};

	
	//check if it already has a value
	if ((_object == player) || (_object == server)) then {
		private["_current_value"];
		_current_value = missionNameSpace getVariable _variable;
		if (not(isNil "_current_value")) exitWith {};
		missionNamespace setVariable [_variable, _value];
		_object setVariable [_variable, _value, true];
		//diag_log format["%1, %2 = %3", _object, _variable, _value];
	}
	else {
		_object setVariable [_variable, _value, true];
	};
	
	[_object, _variable] call stats_update_variables_list;
};


stats_init_variable = {
	private["_variable", "_value"];
	_variable = _this select 0;
	_value = _this select 1;
	[player, _variable, _value] call stats_init_entry;
};


stats_loading_progress = 0;
stats_client_start_loading = {
	startLoadingScreen["" , "customLoadingScreen"];
};

stats_client_stop_loading = {
	endLoadingScreen;
};

stats_client_update_loading_title = {
	private["_title"];
	
	_title = _this select 0;
	if (isNil "_title") exitWith {};
	if (typeName _title != "STRING") exitWith {};
	
//	startLoadingScreen[_title , "customLoadingScreen"];
//	[stats_loading_progress] call stats_client_update_loading_progress;
	
	((uiNamespace getVariable 'DFML_LOAD') displayCtrl loadingTitle_idc) ctrlSetText _title;
};


stats_client_update_loading_progress = {
	private["_progress"];
	
	_progress = _this select 0;
	
	if (isNil "_progress") exitWith{};
	if (typeName _progress != "SCALAR") exitWith {};
	if (_progress < 0 || _progress > 1) exitWith {};
	
	stats_loading_progress = _progress;
	progressLoadingScreen _progress;
};


stats_get_mission_variable = {
	private["_variableName"]; 
	_variableName = _this select 0;
	if (isNil "_variableName") exitWith {nil};
	if (typeName _variableName != "STRING") exitWith {nil};
	private["_variable"];
	_variable = missionNamespace getVariable _variableName;
	if (isNil "_variable") exitWith {nil};
	_variable
};

stats_server_wipe_player_data = {
	private["_player_variable","_player"]; 
	_player_variable = _this select 0;
	_player = [_player_variable] call stats_get_mission_variable;
	if (isNil "_player") exitWith {};
	
	private["_uid"];
	_uid = [_player] call stats_get_uid;
	if (isNil "_uid") exitWith {};
	[_uid] call wipePlayerVariables;
};

stats_server_wipe_all_data = {
	call wipeAllPlayerVariables;
};

stats_client_wait_uid = {
	private["_uid"];
	
	//work-around cannot do waitUtil in preloading screen
	while {true} do {
		_uid = [player] call stats_get_uid;
		if (_uid != "") exitWith {};
		uiSleep 0.1;
	};
	
	_uid
};


stats_client_setup = {
	call stats_client_start_loading;
	["Waiting for server initialization ... "] call stats_client_update_loading_title;
	[0.2] call stats_client_update_loading_progress;
	[] call stats_client_server_setup_wait;
	[] call music_play_random;
	uiSleep 1;
	
	["Waiting for player uid ... "] call stats_client_update_loading_title;
	[0.4] call stats_client_update_loading_progress;
	uiSleep 1;
	
	private["_uid"];
	_uid = [] call stats_client_wait_uid;
	
	["Fetching client stats from server ... "] call stats_client_update_loading_title;
	[0.6] call stats_client_update_loading_progress;
	uiSleep 1;
	private["_data"];
	_data = [_uid] call stats_load_request_send;
	
	[format["Initializing %1 client stats ... ", (count _data)]] call stats_client_update_loading_title;
	[0.8] call stats_client_update_loading_progress;
	uiSleep 1;
	[_data, player] call stats_compile_loading;
	
	[format["Restoring client continuity ... "]] call stats_client_update_loading_title;
	[0.9] call stats_client_update_loading_progress;
	uiSleep 1;
	[] call stats_load_core_libraries;
	[] call player_continuity;

	["Client stats setup complete ... "] call stats_client_update_loading_title;
	[1] call stats_client_update_loading_progress;
	uiSleep 1;
	call stats_client_stop_loading;
};

stats_setup = {
	if (isServer) then {
		[] call stats_server_setup;
	};
	
	if (isClient) then {
		[] call stats_client_setup;
	};
};

[] call stats_setup;

stats_functions_defined =  true;