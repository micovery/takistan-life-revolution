if (not(isNil "money_functions")) exitWith {};

player_get_factory_storage_money = {
	private["_player", "_money"];
	_player = player;
	
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
	_player = player;
	
	_money = 0;
	_money = [_player, "money", "private_storage"] call INV_GetStorageAmount;
	_money
};

player_get_inventory_money = {
	_money = 0;
	_money = [player, 'money'] call INV_GetItemAmount;
	_money
};
	
	
player_get_total_money = {
	private["_fac_money", "_priv_money", "_bank_money", "_inv_money"];
	_fac_money = call player_get_factory_storage_money;
	_priv_money = call player_get_private_storage_money;
	_bank_money = call bank_get_value;
	
	_inv_money = call player_get_inventory_money;
	//player groupchat format["FSM: %1, PSM: %2, BM: %3, IM: %4", _fac_money, _priv_money, _bank_money, _inv_money];
	_total_money = _fac_money + _priv_money + _bank_money + _inv_money;
	_total_money
};




player_lose_factory_storage_money = {
	private["_player", "_lost_amount", "_amount"];
	_player = player;
	
	_amount = _this select 0;
	{
		_factory_array = _x;
		_factory_name = _factory_array select 7;
		_factory_money = [_player, "money", _factory_name] call INV_GetStorageAmount;
		
		if (_factory_money <= _amount) then {
			_lost_amount = _factory_money;
		}
		else {
			_lost_amount = _amount;
		};
		
		[_player, "money", -(_lost_amount), _factory_name] call INV_AddItemStorage;
		_amount = _amount - _lost_amount;

		if (_amount <= 0) exitWith {_amount = 0;};
	} foreach all_factories;
	_amount
};

player_lose_private_storage_money =  {
	private["_player", "_lost_amount"];
	_player = player;
	_lost_amount = _this select 0;
	
	[_player, "money", -(_lost_amount), "private_storage"] call INV_AddItemStorage;
};

player_lose_inventory_money =  {
	private["_player", "_lost_amount"];
	_player = player;
	_lost_amount = _this select 0;
	[_player, 'money', -(_lost_amount)] call INV_AddInventoryItem;
};

player_lose_money =  {
	private["_lost_amount", "_amount"];
	_amount = _this select 0;
	
	_fac_money = call player_get_factory_storage_money;
	_priv_money = call player_get_private_storage_money;
	_bank_money = call bank_get_value;
	_inv_money = call player_get_inventory_money;
	
	/////////////////////////////////////////////
	// Raid factories 
	_lost_amount = 0;
	if ( _fac_money >= _amount) then {
		_lost_amount = _amount;
	}
	else {
		_lost_amount = _fac_money;
	};
	
	[_lost_amount] call player_lose_factory_storage_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};
	
	/////////////////////////////////////////////
	// Raid private storage
	_lost_amount = 0;
	if ( _priv_money >= _amount) then {
		_lost_amount = _amount;
	}
	else {
		_lost_amount = _priv_money;
	};
	
	[_lost_amount] call player_lose_private_storage_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};
	
	/////////////////////////////////////////////
	// Raid inventory
	
	_lost_amount = 0;
	if ( _inv_money >= _amount) then {
		_lost_amount = _amount;
	}
	else {
		_lost_amount = _inv_money;
	};
	
	[_lost_amount] call player_lose_inventory_money;
	_amount = _amount - _lost_amount;
	if (_amount <= 0) exitWith {};

	/////////////////////////////////////////////
	// Raid bank 
	[_amount * -1]  call bank_transaction;
};

money_functions = true;