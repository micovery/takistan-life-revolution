
enable_admin_camera =  {
	player setVehicleInit "this allowDamage false; this hideObject true;";
	processInitCommands;

	if (isnil "target_player") then {
		target_player = cop1;
	};

	original_position = getpos player;
	player groupChat "Entering camera mode";

	call reset_camera_offset;
	admin_camera_on = true;
	player setVariable ["has_admin_camera", true, true];

	while {admin_camera_on}  do {
		admin_camera_running = true;	
		if (!isnil "target_player") then {
			player attachTo [(vehicle target_player), camera_offset];
		};
		sleep 0.5;
	};
	
	player groupChat "Exiting camera mode";
	admin_camera_running = false;
	player setVariable ["has_admin_camera", false, true];
	
	call restore_admin_camera;
};

liafu = true;

restore_admin_camera = {
	player setVehicleInit "this allowDamage true; this hideObject false;";
	processInitCommands;
	clearVehicleInit player;
	detach player;
	player setVelocity [0, 0, 0];

	if (!(isnil "original_position")) then {
		player groupChat "Setting you back to original position";
		player setpos original_position;
	};
};

target_player_index = 0;
switch_target_player = {
	private["_dir"];
	_dir = _this select 0;

	if (isnil "_dir") then { _dir = 1;};

	if (_dir == 0) then {
		target_player = nil;
		detach player;
		player groupChat "You are now in detached camera mode, watch out!";
	}
	else {
		private["_target_player"];
		_size = count playerstringarray;	
		while {true} do {
			target_player_index = target_player_index + _dir;
			target_player_index = if (target_player_index == _size) then { 0 } else { target_player_index};
			target_player_index = if (target_player_index == -1) then { _size } else { target_player_index };

			private["_player_variable_name"];
			_player_variable_name = playerstringarray select target_player_index;
			_target_player = missionNamespace getVariable _player_variable_name;
			if (([_target_player] call player_human) && str(_target_player) != str(player)) exitWith {};
		};

		player groupChat format["Camera target set to %1 (%2)", (name _target_player), _target_player];
		target_player = _target_player;
	};
};

toggle_admin_camera = {
	if ((isnil "admin_camera_on") || !admin_camera_on) then {	
		admin_camera_on = true;
		player groupChat "Enabling admin camera!";
		[] spawn enable_admin_camera;
	}
	else {
		admin_camera_on = false;
		player groupChat "Disabling admin camera!";
	};
};

reset_camera_offset = {
	if (isnil "camera_offset") then {
		camera_offset = [0,-2,2];
	};
};

c_handler =  {
	_key = _this select 1;
	add_positions = {
		_pos1 = _this select 0;
		_pos2 = _this select 1;
		[(_pos1 select 0) + (_pos2 select 0), (_pos1 select 1) + (_pos2 select 1), (_pos1 select 2) + (_pos2 select 2)]
	};
  
	call reset_camera_offset;
	
	private["_d"];
	_d = 1;
		
	switch _key do {
		//UP ARROW
		case 200: {
			//+Y
			camera_offset = [camera_offset, [0,_d,0]] call add_positions;
		};

		//DOWN ARROW
		case 208: {
			//-Y
			camera_offset = [camera_offset, [0,_d*-1,0]] call add_positions;		
		};

		//LEFT ARROW
		case 203: {
			//-X
			camera_offset = [camera_offset, [_d*-1,0,0]] call add_positions;
		};

		//RIGHT ARROW
		case 205: {
			//+X
			camera_offset = [camera_offset, [_d,0,0]] call add_positions;
		};

		//NUMPAD ZERO
		case 82: {
			//+Z
			camera_offset = [camera_offset, [0,0,_d]] call add_positions;
		};

		//NUMPAD DEL
		case 83: {
			//-Z
			camera_offset = [camera_offset, [0,0,_d*-1]] call add_positions;
		};
		
		//DELETE 
		case 211: {
			//Reset camera
			camera_offset = [0,-2,2];
		};

		//PGUP
		case 201: {
			[1] call switch_target_player;
		};

		//PGDOWN
		case 209: {
			[-1] call switch_target_player;
		};
		//RIGHT CTRL
		case 157: {
			call toggle_admin_camera;
		};
		
		//INSERT
		case 210: {
			[0] call switch_target_player;
		};
	};
	false
};


setup_c_handler =  {
	disableSerialization;
    _display = findDisplay 46;
	admin_camera_on = false;
	camera_offset = nil;

	if (!(isnil "camera_handler_id")) exitWith  {
		player groupChat "Unloading admin camera.";
		_display displayRemoveEventhandler [ "KeyDown", camera_handler_id];
		camera_handler_id = nil;
	};

	call reset_camera_offset;
	player groupChat "Loading admin camera.";
	player groupChat "Use Right Control key to enter/exit camera mode.";
	player groupChat "Use PgUp/PgDown keys to switch camera target.";
	player groupChat "Use Arrow keys to adjust X and Y axis.";
	player groupChat "Use Numpad 0/Del keys to adjust Z axis.";
	player groupChat "Use Delete key to reset X,Y,Z axis.";
	player groupChat "Use Insert key to detach from camera target";
	
	camera_handler_id = _display displayAddEventHandler  ["KeyDown"," _this call c_handler;"];
};

[] call setup_c_handler;
[] call toggle_admin_camera;




