_art = _this select 0;

if (_art == "use") then {
	_item   = _this select 1;
	[player, _item, -1] call INV_AddInventoryItem;
	call vehicle_lockpick;
};
