#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};
private["_art","_item","_anzahl","_vehicle"];
_art = _this select 0;
if (_art == "use") then {
	_item = _this select 1;
	_anzahl = _this select 2;
	
	_vehicle = vehicle player;
	
    if (player == _vehicle)  exitWith {
		player groupChat localize "STRS_inv_items_repair_refuel_notincar";
	};

	if !(player == (driver _vehicle)) exitWith {
		player groupChat localize "STRS_inv_items_repair_refuel_notdriver";
	};

	if ((fuel _vehicle) == 1)  exitWith {
		player groupChat localize "STRS_inv_items_refuel_notneeded";
	};

	player groupchat "Refueling Vehicle!";
	SleepWait(30)
	_vehicle setFuel 1;
	player groupChat localize "STRS_inv_items_refuel_refueled";
	[player, _item, -1] call INV_AddInventoryItem;
};

