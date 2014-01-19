private["_stunned","_restrained","_arrest","_exit"];
_stunned = [player, "isstunned"] call player_get_bool;
_restrained = [player, "restrained"] call player_get_bool;
_arrest = [player] call player_get_arrest;

_exit = false;

if(_stunned) exitwith {server globalChat "Cannot use headbug at this time";};
if(_restrained) exitwith {server globalChat "Cannot use headbug at this time";};
if(_arrest) exitwith {server globalChat "Cannot use headbug at this time";};

if(vehicle player != player) exitWith {hint "You must be on foot"};
titleCut ["","black faded", 0];

private["_pos","_dir","_vec","_vecs","_freeseats"];

_pos = position player;
_dir = direction player;
_vec = objNull;

_vecs = nearestObjects [getpos player, ["Car","Tank","Air","Ship"], 10];

if(count _vecs >0) then {
	_vec = _vecs select 0;
	_freeseats = _vec emptyPositions "cargo";
	if(_freeseats > 0) then {player moveincargo _vec};
};

if(vehicle player != player) exitWith {titleCut["", "BLACK in",2]};

player moveincargo headbugbus;
waitUntil {vehicle player != player};
unassignVehicle player;
player action ["Eject",vehicle player];
waitUntil {vehicle player == player};
player setpos _pos;
player setdir _dir;
titleCut["", "BLACK in",2];