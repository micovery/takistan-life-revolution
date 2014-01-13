if (not(isNil "respawn_functions_defined")) exitWith {};


//	["player_rejoin_camera_complete"] call player_wait;
//	[player] call interact_stranded_check;

private["_handler"]; 
_handler = ["player_rejoin_camera_complete"] spawn player_wait;
waitUntil{scriptDone _handler};
 
_handler = [player] spawn interact_stranded_check;
waitUntil{scriptDone _handler};

[player, true] spawn player_spawn;


respawn_functions_defined = true;