#include "dikcodes.h"
if (not(isNil "camera_functions_defined")) exitWith {};

camera_keyUpHandler = {
	//player groupChat format["camera_keyUpHandler %1", _this];
	_this = _this select 0;
	
	private["_display", "_key", "_shift", "_control", "_alt"];
	_display = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	_control = _this select 3;
	_alt = _this select 4;
	
	private["_player"];
	_player = player;
	
	if (_key in (actionKeys "MoveForward") || 
		_key in (actionKeys "MoveBack") ||
		_key in (actionKeys "TurnLeft") ||
		_key in (actionKeys "TurnRight") ||
		_key in (actionKeys "HeliUp") ||
		_key in (actionKeys "HeliDown")) then {
		[_player, 0] call camera_set_velocity;
	};
	
	false
};

camera_remove_keyUp = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "camera_keyUpHandler_id")) then {
		_display displayRemoveEventHandler  ["keyUp", camera_keyUpHandler_id];
		camera_keyUpHandler_id = nil;
	};
};


camera_setup_keyUp = {
	private["_data"];
	_data = _this;
	
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "camera_keyUpHandler_id" ) then {
		camera_keyUpHandler_id = _display displayAddEventHandler  ["keyUp", format["[_this, %1] call camera_keyUpHandler", _data]];
	};
};


camera_move_pos_vector = {
	private["_pos", "_data", "_velocity"]; 
	_pos = _this select 0;
	_data = _this select 1;
	_velocity = _this select 2;
	
	private["_direction", "_angle", "_pitch"];
	_direction = _data select 0;
	_angle = _data select 1;
	_pitch = _data select 2;
	
	_vecdx = (sin(_direction) * cos(_angle)) * _velocity;
	_vecdy = (cos(_direction) * cos(_angle)) * _velocity;
	_vecdz = (sin(_angle)) * _velocity;

	_pos = [((_pos select 0) + _vecdx), ((_pos select 1) + _vecdy), ((_pos select 2) + _vecdz)];
	_pos
};


camera_next_target = {
	private["_direction", "_target"];
	_direction = _this select 0;
	_target = _this select 1;
	
	private["_units"];
	_units = playableUnits;
	_target = if (isNil "_target") then {_units select 0} else {_target};
	
	private["_index"];
	_index = _units find _target;
	_index = _index + _direction;
	_index = if (_index >= (count(_units))) then {0} else {_index};
	_index = if (_index < 0) then { (count _units) - 1} else {_index};
	_target = _units select _index;
	_player setVariable ["camera_target", _target];
	
	(_target)
};

camera_update_target = {
	private["_player", "_key", "_shift"];
	_player = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	
	private["_target", "_previous_target"];
	_target = _player getVariable "camera_target";
	_previous_target = _target;
	
	private["_handled"];
	_handled = false;
	if (_shift && _key in (actionKeys "NextChannel")) then {
		_target = [+1, _target] call camera_next_target;
		player groupChat format["Camera target set to %1-%2", _target, (name _target)];
		private["_pos"];
		_pos = if (isNil "_previous_target") then {nil} else {[_player] call camera_get_position};
		[_player, _pos] call camera_set_position;
		
		private["_heading"];
		_heading = if (isNil "_previous_target") then {[0,0,0]} else {[_player] call camera_get_heading};
		[_player, _heading] call camera_set_heading;
		
		_handled = true;
	};
	
	if (_shift && _key in (actionKeys "PrevChannel")) then {
		_target = [-1, _target] call camera_next_target;
		player groupChat format["Camera target set to %1-%2", _target, (name _target)];
		private["_pos"];
		_pos = if (isNil "_previous_target") then {nil} else {[_player] call camera_get_position};
		[_player, _pos] call camera_set_position;
		
		private["_heading"];
		_heading = if (isNil "_previous_target") then {[0,0,0]} else {[_player] call camera_get_heading};
		[_player, _heading] call camera_set_heading;
		
		_handled = true;
	};
	
	if (_shift && _key in (actionKeys "Chat")) then {
		player groupChat format["Detaching form camera target"];

		detach _camera;
		_player setVariable ["camera_target", nil];
		
		private["_heading"];
		_heading = if (isNil "_previous_target") then {nil} else {[_previous_target, ([_player] call camera_get_heading)] call camera_heading_modelToWorld;};
		[_player, _heading] call camera_set_heading;
		
		private["_pos"];
		_pos = if (isNil "_previous_target") then {nil} else {_previous_target modelToWorld ([_player] call camera_get_position)};
		[_player, _pos] call camera_set_position;
		
		_handled = true;
	};
	
	_handled
};

camera_get_map_open = {
	private["_player"];
	_player = _this select 0;
	
	private["_map_open"];
	_map_open = _player getVariable "camera_map_open";
	_map_open = if (isNil "_map_open") then {false} else {_map_open};
	_map_open
};

camera_set_map_open = {
	private["_player", "_map_open"];
	_player = _this select 0;
	_map_open = _this select 1;
	
	private["_map_open"];
	_map_open = _player setVariable["camera_map_open", _map_open];
};

camera_map_control = {
	((finddisplay 12) displayctrl 51)
};

camera_map_open = {
	private["_player"];
	_player = _this select 0;
	
	[_player, true] call camera_set_map_open;
	openMap [true, true];
	
	(call camera_map_control) mapCenterOnCamera false;
	
	private["_pos"];
	_pos = [_player] call camera_get_world_position;
	mapAnimAdd [0, (ctrlMapScale (call camera_map_control)) , _pos];
	mapAnimCommit;
};

camera_map_close = {
	private["_player"];
	_player = _this select 0;
	
	[_player, false] call camera_set_map_open;
	openMap [false, false];
	
	private["_pos"];
	_pos = [_player] call camera_get_world_position;
	mapAnimAdd [0, (ctrlMapScale (call camera_map_control)) , _pos];
	mapAnimCommit;
};


camera_update_map = {
	private["_player", "_key", "_shift"];
	_player = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	
	if (not(_key in (actionKeys "ShowMap"))) exitWith {};
	
	if (not([_player] call camera_get_map_open)) then {
		[_player] call camera_map_open;
	}
	else {
		[_player] call camera_map_close;
	};
};

camera_get_max_velocity = {
	private["_player"];
	_player = _this select 0;
	
	private["_velocity"];
	_velocity = _player getVariable "camera_max_velocity";
	_velocity = if (isNil "_velocity") then {0} else {_velocity};
	_velocity
};

camera_set_max_velocity = {
	private["_player", "_velocity"];
	_player = _this select 0;
	_velocity = _this select 1;
	_player setVariable ["camera_max_velocity", _velocity];
};

camera_get_velocity = {
	private["_player"];
	_player = _this select 0;
	
	private["_velocity"];
	_velocity = _player getVariable "camera_velocity";
	_velocity = if (isNil "_velocity") then {0} else {_velocity};
	_velocity
};

camera_set_velocity = {
	private["_player", "_velocity"];
	_player = _this select 0;
	_velocity = _this select 1;
	_player setVariable ["camera_velocity", _velocity];
};


camera_calculate_velocity = {
	private["_player", "_shift"];
	_player = _this select 0;
	_shift = _this select 1;
	
	private["_velocity", "_max_velocity", "_delta"];
	_delta = 0.1;
	
	_velocity = [_player] call camera_get_velocity;
	_max_velocity = [_player] call camera_get_max_velocity;
	
	if (_velocity < _max_velocity) then {
		_velocity = (_velocity + _delta);
		_velocity = (_velocity) min (_max_velocity);
	} 
	else {
		_velocity = (_velocity - _delta);
		_velocity = (_velocity) max (_max_velocity);
	};
	
	//player groupChat format["_velocity = %1", _velocity];
	[_player, _velocity] call camera_set_velocity;
	
	_velocity = if (_shift) then {_velocity + 5} else {_velocity};
	//player groupChat format["_velocity = %1", _velocity];
	(_velocity)
};

camera_get_position = {
	private["_player"];
	_player = _this select 0;
	
	private["_target"];
	_target = _player getVariable "camera_target";
	
	private["_position", "_relative", "_default"];
	_relative = [0,-3,3];
	_default = if (isNil "_target") then {_player modelToWorld _relative} else {_relative};
	
	_position = _player getVariable "camera_pos";
	_position = if (isNil "_position") then {_default} else {_position};
	_position
};

camera_get_world_position = {
	private["_player"];
	_player = _this select 0;
	
	private["_pos"];
	_pos = [_player] call camera_get_position;
	
	private["_target"];
	_target = _player getVariable "camera_target";
	_pos = if (isNil "_target") then { _pos } else { _target modelToWorld _pos };
	_pos
};

camera_save_position = {
	private["_player", "_position"];
	_player = _this select 0;
	_position = _this select 1;
	_player setVariable ["camera_pos", _position];
};

camera_set_position = {
	private["_player", "_position"];
	_player = _this select 0;
	_position = _this select 1;
	
	[_player, _position] call camera_save_position;
	_position = [_player] call camera_get_position;

	private["_target"];
	_target = _player getVariable "camera_target";
	
	private["_camera"];
	_camera = _player getVariable "camera";
	if (isNil "_camera") exitWith {};
	
	if (isNil "_target") then {
		_camera setPos _position;
	}
	else {
		_camera attachTo [(vehicle _target), _position];
	};
};

camera_update_position = {
	//player groupChat format["camera_update_position %1", _this];
	private["_player", "_key", "_shift"];
	_player = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	
	private["_posistion"];
	_position = [_player] call camera_get_position;
		
	private["_velocity"];
	_velocity = [_player, _shift] call camera_calculate_velocity;
	
	private["_heading", "_direction", "_angle", "_bank"];
	_heading = [_player] call camera_get_heading;
	_direction = _heading select 0;
	_angle = _heading select 1;
	_bank = _heading select 2;
	
	if (_key in (actionKeys "MoveForward")) then {
		_position = [_position, [_direction, _angle, _bank], _velocity] call camera_move_pos_vector;
	};
	
	if (_key in (actionKeys "MoveBack")) then {
		_angle = _angle + 180;
		_angle = if (_angle > 360) then { _angle - 360 } else {_angle};
		_position = [_position, [_direction, _angle, _bank], _velocity] call camera_move_pos_vector;
	};
	
	if (_key in (actionKeys "TurnLeft") || _key in (actionKeys "MoveLeft")) then {
		_direction = _direction - 90;
		_direction = if (_direction < 0) then { 360 - abs(_direction) } else {_direction};
		_position = [_position, [_direction, 0, _bank], _velocity] call camera_move_pos_vector;
	};
	
	if (_key in (actionKeys "TurnRight") || _key in (actionKeys "MoveRight")) then {
		_direction = _direction + 90;
		_direction = if (_direction > 360) then {_direction - 360} else {_direction};
		_position = [_position, [_direction, 0, _bank], _velocity] call camera_move_pos_vector;
	};
	
	if (_key in (actionKeys "HeliUp")) then {
		_angle = _angle + 90;
		_angle = if (_angle > 360) then { _angle - 360 } else {_angle};
		_position = [_position, [_direction, _angle, _bank], _velocity] call camera_move_pos_vector;
	};
	
	if (_key in (actionKeys "HeliDown"))  then {
		_angle = _angle - 90;
		_angle = if (_angle < 0) then { 360 - abs(_angle) } else {_angle};
		_position = [_position, [_direction, _angle, _bank], _velocity] call camera_move_pos_vector;
	};

	[_player, _position] call camera_set_position;
};

camera_MouseZChanged_handler = {
	//player groupChat format["camera_MouseZChanged_handler %1", _this];
	_this = _this select 0;
	private["_player"];
	_player = player;
	
	private["_zc"];
	_zc = _this select 1;
	
	private["_velocity"];
	_velocity = [_player] call camera_get_max_velocity;
	_velocity = if (_zc > 0) then {_velocity + 0.1} else {_velocity - 0.1};
	_velocity = (_velocity) min (5);
	_velocity = (_velocity) max (0);
	_velocity = (round(_velocity * 100) / 100);
	//player groupChat format["Camera max velocity set at %1", _velocity];
	[_player, _velocity] call camera_set_max_velocity;

	true
};

camera_remove_MouseZChanged = {
	disableSerialization;
	private["_control"];
    _control = findDisplay 46;
	if (not(isnil "camera_MouseZChanged_id")) then {
		_control displayRemovEeventHandler  ["MouseZChanged", camera_MouseZChanged_id];
		camera_MouseZChanged_id = nil;
	};
};
 
camera_setup_MouseZChanged = {
	private["_data"];
	_data = _this;
	disableSerialization;
	private["_control"];
    _control = findDisplay 46;
	if ( isnil "camera_MouseZChanged_id" ) then {
		camera_MouseZChanged_id = _control displayAddEventHandler  ["MouseZChanged", format["[_this, %1] call camera_MouseZChanged_handler", _data]];
		//player groupChat format["camera_MouseZChanged_id = %1",camera_MouseZChanged_id];
	};
};

camera_get_nightvision = {
	private["_player"];
	_player = _this select 0;
	
	private["_nightvision"];
	_nightvision = _player getVariable "camera_nightvision";
	_nightvision = if (isNil "_nightvision") then {0} else {_nightvision};
	_nightvision
};

camera_set_nightvision = {
	private["_player", "_nightvision"];
	_player = _this select 0;
	_nightvision = _this select 1;
	
	_player setVariable ["camera_nightvision", _nightvision];
	(_nightvision)
};

camera_update_nightvision = {
	private["_player", "_key"];
	_player = _this select 0;
	_key = _this select 1;
	
	if (not(_key in actionKeys "NightVision")) exitWith {};
	
	private["_nightvision"];
	_nightvision = [_player] call camera_get_nightvision;
	_nightvision = ((_nightvision + 1) % 10);
	//player groupChat format["_nightvision = %1", _nightvision];
	switch (_nightvision) do {
		case 0: {
			player groupChat format["Setting camera default mode"];
			camUseNVG false;
			false SetCamUseTi 0;
		};
		case 1: {
			player groupChat format["Setting camera NV "];
			camUseNVG true;
			false SetCamUseTi 0;
		};
		case 2: {
			player groupChat format["Setting camera thermal white-hot"];
			camUseNVG false;
			true SetCamUseTi 0;
		};
		case 3: {
			player groupChat format["Setting camera thermal black-hot"];
			camUseNVG false;
			true SetCamUseTi 1;
		};
		case 4: {
			player groupChat format["Setting camera thermal light-green-hot"];
			camUseNVG false;
			true SetCamUseTi 2;
		};
		case 5: {
			player groupChat format["Setting camera thermal dark-green-hot"];
			camUseNVG false;
			true SetCamUseTi 3;
		};
		case 6: {
			player groupChat format["Setting camera light-orange-hot "];
			camUseNVG false;
			true SetCamUseTi 4;
		};
		case 7: {
			player groupChat format["Setting camera dark-orange-hot "];
			camUseNVG false;
			true SetCamUseTi 5;
		};
		case 8: {
			player groupChat format["Setting camera orange body-heat "];
			camUseNVG false;
			true SetCamUseTi 6;
		};
		case 9: {
			player groupChat format["Setting camera colored body-heat "];
			camUseNVG false;
			true SetCamUseTi 7;
		};
	};
	
	[_player, _nightvision] call camera_set_nightvision;
};

camera_target = {
	private["_objects"];
	_objects = nearestObjects [(screenToWorld [(safezoneX + 0.5 * safezoneW),(safezoneY + 0.5 * safezoneH)]), ["LandVehicle", "Man"], 2];
	if (count _objects == 0) exitWith {nil};
	(_objects select 0)
};

camera_enabled = {
	private["_player"];
	_player = _this select 0;
	
	private["_camera"];
	_camera = _player getVariable "camera";
	not(isNil "_camera")
};

camera_keyDownHandler = {
	//player groupChat format["camera_keyDownHandler = %1", _this];
	private["_player"];
	_player = player;

	private["_key", "_shift"];
	_this = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	
	private["_camera"];
	_camera = _player getVariable "camera";
	if (isNil "_camera") exitWith {};
	
	[_player, _key, _shift] call camera_update_map;
	if ([_player] call camera_get_map_open) exitWith {false};
	
	[_player, _key] call camera_update_nightvision;
	
	private["_handled"];
	_handled = [_player, _key, _shift] call camera_update_target;	
	
	[_player, _key, _shift] call camera_update_position;
	
	_handled
};


camera_remove_keyDown = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "camera_keyDownHandler_id")) then {
		_display displayRemoveEventHandler  ["keyDown", camera_keyDownHandler_id];
		camera_keyDownHandler_id = nil;
	};
};

camera_setup_keyDown = {
	private["_data"];
	_data = _this;
	
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "camera_keyDownHandler_id" ) then {
		camera_keyDownHandler_id = _display displayAddEventHandler  ["keyDown", format["[_this, %1] call camera_keyDownHandler", _data]];
	};
};

camera_mouseMoving_handler = {
	//player groupChat format["camera_mouseMoving_handler %1", _this];	

	_this = _this select 0;
	private["_xc", "_yc"];
	_xc = _this select 1;
	_yc = _this select 2;
	
	private["_player"];
	_player = player;
	
	if (dialog) exitWith {false};
	if ([_player] call camera_get_map_open) exitWith {false};
	
	[_player, _xc, _yc] call camera_update_heading;
	false
};

camera_remove_mouseMoving = {
	disableSerialization;
    _display = findDisplay 46;
	if (not(isnil "camera_mouseMoving_id")) then {
		_display displayRemoveEventHandler  ["mouseMoving", camera_mouseMoving_id];
		camera_mouseMoving_id = nil;
	};
};
 
camera_setup_mouseMoving = {
	private["_data"];
	_data = _this;
	disableSerialization;
    _display = findDisplay 46;
	if ( isnil "camera_mouseMoving_id" ) then {
		camera_mouseMoving_id = _display displayAddEventHandler  ["mouseMoving", format["[_this, %1] call camera_mouseMoving_handler", _data]];
	};
};


camera_heading2vectors = {
	private["_heading"];
	_heading = _this select 0;
	
	private["_direction", "_angle", "_bank"];
	_direction = _heading select 0;
	_angle = _heading select 1;
	_bank = _heading select 2;
	
	_vecdx = sin(_direction) * cos(_angle);
	_vecdy = cos(_direction) * cos(_angle);
	_vecdz = sin(_angle);

	_vecux = cos(_direction) * cos(_angle) * sin(_bank);
	_vecuy = sin(_direction) * cos(_angle) * sin(_bank);
	_vecuz = cos(_angle) * cos(_bank);
	
	([ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ])
};

camera_vectorDir2heading = {
	//player groupChat format["camera_vectorDir2heading %1", _this];
	private["_vectorDir"];
	_vectorDir = _this select 0;
	
	private["_vecdz", "_vecdy", "_vecdx"];
	_vecdx = _vectorDir select 0;
	_vecdy = _vectorDir select 1;
	_vecdz = _vectorDir select 2;
	
	private["_angle"];
	_angle = asin(_vecdz);
	_direction = asin(_vecdx / cos(_angle)); 
	
	_angle = if (_angle < 0) then {360 - abs(_angle)} else {_angle};
	_direction = if (_direction < 0) then {360 - abs(_direction)} else {_direction};
	
	private["_heading"];
	_heading = [_direction, _angle, 0];
	
	//player groupChat format["_convert = %1", _heading];
	_heading	
};

camera_save_heading = {
	private["_player", "_heading"];
	_player = _this select 0;
	_heading = _this select 1;
	_player setVariable ["camera_heading", _heading];
};

camera_get_heading = {
	private["_player"];
	_player = _this select 0;
	
	private["_camera"];
	_camera = _player getVariable "camera";
	
	private["_heading"];
	_heading = _player getVariable "camera_heading";
	_heading = if (isNil "_heading") then {[_player, [0,0,0]] call camera_heading_modelToWorld} else {_heading};
	_heading
};

camera_update_heading = {
	private["_player", "_xc", "_yc"];
	_player = _this select 0;
	_xc = _this select 1;
	_yc = _this select 2;;
	
	private["_heading"];
	_heading = [_player] call camera_get_heading;
	
	private["_dir"];
	_dir = _heading select 0;
	_dir = _dir + _xc;
	_dir = if (_dir > 360) then { _dir - 360 } else { _dir };
	_dir = if (_dir < 0) then { 360 - abs(_dir) } else { _dir};

	private["_angle"];
	_angle = _heading select 1;
	_angle = if (isNil "_angle") then {0} else {_angle};
	_angle =  _angle - _yc;
	_angle = if (_angle > 360) then { _angle - 360 } else { _angle };
	_angle = if (_angle < 0) then { 360 - abs(_angle) } else { _angle};
	
	private["_bank"];
	_bank = _heading select 2;
	
	_heading = [_dir, _angle, _bank];
	//player groupChat format["_update_heading = %1", _heading];
	[_player, _heading] call camera_set_heading;
};


camera_set_heading = {
	private["_player", "_heading"];
	_player = _this select 0;
	_heading = _this select 1;
	
	private["_camera"];
	_camera = _player getVariable "camera";
	if (isNil "_camera") exitWith {};

	//player groupChat format["_heading_before = %1", _heading];	
	[_player, _heading] call camera_save_heading;
	_heading = [_player] call camera_get_heading;

	//player groupChat format["_heading_last = %1", _heading];
	private["_vectors"];
	_vectors = [_heading] call camera_heading2vectors;
	_camera setVectorDirAndUp _vectors;
};

camera_heading_modelToWorld = {
	private["_target", "_heading"];
	_target = _this select 0;
	_heading = _this select 1;
	
	//player groupChat format["_heading2_before = %1", _heading];
	private["_tdir"];
	_tdir = getDir _target;
	
	private["_dir"];
	_dir = _heading select 0;
	_dir = _dir + _tdir;
	_dir = if (_dir > 360) then { _dir - 360 } else { _dir };
	_heading set [0, _dir];
	//player groupChat format["_heading2_after = %1", _heading];
	_heading
};

camera_destroy = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	private["_camera"];
	_camera = _player getVariable "camera";
	if (isNil "_camera") exitWith {};
	
	_player setVariable ["camera", nil];
	[_player] call camera_map_close;
	
	_camera cameraEffect ["terminate","back"];
	camDestroy _camera;
};

camera_create = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	private["_pos"];
	_pos = (getPosATL _player);
	_camera = "camera" camCreate [(_pos select 0), (_pos select 1), ((_pos select 2) + 3)];
	_camera cameraEffect ["Internal", "LEFT"];
	_camera setPos _pos;
	_camera camSetFoV 1;
	showCinemaBorder false;
	_player setVariable ["camera", _camera];
	_player setVariable ["camera_target", nil];
	[_player, nil] call camera_set_heading;
	[_player, nil] call camera_set_position;
	[_player] call camera_map_close;
	[_player, 0] call camera_set_velocity;
	[_player, 1] call camera_set_max_velocity;
	
	//hook for disabling camera when player dies
	[] spawn { 
		waitUntil {not(alive player)};
		[player] call camera_destroy;
	};
	_camera
};

camera_mouseButtonClick_handler = {
	//player groupChat format["camera_mouseButtonClick_handler %1", _this];
	_this = _this select 0;
	
	private["_player"];
	_player = player;
	
	if (not([_player] call camera_get_map_open)) exitWith {false};
	
	private["_button", "_control", "_x", "_y"];
	_display = _this select 0;
	_button = _this select 1;
	_x = _this select 2;
	_y = _this select 3;
	_control = _this select 5;
	
	if (not(_button == 0)) exitWith {};
	
	private["_target"];
	_target = _player getVariable "camera_target";
	if (not(isNil "_target")) exitWith {
		player groupChat format["Cannot teleport while camera is attached to a target"];
		false
	};
	
	private["_world_pos"];
	_world_pos = _display posScreenToWorld [_x,_y];

	private["_pos"];
	_pos = [_player] call camera_get_position;
	_world_pos set [2, (_pos select 2)];
	
	[_player, _world_pos] call camera_set_position;
	mapAnimAdd [0, (ctrlMapScale _display), _world_pos];
	mapAnimCommit;
	
	[_player] call camera_map_close;
	
	true
};


camera_remove_mouseButtonClick = {
	disableSerialization;
	private["_control"];
    _control = call camera_map_control;
	if (not(isnil "camera_mouseButtonClick_id")) then {
		_control ctrlRemovEeventHandler  ["MouseButtonClick", camera_mouseButtonClick_id];
		camera_mouseButtonClick_id = nil;
	};
};
 
camera_setup_mouseButtonClick = {
	private["_data"];
	_data = _this;
	disableSerialization;
	private["_control"];
    _control = call camera_map_control;
	if ( isnil "camera_mouseButtonClick_id" ) then {
		camera_mouseButtonClick_id = _control ctrlAddEventHandler  ["MouseButtonClick", format["[_this, %1] call camera_mouseButtonClick_handler", _data]];
		//player groupChat format["camera_mouseButtonClick_id = %1",camera_mouseButtonClick_id];
	};
};

camera_toggle = {
	private["_player"];
	_player = player;
	
	private["_camera"];
	
	_camera = _player getVariable "camera";
	_camera = if (isNil "_camera") then {objNull} else {_camera};
	
	if (isNull _camera) then {
		player groupChat format["Enabling camera!"];
		[] call camera_setup_mouseMoving;
		[] call camera_setup_keyDown;
		[] call camera_setup_keyUp;
		[] call camera_setup_mouseButtonClick;
		[] call camera_setup_MouseZChanged;
		[_player] call camera_create;

	}
	else {
		player groupChat format["Disabling camera!"];
		[] call camera_remove_mouseMoving;
		[] call camera_remove_keyDown;
		[] call camera_remove_keyUp;
		[] call camera_remove_mouseButtonClick;
		[] call camera_remove_MouseZChanged;
		[_player] call camera_destroy;
	};
};

camera_functions_defined =  true;