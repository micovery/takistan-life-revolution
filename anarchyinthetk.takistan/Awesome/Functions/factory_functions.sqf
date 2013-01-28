#include "macro.h"
#include "constants.h"

if (not(isNil "factory_functions_defined")) exitWith {};

factory_globals = {
	private["_weaponfactory"];
	_weaponfactory=
	[
		"GPS",
		"Binocular",
		"Binocular_Vector",
		"NVGoggles",
		"M9",
		"Rnd_9x19_M9",
		"Makarov",
		"Rnd_9x18_Makarov",
		"MakarovSD",
		"Rnd_9x18_MakarovSD",
		"glock17_EP1",
		"Rnd_9x19_glock17",
		"revolver_EP1",
		"Rnd_45ACP",
		"Colt1911",
		"Rnd_45ACP_1911",
		"UZI_EP1",
		"Rnd_9x19_UZI",
		"UZI_SD_EP1",
		"Rnd_9x19_UZI_SD",
		"Sa61_EP1",
		"Rnd10_765x17_Ball",
		"Rnd20_765x17_Ball",
		"Pecheneg",
		"PK",
		"Rnd_762x54_PK",
		"M60A4_EP1",
		"Rnd_762x51_M240",
		"SVD",
		"SVD_NSPU_EP1",
		"Rnd_762x54_SVD",
		"VSS_vintorez",
		"Rnd_9x39_10_VSS",
		"Rnd_9x39_20_VSS",
		"CZ_550",
		"x_22_LR_17_HMR",
		"Saiga12K",
		"Rnd_B_Saiga12_74Slug",
		"Rnd_B_Saiga12_Pellets",
		"DMR",
		"M14_EP1",
		"Rnd_762x51_DMR",
		"M16A2",
		"M4A1",
		"Rnd_20_Stanag",
		"Rnd_556x45_Stanag",
		"AKS74GOSHAWK",
		"AKS_74_NSPU",
		"AKS74pso",
		"AK74",
		"AK74GL",
		"AKS74kobragl",
		"AKS_74",
		"AKS74kobra",
		"AKS74U",
		"AKS_74_UN_kobra",
		"RPK_74",
		"Rnd_545x39_AK",
		"Rnd_545x39_AKSD",
		"Rnd_545x39_RPK",
		"Bizon",
		"Rnd_9x19_Bizon",
		"G36a",
		"G36C",
		"G36K",
		"G36_C_SD_eotech",
		"MG36",
		"Rnd_556x45_G36",
		"Rnd_556x45_G36SD",
		"Rnd_556x45_BetaCMag",
		"AK_47_M",
		"AK_47_S",
		"Sa58P_EP1",
		"Sa58V_EP1",
		"Rnd_762x39_AK47",
		"Rnd_762x39_SA58",
		"LeeEnfield",
		"x_303",
		"FN_FAL",
		"FN_FAL_ANPVS4",
		"Rnd_762x51_FNFAL",
		"M79",
		"Rnd_HE_M203",
		"FlareWhite_M203",
		"FlareGreen_M203",
		"FlareRed_M203",
		"FlareYellow_M203",
		"Rnd_Smoke_M203",
		"Rnd_SmokeRed_M203",
		"Rnd_SmokeGreen_M203",
		"Rnd_SmokeYellow_M203",
		"Rnd_HE_GP25",
		"FlareWhite_GP25",
		"FlareGreen_GP25",
		"FlareRed_GP25",
		"FlareYellow_GP25",
		"Rnd_SMOKE_GP25",
		"Rnd_SmokeRed_GP25",
		"Rnd_SmokeGreen_GP25",
		"Rnd_SmokeYellow_GP25",
		"HandGrenade_East",
		"Stone"
	];

	private["_terrorfactoryitems"];
	_terrorfactoryitems =
	[
		"Binocular",
		"NVGoggles",
		"Binocular_Vector",
		"GPS",
		"lockpick",
		"medikit",
		"M9",
		"Rnd_9x19_M9",
		"Colt1911",
		"Rnd_45ACP_1911",
		"AK74",
		"AK74GL",
		"AKS74U",
		"AKS74pso",
		"Rnd_545x39_AK",
		"Rnd_762x39_AK47",
		"1Rnd_HE_GP25",
		"SVD",
		"10Rnd_762x54_SVD",
		"RPG7V",
		"PG7VR",
		"MAAWS",
		"MAAWS_HEAT",
		"MAAWS_HEDP",
		"HandGrenade_East",
		"PipeBomb",
		"selbstmordbombe"
		//"fernzuenderbombe",
		//"zeitzuenderbombe",
		//"aktivierungsbombe",
		//"geschwindigkeitsbombe",
		//"fernzuender"
	];

	private["_terrorfactory"];
	_terrorfactory=
	[
		"Pickup_PK_INS",
		"Offroad_DSHKM_INS",
		"Offroad_SPG9_Gue",
		"BRDM2_TK_GUE_EP1",
		"Ural_ZU23_TK_GUE_EP1",
		"BTR40_MG_TK_INS_EP1",
		"UH1H_TK_EP1"
	];

	private["_vehiclefactory"];
	_vehiclefactory=
	[
		"Tractor",
		"TowingTractor",
		"ATV_CZ_EP1",
		"MMT_Civ",
		"Old_bike_TK_CIV_EP1",
		"M1030",
		"TT650_Civ",
		"TT650_Gue",
		"TT650_TK_CIV_EP1",
		"Old_moto_TK_Civ_EP1",
		"Ikarus_TK_CIV_EP1",
		"Ikarus",
		"Skoda",
		"SkodaBlue",
		"SkodaRed",
		"SkodaGreen",
		"Volha_1_TK_CIV_EP1",
		"Volha_2_TK_CIV_EP1",
		"VolhaLimo_TK_CIV_EP1",
		"VWGolf",
		"Lada1_TK_CIV_EP1",
		"Lada2_TK_CIV_EP1",
		"car_hatchback",
		"Car_Sedan",
		"Lada1",
		"Lada2",
		"S1203_TK_CIV_EP1",
		"S1203_ambulance_EP1",
		"LandRover_TK_CIV_EP1",
		"hilux1_civil_2_covered",
		"hilux1_civil_1_open",
		"hilux1_civil_3_open",
		"hilux1_civil_3_open_EP1",
		"datsun1_civil_1_open",
		"datsun1_civil_2_covered",
		"datsun1_civil_3_open",
		"UAZ_Unarmed_TK_CIV_EP1",
		"SUV_TK_CIV_EP1",
		"Ural_TK_CIV_EP1",
		"UralCivil",
		"UralCivil2",
		"V3S_Open_TK_CIV_EP1",
		"V3S_Civ",
		"BAF_Offroad_D",
		"BAF_Offroad_W",
		"LandRover_CZ_EP1",
		"AH6X_EP1",
		"MH6J_EP1",
		"Mi17_Civilian"
	];

	private["_aircraft_factory"];
	_aircraft_factory =
	[
		"AH6X_EP1",
		"MH6J_EP1",
		"MV22",
		"BAF_Merlin_HC3_D",
		"Mi17_Civilian",
		"C130J_US_EP1",
		"An2_1_TK_CIV_EP1",
		"An2_2_TK_CIV_EP1",
		"L39"
	];

	private["_itemfactory"];
	_itemfactory=
	[
		"Binocular",
		"NVGoggles",
		"GPS",
		"reparaturkit",
		"kleinesreparaturkit",
		"kanister",
		"nitro",
		"lockpick",
		"medikit",
		"lighter",
		"defuser",
		"fernzuender",
		"vclammo",
		"fishingpole",
		"Shovel",
		"Pickaxe",
		"JackHammer",
		"supgrade1",
		"supgrade2",
		"supgrade3",
		"supgrade4",
		"supgrade5",
		"SmokeShell",
		"SmokeShellRed",
		"SmokeShellGreen",
		"SmokeShellYellow",
		"SmokeShellPurple",
		"SmokeShellBlue",
		"SmokeShellOrange",
		"Stone"
	];

	private["_tairfactory"];
	_tairfactory =
	[
		"TowingTractor",
		"Pickup_PK_GUE",
		"Offroad_DSHKM_Gue",
		"Offroad_SPG9_Gue",
		"UAZ_Unarmed_TK_EP1",
		"UAZ_AGS30_TK_EP1",
		"UAZ_MG_TK_EP1",
		"LandRover_Special_CZ_EP1",
		"GAZ_Vodnik",
		"M113_TK_EP1",
		"V3S_Open_TK_CIV_EP1",
		"V3S_TK_GUE_EP1",
		"V3S_Refuel_TK_GUE_EP1",
		"V3S_Repair_TK_GUE_EP1",
		"V3S_Reammo_TK_GUE_EP1",
		"BTR40_TK_INS_EP1",
		"BTR40_MG_TK_INS_EP1",
		"UH1H_TK_EP1",
		"Mi17_TK_EP1",
		"An2_TK_EP1"
	];

	private["_alcoholfactory"];
	_alcoholfactory = 
	[
		"beer",
		"beer2",
		"vodka",
		"smirnoff",
		"wiskey",
		"wine",
		"wine2"
	];

	private["_ringfactory"];
	_ringfactory = 
	[
		"Diamondring",
		"EDiamondring",
		"Platinumring",
		"EPlatinumring"
	];

	private["_furnace"];
	_furnace = ["steel"];

	factory_object = 0;
	factory_id = 1;
	factory_name = 2;
	factory_crate = 3;
	factory_spawn = 4;
	factory_items = 5;
	factory_cost = 6;
	factory_storage = 7;
	factory_queue = 8;

	all_factories =
	[
		[ Vehiclefactory, "factory1", "Vehicle Factory", dummyobj, vfacspawn, _vehiclefactory, 5000000, "Fabrikablage1", "vehiclequeue"],
		[ Aircraftfactory, "factory2", "Aircraft Factory", dummyobj, airfacspawn, _aircraft_factory, 8000000, "AircraftFactory1", "aircraftqueue"],
		[ ItemFabrik_1, "factory3", "General Factory", igunbox,dummyobj, _itemfactory, 650000, "Fabrikablage3", "itemqueue"],
		[ weaponfactory, "factory4", "Weapon Factory", wfgunbox,dummyobj, _weaponfactory, 10000000, "Fabrikablage4", "weaponqueue"],
		[ tairshop, "factory6", "Terrorist Vehicle Factory", dummyobj,tairspawn, _tairfactory, 20000000, "Fabrikablage6", "tavehiclequeue"],
		[ alcoholfactory, "factory7", "Alcohol Factory", dummyobj, dummyobj, _alcoholfactory, 1000000, "Fabrikablage7", "alcoholfactoryqueue"] ,
		//[ ringfactory, "factory9", "Ring Factory", dummyobj, dummyobj, _ringfactory, 2500000, "Fabrikablage9", "diamondqueue"],
		[ Furnace, "factory10","Furnace", dummyobj, dummyobj, _furnace, 1500000, "Fabrikablage10","furnacequeue"]
	];
};

factory_init = {
	//player groupChat format["factory_init %1", _this];
	private["_player", "_factory_id"];
	_player = _this select 0;
	_factory_id = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	
	private["_factory"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {};
	
	//initialize the factory queue
	private["_queue_name"];
	_queue_name = _factory select factory_queue;
	[_queue_name, []] call stats_init_variable;
	
	
	//initialize the factory items
	private["_items"];
	_items = _factory select factory_items;
	
	private["_workers_name", "_workers"];
	_workers_name = format["%1workers", _queue_name];
	[_workers_name, 0] call stats_init_variable;

	{
		private["_item", "_prod_name", "_eta_name", "_pend_name", "_avail_name"];
		_item = _x;
		_avail_name = format["%1avail", _item];
		_pend_name = format["%1pend", _item];
		_eta_name = format["%1eta", _item];
		_prod_name = format["%1prod", _item];
		
		[_avail_name, 0] call stats_init_variable;
		missionNamespace setVariable [_pend_name, 0];
		missionNamespace setVariable [_eta_name, 0];
		missionNamespace setVariable [_prod_name, 0];
	} forEach _items;
	
	private["_queue"];
	_queue = missionNamespace getVariable _queue_name;
	{
		private["_item", "_pend_name"];
		_item = _x;
		_pend_name = format["%1pend", _item];
		_pend = missionNamespace getVariable _pend_name;
		_pend = _pend + 1;
		missionNamespace setVariable [_pend_name, _pend]; 
	} forEach _queue;
};

factory_save_storage = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_exists)) exitWith {};
	
	{
		private["_factory", "_storage_name", "_storage"];
		_factory = _x;
		_storage_name = _factory select factory_storage;
		_storage = [_player, _storage_name] call player_get_array;
		[_player, _storage_name, _storage, false] call player_set_array_checked;
	} forEach all_factories;
};

factory_calculate_production_cost = {
	//player groupChat format["factory_calculate_production_cost %1", _this];
	private["_item"];
	
	_item = _this select 0;
	if (isNil "_item") exitWith {0};
	if (typeName _item != "STRING") exitWith {0};
	
	private["_buy_price"];
	_buy_price = (_item call INV_GetItemBuyCost);
	_sell_price = (_item call INV_GetItemSellCost);
	
	
	// simple forumla for calculating the production cost
	// in order for factory owner, to make a profit, the production cost 
	// must be lower than the amount the items sells for ... 
	// whatever extra money the factory owner makes after selling the item is
	// called the profit margin.
	// We are fixing here the profit margin to 10%
	private["_profit_margin"];
	_profit_margin = 0.1; 
	
	private["_cost"];
	_cost = _sell_price - _sell_price * _profit_margin;
	(_cost)
};

factory_calculate_production_time = {
	//player groupChat format["factory_calculate_production_time %1", _this];
	private["_item", "_workers"];
	_item = _this select 0;
	_workers = _this select 1;
	
	if (isNil "_item") exitWith {0};
	if (isNil "_workers") exitWith {0};
	if (typeName _item != "STRING") exitWith {0};
	if (typeName _workers != "SCALAR") exitWith {0};
	
	if (_workers <= 0) exitWith {0};
	
	private["_item_cost"];
	
	_item_cost = (_item call INV_GetItemBuyCost);
	
	// simple linear formula for calculating the production time ... 
	// the more workers you have, the lower the production time
	// the more expensive the item is the higher the production time
	private["_eta"];
	_eta = (_item_cost * 0.01125);
	_eta = (_eta) min( maxmanitime);
	_eta = (_eta * 5) / _workers;
	_eta = round(_eta);
	_eta	
};


factory_lookup_id = {
	private["_id"];
	_id = _this select 0;
	if (isNil "_id") exitWith {nil};
	if (typeName _id != "STRING") exitWith {nil};
	
	private["_factory"];
	_factory = nil;
	{
		private["_cfactory", "_cid"];
		_cfactory = _x;
		_cid = _cfactory select factory_id;
		if (_id == _cid) exitWith {
			_factory = _cfactory;
		};
	} forEach all_factories;
	_factory
};

factory_player_near = {
	//player groupChat format["factory_player_near %1", _this];
	private["_player", "_distance"];
	_player = _this select 0;
	_distance = _this select 1;
	
	if (not([_player] call player_exists)) exitWith {nil};
	if (isNil "_distance") exitWith {nil};
	if (typeName _distance != "SCALAR") exitWith {nil};
	
	private["_min_distance", "_min_factory"];
	_min_distance = _distance;
	_min_factory = nil;
	
	{
		private["_cfactory", "_cdistance", "_cobject"];
		_cfactory = _x;
		_cobject = _cfactory select factory_object;
		_cdistance = _player distance _cobject;
		if (_cdistance < _min_distance) then {
			_min_distance = _cdistance;
			_min_factory = _cfactory;
		};
	} forEach all_factories;
	
	_min_factory
};

factory_loop = {
	//player groupChat format["factory_loop %1", _this];
	private["_player", "_factory_id"];
	_player = player;
	_factory_id = _this select 0;
	
	if (not([_player] call player_human)) exitWith {
		player groupChat "Error (factory_loop): Not a player";
	};
	
	if (isNil "_factory_id") exitWith {
		player groupChat "Error (factory_loop): No factory";
		_this spawn factory_loop;
	};
	
	if (typeName _factory_id != "STRING") exitWith {
		player groupChat "Error (factory_loop): Invalid factory id";
		_this spawn factory_loop;
	};
	
	private["_factory", "_queue_name"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {
		player groupChat "Error (factory_loop): Invalid factory";
		_this spawn factory_loop;
	};
	
	_queue_name = _factory select factory_queue;
	
	call factory_update_queue_list;
	call factory_update_dequeue_item;
	call factory_update_enqueue_item;
	
	//wait for an item to be put on queue
	//player groupChat format["Waiting for queue item at %1", _factory_id];
	waitUntil { (count(missionNamespace getVariable _queue_name) > 0)};
	//player groupChat format["Queue item %1 received at %2",((missionNamespace getVariable _queue_name) select 0), _factory_id];
	
	//item on queue, production started
	private["_queue", "_item"];
	_queue = missionNamespace getVariable _queue_name;
	_item = _queue select 0;
	
	private["_prod", "_pend", "_avail", "_prod_name", "_pend_name", "_avail_name"];
	
	_prod_name = format["%1prod", _item];
	_pend_name = format["%1pend", _item];
	_avail_name = format["%1avail", _item];
	
	_prod = missionNamespace getVariable _prod_name;
	_pend = missionNamespace getVariable _pend_name;
	_avail = missionNamespace getVariable _avail_name;
	
	//update the production, and pending value
	_prod = (_prod + 1) max (0);
	_pend = (_pend - 1) max (0);
	
	[_prod_name, _prod] spawn stats_client_save;
	[_pend_name, _pend] spawn stats_client_save;
	
	missionNamespace setVariable [_prod_name, _prod];
	missionNamespace setVariable [_pend_name, _pend];

	private["_workers_name"];
	_workers_name = format["%1workers", _queue_name];
	
	//wait for workers
	//player groupChat format["Waiting for workers at %1", _factory_id];
	waitUntil { (missionNamespace getVariable _workers_name) > 0 };
	//player groupChat format["Workers recieved at %1", _factory_id];
	
	private["_workers"];
	_workers = missionNamespace getVariable _workers_name;
	
	//calculate the manufacture time
	private["_eta", "_item_cost"];
	_item_cost = (_item call INV_GetItemBuyCost);
	_eta = [_item, _workers] call factory_calculate_production_time;

	private["_item_name", "_factory_name"];
	_factory_name = (_factory select factory_name);
	_item_name = (_item call INV_GetItemName);
	
	player groupChat format["Production of %1 started at your %2, it will take %3 seconds(s) to complete", _item_name, _factory_name, _eta];
	
	//countdown the manufacture time
	private["_eta_name", "_original_production", "_production_canceled"];
	
	_production_canceled = false;
	_original_production = missionNamespace getVariable _prod_name;
	_eta_name = format["%1eta", _item];
	while { _eta > 0 } do {
		sleep 1;
		
		// For debug:
		//player groupChat format["_eta = %1, _item = %2, _workers = %3", _eta, _item, _workers];

		private["_current_production"];
		_current_production = missionNamespace getVariable _prod_name;
		
		if ((_current_production < _original_production) ) exitWith {
			[_prod_name, _current_production] spawn stats_client_save;
			_production_canceled = true;
		};
		
		_workers = missionNamespace getVariable _workers_name;
		if (_workers > 0) then {
			_eta = _eta - 1;
			missionNamespace setVariable [_eta_name, _eta];
			call factory_update_production_stats;
		};
		
	};
	
	if (_production_canceled) exitWith {
		//player canceled the production of the item
		sleep 1;
		_this spawn factory_loop;
	};

	_prod = missionNamespace getVariable _prod_name;
	_avail = missionNamespace getVariable _avail_name;
	
	//production complete, update the values
	_prod = (_prod - 1) max (0);
	_avail = _avail + 1;
	
	missionNamespace setVariable [_prod_name, _prod];
	missionNamespace setVariable [_avail_name, _avail];
	
	_queue = missionNamespace getVariable _queue_name;
	_queue set [0,0];
	_queue = _queue - [0];
	missionNamespace setVariable [_queue_name, _queue];
	
	player groupChat format["A %1 was produced at your %2", _item_name, _factory_name];
	
	//update the stats
	[_prod_name, _prod] spawn stats_client_save;
	[_avail_name, _avail] spawn stats_client_save;
	[_queue_name, _queue] spawn stats_client_save;
	
	sleep 1;
	_this spawn factory_loop;
};




factory_item_dequeue = {
	//player groupChat format["factory_item_dequeue %1", _this];
	private["_player", "_factory_id", "_item", "_index"];
	_player = _this select 0;
	_factory_id = _this select 1;
	_item = _this select 2;
	_index = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith{};
	if (typeName _factory_id != "STRING") exitWith {};
	if (isNil "_item") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (isNil "_index") exitWith {};
	if (typeName _index != "SCALAR") exitWith {};
	if (_index < 0) exitWith {};
	
	private["_factory"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {};
	
	private["_factory_name", "_queue_name", "_factory_storage"];
	_factory_name = _factory select factory_name;
	_factory_storage = _factory select factory_storage;
	_queue_name = _factory select factory_queue;
	
	
	private["_info", "_item_type", "_item_name"];
	_info = (_item call INV_GetItemArray);
	_item_type = _item call INV_GetItemType;
	_item_name = _item call INV_GetItemName;


	private["_queue", "_eta_name", "_pend_name"];
	_eta_name = format["%1eta", _item];
	_pend_name = format["%1pend", _item];

	private["_eta"];
	
	_queue = missionNamespace getVariable _queue_name;
	_eta = missionNamespace getVariable _eta_name;

	private["_minimum_time"];
	_minimum_time = 5; 
	if (_index == 0 && _eta < _minimum_time) exitWith {
		player groupChat format["%1-%2, you are not allowed to cancel when production time is less than %3 seconds", _player, (name _player), _minimum_time];
	};
	
	
	//simple case, item is not being produced yet
	private["_pend_name", "_pend", "_prod_name", "_prod"];
	_pend_name = format["%1pend", _item];
	_pend = missionNamespace getVariable _pend_name;
	_prod_name = format["%1prod", _item];
	_prod = missionNamespace getVariable _prod_name;
	
	if (not(_prod > 0 || _pend > 0)) exitWith {
		player groupChat format["%1-%2, you do not have any %3 in production, or pending", _player, (name _player), _item_name];
	};
	
	//update the production and pending values
	if (_index == 0 && _prod > 0) then {
		_prod = _prod - 1;
		_prod = (_prod) max (0);
		
		//player groupChat format["%1-%2, your %3 was in production, it has been canceled", _player, (name _player), _item_name];
	}
	else { if (_pend > 0) then {
		_pend = _pend - 1;
		_pend = (_pend) max (0);
		//player groupChat format["%1-%2, you had a %3 pending production, it has been canceled", _player, (name _player), _item_name];
	};};
		
	
	//look for the item in the queue
	private["_i", "_index"];
	_i = 0;
	_index = -1;
	while { _i < (count _queue) } do {
		private["_citem"];
		_citem = _queue select _i;
		if (_citem == _item) exitWith {
			_index = _i;
		};
		_i = _i + 1;
	};
	
	
	//remove the item from the queue
	if (_index >= 0) then {
		_queue set [_index, 0];
		_queue = _queue - [0];
	};
	
	//reimburse the player for the production cost
	private["_production_cost"];
	_production_cost = [_item] call factory_calculate_production_cost;
	[_player, "money", _production_cost, _factory_storage] call INV_AddItemStorage;
	[_factory_storage, _player getVariable _factory_storage] call stats_client_save;
	
	//player groupChat format["%1-%2, you have been reimbursed $%3 for %4", _player, (name _player), _production_cost, _item_name];
	//player groupChat format["_queue = %1", _queue];
	missionNamespace setVariable [_queue_name, _queue];
	missionNamespace setVariable [_pend_name, _pend];
	missionNamespace setVariable [_prod_name, _prod];
	[_prod_name, _prod] spawn stats_client_save;
	[_queue_name, _queue] spawn stats_client_save;
	call factory_update_queue_list;
};

factory_item_enqueue = {
	//player groupChat format["factory_item_enqueue %1", _this];
	private["_player", "_factory_id" ,"_item", "_amount"];
	
	_player = _this select 0;
	_factory_id = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;
	
	factory_enqueue_active = if(isNil "factory_enqueue_active") then {false} else {factory_enqueue_active};
	if (factory_enqueue_active) exitWith{};
	
	if (not([_player] call player_human)) exitWith {};
	if(isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	if (isNil "_item") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCAlAR") exitWith {};
	
	if (_amount == 0) exitWith {};
	factory_enqueue_active = true;
	
	
	private["_factory", "_factory_storage", "_factory_queue", "_factory_name", "_factory_money", "_starttime"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {factory_enqueue_active = false;};
	
	_factory_storage = _factory select factory_storage;
	_factory_queue = _factory select factory_queue;
	_factory_name = _factory select factory_name;
	_factory_money = [_player, "money", _factory_storage] call INV_GetStorageAmount;
	
	private["_info", "_item_type", "_item_name", "_production_cost"];
	_info = (_item call INV_GetItemArray);
	_item_type = _item call INV_GetItemType;
	_item_name = _item call INV_GetItemName;
	
	private["_workers_name", "_workers"];
	_workers_name = format["%1workers", _factory_queue];
	_workers = missionNamespace getVariable _workers_name;
	
	if (_workers <= 0) exitWith {
		factory_enqueue_active = false;
		player groupChat format["%1-%2, you cannot start production at your %3, because you have not hired any workers", _player, (name _player), _factory_name];
	};
	
	_production_cost = [_item, _workers] call factory_calculate_production_cost;
	
	private["_total_due"];
	_total_due = (_amount * _production_cost);
	
	if (_factory_money < _total_due) exitWith {
		factory_enqueue_active = false;
		player groupChat format["%1-%2, you do not have enough money in your %3 storage to produce %4 %5", _player, (name _player), _factory_name, _amount, _item_name];
	};
	
	
	[_player, "money", -(_total_due), _factory_storage] call INV_AddItemStorage;
	[_factory_storage, _player getVariable _factory_storage] call stats_client_save;
	
	
	player groupChat format["%1-%2, you have added %3 %4 to the production queue of your %5", _player, (name _player), _amount, _item_name, _factory_name];
	
	private["_pend_name", "_pend", "_queue"];
	_pend_name = format["%1pend", _item];	
	
	while { _amount > 0 } do {
		_queue = missionNamespace getVariable _factory_queue;
		_pend = missionNamespace getVariable _pend_name;
		
		_queue = _queue + [_item];
		_pend = _pend + 1;
	
		missionNamespace setVariable [_pend_name, _pend];
		missionNamespace setVariable [_factory_queue, _queue];
		
		[_pend_name, _pend] call stats_client_save;
		[_factory_queue, _queue] call stats_client_save;
		_amount = _amount - 1;
	};
	
	call factory_update_queue_list;
	factory_enqueue_active = false;
};


factory_item_create = { 
	//player groupChat format["factory_item_create %1", _this];
	private["_player", "_factory_id" ,"_item", "_amount"];
	
	_player = _this select 0;
	_factory_id = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if(isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	if (isNil "_item") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCAlAR") exitWith {};
	
	if (_amount <= 0) exitWith {};

	private["_factory", "_factory_storage", "_factory_spawn", "_factory_crate"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {};
	
	_factory_storage = _factory select factory_storage;
	_factory_spawn = _factory select factory_spawn;
	_factory_crate = _factory select factory_crate;
	
	private["_info", "_item_type", "_item_name"];
	_info = (_item call INV_GetItemArray);
	_item_type = _item call INV_GetItemType;
	_item_name = _item call INV_GetItemName;
	
	if (not(_item_type in ["Item", "Weapon", "Magazine", "Vehicle"])) exitWith {};
	
	if (_item_type == "Vehicle" && _amount > 1) exitWith {
		player groupChat format["%1-%2, you can only create one %3 at a time", _player, (name _player), _item_name];
	};
	
	private["_avail_name", "_avail"];
	_avail_name = format["%1avail", _item];
	_avail = missionNamespace getVariable _avail_name;
	
	if (_avail  < _amount) exitWith {
		player groupChat format["%1-%2, you have not produced enough %3 to create", _player, (name _player), _item_name];
	};
		
	player groupChat format["%1-%2, you have created %3 %4", _player, (name _player), _amount, _item_name];

	_avail = missionNamespace getVariable _avail_name;
	while { _amount > 0 && _avail > 0} do {
		_avail = _avail - 1;
		missionNamespace setVariable [_avail_name, _avail];
		[_avail_name, _avail] spawn stats_client_save;
		
		switch _item_type do {
			case "Item": {
				[_player, _item, 1, _factory_storage] spawn INV_CreateItem;
			};
			case "Weapon": {
				[(_info call INV_GetItemClassName), 1, _factory_crate] spawn INV_CreateWeapon;
			};
			case "Magazine": {
				[(_info call INV_GetItemClassName), 1, _factory_crate] spawn INV_CreateMag;
			};
			case "Vehicle": {
				private["_vehicle_class"];
				_vehicle_class = (_info call INV_GetItemClassName);
				_vehicle_script_name = (_info call INV_GetItemScriptName);
				[_factory_spawn, _vehicle_class, _vehicle_script_name, false] spawn vehicle_create_shop_extended;
			};
		};
		
		_avail = missionNamespace getVariable _avail_name;
		_amount = _amount - 1;
	};
	
	call factory_update_enqueue_item;
};


factory_actions = [];
factory_remove_actions = {
	if (count factory_actions == 0) exitWith {};
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	{
		private["_action_id"];
		_action_id = _x;
		_player removeAction _action_id;
	} forEach factory_actions;
	factory_actions = [];
};

factory_update_enqueue_list = { 
	private["_factory"];
	_factory = factory_selected;
	if (isNil "_factory") exitWith {};
	
	private["_queue_name", "_queue", "_items", "_workers_name", "_workers"];
	_queue_name = _factory select factory_queue;
	_queue = missionNamespace getVariable _queue_name;
	_items = _factory select factory_items;
	_workers_name = format["%1workers", _queue_name];
	_workers = missionNamespace getVariable _workers_name;
	
	lbClear factory_enqueue_list_id;
	
	{
		if (!dialog) exitwith {};
		
		private["_index", "_item", "_eta", "_item_name", "_minutes"];
		_item = _x;
		_eta = [_item, _workers] call factory_calculate_production_time;
		_minutes = _eta / 60;
		_minutes = (floor(_minutes * 10)/10); //truncate to leave only 1 decimal digit
		_item_name = _item call INV_GetItemName;
		_index = lbAdd [factory_enqueue_list_id, format["%1 (%2 min/s)", _item_name, _minutes]];
		lbSetData [factory_enqueue_list_id, _index, _x];
	} forEach _items;
		
	call factory_update_enqueue_item;
};




factory_update_queue_list = { 
	private["_factory"];
	_factory = factory_selected;
	if (isNil "_factory") exitWith {};
	
	private["_queue_name", "_queue"];
	_queue_name = _factory select factory_queue;
	_queue = missionNamespace getVariable _queue_name;
	
	private["_index"];
	_index = (lbCurSel factory_dequeue_list_id);
	
	lbClear factory_dequeue_list_id;
	
	private["_i"];
	_i = 0;
	private["_previous_item", "_previous_item_count", "_logical_index"];
	_previous_item = "";
	_previous_item_count = -1;
	_logical_index = 0;
	
	//build the merged list 
	private["_list"];
	_list = [];
	while { _i < (count _queue) } do {
		private["_citem", "_citem_info", "_citem_name", "_index"];
		_citem = _queue select _i;
		_citem_info = (_citem call INV_GetItemArray);
		_citem_name = (_citem_info call INV_GetItemName);
		
		if (_citem == _previous_item) then {
			_previous_item_count = _previous_item_count + 1;
			_previous_item = _citem;
			_list set [((count _list) - 1), [format["%1. %2 (%3 item)",_logical_index, _citem_name, _previous_item_count], _citem]];
		}
		else {
			_logical_index = _logical_index + 1;
			_previous_item_count = 1;
			_previous_item = _citem;
			_list set [(count _list), [format["%1. %2 (%3 item)",_logical_index, _citem_name, 1], _citem]];
		};
		_i = _i + 1;
	};
	
	//player groupChat format["_list = %1", _list];
	_i = 0;
	while { _i < (count _list) } do {
		private["_entry", "_text", "_item", "_index"];
		_entry = _list select _i;
		_text = _entry select 0;
		_item = _entry select 1;
		
		//player groupChat format["Adding %1, %2", _text, _item];
		_index = lbAdd [factory_dequeue_list_id, _text];
		lbSetData [factory_dequeue_list_id, _index, _item];
		_i = _i + 1;
	};
	
	lbSetCurSel [factory_dequeue_list_id, _index];
	call factory_update_dequeue_item; 
};

factory_update_status_fields = {
	private["_messages"];
	_messages = _this select 0;
	if (isNil "_messages") exitWith {};
	if (typeName _messages != "ARRAY") exitWith {};

	private["_message1", "_message2"];
	_message1 = _messages select 0;
	_message2 = _messages select 1;
	
	ctrlSetText [factory_status_field1_id, _message1];
	ctrlSetText [factory_status_field2_id, _message2];
};

factory_update_enqueue_item = {
	private["_index", "_item"];
	_index = (lbCurSel factory_enqueue_list_id);
	
	private["_production_cost", "_avail"];
	_production_cost = 0;
	_avail = 0;
	
	if (_index > 0) then {
		_item = (lbData [factory_enqueue_list_id, _index ]);
		
		if (isNil "_item") exitWith {};
		if (typeName _item != "STRING") exitWith {};
		
		private["_info", "_item_name", "_avail_name"];
		
		_info = (_item call INV_GetItemArray);
		_item_name = (_info call INV_GetItemName);
		_avail_name =  format["%1avail", _item];
		_avail = missionNamespace getVariable _avail_name;
		
		private["_amount"];
		_amount = (ctrlText factory_amount_field_id);
		_amount = [_amount] call parse_number;
		
		_production_cost = ([_item] call factory_calculate_production_cost) * _amount;
	};
	
	ctrlSetText [factory_item_cost_field_id, format["$%1", strM(_production_cost)]];
	ctrlSetText [factory_item_produced_field_id, str(_avail)];
	
	private["_messages"];
	_messages = call factory_validate_enqueue_item;
	[_messages] call factory_update_status_fields;
};

factory_validate_enqueue_item = {
	//player groupChat format["factory_validate_enqueue_item"];
	ctrlEnable[factory_enqueue_button_id, false];
	ctrlEnable[factory_create_button_id, false];
	
	
	private["_factory"];
	_factory = factory_selected;
	if (isNil "_factory") exitWith {};
		
	private["_player", "_item", "_index"];	
	_player = player;
	_index = (lbCurSel factory_enqueue_list_id);
	
	if (_index < 0 ) exitWith {
		(["You have not selected any item to produce or create", ""])
	};
	
	_item = (lbData [factory_enqueue_list_id, _index]);
	
	private["_message1", "_message2"];
	_message1 = "";
	_message2 = "";
	
	private["_amount", "_amount_str"];
	_amount_str = (ctrlText factory_amount_field_id);
	
	_amount = if (_amount_str == "") then { 0 } else {[_amount_str] call parse_number };
	_amount = if (_amount < 0 ) then { ctrlSetText [factory_amount_field_id, "1"]; 1 } else {_amount};
	_amount = if (_amount > 100) then { ctrlSetText [factory_amount_field_id, "100"]; 100 } else { _amount };
	
	
	
	if (_amount == 0) exitWith {
		["The value entered in the amount field is not valid", ""]
	};
	
	private["_factory_queue", "_workers_name", "_workers"];
	_factory_queue = _factory select factory_queue;
	_workers_name = format["%1workers", _factory_queue];
	_workers = missionNamespace getVariable _workers_name;
		

	private["_avail_name", "_avail"];
	_avail_name = format["%1avail", _item];
	_avail = missionNamespace getVariable _avail_name;
	
	private["_factory_storage", "_factory_money", "_production_cost"];
	_factory_storage = _factory select factory_storage;
	_factory_money = [_player, "money", _factory_storage] call INV_GetStorageAmount;
	_production_cost = ([_item] call factory_calculate_production_cost) * _amount;
	
	private["_created_allowed", "_enqueue_allowed"];
	_create_allowed = true;
	_enqueue_allowed = true;
	
	
	
	if (_amount > _avail) then {
		_message1 = "The amount of items create is higher than the amount of items produced";
		_create_allowed = false;
	};
	
	if (_production_cost > _factory_money) then {
		_message2 = "There is not enough money in the factory storage to produce this item";
		_enqueue_allowed = false;
	};
	
	if (not(_workers > 0)) then {
		_message2 = "Production cannot start because you have not hired any workers";
		_enqueue_allowed = false;
	};
	
	
	ctrlEnable[factory_create_button_id, _create_allowed];
	ctrlEnable[factory_enqueue_button_id, _enqueue_allowed];
	
	([_message1, _message2])
};

factory_update_dequeue_item = {
	call factory_update_production_stats;
	private["_messages"];
	_messages = call factory_validate_dequeue_item;
	[_messages] call factory_update_status_fields;
};

factory_validate_dequeue_item = {
	ctrlEnable[factory_dequeue_button_id, false];
	
	private["_factory"];
	_factory = factory_selected;
	if (isNil "_factory") exitWith {};
		
	private["_player", "_item", "_index"];	
	_player = player;
	_index = (lbCurSel factory_dequeue_list_id);
	if (_index < 0 ) exitWith {
		(["You have not selected any item to cancel", ""])
	};
	
	_item = (lbData [factory_dequeue_list_id, _index]);

	private["_message1", "_message2", "_dequeue_allowed"];
	_message1 = "";
	_message2 = "";
	_dequeue_allowed = true;
	
	if (_index == 0) then {
		private["_eta_name", "_eta", "_min", "_prod", "_prod_name"];
		_min = 5;
		_eta_name = format["%1eta", _item];
		_eta = missionNamespace getVariable _eta_name;
		
		_prod_name = format["%1prod", _item];
		_prod = missionNamespace getVariable _prod_name;
		if (_eta < _min && _prod > 0) then {
			_message1 = format["Cancel not allowed if production time is less than %1 seconds", _min];
			_dequeue_allowed = false;
		};
	};
	
	ctrlEnable[factory_dequeue_button_id, _dequeue_allowed];
	([_message1, _message2])
};



factory_update_production_stats = {
	private["_factory"];
	_factory = factory_selected;
	if (isNil "_factory") exitWith {};
	
	private["_item", "_index"];	
	_index = (lbCurSel factory_dequeue_list_id);
	_item = (lbData [factory_dequeue_list_id, _index]);
	
	if (isNil "_item") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	
	private["_info", "_item_name"];
	_info = (_item call INV_GetItemArray);
	_item_name = (_info call INV_GetItemName);
		
	private["_eta"];
	_eta = 0;
	if (_index < 0) then {
		_eta = 0;
		_item_name = "(none)";
	}
	else { if (_index == 0) then {
		private["_eta_name"];
		_eta_name = format["%1eta", _item];
		_eta = missionNamespace getVariable _eta_name;
	}
	else {
		private["_queue_name", "_workers_name", "_workers"];
		_queue_name = _factory select factory_queue;
		_workers_name = format["%1workers", _queue_name];
		_workers = missionNamespace getVariable _workers_name;
		private["_production_time"];
		_eta = [_item, _workers] call factory_calculate_production_time;
	};};
	
	
	ctrlSetText [factory_production_field_id, _item_name];
	ctrlSetText [factory_production_eta_field_id, format["%1 seconds", _eta]];
};

factory_production_menu = { _this spawn {
	private["_player", "_factory_id"];
	_player = _this select 0;
	_factory_id = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	
	private["_factory"];
	_factory = [_factory_id] call factory_lookup_id;
	
	if (!(createDialog "factory_dialog")) exitWith {hint "Dialog Error!";};
	
	disableSerialization;
	
	//set the factory being used, for other UI functions
	factory_selected = _factory;
	[] spawn {
		waitUntil { not(ctrlVisible factory_enqueue_list_id) };
		factory_selected = nil;
	};
	
	private["_factory_name"];
	_factory_name = _factory  select factory_name;
	
	ctrlSetText [factory_left_frame_id, format["%1 Items", _factory_name]];
	ctrlSetText [factory_right_frame_id, format["%1 Queue", _factory_name]];
	
	call factory_update_enqueue_list;
	call factory_update_queue_list;
	
	private["_player", "_factory_id", "_item"];

	buttonSetAction [factory_enqueue_button_id, format['[%1, "%2", (lbData [factory_enqueue_list_id, (lbCurSel factory_enqueue_list_id)]), ([(ctrlText factory_amount_field_id)] call parse_number)] call factory_item_enqueue;', _player, _factory_id]];
	buttonSetAction [factory_create_button_id, format['[%1, "%2", (lbData [factory_enqueue_list_id, (lbCurSel factory_enqueue_list_id)]), ([(ctrlText factory_amount_field_id)] call parse_number)] call factory_item_create;', _player, _factory_id]];
	buttonSetAction [factory_dequeue_button_id, format['[%1, "%2", (lbData [factory_dequeue_list_id, (lbCurSel factory_dequeue_list_id)]), (lbCurSel factory_dequeue_list_id)] call factory_item_dequeue;', _player, _factory_id]]; 
};};

factory_hire_workers = {
	private["_player", "_factory_id", "_workers_count", "_workers_cost"];
	_player = _this select 0;
	_factory_id = _this select 1;
	_workers_count = _this select 2;
	_workers_cost = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith {};
	if (isNil "_workers_count") exitWith {};
	if (isNil "_workers_cost") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	if (typeName _workers_count != "SCALAR") exitWith {};
	if (typeName _workers_cost != "SCALAR") exitWith {};
	
	
	private["_factory", "_queue_name", "_factory_name"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {};
	
	_queue_name = _factory select factory_queue;
	_factory_name = _factory select factory_name;
	
	private["_workers_name", "_workers"];
	_workers_name = format["%1workers", _queue_name];
	_workers = missionNamespace getVariable _workers_name;
	
	private["_max"];
	_max = maxfacworkers;
	if (_workers >= _max) exitWith {
		player groupChat format["%1-%2, your %3 has already reached maximum of %4 workers", _player, (name _player), _factory_name, _max];
	};
	
	private["_money", "_total_cost"];
	_money = [_player, "money"] call INV_GetItemAmount;
	_total_cost = (_workers_count * _workers_cost);
	
	if (_money < _total_cost) exitWith {
		player groupChat format["%1-%2, you do not have enough money in your inventory to hire %3 workers for your %4", _player, (name _player), _workers_count, _factory_name];
	};
	
	[player, "money", -(_total_cost)] call INV_AddInventoryItem;
	
	_workers = _workers + _workers_count;
	player groupChat format["%1-%2, you have hired %3 workers for your %4", _player, (name _player), _workers_count, _factory_name];
	missionNamespace setVariable [_workers_name, _workers];
	[_workers_name, _workers] call stats_client_save;
	

	//adjust the ETA for the current item in queue
	private["_queue"];
	_queue = missionNamespace getVariable _queue_name;
	if (count _queue > 0) then {
		private["_eta", "_eta_name"];
		_eta_name = format["%1eta", _queue_name];
		_eta = missionNamespace getVariable _eta_name;
		_eta =  _eta - ((_eta / maxfacworkers) * _workers_count);
		_eta = _eta max 0;
		missionNamespace setVariable [_eta_name, _eta];
	};
};

factory_add_actions = {
	if (count factory_actions > 0) exitWith {};
	private["_player", "_factory_id"];
	_player = _this select 0;
	_factory_id = _this select 1;

	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	
	private["_factory"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory_id") exitWith {};
	
	private["_factory_id", "_factory_cost", "_factory_storage", "_factory_name"];
	_factory_name = _factory select factory_name;
	_factory_cost = _factory select factory_cost;
	_factory_storage = _factory select factory_storage;
	
	if (_factory_id  in INV_FabrikOwner) then {
		private["_action_id"];
		_action_id = player addaction ["Storage", "noscript.sqf", format['[%1, "%2"] call factory_storage_menu;', _player, _factory_storage]];
		factory_actions = factory_actions + [_action_id];
		
		_action_id = player addaction ["Manufacture", "noscript.sqf", format['[%1, "%2"] call factory_production_menu;', _player, _factory_id]];
		factory_actions = factory_actions + [_action_id];
		
		_action_id = player addaction [format["Hire one worker ($%1)", strM(facworkercost)], "noscript.sqf", format['[%1, "%2", %3, %4] call factory_hire_workers;', _player, _factory_id, 1, facworkercost]];
		factory_actions = factory_actions + [_action_id];
		
		_action_id = player addaction [format["Hire ten workers ($%1)", strM(10*facworkercost)], "noscript.sqf", format['[%1, "%2", %3, %4] call factory_hire_workers;', _player, _factory_id, 10, facworkercost]];
		factory_actions = factory_actions + [_action_id];
	}
	else {
		private["_action_id"];
		_action_id = player addaction [format["Buy %1 ($%2)", _factory_name, strM(_factory_cost)], "noscript.sqf", format['[%1, "%2"] call factory_buy;', _player, _factory_id]];
		factory_actions = factory_actions + [_action_id];
	};
};

factory_buy = {
	private["_player", "_factory_id"];
	_player = _this select 0;
	_factory_id = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_factory_id") exitWith {};
	if (typeName _factory_id != "STRING") exitWith {};
	
	private["_factory", "_factory_cost"];
	_factory = [_factory_id] call factory_lookup_id;
	if (isNil "_factory") exitWith {};
	_factory_cost = _factory select factory_cost;
	
	if (_factory_id in INV_Fabrikowner) exitWith {
		player groupChat format["%1-%2, you already own this factory", _player, (name _player)];
	};

	private["_money"];	
	_money = [_player, "money"] call INV_GetItemAmount;
	if (_money < _factory_cost) exitWith {
		player groupChat format["%1-%2, you do not have enough money in your inventory to buy this factory", _player, (name _player)];
	};
	
	[_player, "money", -(_factory_cost)] call INV_AddInventoryItem;
	INV_Fabrikowner = INV_Fabrikowner + [ _factory_id ];
	["INV_Fabrikowner", INV_Fabrikowner] spawn stats_client_save;
	
	
	player groupChat format["%1-%2, you bought this factory for $%3", _player, (name _player), strM(_factory_cost)];
	[_player] call factory_remove_actions;
};

factory_setup = {
	{
		private["_factory", "_factory_id"];
		_factory = _x;
		
		_factory_id = _factory select factory_id;
		[player, _factory_id] call factory_init;
		[_factory_id] spawn factory_loop;
	} forEach all_factories;
};

[] call factory_globals;
if (isClient) then {
	call factory_setup;
};

factory_functions_defined = true;