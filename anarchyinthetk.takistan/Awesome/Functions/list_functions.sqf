if (not(isNil "list_functions_defined")) exitWith {};

list_id = 0;
list_name = 1;
list_keys = 2;
list_values = 3;

list_exists = {
	private["_list_id"];
	_list_id = _this select 0;
	if (isNil "_list_id") exitWith {false};
	if (typeName _list_id != "STRING") exitWith {false};
	
	private["_list"];
	_list = [_list_id] call server_get_array;
	
	if ((count _list) == 0) exitWith {false};
	
	(true)
};

list_data = {
	private["_list_id"];
	_list_id = _this select 0;
	if (isNil "_list_id") exitWith {nil};
	if (typeName _list_id != "STRING") exitWIth {nil};
	if (_list_id == "") exitWith {nil};
	
	private["_data"];
	_data = [_list_id] call server_get_array;
	if ((count _data) == 0) exitWith {""};
	(_data)
};

list_create = {
	//player groupChat format["list_create %1", _this];
	private["_list_id", "_list_name"];
	_list_id = _this select 0;
	_list_name = _this select 1;
	
	if (isNil "_list_id") exitWIth {};
	if (typeName _list_id != "STRING") exitWith {};
	if (isNil "_list_name") exitWith {};
	if (typeName _list_name != "STRING") exitWith {};
	
	if ([_list_id] call list_exists) exitWith {};
	private["_data"];
	_data = [];
	_data set [list_id, _list_id];
	_data set [list_name, _list_name];
	_data set [list_keys, []];
	_data set [list_values, []];
	[_list_id, _data] call server_set_array;
};

list_put_value = {
	//player groupChat format["list_put_value %1", _this];
	private["_list_id", "_key", "_value"];
	_list_id = _this select 0;
	_key = _this select 1;
	_value = _this select 2;
	
	if (isNil "_list_id") exitWith {};
	if (typeName _list_id != "STRING") exitWith {};
	if (isNil "_key") exitWith {};
	if (typeName _key != "STRING") exitWith {};
	
	private["_data"];
	_data = [_list_id] call list_data;
//	if (isNil "_data") exitWith {};
	if ((typeName _data) != "ARRAY") exitwith {};
	
	private["_keys", "_values"];
	_keys = _data select list_keys;
	_values = _data select list_values;
	
	private["_index"];
	_index = _keys find _key;
	_index = if (_index ==  -1) then {count(_keys)} else {_index};
	_keys set [_index, _key];
	_values set [_index, _value];
	
	_data set [list_keys, _keys];
	_data set [list_values, _values];
	
	[_list_id, _data, false] call server_set_array_checked;
};

list_get_value = {
	private["_list_id", "_key"];
	_list_id = _this select 0;
	_key = _this select 1;
	
	if (isNil "_list_id") exitWith {nil};
	if (typeName _list_id != "STRING") exitWith {nil};
	if (isNil "_key") exitWith {nil};
	if (typeName _key != "STRING") exitWIth {nil};
	
	private["_data"];
	_data = [_list_id] call list_data;
//	if (isNil "_data") exitWith {nil};
	
	if ((typeName _data) != "ARRAY") exitwith {""};
	
	private["_keys", "_values"];
	_keys = _data select list_keys;
	_values = _data select list_values;
	
	private["_index"];
	_index = _keys find _key;
	if (_index == -1) exitWith {""};
	
	private["_value"];
	if (_index >= count(_values)) exitWith {""};
	
	_value = _values select _index;
	
	(_value)
};

list_remove_key = {
	private["_list_id", "_key"];
	_list_id = _this select 0;
	_key = _this select 1;
	
	if (isNil "_list_id") exitWith {};
	if (typeName _list_id != "STRING") exitWith {};
	if (isNil "_key") exitWith {};
	if (typeName _key != "STRING") exitWIth {};
	
	private["_data"];
	_data = [_list_id] call list_data;
//	if (isNil "_data") exitWith {};
	if ((typeName _data) != "ARRAY") exitwith {};
	
	private["_keys", "_values"];
	_keys = _data select list_keys;
	_values = _data select list_values;
	
	private["_index"];
	_index = _keys find _key;
	if (_index == -1) exitWith {};
	
	_values set [_index, _key];
	
	_keys = _keys - [_key];
	_values = _values - [_key];
	
	_data set [list_keys, _keys];
	_data set [list_values, _values];
	
	[_list_id,  _data, false] call server_set_array_checked;
};

list_contains_key = {
	private["_list_id", "_key"];
	_list_id = _this select 0;
	_key = _this select 1;
	
	if (isNil "_list_id") exitWith {false};
	if (typeName _list_id != "STRING") exitWith {false};
	if (isNil "_key") exitWith {false};
	if (typeName _key != "STRING") exitWIth {false};
	
	private["_data"];
	_data = [_list_id] call list_data;
//	if (isNil "_data") exitWith {false};
	if ((typeName _data) != "ARRAY") exitwith {false};
	
	private["_keys", "_values"];
	_keys = _data select list_keys;
	
	private["_index"];
	_index = _keys find _key;
	if (_index == -1) exitWith {false};
	
	(true)
};

//player groupChat format["list functions defined"];
list_functions_defined = true;