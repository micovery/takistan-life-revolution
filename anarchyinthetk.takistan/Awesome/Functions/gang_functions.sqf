if (not(isNil "gang_functions_defined")) exitWith {};

gang_id = 0;
gang_name = 1;
gang_members = 2;
gang_open = 3;
gang_group = 4;

gangs_get_list = {
	private["_gangs_list"];
	_gangs_list = server getVariable "gangs_list";
	if (isNil "_gangs_list") exitWith {[]};
	if (typeName _gangs_list != "ARRAY") exitWith {[]};
	(_gangs_list)
};

gangs_set_list = {
	private["_gangs_list"];
	_gangs_list = _this select 0;
	if (isNil "_gangs_list") exitWith {};
	if (typeName _gangs_list != "ARRAY") exitWith {};
	server setVariable ["gangs_list", _gangs_list, true];
};

gangs_update_list = {
	private["_gang"];
	_gang = _this select 0;
	if (isNil "_gang") exitWith {};
	if (typeName _gang != "ARRAY") exitWith {};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	private["_gang_id", "_gang_index"];
	_gang_id = _gang select gang_id;
	_gang_index = [_gang_id] call gangs_id_2_index;
		
	if (_gang_index == -1) then {
		_gangs_list = _gangs_list + [_gang];
	}
	else {
		_gangs_list set [_gang_index, _gang];
	};

	[_gangs_list] call gangs_set_list;
};

gangs_lookup_id = {
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {nil};
	if (typeName _gang_id != "STRING") exitWith {nil};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	private["_gang"];
	_gang = nil;
	{
		private["_cgang", "_cgang_id"];
		_cgang = _x;
		_cgang_id = _cgang select gang_id;
		if (_cgang_id == _gang_id) exitWith {
			_gang = _cgang;
		};
	} forEach _gangs_list;
	
	(_gang)
};

gangs_lookup_name = {
	private["_gang_name"];
	_gang_name = _this select 0;
	if (isNil "_gang_name") exitWith {nil};
	if (typeName _gang_name != "STRING") exitWith {nil};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	private["_gang"];
	_gang = nil;
	{
		private["_cgang", "_cgang_name"];
		_cgang = _x;
		_cgang_name = _cgang select gang_name;
		if (_cgang_name == _gang_name) exitWith {
			_gang = _cgang;
		};
	} forEach _gangs_list;
	
	(_gang)
};

gangs_uids_2_names = {
	private["_uids_list"];
	_uids_list = _this select 0;
	if (isNil "_uids_list") exitWith {[]};
	if (typeName _uids_list != "ARRAY") exitWith {[]};
	
	private["_names", "_players"];
	_names = [];
	_players = [_uids_list] call gangs_uids_2_players;
	
	private["_i"];
	_i = 0;
	while {_i < (count _players) } do {
		private["_player", "_player_name"];
		_player = _players select _i;
		_name = (name _player);
		_names = _names + [_name];
		_i = _i + 1;
	};
	
	(_names)
};



gangs_uids_2_players = {
	private["_uids_list"];
	_uids_list = _this select 0;
	if (isNil "_uids_list") exitWith {[]};
	if (typeName _uids_list != "ARRAY") exitWith {[]};
	
	private["_players"];
	_players = [];
	
	private["_i"];
	_i = 0;
	while {_i < (count _uids_list)} do { 
		private["_uid"];
		_uid = _uids_list select _i;
		private["_player"];
		_player = [_uid] call player_lookup_gang_uid;
		if (not(isNil "_player")) then {
			_players = _players + [_player];
		};
		_i = _i + 1;
	};
	
	(_players)
};

gangs_lookup_player_name = {
	private["_player_name"];
	_player_name = _this select 0;
	if (isNil "_player_name") exitWith {nil};
	if (typeName _player_name != "STRING") exitWith {};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	private["_gang"];
	_gang = nil;
	{
		private["_cgang", "_cgang_members"];
		_cgang = _x;
		_cgang_members = _cgang select gang_members;
		
		private["_names"];
		_uids_list = _cgang_mambers;
		_names = [_cgang_mambers] call gangs_uids_2_names;
		
		if (_player_name in _names) exitWith {
			_gang = _cgang;
		};		
	} forEach _gangs_list;
	
	(_gang)
};


gangs_lookup_player_uid = {
	private["_player_uid"];
	_player_uid = _this select 0;
	if (isNil "_player_uid") exitWith {nil};
	if (typeName _player_uid != "STRING") exitWith {};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	private["_gang"];
	_gang = nil;
	{
		private["_cgang", "_cgang_members"];
		_cgang = _x;
		_cgang_members = _cgang select gang_members;
		
		private["_uids_list"];
		_uids_list = _cgang_members;
		
		if (_player_uid in _uids_list) exitWith {
			_gang = _cgang;
		};
	} forEach _gangs_list;
	
	(_gang)
};

gangs_id_2_index = {
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {-1};
	if (typeName _gang_id != "STRING") exitWith {-1};
	
	private["_i", "_gangs_list", "_gang_index"];
	_i = 0;
	_gang_index = -1;
	_gangs_list = call gangs_get_list;
	while { _i < (count _gangs_list) } do {
		private["_cgang", "_cgang_id"];
		_cgang = _gangs_list select _i;
		_cgang_id = _cgang select gang_id;
		if (_cgang_id == _gang_id) exitWith {
			_gang_index = _i;
		};
		_i = _i + 1;
	};
	
	(_gang_index)
};

gangs_delete_id = {
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	private["_gang", "_gang_index"];
	_gang_index = [_gang_id] call gangs_id_2_index;
	if (_gang_index < 0) exitWith {};
	
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	_gangs_list set [_gang_index, 0];
	_gangs_list = _gangs_list - [0];
	[_gangs_list] call gangs_set_list;
};

gang_player_disconnected = {
	player groupChat format["gang_player_disconnected %1", _this];
	private["_player", "_gang_player_uid"];
	_player = _this select 0;
	_gang_player_uid = [_player] call gang_player_uid;
	
	private["_gang"];
	_gang = [_gang_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {};
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	
	[_gang_id, _gang_player_uid] call gang_remove_member;
};

gang_update_leader = {
	if (not(isServer)) exitWith {};
	
	player groupChat format["gang_update_leader %1", _this];
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	private["_leader_uid"];
	_leader_uid = [_gang_id] call gang_leader_uid;
	
	private["_leader"];
	_leader = [_leader_uid] call player_lookup_gang_uid;
	
	private["_i", "_member_uids", "_members", "_group"];
	_member_uids = _gang select gang_members;
	_group = _gang select gang_group;
	
	
		
	_members = [_member_uids] call gangs_uids_2_players;
	if (count _members > 0) then {
		_members joinSilent _group;
	};
	
	if ([_leader] call player_exists) then {
		player groupChat format["making %1 leader of %2", _leader, _group];
		_group selectLeader _leader;
	};
	
};

gang_player_uid = {
	(_this call stats_get_player_uid)
};

gang_schedule_deletion = { _this spawn {
	if (not(isServer)) exitWith {};
	player groupChat format["gang_schedule_deletion %1", _this];
	
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	private["_wait_time"];
	_wait_time = gangdeltime;
	//player groupChat format["Waiting for %1 seconds to delete %2", _wait_time, _gang_id];
	[_wait_time] call isleep;
	//player groupChat format["Waiting to delete %1 compelete", _gang_id];
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	//some-one else has joined the gang while it was scheduled for deletion
	private["_gang_members"];
	_gang_members = _gang select gang_members;
	if (count(_gang_members) > 0) exitWith {};
	
	[_gang_id] call gangs_delete_id;
};};

gangs_calculate_income = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};
	
	private["_gang", "_player_uid", "_extra"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {0};
	
	_extra = 0;

	private["_member_uids", "_active_members", "_active_members_count"];
	_member_uids = _gang select gang_members;
	_active_members = [_member_uids] call gangs_uids_2_players;
	_active_members_count = count(_active_members);
	if (_active_members_count == 0) exitWith {0};
	
	private["_base_extra", "_gang_id"];
	_base_extra = (gangincome / _active_members_count);
	_gang_id = _gang select gang_id;
	
	{if (true) then {
		private["_gang_area", "_cgang_id"];
		_gang_area = _x;
		_cgang_id = _gang_area getVariable "control";
		if (isNil "_cgang_id") exitWith {};
		if (typeName _cgang_id != "STRING") exitWith {};
		if (not(_cgang_id == _gang_id)) exitWith {};
		
		_extra = _extra + _base_extra;
	}} forEach gangareas;
	
	_extra = round(_extra);
	(_extra)
};

gang_area_set_control = {
	private["_gang_area", "_gang_id"];
	_gang_area = _this select 0;
	_gang_id = _this select 1;

	if (isNil "_gang_area") exitWith {};
	if (typeName _gang_area != "OBJECT") exitWith {};
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	_gang_area setVariable ["control", _gang_id, true];
};

gang_area_get_control = {
	private["_gang_area"];
	_gang_area = _this select 0;
	if (isNil "_gang_area") exitWith {""};
	if (typeName _gang_area != "OBJECT") exitWith {""};
	
	private["_control"];
	_control = _gang_area getVariable "control";
	if (isNil "_control") exitWith {""};
	if (typeName _control != "STRING") exitWith {""};
	_control
};

gang_area_clear_control = {
	private["_gang_area"];
	_gang_area = _this select 0;
	([_gang_area, ""] call gang_area_set_control)
};

gang_area_owned = {
	private["_player", "_gang_area"];
	_player = _this select 0;
	_gang_area = _this select 1;
	if (not([_player] call player_human)) exitWith {false};
	
	private["_gang", "_player_uid"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {false};
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	
	private["_control"];
	_control = [_gang_area] call gang_area_get_control;

	(_control == _gang_id)
};

gang_area_neutral = {
	private["_gang_area"];
	_gang_area = _this select 0;
	
	private["_control"];
	_control = [_gang_area] call gang_area_get_control;
	(_control == "")
};


gang_area_player_near = {
	//player groupChat format["gang_area_player_near %1", _this];
	private["_player", "_distance"];
	_player = _this select 0;
	_distance = _this select 1;
	
	if (not([_player] call player_exists)) exitWith {nil};
	if (isNil "_distance") exitWith {nil};
	if (typeName _distance != "SCALAR") exitWith {nil};
	
	private["_min_distance", "_min_gang_area"];
	_min_distance = _distance;
	_min_gang_area = nil;
	
	{
		private["_cgang_area", "_cdistance"];
		_cgang_area = _x;
		_cdistance = _player distance _cgang_area;
		if (_cdistance < _min_distance) then {
			_min_distance = _cdistance;
			_min_gang_area = _cgang_area;
		};
	} forEach gangareas;

	_min_gang_area
};


gang_area_action_text = 0;
gang_area_action_code = 1;
gang_area_action_condition = 2;

gang_area_actions_setup = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	//Setup actions for Gang Area 1
	private["_ga1_actions", "_ga1_lsd_action", "_ga1_cocaine_action", 
			"_ga1_capture_action", "_ga1_neutralise_action", 
			"_ga1_shop_action"];

	_ga1_actions  = [];
	_ga1_lsd_action = [];
	_ga1_lsd_action set [gang_area_action_text, "Process LSD"];
	_ga1_lsd_action set [gang_area_action_code,  format['[%1, "Unprocessed_LSD", "lsd", 5] call interact_item_process;', _player]];
	_ga1_lsd_action set [gang_area_action_condition, format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea1, "lsd ga1"]];
	
	_ga1_cocaine_action = [];
	_ga1_cocaine_action set [gang_area_action_text, "Process Cocaine"];
	_ga1_cocaine_action set [gang_area_action_code,  format['[%1, "Unprocessed_Cocaine", "cocaine", 5] call interact_item_process;', _player]];
	_ga1_cocaine_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea1, "cocaine ga1"]
	];
	
	_ga1_capture_action = [];
	_ga1_capture_action set [gang_area_action_text, "Capture"];
	_ga1_capture_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_capture;', _player, gangarea1]];
	_ga1_capture_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%2] call gang_area_neutral) && not(gang_animation)', _player, gangarea1]
	];
	
	_ga1_neutralise_action = [];
	_ga1_neutralise_action set [gang_area_action_text, "Neutralise"];
	_ga1_neutralise_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_neutralise;',_player, gangarea1]];
	_ga1_neutralise_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && not([%2] call gang_area_neutral) && not([%1, %2] call gang_area_owned) && not(gang_animation)', _player, gangarea1]
	];
	
	_ga1_shop_action = [];
	_ga1_shop_action set [gang_area_action_text, "Gang Shop"];
	_ga1_shop_action set [gang_area_action_code,  format['[(%1 call INV_GetShopNum)] call shop_open_dialog;', gangarea1]];
	_ga1_shop_action set [gang_area_action_condition, format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned)', _player, gangarea1]];
	
	_ga1_actions = [_ga1_lsd_action, _ga1_cocaine_action, _ga1_capture_action, _ga1_neutralise_action, _ga1_shop_action];
	gangarea1 setVariable ["actions", _ga1_actions];
	
	//Setup actions for Gang Area 2
	private["_ga2_actions", "_ga2_lsd_action", "_ga2_heroin_action", 
			"_ga2_capture_action", "_ga2_neutralise_action", 
			"_ga2_shop_action"];

	_ga2_actions  = [];
	_ga2_lsd_action = [];
	_ga2_lsd_action set [gang_area_action_text, "Process LSD"];
	_ga2_lsd_action set [gang_area_action_code,  format['[%1, "Unprocessed_LSD", "lsd", 5] call interact_item_process;', _player]];
	_ga2_lsd_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea2, "lsd ga2"]
	];
	
	_ga2_heroin_action = [];
	_ga2_heroin_action set [gang_area_action_text, "Process Heroin"];
	_ga2_heroin_action set [gang_area_action_code,  format['[%1, "Unprocessed_Heroin", "heroin", 5] call interact_item_process;', _player]];
	_ga2_heroin_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea2, "heroin ga2"]
	];
	
	_ga2_capture_action = [];
	_ga2_capture_action set [gang_area_action_text, "Capture"];
	_ga2_capture_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_capture;', _player, gangarea2]];
	_ga2_capture_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) &&  ([%2] call gang_area_neutral) && not(gang_animation)', _player, gangarea2]
	];
	
	_ga2_neutralise_action = [];
	_ga2_neutralise_action set [gang_area_action_text, "Neutralise"];
	_ga2_neutralise_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_neutralise;', _player, gangarea2]];
	_ga2_neutralise_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) &&  not([%2] call gang_area_neutral) && not([%1, %2] call gang_area_owned) && not(gang_animation)', _player, gangarea2]
	];
	
	_ga2_shop_action = [];
	_ga2_shop_action set [gang_area_action_text, "Gang Shop"];
	_ga2_shop_action set [gang_area_action_code,  format['[(%1 call INV_GetShopNum)] call shop_open_dialog;', gangarea2]];
	//player groupChat format["GA2: %1", format['[(%1 call INV_GetShopNum)] call shop_open_dialog;', gangarea2]];
	_ga2_shop_action set [gang_area_action_condition, format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned)', _player, gangarea2]];
	
	_ga2_actions = [_ga2_lsd_action, _ga2_heroin_action, _ga2_capture_action, _ga2_neutralise_action, _ga2_shop_action];
	gangarea2 setVariable ["actions", _ga2_actions];
	
	//Setup Actions for Gang Area 3
	private["_ga3_actions", "_ga3_marijuana_action", "_ga3_heroin_action", 
			"_ga3_capture_action", "_ga3_neutralise_action", 
			"_ga3_shop_action"];

	_ga3_actions  = [];
	_ga3_marijuana_action = [];
	_ga3_marijuana_action set [gang_area_action_text, "Process Marijuana"];
	_ga3_marijuana_action set [gang_area_action_code,  format['[%1, "Unprocessed_Marijuana", "marijuana", 5] call interact_item_process;', _player]];
	_ga3_marijuana_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea3, "marijuana ga3"]
	];
	
	_ga3_heroin_action = [];
	_ga3_heroin_action set [gang_area_action_text, "Process Heroin"];
	_ga3_heroin_action set [gang_area_action_code,  format['[%1, "Unprocessed_Heroin", "heroin", 5] call interact_item_process;', _player]];
	_ga3_heroin_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned) && ([%1, "%3"] call player_has_license)', _player, gangarea3, "heroin ga3"]
	];
	
	_ga3_capture_action = [];
	_ga3_capture_action set [gang_area_action_text, "Capture"];
	_ga3_capture_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_capture;', _player, gangarea3]];
	_ga3_capture_action set [gang_area_action_condition, format['([%1] call player_gang_member) && ([%2] call gang_area_neutral) && not(gang_animation)',_player, gangarea3]];
	
	_ga3_neutralise_action = [];
	_ga3_neutralise_action set [gang_area_action_text, "Neutralise"];
	_ga3_neutralise_action set [gang_area_action_code,  format['[%1, %2] call interact_gang_area_neutralise;', _player,gangarea3]];
	_ga3_neutralise_action set 
	[
		gang_area_action_condition, 
		format['([%1] call player_gang_member) && not([%2] call gang_area_neutral) && not([%1, %2] call gang_area_owned) && not(gang_animation)',_player, gangarea3]
	];
	
	_ga3_shop_action = [];
	_ga3_shop_action set [gang_area_action_text, "Gang Shop"];
	_ga3_shop_action set [gang_area_action_code,  format['[(%1 call INV_GetShopNum)] call shop_open_dialog;', gangarea3]];
	_ga3_shop_action set [gang_area_action_condition, format['([%1] call player_gang_member) && ([%1, %2] call gang_area_owned)',_player, gangarea3]];
	
	_ga3_actions = [_ga3_marijuana_action, _ga3_heroin_action, _ga3_capture_action, _ga3_neutralise_action, _ga3_shop_action];
	gangarea3 setVariable ["actions", _ga3_actions];
};

gang_area_actions = [];
gang_area_add_actions = {
	if (count gang_area_actions > 0) exitWith {};
	private["_player", "_gang_area"];
	_player = _this select 0;
	_gang_area = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_gang_area") exitWith {};
	if (typeName _gang_area != "OBJECT") exitWith {};
	
	
	private["_actions"];
	_actions = _gang_area getVariable "actions";
	if (not(isNil "_actions")) then {
		if (typeName _actions != "ARRAY") exitWith {};
		{
			private["_action", "_action_text", "_action_code", "_action_condition"];
			_action = _x;
			_action_text = _action select gang_area_action_text;
			_action_code = _action select gang_area_action_code;
			_action_condition = _action select gang_area_action_condition;
			
			private["_action_id"];
			_action_id = _player addAction [_action_text, "noscript.sqf", _action_code,1, false,true,"", _action_condition];
			gang_area_actions = gang_area_actions + [_action_id];
		} forEach _actions;
	};
};

gang_area_remove_actions = {
	if (count gang_area_actions == 0) exitWith {};
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	{
		private["_action_id"];
		_action_id = _x;
		_player removeAction _action_id;
	} forEach gang_area_actions;
	gang_area_actions = [];
};

gang_generate_id = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {nil};
	
	private["_uid"];
	_uid = [_player] call gang_player_uid;
	
	private["_restart_count", "_gang_id"];
	_restart_count = server getVariable "restart_count";
	_gang_id = format["gang_%1_%2_%3", _uid, _restart_count, round(time)];
	(_gang_id)
};

gang_create = {
	if (not(isServer)) exitWith {};
	
	private["_player", "_name"];
	_player = _this select 0;
	_name = _this select 1;
	if (not([_player] call player_human)) exitWith {nil};
	if (isNil "_name") exitWith {nil};
	if (typeName _name != "STRING") exitWith {nil};
	
	private["_gang","_gang_id", "_gang_group"];
	_gang = [];
	_gang_id = [_player] call gang_generate_id;
	
	private["_side"];
	_side = [_player] call player_side;
	_gang_group = [_side, nil] call gang_recreate_group;
		
	[_player] joinSilent _gang_group;
	
	_gang set [gang_id, _gang_id];
	_gang set [gang_name, _name];
	_gang set [gang_members, [([_player] call gang_player_uid)]];
	_gang set [gang_open, true];
	_gang set [gang_group, _gang_group];
	
	[_gang] call gangs_update_list;
};

gang_recreate_group = {
	private["_side", "_group"];
	_side = _this select 0;
	_group = _this select 1;
	if (isNil "_side") exitWith {grpNull};
	if (typeName _side != "SIDE") exitWith {grpNull};
	
	private["_original_group"];
	_original_group = _group;
	
	_group = if (isNil "_group") then {createGroup _side} else {_group};
	_group = if (typeName _group != "GROUP") then {createGroup _side} else {_group};
	_group = if (isNull _group) then {createGroup _side} else {_group};
	
	player groupChat format["_original_group = %1, _group = %2", _original_group, _group];
	
	(_group)
};

gang_add_member = { _this spawn {
	if (not(isServer)) exitWith {};
	private["_gang_id", "_player"];
	_gang_id = _this select 0;
	_player = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	private["_player_uid"];
	[_player, (group _player)] call player_set_saved_group;
	_player_uid = [_player] call gang_player_uid;
	
	private["_side"];
	_side = [_player] call player_side;
	
	private["_members", "_group"];
	_group = _gang select gang_group;
	//recreate the group if it does not exist
	_group = [_side, _group] call gang_recreate_group;
	_gang set [gang_group, _group];
	
	_members = _gang select gang_members;
	_members = _members + [_player_uid];
	_gang set [gang_members, _members];
	[_gang] call gangs_update_list;
	
	sleep 1;
	[_player]  joinSilent _group;
	sleep 1;
	[_gang_id] call gang_update_leader;
};};

gang_restore_member_group = {
	private["_member_uid"];
	_member_uid = _this select 0;
	
	private["_member"];
	_member = [_member_uid] call player_lookup_gang_uid;
	if (isNil "_member") exitWith {};
	
	private["_side"];
	_side = [_member] call player_side;
	_group = [_member] call player_get_saved_group;
	
	//recreate the group if it does not exist
	_group = [_side, _group] call gang_recreate_group;
	
	[_member] joinSilent _group;
	_group selectLeader _member;
};

gang_remove_member = { _this spawn {
	if (not(isServer)) exitWith {};
	private["_gang_id", "_member_uid"];
	_gang_id = _this select 0;
	_member_uid = _this select 1;
	if (isNil "_member_uid") exitWith {};
	if (typeName _member_uid != "STRING") exitWith {};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	

	
	private["_members"];
	_members = _gang select gang_members;
	_members = _members - [_member_uid];
	_gang set[gang_members, _members];
	
	if ((count _members) == 0) then {
		_gang set [gang_open, true];
		format['["%1"] call gang_schedule_deletion;', _gang_id] call broadcast;
	};
	
	[_gang] call gangs_update_list;
	sleep 1;
	
	[_gang_id] call gang_update_leader;
	sleep 1;
	
	[_member_uid] call gang_restore_member_group;
};};

gang_make_leader = { _this spawn {
	if (not(isServer)) exitWith {};
	
	private["_gang_id", "_member_uid"];
	_gang_id = _this select 0;
	_member_uid = _this select 1;
	if (isNil "_member_uid") exitWith {};
	if (typeName _member_uid != "STRING") exitWith {};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	private["_members"];
	_members = _gang select gang_members;
	_members = _members - [_member_uid];
	_members = [_member_uid] + _members;
	_gang set[gang_members, _members];
	
	[_gang] call gangs_update_list;
	sleep 1;
	
	[_gang_id] call gang_update_leader;
	
};};


gang_leader_uid = {
	private["_gang_id"];
	_gang_id = _this select 0;
	if (isNil "_gang_id") exitWith {""};
	if (typeName _gang_id != "STRING") exitWith {""};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {""};
	
	private["_gang_members"];
	_gang_members = _gang select gang_members;
	if (count (_gang_members) == 0) exitWith {""};
	
	private["_leader_uid"];
	_leader_uid = _gang_members select 0;
	(_leader_uid)
};

gang_flag_add_position = {
	_pos1 = _this select 0;
	_pos2 = _this select 1;
	[(_pos1 select 0) + (_pos2 select 0), (_pos1 select 1) + (_pos2 select 1), (_pos1 select 2) + (_pos2 select 2)]
};

gang_flag_get_offset = {
	private ["_anchor", "_banner", "_old_offset"];
	
	_anchor = _this select 0;
	_banner = _anchor  getVariable "banner";
	if (isNil "_banner") exitWith { nil};
	
	_old_offset = _banner getVariable "offset";
	_old_offset
};

gang_flag_set_offset = {
	private ["_anchor", "_offset", "_banner", "_old_offset", "_new_offset"];
	
	_anchor = _this select 0;
	_offset = _this select 1;
	
	_banner = _anchor  getVariable "banner";
	_old_offset = _banner getVariable "offset";
	_new_offset = [_old_offset, _offset] call gang_flag_add_position;
	
	_banner attachTo [_anchor, _new_offset];
	_banner setVariable ["offset", _new_offset, true];
	_new_offset
};

gang_flag_reset_offset = {
	private ["_anchor", "_offset", "_banner", "_old_offset", "_new_offset"];
	
	_anchor = _this select 0;
	_offset = _this select 1;
	
	_banner = _anchor  getVariable "banner";
	_banner attachTo [_anchor, _offset];
	_banner setVariable ["offset", _offset, true];
	_offset
};

gang_flag_setup = {
	private ["_banner", "_anchor"];
	
	_anchor = _this select 0;
	_banner = _anchor getVariable "banner";
	
	if (isNil "_banner") then {
		_banner = createVehicle ["FlagCarrierTKMilitia_EP1", getpos _anchor, [], 0, "CAN_COLLIDE"];
		_anchor setVariable ["banner", _banner, true];
		_offset = [0,0,-7.5];
		_banner attachTo [_anchor,_offset];
		_banner setVariable ["offset", _offset, true];	
	};
};

gangs_loop_iteration = {
	//player groupChat format["gangs_loop_iteration"];
	private["_player"];
	_player = player;

	{if (true) then {
		private["_gang_area"];
		_gang_area = _x;
		
		private["_cgang_id", "_gang", "_player_uid"];
		_cgang_id  = [_gang_area] call gang_area_get_control;
		_player_uid = [_player] call gang_player_uid;
		_gang = [_player_uid] call gangs_lookup_player_uid;
		
		if (isNil "_gang") exitWith {};
		private["_gang_id"];
		_gang_id = _gang select gang_id;
		if (not (_gang_id == _cgang_id)) exitWith {};
		
		private["_offset"];
		_offset = [_gang_area] call gang_flag_get_offset;
		if (isNil "_offset") exitWith {};
		if (not((_player distance _gang_area) < 10 && (_offset select 2) < 0)) exitWith {};
	
		private["_new_offset"];
		_new_offset = [_gang_area, [0,0,0.1]] call gang_flag_set_offset;
		if ((_new_offset select 2) > 0) then {
			[_gang_area, [0,0,0]] call gang_flag_reset_offset;
		};
	};} forEach gangareas;
};

gangs_loop = {
	private ["_gangs_loop_i"];
	_gangs_loop_i = 0; 

	while {_gangs_loop_i < 5000} do {
		[] call gangs_loop_iteration;
		_gangs_loop_i = _gangs_loop_i + 1;
	};
	
	[] spawn gangs_loop;
};

[] spawn gangs_loop;
[player] call gang_area_actions_setup;

gang_functions_defined = true;