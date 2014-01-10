if (not(isNil "faction_time_functions_loaded")) exitWith {};

//Settings (time in sec)

//Variable (side) = time in hours * 3600
//WARNING: Because of the known time problem the 4.5hr will be
//~15hr playtime in real time!

ftf_opf_playtime = 4.5*3600;
ftf_cop_playtime = 4.5*3600;
ftf_ins_playtime = 4.5*3600;

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
	
//	waitUntil{alive _player};
	
	if (isCiv) exitWith {true};
	
	//Reducing traffic by setting local if loaded
	if (isNil "ignoreFactionPlaytime") then {
		ignoreFactionPlaytime = [_player, "ignoreFactionPlaytime"] call player_get_bool;
	};
	
	if (isNil "playtime") then {
		playtime = [_player, "playtime"] call player_get_scalar;
	};
	
	//Manual overrides:
	if ((_uid in alldonators) or (_uid in A_LIST_ADMINS) or (ignoreFactionPlaytime)) exitWith {true};
	
	
	//Get side var
	private["_factionVar", "_allowed"];
	
	_factionVar = format["faction_%1_allowed", (side _player)];
	
	_allowed = [_player, _factionVar] call player_get_bool;
//	_allowed = _player getVariable [_factionVar, false];

	
	//Check if already set
	if (typeName _allowed != "BOOL") then {_allowed = false;};
	if (_allowed) exitWith {true};
	
	//Check if time is ok and set the var
	
	if (((isOpf) and (playtime < ftf_opf_playtime)) or ((isCop) and (playtime < ftf_cop_playtime)) or ((isIns) and (playtime < ftf_ins_playtime))) exitWith {
		[_player, _factionVar, true] call player_set_bool;
		(true)
	};
	false
};

ftf_init = {
	if (isServer) then {
		server setVariable ["player_time_array", [], true];
	} else {
		if (!([player] call ftf_faction_allowed)) then {
			format['Faction not allowed, kicking'] call A_DEBUG_S;
			server globalChat format["You are not allowed to play %1 faction yet. Please try again later", (side player)];
			disableuserinput true;
			sleep 5;
			disableuserinput false;
			failMission "END1";
		};
	};
};


// Moved to init
//	[] spawn ftf_init;

faction_time_functions_loaded = true;
