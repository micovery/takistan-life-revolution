player_get_player_by_name = {
	private["_name", "_player"];
	_name = _this select 0;
	if (isNil "_name") exitWith {nil};
	if (typeName _name != "STRING") exitWith {nil};

	_player = nil;

	{
		private["_exit"];

		_exit = if (true) then {
			private["_cplayer", "_cname", "_cplayer_variable"];
			_cplayer_variable = _x;
			_cplayer = missionNamespace getVariable _cplayer_variable;
			if (isNil "_cplayer") exitWith {false};
			_cname = name _cplayer;
			if (_cname == _name) exitWith {
				_player = _cplayer;
				true
			};
		};
		if (_exit) exitWith {};    
	} foreach playerstringarray;
	_player
};

private["_counter", "_sleep_time"];
_counter = 0;
_sleep_time = 60;
while {true} do {

	//Go through each of the gangs
	private["_i"];
	_i = (count gangsarray) - 1;	
	while { _i >= 0 } do {
		private["_gangarray", "_members", "_gang_name"];
		
		_gangarray = gangsarray select _i;
		_gang_name = _gangarray select 0;
		_members   = _gangarray select 1;
		
		//player groupChat format["Checking Gang %1, with %2 members", _gang_name, count(_members)];
		
		//check that all the members of the gang are active, remove any that are not
		private["_j", "_original_size"];
		_original_size = count _membes;
		_j = (count _members) - 1;
		while { _j >= 0 } do {
			private["_player_name", "_player"];
			_player_name = _members select _j;
			_player = [_player_name] call player_get_player_by_name;
			if(isNil "_player" )then {
				//player groupChat format["Removing %1 from gang %2", _player_name, _gang_name];
				_members = _members - [_player_name];
				_gangarray set[1, _members];
			};
			_j = _j - 1;
		};
		
		//player groupChat format["Done Checking gang %1, now has %2 members", _gang_name, count(_members)];
		
		//if the gang member count is 0, delete it (given that the timeout has passed)
		if(_counter >= gangdeltime && (count _members) == 0) then {
			//player groupChat format["Will delete gang %1, because it has 0 members", _gang_name];
			format['
			gangsarray set[%1, 0]; 
			gangsarray = gangsarray - [0];
			', _i] call broadcast;
		}
		//If the gang member count has changed, send update it
		else { if (_original_size != (count _members)) then {
			//player groupChat format["Updating gang %1, member count changed from %1, to %2", _gang_name, _original_count, count(_members)];
			format['gangsarray set[%1, %2]', _i, _gangarray] call broadcast;
		};};
		
		_i = _i - 1;
	};
	
	if(_counter >= gangdeltime)then{
		_counter = 0
	};
	
	_counter = _counter + _sleep_time;
	sleep _sleep_time;
};
