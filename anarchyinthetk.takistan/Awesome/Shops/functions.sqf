//the macro.h included here is a copy, original is in Awesome\Functions\macro.h (arma does not allow relative includes) .. see https://dev-heaven.net/issues/8275
#include  "macro.h"
#include "constants.h"

if (not(isNil "shop_functions_defined")) exitWith {};

shop_lookup = {
	private["_shop_id"];
	_shop_id = _this select 0;
	_shop_key = [_shop_id] call shop_make_key;
	if (isNil "_shop_key") exitWith { nil };
	
	_shop_cache = server getVariable _shop_key;
	_shop_cache
};

shop_make_key = {
	private ["_shop_id"];
	_shop_id = _this select 0;
	if (isNil "_shop_id") exitWith { nil };
	if (typeName _shop_id != "SCALAR") exitWith { nil };
	_shop_key = format["shop_id_%1", _shop_id];	
	_shop_key
};

shop_close =  {
	private ["_shop_id", "_shop_cache"];
	_shop_id = _this select 0;
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};

	_indicator = _shop_cache getVariable "indicator";
	
	if (isNil "_indicator") then {
		private ["_pos", "_indicator", "_model_pos", "_center", "_max_z"];
		_indicator = "Sign_sphere25cm_EP1" createVehicleLocal [0,0,0];
		_shop_cache setVariable ["indicator", _indicator];
		_max_z = ((boundingBox _shop_cache) select 1) select 2;
		_indicator attachTo [_shop_cache, [0,0,_max_z+0.1]];
	};
	
	_indicator hideObject false;
	_shop_cache setVariable ["open", false];
};



shop_open =  {
	private ["_shop_id", "_shop_cache"];
	_shop_id = _this select 0;
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	_indicator = _shop_cache getVariable "indicator";
	if (not(isNil "_indicator")) then {
		//_indicator hideObject true;
		//detach _indicator;
		deleteVehicle _indicator;
	};
	
	_shop_cache setVariable ["open", true];
};

shop_init = {
	private ["_shop_id", "_shop_cache"];
	_shop_id = _this select 0;
	_shop_cache = _this select 1;
	
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	if (isNil "_shop_cache") exitWith {};
	

	_shop_cache setVariable ["open", false];
	_shop_cache setVariable ["buy_items", []];
	_shop_cache setVariable ["sell_items", []];
	_shop_cache setVariable ["id", _shop_id];
	_shop_cache setVariable ["put_gear", false];
	_shop_cache setVariable ["hide_sell_items", true];
	_shop_key = ([_shop_id] call shop_make_key);
	server setVariable [_shop_key, _shop_cache];
};


shop_sort_list_by_distance = {
    private["_unsorted_shop_list", "_list_to_sort", "_i", "_count", "_location", "_sorted_shop_list"];
	
	_location = _this select 0;
	_unsorted_shop_list = _this select 1;
	if (isNil "_unsorted_shop_list") exitWith {};
	if (typeName _unsorted_shop_list != "ARRAY") exitWith {};
	if (isNil "_location") exitWith {_unsorted_shop_list};
	if (typeName _location != "ARRAY") exitWith {_unsorted_shop_list};
	if ((count _location) != 3) exitWith {_unsorted_shop_list};
	
	_list_to_sort = [];
	_i = 0;
	_count = count _unsorted_shop_list;
	while {_i < _count} do {
		private["_shop_object", "_shop_id", "_distance", "_shop"];
		_shop_id = _i;
		_shop = _unsorted_shop_list select _i;
		_shop_object = _shop select INV_ItemShops_Object;
		_distance = _location distance _shop_object;
		_element = [];
		_element set [sort_key, _distance];
		_element set [sort_data, _shop_id];
		_list_to_sort set[_i, _element];
		_i = _i + 1;
	};
	
	_list_to_sort call quicksort;
	_list_to_sort
};

shop_setup_progress = 0;
shop_setup = {
	private[ "_i", "_count", "_sorted_item_shops"];
	_unsorted_shops = _this select 0;
	
	_sorted_item_shops = [(getPos player), _unsorted_shops] call shop_sort_list_by_distance;
	_count = count _sorted_item_shops;
	
	//initialize and close all the shops
	_i = 0;
	while { _i < _count } do {
		private["_element", "_shop", "_shop_object"];
		_element = _sorted_item_shops select _i;
		_shop_id = _element select sort_data;
		_shop_object = (_unsorted_shops select _shop_id) select INV_ItemShops_Object;
		
		[_shop_id, _shop_object] call shop_init;
		[_shop_id] call shop_close;
		_i = _i + 1;
	};
	
	
	_i = 0;
	_count = count _sorted_item_shops;
	//build the list for each shop, and open them
	while { _i < _count } do {
		private["_element", "_shop", "_shop_object"];
		_element = _sorted_item_shops select _i;
		_shop_id = _element select sort_data;
		_shop_object = (_unsorted_shops select _shop_id) select INV_ItemShops_Object;
		
		[_shop_id] call shop_build_buy_list;
		[_shop_id] call shop_build_sell_list;
		[_shop_id] call shop_open;
		
		_i = _i + 1;
		shop_setup_progress = floor((_i/_count)*100);
	};
};



shop_set_sell_items = {
	private["_items", "_shop_cache", "_shop_id"];

	_shop_id = _this select 0;
	_items = _this select 1;

	if (isNil "_shop_id") exitWith {};
	if (isNil "_items") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};

	_shop_cache setVariable ["sell_items", _items];
};

shop_get_sell_items = {
	private ["_items", "_shop_cache"];
	
	_shop_cache = _this select 0;
	if (isNil "_shop_cache") exitWith { nil };
	
	_items = _shop_cache getVariable "sell_items";
	_items
};


shop_set_buy_items = {
	private["_items", "_shop_cache", "_shop_id"];

	_shop_id = _this select 0;
	_items = _this select 1;

	if (isNil "_shop_id") exitWith {};
	if (isNil "_items") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};


	_shop_cache setVariable ["buy_items", _items];
};

shop_get_buy_items = {
	private ["_items", "_shop_cache"];
	
	_shop_cache = _this select 0;
	if (isNil "_shop_cache") exitWith { nil };
	
	_items = _shop_cache getVariable "buy_items";
	_items
};

shop_is_open = {
	private ["_open", "_shop_cache","_shop_id"];
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith { false };
	
	_open = _shop_cache getVariable "open";
	if (isNil "_open") exitWith { false };
	if (typeName _open != "BOOL") exitWith {   false };
	_open	
};


shop_sell_item_key = 0;
shop_sell_item_price = 1;
shop_sell_item_index = 2;
shop_sell_item_label = 3;
shop_sell_item_shop_id = 4;
shop_sell_item_name = 5;
shop_sell_item_logic = 6;


shop_sell_item_total_return = 7;
shop_sell_item_sales_tax = 8;
shop_sell_item_market_adjust = 9;
shop_sell_item_max_stock = 10;
shop_sell_item_demand = 11;
shop_sell_item_supply = 12;
shop_sell_item_type = 13;
shop_sell_item_legal = 14;
shop_sell_item_amount = 15;
shop_sell_item_class = 16;
shop_sell_item_kind = 17;

shop_build_sell_list = {
	private ["_i", "_shop_id", "_item_sell_list", "_shop_sell_list", "_count", "_shop", "_logic"];

	_shop_id = _this select 0;
	
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop =  (INV_ItemShops select _shop_id);
	_logic = (_shop select INV_ItemShops_Logic);
	_logic = if (isNil "_logic" ) then { "" } else { _logic };
	
	_item_sell_list  = (_shop select INV_ItemShops_SellList);
	_count = count _item_sell_list;
	_shop_sell_list = [];
	
	_i = 0;
	while { _i < _count } do {
		private ["_data", "_item", "_infos", "_price", "_name", "_isItem", "_weight_str", "_label"];
		_item = _item_sell_list select _i;
		_infos = _item call INV_GetItemArray;
		_price = _infos call INV_GetItemSellCost;
		_name = _infos call INV_GetItemName;

		_isItem = (_infos call INV_GetItemType == "Item");
		_isDroppable = if (_isItem) then {(_item call INV_GetItemDropable)} else { false };

		_weight_str = if (_isItem) then {format[" - %1kg", (_infos call INV_GetItemTypeKg)] } else { "" };
		_label = format["%1 ($%2%3)", _name, strM(_price), _weight_str];
		
		_data = [];
		_data set [shop_sell_item_key, _item];
		_data set [shop_sell_item_price, ([_price] call encode_number)];
		_data set [shop_sell_item_index, _i];
		_data set [shop_sell_item_label, _label];
		_data set [shop_sell_item_shop_id, _shop_id];
		_data set [shop_sell_item_name, _name];
		_data set [shop_sell_item_logic, _logic];
		
		_shop_sell_list set [_i, _data];
		_i = _i + 1;
	};
	
	[_shop_id, _shop_sell_list] call shop_set_sell_items;
};

shop_buy_item_key = 0;
shop_buy_item_price = 1;
shop_buy_item_index = 2;
shop_buy_item_label = 3;
shop_buy_item_shop_id = 4;
shop_buy_item_name = 5;
shop_buy_item_license_1 = 6;
shop_buy_item_license_2 = 7;
shop_buy_item_needs_license = 8;
shop_buy_item_crate = 9;
shop_buy_item_logic = 10;

shop_buy_item_total_due = 11;
shop_buy_item_sales_tax = 12;
shop_buy_item_market_adjust = 13;
shop_buy_item_max_stock = 14;
shop_buy_item_supply = 15;
shop_buy_item_type = 16;
shop_buy_item_legal = 17;
shop_buy_item_amount = 18;
shop_buy_item_class = 19;
shop_buy_item_kind = 20;
shop_buy_item_in_hands = 21;


shop_build_buy_list  =  {
	private ["_i", "_shop_id", "_item_buy_list", "_shop_buy_list", "_count", "_shop", "_crate", "_logic"];

	_shop_id = _this select 0;
	
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	_shop = (INV_ItemShops select _shop_id);
	_item_buy_list   = ( _shop select INV_ItemShops_BuyList);
	_shop_needs_license =  (_shop select INV_ItemShops_License);
	_crate = (_shop select INV_ItemShops_Crate);
	_crate = if (isNil "_crate" ) then { "" } else { _crate };
	_logic = (_shop select INV_ItemShops_Logic);
	_logic = if (isNil "_logic" ) then { "" } else { _logic };
	
	_shop_buy_list = [];
	_count = count _item_buy_list;
	_i = 0;
	while { _i < _count } do {
		private ["_data", "_item", "_infos", "_price", "_name", "_isItem", "_weight_str", "_label", "_license_1", "_license_2"];
		_item = _item_buy_list select _i;
		_infos = _item call INV_GetItemArray;
		_price = _infos call INV_GetItemBuyCost;
		_name  = (_infos call INV_GetItemName);
		_isItem = (_infos call INV_GetItemType == "Item");
		_license_1 = _infos call INV_GetItemLicense;
		_license_2 = _infos call INV_GetItemLicense2;
		
 
		_weight_str = if (_isItem) then {format[" - %1kg", (_infos call INV_GetItemTypeKg)] } else { "" };
		_label = format["%1 ($%2%3)", _name, strM(_price), _weight_str];
		
		_data = [];
		_data set [shop_buy_item_key, _item];
		_data set [shop_buy_item_price, [_price] call encode_number];
		_data set [shop_buy_item_index, _i];
		_data set [shop_buy_item_label, _label];
		_data set [shop_buy_item_shop_id, _shop_id];
		_data set [shop_buy_item_name, _name];
		_data set [shop_buy_item_license_1, _license_1];
		_data set [shop_buy_item_license_2, _license_2];
		_data set [shop_buy_item_needs_license, _shop_needs_license];
		_data set [shop_buy_item_crate, _crate];
		_data set [shop_buy_item_logic, _logic];
		_shop_buy_list set [_i, _data];
		_i = _i + 1;
	};
	
	[_shop_id, _shop_buy_list] call shop_set_buy_items;
};


//Boolean not equal
BNE = {
	_bool1 = _this select 0;
	_bool2 = _this select 1;
	((_bool1 && not(_bool2)) || (not(_bool1) && _bool2))
};

shop_update_sell_list =  {
	disableSerialization;
	private [ "_items",  "_dialog", "_shop_id", "_shop_cache", "_items", "_count", "_i", "_hide_items"];
	
	lbClear sellItem_list_idc;
	call shop_reset_sell_labels;
	
	_this = if (isNil "_this") then { [] } else { _this };
	_shop_id = if (count _this > 0) then { _this select 0 } else { call shop_get_current_shop_id };
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	_hide_items = [_shop_id] call shop_get_sell_cb;
	
	_items = [_shop_cache] call shop_get_sell_items;
	
	
	_count = (count _items);
	[_shop_id] call shop_refresh_sell_cb;

	_i = 0;
	while { _i < _count && not(isNull(findDisplay shopDialog_idd))} do {
		private["_index", "_data", "_valid"];
		//exit early if the state of the checkbox changes
		if ([([_shop_id] call shop_get_sell_cb), _hide_items] call BNE ) exitWith {};
		_data = _items select _i;
		_valid = if (_hide_items) then { private["_out"]; _out = [_data, true] call shop_sell_item_validate_data; not(isNil("_out")) } else { true };

		if (_valid) then {
			_index = lbAdd [sellItem_list_idc, (_data select shop_sell_item_label)];
			lbSetData [sellItem_list_idc, _index, format["%1", _data]];
		};
		_i = _i + 1;
	};
};


shop_update_buy_list =  {
	disableSerialization;
	private [ "_items",  "_dialog", "_shop_id", "_shop_cache", "_items", "_count", "_i"];
	
	lbClear buyItem_list_idc;
	call shop_reset_buy_labels;
	
	_this = if (isNil "_this") then { [] } else { _this };
	_shop_id = if (count _this > 0) then { _this select 0 } else { call shop_get_current_shop_id };

	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	_items = [_shop_cache] call shop_get_buy_items;
	
	_i = 0;
	_count = (count _items);
	while { _i < _count } do {
		private["_index", "_data"];
		_data = _items select _i;
		_index = lbAdd [buyItem_list_idc, (_data select shop_buy_item_label)];
		 lbSetData [buyItem_list_idc, _index, format["%1", _data]];
		_i = _i + 1;
	};
	
	[_shop_id] call shop_refresh_put_gear_cb;
	
};


shop_reset_buy_labels = {
	ctrlSetText [supply_box_idc, "0"];
	ctrlSetText [salesTaxBuy_box_idc, "$0"];
	ctrlSetText [marketAdjustBuy_box_idc, "$0"];
	ctrlSetText [totalDue_box_idc, "$0"];
	ctrlSetText [buyButton_idc, "Buy"];
	ctrlEnable [buyButton_idc, false];
	ctrlSetText [statusLabel_idc, ""];
};

shop_reset_sell_labels = {
	ctrlSetText [demand_box_idc, "0"];
	ctrlSetText [salesTaxSell_box_idc, "$0"];
	ctrlSetText [marketAdjustSell_box_idc, "$0"];
	ctrlSetText [totalReturn_box_idc, "$0"];
	ctrlSetText [sellButton_idc, "Sell"];
	ctrlEnable [sellButton_idc, false];
	ctrlSetText [statusLabel_idc, ""];
};

shop_get_player_third_weapon = {
	private["_weapons", "_found_pistol"];

	_weapons = weapons player;
	_found_pistol = "";
	{
		if ([_x, "PistolCore"] call shop_weapon_inherits_from) exitWith { _found_pistol = _x };
	} foreach _weapons;
	
	_found_pistol
};

shop_weapon_inherits_from = {
	private["_weapon_class", "_base_class", "_config_class"];
	_weapon_class = _this select 0;
	_base_class = _this select 1;
	_config_class = if (count _this > 2) then { _this select 2; } else { "CfgWeapons" };
	
	
	if (isNil "_weapon_class") exitWith { false };
	if (isNil "_base_class") exitWith { false };
	if (isNil "_config_class") exitWith { false };
	
	if (typeName _weapon_class != "STRING") exitWith { false };
	if (typename _base_class != "STRING") exitWith { false };
	
	private["_i", "_matches", "_parent_config", "_parent_name"];
	_i = 10;
	_matches = false;
	_parent_config = (configFile >> _config_class >> _weapon_class );
	_parent_name = configName(_parent_config);
	while { _i > 0 } do {
		if (_parent_name == _base_class) exitWith { _matches = true };
		_parent_config = inheritsFrom(_parent_config);
		_parent_name = configName(_parent_config);
	    _i = _i - 1;
	};
	_matches
};

shop_get_market_adjustment = {
	private["_supply", "_max_stock", "_market_adjust", "_base_price", "_item", "_amount", "_stock_sold", "_percent_stock_sold"];
	_item  = _this select 0;
	_amount = _this select 1;
	_base_price = _this select 2;
	_supply = _this select 3;
	_max_stock = _this select 4;
	_market_adjust = 0;
		
	if (_max_stock < 0) exitWith { 0 };
	
	_stock_sold = (_max_stock - _supply);
	_percent_stock_sold = (_stock_sold / _max_stock);
	_market_adjust = (_amount * _base_price) * 0.25 * _percent_stock_sold;
	
	_market_adjust
};

shop_buy_item_validate_data = {
	private ["_index", "_item", "_base_price", "_price", "_infos", "_amount", "_total_price", "_shop_id", "_supply", "_max_stock"];
	private ["_sales_tax", "_market_adjust", "_name", "_kind", "_label", "_data", "_control", "_type", "_tax"];
	private ["_weight_str", "_base_weight", "_weight", "_price_str", "_buy_label", "_limitedStock", "_isItem", "_isIllegal"];
	private ["_amount_str", "_class", "_logic", "_quiet", "_supply_str"];
	
	_data = _this select 0;
	if (isNil "_data") exitWith {nil};
	
	_quiet = if (count _this > 1) then { _this select 1 } else {  false };
	if (not(_quiet)) then {
		call shop_reset_buy_labels;
	};
	
	if ((call shop_is_busy)) exitWith {
		[format["Shop is currently busy, please wait"], _quiet] call shop_set_status_message; nil;
	};
	
	_shop_id  = _data select shop_buy_item_shop_id;
	_item = _data select shop_buy_item_key;
	_base_price = [(_data select shop_buy_item_price)] call decode_number;
	_infos = _item call INV_GetItemArray;
	_needsLicense = _data select shop_buy_item_needs_license;
	_license_1 = _data select shop_buy_item_license_1;
	_license_2 = _data select shop_buy_item_license_2;
	_logic = _data select shop_buy_item_logic;
	
	_near_vehicles = if (isNil "_logic") then { [] } else { nearestobjects [getpos _logic, ["Ship","car","motorcycle","truck"], 3] };
	_near_vehicles_count = if (isNil "_near_vehicles") then { 0 } else { count _near_vehicles };
	_supply = [_item, _shop_id] call INV_GetStock;
	_max_stock = [_item, _shop_id] call INV_GetMaxStock;
	_type = _infos call INV_GetItemType;
	_tax = _type call INV_GetObjectTax;
	_kind = _infos call INV_GetItemKindOf;
	_kind = if (isNil "_kind") then { "" } else { _kind };
	_isItem = (_type == "Item");
	_isFort = (_type == "Fort");
	_isWeapon = (_type == "Weapon");
	_isMagazine = (_type == "Magazine");
	_isVehicle = (_type == "Vehicle");
	_isBackpack = (_type == "backpack");
	
	_base_weight = if (_isItem) then { (_infos call INV_GetItemTypeKg) } else { 0 };
	_playerWeight =  call INV_GetOwnWeight;
	_isIllegal = if(_isItem) then {(_item call INV_GetItemIsIllegal)} else { false };
	_class = if(not(_isItem)) then { _infos call INV_GetItemClassName } else { "" };
	
	_limitedStock = (_max_stock != -1);
		
	_amount_str = (ctrlText itemsToBuy_box_idc);
	_amount = if (_amount_str == "") then { 0 } else {[_amount_str] call parse_number };
	_amount = if (_amount < 0 ) then { ctrlSetText [itemsToBuy_box_idc, "1"]; 1 } else {_amount};
	_amount = if (_amount > 100) then { ctrlSetText [itemsToBuy_box_idc, "100"]; 100 } else { _amount };
	
	_status_message = "";
	_buyButton_state = true;
	
	if (_amount <= 0) exitWith {
		["You have entered an invalid amount of items to buy", _quiet] call shop_set_status_message; nil
	};
	
	_putInHands = [_shop_id] call shop_get_put_gear_cb;
	_primary_weapon = primaryWeapon player;
	_secondary_weapon = secondaryWeapon player;
	_pistol = call shop_get_player_third_weapon;
	_backpack = unitBackpack player;
	_hasPrimaryWeapon = (_primary_weapon != "");
	_hasSecondaryWeapon = (_secondary_weapon != "");
	_hasPistol = (_pistol != "");
	_hasBackpack = if (isNil "_backpack" || isNull _backpack) then { false } else { true };
	_isRifle =  ([_class, "RifleCore"] call shop_weapon_inherits_from);
	_isLauncher = ([_class, "LauncherCore"] call shop_weapon_inherits_from);
	_isPistol = ([_class, "PistolCore"] call shop_weapon_inherits_from);
	
	
	_price = _base_price * _amount;
	_weight = _base_weight * _amount;
	
	//add the sales tax to the price
	_sales_tax = round(_price *  (_tax/100));
	
	//for limited stock, adjust the price based on scarce the product is
	_market_adjust = [_item, _amount, _base_price, _supply, _max_stock] call shop_get_market_adjustment;
	
	_market_adjust = round(_market_adjust);
	_sales_tax = round(_sales_tax);
	_total_price = round(_price + _sales_tax + _market_adjust);
	
	_weight_str = if (_weight > 0) then { format["(%1kg)", _weight] } else { "" };
	_supply_str = if (_limitedStock) then { format["%1/%2",_supply, _max_stock] } else { "Unlimited" };
	_salesTax_str = format["$%1", strM(_sales_tax)];
	_marketAdjust_str = format["$%1", strM(_market_adjust)];
	_totalDue_str = format["$%1", strM(_total_price)];
	_buy_label = format["Buy%1", _weight_str];
	
	if (not(_quiet)) then {
		ctrlSetText [supply_box_idc, _supply_str];
		ctrlSetText [salesTaxBuy_box_idc, _salesTax_str];
		ctrlSetText [marketAdjustBuy_box_idc, _marketAdjust_str];
		ctrlSetText [totalDue_box_idc, _totalDue_str];
		ctrlSetText [buyButton_idc, _buy_label];
	};
	
	_player_money =  ([player, 'money'] call INV_GetItemAmount);
	
	//player groupChat format["_license_1 = %1", _license_1];
	if (_needsLicense && isciv && not(_license_1 call INV_HasLicense) && not(_license_1 == "")) exitWith {
		[format["This item requires %1", (_license_1 call INV_GetLicenseName)], _quiet] call shop_set_status_message; nil
	};
	
	//player groupChat format["_license_2 = %1", _license_2];
	if (_needsLicense && iscop && not(_license_2 call INV_HasLicense) && not(_license_2 == "")) exitWith {
		[format["This item requires %1", (_license_2 call INV_GetLicenseName)], _quiet] call shop_set_status_message; nil
	};
	
	if (_isIllegal && iscop) exitWith {
		["The selected item is illegal, you are not allowed to buy it", _quiet]  call shop_set_status_message; nil
	};
	
	if (_amount > 1 && (_isFort || _isVehicle || _isBackpack)) exitWith {
		["The item you have selected can only be bought one at a time", _quiet] call shop_set_status_message; nil
	};
	
	if((_isFort || _isVehicle) && _near_vehicles_count > 0) exitWith {
		["There is a vehicle blocking the spawn", _quiet] call shop_set_status_message; nil
	};
	
	if (_limitedStock && _supply == 0) exitWith {
		["There is no supply for the item you have selected", _quiet] call shop_set_status_message; nil
	};
	
	if (_limitedStock && _amount > _supply) exitWith {
		["You have entered more than the available supply for this item", _quiet] call shop_set_status_message; nil
	};
	
	if (_putInHands && _amount > 1) exitWith {
		["You can only buy one item at a time when using ""Put weapon in hands"" option", _quiet] call shop_set_status_message; nil
	};

	if ((_weight + _playerWeight) > INV_CarryingCapacity) exitWith {
		["The total weight of the items to buy exceed your carrying capacity", _quiet] call shop_set_status_message; nil;
	};
	
	if (_total_price > _player_money) exitWith {
		["You do not have enough money to buy this item", _quiet]  call shop_set_status_message; nil
	};
		
	if (_putInHands &&  _hasPrimaryWeapon && _isWeapon && _isRifle) exitWith {
		["You already have a primary weapon in your hands", _quiet] call shop_set_status_message; nil
	};
	
	if (_putInHands && (_hasSecondaryWeapon || _hasBackpack) && _isWeapon && _isLauncher) exitWith {
		["Your secondary weapon slot is already filled", _quiet] call shop_set_status_message; nil
	};
	
	if (_putInHands && (_hasSecondaryWeapon || _hasBackpack) && _isBackpack) exitWith {
		["Your secondary weapon slot is already filled", _quiet] call shop_set_status_message; nil
	};
		
	if (_putInHands && _hasPistol && _isWeapon && _isPistol) exitWith {
		["Your pistol slot is already filled", _quiet] call shop_set_status_message; nil
	};
	
	if (_putInHands && not(_isPistol || _isBackpack || _isLauncher || _isRifle)) exitWith {
		["The item you have selected to buy cannot be put in hands automatically", _quiet] call shop_set_status_message; nil
	};
	
	_data set [shop_buy_item_total_due, [(_total_price)] call encode_number];
	_data set [shop_buy_item_sales_tax, _sales_tax];
	_data set [shop_buy_item_market_adjust, _market_adjust];
	_data set [shop_buy_item_max_stock, _max_stock];
	_data set [shop_buy_item_supply, _supply];
	_data set [shop_buy_item_type, _type];
	_data set [shop_buy_item_legal, not(_isIllegal)];
	_data set [shop_buy_item_amount, _amount];
	_data set [shop_buy_item_class, _class];
	_data set [shop_buy_item_kind, _kind];
	_data set [shop_buy_item_in_hands, _putInHands];
	
	_data
};

shop_sell_item_validate_data = {
	private ["_index", "_item", "_base_price", "_price", "_infos", "_amount", "_total_price", "_shop_id", "_supply", "_max_stock"];
	private ["_sales_tax", "_market_adjust", "_name", "_kind", "_label", "_data", "_control", "_type", "_tax"];
	private ["_weight_str", "_base_weight","_weight", "_price_str", "_buy_label", "_limitedStock", "_isItem", "_isIllegal"];
	private ["_amount_str", "_class", "_logic", "_quiet", "_demand_str", "_isOilBarrel"];
	
	
	_data = _this select 0;
	if (isNil "_data") exitWith {nil};
	
	_quiet = if (count _this > 1) then { _this select 1; } else { false };
	if (not(_quiet)) then {
		call shop_reset_sell_labels;
	};
	
	if ((call shop_is_busy)) exitWith {
		[format["Shop is currently busy, please wait"], _quiet] call shop_set_status_message; nil;
	};
	
	_sellableItems = ["Item", "Weapon", "Magazine", "Vehicle", "backpack"];
	
	_shop_id  = _data select shop_sell_item_shop_id;
	_item = _data select shop_sell_item_key;
	_base_price = [(_data select shop_sell_item_price)] call decode_number;
	_infos = _item call INV_GetItemArray;
	_logic = _data select shop_sell_item_logic;
	_supply = [_item, _shop_id] call INV_GetStock;
	_max_stock = [_item, _shop_id] call INV_GetMaxStock;
	_isOilBarrel = (_item == "OilBarrel");
	
	

	
	_type = _infos call INV_GetItemType;
	_limitedStock = (_max_stock != -1);
	_isItem = (_type == "Item");
	_isWeapon = (_type == "Weapon");
	_isMagazine = (_type == "Magazine");
	_isVehicle = (_type == "Vehicle");
	_isBackpack = (_type == "backpack");
	_class = if(not(_isItem)) then { _infos call INV_GetItemClassName } else { "" };
	_demand = if (_limitedStock) then { _max_stock - _supply } else { -1 };
	
	_weapons = (weapons player);
	_magazines = (magazines player);
	_vehicles = [player, _class, _item, 50] call shop_get_vehicles_by_class_item;
	
	_weapon_count = if (_isWeapon) then { ({_x == _class} count _weapons ) } else { 0 };
	_weapon_count = if (isNil "_weapon_count") then { 0 } else { _weapon_count };
	
	_magazine_count = if (_isMagazine) then {({_x == _class} count _magazines) } else { 0 };
	_magazine_count = if (isNil "_magazine_count") then { 0 } else { _magazine_count };
	_item_count = if (_isItem) then { ([player, _item] call INV_GetItemAmount) } else { 0 };
	_item_count = if (isNil "_item_count") then { 0 } else { _item_count };
	_vehicle_count = if (_isVehicle) then { count (_vehicles) } else { 0 };
	_vehicle_count = if (isNil "_vehicle_count") then {0} else {_vehicle_count};
	_vehicle_alive_count = if (_vehicle_count > 0) then {({alive _x} count _vehicles)} else { 0 }; 
	_vehicle_alive_count = if (isNil "_vehicle_alive_count") then { 0 } else { _vehicle_alive_count };
	_vehicle_near_count = if (_vehicle_alive_count > 0)  then {({((alive _x) && ((_x distance player) < 50))} count _vehicles) } else { 0 }; 
	_vehicle_near_count = if (isNil "_vehicle_near_count") then {0} else {_vehicle_near_count};
	_hasBackpack = if (_isBackpack) then { _class == typeOf(unitBackpack player); } else { false };
		
	_tax = _type call INV_GetObjectTax;
	_kind = _infos call INV_GetItemKindOf;
	_kind = if (isNil "_kind") then { "" } else { _kind };
	
	_base_weight = if (_isItem) then { (_infos call INV_GetItemTypeKg) } else { 0 };
	_isIllegal = if(_isItem) then {(_item call INV_GetItemIsIllegal)} else { false };
	
	_amount_str = (ctrlText itemsToSell_box_idc);
	
	_amount = if (_amount_str == "") then { 0 } else {[_amount_str] call parse_number };
	_amount = if (_amount < 0 ) then { ctrlSetText [itemsToSell_box_idc, "1"]; 1 } else {_amount};
	_amount = if (_amount > 100) then { ctrlSetText [itemsToSell_box_idc, "100"]; 100 } else { _amount };
	
	if (_amount <= 0) exitWith {
		["You have entered an invalid amount of items to sell", _quiet] call shop_set_status_message; nil
	};
	
	
	if (_isOilBarrel) then {
		_max_stock = (call shop_get_oil_barrel_max_stock);
		_demand = (call shop_get_oil_barrel_demand);
		_supply =  _max_stock - _demand;
		_limitedStock  = true;
	};
	

	
	_price = _base_price * _amount;
	_weight = _base_weight * _amount;
	
	//add the sales tax to the price
	_sales_tax = round(_price *  (_tax/100));
	
	_market_adjust = [_item, _amount, _base_price, _supply, _max_stock] call shop_get_market_adjustment;

	_market_adjust = round(_market_adjust);
	_sales_tax = round(_sales_tax);
	_total_price = round(_price + _sales_tax + _market_adjust);
	
	_weight_str = if (_weight > 0) then { format["(%1kg)", _weight] } else { "" };
	_demand_str = if (_limitedStock) then { format["%1/%2",_demand, _max_stock] } else { "Unlimited" };
	_salesTax_str = format["$%1", strM(_sales_tax)];
	_marketAdjust_str = format["$%1", strM(_market_adjust)];
	_totalReturn_str = format["$%1", strM(_total_price)];
	_sell_label = format["Sell%1",_weight_str];
	
	if (not(_quiet)) then {
		ctrlSetText [demand_box_idc, _demand_str];
		ctrlSetText [salesTaxSell_box_idc, _salesTax_str];
		ctrlSetText [marketAdjustSell_box_idc, _marketAdjust_str];
		ctrlSetText [totalReturn_box_idc, _totalReturn_str];
		ctrlSetText [sellButton_idc, _sell_label];
	};
	
	if(not(_type in _sellableItems)) exitWith {
		["The item you have selected to sell, is not an item that can be sold", _quiet] call shop_set_status_message; nil
	};
	
	if(_limitedStock && _demand == 0 && not(_isOilBarrel)) exitWith {
		["The item you have selected to sell has currently no demand", _quiet] call shop_set_status_message; nil
	};
	
	if (_isWeapon && _weapon_count == 0) exitWith {
		["You do not have the selected weapon to sell", _quiet] call shop_set_status_message; nil
	};
	
	if (_isItem && _item_count == 0) exitWith {
		["You do not have any of the selected item to sell", _quiet] call shop_set_status_message; nil
	};
	
	if (_isItem && _amount > _item_count) exitWith {
		["You are trying to sell more than the amount of items you have", _quiet] call shop_set_status_message; nil
	};
	
	
	if (_isMagazine && _magazine_count == 0) exitWith {
		["You do not have any of the selected magazine/ammunition to sell", _quiet] call shop_set_status_message; nil
	};
	
	if (_isMagazine && _amount  > _magazine_count) exitWith {
		["You are trying to sell more than the amount of magazines/ammution you have", _quiet] call shop_set_status_message; nil
	};
	
	if(_isVehicle && _vehicle_count == 0) exitWith {
		["You do not own any vehicles of the selected type to sell", _quiet] call shop_set_status_message; nil
	};
	if (_isVehicle && _vehicle_alive_count == 0) exitWith {
		["You do not own any vehicles of the selected type that are alive", _quiet] call shop_set_status_message; nil
	};
	if (_isVehicle && _vehicle_near_count == 0) exitWith {
		["You do not own any vehicles of the selected type that are near this shop", _quiet] call shop_set_status_message; nil
	};
	
	if (_isBackpack && not(_hasBackpack)) exitWith {
		["You do not have the selected backpack to sell", _quiet] call shop_set_status_message; nil
	};
	
	if (_amount > 1 && (_isWeapon || _isVehicle || _isBackpack )) exitWith {
		["The item you have selected can only be sold one at a time", _quiet] call shop_set_status_message; nil
	};
	
	if (_isMagazine && _amount > _magazine_count) then {
		["You are trying to sell more magazines/ammution than the amount you have", _quiet] call shop_set_status_message; nil
	};
	
	if (_limitedStock && _amount > _demand && not(_isOilBarrel)) exitWith {
		["You are trying to sell more than the current demand for this item", _quiet] call shop_set_status_message; nil
	};
	
	if (_isIllegal && iscop) exitWith {
		 ["The selected item is illegal, you are not allowed to sell it", _quiet]  call shop_set_status_message; nil
	};
	
	_data set [shop_sell_item_total_return, _total_price];
	_data set [shop_sell_item_sales_tax, _sales_tax];
	_data set [shop_sell_item_market_adjust, _market_adjust];
	_data set [shop_sell_item_max_stock, _max_stock];
	_data set [shop_sell_item_demand, _demand];
	_data set [shop_sell_item_supply, _supply];
	_data set [shop_sell_item_type, _type];
	_data set [shop_sell_item_legal, not(_isIllegal)];
	_data set [shop_sell_item_amount, _amount];
	_data set [shop_sell_item_class, _class];
	_data set [shop_sell_item_kind, _kind];
	
	_data
};


shop_set_status_message = {
	_text = _this select 0;
	_quiet = if (count _this > 1) then { _this select 1 } else { false };
	if (_quiet) exitWith {};
	
	ctrlSetText [statusLabel_idc, _text];
};

shop_get_buy_item_data = {
	private["_index", "_data", "_data_str"];
	_index = lbCurSel buyItem_list_idc;
	_index = if (isNil "_index") then { -1 } else { _index };
	if (_index < 0) exitWith { nil };
	_data_str =  lbData[buyItem_list_idc, _index];
	_data = (call compile _data_str);
	_data
};

shop_get_sell_item_data = {
	private["_index", "_data", "_data_str"];
	_index = lbCurSel sellItem_list_idc;
	_index = if (isNil "_index") then { -1 } else { _index };
	if (_index < 0) exitWith { nil };
	_data_str =  lbData[sellItem_list_idc, _index];
	_data = (call compile _data_str);
	_data
};

shop_update_buy_item = {
	private ["_data"];
	_data = call shop_get_buy_item_data;
	_data = [_data] call shop_buy_item_validate_data;
	if (isNil "_data") exitWith { nil };
	ctrlEnable [buyButton_idc, true];
	buttonSetAction [buyButton_idc,  "call shop_buy;"];
	_data
};

shop_update_sell_item = {
	private ["_data"];
	_data = call shop_get_sell_item_data;
	_data = [_data] call shop_sell_item_validate_data;
	if (isNil "_data") exitWith { nil };
	ctrlEnable [sellButton_idc, true];
	buttonSetAction [sellButton_idc,  "call shop_sell;"];
	_data
};

shop_buy_transaction = {
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	private ["_total_due", "_sales_tax"];
	
	_total_due = [(_data select shop_buy_item_total_due)] call decode_number;
	_sales_tax = _data select shop_buy_item_sales_tax;
	

	[player, 'money', -(_total_due)] call INV_AddInventoryItem;
	[_sales_tax] call shop_update_paid_taxes;
	[_data] call shop_buy_update_stocks;
};

shop_sell_transaction = {
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	private ["_total_return", "_sales_tax"];
	
	_total_return = _data select shop_sell_item_total_return;
	
	[player, 'money', (_total_return)] call INV_AddInventoryItem;
	[_data] call shop_sell_update_stocks;
};

shop_buy = {
	private["_data"];
	_data = call shop_update_buy_item;
	if (isNil "_data") exitWith {};

	ctrlEnable [buyButton_idc, false];
	
	[_data] call shop_buy_transaction;
	private ["_type"];
	_type = _data select shop_buy_item_type;
	switch _type do {
		case "Item": {
			[_data] call shop_buy_item;
		};
		case "Fort": {
			[_data] call shop_buy_fort;
		};
		case "Vehicle": {
			[_data] call shop_buy_vehicle;
		};
		case "Weapon": {
			[_data, INV_CreateWeapon] call shop_buy_gear_item;
		};
		case "Magazine": {
			[_data, INV_CreateMag] call shop_buy_gear_item;
		};
		case "backpack": {
			[_data, INV_CreatePack] call shop_buy_gear_item;
		};
	};
	call shop_update_buy_item;
};

shop_sell = {
[] spawn {
	private["_data"];
	_data = call shop_update_sell_item;
	if (isNil "_data") exitWith {};

	ctrlEnable [sellButton_idc, false];

	private ["_type", "_sold"];
	_type = _data select shop_sell_item_type;
	_sold = true;
	switch _type do {
		case "Item": {
			[_data] call shop_sell_item;
		};
		case "Vehicle": {
			_sold = [_data] call shop_sell_vehicle;
		};
		case "Weapon": {
			[_data] call shop_sell_gear;
		};
		case "Magazine": {
			[_data] call shop_sell_gear;
		};
		case "backpack": {
			[_data] call shop_sell_gear;
		};
	};
	
	if (_sold) then {
		[_data] call shop_sell_transaction;
	};
	call shop_update_sell_item;
};

};

shop_sell_item = {
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	private ["_item", "_total_return", "_item_name", "_i", "_amount", "_type", "_isDrug", "_price","_kind"];

	_item = _data select shop_sell_item_key;
	_item_name = _data select shop_sell_item_name;
	_total_return = _data select shop_sell_item_total_return;
	_amount = _data select shop_sell_item_amount;
	_type = _data select shop_sell_item_type;
	_kind = _data select shop_sell_item_kind;
	_isDrug = (_kind == "drug");
	_price = [(_data select shop_sell_item_price)] call decode_number;
	_shop_id = _data select shop_sell_item_shop_id;
	
	call shop_play_animation;
	
	//keep track of wh has sold drugs
	if (_isDrug) then {
		private["_list"];
		_list  = [];
		_list set [shop_drug_list_player_uid, getPlayerUID player];
		_list set [shop_drug_list_profit, _total_return];
		[_shop_id, _list] call shop_update_drug_list;
	};

	[player, _item, -(_amount)] call INV_AddInventoryItem;
	player groupChat format ["You sold %1 %2 for $%3", _amount, _item_name, strM(_total_return)];
};


shop_sell_select_vehicle = {
	private["_index", "_data", "_data_str"];
	_index = lbCurSel selectVehicle_list_idc;
	_index = if (isNil "_index") then { -1 } else { _index };
	if (_index < 0) exitWith { nil };
	_data_str =  lbData[selectVehicle_list_idc, _index];
	_data = (call compile _data_str);
	shop_sell_selected_vehicle = _data;
	closeDialog shopVehicles_idd;
	_data
};

shop_sell_select_vehicle_wait = {
	private["_vehicles", "_dialog"];
	_vehicles = _this select 0;
	
	if (isNil "_vehicles") exitWith { nil };
	if (typeName _vehicles != "ARRAY") exitWith { nil };
	
	if (!(createDialog "ShopVehicles")) exitWith {hint "Dialog Error!"};
	
	buttonSetAction [selectButton_idc,  "call shop_sell_select_vehicle;"];
	private["_i", "_count"];
	_count = count _vehicles;
	_i = 0;
	shop_sell_selected_vehicle = nil;
	while { _i < _count } do {
		private["_index", "_vehicle", "_vehicle_str"];
		_vehicle = _vehicles select _i;
		_vehicle_str = format["%1", _vehicle];
		_index = lbAdd [selectVehicle_list_idc, _vehicle_str];
		lbSetData [selectVehicle_list_idc, _index, _vehicle_str];
		_i = _i + 1;
	};
	lbSetCurSel [selectVehicle_list_idc, 0];
	waitUntil { _dialog = findDisplay shopVehicles_idd; isNull _dialog };
	
	_vehicle = shop_sell_selected_vehicle;
	shop_sell_selected_vehicle = nil;
	_vehicle
};

shop_sell_vehicle = {
	disableSerialization;
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	private ["_class", "_item", "_total_return", "_class", "_item_name", "_i", "_amount", "_type", "_vehicles", "_vehicle"];
	
	_item = _data select shop_sell_item_key;
	_item_name = _data select shop_sell_item_name;
	_class = _data select shop_sell_item_class;
	_total_return = _data select shop_sell_item_total_return;
	_amount = _data select shop_sell_item_amount;
	_type = _data select shop_sell_item_type;
	
	_vehicles = [player, _class, _item, 50] call shop_get_vehicles_by_class_item;
	_vehicles_count = (count _vehicles);
	_vehicle = nil;
	if  (_vehicles_count == 0) exitWith { false };
	if (_vehicles_count > 1) then {
		_vehicle = [_vehicles] call shop_sell_select_vehicle_wait;
	}
	else {
		_vehicle = _vehicles select 0;
	};
	
	if (isNil "_vehicle") exitWith { false };
				
	player groupChat format["You sold the vehicle for $%1.", strM(_total_return)];
	[player, _vehicle] call vehicle_remove;
	deleteVehicle _vehicle;
	true
};

shop_get_vehicles_by_class_item = {
	//player groupChat format["shop_get_vehicles_by_class_item %1", _this];
	private ["_player", "_class", "_item", "_distance"];
	
	_player = _this select 0;
	_class = _this select 1;
	_item = _this select 2;
	_distance = _this select 3;
	
	if (not([_player] call player_exists)) exitWith {[]};
	if (isNil "_class") exitWith { [] };
	if (typeName _class != "STRING") exitWith { [] };
	if (isNil "_item") exitWith {[]};
	if (typeName _item != "STRING") exitWith {[]};
	if (isNil "_distance") exitWith { [] };
	if (typeName _distance != "SCALAR") exitWith { [] };
	
	private["_vehicles"];
	_vehicles = [];
	private["_vehicle_list"];
	
	_vehicle_list = [_player] call vehicle_list;
	//player groupChat format["_vehicle_list = %1", _vehicle_list];

	private["_vehicle"];
	
	{
		_vehicle = _x;
		if (true) then {
			if (isNil "_vehicle") exitWith {};
			if (not(alive(_vehicle))) exitWith {};
			private["_cdistance"];
			_cdistance = _player distance _vehicle;
			//player groupChat format["_actual_distance = %1, _check_distance = %2", _cdistance , _distance];
			if (_cdistance > _distance) exitWith {};
			if (typeOf _vehicle != _class) exitWith {};
			
			private["_citem"];
			_citem = [_vehicle, "item_name"] call vehicle_get_string;
			//player groupChat format["_citem = %1", _citem];
			if (_citem != _item) exitWith {};
			
			_vehicles = _vehicles + [_vehicle];
		};
	} foreach _vehicle_list;
	
	_vehicles

	
};



shop_sell_gear = {	
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	private ["_class", "_total_return", "_class", "_item_name", "_i", "_amount", "_type"];
	
	_item_name = _data select shop_sell_item_name;
	_class = _data select shop_sell_item_class;
	_total_return = _data select shop_sell_item_total_return;
	_amount = _data select shop_sell_item_amount;
	_type = _data select shop_sell_item_type;
	
	call shop_play_animation;
	
	_i = _amount;
	//for weapon, and backpack, it's always one item 
	while { _i > 0 } do {
		if (_type == "Weapon") then {
			player removeWeapon _class;
		}
		else { if (_type == "Magazine") then {
			player removeMagazine _class;
		}
		else { if (_type == "backpack") then {
			removeBackpack player;
		};};};
		_i = _i - 1;
	};
	
	player groupChat format["You sold %1 %2 for $%3", _amount, _item_name, strM(_total_return)];	
};

shop_buy_item = {
	private ["_data"];
	_data = _this select 0;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	private ["_amount", "_item", "_total_due", "_shop_id", "_item_name"];
	
	_total_due = [(_data select shop_buy_item_total_due)] call decode_number;
	_amount = _data select shop_buy_item_amount;
	_item_name = _data select shop_buy_item_name;
	_item = _data select shop_buy_item_key;
	_shop_id = _data select shop_buy_item_shop_id;
	_kind =  _data select shop_buy_item_kind;
	_isDrug = (_kind == "drug");
	
	if (_isDrug && _total_due > 0) then {
		[_shop_id, _total_due] call shop_distribute_drug_sale;
	};
	
	call shop_play_animation;
	[player, _item, _amount, ([player] call player_inventory_name)] call INV_CreateItem;
	player groupChat format["You bought %1 %2 for $%3", _amount, _item_name, strM(_total_due)];
};


shop_buy_gear_item = {
	private ["_data", "_function"];
	_data = _this select 0;
	_function = _this select 1;
	
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	if (isNil "_function") exitWith {};
	if (typeName _function != "CODE") exitWith {};
	
	private ["_type", "_amount", "_item", "_total_due", "_item_name", "_class", "_crate", "_in_hands"];
	
	_amount = _data select shop_buy_item_amount;
	_item_name = _data select shop_buy_item_name;
	_class = _data select shop_buy_item_class;
	_crate = _data select shop_buy_item_crate;
	_total_due = [(_data select shop_buy_item_total_due)] call decode_number;;
	_type = _data select shop_buy_item_type;
	_in_hands = _data select shop_buy_item_in_hands;
	
	if (_in_hands) then {
		call shop_play_animation;
	};
	
	[_class, _amount, _crate, _in_hands] spawn _function;
		
	player groupChat format["You bought %1 %2 for $%3", _amount, _item_name, strM(_total_due)];
};

shop_buy_fort = {
	_this spawn {
		private ["_data"];
		_data = _this select 0;

		if (isNil "_data") exitWith {};
		if (typeName _data != "ARRAY") exitWith {};
		
		private ["_kind", "_total_due", "_item_name", "_class", "_logic", "_sleep_time"];
		_item_name = _data select shop_buy_item_name;
		_logic = _data select shop_buy_item_logic;
		_total_due = [(_data select shop_buy_item_total_due)] call decode_number;
		_kind = _data select shop_buy_item_kind;
		_class = _data select shop_buy_item_class;
		_sleep_time = 5;
		
		player groupChat format ["You bought a %1 for $%2. Please wait %3 seconds until the vehicle spawns.", _item_name, strM(_total_due), _sleep_time];
		[_sleep_time] call shop_set_busy;
		sleep _sleep_time;
		[_logic, _class, _kind] spawn INV_CreateFort;
	};
};

shop_get_gang_by_shop_id = {
	private["_shop_id", "_shop_cache"];
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {nil};
	
	private["_gang_id", "_gang"];
	_gang_id = _shop_cache getVariable "control";
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id  != "STRING") exitWith {nil};
	if (_gang_id == "") exitWith {nil};
	
	([_gang_id] call gangs_lookup_id)
};

shop_distribute_drug_sale = {
	private["_total_due", "_shop_id"];
	
	_shop_id = _this select 0;
	_total_due = _this select 1;

	if (isNil "_total_due") exitWith {};
	if (typeName _total_due != "SCALAR") exitWith{};

	
	private["_gang", "_gang_name", "_gang_members", "_income"];
	_gang = [_shop_id] call shop_get_gang_by_shop_id;
	
	if (isNil "_gang") exitWith {};
	_gang_name = _gang select gang_name;
	_gang_members = _gang select gang_members;
	_gang_members_count = (count _gang_members);
	if (_gang_members_count == 0) exitWith {};
	
	_income = round(_total_due/_gang_members_count);
	format['if((getPlayerUID player) in %1) then {player groupchat "You received $%2 from a drug sale"; [player, %2] call bank_transaction;};', _gang_members, strM(_income)] call broadcast;
};

shop_get_drug_list = {
	private["_shop_id", "_list", "_shop_cache"];
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	
	if (isNil "_shop_cache") exitWith {[]};
	
	_list = _shop_cache getVariable "drugList";
	if (isNil "_list") exitWith {[]};
	if (typeName _list != "ARRAY") exitWith {[]};
	
	_list
};

shop_update_drug_list = {
	private["_shop_id", "_list", "_shop_cache", "_data", "_uid", "_profit"];
	
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	_data = _this select 1;
	if (isNil "_data") exitWith {};
	
	_list = [_shop_id] call shop_get_drug_list;
	
	//if player uid is already in the list, just update it
	_uid = _data select shop_drug_list_player_uid;
	_profit = _data select shop_drug_list_profit;
	private["_inList"];
	_inList = false;
	{
		private["_cdata", "_cuid", "_cprofit"];
		_cdata = _x;
		_cuid = _cdata select shop_drug_list_player_uid;
		_cprofit = _cdata select shop_drug_list_profit;
		if (_cuid == _uid) exitWith {
			_cdata set [shop_drug_list_profit, (_cprofit + _profit)];
			_inList = true;
		};
	} foreach _list;
	
	if (not(_inList)) then {
		_list = _list + [_data];
	};
	
	[_shop_id, _list] call shop_set_drug_list;
	
	_list
};

shop_set_drug_list = {
	private["_shop_id", "_list", "_shop_cache"];
	_shop_id = _this select 0;
	_list = _this select 1;
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	if (isNil "_list") exitWith {[]};
	if (typeName _list != "ARRAY") exitWith {[]};
	
	_shop_cache setVariable ["drugList", _list, true]; 
	_list
};

shop_drug_list_player_uid = 0;
shop_drug_list_profit = 1;

shop_get_player_by_uid = {
	private["_uid", "_player"];
	
	_uid = _this select 0;
	if (isNil "_uid") exitWith {nil};
	if (typeName _uid != "STRING") exitWith {nil};
	_player = nil;
	{
		private["_player_variable_name", "_cplayer", "_cuid"];
		_player_variable_name = _x;
		_cplayer = missionNamespace getVariable _player_variable_name;
		_cuid = getPlayerUID _cplayer; 
		if (_cuid == _uid) exitWith {
			_player = _cplayer;
		};
	} foreach playerstringarray;
	
	_player
};

shop_drug_search = {
	waituntil{!shop_busy};
	shop_busy=true;
	private["_shop_id", "_list"];
	_shop_id = _this select 0;
	
	_list = [_shop_id] call shop_get_drug_list;
	
	//player groupChat format["_shop_id = %1, _list = %2", _shop_id, _list];
	
	if(count _list == 0) exitWith {
		player groupchat "No drugs found";
	};
	
	{
		if (true) then {
			private["_data", "_player", "_profit", "_uid"];
			_data = _x;
			_uid = _data select shop_drug_list_player_uid;
			_profit = _data select shop_drug_list_profit;
			_player =  [_uid] call player_lookup_uid;
			if (isNil "_player") exitWith {};
			
			player groupChat format["This civilian bought $%1 worth of drugs from %2-%3!", strM(_profit), _player, (name _player)];
			
			[_player, "(drug-trafficking)", _profit] call player_update_warrants;
			private["_message"];
			_message = format["%1-%2 is wanted for trafficking $%3 worth of drugs!", _player, (name _player), strM(_profit)];
			format['titleText [toString(%1), "PLAIN"];', toArray(_message)] call broadcast;
		};
	} foreach _list;
	
	_list = [];
	shop_busy=false;
	[_shop_id, _list] call shop_set_drug_list;
};


shop_busy = false;
shop_set_busy = {
	_this spawn {
		private["_timeout"];
		_timeout = _this select 0;
		_timeout = if(isNil "_timeout") then { 0 } else {_timeout};
		_timeout = if (typeName _timeout != "SCALAR") then { 0 } else { _timeout };
		if (shop_busy) exitWith {};
		shop_busy = true;
		call shop_update_buy_item;
		call shop_update_sell_item;
		sleep _timeout;
		shop_busy = false;
		call shop_update_buy_item;
		call shop_update_sell_item;
	};	
};

shop_is_busy = {
	shop_busy
};

shop_buy_vehicle = {
	_this spawn {
		private ["_data"];
		_data = _this select 0;

		if (isNil "_data") exitWith {};
		if (typeName _data != "ARRAY") exitWith {};
		
		private ["_kind", "_total_due", "_item_name", "_class", "_logic", "_sleep_time"];
		_item = _data select shop_buy_item_key;
		_item_name = _data select shop_buy_item_name;
		_logic = _data select shop_buy_item_logic;
		_total_due = [(_data select shop_buy_item_total_due)] call decode_number;
		_class = _data select shop_buy_item_class;
		_sleep_time = 5;
		
		player groupChat format ["You bought a %1 for $%2. Please wait %3 seconds until the vehicle spawns.", _item_name, strM(_total_due), _sleep_time];
		[_sleep_time] call shop_set_busy;
		sleep _sleep_time;
		[_logic, _class, _item] spawn vehicle_create_shop;
	};
};

shop_reset_paid_taxes = {
	INV_TaxesPaid = 0;
};

shop_get_paid_taxes = {
	if (isNil "INV_TaxesPaid") then { INV_TaxesPaid = 0; };
	INV_TaxesPaid
};

shop_update_paid_taxes = {
	private ["_sales_tax"];
	_sales_tax = _this select 0;
	if (isNil "_sales_tax") exitWith {};
	if (typeName _sales_tax != "SCALAR") exitWith {};
	
	if (isNil "INV_TaxesPaid") then { INV_TaxesPaid = 0; };
	INV_TaxesPaid = INV_TaxesPaid + _sales_tax;
};

shop_buy_update_stocks = {
	private ["_data"];
	
	_data = _this select 0;
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	_item = _data select shop_buy_item_key;
	_max_stock = _data select shop_buy_item_max_stock;
	_amount = _data select shop_buy_item_amount;
	_supply = _data select shop_buy_item_supply;
	_shop_id = _data select shop_buy_item_shop_id;
	_isOilBarrel = (_item == "OilBarrel");
	
	if (_isOilBarrel) exitWith {
		[(_amount * fuel_per_barrel)] call shop_update_fuel_consumed;
	};
	
	if (_max_stock < 0) exitWith {};
	_new_supply = _supply - _amount;
	format['["%1", %2, %3] call INV_ItemStocksupdate;', _item, _new_supply, _shop_id] call broadcast;
};

shop_sell_update_stocks = {
	private ["_data"];
	
	_data = _this select 0;
	if (isNil "_data") exitWith {};
	if (typeName _data != "ARRAY") exitWith {};
	
	_item = _data select shop_sell_item_key;
	_max_stock = _data select shop_sell_item_max_stock;
	_amount = _data select shop_sell_item_amount;
	_supply = _data select shop_sell_item_supply;
	_shop_id = _data select shop_sell_item_shop_id;
	_isOilBarrel = (_item == "OilBarrel");
	
	if (_isOilBarrel) exitWith {
		[-(_amount * fuel_per_barrel)] call shop_update_fuel_consumed;
	};
	
	if (_max_stock < 0) exitWith {};
	_new_supply = _supply + _amount;
	format['["%1", %2, %3] call INV_ItemStocksupdate;', _item, _new_supply, _shop_id] call broadcast;
};


shop_play_animation = {
	private ["_move"];
	_move = if (primaryweapon player == "" && secondaryweapon player == "") then { "AmovPercMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon" } else  {"AinvPknlMstpSlayWrflDnon"};
	if ((vehicle player) == player) then {
		player playMove _move;
		format['%1 playMove %2;', player, _move] call broadcast;
	};
};

shop_refresh_put_gear_cb = {
	private["_state", "_shop_id", "_new_state_str"];
	_shop_id = _this select 0;
	_state = [_shop_id] call shop_get_put_gear_cb;
	_new_state_str = if (_state) then { "[x]" } else { "[ ]" };
	CtrlSettext [put_gear_label_idc, format["%1 - Put weapon in hands", _new_state_str]];
};

shop_refresh_sell_cb = {
	private["_state", "_shop_id", "_new_state_str"];
	_shop_id = _this select 0;
	_state = [_shop_id] call shop_get_sell_cb;
	_new_state_str = if (_state) then { "[x]" } else { "[ ]" };
	CtrlSettext [showAllSellItems_label_idc, format["%1 - Hide unsellable items", _new_state_str]];
};

shop_set_put_gear_cb = {
	private ["_state", "_shop_id", "_shop_cache", "_new_state_str"];
	
	_shop_id = _this select 0;
	_state = _this select 1;
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	if (isNil "_state") then { _state = true; };
	if (typeName _state != "BOOL") then { _state = true;};
		
	_shop_cache setVariable ["put_gear", _state]; 
};

shop_set_sell_cb = {
	private ["_state", "_shop_id", "_shop_cache", "_new_state_str"];
	
	_shop_id = _this select 0;
	_state = _this select 1;
	
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	if (isNil "_state") then { _state = false; };
	if (typeName _state != "BOOL") then { _state = false;};
		
	_shop_cache setVariable ["hide_sell_items", _state]; 
};

shop_get_put_gear_cb = {
	private ["_state", "_shop_id", "_shop_cache"];
	
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith {};
	
	_state = _shop_cache getVariable "put_gear";
	if (isNil "_state") exitWith { false };
	if (typeName _state != "BOOL") exitWith { false };
	_state
};

shop_get_sell_cb = {
	private ["_state", "_shop_id", "_shop_cache"];
	
	_shop_id = _this select 0;
	_shop_cache = [_shop_id] call shop_lookup;
	if (isNil "_shop_cache") exitWith { false };
	
	_state = _shop_cache getVariable "hide_sell_items";	
	if (isNil "_state") exitWith { false };
	if (typeName _state != "BOOL") exitWith { false };
	_state
};

shop_toggle_put_gear_cb = {
	private["_control", "_element", "_state", "_shop_id", "_current_state"];
	_shop_id = call shop_get_current_shop_id;
	_current_state = [_shop_id] call shop_get_put_gear_cb;
	[_shop_id, not(_current_state)] call shop_set_put_gear_cb;
	[_shop_id] call shop_refresh_put_gear_cb;
};

shop_toggle_sell_cb = {
	private["_control", "_element", "_state", "_shop_id", "_current_state"];
	_shop_id = call shop_get_current_shop_id;
	_current_state = [_shop_id] call shop_get_sell_cb;
	[_shop_id, not(_current_state)] call shop_set_sell_cb;
	[_shop_id] call shop_refresh_sell_cb;
};

shop_set_current_shop_id = {
	private["_shop_id"];
	_shop_id = _this select 0;
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	player setVariable ["current_shop_id", _shop_id];
};

shop_get_current_shop_id = {
	private["_shop_id", "_shopDialog"];
	
	_shopDialog = findDisplay shopDialog_idd;
	if (isNull _shopDialog) exitWith {nil};
	
	_shop_id = player getVariable "current_shop_id";
	if (isNil "_shop_id") exitWith { nil };
	if (typeName _shop_id != "SCALAR") exitWith { nil};
	_shop_id
};

shop_open_dialog = {
	private["_shop_id"];
	disableSerialization;
	_shop_id = _this select 0;
	if (isNil "_shop_id") exitWith {};
	if (typeName _shop_id != "SCALAR") exitWith {};
	
	if (not([_shop_id] call shop_is_open)) exitWith {
		player groupChat format["This shop is not open yet. All shops are now %1%2 open", shop_setup_progress, "%"];
	};
	
	if (!(createDialog "Shops")) exitWith {hint "Dialog Error!"};
	[_shop_id] call shop_set_current_shop_id;
	
	[_shop_id] spawn shop_update_buy_list;
	[_shop_id] spawn shop_update_sell_list;
};

shop_get_fuel_consumed = {
	private["_fuel_consumed"];
	_fuel_consumed = server getVariable "fuel_consumed";
	_fuel_consumed
};

shop_set_fuel_consumed = {
	private["_fuel_consumed"];
	_fuel_consumed = _this select 0;
	if (isNil "_fuel_consumed") exitWith {};
	if (typeName _fuel_consumed != "SCALAR") exitWith {};
	
	server setVariable ["fuel_consumed", _fuel_consumed, true];
};

shop_update_fuel_consumed = {
	private["_consumed", "_total_consumed"];

	_consumed = _this select 0;
	if (isNil "_consumed") exitWith {};
	if (typeName _consumed != "SCALAR") exitWith {};
	
	_total_consumed = call shop_get_fuel_consumed;
	_total_consumed = _total_consumed + _consumed;
	
	if (_total_consumed < 0) then {
		_total_consumed = 0;
	};
	
	if (_total_consumed > fuel_max_reserve) then {
		_total_consumed = fuel_max_reserve;
	};
	
	[_total_consumed] call shop_set_fuel_consumed;
};

shop_get_fuel_price = {
	private["_price", "_fuel_consumed", "_barrels_consumed"];
	//the price of fuel goes up by 0.1 for every barrel of oil that is consumed
	_fuel_consumed = call shop_get_fuel_consumed;
	_barrels_consumed = _fuel_consumed / fuel_per_barrel;
	_price = fuel_base_price + (_barrels_consumed * 0.1);
	(round(_price * 100) / 100)
};

shop_get_oil_barrel_demand = {
	round((call shop_get_fuel_consumed)/fuel_per_barrel)
};

shop_get_oil_barrel_max_stock = {
  round(fuel_max_reserve/fuel_per_barrel)
};

shop_get_oil_barrel_supply = {
	private["_demand", "_supply", "_max_stock"];
	_demand = call shop_get_oil_barrel_demand;
	_max_stock = call shop_get_oil_barrel_stock;
	_supply = _max_stock - _demand;
	_supply
};


[INV_ItemShops] spawn shop_setup;
shop_functions_defined = true;
