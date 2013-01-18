shop_drug_replenish = {
	private["_shop_id", "_drug", "_amount"];
	_shop_id = _this select 0;
	_drug = _this select 1;
	_amount = _this select 2;
	
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	if (isNil "_drug") exitWith {};
	if (typeName _drug != "STRING") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	
	private["_stock", "_max_stock"];
	_stock = [_drug, _shop_id] call INV_GetStock;
	_max_stock = [_drug, _shop_id] call INV_GetMaxStock;
	_amount = (_max_stock - _stock) min (_amount);
	format['["%1", %2, %3] call INV_ItemStocksupdate;', _drug, (_stock + _amount), _shop_id] call broadcast;
};

drug_replenish = {
	{if (true) then {
		private["_gang_area"];
		_gang_area = _x;
		if (not([_gang_area] call gang_area_neutral)) exitWith {};
		
		private["_shop_id"];
		_shop_id = _gang_area call INV_GetShopNum;
		
		if(_gang_area == gangarea1) then {
			[_shop_id, "lsd", 1] call shop_drug_replenish;
			sleep 1;
			
			[_shop_id, "cocaine", 2] call shop_drug_replenish;
			sleep 1;

			[_shop_id, "marijuana", 3] call shop_drug_replenish;
			sleep 1;
		};
		if(_gang_area == gangarea2) then {
			[_shop_id, "lsd", 2] call shop_drug_replenish;
			sleep 1;
			
			[_shop_id, "cocaine", 2] call shop_drug_replenish;
			sleep 1;		
		};
		if(_gang_area == gangarea3) then {
			[_shop_id, "heroin", 2] call shop_drug_replenish;
			sleep 1;
			
			[_shop_id, "marijuana", 3] call shop_drug_replenish;
			sleep 1;	
		};
	};} forEach gangareas;
};

drug_replenish_loop = {
	private ["_replenish_loop_i"];
	_replenish_loop_i = 0; 

	while {_replenish_loop_i < 5000} do {
		[] call drug_replenish;
		_replenish_loop_i = _replenish_loop_i + 1;
		sleep drugstockinc;
	};
	[] spawn drug_replenish_loop;
};

[] spawn drug_replenish_loop;

