private["_art"];
_art = _this select 0;

if (_art == "use") then {
	private["_item","_vcl","_type"];
	_item   = _this select 1;
	_vcl  	= vehicle player;
	_type	= typeof _vcl;

	if((_vcl getvariable ["nitro", 0]) == 1)exitwith{player groupchat "this vehicle already has nitro installed"};
	if (player == _vcl) exitWith {player groupChat localize "STRS_inv_items_speed_car"};
	if (!(_vcl iskindof "Car")) exitWith {player groupChat localize "STRS_inv_items_speed_no";};
	
	if (
		(({_vcl isKindOf _x} count ["BRDM2_Base","BTR90_Base","LAV25_Base","HMMWV_M1151_M2_DES_Base_EP1","StrykerBase_EP1"]) > 0) ||
		(({_vcl isKindOf _x} count ["ArmoredSUV_Base_PMC"]) > 0) ||
		false
	) exitwith {player groupchat "you cannot tune this vehicle"};
		
	[player, _item, -1] call INV_AddInventoryItem;

	player groupchat "tuning vehicle...";
	_vcl setfuel 0;
	sleep 10;
	_vcl setfuel 1;
	[_vcl, "nitro", 1] call vehicle_set_scalar;
	player groupchat "vehicle tuned!";
	sleep 2;
	player groupchat "press and hold shift to activate nitro";
};



