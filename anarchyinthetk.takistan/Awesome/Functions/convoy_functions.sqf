#define Spawn_convoy 1
#define Driver_dead 2
#define Damaged_convoy 3
#define Cop_escort 4

convoy_side_msg = {
	private ["_code", "_msg1","_msg2"];
	
	_code = _this select 0;
	_msg1 = "";
	_msg2 = "";
	
	switch(_code) do {
		case Spawn_convoy: {
			_msg1 = "Attention officers, the supply truck has entered North Takistan. Defend it against bandits and terrorists, and escort it to base.";
			_msg2 = "Rumors indicate that a valuable government truck has entered north takistan.";
		};
		case Driver_dead: {
			_msg1 = "The governemnt truck driver is dead. Save it from the bandits, and escort it to base.";
			_msg2 = "Rumors indicate that a valuable government truck is under attack in North Takistan.";
		};
		case Damaged_convoy: {
			_msg1 = "Attention officers, the governemnt truck is heavily damaged. Protect the truck at all costs!";
		};
		case Cop_escort: {
			_msg1 = format["%1-%2, you received $%3 for escorting the governemnt truck", player, (name player), govconvoybonus];
		};
	};
	
	if ([player] call player_cop) then {
		if (_code == Cop_escort) then {
			[player, govconvoybonus] call bank_transaction;
		};
		player sidechat format [ "%1",_msg1];
	}
	else { if(_msg2 != "") then{ 
		player sidechat format [ "%1",_msg2];}; 
	};
};

convoy_spawns = [convspawn1, convspawn2, convspawn3, convspawn4, convspawn5];
convoy_get_spawn = {
	private["_spawn"];
	_spawn = convoy_spawns select (floor(random(count convoy_spawns)));
	_spawn
};

convoy_create_truck = {
	private["_location"];
	_location = _this select 0;
	
	private["_class", "_truck"];
	_class = ["Ural_TK_CIV_EP1", "MTVR_DES_EP1"] call BIS_fnc_selectRandom;
	_truck = createVehicle [_class, _location, [], 0, "NONE"];

	_truck setVehicleInit 
	'
		convoy_truck = this; 
		this setVehicleVarName "convoy_truck"; 
		this setAmmoCargo 0; 
		clearweaponcargo this;
		clearmagazinecargo this;
	';	
	
	_truck setvariable ["tuning", 5, true];
	processinitcommands;
	_truck
};

convoy_create_marker = {
	private["_location"];
	_location = _this select 0;
	
	// spawn markers truck and soldiers
	private["_marker", "_name"];
	_name = "convoy";
	_marker = createMarker [_name, [0,0]];																				
	_marker setMarkerShape "ICON";								
	_marker setMarkerType "Marker";										
	_marker setMarkerColor "ColorRed";																														
	_marker setMarkerText "Government Convoy";
	_marker setMarkerPos [(_location select 0), (_location select 1)];
	_marker
};

convoy_unit_name = 0;
convoy_unit_class = 1;
convoy_unit_weapons = 2;
convoy_unit_magazines = 3;
convoy_unit_commander = 4;

convoy_units = [
	["convoysoldier", "US_Soldier_LAT_EP1", ["SCAR_L_CQC_Holo"], ["30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag"], true],
	["convoyguard1", "US_Soldier_LAT_EP1", ["SCAR_L_CQC_Holo"], ["30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag"], false],
	["convoyguard2", "US_Soldier_LAT_EP1", ["SCAR_L_CQC_Holo"], ["30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag"], false],
	["convoyguard3", "US_Soldier_LAT_EP1", ["SCAR_L_CQC_Holo"], ["30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag"], false],
	["convoyguard5", "US_Soldier_LAT_EP1", ["SCAR_L_CQC_Holo"], ["30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag"], false],
	["convoyguardmg", "US_Soldier_LAT_EP1", ["Mk_48_DES_EP1"], ["100Rnd_762x51_M240", "100Rnd_762x51_M240", "100Rnd_762x51_M240"], false],
	["convoyguardmg2", "US_Soldier_LAT_EP1", ["Mk_48_DES_EP1"], ["100Rnd_762x51_M240", "100Rnd_762x51_M240", "100Rnd_762x51_M240"], false]
];

convoy_create_units = {
	private["_truck", "_location"];
	_truck = _this select 0;
	_location = _this select 1;
	
	private["_convoy_group"];
	_convoy_group = createGroup west;
	
	{
		private["_data", "_name", "_class", "_weapons", "_magazines", "_commander"];
		_data = _x;
		_name = _data select convoy_unit_name;
		_class = _data select convoy_unit_class;
		_weapons = _data select convoy_unit_weapons;
		_magazines = _data select convoy_unit_magazines;
		_commander = _data select convoy_unit_commander;
	
		private["_unit"];
		_unit = _convoy_group createUnit [_class, _location, [], 0, "FORM"];
		_unit setVehicleInit format[
		'
			%1 = this; 
			this setSpeedMode "full"; 
			this allowFleeing 0;
			this setVehicleVarName "%1";
		', _name];
		processInitCommands;
		removeAllWeapons _unit;
		
		_unit addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
		
		_unit setSkill ["general", 0.86];
		_unit setSkill ["endurance", 1];
		_unit setSkill ["spotDistance", 1];
			
		{ _unit addWeapon _x } forEach _weapons;
		{ _unit addMagazine _x } forEach _magazines;
		
		if (_commander) then {
			_convoy_group selectLeader _unit;
			_unit moveInDriver _truck; 
			_unit assignAsDriver _truck;
			_unit setSkill ["commanding", 1];
		}
		else {
			_unit doFollow _truck;
			_unit moveInCargo _truck; 
			_unit assignAsCargo _truck;
		};
	} forEach convoy_units;
	
	_convoy_group setBehaviour "AWARE";
	_convoy_group setCombatMode "RED";
	
	sleep 2;
	_convoy_group
};

convoy_mission_loop = {
	format["convoy_mission_loop %1", _this] call convoy_debug;
	while {not(convoy_complete)} do {
		 _this call convoy_mission_iteration;
		convoy_running_time = convoy_running_time + 1;
		sleep 1;
	};

	if (convoy_complete) exitWith {};
	_this spawn convoy_mission_loop;
};

convoy_mission_check_damage = {
	private["_truck", "_group"];
	_truck = _this select 0;
	_group = _this select 1;
	
	if ((damage _truck) < 0.2) exitWith {};
	if (not([(driver _truck)] call player_exists)) exitWith {};

	private["_velocity", "_direction", "_speed"];
	
	_velocity = velocity _truck ;
	_direction = direction _truck ;		
	_speed = 5; 
	// speed boost when shots hits vehicle, is a permanent max fullspeed for vehicle, as 5 m/s is 180km/h
	_truck setVelocity [
		(_velocity select 0)+((sin _direction) * _speed), 
		(_velocity select 1) + ((cos _direction) * _speed),
		(_velocity select 2)
	];
};

convoy_mission_check_targets = {
	private["_truck", "_group", "_target"];
	_truck = _this select 0;
	_group = _this select 1;
	
	{
		_target = _x;
		if (([_target] call player_human) && not([_target] call player_cop) && (alive _target)) then {
			private["_message"];
			_message = "The Government is operating in this area! Turn back or you will be shot!";
			format['if (player == %1) then { titleText [toString(%2), "PLAIN"];};', _target, toArray(_message)] call broadcast;
			
			if ([_target] call player_armed) then {
				{
					_x doTarget _target;			
					_x doFire _target;
				} foreach (units _group);
			};
		};
	} foreach (nearestObjects [getPos _truck, ["Man"], 150]);
};

convoy_mission_check_state = {
	private["_truck", "_group"];
	_truck = _this select 0;
	_group = _this select 1;
	

	if (convoy_units_exited) exitWith {};
	
	if (not(alive driver(_truck))) then { 
		format['[Driver_dead] call convoy_side_msg;'] call broadcast;
		[_truck, _group] call convoy_units_exit;
		convoy_units_exited = true;
	}
	else { if (not(canMove _truck)) then {
		format['[Damaged_convoy] call convoy_side_msg;'] call broadcast;
		[_truck, _group] call convoy_units_exit;
		convoy_units_exited = true;				
	};};
};

convoy_units_exit = {
	private["_truck", "_group"];
	_truck = _this select 0;
	_group = _this select 1;
	
	_truck setVehicleLock "unlocked";
	_group setBehaviour "COMBAT";
		
	{ 
		if (alive _x) then {
			unassignVehicle _x;
			doGetOut _x;
			_x doWatch getPos _truck;
		};
	} foreach (units _group);
};

convoy_mission_check_complete = {
	private["_truck", "_group", "_time"];
	_truck = _this select 0;
	_group = _this select 1;
	_time = _this select 2;
	
	//the convoy cash has been stolen
	if (not(convoy_cash)) exitwith { 
		convoy_complete_side = Civilian;
		true
	};

	//exit early if the truck is dead
	if (not(alive _truck)) exitWith {
		private["_message"];
		_message = format["The goverment convoy truck was destroyed. The money has burned"];
		format['server globalChat toString(%1);', toArray(_message)] call broadcast;
		convoy_complete_side = sideUnknown;
		true
	};
	
	//convoy has been running for a while ... lets kill it
	if (_time >= 900) exitWith {
		convoy_complete_side = sideUnknown;
		// if there's a cop nearby and the trucks have the payroll until now, so this cop is well protecting truck :]
		{
			private["_unit"];
			_unit = _x;
			if ([_unit] call player_cop) exitWith {
				convoy_complete_side = west;
			};
		} foreach (nearestObjects [getpos _truck,["Man"], 60]);
		true
	};
	
	//convoy has arrived at its destination
	if (((driver _truck) distance _destination) < 25) exitWith {  		
		format['[Cop_escort] call convoy_side_msg;'] call broadcast;
		convoy_complete_side = west;
		true
	};
	
	false
};


/*
 * Simple state machine that controls the movement of the convoy.
 * UNKNOWN -> INITIAL: Send move command to the destination
 * INITIAL -> STUCK:   Send move command to the half-waypoint between current truck position, and destination
 * STUCK   -> STUCK:   Send move command to the half-waypoint between current truck position, and the pevious half-waypoint
 * STUCK   -> MOVING:  Send move command  to the destination
 * MOVING  -> MOVING:  No action
 * INITIAL -> MOVING:  No action
 */
 
#define UNKNOWN 0
#define INITIAL 1
#define STUCK 2
#define MOVING 3

convoy_state2str = {
	private["_state"];
	_state = _this select 0;
	
	if (_state == UNKNOWN) exitWith {"UNKNOWN"};
	if (_state == INITIAL) exitWith {"INITIAL"};
	if (_state == STUCK) exitWith {"STUCK"};
	if (_state == MOVING) exitWith {"MOVING"};
	"INVALID"
};

convoy_get_state = {
	private["_truck"];
	_truck = _this select 0;
	
	private["_state"];
	_state = _truck getVariable "state";
	_state = if (isNil "_state") then {UNKNOWN} else {_state};
	_state
};

convoy_set_state = {
	private["_truck", "_state"];
	_truck = _this select 0;
	_state = _this select 1;
	_truck setVariable ["state", _state, true];
};

convoy_get_current_state = {
	private["_truck", "_time"];
	
	_truck = _this select 0;
	_time = _this select 1;
	
	private["_cur_pos", "_last_pos"];
	_cur_pos = getPos _truck;
	_last_pos = _truck getVariable "last_pos";
	_last_pos = if (isNil "_last_pos") then {_cur_pos} else {_last_pos};
	
	private["_prev_state", "_cur_state"];
	_prev_state = [_truck] call convoy_get_state;
	_cur_state = if ((_cur_pos distance _last_pos) > 3 ) then {MOVING} else {STUCK};
	
	if (_prev_state == UNKNOWN) then {
		_truck setVariable ["last_pos", _cur_pos];
		_cur_state = INITIAL;
	};

	if ((_time % 20) == 0) then {
		_truck setVariable ["last_pos", _cur_pos];
	};
	
	_cur_state
};

calculate_half_waypoint = {
	//format["calculate_half_waypoint %1", _this] call convoy_debug;
	private["_point_a", "_point_b"];
	_point_a = _this select 0;
	_point_b = _this select 1;

	([((_point_b select 0)+(_point_a select 0))/ 2, ((_point_a select 1)+(_point_b select 1))/ 2, 0])
};

convoy_mission_check_position = {
	//format["convoy_mission_check_position %1", _this] call convoy_debug;
	
	private["_truck", "_group", "_destination", "_time"];
	_truck = _this select 0;
	_group = _this select 1;
	_destination = _this select 2;
	_time = _this select 3;
	
	private["_dst_pos", "_cur_pos"];
	_dst_pos = getPos _destination;
	_cur_pos = getPos _truck;
	
	private["_prev_state", "_cur_state"];
	
	_prev_state = [_truck] call convoy_get_state;
	_cur_state = [_truck, _time] call convoy_get_current_state;

	if (_prev_state == UNKNOWN && _cur_state == INITIAL) then {
		//send initial move command
		format["sending initial move command %1", _dst_pos] call convoy_debug;
		(driver _truck) commandMove _dst_pos;
		_truck setVariable ["next_pos", _dst_pos];
	}
	else { if ( (_prev_state == INITIAL && _cur_state == STUCK) ||
				(_prev_state == MOVING && _cur_state == STUCK) ||
				(_prev_state == STUCK && _cur_state == STUCK && (_time % 20) == 0)) then {
		//calculate the halfway point between the current, and the next position
		private["_next_pos", "_half_pos"];
		_next_pos = _truck getVariable "next_pos";
		_half_pos = [_cur_pos, _next_pos] call calculate_half_waypoint;
		format["sending half-way move command %1", _half_pos] call convoy_debug;
		_truck setVariable ["next_pos", _half_pos, true];
		(driver _truck) commandMove _half_pos;
	}
	else { if ((_prev_state == STUCK && _cur_state == MOVING)) then {
		//reset the waypoint for the final destination
		format["sending reset move command %1", _dst_pos] call convoy_debug;
		_truck setVariable ["next_pos", _dst_pos];
		(driver _truck) commandMove _dst_pos;
	};};};
	
	[_truck, _cur_state] call convoy_set_state;
	
};

convoy_mission_iteration = {
	//format["convoy_mission_iteration %1, %2", _this, convoy_running_time] call convoy_debug;
	private["_convoy_truck", "_convoy_group", "_convoy_marker", "_destination"];
	
	_convoy_truck = _this select 0;
	_convoy_group = _this select 1;
	_convoy_marker = _this select 2;
	_destination = _this select 3;
	
	[_convoy_truck, _convoy_group] call convoy_mission_check_targets;
	[_convoy_truck, _convoy_group] call convoy_mission_check_state;
	[_convoy_truck, _convoy_group] call convoy_mission_check_damage;
	
	convoy_complete = [_convoy_truck, _convoy_group, convoy_running_time] call convoy_mission_check_complete;
	if (convoy_complete) exitWith {};
	
	[_convoy_truck, _convoy_group, _destination, convoy_running_time] call convoy_mission_check_position;
	
	//update the convoy marker position
	_convoy_marker setMarkerPos (getPos _convoy_truck);
};

convoy_side2string = {
	private ["_side"];
	_side = _this select 0;

	if (_side == east) exitWith {"Opfor"};
	if (_side == west) exitWith {"Cop"};
	if (_side == civilian) exitWith {"Civilian"};
	if (_side == resistance) exitWith {"Insurgent"};
	"Neither"
};


convoy_debug = {
	diag_log format["%1", _this];
};


convoy_loop = {
	format["convoy_loop %1", _this] call convoy_debug;
	
	sleep (convoyrespawntime * 3);
	private["_message"];
	_message = "There are rumors that a government convoy is leaving in a few minutes.";
	format["hint toString(%1);", toArray(_message)] call broadcast;
	sleep (convoyrespawntime * 3);

	//Gets position to spawn
	private["_spawn", "_location"];
	_spawn = call convoy_get_spawn;
	_location = getPosATL _spawn;

	private["_convoy_truck", "_convoy_marker", "_convoy_group"];
	_convoy_truck = [_location] call convoy_create_truck;
	_convoy_marker = [_location] call convoy_create_marker;
	_convoy_group = [_convoy_truck, _location] call convoy_create_units;
	
	format['[Spawn_convoy] call convoy_side_msg;'] call broadcast;

	//init convoy globals
	convoy_complete = false;
	convoy_cash = true;
	convoy_complete_side = sideUnknown;
	convoy_running_time = 0;
	convoy_units_exited = false;
	
	publicVariable "convoy_cash";
	
	//start the convoy loop, and wait for it to complete
	[_convoy_truck, _convoy_group, _convoy_marker, copbase1] spawn convoy_mission_loop;	
	waitUntil {convoy_complete};

	//announce who won the convoy
	private["_side_str"];
	_side_str = [convoy_complete_side] call convoy_side2string;
	_message = format["%1 side won the goverment convoy mission. Next truck leaves in %2 minutes", _side_str, convoyrespawntime];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	
	sleep 10;
	
	//cleanup the convoy items
	{deleteVehicle _x;} foreach units _convoy_group;
	deleteVehicle _convoy_truck; 
	deleteGroup _convoy_group;
	deleteMarker _convoy_marker;
	
	//waits for respawn
	sleep (convoyrespawntime * 54);
	
	[] spawn convoy_loop;
};

if (isServer) then {
	[] spawn convoy_loop;
};

// bla bla bla these people thought it was cool to put their names here
// Convoy ideia by Eddie Vedder for the Chernarus life Revivved mission, code rewrite and improvement by a old beggar working for food :P
// written by Gman, rewrited by aliens
