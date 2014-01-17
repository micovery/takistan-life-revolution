#include "Awesome\Functions\macro.h"

_this = _this select 3;

private["_number", "_action"];
_number = _this select 0;
_action = _this select 1;

if (_action == "add") then {
	private["_license", "_name", "_cost"];
	
	_license = ((INV_Licenses select _number) select 0);
	_name = ((INV_Licenses select _number) select 2);
	_cost = ((INV_Licenses select _number) select 3);
	
	if (_license call INV_HasLicense) exitWith {
		player groupChat localize "STRS_inv_buylicense_alreadytrue";
	};
	
	if (([player, 'money'] call INV_GetItemAmount) < _cost) exitWith {
		player groupChat localize "STRS_inv_buylicense_nomoney";
	};
	
	private["_exit", "_uid"];
	_exit = false;
	if((_license in pmc_shop_list)	) then {
		if ((iscop || isopf || isins)) then {
			_exit = true; 
			player groupchat "You cannot access PMC Licenses: Not a civilian";
		};

		if (not(_exit)) then {
			_uid = getPlayerUID player;
			if (A_WBL_V_ACTIVE_PMC_1 == 1) then {
				if (!(_uid in A_WBL_V_W_PMC_1)) then { 
					_exit = true; 
					player groupchat "You cannot access PMC Licenses: The police chief has not added you to the whitelist";
				};
			} else { if (A_WBL_V_ACTIVE_PMC_1 == 2) then {
				if ((_uid in A_WBL_V_B_PMC_1)) then {_exit = true; player groupchat "You cannot access PMC Licenses: The police chief has added you to the blacklist";};
			};};
		};
	};
	
	if (_exit && not(debug)) exitwith {};
	
	if(_license == "car" or _license == "truck")then{demerits = 10};
	[player, 'money', -(_cost)] call INV_AddInventoryItem;
	player groupChat format[localize "STRS_inv_buylicense_gottraining", strM(_cost), _name];

	[player, [_license]] call player_add_licenses;
}; 
	
if (_action == "remove") then {
	private["_name", "_license"];
	_license = ((INV_Licenses select _number) select 0);
	_name = ((INV_Licenses select _number) select 2);
	
	if (not(_license call INV_HasLicense)) exitWith {
		player groupChat localize "STRS_inv_buylicense_alreadyfalse";
	};
	
	[player, [_license]] call player_remove_licenses;
	
	player groupChat format[localize "STRS_inv_buylicense_losttraining", _name];
	
};
