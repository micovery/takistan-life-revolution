private["_veh", "_crew", "_mounted", "_target","_n","_exitvar","_i"];
_veh = _this;
_crew = crew _this;
_mounted = [];
_target = objNull;

_target = if ((count _crew) == 0) then {
	_mounted = [_veh] call mounted_get_occupants;
	_mounted select 0
}else{
	_crew select 0
};

_n 	= 10;
_exitvar = false;
if (locked _veh) then {player groupChat "The car is locked. This might take a while."; _n = 16;};

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

_veh lock false;

player switchMove "AmovPercMstpSnonWnonDnon_AcrgPknlMstpSnonWnonDnon_getInLow";
sleep 0.4;
if (!(isPlayer _target)) then {
	} else {
		if (_target in _crew) then {
			format['if(player == %2)then{player action["eject", vehicle player]}; server globalChat "%1 pulled %2 out of a vehicle!";', player, _target] call broadcast;
		}else{
			format['if(player == %2)then{[player] call mounted_unboard_slot_force}; server globalChat "%1 pulled %2 out of a car!";', player, _target] call broadcast;
		};
	};

