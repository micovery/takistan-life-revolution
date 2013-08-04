private["_veh", "_vehclass", "_xpos", "_ypos", "_zpos", "_parachute"];

_veh = vehicle player;
_vehclass = toUpper(typeof _veh);

_xpos = (getPosATL _veh) select 0;
_ypos = (getPosATL _veh) select 1;
_zpos = (getPosATL _veh) select 2;

// Getout/Moveout?
/*
player action ["eject", _veh];

waitUntil {(vehicle player) iskindof "ParachuteBase"};
_parachute = vehicle player;
deletevehicle _parachute;
*/

_veh removeAction (_veh getVariable [A_R_RAPPEL_V, -1]);

player action ["getOut", _veh];

format ["%1 switchmove ""Crew"";", player] call broadcast;
waitUntil {((getPosATL player) select 2) <= 3};
player setvelocity [0,0,0];
	
player switchmove "Stand";