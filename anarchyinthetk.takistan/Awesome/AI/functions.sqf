/*
	AI Functions
	
	last change:
	05/04/2014 - chill0r
*/


if (not(isNil "ai_functions_loaded")) exitWith {};


ai_class = {
	private["_side"];
	_side = _this select 0;
	if (isNil "_side") exitWith {""};
	if (typeName _side != "SIDE") exitWith {""};
	
	if (_side == west) exitWith {"UN_CDF_Soldier_EP1"};
	if (_side == east) exitWith {"TK_Soldier_EP1"};
	if (_side == resistance) exitWith {"TK_GUE_Soldier_EP1"};
	""
};

ai_recruit_receive = {
	if (!(isServer)) exitWith {};
	private["_player", "_loadout", "_selected_loadout"];
	_player = _this select 0;
	_loadout = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_loadout") exitWith {};
	if (typeName _loadout != "SCALAR") exitWith {};
	
	_selected_loadout = customAILoadouts select _loadout;
	private["_class"];
	_class = _selected_loadout select 4;
	if (isNil "_class") then {
		_class = [([_player] call player_side)] call ai_class;
	};
	
	private["_unit", "_backup"];
	_unit = (group _player) createUnit [_class, position _player, [], 0, "FORM"];
	[_unit] joinSilent (group _player);
	
	private["_unit_name"];
	_unit_name = format["%1_Troop_%2_%3", str(_player), (count (units (group _player))), round(time)];

	_unit setVehicleInit format[
	'
		this setVehicleVarName "%1";
		%1 = this;
	', _unit_name];

	processInitCommands;

	_unit = missionNamespace getVariable _unit_name;
	_backup = [] call compile format["%1", _varName];

	private["_side_ai_weapons", "_side_ai_magazines"];
	
	[_unit] call player_reset_gear;
	
	_side_ai_weapons = _selected_loadout select 2;
	_side_ai_magazines = _selected_loadout select 3;
	
	
	{ _unit addWeapon _x } forEach _side_ai_weapons;
	{ _unit addMagazine _x } forEach _side_ai_magazines;
	
	reload _unit;
	_unit addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
	format['[%1, %2] call ai_recruit_complete;', _player, _unit] call broadcast;
};

ai_select_dialog = {
	private["_default_price", "_loadout_index"];
	_default_price = _this select 0;
	
	_loadout_index = 0;
	response = false;
	if (!(createDialog "dialog_select_cancel")) exitWith {hint "Dialog Error!"; nil };
	{
		private["_loadout", "_loadout_name", "_loadout_weapons", "_loadout_magazines","_loadout_skin","_loadout_price"];
		_loadout = _x;
		if (call compile (_loadout select 1)) then {
			_loadout_name = _loadout select 0;
			_loadout_price = _loadout select 5;
			if (isNil "_loadout_price") then { _loadout_price = _default_price; };
			private["_index"];
			_index = lbAdd [1, (format ["%1 - $%2", _loadout_name, _loadout_price])];
			lbSetData [1, _index, str(_loadout_index)];
		};
		_loadout_index = _loadout_index + 1;
	} forEach customAILoadouts;
	waitUntil{(not(ctrlVisible 1023))};
	
	private["_selected_loadout"];
	if (typeName response != "STRING") exitWith {nil};
	_selected_loadout = parseNumber(response);
	if ((_selected_loadout < 0) or (_selected_loadout >= (count customAILoadouts))) exitWith {nil};
	(_selected_loadout)
};

interact_recruit_ai = { _this spawn {
	private["_player", "_price"];
	_player = _this select 0;
	_price = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_price") exitWith {};
	if (typeName _price != "SCALAR") exitWith {};
	
	interact_recruit_ai_busy = if (isNil "interact_recruit_ai_busy") then { false } else {interact_recruit_ai_busy};
	
	if (interact_recruit_ai_busy) exitWith {
		player groupChat format["Already recruiting AI"];
	};
	
	if (count (units group player) >= 8) exitWith {
		player groupChat "Squad Is Full"; 
	};
	
	interact_recruit_ai_busy = true;
	
	private["_ai_type"];
	//Weapons, Magazines, skin, price
	_ai_type = [_price] call ai_select_dialog;
	if (isNil "_ai_type") exitWith {
		interact_recruit_ai_busy = false;
	};
	private["_loadout_price"];
	_loadout_price = ((customAILoadouts select _ai_type) select 5);
	if (isNil "_loadout_price") then {
		_loadout_price = _price;
	};
	
	private["_money"];
	_money = [_player, 'money'] call INV_GetItemAmount;

	if (_money < _loadout_price) exitWith {
		player groupChat "Not Enough Money";
		interact_recruit_ai_busy = false;
	};

	[_player, 'money', -(_loadout_price)] call INV_AddInventoryItem;
	player groupChat "Recruiting soldier";

	format['[%1, %2] call ai_recruit_receive;', _player, _ai_type] call broadcast_server;
	sleep 1;
	interact_recruit_ai_busy = false;
};

};


ai_recruit_complete = {
	private["_player", "_unit"];
	_player = _this select 0;
	_unit = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (not([_unit] call player_exists)) exitWith {};
	if (_player != player) exitWith {};
	
	[_unit] joinSilent (group _player);
};

ai_functions_loaded = true;