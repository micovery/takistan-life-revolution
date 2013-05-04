//Usefood

private["_action", "_item", "_amount", "_invamount", "_item_type"];

_action = _this select 0;

if (_action != "use") exitWith {};

_item = _this select 1;
_amount = _this select 2;
_invamount = [player, _item] call INV_GetItemAmount;
_item_type = _item call INV_GetItemKindOf;

//Checking here, not that much calls involved
if (_amount > _invamount) exitWith {
	player groupChat "You don't have that much"
};

switch _item_type do {
	case "food": {[_item, _amount] call tlr_life_eat;};
	case "drink": {[_item, _amount] call tlr_life_drink;};
};

//Remove items
[player, _item, -(_amount)] call INV_AddInventoryItem;
