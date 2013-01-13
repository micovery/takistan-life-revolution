if (not(isNil "money_functions")) exitWith {};

player_get_factory_money = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};
	
	private["_money"];
	_money = 0;
	{
		_factory_array = _x;
		_factory_name = _factory_array select 7;
		_factory_money = [_player, "money", _factory_name] call INV_GetStorageAmount;
		_money = _money + _factory_money;
	} foreach all_factories;
	
	_money
};

player_get_private_storage_money = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};
	
	([_player, "money", "private_storage"] call INV_GetStorageAmount)
};

player_get_inventory_money = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};
	
	([_player, "money"] call INV_GetItemAmount)
};
	
	
player_get_total_money = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};

	private["_fac_money", "_priv_money", "_bank_money", "_inv_money"];
	_fac_money = [_player] call player_get_factory_money;
	_priv_money = [_player] call player_get_private_storage_money;
	_bank_money = [_player] call bank_get_value;
	
	_inv_money = [_player] call player_get_inventory_money;
	//player groupchat format["FSM: %1, PSM: %2, BM: %3, IM: %4", _fac_money, _priv_money, _bank_money, _inv_money];
	_total_money = _fac_money + _priv_money + _bank_money + _inv_money;
	_total_money
};


player_lose_factory_money = {
	private["_player", "_amount"];
	_player = _this select 0;
	_amount = _this select 1;
	
	if (not([_player] call player_human)) exitWith {0};
	if (isNil "_amount") exitWith {0};
	if (typeName _amount != "SCALAR") exitWith {0};
	
	private["_lost_amount"];
	_lost_amount = 0;
	{
		_factory_array = _x;
		_factory_name = _factory_array select 7;
		_factory_money = [_player, "money", _factory_name] call INV_GetStorageAmount;
		
		_lost_amount = (_factory_money) min (_amount);
		[_player, "money", -(_lost_amount), _factory_name] call INV_AddItemStorage;
		_amount = _amount - _lost_amount;

		if (_amount <= 0) exitWith {_amount = 0;};
	} foreach all_factories;
	_amount
};

player_lose_private_storage_money =  {
	private["_player", "_lost_amount"];
	_player = _this select 0;
	_lost_amount = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_lost_amount") exitWith {};
	if (typeName _lost_amount != "SCALAR") exitWith {};

	[_player, "money", -(_lost_amount), "private_storage"] call INV_AddItemStorage;
};

player_lose_inventory_money =  {
	private["_player", "_lost_amount"];
	_player = _this select 0;
	_lost_amount = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_lost_amount") exitWith {};
	if (typeName _lost_amount != "SCALAR") exitWith {};

	[_player, 'money', -(_lost_amount)] call INV_AddInventoryItem;
};

player_lose_money =  {
	private["_player", "_amount"];
	_player = _this select 0;
	_amount = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};

	_fac_money = [_player] call player_get_factory_money;
	_priv_money = [_player] call player_get_private_storage_money;
	_bank_money = [_player] call bank_get_value;
	_inv_money = [_player] call player_get_inventory_money;
	
	private["_lost_amount"];
	
	/////////////////////////////////////////////
	// Raid factories 
	_lost_amount = (_fac_money) min (_amount);
	[_player, _lost_amount] call player_lose_factory_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};
	
	/////////////////////////////////////////////
	// Raid private storage
	_lost_amount = (_priv_money) min (_amount);
	[_player, _lost_amount] call player_lose_private_storage_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};
	
	/////////////////////////////////////////////
	// Raid inventory
	_lost_amount =  (_inv_money) min (_amount);
	[_player, _lost_amount] call player_lose_inventory_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};

	/////////////////////////////////////////////
	// Raid bank (it can go negative, it's on purpose)
	[_player, -(_amount)]  call bank_transaction;
};

money_functions = true;