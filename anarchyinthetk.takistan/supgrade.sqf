private["_art","_item","_vcl","_type"];
_art 	= _this select 0;
_item 	= _this select 1;
_vcl	= vehicle player;
_type	= typeof _vcl;

if(_art == "use")then {

if(_vcl == player)exitwith{player groupchat "you must be in a vehicle"};
if(!(_vcl iskindof "car"))exitwith{player groupchat "you cannot tune this vehicle"};

if (
		(({_vcl isKindOf _x} count ["BRDM2_Base","HMMWV_M1151_M2_DES_Base_EP1","StrykerBase_EP1"]) > 0)
	) exitwith {player groupchat "you cannot tune this vehicle"};
	
private["_exit"];
_item = toLower(_item);
_exit = false;

if (_item in ["supgrade4","supgrade5"]) then {
	if (
		(({_vcl isKindOf _x} count ["ArmoredSUV_Base_PMC"]) > 0)
	) then {
		player groupchat "This tune cannot be used on this vehicle";
		_exit = true;
	};
};

if _exit exitwith {};

			

[player, _item, -1] call INV_AddInventoryItem;

if(_item == "supgrade1")then{player groupchat "tuning vehicle..."; _vcl setfuel 0; sleep 6; _vcl setfuel 1; [_vcl, "tuning", 1] call vehicle_set_scalar; player groupchat "vehicle tuned!";};
if(_item == "supgrade2")then{player groupchat "tuning vehicle..."; _vcl setfuel 0; sleep 7; _vcl setfuel 1; [_vcl, "tuning", 2] call vehicle_set_scalar; player groupchat "vehicle tuned!";};
if(_item == "supgrade3")then{player groupchat "tuning vehicle..."; _vcl setfuel 0; sleep 8; _vcl setfuel 1; [_vcl, "tuning", 3] call vehicle_set_scalar; player groupchat "vehicle tuned!";};
if(_item == "supgrade4")then{player groupchat "tuning vehicle..."; _vcl setfuel 0; sleep 9; _vcl setfuel 1; [_vcl, "tuning", 4] call vehicle_set_scalar; player groupchat "vehicle tuned!";};
if(_item == "supgrade5")then{player groupchat "tuning vehicle..."; _vcl setfuel 0; sleep 10; _vcl setfuel 1; [_vcl, "tuning", 5] call vehicle_set_scalar; player groupchat "vehicle tuned!";};

};