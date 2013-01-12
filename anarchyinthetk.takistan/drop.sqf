liafu = true;

_item   = _this select 0;
_amount = _this select 1;


if ((!INV_CanUseInventory) or (!INV_CanDropItem)) exitWith {
	player groupChat localize "STRS_inv_inventar_cannotdrop";
};

if(!isnull (nearestobjects[getpos player, droppableitems, 1] select 0)) exitWith {
	player groupchat "You cannot drop items on top of each other. move and try again."
};

if (_amount <= 0) exitwith {
	format["hint ""%1 has dropped %2!"";", (name player), _amount] call broadcast;
};

if (_item call INV_GetItemDropable) then {
	if ([player, _item, -(_amount)] call INV_AddInventoryItem) then {
		player groupChat localize "STRS_inv_inventar_weggeworfen";
		if(primaryweapon player == "" and secondaryweapon player == "")then{player playmove "AmovPercMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon"}else{player playmove "AinvPknlMstpSlayWrflDnon"};
		sleep 1.5;
		private "_class";
		_class = [_item] call item2class;
		
		_pos = getPosATL player;
		_object = createVehicle [_class, _pos, [], 0, "NONE"];
		liafu = true;
		_object setposASL getposASL player;
		_object setvariable ["droparray", [([_amount] call encode_number), _item], true];
	}
	else {
		player groupChat localize "STRS_inv_inventar_drop_zuwenig";
	};
}
else {
	player groupChat localize "STRS_inv_inventar_ablege_verbot";
};

