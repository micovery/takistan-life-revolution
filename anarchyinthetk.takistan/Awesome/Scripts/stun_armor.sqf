//stun_armor

private["_action", "_item", "_amount"];
_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

switch _item do {
	case "stun_light": {
		if (([player, "stun_full_on"] call INV_GetItemAmount > 0) || ([player, "stun_light_on"] call INV_GetItemAmount > 0)) exitwith {player groupChat "You already have stun armor on";};
		player setvariable ["stun_armor", "light", true];
		player groupchat "You put on light stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_light_on", 1] call INV_AddInventoryItem;
	};

	case "stun_light_ter": {
		if (([player, "stun_full_on"] call INV_GetItemAmount > 0) || ([player, "stun_light_on"] call INV_GetItemAmount > 0)) exitwith {player groupChat "You already have stun armor on";};
		player setvariable ["stun_armor", "light", true];
		player groupchat "You put on light stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_light_on", 1] call INV_AddInventoryItem;
	};

	case "stun_light_ill": {
		if (([player, "stun_full_on"] call INV_GetItemAmount > 0) || ([player, "stun_light_on"] call INV_GetItemAmount > 0)) exitwith {player groupChat "You already have stun armor on";};
		player setvariable ["stun_armor", "light", true];
		player groupchat "You put on light stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_light_on", 1] call INV_AddInventoryItem;
	};
	
	case "stun_full": {
		if (([player, "stun_full_on"] call INV_GetItemAmount > 0) || ([player, "stun_light_on"] call INV_GetItemAmount > 0)) exitwith {player groupChat "You already have stun armor on";};
		player setvariable ["stun_armor", "full", true];
		player groupchat "You put on Full stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_full_on", 1] call INV_AddInventoryItem;
	};
	
	case "stun_light_on":{
		player setvariable ["stun_armor", "", true];
		player groupchat "You took off your light stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_light", 1] call INV_AddInventoryItem;
	};
	case "stun_full_on": {
		player setvariable ["stun_armor", "", true];
		player groupchat "You took off your Full stun Armor";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "stun_full", 1] call INV_AddInventoryItem;
	};
};