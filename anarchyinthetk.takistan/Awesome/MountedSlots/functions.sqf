if (not(isNil "mounted_vehicles_functions")) exitWith {};

#define DIK_E 18

mounted_classes = 0;
mounted_slots = 1;

mounted_slot_id = 0;
mounted_slot_text = 1;
mounted_slot_offset = 2;
mounted_slot_heading = 3;
mounted_slot_exit = 4;
mounted_slot_blocked_actions = 5; // Prone, Crouch, Stand  (these are the names returned by actionKeys command)
mounted_slot_default_action = 6;  // Lying, Crouch, Stand  (these are strings passed to playActioNow command)
mounted_slot_direction_min = 7;
mounted_slot_direction_max = 8;

mounted_slot_offset_name = 0;
mounted_slot_offset_data = 1;

mounted_slot_heading_name = 0;
mounted_slot_heading_data = 1;

mounted_slot_exit_name = 0;
mounted_slot_exit_data = 1;

mounted_vehicle_slots = [

	[	["Ural_INS", "Ural_TK_CIV_EP1", "UralCivil", "Ural_CDF", "MTVR_DES_EP1", "Ural_UN_EP1", "Kamaz"],
		[
			["shooter1", ", ride on flat-bed front", ["offset",  [0.01,0,-0.6]], ["heading", [0,346,0]], ["exit", [-0.24,-3.89,-1.93]], ["Stand", "Prone"], "Crouch", -1, 361],
			["shooter2", ", ride on flat-bed back", ["offset",  [0.04,-1.81,-0.67]], ["heading", [129,8,0]], ["exit", [-0.24,-3.89,-1.93]], ["Stand", "Prone"], "Crouch", -1, 361]
		]
	],
	[	["UralCivil2", "V3S_Open_TK_CIV_EP1", "V3S_Civ", "UralOpen_INS", "UralOpen_CDF", "KamazOpen"],
		[
			["shooter1", ", ride on flat-bed front", ["offset",  [0.01,0,-0.6]], ["heading", [0,346,0]], ["exit", [-0.24,-3.89,-1.93]], ["Prone"], "Crouch", -1, 361],
			["shooter2", ", ride on flat-bed back", ["offset",  [0.04,-1.81,-0.67]], ["heading", [129,8,0]], ["exit", [-0.24,-3.89,-1.93]], ["Prone"], "Crouch", -1, 361]
		]
	],
	[	["MH6J_EP1"],
		[
			["shooter1", ", ride on left side", ["offset",  [-0.60,0.88,-1.14]], ["heading", [285,350,0]], ["exit", [-1.77,1.05,-2.05]], ["Stand", "Prone"], "Crouch", 199, 319],
			["shooter2", ", ride on right side", ["offset",  [0.61,0.73,-1.2]], ["heading", [84,360,0]], ["exit", [2.21,0.55,-1.8]], ["Stand", "Prone"], "Crouch", 30, 150]
		]
	],
	[	["MH60S"],
		[
			["shooter1", ", ride on left side", ["offset", [-0.8,1.2,-1.95]], ["heading", [291,360,0]], ["exit", [-2.31,1.34,-2.55]], ["Stand", "Prone"], "Crouch", -1, 361]
		]
	],
	[	["LandRover_ACR", "LandRover_TK_CIV_EP1", "LandRover_CZ_EP1", "BAF_Offroad_D", "BAF_Offroad_W"],
		[
			["shooter1", ", ride on the back", ["offset", [1.49012e-008,-1.5,-0.9]], ["heading", [191,360,0]], ["exit", [0.1,-3.1,-1.7]], ["Stand", "Prone"], "Crouch", -1, 361]
		]
	],
	[	["Ikarus_TK_CIV_EP1", "Ikarus"],
		[
			["shooter1", ", ride on the back", ["offset", [-0.3,-4.6,-0.8]], ["heading", [161,0,0]], ["exit", [2.1,-4.7,-1.7]], ["Prone"], "Stand", -1, 361],
			["shooter2", ", ride on the hallway", ["offset", [-0.39,0,-0.83]], ["heading", [0,0,0]], ["exit", [1.77,0,-1.78]], ["Prone"], "Stand", -1, 361],
			["shooter3", ", ride on the front", ["offset", [-0.1,3.2,-0.9]], ["heading", [349,0,0]], ["exit", [2,3.5,-1.8]], ["Prone"], "Stand", -1, 361]
		]
	],
	[	["datsun1_civil_3_open", "datsun1_civil_1_open", "hilux1_civil_3_open_EP1", "hilux1_civil_3_open", "hilux1_civil_1_open"],
		[
			["shooter1", ", ride on the back", ["offset", [-0.1,-1.3,-0.8]], ["heading", [1,0,0]], ["exit", [-0.1,-3.2,-1.6]], ["Stand", "Prone"], "Crouch", -1, 361]
		]
	],
	[	["datsun1_civil_2_covered"],
		[
			["shooter1", ", ride on the back", ["offset", [0.1,-1.29,-1]], ["heading", [180,360,0]], ["exit", [0.13,-3.01,-1.47]], ["Stand", "Prone"], "Crouch", -1, 361]
		]
	]
];


mounted_disallowed_actions = [ "MoveBack", "MoveDown", "MoveFastForward", "MoveForward", "MoveLeft", "MoveRight", "MoveSlowForward", 
							   "CommandBack", "CommandLeft", "CommandRight", "CommandForward", "CommandFast", "CommandSlow"];	   
mounted_diallowed_keys = [];

{
	private["_action"];
	_action = _x;
	mounted_diallowed_keys = mounted_diallowed_keys + (actionKeys _action);
} foreach mounted_disallowed_actions;


mounted_passthrough_actions = ["LeanLeft", "LeanLeftToggle", "LeanRight",  "LeanRightToggle"];
mounted_passthrough_keys = [];

{
	private["_action"];
	_action = _x;
	mounted_passthrough_keys = mounted_passthrough_keys + (actionKeys _action);
} foreach mounted_passthrough_actions;


mounted_set_heading =
{
	private["_direction", "_angle", "_pitch"];
	
	_object = _this select 0;
	_data = _this select 1;
	
	_direction = _data select 0;
	_angle = _data select 1;
	_pitch = _data select 2;
	
	_vecdx = sin(_direction) * cos(_angle);
	_vecdy = cos(_direction) * cos(_angle);
	_vecdz = sin(_angle);

	_vecux = cos(_direction) * cos(_angle) * sin(_pitch);
	_vecuy = sin(_direction) * cos(_angle) * sin(_pitch);
	_vecuz = cos(_angle) * cos(_pitch);

	_object setVariable ["heading", _data];
	_object setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
};

mounted_attach = {
	private["_player", "_vehicle", "_offset"];
	_player = _this select 0;
	_vehicle = _this select 1;
	_offset = _this select 2;
	
	_player attachTo [_vehicle, _offset];
};

mounted_lookup_class = {
	private["_class"];
	_class = _this select 0;
	if (isNil "_class") exitWith {};
	if (typeName _class != "STRING") exitWith {};
	
	private["_entry"];
	_entry = nil;
	
	{
		private["_centry", "_cclass", "_cslot_name", "_clots"];
		_centry = _x;
		_cclass = _centry select mounted_classes;
		if (_class in (_cclass) ) exitWith {
			_entry = _centry;
		};
	} forEach mounted_vehicle_slots;
	
	_entry
};

mounted_lookup_class_slot = {
	private["_class", "_slot_anme"];
	_class = _this select 0;
	_slot_id = _this select 1;
	
	private["_entry"];
	_entry = [_class] call mounted_lookup_class;
	if (isNil "_entry") exitWith {nil};
	
	if (isNil "_slot_id") exitWith {};
	if (typeName _slot_id != "STRING") exitWith {};
	
	private["_slot_entry"];
	_slot_entry = nil;
	
	{
		private["_cslot_entry", "_cslot_name"];
		_cslot_entry = _x;
		_cslot_name = _cslot_entry select mounted_slot_id;
		if (_cslot_name == _slot_id) exitWith {
			_slot_entry = _cslot_entry;
		};
	} forEach (_entry select mounted_slots);
	
	_slot_entry
};

mounted_get_occupants = {
	private["_vehicle", "_class"]; 
	_vehicle = _this select 0;
	
	_class = (typeOf _vehicle);
	private["_entry"];
	_entry = [_class] call mounted_lookup_class;
	if (isNil "_entry") exitWith {[]};
	
	private["_occupants"];
	_occupants = [];
	
	{
		private["_slot", "_slot_id", "_occupant"];
		_slot = _x;
		_slod_id = _slot select mounted_slot_id;
		_occupant = [_vehicle, _slod_id] call mounted_get_slot_occupant;
		if (not(isNil "_occupant")) then {
			_occupants = _occupants + [_occupant];
		};
	} forEach (_entry select mounted_slots);
	
	_occupants
};

mounted_slot_wait = {
	_this spawn {
		private["_player", "_vehicle", "_slot_id"];
		_player = _this select 0;
		_vehicle = _this select 1;
		_slot_id = _this select 2;
		
		//player groupChat format["Waiting for death"];
		waitUntil { not(alive _player) || not(_player getVariable "inMountedSlot")};

		//player groupChat format["Wait complete _notAlive = %1, _notInMountedSlot = %2", not(alive _player), not(_player getVariable "inMountedSlot")];
		_player setVariable ["inMountedSlot", false, true];
		_player setVariable ["mountedVehicle", nil, true];
		
		private["_occupant"];
		_occupant = [_vehicle, _slot_id] call mounted_get_slot_occupant;
		if (_occupant == _player) then {
			[_vehicle, _slot_id, nil] call mounted_set_slot_occupant;
		};
		
		[] call mounted_remove_keyDown;
		[] call mounted_remove_keyUp;
		[] call mounted_remove_mouseMoving;
		
		if (alive _player) then {
			private["_class", "_slot_entry"];
			_class = typeOf _vehicle;
			_slot_entry = [_class, _slot_id] call mounted_lookup_class_slot;
			if (not(isNil "_slot_entry")) then {
				private["_exit"];
				_exit = (_slot_entry select mounted_slot_exit) select mounted_slot_exit_data;
				[_player, _vehicle, _exit] call mounted_attach;
			};
			
			[_player] spawn { detach (_this select 0);};
			
			titleText ["", "BLACK OUT", 0.1];
			titleText ["", "BLACK IN", 2];
		} 
		else {
			detach _player;
			hideBody _player;
		};
	};
};

mounted_board_slot = {
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;
	_slot_id = _this select 2;
	
	private["_class", "_slot_entry"];
	
	_class = typeOf _vehicle;
	
	_slot_entry = [_class, _slot_id] call mounted_lookup_class_slot;
	if (isNil "_slot_entry") exitWith {nil};
	
	private["_offset", "_heading", "_blocked_actions", "_blocked_keys", "_default_action"];
	_offset = ((_slot_entry select mounted_slot_offset) select mounted_slot_offset_data);
	_heading = ((_slot_entry select mounted_slot_heading) select mounted_slot_heading_data);
	_blocked_actions = (_slot_entry select mounted_slot_blocked_actions);
	_blocked_keys = [_blocked_actions] call mounted_keysForActions;
	_default_action = _slot_entry select mounted_slot_default_action;
	_direction_min = _slot_entry select mounted_slot_direction_min;
	_direction_max = _slot_entry select mounted_slot_direction_max;
	
	[_player, _vehicle, _offset] call mounted_attach;
	[_player, _heading] call mounted_set_heading;
	_player playActionNow _default_action;
	_player groupChat format["You have boarded a mounted slot in this vehicle. Use Control + E to exit"];
	
	_player setVariable ["inMountedSlot", true, true];
	_player setVariable ["mountedVehicle", _vehicle, true];
	[_vehicle, _slot_id, _player] call mounted_set_slot_occupant;
	
	titleText ["", "BLACK OUT", 0.1];
	[_player, _vehicle, _slot_id, _blocked_keys] call mounted_setup_keyDown;
	[_player, _vehicle, _slot_id, _blocked_keys] call mounted_setup_keyUp;
	[_player, _vehicle, _slot_id, _direction_min, _direction_max] call mounted_setup_mouseMoving;
	[_player, _vehicle, _slot_id] call mounted_slot_wait;
	titleText ["", "BLACK IN", 2];
	
};

mounted_unboard_slot = {
	private["_player", "_vehicle", "_slot_id"];
	_player = _this select 0;
	_vehicle = _this select 1;
	_slot_id = _this select 2;
	
	private["_unlocked"];
	_unlocked = [_vehicle] call mounted_vehicle_unlocked;
	
	if (not(_unlocked)) exitWith {
		player groupChat format["This vehicle is locked"];
	};
	
	_player setVariable ["inMountedSlot", false, true];
	_player setVariable ["mountedVehicle", nil, true];

};



mounted_get_slot_occupant = {
	private["_vehicle", "_slot_id"];
	_vehicle = _this select 0;
	_slot_id = _this select 1;
	
	if (isNil "_slot_id") exitWith {nil};
	if (typeName _slot_id != "STRING") exitWith {nil};
	if (isNil "_vehicle") exitWith {nil};
	
	private["_occupant"];
	_occupant = _vehicle getVariable _slot_id;
	if (typeName _occupant == "OBJECT") then {
		_occupant = if (isNull _occupant) then { nil } else { _occupant };
	};
	
	_occupant
};

mounted_set_slot_occupant = {
	private["_vehicle", "_slot_id", "_occupant"];
	//player groupChat format["_this = %1", _this];
	_vehicle = _this select 0;
	_slot_id = _this select 1;
	_occupant = _this select 2;

	if (isNil "_slot_id") exitWith {};
	if (typeName _slot_id != "STRING") exitWith {};
	if (isNil "_vehicle") exitWith {};
	
	private["_occupant"];
	//player groupChat format["typeName _occupant = %1", (typeName _occupant)];
	if (typeName _occupant == "OBJECT") then {
		_occupant = if (isNull _occupant) then { nil } else { _occupant };
	};
	
	//player groupChat format["_vehicle = %1, _slot_id = %2, _occupant = %3", _vehicle, _slot_id, _occupant];
	_vehicle setVariable [_slot_id, _occupant, true];
};



mounted_player_inside = {
	//player groupChat format["Checking player inside"];
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;
	if (((vehicle _player) == _vehicle) && (_vehicle != _player)) exitWith {true};
	
	private["_inMountedSlot"];
	_inMountedSlot = _player getVariable "inMountedSlot";
	if (isNil "_inMountedSlot") exitWith {false};
	if (typeName _inMountedSlot != "BOOL") exitWith {false};
	_inMountedSlot
};

mounted_player_get_vehicle = {
	private["_player"];
	_player = _this select 0;
	
	private["_vehicle"];
	_vehicle = _player getVariable "mountedVehicle";

	if (typeName _vehicle == "OBJECT") then {
		_vehicle = if (isNull _vehicle) then { nil } else { _vehicle };
	};
	_vehicle
};

mounted_slot_open = {
	private["_vehicle", "_slot_id"];
	//player groupChat format["_this = %1", _this];
	_vehicle = _this select 0;
	_slot_id = _this select 1;
	
	private["_slot_occupant", "_result"];
	_slot_occupant = [_vehicle, _slot_id] call mounted_get_slot_occupant;
	//player groupChat format["_slot_occupant = %1", _slot_occupant];
	_result = (isNil "_slot_occupant");
	_result
};


mounted_vehicle_unlocked = {
	private["_vehicle"];
	_vehicle = _this select 0;
	if (isNil "_vehicle") exitWith {false};
	not(locked _vehicle)
};



mounted_add_actions = {
	_vehicle = _this select 0;
	//player groupChat format["Adding actions!"];
	if (isNil "_vehicle") exitWith {};
	private["_class"];
	_class =  typeOf _vehicle;
	
	private["_entry"];
	_entry = [_class] call mounted_lookup_class;
	if (isNil "_entry") exitWith {};
	
	
	private ["_has_mounted_actions"];
	private["_actions_variable"];
	_actions_variable = format["has_mounted_actions_%1", (getPlayerUID player)]; 
	
	_has_mounted_actions = _vehicle getVariable _actions_variable;
	if (isNil "_has_mounted_actions") then { _has_mounted_actions = false;}; 
	if (_has_mounted_actions) exitWith {};
	
	private["_display_name"];
	_display_name =  getText (configFile >> "CfgVehicles" >> _class >> "displayName");
	//player groupChat format["_display_name = %1", _display_name];
	
	private["_slots"];
	
	_slots = _entry select mounted_slots;
	
	{
		private["_slot_id", "_slot_name", "_slot"];
		_slot = _x;
		_slot_id = _slot select mounted_slot_id;
		_slot_name = _slot select mounted_slot_text;
		//player groupChat format["_slot_id = %1, _slot_name = %2", _slot_id, _slot_name];
		_vehicle addAction [format['<t color="#dddd00">Get in %1%2</t>', _display_name, _slot_name], "noscript.sqf", format['[_this select 1, _this select 0, "%1"] call mounted_board_slot;', _slot_id], 1, false, true,"", format['([_target] call mounted_vehicle_unlocked) && ([_target, "%1"] call mounted_slot_open) && !([_this, _target] call mounted_player_inside)', _slot_id]];
	} foreach _slots;
	

	_has_mounted_actions = true;
	_vehicle setVariable [_actions_variable, _has_mounted_actions];
};

mounted_keysForActions = {
	private["_actions"];
	_actions = _this select 0;
	if (isNil "_actions") exitWith {[]};
	if (typeName _actions != "ARRAY") exitWith {[]};
	
	private["_keys"];
	_keys = [];
	{
		private["_action"];
		_action = _x;
		if (true) then {
			if (isNil "_action") exitWith {};
			if (typeName "_action" != "STRING") exitWith {};
			_keys = _keys + (actionKeys _action);
		};
	} foreach _blocked_actions;
	_keys
};

mounted_keyUpHandler = {
	private["_data"];
	_data = _this select 1;
	_this = _this select 0;
	
	private["_display", "_key", "_shift", "_control", "_alt"];
	_display = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	_control = _this select 3;
	_alt = _this select 4;
	
	private["_player", "_vehicle", "_slot_id"];
	
	_player = _data select 0;
	_vehicle = _data select 1;
	_slot_id = _data select 2;
	_blocked_keys = _data select 3;

	_data = [_player, _vehicle, _slot_id];
		
	if (_key in _blocked_keys) exitWith {
		true
	};
	
	if (_key in mounted_diallowed_keys) exitWith {
		true
	};
	
	false
};

mounted_keyDownHandler = {
	//player groupChat format["_this = %1", _this];
	private["_data"];
	_data = _this select 1;
	_this = _this select 0;
	
	private["_display", "_key", "_shift", "_control", "_alt"];
	_display = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	_control = _this select 3;
	_alt = _this select 4;
	
	private["_player", "_vehicle", "_slot_id"];
	
	_player = _data select 0;
	_vehicle = _data select 1;
	_slot_id = _data select 2;
	_blocked_keys = _data select 3;

	_data = [_player, _vehicle, _slot_id];
		
	if (_key in _blocked_keys) exitWith {
		true
	};
	
	if (_key == DIK_E && _control) then {
		if (speed _vehicle > 30) exitWith {
			player groupChat format["%1-%2, you cannot exit the vehicle. It's moving too fast", _player, (name _player)];
		};
		_data call mounted_unboard_slot;
	};
	
	if (_key in (actionKeys "ReloadMagazine")) then {
		reload _player;
	};
	
	if (_key in mounted_passthrough_keys) exitWith {
		false;
	};
	
	if (_key in mounted_diallowed_keys) exitWith {
		true
	};
	
	false
};

mounted_setup_keyDown = {
	private["_data"];
	_data = _this;
	
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "mounted_keyDownHandler_id" ) then {
		mounted_keyDownHandler_id = _display displayAddEventHandler  ["keyDown", format["[_this, %1] call mounted_keyDownHandler", _data]];
	};
};

mounted_remove_keyDown = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "mounted_keyDownHandler_id")) then {
		_display displayRemoveEventHandler  ["keyDown", mounted_keyDownHandler_id];
		mounted_keyDownHandler_id = nil;
	};
};





mounted_setup_keyUp = {
	private["_data"];
	_data = _this;
	
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "mounted_keyUpHandler_id" ) then {
		mounted_keyUpHandler_id = _display displayAddEventHandler  ["keyUp", format["[_this, %1] call mounted_keyUpHandler", _data]];
	};
};

mounted_remove_keyUp = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "mounted_keyUpHandler_id")) then {
		_display displayRemoveEventHandler  ["keyUp", mounted_keyUpHandler_id];
		mounted_keyUpHandler_id = nil;
	};
};


mounted_mouseMoving_handler = {
	private["_data", "_player", "_vehicle", "_slot_id", "_mouse_delta"];
	
	_data = _this select 1;
	_this = _this select 0;
	
	_mouse_delta = _this select 1;
	_r_delta = abs(_mouse_delta);

	_player = _data select 0;
	
	if (dialog) exitWith {};
	if (lookingAround) exitWith {};
	
	private ["_direction", "_heading", "_direction_min", "_direction_max"];
	
	_direction_min = _data select 3;
	_direction_max = _data select 4;
	
	_heading = _player getVariable "heading";
	if (isNil "_heading") then {
		_heading = [(getDir _player),0,0];
		_player setVariable ["heading", _heading];
	};

	_direction = _heading select 0;
	//player groupChat format["_direction = %1", _direction];

	if (_mouse_delta >= 0) then {
		_direction = _direction + _r_delta;
		
		if (_direction >= _direction_max) then {
			_direction = _direction_max;
		};
		
		if (_direction > 360 ) then {
			_direction = (_direction - 360);
		};
		_heading set[0, _direction];
		_player setVariable ["heading", _heading];
		[_player, _heading] call mounted_set_heading;
	};
	
	if (_mouse_delta <= 0) then {
		_direction = _direction - _r_delta;
		
		if (_direction <= _direction_min) then {
			_direction = _direction_min;
		};
		
		if ( _direction < 0 ) then {
			_direction = 360 + _direction;
		};
		_heading set [0, _direction];
		_player setVariable ["heading", _heading];
		[_player, _heading] call mounted_set_heading;
	};
	false
};

	   
mounted_setup_mouseMoving = {
	private["_data"];
	_data = _this;
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "mounted_mouseMoving_id" ) then {
		mounted_mouseMoving_id = _display displayAddEventHandler  ["mouseMoving", format["[_this, %1] call mounted_mouseMoving_handler", _data]];
	};
};

mounted_remove_mouseMoving = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "mounted_mouseMoving_id")) then {
		_display displayRemoveEventHandler  ["mouseMoving", mounted_mouseMoving_id];
		mounted_mouseMoving_id = nil;
	};
};

mounted_actions_init = if (isNil "mounted_actions_init") then { [] } else {mounted_actions_init};

{
	private["_vehicle"];
	_vehicle = _x;
	if (not(isNull _vehicle)) then {
		[_vehicle] call mounted_add_actions;
	};
} forEach mounted_actions_init;


mounted_vehicles_functions = false;
