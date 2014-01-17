private["_mode"];
_mode = _this select 0;

if (_mode == "use") then {
	private["_item", "_amount", "_bounty", "_vehicle"];
	_item   = _this select 1;
	_amount = _this select 2;
	if (player == vehicle player)  exitWith {
		player groupChat localize "STRS_inv_items_ignite_ignite_notincar";
	};

	if ((damage vehicle player) == 1) exitWith {
		player groupChat localize "STRS_inv_items_repair_notneeded";
	};																							   
	
	_vehicle = vehicle player;
	
	if ( ((_vehicle distance (getmarkerpos "respawn_west")) < 100) ) exitwith { player groupChat "You are not allowed to use a lighter inside the cop base"; };
	if ( ((_vehicle distance (getmarkerpos "respawn_civilian")) < 130) ) exitwith { player groupChat "You are not allowed to use a lighter inside the civilian spawn"; };
	if ( ((_vehicle distance (getmarkerpos "respawn_east")) < 100) ) exitwith { player groupChat "You are not allowed to use a lighter inside the opfor spawn"; };
	if ( ((_vehicle distance (getmarkerpos "respawn_guerrila")) < 100) ) exitwith { player groupChat "You are not allowed to use a lighter inside the insurgent spawn"; };
	
	lighterUsed = [_vehicle, crew _vehicle, time];
	_vehicle setDamage 0.95;
	player groupchat localize "STRS_inv_items_ignite_ignite";
	[player, _item, -1] call INV_AddInventoryItem;
	
	// Set the player criminal IF someone else is around and may saw it
	if (([player, 40] call player_near_cops) || ([player, 40] call player_near_civilians)) then {
		// Get the price of the burned vehicle
		[player, "Setting a vehicle on fire", 20000, 50, false] call player_update_warrants;
	};
	
	
};