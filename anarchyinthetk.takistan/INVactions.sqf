private["_amount", "_action", "_item"];

_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

if (!(_amount call ISSE_str_isInteger)) exitWith {
	player groupChat localize "STRS_inv_no_valid_number";
};

_amount = _amount call ISSE_str_StrToInt;
if (_amount > ([player, _item] call INV_GetItemAmount)) exitWith {};

private["_player"]; 
_player = _this select 3;
if (([player] call player_vulnerable) or (!INV_CanUseInventory)) exitWith {
	player groupChat localize "STRS_inv_cannotUseNow";
};

INV_InventarGiveReceiver = _player;

if ((_action == "use") and (INV_CanUseItem)) then {
	private["_script"];
	_script = _item call INV_GetItemFilename;
	_script = if (isNil "_script") then {""} else { _script };
	_script = if (typeName _script != "STRING") then { "" } else {_script};
	
	if (_script == "") exitWith {
		player groupChat localize "STRS_inv_inventar_cannotuse";
	};
	
	["use", _item, _amount, [] ] execVM _script;
};

if ((_action == "drop") and (INV_CanDropItem)) then {
	[_item, _amount] execVM "drop.sqf";
};

if ((_action == "give") and (INV_CanGiveItem)) then {
	["uebergabe", _item, _amount, _player] execVM "give.sqf";
};