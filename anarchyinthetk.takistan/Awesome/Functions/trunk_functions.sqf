if (!(isNil "trunk_functions")) exitWith {};

trunk_get_uuid = {
	_name = (name player);
	_uid = (getPlayerUID player);
	_result = format["%1_%2", _name, _uid];
	_result
};

trunk_close = {
	
	_vehicle = player getVariable "vehicle_trunk_used";
	if (isNil "_vehicle") exitWith { };
	
	//player groupchat format["Closing trunk for %1", _vehicle];
	_vehicle = player getVariable "vehicle_trunk_used";
	_vehicle setVariable ["trunk_user_uuid", "0", true];
	_vehicle setVariable ["trunk_user_name", "Unknown", true];
	player setVariable ["vehicle_trunk_used", nil]; 
};

trunk_open = {

	call trunk_close;
	
	_vehicle = _this select 0;
	_vehicle setVariable ["trunk_user_uuid", (call trunk_get_uuid), true];
	_vehicle setVariable ["trunk_user_name", (name player), true];
	player setVariable ["vehicle_trunk_used", _vehicle]; 
	
	//player groupchat format["Opening trunk for %1", _vehicle];
	
	//for redundancy, close the on all other player vehicles
	format['[%1, %2] spawn close_other_trunk;', player, _vehicle] call broadcast;
};

close_other_trunk = {
	_player = _this select 0;
	_vehicle = _this select 1;
	
	//sleep some time on purpose to give enough time for variable to propagate
	sleep 1;
	
	if (isNil "_player") exitWith {};
	if (isNil "_vehicle") exitWith {};
	if (_player == player) exitWith {};
	
	_cvehicle = player getVariable "vehicle_trunk_used";
	if (isNil "_cvehicle") exitWith {};
	
	if (format["%1", _vehicle]  == format["%1", _cvehicle]) then {
		closeDialog 0;
		call trunk_close;
	};
};


trunk_in_use = {
	_vehicle = _this select 0;
	_uuid = call trunk_get_uuid;
	_cuuid = _vehicle getVariable "trunk_user_uuid";
	
	if (isNil "_cuuid") exitWith { /* player groupChat format["_cuuid is nil"]; */ false };
	if (typeName _cuuid != "STRING") exitWith { /* player groupChat format["_cuuid not STRIING"]; */ false };
	if (_cuuid == "0") exitWith { /* player groupChat format["_cuuid = %1", _cuuid]; */ false };
	
	/* player groupchat format["_cuuid = %1", _cuuid]; */
	
	_in_use = (_cuuid != _uuid);
	_in_use
};

trunk_user =  {
	_vehicle = _this select 0;
	_cname = _vehicle getVariable "trunk_user_name";
	
	if (isNil "_cname") exitWith { "Unknown-A" };
	if (typeName _cname != "STRING") exitWith { "Unknown-B" };
	_cname
};


trunk_functions = true;
