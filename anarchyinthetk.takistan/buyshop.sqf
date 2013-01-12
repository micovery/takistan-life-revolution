#include "Awesome\Functions\macro.h"

_this = _this select 3;
_art   = (_this select 0);
_num   = (_this select 1);
_moneh  = [player, 'money'] call INV_GetItemAmount;

if (_art == "property") then {
	_cost = ((BuyAbleBuildingsArray select _num) select 3);
	_name = ((BuyAbleBuildingsArray select _num) select 0);

	if (_name in BuildingsOwnerArray) exitWith {player groupChat localize "STRS_alreadygotshop";};
	if (_moneh < _cost)                exitWith {player groupChat localize "STRS_no_money";};
	[player, 'money', -(_cost)] call INV_AddInventoryItem;
	player groupChat format[localize "STRS_gotshop", rolestring, strM(_cost)];
	BuildingsOwnerArray = BuildingsOwnerArray + [_name];
	["BuildingsOwnerArray", BuildingsOwnerArray] spawn stats_client_save;
};

