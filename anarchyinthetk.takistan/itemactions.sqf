private ["_counter"];
_counter = 0;

iactionarr = [];

while {true} do {	
	private["_objs"];
	
	_objs = nearestobjects [getpos player, droppableitems, 5];
	{
		private ["_exitvar", "_i"];
		_exitvar = false;
		private["_i"];
		for "_i" from 0 to (count iactionarr) do {
			private["_arr"];
			_arr = iactionarr select _i;
			if(_x in _arr) exitWith {_exitvar=true};
		};

		if(_exitvar) exitWith {};
		private["_near_players", "_near_players_count"];
		_near_players = [_x, 3] call players_object_near;
		_near_players_count = (count _near_players);
		player groupChat format["_near_players = %1", _near_players];
		
		if (((_x distance player) < 3) && (_near_players_count < 2)) then {
			private["_arr"];
			_arr	= _x getvariable "droparray";
			if(isnil "_arr") exitWith {};
			
			private["_amount", "_item", "_infos", "_name"];
			_amount	= [_arr select 0] call decode_number;
			_item 	= _arr select 1;
			_infos	= _item call INV_GetItemArray;
			_name	= _infos call INV_GetItemName;

			private["_action"];
			_action = player addaction [format["Pickup %1 (%2)", _name, _amount], "pickup.sqf",[_x, _item, ([_amount] call encode_number)]];
			iactionarr = iactionarr + [[_x, _action]];
		};
	} foreach _objs;

	private ["_i"];
	_i = 0;
	while { _i < (count iactionarr) } do {
		private["_arr", "_obj", "_action", "_var"];
		_arr	= iactionarr select _i;
		_obj    = _arr select 0;
		_action = _arr select 1;
		_var	= _obj getvariable "droparray";

		if((isNull _obj) || ((_obj distance player) > 2) || (isNil "_var"))then {
			player removeaction _action;
			iactionarr set [_i, 0];
			iactionarr = iactionarr - [0];
		};
		_i = _i + 1;
	};

	sleep 0.2;
	_counter = _counter + 1;
	if (_counter >= 5000) exitwith {[] execVM "itemactions.sqf";};
};