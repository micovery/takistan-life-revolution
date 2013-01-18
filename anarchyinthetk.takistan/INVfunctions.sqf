// "Function-Call" Script.
// invActions.sqf

INV_Heal = {
	if(_this == player) exitWith {
		liafu = true;

		format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", player] call broadcast;
		player groupChat format[localize "STRS_inv_items_medikit_benutzung"];
		sleep 5;
		player setdamage 0;
		player groupChat format[localize "STRS_inv_items_medikit_fertig"];
		true
	};
	
	format ["%1 switchmove ""AinvPknlMstpSlayWrflDnon_medic"";", _this] call broadcast;
	player groupChat "Healing civ...";
	sleep 5;
	_this setdamage 0;

	true
};

INV_AddInventoryItem = {
	private ["_object", "_item", "_amount", "_info"];
	_object = _this select 0;
	_item  = _this select 1;
	_amount = _this select 2;
	_info = _item call INV_GetItemArray;
	
	private["_total_weight", "_own_weight", "_item_weight"];
	_own_weight = (call INV_GetOwnWeight);
	_item_weight = (_info call INV_GetItemTypeKg);
	_total_weight = (_own_weight + (_amount * _item_weight));
	
	if (_amount == 0) exitWith {false};
	if (_total_weight > INV_CarryingCapacity) exitWith {false};
	
	([_object, _item, _amount, ([_object] call object_storage_name)] call INV_AddItemStorage)
};



INV_CheckArray = {
	private["_object", "_array_name"];
	_object = _this select 0;
	_array_name = _this select 1;
	
	if (isNil "_object") exitWith {};
	if (typeName _object != "OBJECT") exitWith {};
	if (isNil "_array_name") exitWith {};
	if (typeName _array_name != "STRING") exitWith {};

	
	private["_array_variable"];
	_array_variable = _object getVariable _array_name;
	if (isNil "_array_variable") exitWith {
		_object setVariable [_array_name, [], true];
	};
	
	if (typeName _array_variable != "ARRAY") exitWith {
		_object setVariable [_array_name, [], true];
	};
};



// Add Items to Storage
INV_AddItemStorage = {
	private ["_object", "_item", "_quantity", "_arrname"];
	_object = _this select 0;
	_item = _this select 1;
	_quantity = _this select 2;
	_arrname = _this select 3;
	
	[_object, _arrname] call INV_CheckArray;
	
	private["_arr", "_arraynum", "_number"];
	_arr = _object getVariable _arrname;
	
	_arraynum  = -1;
	_number = 0;

	//find the array that contains this item, and cleanup empty ones
	private["_i"];
	_i = 0;
	while { _i < (count _arr) } do {
		private["_info", "_citem", "_count"];
		_info = _arr select _i;
		_citem = _info select 0;
		_count = [(_info select 1)] call decode_number;
		if ( _citem == _item) then {
			_arraynum = _i;
			_number = _count;
		};
		_i = _i + 1;
	};
	
	_quantity = _quantity + _number;
	if (_quantity < 0) exitWith {false};
	
	_arraynum = if (_arraynum < 0) then { count _arr} else { _arraynum };
	_arr set [_arraynum, [_item, ([_quantity] call encode_number)]];
	_object setVariable [_arrname, _arr, true];
	true
};




// Calculate How Many Items are Stored.
INV_GetStorageAmount = {
	private ["_object", "_arrname", "_Itemname"];
	
	_object = _this select 0;
	_Itemname = _this select 1;
	_arrname  = _this select 2;
	
	[_object, _arrname] call INV_CheckArray;
	private["_Array"];
	_Array = _object getVariable _arrname;
	
	private["_Result", "_i"];
	_Result = 0;
	_i = 0;
	while { _i <  (count _Array) } do {
		private["_citem"];
		_citem = ((_Array select _i) select 0);
		if ( _citem == _Itemname) exitWith {
			_Result = ((_Array select _i) select 1);
			_Result = [_Result] call decode_number;
		};
		_i = _i + 1;
	};
	
	_Result
};



// Find Quantity of Items
INV_GetItemAmount = {
	private["_object", "_item"];
	_object = _this select 0;
	_item = _this select 1;
	([_object, _item, ([_object] call object_storage_name)] call INV_GetStorageAmount)	
};


// Change Amount of Items
INV_SetStorageAmount = {
	private ["_object", "_Itemname", "_number", "_Arrayname"];
	_object = _this select 0;
	_Itemname  = _this select 1;
	_number = _this select 2;
	_Arrayname = _this select 3;
	
	[_object, _Arrayname] call INV_CheckArray;
	
	private["_Result", "_Array", "_i"];
	_Result = false;
	_Array = _object getVariable _Arrayname;
	
	_i = 0;
	while { _i < (count _Array) } do {
		private["_citem"];
		_citem = ((_Array select _i) select 0);
		if (_citem == _Itemname) exitWith {
			(_Array select _i) set [1, ([_number] call encode_number)];
			_Result = true;
		};
		_i = _i + 1;
	};
	
	_object setVariable [_Arrayname, _Array, true];

	if ( (!(_Result)) and (_number != 0) ) then {
		_Result = [_object, _Itemname, _number, _Arrayname] call INV_AddItemStorage;
	};

	_Result
};


// Change Amount of Items
INV_SetItemAmount = {
	private["_object", "_item", "_number"];
	_object = _this select 0;
	_item = _this select 1;
	_number = _this select 2;
	
	private["_array_name"];
	_array_name = ([_object] call object_storage_name);
	
	([_object, _item, _number, _array_name] call INV_SetStorageAmount)
};


// Check for a Type of Item in Storage
INV_StorageHasKindOf = {
	private ["_object", "_Arrayname", "_Itemart"];
	_object = _this select 0;
	_Arrayname = _this select 1;
	_Itemart = _this select 2;
	
	
	[_object, _Arrayname] call INV_CheckArray;
	private["_Array", "_i", "_re"];
	_re = false;
	_Array = _object getVariable _Arrayname;
	_i = 0;
	while { _i < (count _Array) } do {
		private["_citem", "_count"];
		_citem = ((_Array select _i) select 0);
		_count = ([((_Array select _i) select 1)] call decode_number);
		if (((_citem call INV_GetItemKindOf) == _Itemart) and (_count > 0)) exitWith {
			_re = true;
		};
		_i = _i + 1;
	};
	_re
};


// Remove One Type of Item From Storage
INV_StorageRemoveKindOf = {
	private ["_object", "_Arrayname",  "_Itemart"];
	_object = _this select 0;
	_Arrayname = _this select 1;
	_Itemart = _this select 2;
	
	[_object, _Arrayname] call INV_CheckArray;
	
	private["_Array", "_i"];
	_Array = _object getVariable _Arrayname;
	
	_i = 0;
	while { _i < (count _Array) } do {
		private["_citem"];
		_citem = ((_Array select _i) select 0);
		if ( (_citem call INV_GetItemKindOf)  == _Itemart) then {
			(_Array select _i) set [1, 0];
		};
		_i = _i + 1;
	};
	_object setVariable [_Arrayname, _Array, true];
	true
};


// Check Stored Item Weight
INV_GetStorageWeight = {
	private ["_object", "_Arrayname"];
	_object = _this select 0;
	_Arrayname = _this select 1;
	
	[_object, _Arrayname] call INV_CheckArray;
	
	private["_weight"];
	_weight = 0;

	{
		private["_entry", "_item", "_count", "_infos", "_item_weight"];
		_entry = _x;
		_item = _entry select 0;
		_count = [(_entry select 1)] call decode_number;
		_infos  = _item call INV_GetItemArray;
		_item_weight = (_infos call INV_GetItemTypeKg);
		_weight = _weight + (_count) * (_item_weight);
		
		_i = _i + 1;
	} forEach (_object getVariable _Arrayname);
	
	_weight
};


// Get Current Weight
INV_GetOwnWeight = {
	private["_player", "_inventory_name"];
	_player = player;
	_inventory_name = [_player] call object_storage_name;
	([_player, _inventory_name] call INV_GetStorageWeight)	
};


// Remove Items that Cannot Exist
INV_RemoveIllegalStorage = {
	private ["_object", "_Arrayname"];
	_object = _this select 0;
	_Arrayname = _this select 1;
	
	if (not([_object, _arrayname, "drug"] call INV_StorageHasKindOf)) exitWith {
		player groupchat "No illegal things found.";
		false
	};
	
	private["_drugs_value", "_Array", "_i"];
	_drugs_value = 0;
	_Array = _object getVariable (format["%1", _arrayname]);
	_i = 0;
	while { _i < (count _Array) } do {
		private["_item", "_infos"];
		_item  = ((_Array select _i) select 0);
		_infos = _item call INV_GetItemArray;

		if(_item call INV_GetItemKindOf == "drug") then {
			private["_price", "_amount"];
			_amount = ([_object, _item, _arrayname] call INV_GetStorageAmount);
			_price  = (_infos call INV_GetItemBuyCost);
			_drugs_value = _drugs_value + (_price * _amount);
		};
		_i = _i + 1;
	};

	[_object, _arrayname, "drug"] call INV_StorageRemoveKindOf;
	(format ["if (player == %2) then {player groupChat ""%1 had drugs in its trunk, you removed them. You should jail the owner of %1 for %4 minutes or give him a ticket of $%5.""}; titletext [format[localize ""STRS_civmenucheck_haddrugs"", %1, %3], ""plain""];", _vcl, player, _drugs_value, ceil(_drugs_value/20000), ceil(_drugs_value/2)]) call broadcast;
	true
};

// Remove Illegal Items
INV_RemoveIllegal = {
	private["_object"];
	_object = _this select 0;

	private["_illegalinfos", "_illwArray", "_illmags", "_has_nv", "_has_bin"];
	_has_nv = if (_object hasWeapon "NVGoggles") then { true } else { false};	
	_has_bin = if (_object hasWeapon "Binocular") then { true } else { false};
	
	[_object] call player_reset_gear;

	if (_has_nv) then {
		_object addWeapon "NVGoggles";
	};
	
	if (_has_bin) then {
		_object addWeapon "Binocular";
	};

   [_object] call player_reset_side_inventory;
};



// Check if Player Can Carry More
INV_CanCarryItems = {
	private ["_item", "_count"];
	_item = _this select 0;
	_count = _this select 1;
	
	private["_items_weight", "_own_weight", "_remain_weight"];
	_items_weight = ((_item call INV_GetItemTypeKg)*_count);
	_own_weight = (call INV_GetOwnWeight);
	_remain_weight = (INV_CarryingCapacity - _own_weight);
	
	(_remain_weight <  _items_weight)
};


// Function Object Taxes
INV_GetObjectTax = {
	private["_item"];
	_item = _this;
	
	private["_result", "_i"];
	_result = 0;
	_i = 0;
	while { _i < (count INV_ItemTypeArray) } do {
		private["_citem"];
		_citem = ((INV_ItemTypeArray select _i) select 0);
		if (_citem == _item) exitWith {
			_result = ((INV_ItemTypeArray select _i) select 2);
		};
		_i = _i + 1;
	};
	_result
};


// Fuction Add Percent (Taxes)
INV_AddPercent = {
	private ["_worth", "_percent", "_result"];
	_worth    = _this select 0;
	_percent = _this select 1;
	_round  = true;
	if (count _this > 2) then {
		_round = _this select 2
	};
	
	if (_round) then {
		_result  = round (  _worth + ((_worth / 100) * _percent) );
	} 
	else {
		_result  = (  _worth + ((_worth / 100) * _percent)  );
	};
	_result
};



// Find Player Weapon Type, is either 1,2 or 3. See in INV_AllWeaponObjects, select 4 then select 0. Handgun is "1", rifle "2", explosives "3".
INV_Handgun_type = 1;
INV_Rifle_type = 2;
INV_Explosive_type = 3;

INV_GetWeaponType = {
	private ["_Fresult"];
	_Fresult = -1;
	{
		if (((_x select 2) select 0) == _this) then {
			_Fresult = ((_x select 4) select 0);
		};
	}
	forEach AllLifeMissionObjects;
	_Fresult
};


// Get Kind of Vehicle
INV_GetVehicleType = {
	private ["_Fresult"];
	_Fresult = -1;
	{
		if (((_x select 2) select 0) == _this) then {
			_Fresult = ((_x select 4) select 0);
		};
	}
	forEach AllLifeMissionObjects;
	_Fresult
};

// Check if Player is Armed
INV_IsArmed = {if (count (weapons player - nonlethalweapons) > 0) then {true}else{false}};

// Check if unit is Armed
INV_UnitArmed = {if (count (weapons _this - nonlethalweapons) > 0) then {true}else{false}};

//Function Item Taxes
INV_GetItemTax = {
	private ["_type", "_item", "_result"];
	_type = _this call INV_GetItemType;
	_cost = _this call INV_GetItemBuyCost;
	[_cost, (_type call INV_GetObjectTax)] call INV_AddPercent;
};


//Function Price Taxes
INV_GetItemTaxPrice= {
	private ["_type", "_preis", "_result"];
	_type  = (_this select 0) call INV_GetItemType;
	_preis = (_this select 1);
	[_preis, (_type call INV_GetObjectTax)] call INV_AddPercent;
};


// Check if Player Owns Licence
INV_HasLicense = {
	([player, _this] call player_has_license)
};


// Get Name of Licence
INV_GetLicenseName = {
	private ["_c"];
	for "_c" from 0 to (count INV_Licenses - 1) do {
		if (((INV_Licenses select _c) select 0) == _this) exitWith {
			((INV_Licenses select _c) select 2)
		};
	};
};


// Unknown
INV_GetScriptFromClass_Mag = {
	private ["_c", "_result"];
	_result = "";
	for "_c" from 0 to (count AllLifeMissionObjects - 1) do {
		if ((((INV_AllMagazineObjects select _c) select 2) select 0) == _this) exitWith {
			_result = ((INV_AllMagazineObjects select _c) select 0);
		};
	};
	_result
};


// Unknown
INV_GetScriptFromClass_Weap = {
	private ["_c", "_result"];
	_result = "";
	for "_c" from 0 to (count AllLifeMissionObjects - 1) do {
		if ((((INV_AllWeaponObjects select _c) select 2) select 0) == _this) exitWith {
			_result = ((INV_AllWeaponObjects select _c) select 0);
		};
	};
	_result
};


// Get item Array
INV_GetItemArray = {
	private ["_c", "_Fobjarray"];
	_Fobjarray = [];
	if ((typeName _this) == "STRING") then {
			_Nname = format["A_MS_%1", _this];
			_Fobjarray = missionNamespace getVariable _Nname;
		};
	if ((typeName _this) == "ARRAY") then {
			_Fobjarray = _this;
		};

	_Fobjarray
};

// Get shop array
INV_GetShopArray = {
	private ["_c", "_Fshoparray"];
	_Fshoparray = [];
	if ((typeName _this) == "OBJECT") then {
		for "_c" from 0 to (count INV_ItemShops - 1) do {
			if (((INV_ItemShops select _c) select 0) == _this) then {
				_Fshoparray = INV_ItemShops select _c;
			};
		};
	};
	if ((typeName _this) == "ARRAY") then {
		_Fshoparray = _this;
	};
	_Fshoparray
};

// Get shop number
INV_GetShopNum = {
	private ["_object"];
	_object = _this;
	
	if ((typeName _object) != "OBJECT") exitWith {nil};
	
	private["_shop_id", "_i"];
	_shop_id = nil;
	_i = 0;
	while { _i < (count INV_ItemShops) } do {
		private["_cobject"];
		_cobject = ((INV_ItemShops select _i) select 0);
		if (_cobject == _object) exitWith {
			_shop_id = _i;
		};
		_i = _i + 1;
	};
	_shop_id
};

// Get shopitem number

INV_GetShopItemNum = {
	private["_item", "_shopinv"];
	_item = _this select 0;
	_shopinv = _this select 1;
	
	private ["_shopitemnum"];
	_shopitemnum = [];
	if ((typeName _item) == "STRING") then {
		private["_i"];
		_i = 0;
		while { _i < (count _shopinv) } do {
			if ((_shopinv select _i) == _item) then {
				_shopitemnum = _i;
			};
			_i = _i + 1;
		};
	};
	_shopitemnum
};



INV_GetStock = {
	private["_item", "_shopnum"];
	_item    = _this select 0;
	_shopnum = (_this select 1);
	
	private["_shoparr", "_shopinv", "_itemnum"];
	_shoparr = INV_ItemShops select _shopnum;
	_shopinv = _shoparr select 4;
	_itemnum = [_item, _shopinv] call INV_GetShopItemnum;

	if (not( typeName _shopnum == "SCALAR" && typeName _itemnum == "SCALAR")) exitWith {-1};
	if(typeName (INV_ItemMaxStocks select _shopnum) != "ARRAY")exitwith{-1};

	(INV_ItemStocks select _shopnum) select _itemnum

};

INV_GetMaxStock = {
	private["_item", "_shopnum"];
	_item 	 = _this select 0;
	_shopnum = (_this select 1);
	
	private["_shoparr", "_shopinv", "_itemnum"];
	_shoparr = INV_ItemShops select _shopnum;
	_shopinv = _shoparr select 4;
	_itemnum = [_item, _shopinv] call INV_GetShopItemNum;

	if (not(typeName _shopnum == "SCALAR" && typename _itemnum == "SCALAR")) exitWith {-1};
	if(typename (INV_ItemMaxStocks select _shopnum) != "ARRAY") exitWith {-1};

	((INV_ItemMaxStocks select _shopnum) select _itemnum)

};

INV_ItemStocksupdate = {
	private["_item", "_stock", "_shopnum"];
	
	_item     = _this select 0;
	_stock    = _this select 1;
	_shopnum  = _this select 2;
	
	private["_shoparr", "_shopinv", "_itemnum"];
	_shoparr  = INV_ItemShops select _shopnum;
	_shopinv  = (_shoparr select 4);
	_itemnum  = [_item, _shopinv] call INV_GetShopItemNum;

	if (isNil "_shopnum") exitWith {};
	if (typeName _shopnum != "SCALAR") exitWith {};
	if (isNil "_itemnum") exitWith {};
	if (typeName _itemnum != "SCALAR") exitWith {};

	(INV_ItemStocks select _shopnum) SET [_itemnum, _stock];
};

INV_HasItem = {
	private["_item", "_return", "_object"];
	_object = _this select 0;
	_item = _this select 1;
	_return = false;
	
	//Object item
	if ((typeName _item) == "STRING") then {
		if(([_object, _item] call INV_GetItemAmount) > 0) exitWith{_return = true;};
	};
	if ((typeName _item) == "ARRAY") then {
		{
			if(([_object, _x] call INV_GetItemAmount) > 0) exitWith{_return = true;};
		} foreach _item;
	};
	_return
};


// Get Object Details
INV_GetItemScriptName = { ((_this call INV_GetItemArray) select 0)};
INV_GetItemType = {((_this call INV_GetItemArray) select 1) select 0};
INV_GetItemKindOf = { ((_this call INV_GetItemArray) select 1) select 1	 };
INV_GetItemClassName = { ((_this call INV_GetItemArray) select 2) select 0 };
INV_GetItemName = {((_this call INV_GetItemArray) select 2) select 1};
INV_GetItemBuyCost = {((_this call INV_GetItemArray) select 3) select 0 };
INV_GetItemSellCost = { ((_this call INV_GetItemArray) select 3) select 1 };
INV_GetItemTypeKg = { ((_this call INV_GetItemArray) select 4) select 0 };
INV_GetVehMaxKg = { ((_this call INV_GetItemArray) select 4) select 3 };
INV_GetItemLicense = { private["_license_1"]; _license_1 = (((_this call INV_GetItemArray) select 4) select 1); if (isNil "_license_1") exitWith {""}; _license_1};
INV_GetItemLicense2 = { private["_license_2"]; _license_2 = (((_this call INV_GetItemArray) select 4) select 2); if (isNil "_license_2") exitWith {""}; _license_2};
INV_GetItemOtherStuff = { ((_this call INV_GetItemArray) select 5) };
INV_GetItemDescription1 = { ((_this call INV_GetItemArray) select 6) };
INV_GetItemDescription2 = { ((_this call INV_GetItemArray) select 7) };
INV_GetItemMaterials = { ((_this call INV_GetItemArray) select 8) };
INV_GetItemGiveable = { ((_this call INV_GetItemArray) select 5) select 0 };
INV_GetItemDropable = { ((_this call INV_GetItemArray) select 5) select 1 };
INV_GetItemLooseable = { ((_this call INV_GetItemArray) select 5) select 2 };
INV_GetItemIsIllegal = { ((_this call INV_GetItemArray) select 5) select 3 };
INV_GetItemFilename = { ((_this call INV_GetItemArray) select 5) select 4 };

//player groupChat "Done definining INV_Functions!";
