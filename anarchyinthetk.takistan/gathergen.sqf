#include "Awesome\Functions\macro.h"

//Modded For TL:R by M5iC

private["_type","_item","_chance","_maxzahl","_anzahl","_stock"];
_type    = ((_this select 3)select 0);
_item    = _this select 0;
_chance  = _this select 1;
_maxzahl = _this select 2;

if (isNil("INV_FarmSpamSchutz")) then {INV_FarmSpamSchutz = false;};
if (INV_FarmSpamSchutz) exitWith {};
INV_FarmSpamSchutz = true;

if ( (_chance > (random 100)) ) then {

	if(_type == "Man")then{titletext ["Gathering...", "PLAIN DOWN", 0.1]};
	if(_type == "Ship")then{titletext ["Fishing...", "PLAIN DOWN", 0.1]};
	if(_type == "Truck")then{titletext ["Collecting...", "PLAIN DOWN", 0.1]};

	_anzahl = (ceil(random(_maxzahl)));

	if(_item == "perch") then {

		_stock = ["perch", (shop1 call INV_GetShopNum)] call INV_GetStock;
		_stock = _stock + (["perch", (shop2 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["perch", (shop3 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["perch", (shop4 call INV_GetShopNum)] call INV_GetStock);
		if (_stock < 0) then {_stock = 0;};
		_anzahl = ceil(random(_maxzahl-(_stock/800*_maxzahl)));
	};

	if(_item == "walleye")then {
		_stock = ["walleye", (shop1 call INV_GetShopNum)] call INV_GetStock;
		_stock = _stock + (["walleye", (shop2 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["walleye", (shop3 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["walleye", (shop4 call INV_GetShopNum)] call INV_GetStock);
		
		if (_stock < 0) then {_stock = 0;};

		_anzahl = ceil(random(_maxzahl-(_stock/400*_maxzahl)));
	};

	if(_item == "trout")then {
		_stock = ["trout", (shop1 call INV_GetShopNum)] call INV_GetStock;
		_stock = _stock + (["trout", (shop2 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["trout", (shop3 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["trout", (shop4 call INV_GetShopNum)] call INV_GetStock);
		if (_stock < 0) then {_stock = 0;};
		_anzahl = ceil(random(_maxzahl-(_stock/400*_maxzahl)));
	};

	if(_item == "bass")then {
		_stock = ["bass", (shop1 call INV_GetShopNum)] call INV_GetStock;
		_stock = _stock + (["bass", (shop2 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["bass", (shop3 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["bass", (shop4 call INV_GetShopNum)] call INV_GetStock);
		if (_stock < 0) then {_stock = 0;};
		_anzahl = ceil(random(_maxzahl-(_stock/200*_maxzahl)));
	};

	if(_item == "getreide") then {
		_stock = ["Bread", (shop1 call INV_GetShopNum)] call INV_GetStock;
		_stock = _stock + (["Bread", (shop2 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["Bread", (shop3 call INV_GetShopNum)] call INV_GetStock);
		_stock = _stock + (["Bread", (shop4 call INV_GetShopNum)] call INV_GetStock);

		_anzahl = ceil(random(_maxzahl-(_stock/400*_maxzahl)));
		_item = "getreide";
	};


	if ((vehicle player) == player) then { 
		if ([player, _item, _anzahl] call INV_AddInventoryItem) then { 
			if(_anzahl == 0) exitWith {};
			player groupChat format[localize "STRS_inv_buyitems_get_erhalten", strN(_anzahl), (_item call INV_GetItemName)];
		} 
		else {
			player groupChat localize "STRS_inv_buyitems_get_zuschwer";
		};
	} 
	else { if ([(vehicle player), _item, _anzahl, ([(vehicle player)] call vehicle_storage_name)] call INV_AddItemStorage) then {
		if(_anzahl == 0) exitWith {};
		player groupChat format[localize "STRS_inv_buyitems_get_erhalten", strN(_anzahl), (_item call INV_GetItemName)];
	}	
	else {
		player groupChat localize "STRS_inv_buyitems_get_zuschwer";
	};};
};

sleep 0.1;

INV_FarmSpamSchutz = false;
