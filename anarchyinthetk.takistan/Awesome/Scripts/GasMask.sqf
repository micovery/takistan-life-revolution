//gasmask

player groupchat "gas mask running";

_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

_mask = player getvariable "gasmask";

if ( (typeName _mask) != "BOOL" ) then {
	player setvariable ["gasmask", false, true];
	_mask = player getvariable "gasmask";
};

if (isNil "_mask") then {
	player setvariable ["gasmask", false, true];
	_mask = player getvariable "gasmask";
};
	
_work = false;

switch _mask do {
	case true: {
		player setvariable ["gasmask", false, true];
		player groupchat "You took off your gasmask and it has been added to your inventory";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "gasmask", 1] call INV_AddInventoryItem;
		_work = true;
	};
		
	case false:{
		player setvariable ["gasmask", true, true];
		player groupchat "You put on a gask mask, you will now be protected from tear gas";
		[player, _item, -1] call INV_AddInventoryItem;
		[player, "gasmask_on", 1] call INV_AddInventoryItem;
		_work = true;
	};
};

if (!_work) then {
	player setvariable ["gasmask", true, true];
	player groupchat "You put on a gask mask, you will now be protected from tear gas";
	[player, _item, -1] call INV_AddInventoryItem;
	[player, "gasmask_on", 1] call INV_AddInventoryItem;
};


