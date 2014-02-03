#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};
private["_pass", "_mount", "_veh", "_vehclass", "_xpos", "_ypos", "_zpos", "_parachute", "_loop", "_lastPos"];

_pass = _this select 3;

_veh = _pass select 0;
_mount = _pass select 1;

//_veh = vehicle player;
_vehclass = toUpper(typeof _veh);

_xpos = (getPosATL _veh) select 0;
_ypos = (getPosATL _veh) select 1;
_zpos = (getPosATL _veh) select 2;

if ! _mount then {
	_veh removeAction (_veh getVariable [A_R_RAPPEL_V, -1]);
	player action ["getOut", _veh];
	waitUntil{(vehicle player) == player};
};

format ['%1 switchmove "Crew";', player] call broadcast;

_loop = true;
_lastPos = [0,0,0]; 
player setVelocity [0,0,-5];
while {_loop} do {
	if ((_lastPos distance (getPosATL player)) > 0.2) then {
			player setVelocity [0,0,-5];
			_lastPos = getPosATL player;
			
			SleepWait(0.1)
		}else{
			_loop = false;
			
			player setvelocity [0,0,0];
			format ['%1 switchmove "Stand";', player] call broadcast;
		};
};