if (not(isNil "admin_functions_defined")) exitWith {};

logAdmin = {
	private["_text"];
	_text = _this select 0;
	if (isNil "_text") exitWith {};
	if (typeName _text != "STRING") exitWith {};
	
	private["_player"];
	_player = player;
	
	_text = (format["ADMIN (%1, %2): ", (name _player), (getPlayerUID _player)] + _text + toString [13,10]);
	[_text] call logThis;
};

interact_item_force_give = { _this spawn {
	private["_forced", "_item", "_amount", "_target"];
	_forced = _this select 0;
	_item = _this select 1;
	_amount = _this select 2;
	_target = _this select 3;
	
	if (not([_forced] call player_human)) exitWith {};
	if (isNil "_item") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_amount == 0) exitWith {};
	
	if (_amount > ([_forced, _item] call INV_GetItemAmount)) exitWith {
		player groupChat format["They do not have that many items to give"];
	};
	
	private["_space_available"];
	_space_available = [_target, _item, _amount] call player_inventory_space;
	if (_space_available <= 0) exitWith {
		player groupChat format["The target player does not have enough inventory space to receive the items"];
	};
	
	if (_amount > _space_available) then {
		_amount = _space_available;
	};
	if (_forced == _target) exitWith {
		player groupChat format["You cannot give an item to the giver"];
	};
	
	private["_item_name"];
	_item_name = (_item call INV_GetItemName);

	if (_item == "keychain") then {
		//special processing for keys
		private["_vehicles"];
		_vehicles = [_forced] call vehicle_list;
		
		private["_vehicle"];
		_vehicle = [_vehicles] call interact_select_vehicle_wait;
		if (isNull _vehicle) exitWith {};
		
		player groupChat format["You gave %1-%2 a copy of the key for %3", _target, (name _target), _vehicle];
		format["[%1, %2, %3] call interact_keychain_give_receive;", _forced, _target, _vehicle] call broadcast;
		[format["Gave %1-%2 (%3)'s key for %4 to %5-%6 (%7)", _forced, (name _forced), (getplayerUID _forced), _vehicle, _target, (name _target), (getplayerUID _target)]] call logAdmin;
	} else {
		//generic processing for all other items
		[_forced, _item, -(_amount)] call INV_AddInventoryItem;
		player groupChat format["You gave %1-%2 %3 units of %4 from %5", _target, (name _target), strN(_amount), _item_name, _player];
		format["[%1, %2, ""%3"", %4] call interact_item_give_receive;", _forced, _target, _item, strN(_amount)] call broadcast;
		[format["Gave %4 of %1-%2 (%3)'s %8 to %5-%6 (%7)", _player, (name _forced), (getplayerUID _forced), strN(_amount), _target, (name _target), (getplayerUID _target), _item]] call logAdmin;
	};
};};

interact_force_inventory_menu = {
										
  private["_player"];
		_player = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (!(createDialog "adventar")) exitWith {hint "Dialog Error!";};

	private["_itemcounter"];
		_itemcounter = 0;

	private["_i"];
	  _i = 0;
	private["_inventory"];
	  _inventory = [_player] call player_get_inventory;
	while { _i < (count _inventory) } do {
		private ["_item", "_number", "_lbl_name", "_index"];
			_item = ((_inventory select _i) select 0);
			_number = ([_player, _item] call INV_GetItemAmount);

		if (_number > 0) then {
			_lbl_name = (_item call INV_GetItemName);
			_index = lbAdd [1, format ["%1",_lbl_name]];
		  lbSetData [1, _index, _item];
			_itemcounter = _itemcounter + 1;
	  };
		_i = _i + 1;
	};

  if (_itemcounter == 0) exitWith {
		_player groupChat format["Your inventory is empty"];
	};
	
	private["_player_index"];
		_player_index = 0;
	
	private["_c"];
		_c = 0;
	while { _c < (count playerstringarray) } do {
		private["_player_variable_name", "_player_variable"];
		
		  _player_variable_name = "";
			_player_variable = objNull;
		
			_player_variable_name = playerstringarray select _c;
			_player_variable = missionNamespace getVariable [_player_variable_name, objNull];
		
			if ([_player_variable] call player_human) then {
			  private["_player_name", "_index"];
			    _player_name = (name _player_variable);
					_index = lbAdd [99, format ["%1 - (%2)", _player_variable_name, _player_name]];
				lbSetData [99, _index, format["%1", _player_variable_name]];
			
				if (_player == _player_variable) then {_player_index = _index};
			};
			_c = _c + 1;
	};
	
	lbSetCurSel [99, _player_index];

	lbSetCurSel [1, 0];
	buttonSetAction [3, format["[_player, lbData [1, (lbCurSel 1)], (([_player, _item] call INV_GetItemAmount)-([(ctrlText 501)] call parse_number))] call INV_SetItemAmount"]];
	buttonSetAction [4, format["[_player, lbData [1, (lbCurSel 1)], ([(ctrlText 501)] call parse_number)] call interact_item_drop"]];
	buttonSetAction [246, format["[_player, lbData [1, (lbCurSel 1)], ([(ctrlText 501)] call parse_number), (missionNamespace getVariable (lbData [99, (lbCurSel 99)]))] call interact_item_force_give"]];
											
	private["_item","_number","_array"];
	while {ctrlVisible 1001} do {
		_item   = lbData [1, (lbCurSel 1)];
		_number = [_player, _item]  call INV_GetItemAmount;
		_array  = _item call INV_GetItemArray;

		ctrlSetText [62,  format ["%1", strN(_number)]];
		ctrlSetText [52,  format ["%1", _array call INV_GetItemName]];
		ctrlSetText [72,  format ["%1", _array call INV_GetItemDescription1]];
		ctrlSetText [7,   format ["%1", _array call INV_GetItemDescription2]];
		ctrlSetText [202, format ["%1/%2", (_array call INV_GetItemTypeKg), strN(((_array call INV_GetItemTypeKg)*(_number)))]];
		
		sleep 0.1;
	};
};

admin_actions_list = {
	([
		["------ Admin Commands ------", {}],
		["Camera (Toggle)", {
			[] call camera_toggle;
		}],
		["Carmagedon", {
			private["_text"];
			_text = _this select 2;
			_distance = [(_text)] call parse_number;
			
			if (_distance <= 0) exitWith {};
			
			player groupchat format["Starting Carmagedon at a range of %1 meters", _distance];
			
			{
				{		
					if ({alive _x} count crew _x == 0) then {
						deleteVehicle _x;
					};
				} foreach((getpos player) nearObjects [_x, _distance]);
			} forEach (droppableitems + ["LandVehicle", "Air", "Car", "Motorcycle", "Bicycle", "UAV", "Wreck", "Wreck_Base", 
						"HelicopterWreck", "UH1Wreck", "UH1_Base", "UH1H_base", "AH6_Base_EP1","CraterLong", "Ka60_Base_PMC", 
						"Ka137_Base_PMC", "A10"]);
		}],
		["Check player money", {
			private["_target"];
				_target = _this select 1;
			if (not([_target] call player_human)) exitwith {};
						
			format['
				[] spawn {
					if (player != %1) exitWith {};
						private["_fac_money", "_priv_money", "_bank_money", "_inv_money", "_total_money", "_string"];
						_fac_money = [player] call player_get_factory_money;
						_priv_money = [player] call player_get_private_storage_money;
						_bank_money = [player] call bank_get_value;
						_inv_money = [player] call player_get_inventory_money;
						_total_money = [player] call player_get_total_money;
						_string = format["Total: $%5, Bank: $%3, Private: $%2, Inventory: $%4, Factory: $%1", _fac_money, _priv_money, _bank_money , _inv_money, _total_money];
					titleText[_string, "plain down", 20];
				};
			', _target] call broadcast;
		}],
		["Give player money (input) to Pvt.Stor.", {
			private["_target", "_text"];
				_target = _this select 1;
				_text = _this select 2;
			if (not([_target] call player_human)) exitwith {};
						
			[format["gave %1-%2 (%3) $%4", _target, (name _target), (getPlayerUID _target)]] call logAdmin;
						
			format['
				[] spawn {
					if (player != %1) exitwith {};
					[_player, "money", %2, "private_storage"] call INV_AddItemStorage;
					[_player] call player_save_private_storage;
				;}
			', _target, _text],
		}],
		["Give player 1 of (input) to Inv.", {
			private["_target", "_text"];
				_target = _this select 1;
				_text = _this select 2;
			if (not([_target] call player_human)) exitwith {};
						
			[format["gave %1-%2 (%3) 1 %4's", _target, (name _target), (getPlayerUID _target), _text]] call logAdmin;
						
			format['
				[] spawn {
					if (_target != %1) exitwith {};
					[player, %2, 1] call INV_SetItemAmount;
				;}
			', _target, _text],
		}],
		["Give player 10 of (input) to Inv.", {
			private["_target", "_text"];
				_target = _this select 1;
				_text = _this select 2;
			if (not([_target] call player_human)) exitwith {};
						
			[format["gave %1-%2 (%3) 10 %4's", _target, (name _target), (getPlayerUID _target), _text]] call logAdmin;
						
			format['
				[] spawn {
					if (player != %1) exitwith {};
					[player, %2, 10] call INV_SetItemAmount;
				;}
			', _target, _text],
		}],
		["Interact with player inventory", {
			private["_target"];
				_target = _this select 1;
			if (not([_target] call player_human)) exitwith {};
						
			[format["interacted with %1-%2 (%3)'s inventory", _target, (name _target), (getplayerUID _target)]] call logAdmin;
						
			format['
				[] spawn {
					if (_target != %1) exitwith {};
					private["interact_force_inventory_menu"]
										
					[player, _target] spawn interact_force_inventory_menu;
				};
			' _target],
		}],
		["Remove player weapons", {
			private["_player", "_target"];
			_player = _this select 0;
			_target = _this select 1;
			if (not([_target] call player_human)) exitWith {};
			
			[format["removed %1-%2 (%3)'s weapons", _target, (name _target), (getPlayerUID _target)]] call logAdmin;
			
			format['
				[] spawn {
					if (player != %1) exitWith {};
					[player] call player_reset_gear;
				};
			', _target] call broadcast;
		}],
		["Kill player", {
			private["_player", "_target"];
			_player = _this select 0;
			_target = _this select 1;
			if (not([_target] call player_human)) exitWith {};
			
			[format["killed %1-%2 (%3)", _target, (name _target), (getPlayerUID _target)]] call logAdmin;
			
			format['
				[] spawn {
					if (player != %1) exitWith {};
					(player) setDamage 1; 
				};
			', _target] call broadcast;
		}],
		["Destroy player vehicle", {
			private["_player", "_target"];
			_player = _this select 0;
			_target = _this select 1;
			if (not([_target] call player_human)) exitWith {};
			
	
			[format["destroyed %1-%2 (%3)'s vehicle", _target, (name _target), (getPlayerUID _target)]] call logAdmin;
			
			format['
				[] spawn {
					if (player != %1) exitWith {};
					(vehicle player) setDamage 1; 
				};
			', _target] call broadcast;
		}],
		["Set player to ignore required playtime", {
			private["_player", "_target"];
			_player = _this select 0;
			_target = _this select 1;
			if (not([_target] call player_human)) exitWith {};

			[format["Set %1-%2 (%3) to ignore playtime", _target, (name _target), (getPlayerUID _target)]] call logAdmin;
			
			[_target, "ignoreFactionPlaytime", true] call player_set_bool;
			
			player groupChat format["Player %1(%2) is ignoring the required playtime now", _target, (name _target)];
			
			private["_message"];
			_message = "You are ignoring the required playtime now. Feel free to join blufor, insurent or opfor now.";
			format['if (player == %1) then {player groupChat toString(%2);};', _target, toArray(_message)] call broadcast;
		}],
		["Reset time(40m dy, 20m nt)", {
			player groupChat "Time reset (40-min day, 20-min night), please wait for synchronization to complete";
			[40,20] call time_reset;
		}],
		["MOTD (use input field)", {
			private["_text"];
			_text = _this select 2;
			custom_motd = _text;
			publicVariable "custom_motd";
			
			[format["Set the MOTD to %1", _inputText] call logAdmin;
		}],
		["Delete Target (Man)", {
			private["_target"];
			_target = cursorTarget;
			if (not(isNil "_target")) then {
				if (typeName _target == "OBJECT") then {
					if (_target isKindOf "Man" && not([_target] call object_shop)) then {
						[_target] call C_delete;
					};
				};
			};
		}],
		["------ White / Black Lists ------", {}],
		["COP - 1 List", {
			["COP_1"] spawn A_WBL_F_DIALOG_INIT;
		}],
		["BLANK", {}]
	])
};

admin_activate_command = { _this spawn {
	private["_player", "_command", "_text", "_target"];
	
	_player = _this select 0;
	_command = _this select 1;
	_text = _this select 2;
	_target = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	
	if (isNil "_command") exitWith {};
	if (typeName _command != "STRING") exitWith {};
	
	_text = if (isNil "_text") then {""} else {_text};
	_text = if (typeName _text != "STRING") then {""} else {_text};
	
	private["_code"];
	_code = compile ( "_this call " + _command);
	[_player, _target, _text] spawn _code;
	sleep 1;
	hint "Code Activated";
};};

admin_functions_defined = true;
