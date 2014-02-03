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

private["_pos","_dir"];
_pos = getPosATL player;
_dir = direction player;

private["_exit"];
_exit = false;
if (isNil "headbugbus") then {
		headbugbus = objNull;
	}else{
		if !(isNull headbugbus) then {
			_exit = true;
		};
	};
if _exit exitwith {
	server globalChat "HEADBUG ERROR";
	titleCut["", "BLACK in",2];
};
	
headbugbus = "Ikarus_TK_CIV_EP1" createVehicleLocal [-10,-10,0];

player moveincargo headbugbus;
waitUntil {(vehicle player) != player};

unassignVehicle player;
player action ["Eject",vehicle player];
waitUntil {(vehicle player) == player};

player setPosATL _pos;
player setDir _dir;

deleteVehicle headbugbus;

titleCut["", "BLACK in",2];