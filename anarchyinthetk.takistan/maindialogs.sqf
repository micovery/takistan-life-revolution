#include "Awesome\Functions\macro.h"

disableSerialization;

private["_art"];

_array = _this select 3;
_art   = _array select 0;
_moneh  = [player, 'money'] call INV_GetItemAmount;
_zusatzString = "";

if ((count _array)>1) then {
	_zusatzString = _array select 1;
};

if (_art == "bail") then {
	if (!(createDialog "baildialog")) exitWith {hint "Dialog Error!";};
	sliderSetRange [2, 100, 250000];		sliderSetSpeed [2, 1, 50];

	while {(ctrlVisible 1008)} do {
		ctrlSetText [1, format["$%1", strM((round(sliderPosition 2)))]];
		sleep 0.3;
	};
};



if (_art == "spielerliste") then {

	if (!(createDialog "liste_1_button")) exitWith {hint "Dialog Error!";};
	_DFML = findDisplay -1;
	
	private["_dead_wait_time"];
	_dead_wait_time = [player] call player_dead_wait_time;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	private["_total_money", "_private_money", "_factory_money", "_cash"];
	_total_money = [player] call player_get_total_money;
	_private_money = [player] call player_get_private_storage_money;
	_factory_money = [player] call player_get_factory_money;
	_cash = [player, 'money'] call INV_GetItemAmount;
	_bank = [player] call bank_get_value;
	_trennlinie = "---------------------------------------------";
	(_DFML displayCtrl 1) 	lbAdd format ["Date:     %3.%2.%1", (date select 0), (date select 1), (date select 2)];
	(_DFML displayCtrl 1)	lbAdd format ["Runtime: %1 minutes", (round(time/60))];
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_playerinfo";
	(_DFML displayCtrl 1)	lbAdd format ["Total money: $%1", strM(_total_money)];
	(_DFML displayCtrl 1)	lbAdd format ["Money: $%2", localize "STRS_statdialog_health", strM(_cash)];
	(_DFML displayCtrl 1)	lbAdd format ["Savings: $%2", localize "STRS_statdialog_health", strM(_bank)];
	(_DFML displayCtrl 1)	lbAdd format ["Private storage: $%1", strM(_private_money)];
	(_DFML displayCtrl 1)	lbAdd format ["Factory storage: $%1", strM(_factory_money)];
//	lbAdd [1, format ["%1: %2",    localize "STRS_statdialog_hunger", round(INV_hunger)]];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2/%3", localize "STRS_statdialog_weight", (call INV_GetOwnWeight), INV_CarryingCapacity];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2",    localize "STRS_statdialog_copkills", ([player, "copskilled"] call player_get_scalar)];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2",    localize "STRS_statdialog_civkills", ([player, "civskilled"] call player_get_scalar)];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2",    "Arrests Made", ([player, "arrestsmade"] call player_get_scalar)];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2",    localize "STRS_statdialog_selfkills", ([player, "selfkilled"] call player_get_scalar)];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2",    localize "STRS_statdialog_deaths", ([player, "deadtime"] call player_get_scalar)];
	(_DFML displayCtrl 1)	lbAdd format ["%1: %2 seconds",    "Dead-Wait time", round(_dead_wait_time)];
	
	if ( isciv ) then { (_DFML displayCtrl 1) lbAdd format ["%1: %2",    "Demerit points", demerits]};

	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_licenselist";
	
	private["_i"];
	
	for [{_i=0}, {_i < (count INV_Licenses)}, {_i=_i+1}] do {
		if (((INV_Licenses select _i) select 0) call INV_HasLicense) then
		{
			(_DFML displayCtrl 1)	lbAdd (((INV_Licenses select _i) select 2));
		};
	};
	
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd "F A C T O R I E S:";
	
	for [{_i=0}, {_i < (count all_factories)}, {_i=_i+1}] do {
		if (((all_factories select _i) select 1) in INV_Fabrikowner) then
		{

		_workers = call compile format["%1workers", ((all_factories select _i) select 8)];
		(_DFML displayCtrl 1)	lbAdd format['%1: %2 workers', ((all_factories select _i) select 2), _workers];
		};
	};
	
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_regierung";
	
	if (not(MayorNumber == -1)) then {
		(_DFML displayCtrl 1)	lbAdd (playerstringarray select MayorNumber);
	};
	
	_next_president_election = server getVariable "next_president_election";
	if (not(isnil "_next_president_election")) then { if (typeName _next_president_election == "SCALAR") then { if (_next_president_election > 0) then {
		private ["_s"];
		_s = "";
		if (_next_president_election > 1) then { _s = "s";};
		
		(_DFML displayCtrl 1)	lbAdd format["Next election results in %1 minute%2", _next_president_election, _s]; 
	};};}; 
	
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_chief";
	
	if (not(chiefNumber == -1)) then {
		(_DFML displayCtrl 1)	lbAdd (playerstringarray select chiefNumber);
	};
	
	_next_chief_election = server getVariable "next_chief_election";
	if (not(isnil "_next_chief_election")) then { if (typeName _next_chief_election == "SCALAR") then { if (_next_chief_election > 0) then {
		private ["_s"];
		_s = "";
		if (_next_chief_election > 1) then { _s = "s";};
		
		(_DFML displayCtrl 1)	lbAdd format["Next election results in %1 minute%2", _next_chief_election, _s]; 
	};};}; 


	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd "G A N G S: ";
	private["_gangs_list"];
	_gangs_list = call gangs_get_list;
	
	{if (true) then {
		private["_gang"];
		_gang = _x;
		private["_gang_name"];
		_gang_name = _gang select gang_name;
		
		private["_member_uids", "_member_names"];
		_member_uids = _gang select gang_members;
		_member_names = [_member_uids] call gangs_uids_2_names;
		
		if (count(_member_names) == 0) exitWith {};
		private["_leader_name"];
		_leader_name = _member_names select 0;
		
		(_DFML displayCtrl 1) lbAdd format["%1 (%2)", _gang_name, _leader_name];
		
		private["_i"];
		_i = 1; //(starting at 1 because 0 is the leader)
		while {_i < (count _member_names) } do {
			private["_member_name"];
			_member_name = _member_names select _i;
			(_DFML displayCtrl 1) lbAdd format["    %1. %2", _i, _member_name];
			_i = _i + 1;
		};
	};} forEach _gangs_list;
	
	
	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd "G A N G - A R E A S: ";
	{ if (true) then {
		private["_gang_area"];
		_gang_area = _x;
		
		private["_gang_area_name"];
		_gang_area_name = str(_gang_area);
		
		if ([_gang_area] call gang_area_neutral) then {
			(_DFML displayCtrl 1) lbAdd format["    %1 - (Neutral)", _gang_area_name];
		}
		else {
			private["_gang_id"];
			_gang_id = [_gang_area] call gang_area_get_control;
			//player groupChat format["_gang_id = %1", _gang_id];
			
			private["_gang"];
			_gang = [_gang_id] call gangs_lookup_id;
			//player groupChat format["_gang = %1", _gang];
			
//			if (isNil "_gang") then {
			if ((typename _gang) != "ARRAY") then {
				(_DFML displayCtrl 1) lbAdd format["    %1 - (Abandoned)", _gang_area_name];
			}
			else {
				private["_gang_name"];
				_gang_name = _gang select gang_name;
				(_DFML displayCtrl 1) lbAdd format["    %1 - (%2)", _gang_area_name, _gang_name];
			};
		};
	};} forEach gangareas;
	
	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd "B A N K:";
//	(_DFML displayCtrl 1) lbAdd (format ["Est. total funds in the main bank safe's: $%1", strM(robpoolsafe1 + robpoolsafe2 + robpoolsafe3)]);

	if(!local_useBankPossible)then{(_DFML displayCtrl 1) lbAdd (format ["Bank lockout time remaining: %1 seconds.", round rblock])};

	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd (format ["W O R K P L A C E S"]);
	
	for [{_i=0}, {_i < (count BuyAbleBuildingsArray)}, {_i=_i+1}] do {
		if ( ((BuyAbleBuildingsArray select _i) select 0) in BuildingsOwnerArray ) then {
			(_DFML displayCtrl 1)	lbAdd (format ["%1", ((BuyAbleBuildingsArray select _i) select 1)]);
		};
	};
		
	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd localize "STRS_statdialog_laws";
	
	_i = 0;
	{
		if (not(_x == "")) then {
			_i = _i + 1;
			(_DFML displayCtrl 1)	lbAdd (format ["%1: %2", _i, _x]);
		};
	} forEach LawsArray;
	
	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd localize "STRS_statdialog_taxes";
	
	{
		if ((_x select 2) > 0) then {
			(_DFML displayCtrl 1) lbAdd format["%1: %2", (_x select 1), (_x select 2)];
		};
	} foreach INV_ItemTypeArray;
	(_DFML displayCtrl 1) lbAdd format["Transfer: %1", bank_tax];

	(_DFML displayCtrl 1) lbAdd _trennlinie;
	(_DFML displayCtrl 1) lbAdd "F O O D  S T O C K S:";

	_stock = ["boar", (shop1 call INV_getshopnum)] call INV_GetStock;
	_stock = _stock + (["boar", (shop2 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["boar", (shop3 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["boar", (shop4 call INV_GetShopNum)] call INV_GetStock);

	(_DFML displayCtrl 1)	lbAdd format["boar meat: %1", _stock];

	_stock = ["perch", (shop1 call INV_getshopnum)] call INV_GetStock;
	_stock = _stock + (["perch", (shop2 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["perch", (shop3 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["perch", (shop4 call INV_GetShopNum)] call INV_GetStock);

	(_DFML displayCtrl 1)	lbAdd format["perch: %1", _stock];

	_stock = ["walleye", (shop1 call INV_GetShopNum)] call INV_GetStock;
	_stock = _stock + (["walleye", (shop2 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["walleye", (shop3 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["walleye", (shop4 call INV_GetShopNum)] call INV_GetStock);

	(_DFML displayCtrl 1)	lbAdd format["walleye: %1", _stock];

	_stock = ["trout", (shop1 call INV_GetShopNum)] call INV_GetStock;
	_stock = _stock + (["trout", (shop2 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["trout", (shop3 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["trout", (shop4 call INV_GetShopNum)] call INV_GetStock);

	(_DFML displayCtrl 1)	lbAdd format["trout: %1", _stock];

	_stock = ["bass", (shop1 call INV_GetShopNum)] call INV_GetStock;
	_stock = _stock + (["bass", (shop2 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["bass", (shop3 call INV_GetShopNum)] call INV_GetStock);
	_stock = _stock + (["bass", (shop4 call INV_GetShopNum)] call INV_GetStock);

	(_DFML displayCtrl 1)	lbAdd format["bass: %1", _stock];

	(_DFML displayCtrl 1)	lbAdd _trennlinie;

	//lbAdd [1, "C R O P   S T R E N G T H:"];

	//_stock = ["Bread", (shop1 call INV_GetShopNum)] call INV_GetStock;
	//_stock = _stock + (["Bread", (shop2 call INV_GetShopNum)] call INV_GetStock);
	//_stock = _stock + (["Bread", (shop3 call INV_GetShopNum)] call INV_GetStock);
	//_stock = _stock + (["Bread", (shop4 call INV_GetShopNum)] call INV_GetStock);

	//lbAdd [1, format["Wheat: %1", 100 - (_stock/400)*100]];

	//lbAdd [1, _trennlinie];
	


	(_DFML displayCtrl 1)	lbAdd format["Oil demand: %1 barrel/s", strN(call shop_get_oil_barrel_demand)];
	(_DFML displayCtrl 1)	lbAdd format["Fuel price: $%1 per liter", (call shop_get_fuel_price)];
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_playerlist";

	private ["_i"];
	_i = 0;
	_player_variable_name = "";
	while { _i < (count playerstringarray) } do {
		private["_player", "_player_variable_name"];
		_player_variable_name = playerstringarray select _i;
		_player = missionNamespace getVariable [_player_variable_name, objNull];
		
		if ([_player] call player_human) then {
			private["_label_text", "_index"];
			_label_text =  format ["%1: %2", _player, (name _player)];
			_index = (_DFML displayCtrl 1) lbAdd _label_text;
			private["_wanted"];
			if (not([_player] call player_cop) && ([_player] call player_get_bounty) > 0) then {
				(_DFML displayCtrl 1) lbSetColor [_index, [1, 0, 0, 1]];
			};
		};
		_i = _i + 1;
	};
	
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd "W A N T E D:";
	
	private["_i"];
	_i = 0;
	
	_player_variable_name = "";
	_player_variable = objNull;
	
	while { _i < (count playerstringarray) } do {
		private["_player_variable_name", "_player_variable"];
		_player_variable_name = playerstringarray select _i;
		_player_variable = missionNamespace getVariable [_player_variable_name, objNull];
		
		if !(isNull _player_variable) then {
		if (not([_player_variable] call player_cop) && ([_player_variable] call player_get_wanted)) then {
			private["_bounty", "_reasons"];
			_reasons = [_player_variable] call player_get_reason; 
			_bounty = [_player_variable] call player_get_bounty;
			
			(_DFML displayCtrl 1) lbAdd (format ["%1 (Bounty: %3): %2 is wanted for %4 crime/s:", _player_variable, (name _player_variable), _bounty, (count _reasons)]);
			private["_j", "_count"];
			_j = 0;
			while { _j < (count _reasons) } do {
				private["_reason"];
				_reason = _reasons select _j;
				(_DFML displayCtrl 1) lbAdd (format ["    %1. %2", (_j + 1), _reason]); 
				_j = _j + 1;
			};
			(_DFML displayCtrl 1) lbAdd _trennlinie;
		};
		};
		
		_i = _i + 1;
	};

	//HotFix by HarryWorner 03.April.2012
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
};

if (_art == "inventorycheck") then {
	if (!(createDialog "liste_1_button")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	_licensearray  = (_array select 1);
	_inventararray = (_array select 2);
	_civobj        = (_array select 3);
	_waffenarray   = weapons _civobj - nonlethalweapons;
	_magazinarray  = magazines _civobj;
	_trennlinie = "---------------------------------------------";
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_licenselist";
	private "_i"; //// ADD to fix bug
	for [{_i=0}, {_i < (count _licensearray)}, {_i=_i+1}] do
	{
		_lizenz = (_licensearray select _i);
		(_DFML displayCtrl 1)	lbAdd format ["%1", (_lizenz call INV_GetLicenseName)];
	};
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_inventarlist";
	for [{_i=0}, {_i < (count _inventararray)}, {_i=_i+1}] do
	{
		_objekt     = ((_inventararray select _i) select 0);
		_objektname = (_objekt call INV_GetItemName);
		_anzahl     = [((_inventararray select _i) select 1)] call decode_number;
		if (_anzahl > 0) then
		{
			(_DFML displayCtrl 1)	lbAdd format ["%1: %2", _objektname, _anzahl];
		};
	};

	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	(_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_waffen";
	
	for [{_i=0}, {_i < (count _waffenarray)}, {_i=_i+1}] do
	{
		_objekt     = _waffenarray select _i;
		_scriptname = _objekt call INV_GetScriptFromClass_Weap;
		_objektname = (_scriptname call INV_GetItemName);
		(_DFML displayCtrl 1)	lbAdd format ["%1", _objektname];
	};
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	_index = (_DFML displayCtrl 1)	lbAdd localize "STRS_statdialog_magazine";
	for [{_i=0}, {_i < (count _magazinarray)}, {_i=_i+1}] do
	{
		_objekt     = _magazinarray select _i;
		_scriptname = _objekt call INV_GetScriptFromClass_Mag;
		_objektname = (_scriptname call INV_GetItemName);
		(_DFML displayCtrl 1)	lbAdd format ["%1", _objektname];
	};
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
};

if (_art == "inventorysteal") then {

};

if (_art == "gesetz") then {
	if (!(createDialog "gesetzdialog")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
		
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	{
		_index = (_DFML displayCtrl 1)	lbAdd _x;
		(_DFML displayCtrl 1)	lbSetData [_index, _x];
	}
	forEach LawsArray;
	
	while {ctrlVisible 1020} do {
		_selected = lbCurSel 1;
		ctrlSetText [2, lbText [1, _selected]];
		waitUntil {((not(_selected == lbCurSel 1)) or (not(ctrlVisible 1020)))};
	};
};

if (_art == "coplog") then {
	if (!(createDialog "liste_1_button")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);

	_trennlinie = "---------------------------------------------";
	(_DFML displayCtrl 1)	lbAdd _trennlinie;

	private ["_i"];
	(_DFML displayCtrl 1)	lbAdd "C U R R E N T  W A R R A N T S:";
	(_DFML displayCtrl 1)	lbAdd _trennlinie;
	_i = 0;
	while { _i < (count playerstringarray) } do {
		private["_player_variable_name", "_player_variable"];
		_player_variable_name = playerstringarray select _i;
		_player_variable = missionNamespace getVariable _player_variable_name;
		
		if (not([_player_variable] call player_cop) && ([_player_variable] call player_get_wanted)) then {
			private["_bounty", "_reasons"];
			_reasons = [_player_variable] call player_get_reason; 
			_bounty = [_player_variable] call player_get_bounty;
			
			(_DFML displayCtrl 1) lbAdd (format ["%1 (Bounty: %3): %2 is wanted for %4 crime/s:", _player_variable, (name _player_variable), _bounty, (count _reasons)]);
			private["_j"];
			_j = 0;
			while { _j < (count _reasons) } do {
				private["_reason"];
				_reason = _reasons select _j;
				(_DFML displayCtrl 1) lbAdd (format ["    %1. %2", (_j + 1), _reason]); 
				_j = _j + 1;
			};
			(_DFML displayCtrl 1) lbAdd _trennlinie;
		};
		_i = _i + 1;
	};
};

if (_art == "wahlen") then {
	if (!(createDialog "wahldialog")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	private["_index"];
	_index = [1] call DialogNotCopsList;
	(_DFML displayCtrl 1) lbSetCurSel _index;
};

if (_art == "chief") then {
	if (!(createDialog "chiefdialog")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	private["_c", "_index"];
	_c = 0;
	_player_variable_name = "";
	_index = -1;

	for [{_c=0}, {_c < (count playerstringarray)}, {_c=_c+1}] do {
		private["_player_variable_name", "_player_variable"];
		_player_variable_name = playerstringarray select _c;
		_player_variable = missionNamespace getVariable _player_variable_name;
	
		if (([_player_variable] call player_exists)) then {
			private["_player_cop"];
			_player_cop = [_player_variable] call player_cop;
			if (not(_player_cop)) exitWith {};
			
			private["_player_name"];
			_player_name = (name _player_variable);
			_index = lbAdd [1, format ["%1 - (%2)", _player_variable_name, _player_name]];
			lbSetData [1, _index, format["%1", _c]];
		};
	};
};

if (_art == "steuern") then {
	if (!(createDialog "steuerdialog")) exitWith {hint "Dialog Error!";};
	
	_DFML = findDisplay -1;
	
	lbClear 1;
	lbClear (_DFML displayCtrl 1);
	
	sliderSetSpeed [12, 1, 5];
	sliderSetRange [12, 1, 25];
	sliderSetPosition [12,((INV_ItemTypeArray select 0) select 2)];
	sliderSetSpeed [22, 1, 5];		
	sliderSetRange [22, 1, 30];
	sliderSetPosition [22,((INV_ItemTypeArray select 1) select 2)];
	sliderSetSpeed [32, 1, 5];				
	sliderSetRange [32, 1, 25];
	sliderSetPosition [32,((INV_ItemTypeArray select 2) select 2)];
	sliderSetSpeed [42, 1, 5];
	sliderSetRange [42, 1, 25];
	sliderSetPosition [42,((INV_ItemTypeArray select 3) select 2)];
	sliderSetSpeed [52, 1, 5];
	sliderSetRange [52, 1, 25];
	sliderSetPosition [52,bank_tax];
	while {ctrlVisible 1032} do {
		ctrlSetText [11, format[localize "STRS_dialogandere_steuerdialog_itemsteuer", strN((round(sliderPosition 12)))]];
		ctrlSetText [21, format[localize "STRS_dialogandere_steuerdialog_fahrzeugsteuer", strN((round(sliderPosition 22)))]];
		ctrlSetText [31, format[localize "STRS_dialogandere_steuerdialog_magazinsteuer", strN((round(sliderPosition 32)))]];
		ctrlSetText [41, format[localize "STRS_dialogandere_steuerdialog_waffesteuer", strN((round(sliderPosition 42)))]];
		ctrlSetText [51, format[localize "STRS_dialogandere_steuerdialog_banksteuer", strN((round(sliderPosition 52)))]];
		sleep 0.1;
	};
};

if (_art == "copmenu") then {
	if (!(createDialog "CopMenu")) exitWith {hint "Dialog Error!"};
};

if (_art == "copmenulite") then {
	if (!(createDialog "CopMenuLite")) exitWith {hint "Dialog Error!"};
};

if (_art == "distribute") then {
	if (!(createDialog "distribute")) exitWith {hint "Dialog Error!"};
};

if (_art == "pmc_whitelist") then {
	if (not(ischief)) exitWith { player groupChat "Cannot access PMC whitelist: You are not the police chief";};
	["PMC_1"] spawn A_WBL_F_DIALOG_INIT;
};
