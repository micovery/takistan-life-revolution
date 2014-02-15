private["_mode"];
_mode = _this select 0;

if (_mode == "use") then {
	private["_item", "_amount", "_bounty", "_vehicle"];
	_item   = _this select 1;
	_amount = _this select 2;
	
	player groupChat "Lighters have been disabled";
	
	[player, _item, -1] call INV_AddInventoryItem;
};