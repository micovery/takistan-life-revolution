if (not(isNil "marker_functions_defined")) exitWith {};

marker_local_create = {
	private["_name", "_location", "_shape", "_type", "_color", "_size", "_text"];
	_name = _this select 0;
	_location = _this select 1;
	_shape = _this select 2;
	_type = _this select 3;
	_color = _this select 4;
	_size = _this select 5;
	_text = _this select 6;
	
	if (isNil "_name") exitWith {""};
	if (isNil "_location") exitWith {""};
	if (isNil "_shape") exitWith {""};
	if (isNil "_type") exitWith {""};
	if (isNil "_type") exitWith {""};
	if (isNil "_color") exitWith {""};
	if (isNil "_text") exitWith {""};
	
	if (typeName _name != "STRING") exitWIth {""};
	if (typeName _location != "ARRAY") exitWith {""};
	if (typeName _shape != "STRING") exitWith {""};
	if (typeName _type != "STRING") exitWIth {""};
	if (typeName _color != "STRING") exitWith {""};
	if (typeName _size != "ARRAY") exitWith {""};
	if (typeName _text != "STRING") exitWith {""};
	
	private["_marker"];
	_marker = createMarkerLocal [_name, _location]; 
	
	_marker setMarkerShapeLocal _shape;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerColorLocal _color;
	_marker setMarkerSizeLocal _size;
	_marker setMarkerTextLocal _text;
	(_marker)
};

marker_local_side_create = {
	private["_name", "_location", "_text"];
	_name = _this select 0;
	_location = _this select 1;
	_text = _this select 2;
	
	private["_shape", "_type", "_color", "_size"];
	_shape = "ICON";
	_type = "Dot";
	_color = "ColorBlue";
	_size = [1.2, 1.2];
	([_name, _location, _shape, _type, _color, _size, _text] call marker_local_create)
};


marker_side_init = {
	//create local markers for all cops (even if not in game), and hide them
	private["_i", "_local_markers"];
	_local_markers = [];
	_i = 0;
	while { _i < (count playerstringarray) } do {
		private["_player_variable_name", "_player_variable"];
		_player_variable_name = playerstringarray select _i;
	
		private["_local_marker", "_local_marker_text", "_local_marker_name", "_local_marker_location"];
		_local_marker_name = _player_variable_name;
		_local_marker_location = [0, 0];
		_local_marker_text = _player_variable_name;
		_local_marker = [_local_marker_name, _local_marker_location, _local_marker_text] call marker_local_side_create;
		if (not(_local_marker == "")) then {
			_local_marker setMarkerAlphaLocal 0;
			_local_markers = _local_markers + [_local_marker];
		};
		_i = _i + 1;
	};
	_local_markers
};


marker_loop_draw = {
	if (not([player] call camera_get_map_open)) exitWith {};
	private["_local_marker"];
	//player groupChat format["marking %1", _this];
	_local_marker = _this select 0;
	if (isNil "_local_marker") exitWith {};
	
	private["_player_variable_name", "_player_variable"];
	_player_variable_name = _local_marker;
	_player_variable = missionNamespace getVariable [_player_variable_name, objNull];

	if (not([_player_variable] call player_exists)) exitWith {
		_local_marker setMarkerAlphaLocal 0;
	};
	
	private["_location"];
	_location = getPos _player_variable;
	_local_marker setMarkerAlphaLocal 1;
	_local_marker setMarkerPosLocal [(_location select 0), (_location select 1)];
	_local_marker setMarkerTextLocal (format["%1-%2", _player_variable, (name _player_variable)]);
};

marker_side_loop_draw = {
	if (not(visibleMap)) exitWith {};
	private["_local_marker"];
	//player groupChat format["marking %1", _this];
	_local_marker = _this select 0;
	if (isNil "_local_marker") exitWith {};
	
	private["_player_variable_name", "_player_variable"];
	_player_variable_name = _local_marker;
	_player_variable = missionNamespace getVariable [_player_variable_name, objNull];


	if (
			!([player, "sidemarkers"] call player_get_bool) || 
			!([player] call player_human) || 
			([player] call player_civilian) ||
			!([_player_variable] call player_human) ||
			([_player_variable] call player_civilian)
		) exitWith {
		_local_marker setMarkerAlphaLocal 0;
	};
	
	private["_has_admin_camera"];
//	_has_admin_camera = _player_variable getVariable "has_admin_camera";
//	_has_admin_camera = if (isNil "_has_admin_camera") then { false } else {_has_admin_camera};
//	_has_admin_camera = if (typeName _has_admin_camera != "BOOL") then {false} else {_has_admin_camera};
	
	_has_admin_camera = _player_variable getVariable ["has_admin_camera", false];
	
	if (_has_admin_camera) exitWith {
		_local_marker setMarkerAlphaLocal 0;
	};
	
	//both the marked-player, and the player belong to the same side
	if (([player] call player_side) != ([_player_variable] call player_side)) exitWith {
		_local_marker setMarkerAlphaLocal 0;
	};
	
	//player groupChat format["_player_variable = %1", _player_variable];
	private["_location"];
	_location = getPos _player_variable;
	_local_marker setMarkerAlphaLocal 1;
	_local_marker setMarkerPosLocal [(_location select 0), (_location select 1)];
	_local_marker setMarkerTextLocal (format["%1-%2", _player_variable, (name _player_variable)]);
};


marker_side_loop = {
	if (isNil "marker_side_array") then {
		marker_side_array = call marker_side_init;
	};
	
	private["_marker_loop_i"];
	_marker_loop_i = 0;
	while {true} do {
		private["_player"];
		_player = player;
	
		{ 
			if ([_player] call camera_enabled) then {
				[_x] call marker_loop_draw;
			}
			else {
				[_x] call marker_side_loop_draw; 
			};
		} forEach marker_side_array;
		_marker_loop_i = _marker_loop_i + 1;
		sleep 1;
		if (_marker_loop_i > 5000) exitWith {};
	};
	
	[] spawn marker_side_loop; 
};

[] spawn marker_side_loop;

marker_functions_defined = true;
