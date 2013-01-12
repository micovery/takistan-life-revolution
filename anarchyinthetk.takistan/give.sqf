#include "Awesome\Functions\macro.h"

private["_action", "_item", "_quantity", "_item_name"];
_action = _this select 0;
_item = _this select 1;
_quantity  = _this select 2;
_item_name = (_item call INV_GetItemName);

if ( primaryweapon player == "" and secondaryweapon player == "") then {
	player playmove "AmovPercMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon";
}
else {
	player playmove "AinvPknlMstpSlayWrflDnon";
};


if (_action == "uebergabe") then {
	private["_player_number", "_player_variable_name", "_player_variable"];
	
	_player_number   = call compile (_this select 3);
	_player_variable_name = playerstringarray select _player_number;
	_player_variable =  missionNamespace getVariable _player_variable_name;
	
	if (not([_player_variable] call player_exists)) exitWith {
		player groupChat localize "STRS_inv_not_ingame";
	};

	if (_player_variable == player) exitWith {
		player groupChat localize "STRS_inv_inventar_uebergabe_self";
	};
	
	private["_near_players"];
	_near_players = nearestobjects [getpos player, ["LandVehicle", "Air", "Man"], 20];

	if (not(_player_variable in _near_players) and (player distance _player_variable > 20)) exitWith {
		player groupChat localize "STRS_inv_inventar_uebergabe_distance";
	};

	if (!(_item call INV_GetItemGiveable)) exitWith {
		player groupChat localize "STRS_inv_inventar_uebergabe_verbot";
	};
	
	if (!([player, _item, -(_quantity)] call INV_AddInventoryItem)) exitWith {
		player groupChat localize "STRS_inv_inventar_uebergabe_zuwenig";
	};

	format ["if (player == %1) then {[""bekommen"", ""%2"", %3, %4] execVM ""give.sqf"";};", _player_variable, _item, _quantity, player] call broadcast;
	player groupChat format [localize "STRS_inv_inventar_uebergabe_success_self", name _player_variable, strN(_quantity), _item_name];
};

if (_action == "bekommen") then {
	private["_player"];
	_player = _this select 3;
	if ([player, _item, _quantity] call INV_AddInventoryItem) then {
		player groupChat format[localize "STRS_inv_inventar_gotfromotherplayer", strN(_quantity), _item_name, name _player];
	}
	else {
		format ["if (player == %1) then {[player, ""%2"", %3] call INV_AddInventoryItem;};", _player, _item, _quantity] call broadcast;
	};
};
