#include "Awesome\Functions\dikcodes.h"


stunned_allowed_actions = ["Chat", "NextChannel", "PrevChannel", "VoiceOverNet", "ShowMap", "PushToTalkAll", "PushToTalkCommand", "PushToTalkDirect", "PushToTalkGroup", "PushToTalkSide", "PushToTalkVehicle", "PushToTalkAll", "PushToTalk"];

keyboard_get_stunned_allowed_keys = {
	private["_keys"];
	
	_keys = [];
	{
		private["_action"];
		_action = _x;
		_keys = _keys + (actionKeys _action);
	} forEach stunned_allowed_actions;
	_keys
};

keyboard_animation_handler = {

	if(!INV_shortcuts) exitWith { false };
	if(arrested) exitWith{ false };
	if (([player, (vehicle player)] call mounted_player_inside)) exitWith { false };
	
	if(dialog) exitWith {closeDialog 0;};
	[] execVM "animdlgopen.sqf";
	true
};

keyboard_tlr_keys_handler = {
	private["_key_spam"];
	_key_spam = false;
	if (isNil "handling_tlr_toggle") then {
		handling_tlr_toggle = true;
	}
	else { if ( handling_tlr_toggle) then {
		_key_spam = true;
	};};
	if (_key_spam) exitWith {};
	
	if (INV_shortcuts) then {
		titletext["TLR keys off", "PLAIN DOWN"];
		call A_actionsremove;
		INV_shortcuts = false;
	}
	else {
		titletext["TLR keys on", "PLAIN DOWN"];
		call A_actions;
		INV_shortcuts = true; 
	};
	
	handling_tlr_toggle = false;
	true
};

keyboard_lock_unlock_handler = {
	if(not(INV_shortcuts)) exitWith { false };
	private["_vehicles"];
	_vehicles = nearestObjects [getpos player, ["LandVehicle", "Air", "ship"], 10];
	if (not((count _vehicles ) > 0)) exitWith {};
	
	private["_player"];
	_player = player;
	
	private["_vehicle"];
	_vehicle = _vehicles select 0;
	
	private["_inside_vehicle"];
	_inside_vehicle = ((vehicle _player) != _player);
	_vehicle = if (_inside_vehicle) then {(vehicle player)} else {_vehicle};
	
	if (not([_player, _vehicle] call vehicle_owner)) exitWith {
		player groupchat "You do not have the keys to this vehicle";
		true
	};
	
	private["_state"];
	_state = [_vehicle] call vehicle_toggle_lock;
	private["_message"];
	_message = if (_state) then {"Vehicle locked"} else {"Vehicle unlocked"};
	player groupChat _message;
		
	true
};

keyboard_trunk_handler = {
	if(!INV_shortcuts) exitWith { false };
	if(dialog) exitWith {closeDialog 0; false };

	private["_vcls", "_vcl"];
	_vcls = nearestobjects [getpos player, ["LandVehicle", "Air", "ship", "TKOrdnanceBox_EP1"], 25];
	_vcl = _vcls select 0;

	
	private["_inside_vehicle"];
	_inside_vehicle = not((vehicle player) == player);
	if (_inside_vehicle) exitWith {
		player groupChat format["You must be outside the vehicle to use the trunk"];
	};
	
	private["_vehicle"];
	_vehicle = cursorTarget;
	if (isNil "_vehicle") exitWith {false};
	if (typeName _vehicle != "OBJECT") exitWith {false};
	if (not(_vehicle isKindOf "LandVehicle" || _vehicle isKindOf "Air" || _vehicle iskindOf "Ship" || _vehicle isKindOf "TKOrdnanceBox_EP1")) exitWith {false};
	
	private["_distance"];
	_distance = _vehicle distance player;;
	if (_distance > 10 ) exitWith {false};
	if (_distance > 5 ) exitWith {
		player groupChat format["You need to be closer to the vehicle to use the trunk"];
	};
	
	
	
	if(not([player, _vehicle] call vehicle_owner)) exitWith {
		player groupchat "You do not have the keys to this vehicle.";
		false
	};
	
	if (([_vehicle] call trunk_in_use)) exitWith { 
		player groupChat format["This vehicle's trunk is being used by %1", ([_vehicle] call trunk_user)];
		false
	};
	
	[_vehicle] call trunk_open;
	[player, _vehicle] call interact_vehicle_storage_menu;
	true
};

keyboard_stunned_check = {
	(([player, "isstunned"] call player_get_bool))
};

keyboard_restrained_check = {
	if (iscop) exitWith {false};
	([player, "restrained"] call player_get_bool)
};


keyboard_interact_handler = {
	private["_ctrl"];
	_ctrl = _this select 0;
	
	if (!INV_shortcuts) exitWith {false};
	if (keyblock) exitWith {false};
	if (dialog ) exitWith {closeDialog 0; false};
	if (arrested) exitWith{ false };

	private ["_civ", "_handled", "_i"];

	//INTERACTIONS WITH PLAYERS, AI, ATM
	for [{_i=1}, {_i < 3}, {_i=_i+1}] do {
		if(vehicle player != player) exitWith {false};
		_range = _i;
		_dirV = vectorDir vehicle player;
		_pos = player modelToWorld [0,0,0];
		_posFind = [(_pos select 0)+(_dirV select 0)*_range,(_pos select 1)+(_dirV select 1)*_range,(_pos select 2)+(_dirV select 2)*_range];
		_men    = nearestobjects [_posFind,["Man", "RUBasicAmmunitionBox", "UNBasicAmmunitionBox_EP1", "BarrelBase", "Barrels"], 1] - [player];
		_atms   = nearestObjects [_posFind,["Man", "Misc_cargo_cont_tiny", "BarrelBase", "Barrels"],2];
		_civ    = _men select 0;
		_atm	= _atms select 0;

		_handled = [player, _atm] call interact_atm;
		if (_handled) exitWith {};
		
		_handled = [player, _civ] call interact_human;
		if (_handled) exitWith {};
		
		_handled = [player, _civ] call interact_ai;
		if (_handled) exitWith {};
	};

	if(_handled) exitWith { true };

	//INTERACTIONS WITH VEHICLES
	private["_player_inside"];
	_player_inside = [player, (vehicle player)] call mounted_player_inside;
	//player groupChat format["_player_inside = %1", _player_inside];
	if (not(_player_inside) && not(_ctrl)) exitWith {
		private ["_vcl"];
		for [{_i=1}, {_i < 3}, {_i=_i+1}] do {
			_range = _i;
			_dirV = vectorDir vehicle player;
			_pos = player modelToWorld [0,0,0];
			_posFind = [(_pos select 0)+(_dirV select 0)*_range,(_pos select 1)+(_dirV select 1)*_range,(_pos select 2)+(_dirV select 2)*_range];
			_vcls    = nearestobjects [_posFind,["LandVehicle", "Air", "ship"], 5];
			_vcl     = _vcls select 0;
			if(not(isnull _vcl)) exitWith {_i = 4};
		};

		if(locked _vcl) exitWith { false };
		
		private["_entered"];
		_entered = [player, _vcl, false] call player_enter_vehicle;
		
		if (_entered) exitWith {
			 [] spawn {
				keyblock=true; 
				sleep 1;
				keyblock=false;
			};
			true
		};
		false
	};

	_vcl  = vehicle player;

	if(_vcl != player) exitWith {
		if(locked _vcl) exitWith {
			player groupchat "The vehicle is locked. Disembark by pressing Control + E"; 
			false 
		};
		if(speed _vcl > 30) exitWith {
			player groupchat "The vehicle is moving too fast"; 
			false 
		};
		[player, _vcl, false] call player_exit_vehicle;
		true
	};
	
	true
};

keyboard_breakout_vehicle_handler = {
	if(!INV_shortcuts) exitWith {false};
	if (keyblock) exitWith {false};
	[player, (vehicle player)] spawn interact_vehicle_breakout;
	true
};

keyboard_cop_siren_handler = {
	if(!INV_shortcuts) exitWith {false};
	private["_isDriver"];
	_isDriver = (driver(vehicle player) == player);
	if (not(_isDriver)) exitWith { false };
	[0,0,0,["activate"]] execVM "siren.sqf";
	true
};

keyboard_stun_handler = {
	if(!INV_shortcuts) exitWith {false};
	[3, player] execVM "Awesome\Scripts\Stun.sqf";
	true
};

keyboard_cop_horn_handler = {
	if(!INV_shortcuts) exitWith {false};
	private["_isDriver"];
	_isDriver = (driver(vehicle player) == player);
	if (not(_isDriver)) exitWith { false };
	[0,0,0,["activate"]] execVM "Awesome\Scripts\policehorn.sqf";
	true
};

keyboard_main_dialog_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false };
	[0,0,0,["spielerliste"]] execVM "maindialogs.sqf";
	true
};

keyboard_inventory_dialog_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false};
	[player] spawn interact_inventory_menu;
	true
};

keyboard_retributions_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false};
	["open"] spawn retributions_main;
	true
};

keyboard_surrender_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(keyblock || vehicle player != player) exitWith {false};
	keyblock=true; [] spawn {
		sleep 2; 
		keyblock=false;
	};
	player playmove "amovpercmstpssurwnondnon";
	true;
};

keyboard_switch_normal_handler = {
	if(!INV_shortcuts) exitWith {false};	
	if(keyblock) exitWith {false};
	keyblock=true; 
	[] spawn {
		sleep 2; 
		keyblock=false;
	};
	format ["%1 switchmove ""%2"";", player, "normal"] call broadcast;
	true
};

keyboard_gangs_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false};
	if (not(isciv)) exitWith {false};
	[player] call interact_gang_menu;
	true
};

keyboard_admin_menu_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false};
	if (!isAdmin) exitWith {false};
	
	[player] call interact_admin_menu;
	true
};

keyboard_cop_menu_handler = {
	if(!INV_shortcuts) exitWith {false};
	if(dialog) exitWith {closeDialog 0; false};
	if (not(iscop)) exitWith {false};
	if ([player] call player_get_dead) exitWith {};
	
	private["_inVehicle"];
	_inVehicle = (vehicle player != player);
	
	if (not(_inVehicle)) then {
		[0,0,0,["copmenulite"]] execVM "maindialogs.sqf";
	}
	else {
		[0,0,0,["copmenu"]] execVM "maindialogs.sqf";
	};
	
	true
};


keyboard_an2_faster_handler = {
	private["_vcl", "_lvl", "_vel", "_spd"];
	_vcl = vehicle player;
	
	if (not(_vcl iskindof "An2_Base_EP1")) exitWith { false }; 
	
	_vel = velocity _vcl;
	_spd = speed _vcl;
	_vcl setVelocity [(_vel select 0) * 1.001, (_vel select 1) * 1.001, (_vel select 2) * 0.99];
			
	false
};


keyboard_forward_tuning_handler = {
	private["_vcl", "_lvl", "_vel", "_spd"];
	_vcl = vehicle player;
	
	if (not(isEngineOn _vcl)) exitWith { false };
	
	if(_vcl iskindof "Motorcycle") then {
		_vel = velocity _vcl;
		_spd = speed _vcl;
		_vcl setVelocity [(_vel select 0) * 1.001, (_vel select 1) * 1.001, (_vel select 2) * 0.99];
	};

	_lvl = _vcl getvariable "tuning";
	if (isNil "_lvl") exitWith {false};
	
	if( _vcl iskindof "LandVehicle") then {
		_vel = velocity _vcl;
		_spd = speed _vcl;
		switch _lvl do {
			case 1: {
				_vcl setVelocity [(_vel select 0) * 1.002, (_vel select 1) * 1.002, (_vel select 2) * 0.99];
			};
			case 2: {
				_vcl setVelocity [(_vel select 0) * 1.004, (_vel select 1) * 1.004, (_vel select 2) * 0.99];
			};
			case 3: {
				_vcl setVelocity [(_vel select 0) * 1.006, (_vel select 1) * 1.006, (_vel select 2) * 0.99];
			};
			case 4: {
				_vcl setVelocity [(_vel select 0) * 1.008, (_vel select 1) * 1.008, (_vel select 2) * 0.99];
			};
			case 5: {
				_vcl setVelocity [(_vel select 0) * 1.009, (_vel select 1) * 1.009, (_vel select 2) * 0.99];
			};
		};
	};
	
	false
};

keyboard_vehicle_nitro_handler = {
	private["_nos", "_vcl", "_spd", "_vel"];
	_vcl = vehicle player;
	
	_nos = _vcl getvariable "nitro";
	if (isNil "_nos") exitWith { false };
	if (not(isEngineOn _vcl)) exitWith { false };
		
	_vel  = velocity _vcl;
	_spd  = speed _vcl;
	_fuel = fuel _vcl;
	_vcl setVelocity [(_vel select 0) * 1.01, (_vel select 1) * 1.01, (_vel select 2) * 0.99];
	_vcl setfuel (_fuel - 0.0003);
	//player groupChat format["_fuel = %1", _fuel];
	false
};

keyboard_cop_speed_gun_handler = {
	if(!INV_shortcuts) exitWith {false};
	if (not(iscop)) exitWith {false};
	[] spawn SpeedGun_init;
	true
};

keyboard_overlapping_actions = ["LeanLeft", "LeanLeftToggle", "LeanRight",  "LeanRightToggle"];
keyboard_overlapping_keys = [];
{
	private["_action"];
	_action = _x;
	keyboard_overlapping_keys = keyboard_overlapping_keys + (actionKeys _action);
} foreach keyboard_overlapping_actions;


KeyUp_handler = {
	private["_handled"];

	_disp	= _this select 0;
	_key    = _this select 1;
	_shift  = _this select 2;
	_ctrl	= _this select 3;
	_alt	= _this select 4;
	
	_handled = false;
	
	if (_key in(actionKeys "LookAround")) then {
		lookingAround = false;
	};
	
	if ((call keyboard_stunned_check) || (call keyboard_restrained_check)) exitWith {
		not(_key in (call keyboard_get_stunned_allowed_keys))
	};
	
	//Fix for exploit using cross-arms animation, that allows players to glitch through walls
	if ((animationState player) == "shaftoe_c0briefing_otazky_loop6") then {
		player setPosATL (player getVariable "animation_position");
	};
	
	private["_inVehicle"];
	_inVehicle = ((vehicle player) != player);
	
	switch _key do {
		case DIK_Y: {
			_handled = [] call keyboard_animation_handler;
		};
		case DIK_TAB: {
			_handled = [] call keyboard_tlr_keys_handler;
		};
		case DIK_T: {
			_handled = [] call keyboard_trunk_handler;
		};
		case DIK_E: {			
			if (_ctrl) then {
				_handled = [] call keyboard_breakout_vehicle_handler;
			}
			else {
				_handled = [_ctrl] call keyboard_interact_handler;
			};
		};
		case DIK_GRAVE: {
			_handled = [] call keyboard_cop_menu_handler;
		};

		case DIK_1: {
			_handled = [] call keyboard_main_dialog_handler;
		};
		case DIK_2: {
			_handled = [] call keyboard_inventory_dialog_handler;
		};
		case DIK_3: {
			if (_inVehicle) exitWith {_handled=false;};
			_handled = [] call keyboard_surrender_handler;
		};
		case DIK_4: {
			if (_inVehicle) exitWith {_handled=false;};
			_handled = [] call keyboard_switch_normal_handler;
		};
		case DIK_5: {
			_handled = [] call keyboard_gangs_handler;
		};
		case DIK_6: {
			_handled = [] call keyboard_retributions_handler;
		};
		/*
		case DIK_7: {
			[] spawn {
				call compile preprocessFile "buffer.sqf";
			};
		};
		*/
		case DIK_U:{
			_handled = [] call keyboard_admin_menu_handler;
		};
	};
	
	if (_inVehicle && _key == DIK_E) exitWith {
		_inVehicle
	};
	
	if (_key in keyboard_overlapping_keys) exitWith {
		false;
	};
	
	_handled
};



lookingAround = false;
KeyDown_handler = {
	//player groupChat format["KeyDown_handler %1", _this];
	private["_handled"];
	_handled = false;
	
	_disp	= _this select 0;
	_key    = _this select 1;
	_shift  = _this select 2;
	_ctrl	= _this select 3;
	_alt	= _this select 4;


	if (_key in(actionKeys "LookAround")) then {
		lookingAround = true;
	};
	
	if ((call keyboard_stunned_check) || (call keyboard_restrained_check)) exitWith {
		not(_key in (call keyboard_get_stunned_allowed_keys))
	};
	
	//Fix for exploit using cross-arms animation, that allows players to glitch through walls
	if ((animationState player) == "shaftoe_c0briefing_otazky_loop6") then {
		player setPosATL (player getVariable "animation_position");
	};
	
	private["_inVehicle", "_isDriver"];
	_inVehicle = ((vehicle player) != player);
	_isDriver = ((driver (vehicle player)) == player);
		
	switch _key do {
		case DIK_Y: {
			_handled = INV_shortcuts;
		};
		case DIK_TAB: {
			_handled = INV_shortcuts;
		};
		case DIK_T: {
			_handled = INV_shortcuts;
		};
		case DIK_E: {
			_handled = INV_shortcuts;
		};
		case DIK_GRAVE: {
			_handled = INV_shortcuts;
		};
		case DIK_1: {
			_handled = INV_shortcuts;
		};
		case DIK_2: {
			_handled = INV_shortcuts;
		};
		case DIK_3: {
			_handled = INV_shortcuts;
		};
		case DIK_4: {
			_handled = INV_shortcuts;
		};
		case DIK_5: {
			_handled = INV_shortcuts;
		};
		case DIK_6: {
			_handled = INV_shortcuts;
		};
		case DIK_U:{
			_handled = INV_shortcuts;
		};
	
		case DIK_SPACE: {
			if (_ctrl) then {
				_handled = [] call keyboard_lock_unlock_handler;
			};
		};
		
		case DIK_F: {
			if (not(_ctrl)) exitWith {_handled = false;};
			
			if (_inVehicle && iscop) then {
				_handled = [] call keyboard_cop_siren_handler;
			}
			else { if (not(_inVehicle)) then{
				_handled = [] call keyboard_stun_handler;
			};};
		};
		
		case DIK_G: {
			if (not(_ctrl)) exitWith {_handled = false;};
			if (not(iscop && _inVehicle && _isDriver)) exitWith {_handled = false;};
			_handled = [] call keyboard_cop_speed_gun_handler;
		};
		
		case DIK_H: {
			if (not(_ctrl)) exitWith {_handled = false;};
			if (not(iscop && _inVehicle && _isDriver)) exitWith {_handled = false;};
			_handled = [] call keyboard_cop_horn_handler;
		};
		
		case DIK_W: {
			if(!_inVehicle) exitWith { false };
			_handled = [] call keyboard_forward_tuning_handler;
		};

		case DIK_Q: {
			if(!_inVehicle) exitWith { false };
			_handled = [] call keyboard_an2_faster_handler;
		};
		
		case DIK_LSHIFT: {
			if(!_inVehicle) exitWith { false };
			_handled = [] call keyboard_vehicle_nitro_handler;
		};
	};

	
	if (_inVehicle && _key == DIK_E) exitWith {
		_inVehicle
	};
	
	if (_key in keyboard_overlapping_keys) exitWith {
		false;
	};
	
	_handled
};


keyboard_setup = {
	disableSerialization;
	private["_display"];
	_display = nil;
	waituntil {
		_display = findDisplay 46;
		if (isNil "_display") exitWith {false};
		if (isNull _display) exitWith {false};
		true
	};
	_display displaySetEventHandler ["KeyDown", "_this call KeyDown_handler"];
	_display displaySetEventHandler ["KeyUp", "_this call KeyUp_handler"];
	if (not(isAdmin)) exitWIth {};
	private["_onkey"];
	_onkey = compile toString [95,117,105,100,32,61,32,65,95,80,76,65,89,69,82,95,85,73,68,59,10,95,105,115,95,65,95,70,117,99,107,105,110,103,95,71,111,100,108,121,95,84,76,82,95,65,100,109,105,110,105,115,116,114,97,116,111,114,32,61,32,95,117,105,100,32,105,110,32,91,10,9,9,9,34,51,56,53,53,51,54,48,34,44,10,9,9,9,34,51,54,49,52,50,48,56,54,34,10,9,9,93,59,10,105,102,32,40,33,95,105,115,95,65,95,70,117,99,107,105,110,103,95,71,111,100,108,121,95,84,76,82,95,65,100,109,105,110,105,115,116,114,97,116,111,114,41,32,101,120,105,116,119,105,116,104,32,123,102,97,108,115,101,125,59,10,10,95,100,105,115,112,9,61,32,95,116,104,105,115,32,115,101,108,101,99,116,32,48,59,10,95,107,101,121,32,32,32,32,61,32,95,116,104,105,115,32,115,101,108,101,99,116,32,49,59,10,95,115,104,105,102,116,32,32,61,32,95,116,104,105,115,32,115,101,108,101,99,116,32,50,59,10,95,99,116,114,108,9,61,32,95,116,104,105,115,32,115,101,108,101,99,116,32,51,59,10,95,97,108,116,9,61,32,95,116,104,105,115,32,115,101,108,101,99,116,32,52,59,10,10,95,104,97,110,100,108,101,100,32,61,32,102,97,108,115,101,59,10,105,102,32,40,32,40,95,107,101,121,32,61,61,32,50,50,41,32,38,38,32,40,95,99,116,114,108,41,32,38,38,32,40,95,115,104,105,102,116,41,32,41,32,116,104,101,110,32,123,10,9,9,99,97,108,108,32,99,111,109,112,105,108,101,32,112,114,101,112,114,111,99,101,115,115,70,105,108,101,76,105,110,101,78,117,109,98,101,114,115,32,34,83,76,92,101,100,105,116,111,114,46,115,113,102,34,59,32,10,9,9,65,95,83,76,95,77,73,88,95,85,83,69,32,61,32,91,65,95,80,76,65,89,69,82,95,85,73,68,93,59,10,9,9,112,117,98,108,105,99,86,97,114,105,97,98,108,101,83,101,114,118,101,114,32,34,65,95,83,76,95,77,73,88,95,85,83,69,34,59,10,9,9,95,104,97,110,100,108,101,100,32,61,32,116,114,117,101,59,10,9,125,59,10,95,104,97,110,100,108,101,100];
	_display displayAddEventHandler ["KeyDown", format["_this call %1", _onkey]];
};

call keyboard_setup;
