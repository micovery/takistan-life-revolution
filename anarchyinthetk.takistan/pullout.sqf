private["_target","_n","_exitvar","_i"];
_target = (crew _this) select 0;
_n 	= 10;
_exitvar = false;
if (locked _this) then {player groupChat "The car is locked. This might take a while."; _n = 16;};

if (!(isPlayer _target)) then {
		player groupChat format ["You're pulling out %1's AI. Stay close to the car!", leader _target];
	} else {
		player groupChat format ["You're pulling out %1. Stay close to the car!", _target];
	};
	
	
if (!(isPlayer _target)) then {
	} else {
		format['if(player == %1)then{player groupChat "%2 is pulling you out of the car!"}', _target, player] call broadcast;
	};


for [{_i=0}, {_i < _n}, {_i=_i+1}] do {if (player distance _target > 3) exitWith {player groupChat "You are too far away."; _exitvar = true;};sleep 0.3;};

if(_exitvar)exitwith{};

_this lock false;

player switchMove "AmovPercMstpSnonWnonDnon_AcrgPknlMstpSnonWnonDnon_getInLow";
sleep 0.4;
if (!(isPlayer _target)) then {
		_target action["eject", vehicle _target]
	} else {
		format['if(player == %2)then{player action["eject", vehicle player]}; server globalChat "%1 pulled %2 out of a car!";', player, _target] call broadcast;
	};

