if (not(isNil "faction_time_functions_loaded")) exitWith {};

//Settings (time in sec)

//Variable (side) = time in hours * 3600
ftf_opf_playtime = 12*3600;
ftf_cop_playtime = 12*3600;
ftf_ins_playtime = 12*3600;


ftf_connected = {
	//Trigger on connected
	private["_timearray", "_playeruid"];
	_playeruid = _this select 0;
	_timearray = server getVariable "player_time_array";
	if (isNil "_timearray") exitWith {
		diag_log format["[ERROR]: FTF_CONNECTED - _timearray = nil"];
	};
	if (isNil "_playeruid") exitWith {
		diag_log format["[ERROR]: FTF_CONNECTED - _playeruid = nil"];
	};
	if (typeName _timearray != "ARRAY") exitWith {
		diag_log format["[ERROR]: FTF_CONNECTED - _timearray != ARRAY"];
	};
	
	_timearray set [(count _timearray), [_playeruid, serverTime]];
	server setVariable["player_time_array", _timearray, true];
};

ftf_disconnected = {
	private["_timearray", "_uid", "_leavetime", "_playtime", "_player"];
	_uid = _this select 0;
	_player = _this select 1;
	_timearray = server getVariable ["player_time_array", nil];
	
	if (isNil "_timearray") exitWith {
		diag_log format["[ERROR]: FTF_DISCONNECTED - _timearray = nil"];
	};
	if (isNil "_uid") exitWith {
		diag_log format["[ERROR]: FTF_DISCONNECTED - _uid = nil"];
	};
	if (isNil "_player") exitWith {
		diag_log format["[ERROR]: FTF_DISCONNECTED - _player = nil"];
	};
	
	_leavetime = serverTime;
	
	private["_jointime", "_i"];
	_i = 0;
	{
		if ((_x select 0) == _uid) exitWith {
			_jointime = _x select 1;
			_timearray set [_i, "remove"];
			_timearray = _timearray - ["remove"];
		};
		_i = _i + 1;
	} foreach _timearray;
	if (isNil "_timearray") then {_timearray = [];};
	if (isNil "_jointime") exitWith {
		diag_log format["[ERROR]: FTF_DISCONNECTED - No jointime: %1",_timearray];
	};
	server setVariable["player_time_array", _timearray, true];
	_playtime = _leavetime - _jointime;
	if (_playtime <= 0) exitWith {};
	[_player, "playtime", _playtime] call player_update_scalar;
};

ftf_faction_allowed = {
	private["_player", "_faction", "_uid"];
	_player = _this select 0;
		
	if (isNil "_player") exitWith {false};
	if (not([_player] call player_human)) exitWith {false};
	_uid = getPlayerUID _player;
	if ((_uid in donators3) or (_uid in donators4) or ((getPlayerUID _player) in A_LIST_ADMINS)) exitWith {true};
	
	if (isNil "playtime") then (
		playtime = _player getVariable ["playtime", 0];
	};
		
	if (isCiv) exitWith {true};
	if ((isOpf) and (playtime < ftf_opf_playtime)) exitWith {false};
	if ((isCop) and (playtime < ftf_cop_playtime)) exitWith {false};
	if ((isIns) and (playtime < ftf_ins_playtime)) exitWith {false};	
	
	true
	
};

ftf_init_server = {
	if (not(isServer)) exitWith {};
	server setVariable ["player_time_array", [], true];
};

[] call ftf_init_server;

faction_time_functions_loaded = true;