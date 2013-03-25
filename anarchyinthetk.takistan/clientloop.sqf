#include "Awesome\Functions\macro.h"
if (not(isNil "client_loop_functions_defined")) exitWith {};

liafu = true;

player_is_armed = false;
check_armed_player = {
	private["_player"];
	_player = _this select 0;

	if ((primaryWeapon _player) != "") exitWith {true};
	if ((secondaryWeapon _player) != "") exitWith {true};
	
	//check if player is gunner
	private["_vehicle", "_in_vehicle", "_is_commander", "_is_driver", "_is_gunner"];
	_vehicle = (vehicle _player);
	_is_driver = (driver(_vehicle) == _player);
	_in_vehicle = (_vehicle != _player);
	_is_commander = (commander(_vehicle) == _player) && not(_is_driver);
	_is_gunner = (gunner(_vehicle) == _player);
	if (_in_vehicle && (_is_gunner || _is_commander))  exitWith { true };
	
	//Check if player has a suicide vest or similar bomb
	private["_armed_items"];
	//Remote bomb, timed bomb, activated bomb (ied), speed bomb, suicide vest, lighter
	_armed_items = ["fernzuenderbombe", "zeitzuenderbombe", "aktivierungsbombe", "geschwindigkeitsbombe", "selbstmordbombe", "lighter"];
	if([_player, _armed_items] call INV_HasItem) exitWith { true };
	
	//check if player has pistol
	private["_weapon"];
	_weapon = (currentWeapon _player);
	if ([_weapon, "GrenadeLauncher"] call shop_weapon_inherits_from) exitWith { true }; //Throw (Grenades), Put (IEDs)
	if ([_weapon, "PistolCore"] call shop_weapon_inherits_from) exitWith { true };
	if (call holster_pistol_in_inventory) exitWith { true };
	false;
};

check_armed_mounted = {
	private["_vehicle"];
	
	_vehicle = _this select 0;
	
	//check if the vehicle has a mounted player with a weapon
	private["_occupants"];
	_occupants = [_vehicle] call mounted_get_occupants;
	//player groupChat format["_occupants = %1", _occupants];
	private["_armed_occupant"];
	_armed_occupant = nil;
	
	{
		private["_occupant"];
		_occupant = _x;
		if (([_occupant] call check_armed_player)) exitWith {
			_armed_occupant = _occupant;
		};
	} forEach _occupants;
	
	not(isNil "_armed_occupant")
};


check_armed_vehicle = {
	private["_in_vehicle", "_horns",  "_player", "_vehicle"];
	
	_player = _this select 0;
	_vehicle = (vehicle player);
	_in_vehicle = (_vehicle != _player);
	
	if (not(_in_vehicle)) then {
		_vehicle = [_player] call mounted_player_get_vehicle;
	};
	
	if (isNil "_vehicle") exitWith {false};
	
	//check if the vehicle has a weapon
	private["_weapon"];
	_weapon = currentWeapon _vehicle;
	if ([(currentWeapon _vehicle), "CarHorn"] call shop_weapon_inherits_from) exitWith { false };
	
	([_vehicle] call check_armed_mounted)
};

check_armed_stunning = {
	private["_player"];
	_player = _this select 0;
	
	if (isNil "was_stunning_count") then { was_stunning_count = 0; };
	if (isNil "stunning" ) then { stunning = false;};
	if (isNil "was_stunning") then { was_stunning = false;};
	
	private["_delay"];
	_delay = 30;
	//Delayed check for player stunning within the last X seconds
	if (stunning) then 	{ 
		was_stunning = true; 
		was_stunning_count = 0;
	}
	else { if ( !stunning && was_stunning) then {
		if (was_stunning_count < _delay) then { was_stunning_count = was_stunning_count + 1;};
		if (was_stunning_count >= _delay) then { was_stunning = false; was_stunning_count = 0;};
	};};
	
	//player groupChat format["STUNNING: %1, WAS STUNNING: %2", stunning, was_stunning];
	was_stunning
};

check_armed = {
	private["_player"];
	_player = _this select 0;
	
	if (isNil "_player") exitWith { false };
	if (not(alive _player)) exitWith {false};
	
	private["_armed_vehicle", "_armed_player"];
	_armed_vehicle = ([_player] call check_armed_vehicle);
	_armed_player =  ([_player] call check_armed_player);
	_was_stunning = ([_player] call check_armed_stunning);
	
	//player groupChat format["_armed_vehicle = %1, _armed_player = %2, _was_stunning = %3", _armed_vehicle, _armed_player, _was_stunning];
	
	private["_armed"];
	_armed = _armed_vehicle || _armed_player || _was_stunning;
	[_player, _armed] call player_update_armed;
	_player setVariable ["armed", _armed];
	_armed
};



compare_array = {
	private["_a", "_b"];
	_a = _this select 0;
	_b = _this select 1;
	if (isNil "_a") exitWith { false };
	if (isNil "_b") exitWith { false };
	if (typeName _a != "ARRAY") exitWith {false};
	if (typeName _b != "ARRAY") exitWith {false};
	if (count _a != count _b) exitWith {false};
	
	private["_i"];
	_i = (count _a) - 1;
	while {_i >= 0} do {
		if (str(_a select _i) != str(_b select _i)) exitWith { false };
		_i = _i - 1;
	};
	
	(_i == -1)
};


check_keychain = {
	private["_player"];
	_player = player;
	if (([_player, "keychain"] call INV_GetItemAmount) == 1) exitWith {};	
	[_player, "keychain", 1] call INV_SetItemAmount;
};

check_inventory = {
	if (not(alive player)) exitWith {};
	
	private["_player"];
	_player = player;
	
	call check_keychain;
};


cop_stun_gun_modify = {
	if (!iscop) exitWith {};
	if((player ammo (currentWeapon player)) <= 0) exitWith {};
	if (not(alive player)) exitWith {};
	
	if ((((currentWeapon player) == "M9" || (currentWeapon player) == "M9SD")) && ((currentMagazine player) == ("15Rnd_9x19_M9SD"))) then {	
		_magazines = magazines player;
		_magazines_count = {_x == "15Rnd_9x19_M9SD"} count (_magazines);
		_ammo = player ammo (currentWeapon player);
				
		if (_ammo > stunshotsmax) then {
			{
				if (_x == "15Rnd_9x19_M9SD") then {
					player removeMagazine _x;
				};
			} forEach _magazines;
						
			for [{_c=0}, {_c < (_magazines_count)}, {_c=_c+1}] do {
				player addMagazine ["15Rnd_9x19_M9SD", stunshotsmax];
			};
		};
	};	
};

check_money = {
	private ["_player", "_money"];
	_player = player;
	
	_money = [player, 'money'] call INV_GetItemAmount;
	if (_money < 0) then {
		[_player, 'money', 0] call INV_SetItemAmount; 
		_money = 0;
	};
		
	if (_money > money_limit) then {
		[_player, 'money', money_limit] call INV_SetItemAmount; 
		player groupChat format["You can't carry more than $%1 in your inventory. Money was removed.", strM(money_limit)];
	}; 
};

check_bank = {
	private ["_bank_account", "_player"];
	_player = player;
	_bank_account = [_player] call bank_get_value;
	
	if (_bank_account > bank_limit) exitWith {
		[_player, bank_limit] call bank_set_value; 
		player groupChat format["You can't have more than $%1 in your bank account. Money has been removed.", strM(bank_limit)];
	};
};

check_actions = {
	private["_vehicle"];
	_vehicle = (vehicle player);
	_in_vehicle = (_vehicle != player);
	if (not(_in_vehicle)) exitWith {};
		
	if ((typeOf _vehicle == "ArmoredSUV_PMC")) then {
		[_vehicle] call armored_suv_add_actions;
	};
	
	if (_vehicle isKindOf "Air") then {
		[_vehicle] call halo_jump_add_actions;
	};
};


check_factory_actions = {
	private["_player"];
	_player = player;
	private["_vehicle", "_in_vehicle"];
	_vehicle = (vehicle _player);
	_in_vehicle = (_vehicle != _player);
	
	private["_factory"];
	_factory = [_player, 5] call factory_player_near;
	if (isNil "_factory" || not(INV_shortcuts) || _in_vehicle || not(alive _player)) exitWith {
		[_player] call factory_remove_actions;
	};
	
	private["_factory_id"];
	_factory_id = _factory select factory_id;
	
	[_player, _factory_id] call factory_add_actions;
};

check_gang_area_actions = {
	private["_player"];
	_player = player;
	private["_vehicle", "_in_vehicle"];
	_vehicle = (vehicle _player);
	_in_vehicle = (_vehicle != _player);
	
	private["_gang_area"];
	_gang_area = [_player, 5] call gang_area_player_near;
	if (isNil "_gang_area" || not(INV_shortcuts) || _in_vehicle || not(alive _player)) exitWith {
		[_player] call gang_area_remove_actions;
	};

	[_player, _gang_area] call gang_area_add_actions;
};

check_workplaces = {
	{
		private["_workplace", "_object", "_radius"];
		_workplace = _x;
		_object = _workplace select workplace_object;
		_radius = _workplace select workplace_radius;
		if ((player distance _object) < _radius) then {
			timeinworkplace = timeinworkplace + 1;
		};
	} forEach workplacearray;
};


logics_check_object = 0;
logics_check_warn_distance = 1;
logics_check_teleport_distance = 2;

logics_checks = [
	[terrorhideoutlogic, 900, 750],
	[assassinlogic, 160, 80],
	[deadcamlogic, 400, 300],
	[impoundarea1, 400, 100]
];

check_logics = {
	private["_alive"];
	_alive = alive player;
	
	if (not(_alive)) exitWith {};

	{
		private["_entry", "_cdistance", "_logic", "_warn_distance", "_teleport_distance"];
		_entry = _x;
		
		_warn_distance = _entry select logics_check_warn_distance;
		_teleport_distance = _entry select logics_check_teleport_distance;
		_logic = _entry select logics_check_object;
		_distance = player distance _logic;
		
		
		if (_distance <= _teleport_distance) exitWith {
			[player] call player_teleport_spawn;
			player groupChat format["You have been teleported out of a restricted zone"];
		};
		
		if (_distance < _warn_distance) exitWith {
			titleText ["You are entering a restricted zone. Turn around!", "plain"]
		};
		
	} forEach logics_checks;
};




check_camera = {
	if (isnil "admin_camera_on") then {	admin_camera_on = false; };
};

bases_check_faction_bool = 0;
bases_check_trigger_area = 1;
bases_check_teleport_height = 2;
bases_check_teleport_marker = 3;
bases_check_teleport_message = 4;

bases_checks = [
	["isins", "ins_area_1", 20, "telehesnotins", "You were teleported out of the Insurgent base!"],
	["isopf", "opfor_area_1", 20, "telehesnottla", "You were teleported out of the TLA base!"],
	["iscop", "blufor_area_1", 20, "telehesnotcop", "You were teleported out of the Police base!"]
];

check_bases = {
	private["_vehicle"];
	_vehicle = vehicle player;
	if (admin_camera_on) exitWith {};
	
	{
		private["_base_check", "_faction_bool", "_trigger_area", "_teleport_height", "_teleport_marker", "_teleport_message"];
		_base_check = _x;
		
		_faction_bool =  missionNamespace getVariable (_base_check select bases_check_faction_bool);
		_trigger_area = missionNamespace getVariable (_base_check select bases_check_trigger_area);
		_teleport_height = _base_check select bases_check_teleport_height;
		_teleport_marker = _base_check select bases_check_teleport_marker;
		_teleport_message = _base_check select bases_check_teleport_message;
		
		private["_altitude"];
		_altitude = (getPosATL _vehicle) select 2;
		
		if (_vehicle in (list _trigger_area) && (_altitude < _teleport_height) && not(_faction_bool)) exitWith {
			_vehicle setVelocity [0,0,0];
			_vehicle setPos (getMarkerPos _teleport_marker);
			player groupChat _teleport_message;
		};
	} forEach bases_checks;
};


check_static_weapons = {
	private["_vehicle","_isStatic"];
	_vehicle = (vehicle player);
	_isStatic = (_vehicle isKindOf "StaticWeapon");
	if (not(_isStatic)) exitWith {};
	
	_vehicle lock false;
};



check_smoke_grenade = {
	private["_flashed"];
	_flashed = player getVariable "flashed";
	
	if (isNil "_flashed") exitWith {};
	if (typeName _flashed != "BOOL") exitWith {};
	if (not(_flashed)) exitWith {};
	
	private ["_mask", "_fadeInTime", "_fadeOutTime"];
	
	_mask = player getvariable "gasmask";
	_mask = if (isNil "_mask") then { false } else { _mask };
	_mask = if (typeName "_mask" != "BOOL") then { false } else { _mask };
	
	player setVariable ["gasmask", _mask, true];
	if (_mask) exitWith {};
	
	[] spawn {
		private ["_fadeInTime", "_fadeOutTime"];
		_fadeInTime   = 1;
		_fadeOutTime  = 5;
		if (not(alive player)) exitWith {};
		titleCut ["","WHITE OUT",0];
		sleep _fadeOutTime;
		titleCut ["","WHITE IN",0];
		sleep _fadeInTime;
		player setVariable ["flashed", false, true];
	};
};

check_droppable_items = {
	//player groupChat format["check_droppable_items %1", _this];
	private["_player"];
	_player = player;
	if (not(alive _player)) exitWith {};
	
	private["_current_object"];
	_current_object = _player getVariable "current_object";
	_current_object = if (isNil "_current_object") then {objNull} else {_current_object};
	
	private["_objects", "_near_object"];
	_objects = nearestObjects [getPos _player, droppableitems, 5];
	//player groupChat format["_objects = %1", _objects];
	_near_object = if (count _objects == 0) then {objNull} else {_objects select 0};
	
	if (isNull _current_object && isNull _near_object) exitWith {};
	
	//remove the action for the previous object
	if (not(isNull _current_object)) then {
		private["_distance"];
		_distance = _current_object distance _player;
		if (_distance < 3) exitWith {};
		
		private["_action_id"];
		_action_id = _player getVariable "current_action";
		if (not(isNil "_action_id")) then {
			_player removeAction _action_id;
			_player setVariable ["current_action", nil];
			//player groupChat format["REMOVED: _action_id = %1, _object = %2", _action_id, _current_object];
		};
		_player setVariable ["current_object", nil];
	};
	
	_current_object = _player getVariable "current_object";
	_current_object = if (isNil "_current_object") then {objNull} else {_current_object};
	
	if (not(isNull(_current_object))) exitWith {};
	
	//add the action for the new object
	if (not(isNull _near_object)) then {
		private["_distance"];
		_distance = _near_object distance _player;
		if (not(_distance < 3)) exitWith {};

		private["_amount", "_item", "_illegal"];
		_amount = _near_object getVariable "amount";
		_item = _near_object getVariable "item";
		
		if (isNil "_amount" || isNil "_item") exitWith {};
		
		private["_name"];
		_amount = [_amount] call decode_number;
		_name = (_item call INV_GetItemName);
		_isIllegal = (_item call INV_GetItemIsIllegal);
		
		private["_action_id"];
		if ((isCop) and (_isIllegal)) then {
			// Copside illegal item. Same global variable on purpose (either is picking something up OR seizing, not both the same time)
			_action_id = _player addAction [
				format["Seize %1 (%2)", _name, strM(_amount)], "noscript.sqf", 
				format['[%1, %2] call interact_object_seize', _player, _near_object], 1, false, true, "", 
				format['not(interact_object_pickup_active) && (((player distance %1) < 3) && (count([%1, 3] call players_object_near) < 2))', _near_object]
			];
		} else {
			//Not on copside or legal item
			_action_id = _player addAction [
				format["Pickup %1 (%2)", _name, strM(_amount)], "noscript.sqf", 
				format['[%1, %2] call interact_object_pickup', _player, _near_object], 1, false, true, "", 
				format['not(interact_object_pickup_active) && (((player distance %1) < 3) && (count([%1, 3] call players_object_near) < 2))', _near_object]
			];
		};
		//player groupChat format["ADDED: _action_id = %1, _object = %2", _action_id, _near_object];
		_player setVariable ["current_object", _near_object];
		_player setVariable ["current_action", _action_id];
	};
};

check_restrains = {
	if (iscop) exitWith {};
	if (not(alive player)) exitWith {};
	
	private["_physicallyRestrained", "_logicallyRestrained"];
	_physicallyRestrained = ((animationState player) ==  "civillying01");
	_logicallyRestrained = [player, "restrained"] call player_get_bool;
	
	if (_logicallyRestrained && not(_physicallyRestrained)) then {
		format['%1 switchMove "civillying01";', player] call broadcast;
	}
	else { if (not(_logicallyRestrained) && _physicallyRestrained) then {
		format['%1 switchMove "amovppnemstpsnonwnondnon";', player] call broadcast;
		[player, "isstunned", false] call player_set_bool;
		StunActiveTime=0;
	}
	else { if (_logicallyRestrained && _physicallyRestrained) then {
		if (not([player, 50] call player_near_cops)) then {
			[player, "restrained", false] call player_set_bool;
			player groupChat format["You have managed to unrestrain yourself!"];
		};
	};};};
};

check_respawn_time = {
	if (not(alive player)) exitWith {};
	private["_interval"];
	_interval = 30;
	if (not((time % _interval) == 0)) exitWith {};
	[player, "extradeadtime", -(_interval)] call player_update_scalar;
	
};
client_loop = {
	private ["_client_loop_i"];
	_client_loop_i = 0; 

	while {_client_loop_i < 5000} do {
		[player] call check_armed;
		call check_money;
		call check_bank;
		call check_actions;
		call check_factory_actions;
		call check_gang_area_actions;
		call check_inventory;
		call cop_stun_gun_modify;
		call check_workplaces;
		call check_logics;
		call check_tampering;
		call check_camera;
		call check_bases;
		call check_static_weapons;
		call check_respawn_time;
		call check_smoke_grenade;
		call check_droppable_items;
		call check_restrains;
		sleep 0.5;
		disableuserinput false;
		_client_loop_i = _client_loop_i + 1;
	};
	[] spawn client_loop;
};

[] spawn client_loop;

client_loop_functions_defined = true;