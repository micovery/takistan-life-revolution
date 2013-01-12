while {true} do {

for [{_i=0}, {_i < (count gangareas)}, {_i=_i+1}] do  {

	_gangarea	= gangareas select _i;
	_control 	= _gangarea getvariable "control";
	_shopnum  	= _gangarea call INV_GetShopNum;
	
	if(!isnil "_control")then

		{

		if(_gangarea == gangarea1) then

			{

			_num      = 1;
			_stock    = ["lsd", _shopnum] call INV_GetStock;
			_maxstock = ["lsd", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["lsd", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;

			sleep 1;

			_num      = 2;
			_stock    = ["cocaine", _shopnum] call INV_GetStock;
			_maxstock = ["cocaine", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["cocaine", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;
	
			sleep 1;

			_num      = 3;
			_stock    = ["marijuana", _shopnum] call INV_GetStock;
			_maxstock = ["marijuana", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["marijuana", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;

			};

		if(_gangarea == gangarea2) then

			{

			_num      = 2;
			_stock    = ["lsd", _shopnum] call INV_GetStock;
			_maxstock = ["lsd", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["lsd", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;

			sleep 1;

			_num      = 2;
			_stock    = ["cocaine", _shopnum] call INV_GetStock;
			_maxstock = ["cocaine", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["cocaine", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;
	
			};

		if(_gangarea == gangarea3) then

			{

			_num      = 2;
			_stock    = ["heroin", _shopnum] call INV_GetStock;
			_maxstock = ["heroin", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["heroin", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;
			
			sleep 1;

			_num      = 3;
			_stock    = ["marijuana", _shopnum] call INV_GetStock;
			_maxstock = ["marijuana", _shopnum] call INV_GetMaxStock;
			if((_maxstock - _stock) < _num)then{_num = (_maxstock - _stock)};
			format['["marijuana", (%1 + %2), %3] call INV_ItemStocksupdate;',  _stock, _num, _shopnum] call broadcast;
	
			
			};

		};

	sleep 1;

	};

sleep drugstockinc;

};
											



