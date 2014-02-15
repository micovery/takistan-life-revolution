private["_action","_item","_amount","_mask"];
_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

switch (_mask) do {
	case true: {
		player setVariable ["gasmask", false, true];
		player groupchat "You took off your gasmask and it has been added to your inventory";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "gasmask", 1] call INV_AddInventoryItem;		
	};
		
	case false:{
		player setVariable ["gasmask", true, true];
		player groupchat "You put on a gask mask, you will now be protected from tear gas";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "gasmask_on", 1] call INV_AddInventoryItem;		
	};
};





