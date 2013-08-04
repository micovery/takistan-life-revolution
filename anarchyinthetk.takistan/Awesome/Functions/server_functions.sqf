if (not(isNil "server_functions_defined")) exitWith {};

server_get_array = {
	//player groupChat format["server_get_array %1", _this];
	private["_variable_name"];
	_variable_name = _this select 0;
	
	if (isNil "_variable_name") exitWith {[]};

	private["_variable_value"];
	_variable_value = server getVariable _variable_name;
	_variable_value = if (isNil "_variable_value") then { [] } else { _variable_value };
	_variable_value = if (typeName _variable_value != "ARRAY") then { [] } else {_variable_value };
	_variable_value
};

server_set_array = {
	//player groupChat format["server_set_array %1", _this];
	private["_variable_name", "_variable_value"];
	_variable_name = _this select 0;
	_variable_value = _this select 1;
	
	[_variable_name, _variable_value, true] call server_set_array_checked;
};

server_set_array_checked = {
	//player groupChat format["server_set_array_checked %1", _this];
	private["_variable_name", "_variable_value", "_check_change"];
	_variable_name = _this select 0;
	_variable_value = _this select 1;
	_check_change = _this select 2;
	
	if (isNil "_variable_name") exitWith {};
    if (isNil "_variable_value") exitWith {};
	if (isNil "_check_change") exitWith {};
	
	if (typeName _variable_name != "STRING") exitWith {};
	if (typeName _variable_value != "ARRAY") exitWith {};
	if (typeName _check_change != "BOOL") exitWith {};
	
	private["_current_value"];
	
	if (_check_change) then {
		_current_value = [_variable_name] call server_get_array;	
		if (str(_current_value) == str(_variable_value)) exitWith {};
	};
	
	server setVariable [_variable_name, _variable_value, true];
	[_variable_name, _variable_value] call stats_server_save;
};





//player groupChat format["server functions defined"];
server_functions_defined =  true;