#include "Awesome\Functions\macro.h"

_this    = _this select 3;
_number  = _this select 0;
_art     = _this select 1;

if ((_art == "remove") or (_art == "add")) then

{

if (_art == "add") then

	{

	_license = ((INV_Licenses select _number) select 0);
	_name    = ((INV_Licenses select _number) select 2);
	_cost    = ((INV_Licenses select _number) select 3);
	
	if (_license call INV_HasLicense) exitWith {player groupChat localize "STRS_inv_buylicense_alreadytrue";};
	if (([player, 'money'] call INV_GetItemAmount) < _cost) exitWith {player groupChat localize "STRS_inv_buylicense_nomoney";};
	
	_exit = false;
	if(		(_license in pmc_shop_list)	) then {
					
			if (	(iscop || isopf || isins)	) then {_exit = true; player groupchat "You cannot access PMC Licenses: Not a civilian";};
							
			if (!_exit) then {
					_uid = getPlayerUID player;
												
					if (A_WBL_V_ACTIVE_PMC_1 == 1) then {
						if (!(_uid in A_WBL_V_W_PMC_1)) then { 
							_exit = true; player groupchat "You cannot access PMC Licenses: The police chief has not added you to the whitelist";};
						} else {
						if (A_WBL_V_ACTIVE_PMC_1 == 2) then {
									if ((_uid in A_WBL_V_B_PMC_1)) then {_exit = true; player groupchat "You cannot access PMC Licenses: The police chief has added you to the blacklist";};
								};
						};
				};
		};
	if (_exit && !debug) exitwith {};
	
	if(_license == "car" or _license == "truck")then{demerits = 10};
	[player, 'money', -(_cost)] call INV_AddInventoryItem;
	player groupChat format[localize "STRS_inv_buylicense_gottraining", strM(_cost), _name];

	
	INV_LicenseOwner = INV_LicenseOwner + [_license];
	["INV_LicenseOwner", INV_LicenseOwner] spawn stats_client_save;

	} else {

	_license = ((INV_Licenses select _number) select 0);
	name    = ((INV_Licenses select _number) select 2);
	if (not(_license call INV_HasLicense)) exitWith {player groupChat localize "STRS_inv_buylicense_alreadyfalse";};
	INV_LicenseOwner = INV_LicenseOwner - [_license];
	player groupChat format[localize "STRS_inv_buylicense_losttraining", _name];
	["INV_LicenseOwner", INV_LicenseOwner] spawn stats_client_save;

	};

};