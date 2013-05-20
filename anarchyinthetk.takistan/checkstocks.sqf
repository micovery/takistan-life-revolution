_art  = _this select 0;
_shop = _this select 1;


if (_art == "Start") exitwith
{
if (!(createDialog "distribute4")) exitwith {hint "Dialog Error!"};
ctrlSetText [7, format["Select Factory"]];
ctrlSetText [3, format["Car Shops"]];
buttonSetAction [3, format['["VehicleStart"] execVM "checkstocks.sqf";']];
ctrlSetText [4, format["Gas Stations"]];
buttonSetAction [4, format['["GasStart"] execVM "checkstocks.sqf";']];
ctrlSetText [5, format["Shops"]];
buttonSetAction [5, format['["ShopStart"] execVM "checkstocks.sqf";']];
ctrlSetText [6, format["Gun Shop"]];
buttonSetAction [6, format['["Check",9] execVM "checkstocks.sqf";']];
};

if (_art == "VehicleStart") exitwith
{
if (!(createDialog "distribute4")) exitwith {hint "Dialog Error!"};
ctrlSetText [7, format["Select Shop To Check Stocks"]];
ctrlSetText [3, format["Car Shop 1"]];
buttonSetAction [3, format['["Check",13] execVM "checkstocks.sqf";']];
ctrlSetText [4, format["Car Shop 2"]];
buttonSetAction [4, format['["Check",14] execVM "checkstocks.sqf";']];
ctrlSetText [5, format["Car Shop 3"]];
buttonSetAction [5, format['["Check",16] execVM "checkstocks.sqf";']];
ctrlSetText [6, format["Truck Shop"]];
buttonSetAction [6, format['["Check",17] execVM "checkstocks.sqf";']];
};

if (_art == "GasStart") exitwith
{
if (!(createDialog "distribute4")) exitwith {hint "Dialog Error!"};
ctrlSetText [7, format["Select Shop To Check Stocks"]];
ctrlSetText [3, format["Gas Station 1"]];
buttonSetAction [3, format['["Check",0] execVM "checkstocks.sqf";']];
ctrlSetText [4, format["Gas Station 2"]];
buttonSetAction [4, format['["Check",1] execVM "checkstocks.sqf";']];
ctrlSetText [5, format["Gas Station 3"]];
buttonSetAction [5, format['["Check",2] execVM "checkstocks.sqf";']];
ctrlSetText [6, format["Gas Station 3"]];
buttonSetAction [6, format['["Check",3] execVM "checkstocks.sqf";']];
};

if (_art == "ShopStart") exitwith
{
if (!(createDialog "distribute4")) exitwith {hint "Dialog Error!"};
ctrlSetText [7, format["Select Shop To Check Stocks"]];
ctrlSetText [3, format["Shop 1"]];
buttonSetAction [3, format['["Check",4] execVM "checkstocks.sqf";']];
ctrlSetText [4, format["Shop 2"]];
buttonSetAction [4, format['["Check",5] execVM "checkstocks.sqf";']];
ctrlSetText [5, format["Shop 3"]];
buttonSetAction [5, format['["Check",6] execVM "checkstocks.sqf";']];
ctrlSetText [6, format["Shop 3"]];
buttonSetAction [6, format['["Check",7] execVM "checkstocks.sqf";']];
};

if (_art == "Check") Exitwith

{
if (!(createDialog "CheckDialog")) then {hint "Dialog Error!"};

INV_ActiveShopNumber    = _shop;
_itemarray   = ((INV_ItemShops select INV_ActiveShopNumber) select 4);

for [{_i=0}, {_i < (count _itemarray)}, {_i=_i+1}] do

{

_item         = _itemarray select _i;
_infos        = _item call INV_GetItemArray;
_stock        = [_item, INV_ActiveShopNumber] call INV_GetStock;
_preisOhneTax = _infos call INV_GetItemBuyCost;
_preis        = _infos call INV_GetItemTax;
_name         = (_infos call INV_GetItemName);

if(_stock != -1) then

	{

	_maxstock     = [_item, INV_ActiveShopNumber] call INV_GetMaxStock;
	_demand       = _preis*0.25*(_stock-(_maxstock*0.5))/(0.5*_maxstock);
	_preis        = round((_preisOhneTax*(_preis/_preisOhneTax)) - _demand);

	};

if (_stock != -1) then

	{

	if (_infos call INV_GetItemType == "item") then

		{

		_index = lbAdd [1, format ["%1 (%2kg, Stock: %3)", _name, (_infos call INV_GetItemTypeKg), _stock] ];

		}
		else
		{

		_index = lbAdd [1, format ["%1 (Stock: %2)", _name, _stock]];

		};

	}
	else
	{

	if (_infos call INV_GetItemType == "item") then

		{

		_index = lbAdd [1, format ["%1 (%2kg)", _name, (_infos call INV_GetItemTypeKg)] ];

		}
		else
		{

		_index = lbAdd [1, format ["%1", _name] ];

		};

	};

lbSetData [1, _index, format ["%1", _item] ];

};
};