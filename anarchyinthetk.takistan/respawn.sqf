if (not(isNil "respawn_functions_defined")) exitWith {};
["player_rejoin_camera_complete"] call player_wait;;
[player] call interact_stranded_check;
[player, true] call player_spawn;
respawn_functions_defined = true;