private["_art","_item","_anzahl"];
_art = _this select 0;
if (_art == "use") then {
	_item = _this select 1;
	_anzahl = _this select 2;
    if (player == vehicle player)  exitWith {
		player groupChat localize "STRS_inv_items_repair_refuel_notincar";
	};

	if (!(player == driver vehicle player)) exitWith {
		player groupChat localize "STRS_inv_items_repair_refuel_notdriver";
	};

	if ((fuel vehicle player) == 1)  exitWith {
		player groupChat localize "STRS_inv_items_refuel_notneeded";
	};

	player groupchat "Refueling Vehicle!";
	sleep 15;
	vehicle player setFuel 1;
	player groupChat localize "STRS_inv_items_refuel_refueled";
	[player, _item, -1] call INV_AddInventoryItem;
};

